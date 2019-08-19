#!/usr/bin/bash
ps -A -o comm,rss | grep chromium | cut -d ' ' -f9 | awk '{s+=$1} END {print sprintf("%.3f GB", s / 1000 / 1000)}'

