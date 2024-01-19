## Changelog Overlay FS

+ Github: [Zenlua/Overlayfs](https://github.com/Zenlua/Overlayfs)

+ Report: [Telegram](https://t.me/toolmod)

#### V1.3

+ Move home to /data/overlayfs
+ Remove the backup feature because from this version only deleting the module will cause data loss, updates will remain the same
+ Remove vip mount feature
+ Fix some inactivity errors
+ Note that from 1.2 to 1.3 there will be no backup, please switch manually.

#### V1.2

+ Added bootloop drum feature, waiting time 2 minutes 120 seconds, Timeout automatically turns off the overlayfs module
+ Added auto mode again
+ Command: `overlayrw [path_folder_rw]`
+ For example: overlayrw /system/app
+ Will rw the entire /system/app directory
+ Fully updated to support more magisks
+ Default backup option on
+ Remove rw option in module.prop
+ Added early or late start feature

#### V1.1

+ Fix bootloop
+ Update some more partitions

#### V1.0

+ First version
