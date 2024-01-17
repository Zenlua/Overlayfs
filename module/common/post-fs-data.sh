# kakathic
MODP="${0%/*}"
for TV in $(cat $MODP/partition); do
if [ ! -L $TV ];then
[ -e $MODP/zption/chcon ] && chcon -Rh "$(ls -Z -d $TV | awk '{print $1}')" $MODP$TV
[ -e $MODP/zption/chmod ] && chmod -R 755 $MODP$TV
[ -e $MODP/zption/chown ] && chown -Rh 0:0 $MODP$TV
fi
done
