GITENV(){ echo "$1=$2" >> $GITHUB_ENV; }


GITENV kk 123

echo $kk
