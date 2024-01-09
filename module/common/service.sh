# kakathic
MODP="${0%/*}"
PMSK="$(magisk --path)/.magisk/mirror"

# Check boot
while true; do
[ -e /sdcard/Android ] && break || sleep 1
done
# end
