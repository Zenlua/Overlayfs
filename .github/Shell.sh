TOME="$GITHUB_WORKSPACE"

mkdir -p $TOME/Up $TOME/tmp2

getmodun(){ grep -m1 "$1=" $TOME/module/module.prop | cut -d= -f2; }
upenv(){ echo "$1=$2" >> $GITHUB_ENV; eval "$1=$2"; }

cd $TOME/module

zip -r $TOME/Up/$(getmodun id)_$(getmodun version).zip *
upenv VER "V$(getmodun version)"
upenv VUR "$(getmodun version)"
upenv VSR "$(getmodun versionCode)"
upenv VIR "$(getmodun id)"
cat $TOME/module/log.md | sed -n "/#### $VER/,/####/P" | sed "/#/d" | sed '1d' | sed '$d' >$TOME/log.txt

echo '
{
"version": "'$VUR'",
"versionCode": "'$VSR'",
"zipUrl": "https://github.com/Zenlua/Overlayfs/releases/download/'$VER'/'${VIR}_${VUR}'.zip",
"changelog": "https://raw.githubusercontent.com/Zenlua/Overlayfs/main/module/log.md"
}
' > $TOME/tmp2/overlay.json
