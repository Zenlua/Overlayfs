# Kakathic

MKD="${0%/*}"
MKS="/mnt/overlayfs"

if [ -d "$MKS" ]; then
echo "The $MKS folder is already mount, only use this command if it's not yet mount.!"
else
    if [ -d $MKD/overlay ] && [ "$(ls $MKD/overlay/*)" ]; then
        echo "Umount: $MKD/overlay"
        umount -l $MKD/overlay
        rm -fr $MKD/overlay
    else
        echo "Mount RW: $MKD/overlay"
        mkdir -p $MKD/overlay
        mount -w $MKD/overlayfs.img $MKD/overlay
    fi
fi

# Only use this command in Recovery, TWRP, or Fox
# Instructions on how to use it from the terminal command line screen.
# Import from: /data/adb/overlayfs/mount.sh
# Go to the /data/adb/overlayfs/overlay directory to delete or add files, making sure to grant full permissions when adding them.
