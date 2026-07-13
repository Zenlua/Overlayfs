# Kakathic

# Để true để bỏ qua Mount system
SKIPMOUNT=false
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=true
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=true
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true

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

ui_print "  Start checking the overlay..."
ui_print " "

# test mount
mkdir -p $MODPATH/system/app $MODPATH/tmp/system/app
mount -t overlay Kakathic -o "upperdir=$MODPATH/system/app,lowerdir=/system/app,workdir=$MODPATH/tmp/system/app" "/system/app"
touch /system/app/kakathic

# check
if [ -f /system/app/kakathic ]; then
    ui_print "  Success"
    rm /system/app/kakathic
else
    umount -l /system/app 2>/dev/null
    abort "  Mount overlay failed, your device cannot use this module."
fi

# umount
umount -l /system/app 2>/dev/null
rm -fr $MODPATH/system $MODPATH/tmp
ui_print " "

# list partition
for vc in $(cat "$TMPDIR/partition.txt"); do
ui_print "  Overlayfs: $vc"
sleep 0.01
done
# Create partition
cp -rf $TMPDIR/action.sh $MODPATH
if [ ! -f /data/adb/modules/overlayfs/partition.txt ]; then
cp -rf $TMPDIR/partition.txt $MODPATH
fi
ui_print " "
}

# Cấp quyền
set_permissions() {
true
}
