# kakathic
MODP="${0%/*}"
rm -fr $MODP/log.txt
for TV in $(grep 'partition=' $MODP/module.prop | cut -d= -f2); do
/data/overlayfs/system/product/bin/overlayrw $TV >> $MODP/log.txt
done
