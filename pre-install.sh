#!/bin/sh

backup_dir="/mnt/backups"
if [ ! -d "$backup_dir" ]; then
    echo "Backup dir not found: $backup_dir"
    exit 1
fi

if [ ! -s /tmp/firmware.bin ]; then
    echo "Firmware not found or empty: /tmp/firmware.bin"
    exit 1
fi

umask 022
touch /etc/timestamp

stamp="$(date +'%FT%H%M')"

sysupgrade --create-backup "${backup_dir}/backup-${stamp}.tgz" || exit 2
echo "Created local backup ${backup_dir}/backup-${stamp}.tgz"

cp "/tmp/firmware.bin" "${backup_dir}/firmware-${stamp}.bin" || exit 3
echo "Copied image to ${backup_dir}/firmware-${stamp}.bin"

if command -v owut >/dev/null 2>&1; then
    owut_file="${backup_dir}/owut-list-${stamp}.txt"
    owut list > "$owut_file" || exit 4
    if [ -s "$owut_file" ]; then
        echo "Saved OWUT list to $owut_file"
    else
        echo "Owut list not found or empty: $owut_file"
        exit 4
    fi
fi

if [ -x /root/bin/listpackages ]; then
    /root/bin/listpackages
    if [ -f /tmp/my-user-installed-packages ]; then
        cp "/tmp/my-user-installed-packages" "${backup_dir}/list-add-package-${stamp}.txt" || exit 5
        echo "Created local backup ${backup_dir}/list-add-package-${stamp}.txt"
    fi
fi

exit 0
