
## To rsync the boot partition:

rsync -av /boot/ /mnt/boot

## To rsync the root partition:

rsync -av --one-file-system / /mnt




