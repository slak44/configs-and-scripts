#!/bin/bash
for path in "$@"; do
  mkdir -p "$(dirname "$path")"/edited
  target_path=$(dirname "$path")/edited/$(basename "$path")
  echo "$path -> $target_path"

  main_resolution=$(xrandr | grep -oP 'primary \K\d+[x]\d+')
  full_resolution=$(xdpyinfo | grep -oP 'dimensions:\s+\K\S+')

  # 2560x1440 and 6400x1440
  convert "$path" -resize "$main_resolution" -gravity Center -background black -extent "$full_resolution" -format png "$target_path"
done
