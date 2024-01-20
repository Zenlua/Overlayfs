# kakathic
MODP="${0%/*}"
rm -fr $MODP/log.txt
for TV in $(cat $MODP/partition); do
[ "$(grep 'vipmount=' $MODP/module.prop | cut -d= -f2)" == 1 ] || /data/overlayfs/system/product/bin/overlayrw $TV >> $MODP/log.txt
done
