# Kakathic

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
    umount -l "$2" && echo "Umount: $2 done"
elif [ "$1" == "rw" ];then
    mount -t overlay Kakathic -o "upperdir=$MKD$2,lowerdir=$2,workdir=$MKD/tmp$2" "$2" && echo "Mount RW: $2 done"
fi
}

[ -f $MKD/log.txt ] && rm -fr $MKD/log.txt
if grep -q 'checkrw=1' $MKD/module.prop; then
echo -e "Changing state: RO\n\nIn this state, it is not possible to edit system files. "
sed -i '/^checkrw=/c\checkrw=0' $MKD/module.prop
sed -i '/^description=/c\description=Status: RO ❌' $MKD/module.prop
for vcl in $(cat $MKD/partition.txt | sort | uniq); do
[ -d "$vcl" ] && overlayrw ro "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
done
else
echo -e "Changing state: RW\n\nIn this state, system files can be edited. "
sed -i '/^checkrw=/c\checkrw=1' $MKD/module.prop
sed -i '/^description=/c\description=Status: RW ✅' $MKD/module.prop
for vcl in $(cat $MKD/partition.txt | sort | uniq); do
[ -d "$vcl" ] && overlayrw rw "$vcl" >> "$MKD/log.txt" 2>> "$MKD/log.txt"
done
fi

sleep 1
exit 0
