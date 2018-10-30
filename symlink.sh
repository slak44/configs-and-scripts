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
src2dest["config/konsolerc"]="$HOME/.config/konsolerc"
src2dest["config/htop/htoprc"]="$HOME/.config/htop/htoprc"
src2dest["config/parcellite/parcelliterc"]="$HOME/.config/parcellite/parcelliterc"
src2dest["config/trizen/trizen.conf"]="$HOME/.config/trizen/trizen.conf"
src2dest["local/share/konsole/Shell.profile"]="$HOME/.local/share/konsole/Shell.profile"
src2dest["local/share/konsole/DarkPastels.colorscheme"]="$HOME/.local/share/konsole/DarkPastels.colorscheme"
src2dest["Scripts/regen-grub"]="$HOME/Scripts/regen-grub"
src2dest["Scripts/mousealign"]="$HOME/Scripts/mousealign"
src2dest["Scripts/mcserver"]="$HOME/Scripts/mcserver"
src2dest["Scripts/img-to-bg"]="$HOME/Scripts/img-to-bg"
src2dest["Scripts/git-lg"]="$HOME/Scripts/git-lg"
src2dest["Scripts/git-cloc"]="$HOME/Scripts/git-cloc"
src2dest["Scripts/fix-steam"]="$HOME/Scripts/fix-steam"
src2dest["Scripts/cold-start-liferea"]="$HOME/Scripts/cold-start-liferea"
src2dest["Scripts/check-cinnamon-ram"]="$HOME/Scripts/check-cinnamon-ram"
src2dest["Scripts/backup"]="$HOME/Scripts/backup"
src2dest["Scripts/purge-swap"]="$HOME/Scripts/purge-swap"
src2dest["Scripts/js/share.js"]="$HOME/Scripts/share"
src2dest["Scripts/js/share-file.js"]="$HOME/Scripts/share-file"
src2dest["Scripts/js/cwd2mp3.js"]="$HOME/Scripts/cwd2mp3"

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
