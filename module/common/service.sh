#!/system/bin/sh
# Kakathic

MKD="${0%/*}"

# Tính năng
set_mdul(){ sed -i "/^$1=/c $1=$2" $MKD/module.prop; }

overlayfs(){
if [ "$1" == "ro" ]; then
    mount -t overlay Kakathic -o "lowerdir=$MKD$2:$2" "$2" && echo "Mount RO: $2 done"
elif [ "$1" == "rw" ]; then
    mkdir -p "$MKD$2" "$MKD/tmp$2"
    busybox setfattr -n trusted.overlay.opaque -v y $MKD$2 2>/dev/null
    chcon -R "$(busybox ls -nZld "$2" | awk '{print $5}')" "$MKD$2"
    chmod -R 755 "$MKD$2"
    chown -R $(busybox ls -nZld "$2" | awk '{print $3":"$4}') "$MKD$2"
    mount -t overlay Kakathic -o "upperdir=$MKD$2,lowerdir=$2,workdir=$MKD/tmp$2" "$2" && echo "Mount RW: $2 done"
fi
}

# Anti-bootloop feature using volume keys with LED lights
until [ "$(getprop sys.boot_completed)" = 1 ]; do
  get_key="$(getevent -qlc1)"
  if echo "$get_key" | grep -q KEY_VOLUMEDOWN; then
  # Turn off the current module.
    check_up=0
    check_dow=$((check_dow + 1))
    echo 255 > /sys/class/leds/flashlight/brightness
    sleep 0.3
    echo 0 > /sys/class/leds/flashlight/brightness
    if [ "$check_dow" -ge 5 ]; then
      touch $MKD/disable
      reboot
    fi
  elif echo "$get_key" | grep -q KEY_VOLUMEUP; then
  # Turn off all modules
    check_dow=0
    check_up=$((check_up + 1))
    echo 255 > /sys/class/leds/flashlight/brightness
    sleep 0.3
    echo 0 > /sys/class/leds/flashlight/brightness
    if [ "$check_up" -ge 5 ]; then
      for vv in /data/adb/modules/*; do
      [ -d "$vv" ] && touch "$vv/disable"
      done
      reboot
    fi
  elif echo "$get_key" | grep -q KEY_POWER; then
  # Turn the lights on and off
    check_pow=$((check_pow + 1))
      if [ "$check_pow" == 1 ]; then
        echo 255 > /sys/class/leds/flashlight/brightness
      else
        echo 0 > /sys/class/leds/flashlight/brightness
        check_pow=0
      fi
    sleep 0.3
  fi
done

# Ép tắt đèn pin
echo 0 > /sys/class/leds/flashlight/brightness

# Run code
[ -f $MKD/log.txt ] && rm -fr $MKD/log.txt
grep -q 'checkrw=' $MKD/module.prop || echo 'checkrw=1' >> $MKD/module.prop

# Overlay
if grep -q 'checkrw=1' $MKD/module.prop; then
    for vcl in $(cat $MKD/partition.txt | sort | uniq); do
    [ -d "$vcl" ] && overlayfs rw "$vcl" >> "$MKD/log.txt" 2>&1
    done
    # Tạo log overlay
    error_rw="Error: This device does not support overlay RW 🛑"
    mount_ov="$(mount -t overlay)"
    if [ "$mount_ov" ]; then
        echo "$mount_ov" > $MKD/overlay.txt
        if grep -q Kakathic $MKD/overlay.txt; then
            set_mdul description "Current status: RW 📝, file editable. After editing, restart to apply system changes."
        else
            set_mdul description "$error_rw"
        fi
    else
        set_mdul description "$error_rw"
        rm -f $MKD/overlay.txt
    fi
fi

