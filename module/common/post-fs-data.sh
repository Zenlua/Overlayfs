# kakathic
MODP="${0%/*}"

for TV in $(getprop 'partition=' $MODP/module.prop | cut -d= -f2); do
magisk && $MODP/overlayrw $TV
done
