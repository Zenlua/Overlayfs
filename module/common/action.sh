#!/system/bin/sh
# Kakathic

MKD="${0%/*}"

# Xoá log cũ
[ -f $MKD/log.txt ] && rm -fr $MKD/log.txt

# Tính năng
set_mdul(){ sed -i "/^$1=/c $1=$2" $MKD/module.prop; }
overlayfs(){
if [ "$1" == "ro" ]; then
    umount -l "$2" && echo "Umount: $2 done"
elif [ "$1" == "rw" ]; then
    mkdir -p "$MKD$2" "$MKD/tmp$2"
    busybox setfattr -n trusted.overlay.opaque -v y $MKD$2 2>/dev/null
    chcon -R "$(busybox ls -nZld "$2" | awk '{print $5}')" "$MKD$2"
    chmod -R 755 "$MKD$2"
    chown -R $(busybox ls -nZld "$2" | awk '{print $3":"$4}') "$MKD$2"
    mount -t overlay Kakathic -o "upperdir=$MKD$2,lowerdir=$2,workdir=$MKD/tmp$2" "$2" && echo "Mount RW: $2 done"
fi
}

# run code
if grep -q 'checkrw=1' $MKD/module.prop; then
    text_ro="Current status: RO 💤, currently unable to edit files, old files remain unchanged."
    echo "$text_ro"
    set_mdul checkrw 0
    set_mdul description "$text_ro"
    for vcl in $(cat $MKD/partition.txt | sort | uniq); do
    [ -d "$vcl" ] && overlayfs ro "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
    done
    find $MKD -type d -empty -delete >/dev/null
else
    text_rw="Current status: RW 📝, file editable. After editing, restart to apply system changes."
    echo "$text_rw"
    set_mdul checkrw 1
    set_mdul description "$text_rw"
    for vcl in $(cat $MKD/partition.txt | sort | uniq); do
    [ -d "$vcl" ] && overlayfs rw "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
    done
fi

# Tạo log overlay
mount_ov="$(mount -t overlay)"
[ -z "$mount_ov" ] || echo "$mount_ov" > $MKD/overlay.txt

# End sleep delay 1s, fix bug ksu
sleep 1
exit 0
