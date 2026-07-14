# OverlayFS RW

[![Build module](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml/badge.svg)](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml)

+ Update: [Release](https://github.com/Zenlua/Overlayfs/releases) | [Changelog](./module/log.md)

+ Flash Magisk, KSU, or a similar app to use.

+ If you are using `erofs` partitions, you should use this module.

#### Features

1. Basic version

- There is no root hiding feature.
- There's only mount overlay, no mount bind.
- It can be edited directly in `/data/adb/overlayfs`
- Storage capacity, in terms of memory `/data`

2. Hidden root version

- System hidden root feature
- The default setting is mount overlay, with 4GB of storage.
- Mount bind mode is only enabled when:
    + Mount overlay mode is not working.
    + To enable mount bind, create a file at the following path: `/data/adb/overlayfs/bind` ©
- Modify the list of partitions that are rw in: `/data/adb/overlayfs/partition.txt` ©
- Add the prop to: `/data/adb/overlayfs/system.prop`
- All features marked with the © symbol require flashing the module.zip file to function.
- If you encounter errors, you can mount overlayfs.img to edit or delete the file in TWRP or Fox.
     + In the terminal screen in recovery mode, type the command: `/data/adb/overlayfs/mount.sh`
     + After typing the command, the overlay directory will appear at: `/data/adb/overlayfs/overlay`, where you can edit the files.

#### Partition list

+ List of folders that have been RW

```
/system/app
/system/etc
/system/fonts
/system/framework
/system/media
/system/priv-app
/system/product/app
/system/product/etc
/system/product/fonts
/system/product/overlay
/system/product/priv-app
/system/system_ext/app
/system/system_ext/cust
/system/system_ext/etc
/system/system_ext/framework
/system/system_ext/priv-app
/system/vendor/app
/system/vendor/etc
/system/vendor/odm/etc
/system/vendor/odm/app
/system/vendor/overlay
```

+ `/product/app`, for example, will allow rw to this directory

+ You can easily add the partition path yourself to the partition.txt file

+ For magisk be careful when adding partition it may bootloop

+ Note that you should only add partitions with apk, do not add strange partitions that may be bootloop.
