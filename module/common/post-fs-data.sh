# Kakathic

MKD="${0%/*}"
MKS="/mnt/overlayfs"

find $MKD -type d -empty -delete >/dev/null
mkdir -p "$MKS"
mount --bind "$MKD" "$MKS"

# tính năng
overlayfs_ro(){
    if [ -d "$MKS$1" ]; then
    busybox setfattr -n trusted.overlay.opaque -v y $MKD$1 2>/dev/null
    chcon -R "$(busybox ls -nZld "$1" | awk '{print $5}')" "$MKD$1"
    chmod -R 755 "$MKD$1"
    chown -R $(busybox ls -nZld "$1" | awk '{print $3":"$4}') "$MKD$1"
    mount -t overlay overlay -o "lowerdir=$MKS$1:$1" "$1" && echo "Mount RO: $1 done"
    fi
}

# run overlay
for vcl in $(cat $MKD/partition.txt | sort | uniq); do
    [ -d "$vcl" ] && overlayfs "$vcl" >> "$MKD/log.txt" 2>&1
done

umount -l "$MKS"
rm -fr "$MKS"
