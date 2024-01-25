# kakathic
MODP="${0%/*}"
rm -fr $MODP/log.txt
if [ "$(grep 'vipmount=' "$MODP/module.prop" | cut -d= -f2)" == 1 ];then
rm -fr "$MODP/skip_mount"
#mount -o bind /data/overlayfs/system "$MODP/system"
else
echo > "$MODP/skip_mount"
for TV in $(cat /data/overlayfs/tmp/partition); do
/data/overlayfs/system/product/bin/overlayrw "$TV" >> "$MODP/log.txt" 2>> "$MODP/log.txt"
done
fi
