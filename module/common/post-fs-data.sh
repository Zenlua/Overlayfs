# kakathic
MODP="${0%/*}"
magisk && PMSK="$(magisk --path)/.magisk/mirror"

# start overlay_fs
for TV in $(cat $MODP/partition); do
[ -e $MODP/zption/chcon ] && chcon -Rh "$(ls -Z -d $TV | awk '{print $1}')" $MODP$TV
[ -e $MODP/zption/chmod ] && chmod -R 755 $MODP$TV
[ -e $MODP/zption/chown ] && chown -Rh 0:0 $MODP$TV
if [ -e $MODP/zption/rw ];then
mount -t overlay kakathic -o upperdir=$MODP$TV,lowerdir=$TV,workdir=$MODP/zption/tmp1$TV $TV
magisk && mount -t overlay kakathic -o upperdir=$MODP$TV,lowerdir=$PMSK$TV,workdir=$MODP/zption/tmp2$TV $PMSK$TV
else
mount -t overlay kakathic -o lowerdir=$MODP$TV:$TV $TV
magisk && mount -t overlay kakathic -o lowerdir=$MODP$TV:$PMSK$TV $PMSK$TV
fi
done
# end overlay_fs
