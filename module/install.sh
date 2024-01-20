# kakathic

# Để true để bỏ qua Mount system
SKIPMOUNT=true
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
ui_print "  Create partition"
ui_print " "
for TV in $(grep 'partition=' $TMPDIR/module.prop | cut -d= -f2); do
if [ -d $TV ];then
ui_print "  $TV"
echo "$TV" >> /data/overlayfs/tmp/partition
[ "$(grep -cm1 "$TV" /data/overlayfs/tmp/partition 2>/dev/null)" == 1 ] || echo "$TV" >> /data/overlayfs/tmp/partition
fi
done
Text="$(cat /data/overlayfs/tmp/partition | sort | uniq)"
echo "$Text" > tee /data/overlayfs/tmp/partition
mkdir -p /data/overlayfs/system/product/bin
cp -rf $TMPDIR/overlayrw /data/overlayfs/system/product/bin
ui_print " "
ui_print "  Save: /data/overlayfs"
ui_print " "
}

# Cấp quyền
set_permissions() { 
set_perm_recursive /data/overlayfs/system/product/bin 0 2000 0755 0755 u:object_r:system_file:s0
}

