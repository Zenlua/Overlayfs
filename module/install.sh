# kakathic

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
ui_print "  Name: $(grep_prop name $TMPDIR/module.prop), $(grep_prop version $TMPDIR/module.prop), $(grep_prop author $TMPDIR/module.prop)"
}

# Bắt đầu cài đặt
on_install() {
ui_print " "
ui_print "  Create overlayrw"
ui_print " "
for TV in $(grep 'partition=' $TMPDIR/module.prop | cut -d= -f2); do
if [ -d $TV ];then
ui_print "  $TV"
fi
done
ui_print " "
mkdir -p $MODPATH/system/product/bin
cp -rf $TMPDIR/overlayrw $MODPATH/system/product/bin
[ "$(magisk --path)" ] && sed -i "s|vipmount=1|vipmount=1|g" $TMPDIR/module.prop
if [ "$(grep_prop backup $TMPDIR/module.prop)" == "true" ] && [ -e "/data/adb/modules/overlayfs/service.sh" ];then
ui_print "  Start backup"
rm -fr /data/adb/modules/overlayfs/zoption
rm -fr /data/adb/modules/overlayfs/system/product/bin/overlayrw
for KS3 in $(ls -d /data/adb/modules/overlayfs/*); do
[ -d "$KS3" ] && cp -acf $KS3 $MODPATH
done
ui_print " "
fi
}

# Cấp quyền
set_permissions() { 
set_perm_recursive $MODPATH/system/product/bin 0 0 0755 0755 u:object_r:system_file:s0
}

