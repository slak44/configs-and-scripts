#!/bin/bash

totalMemBytes=$(free | grep Mem | tr -s ' ' | cut -d ' ' -f2)
availMemBytes=$(free | grep Mem | tr -s ' ' | cut -d ' ' -f7)
totalSwapBytes=$(free | grep Swap | tr -s ' ' | cut -d ' ' -f2)
usedSwapBytes=$(free | grep Swap | tr -s ' ' | cut -d ' ' -f3)

function percent() {
  echo $(($1 * 100 / $2))
}

memAvailPercent=$(percent $availMemBytes $totalMemBytes)
swapUsePercent=$(percent $usedSwapBytes $totalSwapBytes)

# If less than 2% of memory is available, we need the swap, so don't cycle it
# (Memory is size is roughly equal to swap size, and 2% of that is roughly 325MB)
if [[ $memAvailPercent -le 2 ]]; then
  echo "Swap required due to low memory ($memAvailPercent% available)"
  exit 0
fi

# If less than 2% of swap is used, it is probably benign usage of swap
if [[ $swapUsePercent -le 2 ]]; then
  echo "Swap mostly empty ($swapUsePercent% used), cycle ineffective"
  exit 0
fi

echo "Turning swap off..."
swapoff -a || exit 1
echo "Turning swap back on..."
swapon -a || exit 2
echo "Done!"
