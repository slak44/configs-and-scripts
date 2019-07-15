#!/bin/bash
rm -rf ~/.cache/jetbrains-toolbox/
mkdir -p ~/.cache/jetbrains-toolbox/
cd ~/.cache/jetbrains-toolbox/
/opt/jetbrains-toolbox/jetbrains-toolbox --appimage-extract
cd squashfs-root/
APPDIR=. ./AppRun "$@"

