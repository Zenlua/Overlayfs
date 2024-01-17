# kakathic
MODP="${0%/*}"

for TV in $(getprop 'partition=' $MODP/module.prop | cut -d= -f2); do
if [ ! -L $TV ] && [ -d $TV ];then
magisk && $MODP/product/bin/overlayrw $TV
fi
done
