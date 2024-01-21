# kakathic
MODP="${0%/*}"
rm -fr $MODP/log.txt
for TV in $(cat /data/overlayfs/tmp/partition); do
if [ "$(grep 'vipmount=' "$MODP/module.prop" | cut -d= -f2)" == 1 ];then
/data/overlayfs/system/product/bin/overlayrw -ro "$TV" >> "$MODP/log.txt" 2>> "$MODP/log.txt"
else
/data/overlayfs/system/product/bin/overlayrw "$TV" >> "$MODP/log.txt" 2>> "$MODP/log.txt"
fi
done
