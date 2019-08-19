#!/bin/bash

if [ ! -d $HOME ]; then
  echo "Home directory doesn't exist or \$HOME variable not set"
  exit 1
fi

declare -A src2dest
src2dest["bash_profile"]="$HOME/.bash_profile"
src2dest["bashrc"]="$HOME/.bashrc"
src2dest["gen-ps1.sh"]="$HOME/.gen-ps1.sh"
src2dest["vimrc"]="$HOME/.vimrc"
src2dest["eslintrc.json"]="$HOME/.eslintrc.json"
src2dest["archey3.cfg"]="$HOME/.archey3.cfg"
src2dest["config/htop/htoprc"]="$HOME/.config/htop/htoprc"
src2dest["config/parcellite/parcelliterc"]="$HOME/.config/parcellite/parcelliterc"
src2dest["config/trizen/trizen.conf"]="$HOME/.config/trizen/trizen.conf"
src2dest["config/octave/qt-settings"]="$HOME/.config/octave/qt-settings"
src2dest["local/share/konsole/Shell.profile"]="$HOME/.local/share/konsole/Shell.profile"
src2dest["local/share/konsole/DarkPastels.colorscheme"]="$HOME/.local/share/konsole/DarkPastels.colorscheme"
src2dest["local/share/rom.dic"]="$HOME/.local/share/rom.dic"
src2dest["Scripts/run-toolbox.sh"]="$HOME/Scripts/run-toolbox"
src2dest["Scripts/regen-grub.sh"]="$HOME/Scripts/regen-grub"
src2dest["Scripts/mousealign.sh"]="$HOME/Scripts/mousealign"
src2dest["Scripts/mcserver.sh"]="$HOME/Scripts/mcserver"
src2dest["Scripts/img-to-bg.sh"]="$HOME/Scripts/img-to-bg"
src2dest["Scripts/git-lg.sh"]="$HOME/Scripts/git-lg"
src2dest["Scripts/git-cloc.sh"]="$HOME/Scripts/git-cloc"
src2dest["Scripts/fix-steam.sh"]="$HOME/Scripts/fix-steam"
src2dest["Scripts/cold-start-liferea.sh"]="$HOME/Scripts/cold-start-liferea"
src2dest["Scripts/check-cinnamon-ram.sh"]="$HOME/Scripts/check-cinnamon-ram"
src2dest["Scripts/backup.sh"]="$HOME/Scripts/backup"
src2dest["Scripts/purge-swap.sh"]="$HOME/Scripts/purge-swap"
src2dest["Scripts/print-chromium-uss.sh"]="$HOME/Scripts/print-chromium-uss"
src2dest["Scripts/js/share.js"]="$HOME/Scripts/share"
src2dest["Scripts/js/share-file.js"]="$HOME/Scripts/share-file"
src2dest["Scripts/js/cwd2mp3.js"]="$HOME/Scripts/cwd2mp3"
src2dest["Scripts/hwmon-perms.sh"]="$HOME/Scripts/hwmon-perms"
src2dest["Scripts/try-cycle-swap.sh"]="$HOME/Scripts/try-cycle-swap"

dir=$(dirname "$0")
for key in "${!src2dest[@]}"
do
  [ -L "${src2dest[$key]}" ] && rm "${src2dest[$key]}"
  mkdir -p "$(dirname ${src2dest[$key]})"
  if [ -f "${src2dest[$key]}" ]; then
    echo "File exists at ${src2dest[$key]}. Remove?"
    select yn in "Yes" "No"; do
      case $yn in
        "Yes" )
          mkdir -p "/tmp/backups/${src2dest[$key]}"
          mv "${src2dest[$key]}" "/tmp/backups/${src2dest[$key]}"
          break;;
        "No" ) break;;
      esac
    done
  fi
  ln -sr "$dir/files/$key" "${src2dest[$key]}" || echo "File probably still exists at ${src2dest[$key]}"
done
