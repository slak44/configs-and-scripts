#!/bin/bash
for path in "$@"; do
  mkdir -p "$(dirname "$path")"/edited
  target_path=`dirname "$path"`/edited/`basename "$path"`
  echo "$path -> $target_path"
  convert "$path" -resize 1920x1080 -gravity Center -background black -extent 5760x1080 -format png "$target_path"
done
