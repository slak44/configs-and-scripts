#!/bin/bash

user=$(whoami)

declare -A src2dest
src2dest["bash_profile"]="/home/$user/.bash_profile"
src2dest["bashrc"]="/home/$user/.bashrc"
src2dest["gen-ps1.sh"]="/home/$user/.gen-ps1.sh"
src2dest["vimrc"]="/home/$user/.vimrc"
src2dest["gitconfig"]="/home/$user/.gitconfig"
src2dest["eslintrc.json"]="/home/$user/.eslintrc.json"
src2dest["archey3.cfg"]="/home/$user/.archey3.cfg"
src2dest["config/konsolerc"]="/home/$user/.config/konsolerc"
src2dest["config/htop/htoprc"]="/home/$user/.config/htop/htoprc"
src2dest["config/parcellite/parcelliterc"]="/home/$user/.config/parcellite/parcelliterc"
src2dest["local/share/konsole/Shell.profile"]="/home/$user/.local/share/konsole/Shell.profile"
src2dest["local/share/konsole/DarkPastels.colorscheme"]="/home/$user/.local/share/konsole/DarkPastels.colorscheme"
src2dest["Scripts/regen-grub"]="/home/$user/Scripts/regen-grub"
src2dest["Scripts/mousealign"]="/home/$user/Scripts/mousealign"
src2dest["Scripts/mcserver"]="/home/$user/Scripts/mcserver"
src2dest["Scripts/img-to-bg"]="/home/$user/Scripts/img-to-bg"
src2dest["Scripts/git-lg"]="/home/$user/Scripts/git-lg"
src2dest["Scripts/git-cloc"]="/home/$user/Scripts/git-cloc"
src2dest["Scripts/fix-steam"]="/home/$user/Scripts/fix-steam"
src2dest["Scripts/cold-start-liferea"]="/home/$user/Scripts/cold-start-liferea"
src2dest["Scripts/check-cinnamon-ram"]="/home/$user/Scripts/check-cinnamon-ram"
src2dest["Scripts/backup"]="/home/$user/Scripts/backup"
src2dest["Scripts/js/share.js"]="/home/$user/Scripts/share"
src2dest["Scripts/js/share-file.js"]="/home/$user/Scripts/share-file"
src2dest["Scripts/js/cwd2mp3.js"]="/home/$user/Scripts/cwd2mp3"

for key in "${!src2dest[@]}"
do
  ln -s "/home/$user/Config/symlink-files/$key" "${src2dest[$key]}" || echo "File probably exists at ${src2dest[$key]}"
done
