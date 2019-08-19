#!/usr/bin/bash
smem -P chromium -t -c uss | tail -1 | tr -d ' ' | awk '{} END {print sprintf("%.3f GB", $1 / 1000 / 1000)}'
# ps -A -o comm,rss | grep chromium | cut -d ' ' -f9 | awk '{s+=$1} END {print sprintf("%.3f GB", s / 1000 / 1000)}'

