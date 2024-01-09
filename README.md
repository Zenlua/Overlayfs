# Overlay FS

+ [Update log](../module/log.md)

+ Use magisk to flash the module 

+ This module allows to rw partitions present in the list

+ Report: [Telegram](https://t.me/toolmod)

#### Functions

+ Customizable features in module.prop

**Read and write**

+ Default is rw
+ Can be changed to (ro) edit in module.prop (rw=false)

**Grant selinux**

+ Automatically granting selinux permissions can only be 90% correct, if you understand, you should grant permissions manually

**Permissions to read and write directories and files**

+ Grant 755 permission to folders and files

**Grant group and owner**

+ Auto grant permissions to all files (root:root)

**Backup**

+ Will automatically back up old items added or deleted

**Partition list**

+ /product/app, for example, will allow rw to this directory
+ Default: `/product/app /product/etc /product/fonts /product/framework /product/media /product/overlay /product/priv-app /system/app /system/etc /system/fonts /system/framework /system/priv-app /system_ext/app /system_ext/cust /system_ext/etc /system_ext/framework /system_ext/priv-app`
+ Please manually add the folders you want to rw


