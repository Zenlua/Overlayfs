# kakathic
MODP="${0%/*}"

# Check boot
while true; do
[ "$(getprop sys.boot_completed)" == 1 ] && break || sleep 1
done
# end
