# kakathic
MODP="${0%/*}"
#MSGP="$(magisk --path 2>/dev/null)/.magisk/mirror"

while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 1
done

for TV in $(getprop 'partition=' $MODP/module.prop | cut -d= -f2); do
magisk || overlayrw $TV
done
