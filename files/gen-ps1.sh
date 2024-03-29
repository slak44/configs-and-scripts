#!/bin/bash
isGoodTerminal=$([[ ${IS_DECENT_TERMINAL} == 'true' ]] && echo true)
noFiraCode=$([[ ! ${isGoodTerminal} ]] && echo true)
hasTrueColor=$([[ "$(echo $1 | head -c 1)" = "-" ]] && echo "false" || echo "true")

isRoot=$([[ $EUID -eq 0 ]] && echo true)

base=$([[ "$hasTrueColor" = "true" ]] && echo "\[\033[38;2;0;231;255m\]" || echo "\[\033[38;2;0;0;175m\]")
accent=$([[ "$hasTrueColor" = "true" ]] && echo "\[\033[38;2;255;132;42m\]" || echo "\[\033[38;2;255;119;0m\]")
white="\[\033[38;2;255;255;255m\]"
reset="\[\033[0m\]"
user=$([[ ${isRoot} ]] && echo "$white" || echo "$base")

sep=$([[ ${noFiraCode} ]] && echo "$accent>" || echo -e "$accent\356\202\261")
branchIcon=$([[ ${noFiraCode} ]] && echo "${white}branch " || echo -e "${white}\356\202\240")

declare -a upstream
declare -a branchAB
while read line; do
  case "$line" in
    "# branch.head"*) branch=$(awk '{ print $3 }' <<< "$line") ;;
    "# branch.upstream"*) mapfile -t upstream < <(awk '{ sub(/[\/]/, " "); print $3 "\n" $4 }' <<< "$line") ;;
    "# branch.ab"*) mapfile -t branchAB < <(awk '{ gsub(/+|-/, " "); print $3 "\n" $4 }' <<< "$line") ;;
    *) changed=$([[ ${line::1} == "1" || ${line::1} == 2 || ${line::1} == "?" ]] && echo "true" || echo '') ;;
  esac
done <<< "$(git status --branch --porcelain=v2 2> /dev/null)"

simpleBranchText="${branchIcon}${reset}${branch} $sep "
localBranchText=$([[ ${upstream[0]} ]] && echo "${reset}local $simpleBranchText" || echo "$simpleBranchText")
upstreamBranchText=$([[ ${upstream[0]} ]] && echo "${reset}remote ${branchIcon}${reset}${upstream[1]} from ${base}${upstream[0]}${reset} $sep " || echo '')
branchText=$([[ ${branch} ]] && echo "$localBranchText$upstreamBranchText" || echo '')
if [[ ${branchAB[0]} -ne 0 ]]; then
  pluralCommits=$([[ ${branchAB[0]} -eq 1 ]] && echo "commit" || echo "commits")
  ahead="${base}${branchAB[0]}${reset} ${pluralCommits} ${white}ahead ${sep} "
fi
if [[ ${branchAB[1]} -ne 0 ]]; then
  pluralCommits=$([[ ${branchAB[1]} -eq 1 ]] && echo "commit" || echo "commits")
  behind="${base}${branchAB[1]}${reset} ${pluralCommits} ${white}behind ${sep} "
fi
workingTreeDirty=$([[ ${changed} ]] && echo "${reset}working tree ${base}dirty ${sep} " || echo '')

commitsAndWorktreeText="${ahead}${behind}${workingTreeDirty}"

function removeExtraStuffLength() {
  hexLetters=$(echo -ne "$1" | sed 's/\x1B\[[0-9;]\+[A-Za-z]//g' | xxd -p -c 999 | sed "s/5c5b5c5d//g" | wc -m)
  echo $((hexLetters / 4))
}

pwdLen=$(pwd | wc -m)
preludeMaxLen=$((25 + pwdLen))
totalLength=$(tput cols)
freeSpace=$((totalLength - preludeMaxLen))
branchTextLength=$(removeExtraStuffLength "$branchText")
commitsAndWorktreeLength=$(removeExtraStuffLength "$commitsAndWorktreeText")

spaceLeftForCmd=$((freeSpace - branchTextLength - commitsAndWorktreeLength))
shouldPutCmdOnNext=$([[ $((spaceLeftForCmd < totalLength / 2)) == "1" ]] && echo "true" || echo '')

firstLineLen=$((preludeMaxLen + branchTextLength + commitsAndWorktreeLength + 30))

# Print anyway
echo -n "$sep $user\u$accent@$base\h $sep $base\w $sep ${branchText}"

if [[ $((firstLineLen >= totalLength)) == "1" ]]; then
  # Put newline, and separator for next line
  echo
  echo -n "$sep "
fi
echo "${reset}${commitsAndWorktreeText}${reset}"

[[ ${shouldPutCmdOnNext} ]] && echo "$sep ${reset}command $sep ${reset}"
