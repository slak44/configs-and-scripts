import java.io.File
import java.nio.file.Files
import kotlin.math.abs

//val smem: Process = ProcessBuilder("sudo", "smem", "-H", "-s", "uss", "-c", "uss pid user command", "-a")
//    .redirectOutput(ProcessBuilder.Redirect.PIPE)
//    .start()
//smem.waitFor()

data class MemEntry(
    val uss: Int,
    val pid: Int,
    val user: String,
    val comm: String
)

sealed class ProcFilter {
  abstract val desc: String
  abstract val test: (entry: MemEntry) -> Boolean

  operator fun plus(other: ProcFilter): ProcFilter {
    return Generic("$desc, ${other.desc}") { test(it) || other.test(it) }
  }

  operator fun times(other: ProcFilter): ProcFilter {
    return Generic("$desc, ${other.desc}") { test(it) && other.test(it) }
  }

  data class Generic(override val desc: String, override val test: (entry: MemEntry) -> Boolean) : ProcFilter()

  data class Name(val name: String) : ProcFilter() {
    override val desc = "name: $name"
    override val test = { it: MemEntry -> name in it.comm }
  }

  data class User(val user: String) : ProcFilter() {
    override val desc = "user: $user"
    override val test = { it: MemEntry -> it.user in user }
  }

  data class Size(override val desc: String, val sizeTest: (Int) -> Boolean) : ProcFilter() {
    override val test = { it: MemEntry -> sizeTest(it.uss) }
  }

  data class Pid(override val desc: String, val pidTest: (Int) -> Boolean) : ProcFilter() {
    override val test = { it: MemEntry -> pidTest(it.pid) }
  }

  object MatchNone : ProcFilter() {
    override val desc = "NONE"
    override val test = { _: MemEntry -> false }
  }

  object MatchAll : ProcFilter() {
    override val desc = "ALL"
    override val test = { _: MemEntry -> true }
  }
}

fun nameFilter(vararg name: String): ProcFilter {
  return name.map { ProcFilter.Name(it) }.reduce(ProcFilter::plus)
}

sealed class ProcRule {
  abstract val desc: String

  data class Filter(val filter: ProcFilter, val mergeSubtree: Boolean, val crossTree: Boolean) : ProcRule() {
    override val desc = filter.desc
  }

  data class Merge(val rules: List<Filter>) : ProcRule() {
    override val desc = rules.joinToString(", ") { it.filter.desc }
  }
}

fun merge(vararg rules: ProcRule.Filter) = ProcRule.Merge(rules.toList())

data class ResultItem(val entries: List<MemEntry>, val rule: ProcRule?) {
  val totalUss = entries.sumBy { it.uss }

  fun join(other: ResultItem): ResultItem {
    require(rule == other.rule)
    return ResultItem(entries + other.entries, rule)
  }

  override fun toString() = "$totalUss kB, by $rule: $entries"
}

//val entries = smem.inputStream.bufferedReader().readLines().map(String::trim).map { line ->
//  val items = line.split(' ').filter { it.isNotBlank() }
//  MemEntry(items[0].toInt(), items[1].toInt(), items[2], items.drop(3).joinToString(" "))
//}.associateBy { it.pid }

fun readPidChildren(pid: Int): List<Int> {
  val tasks = File("/proc/$pid/task").listFiles()!!
  val childrenFiles = tasks.map { File(it, "children") }
  return childrenFiles.flatMap { it.readText().trim().split(' ').filter(String::isNotEmpty).map(String::toInt) }
}

val tree = mutableMapOf<Int, List<Int>>()

fun readProc(pid: Int): MemEntry {
  val base = File("/proc/$pid")
  val pss = File(base, "smaps").readLines().asSequence()
      .map { it.trim() }
      .filter { it.startsWith("Pss") }
      .map { it.split(":") }
      .filter { it.size >= 2 }
      .map { it[1].trim().split(" ")[0].trim().toInt() }
      .sum()
  val command = File(base, "cmdline").readText().replace('\u0000', ' ')
  val user = Files.getOwner(base.toPath()).name
  return MemEntry(pss, pid, user, command)
}

val entries = mutableMapOf<Int, MemEntry>()

val allProcesses = File("/proc").list()!!.filter { it[0].isDigit() }.map(String::toInt)
for (pid in allProcesses) {
  tree[pid] = readPidChildren(pid)
  entries[pid] = readProc(pid)
}

