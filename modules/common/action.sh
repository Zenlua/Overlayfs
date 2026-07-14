#!/system/bin/sh
# Kakathic

MKD="${0%/*}"
MKS="/mnt/overlayfs"
HOVELAY="/data/adb/overlayfs"

# Tính năng
set_mdul(){ sed -i "/^$1=/c $1=$2" $MKD/module.prop; }
overlayfs(){
if [ "$1" == "ro" ]; then
    umount -l "$2" && echo "Umount: $2 done"
    find $MKS$2 -type d -empty -delete >/dev/null
    [ -d "$MKS$2" ] && mount -t overlay Kakathic -o "lowerdir=$MKS$2:$2" "$2" && echo "Mount RO: $2 done"
elif [ "$1" == "rw" ]; then
    mkdir -p "$MKS$2" "$MKS/tmp$2"
    busybox setfattr -n trusted.overlay.opaque -v y $MKS$2 2>/dev/null
    chcon -R "$(busybox ls -nZld "$2" | awk '{print $5}')" "$MKS$2" 2>/dev/null
    chmod -R 755 "$MKS$2" 2>/dev/null
    chown -R $(busybox ls -nZld "$2" | awk '{print $3":"$4}') "$MKS$2" 2>/dev/null
    mount -t overlay Kakathic -o "upperdir=$MKS$2,lowerdir=$2,workdir=$MKS/tmp$2" "$2" && echo "Mount RW: $2 done"
    restorecon -R $2 2>/dev/null
fi
}

# Ngăn cản khi chưa khởi động lại
if ! grep -q 'checkrw=' $MKD/module.prop; then
    echo "Restart your device to use this feature !"
    sleep 2
    exit
fi

if [ "$(cat $MKD/type)" == "bind" ]; then
    echo "While in mount --bind mode, it cannot switch to another state; it will always remain in rw mode !"
    sleep 2
    exit
fi

# Dọn dẹp
[ -f $MKD/log.txt ] && rm -fr $MKD/log.txt

# run code
if grep -q 'checkrw=1' $MKD/module.prop; then
    text_ro="Current status: RO 💤, currently unable to edit files, old files remain unchanged."
    echo "$text_ro"
    set_mdul checkrw 0
    set_mdul description "$text_ro"
    for vcl in $(cat "$HOVELAY/partition.txt" | sort | uniq); do
    [ -d "$vcl" ] && overlayfs ro "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
    done
else
    text_rw="Current status: RW 📝, file editable. After editing, restart to apply system changes."
    echo "$text_rw"
    set_mdul checkrw 1
    set_mdul description "$text_rw"
    for vcl in $(cat "$HOVELAY/partition.txt" | sort | uniq); do
    [ -d "$vcl" ] && overlayfs rw "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
    done
fi

# Tạo log overlay
mount_ov="$(mount -t overlay)"
if [ "$mount_ov" ]; then
    echo "$mount_ov" > $MKD/overlay.txt
    rm $MKD/overlay.txt
fi

# End sleep delay 1s, fix bug ksu
sleep 1
exit 0
