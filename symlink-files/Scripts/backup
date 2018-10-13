#!/bin/bash
BUILD_TAR=$1
TARGET_TO_BACKUP="/"
BACKUP_ARCHIVE_DIR="/mnt/data/backup"
BACKUP_ARCHIVE_NAME="backup-$(date +%F).tar.gz"
BACKUP_RSYNC_DIR="/mnt/data/backup/rsync"
COMPRESSION_UTIL="pigz -p 5 -3"
sudo ionice -c 3 rsync -aAXhcP --backup --backup-dir="$BACKUP_RSYNC_DIR" \
--exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/root","/lost+found","/opt/*","/var/tmp","/var/cache","/var/run","/var/log",\
"/home/*/.thumbnails/*","/home/*/.cache/chromium/*","/home/*/.local/share/Trash/*","/home/*/.gvfs","/home/*/.config/Atom/Cache","/home/*/.cache",\
"/home/*/.config/chromium/*/GPUCache/","/home/slak/VirtualBox VMs/*","/opt/arch32","/etc/lvm/cache/*","/var/lib/colord/.cache/*","/**/__pycache__/"} $TARGET_TO_BACKUP $BACKUP_RSYNC_DIR

function create-backup-tar {
  sudo ionice -c 3 tar --acls --xattrs --totals --use-compress-program="$COMPRESSION_UTIL" -cf "$BACKUP_ARCHIVE_DIR/$BACKUP_ARCHIVE_NAME" $BACKUP_RSYNC_DIR
  sudo rm "$BACKUP_ARCHIVE_DIR/latest"
  sudo ln -sr "$BACKUP_ARCHIVE_DIR/$BACKUP_ARCHIVE_NAME" "$BACKUP_ARCHIVE_DIR/latest"
}

function ask-about-tar {
  echo "Continue with tar?"
  select yn in "Yes" "No"; do
    case $yn in
      "Yes" ) create-backup-tar; break;;
      "No" ) break;;
    esac
  done
}

case $BUILD_TAR in
  "yes" | "y" | "1" | "true" )
    create-backup-tar
    exit;;
  "no" | "n" | "0" | "false" )
    exit;;
  * )
    ask-about-tar
    exit;;
esac
