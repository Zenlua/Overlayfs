# Kakathic

# Để true để bỏ qua Mount system
SKIPMOUNT=false
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=false
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=true
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true

# patch home
HOMEOV="/data/adb/modules/overlayfs"

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

# tạo thư mục mount
#mkdir -p $MODPATH/system/app $MODPATH/tmp/system/app

# test mount
#mount -t overlay Kakathic -o "upperdir=$MODPATH/system/app,lowerdir=/system/app,workdir=$MODPATH/tmp/system/app" "/system/app"
#touch /system/app/kakathic

# check
if  grep -q "overlay" /proc/filesystems; then
    ui_print "  Success"
else
    abort "  Mount overlay failed, your device cannot use this module."
fi

# umount
#umount -l /system/app 2>/dev/null
#rm -fr $MODPATH/system $MODPATH/tmp
ui_print " "

# Create partition
cp -rf $TMPDIR/action.sh $MODPATH
cp -rf $TMPDIR/system.prop $MODPATH
cp -rf $TMPDIR/partition.txt $MODPATH

# backup
[ -f $HOMEOV/partition.txt ] && cp -rf $HOMEOV/partition.txt $MODPATH
[ -f $HOMEOV/system.prop ] && cp -rf $HOMEOV/system.prop $MODPATH
for vc in $HOMEOV/*; do
[ -d "$vc" ] && cp -acf "$vc" $MODPATH
done

# list partition
for vc in $(cat "$MODPATH/partition.txt"); do
ui_print "  List RW: $vc"
sleep 0.01
done

ui_print " "
}

# Cấp quyền
set_permissions() {
true
}
