# kakathic
MODP="${0%/*}"
rm -fr $MODP/log.txt
[ "$(grep 'vipmount=' $MODP/module.prop | cut -d= -f2)" == 2 ] && echo > $MODP/skip_mount || rm -fr $MODP/skip_mount

for TV in $(grep 'partition=' $MODP/module.prop | cut -d= -f2); do
[ "$(grep 'vipmount=' $MODP/module.prop | cut -d= -f2)" == 2 ] && $MODP/system/product/bin/overlayrw $TV >> $MODP/log.txt
done
