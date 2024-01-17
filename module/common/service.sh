# kakathic
MODP="${0%/*}"
#MSGP="$(magisk --path 2>/dev/null)/.magisk/mirror"
while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 1
done
for vv in $list; do
overlayrw $vv
done
