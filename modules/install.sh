# Kakathic

# Để true để bỏ qua Mount system
SKIPMOUNT=true
# Để true nó sẽ kết hợp system.prop vào build.prop
PROPFILE=false
# Để true post-fs-data.sh được sử dụng
POSTFSDATA=true
# Để true để service.sh được sử dụng
LATESTARTSERVICE=true
# home overlay folder
HOVELAY="/data/adb/overlayfs"
yunly="$HOVELAY/overlayfs.img"
MKS="/mnt/overlayfs"

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
ui_print "  Start checking the overlay, bind..."
ui_print " "

# tạo thư mục test
mkdir -p $MODPATH/system/app $MODPATH/system/xbin

# check
if  [ "$(grep -cm1 "overlay" /proc/filesystems)" == 1 ] && [ ! -f $HOVELAY/bind ]; then
    ui_print "  Success: overlay"
    echo overlay >$MODPATH/type
else
    mount --bind $MODPATH/system/app /system/app
    touch /system/app/kakathic
    if [ -f /system/app/kakathic ]; then
    umount -l /system/app 2>/dev/null
    rm -fr $MODPATH/system
    ui_print "  Success: bind"
    echo bind >$MODPATH/type
    else
    abort "  Mount overlay, bind failed, your device cannot use this module."
    fi
fi
ui_print " "

# Sao chép list
mkdir -p "$HOVELAY"
[ -f "$HOVELAY/partition.txt" ] || cp -rf $TMPDIR/partition.txt "$HOVELAY"

# tính toán kích cỡ
if [ "$(cat $MODPATH/type)" == "bind" ]; then
    ui_print "  Calculating the size needed to create..."
    ui_print " "
    total_mb=$(while read -r dir; do [ -d "$dir" ] && du -sk "$dir"; done < $HOVELAY/partition.txt | awk '{total += $1} END {printf "%d", total / 1024}')
    size_mb="$((total_mb + 5120))"
    ui_print "  Size: $(awk -v t="$total_mb" 'BEGIN {printf "%.2fGB\n", (t / 1024) + 5}')"
    ui_print " "
else
    size_mb="4096"
    ui_print "  Size: 4GB"
    ui_print " "
fi

# tính năng tạo img ext4
Taoext4(){
ui_print "  Created: ext4"
if ! fallocate -l "${size_mb}M" "$1" 2>/dev/null; then
    truncate -s "${size_mb}M" "$1" || abort "  Overlayfs.img creation failed."
fi
mkfs.ext4 "$1" >/dev/null 2>&1 || abort "  Formatting overlayfs.img failed."
ui_print " "
}

# tạo kho ext4
if [ -f "$yunly" ]; then
    ui_print "  Already available"
    ui_print " "
else
    Taoext4 "$yunly"
fi

# list partition
if [ "$(cat $MODPATH/type)" == "bind" ]; then
    mkdir -p $HOVELAY/overlay
    versionos="$(getprop ro.build.version.incremental)"
    # check phiên bản
    if [ -f $HOVELAY/versionos ]; then
        if [ "$(cat $HOVELAY/versionos)" == "$versionos" ]; then
        for vc in $(cat "$HOVELAY/partition.txt"); do
            ui_print "  List RW: $vc"
            if [ ! -f "$MKS$vc" ]; then
            mkdir -p "$MKS${vc%/*}"
            toybox cp -Rd --preserve=all "$vc" "$MKS$vc"
            fi
        done
        else
        ui_print "  Warning: A different ROM version or a ROM update has been detected. All modified files from the previous version will be deleted after reboot. Please recover any necessary files now. To do this: navigate to '/data/adb/overlayfs/overlay' to retrieve your previously changed files and move them out of that directory. After rebooting, the 'overlay_new.img' file will replace 'overlayfs.img', and all old files will disappear."
        ui_print " "
        Taoext4 $HOVELAY/overlay_new.img
        mkdir -p $HOVELAY/overlay_new
        mount -w "$HOVELAY/overlayfs.img" $HOVELAY/overlay
        mount -w "$HOVELAY/overlay_new.img" $HOVELAY/overlay_new
        for vc in $(cat "$HOVELAY/partition.txt"); do
            ui_print "  List RW: $vc"
            mkdir -p "$HOVELAY/overlay_new${vc%/*}"
            toybox cp -Rd --preserve=all "$vc" "$HOVELAY/overlay_new$vc"
        done
        echo "$versionos" > $HOVELAY/versionos_new
        fi
    else
    # mount & copy file
    mount -w "$yunly" $HOVELAY/overlay
    for vc in $(cat "$HOVELAY/partition.txt"); do
        ui_print "  List RW: $vc"
        mkdir -p "$HOVELAY/overlay${vc%/*}"
        toybox cp -Rd --preserve=all "$vc" "$HOVELAY/overlay$vc"
    done
    echo "$versionos" > $HOVELAY/versionos
    fi
else
    for vc in $(cat "$HOVELAY/partition.txt"); do
        ui_print "  List RW: $vc"
        sleep 0.01
    done
fi

# copy system.prop
[ -f $HOVELAY/system.prop ] || cp -rf $TMPDIR/system.prop $HOVELAY

# Create partition
cp -rf $TMPDIR/action.sh $MODPATH
cp -rf $TMPDIR/mount.sh "$HOVELAY"

# end
ui_print " "
}

# Cấp quyền
set_permissions() {
    chmod 755 "$HOVELAY/mount.sh"
}
