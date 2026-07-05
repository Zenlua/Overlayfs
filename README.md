# OverlayFS RW

[![Build module](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml/badge.svg)](https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml)

+ Update: [Release](https://github.com/Zenlua/Overlayfs/releases) | [Changelog](./module/log.md)

+ Flash Magisk, KSU, or a similar app to use.

+ If you are using `erofs` partitions, you should use this module.

+ The advice is to only enable rw mode when necessary to modify files. After making changes, switch back to ro mode to avoid system detection of root access.

+ The default state upon installation is rw. Press the action button to change the state. When you change it, it will save the state. Upon restarting, all changes will take effect, and the old state will remain.

#### Partition list

+ `/product/app`, for example, will allow rw to this directory

+ You can easily add the partition path yourself to the partition.txt file

+ For magisk be careful when adding partition it may bootloop

+ Note that you should only add partitions with apk, do not add strange partitions that may be bootloop.
