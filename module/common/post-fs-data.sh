# Kakathic
MKD="${0%/*}"
[ -d $MKD/tmp ] && rm -fr $MKD/tmp
find $MKD -type d -empty -delete
