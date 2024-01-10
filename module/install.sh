# kakathic

# Để true để bỏ qua Mount system
SKIPMOUNT=true
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=false
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
ui_print "  Create folder"
ui_print
for KS1 in $(grep_prop partition $TMPDIR/module.prop); do
ui_print "  $KS1"
echo "$KS1" >> $MODPATH/partition
mkdir -p $MODPATH$KS1
setfattr -n trusted.overlay.opaque -v y $MODPATH$KS1
mkdir -p $MODPATH/zption/tmp$KS1
done
mkdir -p $MODPATH/work
ui_print
ui_print "  Create options"
[ "$(grep_prop rw $TMPDIR/module.prop)" == "true" ] && echo > $MODPATH/zption/rw
[ "$(grep_prop chmod $TMPDIR/module.prop)" == "true" ] && echo > $MODPATH/zption/chmod
[ "$(grep_prop chown $TMPDIR/module.prop)" == "true" ] && echo > $MODPATH/zption/chown
[ "$(grep_prop chcon $TMPDIR/module.prop)" == "true" ] && echo > $MODPATH/zption/chcon
# backup
if [ "$(grep_prop backup $TMPDIR/module.prop)" == "true" ] && [ -e "/data/adb/modules/overlayfs/skip_mount" ];then
ui_print
ui_print "  Start backup"
for KS3 in $(ls -d1 /data/adb/modules/overlayfs/*); do
[ -d "$KS3" ] && cp -acf $KS3 $MODPATH
done
fi
ui_print
ui_print "  Test overlayfs"
mkdir -p $MODPATH/test $MODPATH/test2
echo > $MODPATH/test/a123
/system/bin/mount -t overlay "kakathic" -o upperdir=$MODPATH/test,lowerdir=$MODPATH/test2,workdir=$MODPATH/work $MODPATH/test2
[ -e $MODPATH/test2/a123 ] && ui_print "  Success" || abort "  Failed"
/system/bin/umount $MODPATH/test2
rm -fr $MODPATH/test $MODPATH/test2 $MODPATH/work
ui_print
}

# Cấp quyền
set_permissions() { 
#set_perm_recursive $MODPATH 0 0 0755 0644
true
}
