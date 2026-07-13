#!/system/bin/sh
# Kakathic

MKD="${0%/*}"

# Tính năng
overlayfs(){
if [ "$1" == "ro" ]; then
    mount -t overlay Kakathic -o "lowerdir=$MKD$2:$2" "$2" && echo "Mount RO: $2 done"
elif [ "$1" == "rw" ]; then
    mkdir -p "$MKD$2" "$MKD/tmp$2"
    busybox setfattr -n trusted.overlay.opaque -v y $MKD$2 2>/dev/null
    chcon -R "$(busybox ls -nZld "$2" | awk '{print $5}')" "$MKD$2"
    chmod -R 755 "$MKD$2"
    chown -R $(busybox ls -nZld "$2" | awk '{print $3":"$4}') "$MKD$2"
    mount -t overlay Kakathic -o "upperdir=$MKD$2,lowerdir=$2,workdir=$MKD/tmp$2" "$2" && echo "Mount RW: $2 done"
fi
}

# Anti-bootloop 600s
until [ "$(getprop sys.boot_completed)" = 1 ]; do
    bodem=$((bodem + 1))
    [ "$bodem" -ge 600 ] && echo > "$MKD/disable" && reboot
    sleep 1
done


# Run code
[ -f $MKD/log.txt ] && rm -fr $MKD/log.txt
grep -q 'checkrw=' $MKD/module.prop || echo 'checkrw=1' >> $MKD/module.prop

# Overlay
if grep -q 'checkrw=1' $MKD/module.prop; then
    for vcl in $(cat $MKD/partition.txt | sort | uniq); do
    [ -d "$vcl" ] && overlayfs rw "$vcl" >> "$MKD/log.txt" 2>&1
    done
fi

# Tạo log overlay
mount_ov="$(mount -t overlay)"
[ -z "$mount_ov" ] || echo "$mount_ov" > $MKD/overlay.txt
