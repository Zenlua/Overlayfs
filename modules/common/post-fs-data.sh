#!/system/bin/sh
# Kakathic

MKD="${0%/*}"
MKS="/mnt/overlayfs"
HOVELAY="/data/adb/overlayfs"
yunly="$HOVELAY/overlayfs.img"

# Tính năng
set_mdul(){ sed -i "/^$1=/c $1=$2" $MKD/module.prop; }
overlayfs(){
if [ "$1" == "rw" ] || [ "$1" == "bind" ]; then
    mkdir -p "$MKS$2" "$MKS/tmp$2"
    [ "$1" == "rw" ] && busybox setfattr -n trusted.overlay.opaque -v y $MKS$2 2>/dev/null
    chcon "$(busybox ls -nZld "$2" | awk '{print $5}')" "$MKS$2" 2>/dev/null
    chmod 755 "$MKS$2" 2>/dev/null
    chown $(busybox ls -nZld "$2" | awk '{print $3":"$4}') "$MKS$2" 2>/dev/null
fi
if [ "$1" == "ro" ]; then
    # Dọn thư mục trống
    find $MKS$2 -type d -empty -delete >/dev/null
    [ -d "$MKS$2" ] && mount -t overlay Kakathic -o "lowerdir=$MKS$2:$2" "$2" && echo "Mount RO: $2 done"
elif [ "$1" == "rw" ]; then
    mount -t overlay Kakathic -o "upperdir=$MKS$2,lowerdir=$2,workdir=$MKS/tmp$2" "$2" && echo "Mount RW: $2 done"
    restorecon -R $2 2>/dev/null
elif [ "$1" == "bind" ]; then
    mount --bind "$MKS$2" "$2" && echo "Mount RW: $2 done"
    restorecon -R $2 2>/dev/null
fi
}

# Dọn dẹp
umount -l $HOVELAY/overlay 2>/dev/null
umount -l $HOVELAY/overlay_new 2>/dev/null
rm -fr $MKD/log.txt $HOVELAY/overlay $HOVELAY/overlay_new

# thay thế
if [ -f $HOVELAY/overlay_new.img ]; then
    # di chuyển file mới
    mv $HOVELAY/overlay_new.img $yunly
    mv $HOVELAY/versionos_new $HOVELAY/versionos
fi

# check version
if [ -f $HOVELAY/versionos ]; then
    versionos="$(getprop ro.build.version.incremental)"
    if [ "$(cat $HOVELAY/versionos)" != "$versionos" ]; then
    set_mdul description "Status: Inactive 🚧, Reason: ROM version mismatch, please reinstall this module to update the ROM version in the file."
    echo -n > $MKD/disable
    exit 1
    fi
fi

# mount rw ext4
if [ -f "$yunly" ]; then
    mkdir -p "$MKS"
    mount -w "$yunly" "$MKS"
else
    echo "The ext4 archive file is not found." > "$MKD/log.txt"
    exit 1
fi

# dọn block trống
busybox fstrim "$MKS"

# check tồn tại
grep -q 'checkrw=' $MKD/module.prop || echo 'checkrw=1' >> $MKD/module.prop

# xác định rw/ro
if grep -q 'checkrw=1' $MKD/module.prop; then
    checkrw="rw"
else
    checkrw="ro"
fi

# Run code
if [ -f "$HOVELAY/partition.txt" ]; then
    if [ "$(cat $MKD/type)" == "bind" ]; then
    for vcl in $(cat "$HOVELAY/partition.txt" | sort | uniq); do
    [ -d "$vcl" ] && overlayfs bind "$vcl" >> "$MKD/log.txt" 2>&1
    done
    set_mdul description "Current state: RW 📝, mount --bind mode, cannot switch to another state."
    else
    for vcl in $(cat "$HOVELAY/partition.txt" | sort | uniq); do
    [ -d "$vcl" ] && overlayfs $checkrw "$vcl" >> "$MKD/log.txt" 2>&1
    done
    set_mdul description "Current status: RW 📝, file editable. After editing, restart to apply system changes."
    fi
else
    echo "List not found: partition.txt" > "$MKD/log.txt"
    exit 1
fi

# Tạo log overlay, bind
if [ "$(cat $MKD/type)" == "bind" ]; then
mount_ov="$(mount | grep "$MKS")"
if [ "$mount_ov" ]; then
    echo "$mount_ov" > $MKD/bind.txt
    mount | grep "$(echo "$mount_ov" | awk '{print $1}')" >> $MKD/bind.txt
fi
else
mount_ov="$(mount -t overlay)"
[ -z "$mount_ov" ] || echo "$mount_ov" > $MKD/overlay.txt
fi
