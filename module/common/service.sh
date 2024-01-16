# kakathic
MODP="${0%/*}"
MSGP="$(magisk --path 2>/dev/null)/.magisk/mirror"

for TV in $(cat $MODP/partition); do
if [ ! -L $TV ];then
[ -e $MODP/zption/chcon ] && chcon -Rh "$(ls -Z -d $TV | awk '{print $1}')" $MODP$TV
[ -e $MODP/zption/chmod ] && chmod -R 755 $MODP$TV
[ -e $MODP/zption/chown ] && chown -Rh 0:0 $MODP$TV
fi
done

# Check boot
while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 1
done
sleep 5

# overlay fs
for TV in $(cat $MODP/partition); do
if [ ! -L $TV ];then
#mount -t overlay kakathic_ro -o lowerdir=$MODP$TV:$TV $TV
mount -t overlay kakathic -o upperdir=$MODP$TV,lowerdir=$TV,workdir=$MODP/zption/tmp$TV $TV
[ -e $MSGP/system ] && mount -t overlay magisk -o upperdir=$MODP$TV,lowerdir=$MSGP$TV,workdir=$MODP/zption/tmp2$TV $MSGP$TV
fi
done
