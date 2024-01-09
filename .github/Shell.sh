TOME="$GITHUB_WORKSPACE"

mkdir -p $TOME/Up

getmodun(){ grep -m1 "$1=" $TOME/module/module.prop | cut -d= -f2; }
upenv(){ echo "$1=$2" >> $GITHUB_ENV; }

cd $TOME/module

zip -r $TOME/Up/$(getmodun id)_$(getmodun version).zip *

upenv "V_$(getmodun version)"

echo '
{
"version": "'$(getmodun version)'",
"versionCode": "'$(getmodun versionCode)'",
"zipUrl": "kkkkkk",
"changelog": "kkkk"
}
' > $TOME/tmp2/overlay.json
