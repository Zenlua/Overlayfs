# kakathic
MODP="${0%/*}"
rm -fr $MODP/log.txt
for TV in $(cat $MODP/partition); do
/data/overlayfs/system/product/bin/overlayrw $TV >> $MODP/log.txt
done
