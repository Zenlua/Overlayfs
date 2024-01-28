# kakathic
MODP="${0%/*}"
#MSGP="$(magisk --path 2>/dev/null)/.magisk/mirror"

# Anti-bootloop 120s
while true; do
bodem=$(($bodem + 1))
[ "$(getprop sys.boot_completed)" == 1 ] && break
[ "$bodem" -ge 120 ] && echo > $MODP/disable
[ "$bodem" -ge 120 ] && reboot
sleep 1
done

# log overlay
[ -e "$MODP/bind" ] && mount | grep 'rw.*.noauto_da_alloc.*.data=ordered' > $MODP/overlay.txt || mount -t overlay > $MODP/overlay.txt

echo "/data/overlayfs/$(getprop ro.build.version.incremental)" > /data/overlayfs/tmp/pathxt