val rules = listOf(
    ProcRule.Filter(nameFilter("chromium"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(
        nameFilter("cinnamon", "nemo-desktop", "system-config-print"), mergeSubtree = false, crossTree = true),
    ProcRule.Filter(nameFilter("konsole"), mergeSubtree = false, crossTree = true),
    ProcRule.Filter(nameFilter("akregator"), mergeSubtree = true, crossTree = true),
    ProcRule.Filter(nameFilter("Discord"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(nameFilter("slack"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(nameFilter("teams"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(nameFilter("postgres"), mergeSubtree = false, crossTree = true),
    ProcRule.Filter(nameFilter("docker"), mergeSubtree = false, crossTree = true),
    ProcRule.Filter(nameFilter("steam.sh"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(nameFilter("scripts/idea", "IDEA-U"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(nameFilter("scripts/idea", "WebStorm"), mergeSubtree = true, crossTree = false),
    ProcRule.Filter(nameFilter("jetbrains-toolbox"), mergeSubtree = true, crossTree = true),
    ProcRule.Filter(nameFilter("Xorg"), mergeSubtree = false, crossTree = false),
    merge(
        ProcRule.Filter(nameFilter("dhcpcd"), mergeSubtree = true, crossTree = false),
        ProcRule.Filter(nameFilter("gvfs"), mergeSubtree = true, crossTree = true),
        ProcRule.Filter(nameFilter("systemd"), mergeSubtree = false, crossTree = true),
        ProcRule.Filter(nameFilter("pulseaudio"), mergeSubtree = true, crossTree = false),
        ProcRule.Filter(ProcFilter.Pid("children of init") { it in tree.getValue(1) }, mergeSubtree = false, crossTree = true)
    ),
    merge(
        ProcRule.Filter(ProcFilter.Size("size: <5MB") { it < 5_000 }, mergeSubtree = false, crossTree = true),
        ProcRule.Filter(ProcFilter.Size("size: <20MB") { it < 20_000 }, mergeSubtree = false, crossTree = true)
    ),
    ProcRule.Filter(nameFilter("mem-usage"), mergeSubtree = false, crossTree = false)
)

val outputs = mutableListOf<ResultItem>()

fun resultOf(pid: Int, rule: ProcRule?): ResultItem = ResultItem(listOf(entries.getValue(pid)), rule)

fun subtreeTotal(pid: Int, rule: ProcRule): ResultItem {
  val children = tree.getValue(pid)
  val self = resultOf(pid, rule)
  return if (children.isEmpty()) {
    self
  } else {
    children.fold(self) { r, it -> r.join(subtreeTotal(it, rule)) }
  }
}

val filterRules = rules.flatMap {
  when (it) {
    is ProcRule.Filter -> listOf(it)
    is ProcRule.Merge -> it.rules
  }
}

fun bfs(pids: List<Int>) {
  val recurseOn = pids.toMutableSet()
  for (pid in pids) {
    val rule = filterRules.firstOrNull { it.filter.test(entries.getValue(pid)) }
    if (rule == null) {
      outputs += resultOf(pid, null)
      continue
    }
    if (rule.mergeSubtree) {
      val total = subtreeTotal(pid, rule)
      if (total.entries.size > 1) {
        println("Merged subtree of PID $pid (${total.entries.size} entries) on ${rule.filter}")
      }
      outputs += total
      recurseOn -= total.entries.map(MemEntry::pid)
    } else {
      outputs += resultOf(pid, rule)
    }
  }
  val nextLevel = recurseOn.flatMap { tree.getValue(it) }
  if (nextLevel.isNotEmpty()) {
    bfs(nextLevel)
  }
}

bfs(listOf(1))

val fromSmem = entries.values.sumBy { it.uss }
val tracked = outputs.sumBy { it.totalUss }

// 50MB diff allowed
if (abs(fromSmem - tracked) > 50 * 1000) {
  println("Values differ: smem $fromSmem, tracked: $tracked")
  println("Processes: " + (entries.values.map(MemEntry::pid) - outputs.flatMap { it.entries.map(MemEntry::pid) }))
}

val (withCrossTree, rest) = outputs.partition { (it.rule as? ProcRule.Filter)?.crossTree ?: false }

val grouped = withCrossTree.groupBy { it.rule }

val outputCross = rest.toMutableList()

for (rule in filterRules.filter { it.crossTree }) {
  if (rule in grouped) {
    val merged = grouped.getValue(rule).reduce(ResultItem::join)
    println("Merged cross-tree ${merged.entries.size} entries on ${rule.filter}")
    outputCross += merged
  }
}

val outputMerged = mutableListOf<ResultItem>()

for (merger in rules.filterIsInstance<ProcRule.Merge>()) {
  val toMerge = outputCross.filter { it.rule in merger.rules }
  outputCross -= toMerge
  val merged = toMerge.map { it.copy(rule = merger) }.reduce(ResultItem::join)
  outputMerged += merged
}

outputMerged += outputCross

// From https://stackoverflow.com/questions/3758606/how-to-convert-byte-size-into-human-readable-format-in-java
fun formatBytes(valueBytes: Long): String {
  var bytes = valueBytes
  if (-1000 < bytes && bytes < 1000) {
    return "$bytes B"
  }
  var ci = "kMGTPE".toList()
  while (bytes <= -999950 || bytes >= 999950) {
    bytes /= 1000
    ci = ci.drop(1)
  }
  return "%.1f ${ci[0]}B".format(bytes / 1000.0)
}

println(outputMerged.sortedByDescending { it.totalUss }.joinToString("\n"))

println()
println(outputMerged.sortedByDescending { it.totalUss }.joinToString("\n") {
  "${formatBytes(it.totalUss.toLong() * 1000)}, by ${it.rule?.desc ?: it.entries[0].comm}"
})
