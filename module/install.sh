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
# list partition
for vc in $(cat "$TMPDIR/partition.txt"); do
echo "  Overlayfs: $vc"
sleep 0.01
done
# Create partition
cp -rf $TMPDIR/partition.txt $MODPATH
cp -rf $TMPDIR/action.sh $MODPATH
ui_print " "
}

# Cấp quyền
set_permissions() {
true
}
