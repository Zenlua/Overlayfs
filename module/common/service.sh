# kakathic
MODP="${0%/*}"
magisk && PMSK="$(magisk --path)/.magisk/mirror"

# Check boot
while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 1
done
# end

# mount rw overlayfs
for TV in $(cat $MODP/partition); do
[ -e $MODP/zption/rw ] && mount -o rw,remount $TV
[ -e $MODP/zption/rw ] && mount -o rw,remount $PMSK$TV
done
