# kakathic
MODP="${0%/*}"
PMSK="$(magisk --path)/.magisk/mirror"
su="su -M -c"
# start overlay_fs
for TV in $(cat $MODP/partition); do
if [ -e "$TV" ];then
[ -e $MODP/zption/chcon ] && chcon -Rh "$(ls -Z -d $TV | awk '{print $1}')" $MODP$TV
[ -e $MODP/zption/chmod ] && chmod -R 755 $MODP$TV
[ -e $MODP/zption/chown ] && chown -Rh 0:0 $MODP$TV 
[ -e $MODP/zption/rw ] && $su mount -t overlay kakathic -o upperdir=$MODP$TV,lowerdir=$TV,workdir=$MODP/zption/tmp1$TV $TV || $su mount -t overlay kakathic -o lowerdir=$MODP$TV:$TV $TV
[ -e $MODP/zption/rw ] && $su mount -t overlay kakathic -o upperdir=$MODP$TV,lowerdir=$PMSK$TV,workdir=$MODP/zption/tmp2$TV $PMSK$TV || $su mount -t overlay kakathic -o lowerdir=$MODP$TV:$PMSK$TV $PMSK$TV
fi
done
# end overlay_fs

# Check boot
while true; do
[ -e /sdcard/Android ] && break || sleep 1
done
# end
