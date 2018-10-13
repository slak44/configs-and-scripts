#!/bin/bash

curl -L https://github.com/slak44/htop-custom/releases/download/v2.2.0-3/htop-custom-2.2.0-3-x86_64.pkg.tar.xz -o htop-custom-2.2.0-3-x86_64.pkg.tar.xz
sudo pacman -U htop-custom-2.2.0-3-x86_64.pkg.tar.xz || exit 1
rm htop-custom-2.2.0-3-x86_64.pkg.tar.xz
