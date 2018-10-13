#!/bin/bash

# Dependencies for symlink-files
packageList=(sudo git nodejs npm xdg-utils arp-scan nano konsole chromium java-runtime-common xorg-xinput archey3 otf-fira-code
  vim htop parcellite rsync pigz libnotify steam steam-native-runtime tokei imagemagick grub)
aurPackages=(trizen)
# Soft dependencies
optPackages=(make ninja liferea archey3 unrar)
# Not dependencies for symlink-files
extraPackages=(gimp redshift discord gthumb cmake intellij-idea-community-edition deepin-screenshot file-roller
  libreoffice-still lollypop gedit transmission-cli transmission-gtk)

sudo pacman -S --needed "${packageList[@]}"

echo "Install aur packages?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) trizen -S --needed "${aurPackages[@]}"; break;;
    "No" ) break;;
  esac
done

echo "Install optionals?"
select yn in "Yes" "No"; do
  case $yn in
    "Yes" ) sudo pacman -S --needed "${optPackages[@]}"; break;;
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