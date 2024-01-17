# kakathic
MODP="${0%/*}"

magisk && cp -rf $MODP/system/bin/* $MODP
magisk && rm -fr $MODP/system

for TV in $(getprop 'partition=' $MODP/module.prop | cut -d= -f2); do
magisk && $MODP/overlayrw $TV
done
