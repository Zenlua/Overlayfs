# kakathic

# Để true để bỏ qua Mount system
SKIPMOUNT=true
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=true
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=true
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true
# đường dẫn 
MODP="/data/overlayfs"
TMPP="$MODP/tmp"

# getkey volume 
keyvolume(){ 
keyvl=''; keyvl=`getevent -qlc 1 | awk '{print $3}'`
if [ "$keyvl" == "KEY_VOLUMEDOWN" ] || [ "$keyvl" == "ABS_MT_TRACKING_ID" ];then
echo 1
elif [ "$keyvl" == "KEY_VOLUMEUP" ];then
echo 2
elif [ "$keyvl" == "KEY_POWER" ];then
echo 3
else
keyvolume
fi; }

# Giới thiệu
print_modname() {
ui_print " "
ui_print "  Name: $(grep_prop name $TMPDIR/module.prop), V$(grep_prop version $TMPDIR/module.prop), ($(grep_prop versionCode $TMPDIR/module.prop))"
ui_print " "
ui_print "  Author: $(grep_prop author $TMPDIR/module.prop)"
ui_print " "
}

# Bắt đầu cài đặt
on_install() {
ui_print "! Use volume keys to select"
ui_print "! Cancel, press power key"
ui_print " "
ui_print "- Touch or Volume key to continue ?"
getevent -qlc 1 >&2 && ui_print "  Check OK" || abort "! Check getevent failed"
sleep 0.5
ui_print " "
ui_print "- Select mode detect root path ?"
ui_print "  Vol+ Hidden Root"
ui_print "  Vol- Root"
ui_print " "

if [ "$(keyvolume)" == 1 ];then
ui_print "  Show the entire path root"
ui_print " "
sed -i 's|#||g' $TMPDIR/partition
elif [ "$(keyvolume)" == 2 ];then
ui_print "  Hide root checked path"
ui_print " "
sed -i '/#/d' $TMPDIR/partition
else
abort "! Canceled"
fi

sleep 0.5

ui_print "- Select system mount config ?"
ui_print "  Vol+ Mount Bind"
ui_print "  Vol- OverlayFS"
ui_print " "

if [ "$(keyvolume)" == 2 ];then
ui_print "  Create mount bind partition"
ui_print " "
for XZ in $(cat "$TMPDIR/partition"); do
sleep 0.2
[ -d "$XZ" ] && ui_print "  $XZ"
done
touch "$MODPATH/bind"
elif [ "$(keyvolume)" == 1 ];then
ui_print "  Create overlay fs partition"
ui_print " "
for XZ in $(cat "$TMPDIR/partition"); do
sleep 0.2
[ -d "$XZ" ] && ui_print "  $XZ"
done
else
abort "! Canceled"
fi

# Create partition
mkdir -p $TMPP
cp -rf $TMPDIR/overlayrw $TMPP
cp -rf $TMPDIR/busybox $TMPP
cp -rf $TMPDIR/partition $MODPATH
[ -e $TMPP/path ] || echo > $TMPP/path
ln -sf $MODP $MODPATH
ui_print " "
}

# Cấp quyền
set_permissions() { 
set_perm $TMPP/overlayrw 0 2000 0755 u:object_r:system_file:s0
set_perm $TMPP/busybox 0 2000 0755 u:object_r:system_file:s0
}
