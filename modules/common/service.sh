#!/system/bin/sh
# Kakathic

MKD="${0%/*}"
# Anti-bootloop 600s
until [ "$(getprop sys.boot_completed)" = 1 ]; do
    bodem=$((bodem + 1))
    [ "$bodem" -ge 600 ] && echo > "$MKD/disable" && reboot
    sleep 1
done
