# Kakathic

MKD="${0%/*}"
MKS="/mnt/overlayfs"

find $MKD -type d -empty -delete >/dev/null
mkdir -p "$MKS"
mount --bind "$MKD" "$MKS"

# tính năng
overlayfs_ro(){
    [ -d "$MKS$1" ] && mount -t overlay overlay -o "lowerdir=$MKS$1:$1" "$1" && echo "Mount RO: $1 done"
}

# run overlay
for vcl in $(cat $MKD/partition.txt | sort | uniq); do
    [ -d "$vcl" ] && overlayfs "$vcl" >> "$MKD/log.txt" 2>&1
done

umount -l "$MKS"
rm -fr "$MKS"
