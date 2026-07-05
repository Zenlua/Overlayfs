# Kakathic

#MSGP="$(magisk --path 2>/dev/null)/.magisk/mirror"
#MDS="/data/adb/modules_update/overlayfs"
MKD="${0%/*}"

overlayrw(){
if [ -e "$2" ];then
    mkdir -p "$MKD$2"
    [ "$1" == "rw" ] && mkdir -p "$MKD/tmp$2"
    busybox setfattr -n trusted.overlay.opaque -v y $MKD$2 2>/dev/null
    chcon "$(busybox ls -nZld "$2" | awk '{print $5}')" "$MKD$2"
    chmod 755 "$MKD$2"
    chown $(busybox ls -nZld "$2" | awk '{print $3":"$4}') "$MKD$2"
fi
if [ "$1" == "ro" ];then
    mount -t overlay Kakathic -o "lowerdir=$MKD$2:$2" "$2" && echo "Mount RO: $2 done"
elif [ "$1" == "rw" ];then
    mount -t overlay Kakathic -o "upperdir=$MKD$2,lowerdir=$2,workdir=$MKD/tmp$2" "$2" && echo "Mount RW: $2 done"
fi
}

# Anti-bootloop 600s
while true; do
bodem=$(($bodem + 1))
[ "$(getprop sys.boot_completed)" == 1 ] && break
if [ "$bodem" -ge 600 ]; then
echo > $MKD/disable
reboot
fi
sleep 1
done

# Run code
[ -f $MKD/log.txt ] && rm -fr $MKD/log.txt
grep -q 'checkrw=' $MKD/module.prop || echo 'checkrw=1' >> $MKD/module.prop

if grep -q 'checkrw=1' $MKD/module.prop; then
for vcl in $(cat $MKD/partition.txt | sort | uniq); do
[ -d "$vcl" ] && overlayrw rw "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
done
fi

# log overlay
mount -t overlay > $MKD/overlay.txt
