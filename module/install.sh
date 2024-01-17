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
ui_print
ui_print "  Name: $(grep_prop name $TMPDIR/module.prop), $(grep_prop version $TMPDIR/module.prop), $(grep_prop author $TMPDIR/module.prop)"
}

# Bắt đầu cài đặt
on_install() {
ui_print
ui_print "  Create overlayrw"
ui_print
mkdir -p $MODPATH/system/bin
cp -rf $TMPDIR/overlayrw $MODPATH/system/bin
ui_print "  Start backup"
for KS3 in $(ls -d1 /data/adb/modules/overlayfs/*); do
[ -d "$KS3" ] && cp -acf $KS3 $MODPATH
done
ui_print
}

# Cấp quyền
set_permissions() { 
set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
}
