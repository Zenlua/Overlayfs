# OverlayFS RW

<p align="center">
  <a href="https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml"><img src="https://github.com/Zenlua/Overlayfs/actions/workflows/build.yml/badge.svg" alt="Build module"></a> <a href="https://github.com/Zenlua/Overlayfs/releases"><img src="https://img.shields.io/github/v/release/Zenlua/Overlayfs?color=blue&logo=github" alt="Latest Release"></a>
</p>

An Android module designed to mount **OverlayFS** with Read/Write (RW) permissions. This is an optimized and essential solution for devices utilizing the **`erofs`** partition format.

## 📌 Quick Links

*   🚀 **Update:** [Release](https://github.com/Zenlua/Nverlayfs/releases) | [Changelog](./module/log.md)
*   ⚡ **Requirements:** Flash Magisk, KernelSU (KSU), or a similar manager app to use.
*   💡 **Recommendation:** If you are currently using `erofs` partitions, you should highly consider using this module.

## 🛠 Version Comparison

### 1. Basic Version

*   **Root Hiding:** There is no built-in root hiding feature.
*   **Switching:** You can manually switch to (RO) to hide root.
*   **Mount Mechanism:** Supports **Mount Overlay** only; Mount Bind is not available.
*   **Configuration:** It can be edited directly at the following path:
    ```path
    /data/adb/modules/overlayfs
    ```
*   **Storage Capacity:** Dynamically scales in terms of memory available on your `/data` partition.

### 2. Hidden Root Version

*   **Root Hiding:** Features a built-in system hidden root capability.
*   **Default Mode:** The default setting is configured to Mount Overlay with a fixed **4GB** storage size.
*   **Mount Bind Mode:** The total actual file size is included plus **5GB** of free space. Mount bind mode is only enabled when:
    *   Mount overlay mode is not working properly on the device.
    *   To manually enable mount bind, create a file at the following path: `/data/adb/overlayfs/bind` ©
*   **Custom RW Partitions:** Modify the list of partitions that are rw in: `/data/adb/overlayfs/partition.txt` ©
*   **Add Prop:** Add custom properties configuration at: `/data/adb/overlayfs/system.prop`
*   **Independence:** It operates completely independently and does not require installing Meta Module (with KSU).

> ⚠️ **Note:** All features marked with the **©** symbol require flashing the `module.zip` file to function properly.

## 🚑 Troubleshooting & Recovery

If you encounter errors (such as a bootloop or freeze), you can mount `overlayfs.img` to edit or delete the problematic files directly within **TWRP** or **OrangeFox Recovery**:

1. In the terminal screen of your recovery mode, type and execute the command:
    ```bash
    /data/adb/overlayfs/mount.sh
    ```
2. After typing the command, the overlay directory will appear at:
    ```path
    /data/adb/overlayfs/overlay
    ```
    where you can edit the files.
