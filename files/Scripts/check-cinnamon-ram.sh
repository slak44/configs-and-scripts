#!/bin/bash

date > /tmp/ran-script

user=$(whoami)
CINNAMON_PROC_ID=$(ps aux | grep 'cinnamon --replace' | grep -E "$user\s+[0-9]+" -o | grep -E "[0-9]+" -o | head -1)

echo "Found cinnamon at: $CINNAMON_PROC_ID"

RSS_MEM_GB=$(cat /proc/$CINNAMON_PROC_ID/status | grep -E "VmRSS:\s+([0-9]+)" | grep -E "[0-9]+" -o | awk '{print $1/1000000}')

echo "Cinnamon is using $RSS_MEM_GB GB"

IS_MEM_MORE_THAN_1GB=$(echo "$RSS_MEM_GB > 1" | bc -l)

if [[ "$IS_MEM_MORE_THAN_1GB" == 1 ]] ; then
  echo "It's more than 1GB, notifying"
  notify-send "Cinnamon RAM warning"
else
  echo "It's less than 1GB, all is well"
fi

