# kakathic

MODP="${0%/*}"
MOP="/data/overlayfs"
GPat="$(getprop ro.build.version.incremental)"
rm -fr $MODP/log.txt

if [ ! -e "$MOP/$GPat" ] && [ -e "$MODP/bind" ];then
[ -e $MOP/tmp/pathxt ] && rm -fr "$(cat $MOP/tmp/pathxt)"
mkdir -p "$MOP/$GPat"
fi

for TV in $(cat $MODP/partition $MOP/tmp/path); do
if [ -e "$MODP/bind" ];then
[ -d "$TV" ] && $MOP/tmp/overlayrw -bind "$TV" >> "$MODP/log.txt" 2>> "$MODP/log.txt"
else
[ -d "$TV" ] && $MOP/tmp/overlayrw -rw "$TV" >> "$MODP/log.txt" 2>> "$MODP/log.txt"
fi
done
