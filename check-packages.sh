#!/bin/bash

# Dependencies for symlink-files
packageList=(sudo git nodejs npm xdg-utils arp-scan nano konsole chromium java-runtime-common xorg-xinput otf-fira-code
  vim htop parcellite rsync pigz libnotify steam steam-native-runtime tokei imagemagick grub wmctrl ffmpeg)
# Not dependencies for symlink-files
extraPackages=(make ninja liferea archey3 unrar gimp redshift gthumb cmake intellij-idea-community-edition deepin-screenshot file-roller
  libreoffice-still lollypop gedit transmission-cli transmission-gtk gparted)
aurPackages=(trizen discord)

sudo pacman -S --needed "${packageList[@]}"

echo "Install aur packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) trizen -S --needed "${aurPackages[@]}"; break;;
    "No" ) break;;
  esac
done

echo "Install extra packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) sudo pacman -S --needed "${extraPackages[@]}"; break;;
    "No" ) break;;
  esac
done
