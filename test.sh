User="User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.114 Safari/537.36"
Xem () { curl -s -G -L -N -H "$User" --connect-timeout 20 "$1"; }
Taive () { curl -s -L -N -H "$User" --connect-timeout 20 "$1" -o "$2"; }

ukl="https://dumps.tadiphone.dev/dumps/xiaomi/fuxi/-/raw/missi_phone_global-user-14-UKQ1.230705.002-V14.0.5.0.UMCMIXM-release-keys"
mkdir -p Up
 
Taive "$ukl/product/app/MIUIFrequentPhrase/MIUIFrequentPhrase.apk?inline=false" MIUIFrequentPhrase.apk
java -jar apktool_2.9.0.jar d -s -f MIUIFrequentPhrase.apk -o App
cp -rf App/res/string-vi Up

