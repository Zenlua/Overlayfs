# kakathic
MODP="${0%/*}"

# start overlay_fs
for TV in $(cat $MODP/partition); do
if [ ! -L $TV ];then
[ -e $MODP/zption/chcon ] && chcon -Rh "$(ls -Z -d $TV | awk '{print $1}')" $MODP$TV
[ -e $MODP/zption/chmod ] && chmod -R 755 $MODP$TV
[ -e $MODP/zption/chown ] && chown -Rh 0:0 $MODP$TV
[ -e $MODP/zption/rw ] && mount -t overlay kakathic -o upperdir=$MODP$TV,lowerdir=$TV,workdir=$MODP/zption/tmp$TV $TV || mount -t overlay kakathic -o lowerdir=$MODP$TV:$TV $TV
fi
done
# end overlay_fs
