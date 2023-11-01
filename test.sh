(
while true; do
if [ "$(gh issue view 14 | grep -cm1 CLOSED)" == 1 ];then
gh run cancel $GITHUB_RUN_ID
else
sleep 1
echo 1
fi
done
) & (
sleep 1000
)
