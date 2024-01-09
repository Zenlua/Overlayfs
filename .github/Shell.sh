TOME="$GITHUB_WORKSPACE"

mkdir -p $TOME/Up

getmodun(){ grep -m1 "$1=" $TOME/module/module.prop | cut -d= -f2; }

cd $TOME/module

zip -r $TOME/Up/$(getmodun id)_$(getmodun version).zip *
