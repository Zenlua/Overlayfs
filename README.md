# OverlayFS RW

[![Build module](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml/badge.svg)](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml)

+ Update: [Release](https://github.com/Zenlua/Overlayfs/releases) | [Changelog](./module/log.md)

+ Report: [Telegram](https://t.me/toolmod)

+ Use magisk to flash the module, can use any root manager not just magisk

```
Use: /data/overlayfs/tmp/overlayrw [-ro|-rw|-bind] [path_folder]

Instruct: /data/overlayfs/tmp/overlayrw -rw /system/app

After running the command, you can edit files in that directory
```

#### Hide root

+ If you select root, more rw-allowed partitions will appear

+ Hidden root | Root

#### Mount mode

1. Mount Overlay FS

+ Edit the system without saving the file

2. Mount Bind

+ Need to save data from original ROM the first time it will boot longer 

#### Partition list

+ `/product/app`, for example, will allow rw to this directory

+ For magisk be careful when adding partition it may bootloop

+ Note that you should only add partitions with apk, do not add strange partitions that may be bootlooped

+ Some paths, if used, can be detected as root 

+ Add link partitions here: `/data/overlayfs/tmp/path`
