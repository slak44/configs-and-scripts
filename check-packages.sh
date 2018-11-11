#!/bin/bash

# Basic non-X stuff
basicPackageList=(
  sudo git nodejs npm nano vim java-runtime-common htop
  rsync tokei imagemagick grub ffmpeg)
# Basic X stuff
basicVisualPackageList=(
  cinnamon
  xorg-xinput xdg-utils libnotify wmctrl konsole chromium parcellite
  gthumb gimp redshift deepin-screenshot file-roller gedit)
# Non-essential non-X stuff
extraPackageList=(
  make ninja cmake archey3 unrar transmission-cli arp-scan otf-fira-code pigz
  iotop radeontop)
# Non-essential X stuff
extraVisualPackageList=(
  libreoffice-still lollypop transmission-gtk gparted liferea
  steam steam-native-runtime)
aurPackages=(trizen discord atom-editor-bin jetbrains-toolbox)

echo "Install basic packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) sudo pacman -S --needed "${basicPackageList[@]}"; break;;
    "No" ) break;;
  esac
done

echo "Install extra packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) sudo pacman -S --needed "${extraPackageList[@]}"; break;;
    "No" ) break;;
  esac
done

echo "Install basic visual packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) sudo pacman -S --needed "${basicVisualPackageList[@]}"; break;;
    "No" ) break;;
  esac
done

echo "Install extra visual packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) sudo pacman -S --needed "${extraVisualPackageList[@]}"; break;;
    "No" ) break;;
  esac
done

echo "Install aur packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) trizen -S --needed "${aurPackages[@]}"; break;;
    "No" ) break;;
  esac
done

