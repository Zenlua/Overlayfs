# kakathic

# Để true để bỏ qua Mount system
[ "$(magisk --path)" ] && SKIPMOUNT=true || SKIPMOUNT=false
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=true
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=true
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true

# Giới thiệu
print_modname() {
ui_print
ui_print "  Name: $(grep_prop name $TMPDIR/module.prop), $(grep_prop version $TMPDIR/module.prop), $(grep_prop author $TMPDIR/module.prop)"
}

# Bắt đầu cài đặt
on_install() {
ui_print
ui_print "  Create overlayrw"
ui_print
for TV in $(grep 'partition=' $TMPDIR/module.prop | cut -d= -f2); do
ui_print "  $TV"
done
ui_print
mkdir -p $MODPATH/product/bin
cp -rf $TMPDIR/overlayrw $MODPATH/product/bin
if [ "$(grep_prop backup $TMPDIR/module.prop)" == "true" ] && [ -e "/data/adb/modules/overlayfs/skip_mount" ];then
ui_print "  Start backup"
rm -fr /data/adb/modules/overlayfs/zoption
for KS3 in $(ls -d1 /data/adb/modules/overlayfs/*); do
[ -d "$KS3" ] && cp -acf $KS3 $MODPATH
done
ui_print
fi
}

# Cấp quyền
set_permissions() { 
set_perm_recursive $MODPATH/product/bin 0 0 0755 0755
}
