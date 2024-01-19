# OverlayFS RW

[![Build module](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml/badge.svg)](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml)

+ Update: [Changelog](./module/log.md)

+ Use magisk to flash the module, can use any root manager not just magisk

+ This module allows to rw partitions present in the list

+ Use: `overlayrw path_folder`

+ Example: overlayrw /system/app ( Will rw the entire /system/app directory )

+ Report: [Telegram](https://t.me/toolmod)

#### Functions

+ Customizable features in module.prop

**Vip module**

1. This mode supports many devices. If there is an error that the application cannot be opened, please switch to number 2

2. This mode supports few devices

+ The module will animate the overlay fs form, not the works form like magisk

**Backup**

+ Will automatically back up old items added or deleted

**Partition list**

+ `/product/app`, for example, will allow rw to this directory

+ For magisk be careful when adding partition it may bootloop

+ Note that you should only add partitions with apk, do not add strange partitions that may be bootlooped



