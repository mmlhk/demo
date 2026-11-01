#
# SPDX-License-Identifier: Apache-2.0
#
# K10 (FATARUS) — MT6765 (k62v1_64_bsp_S30_254_incell_1036_dianshang)
# TWRP device tree for twrp-11 (TeamWin android-11) minimal manifest.
#
# All values are derived from on-device forensics of THIS exact unit
# (boot_a.img header v2, GPT by-name table, lpdump, /vendor/etc/fstab.mt6765,
# getprop), not from any donor device tree.
#

DEVICE_PATH := device/k10/k10

# For building with minimal manifest
ALLOW_MISSING_DEPENDENCIES := true

# Architecture — 8x Cortex-A53 (0xd03), arm64-v8a primary + arm secondary
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Bootloader / Platform
TARGET_BOOTLOADER_BOARD_NAME := k62v1_64_bsp
TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := mt6765
PRODUCT_PLATFORM := mt6765

# Kernel — prebuilt, byte-identical to the currently running stock kernel.
# Stock boot_a header (v2, page 2048):
#   kernel 10,231,959 B @0x40080000   (base 0x40000000 + 0x00800000)
#   ramdisk          @0x51b00000     (base           + 0x11b00000)
#   tags / dtb       @0x47880000     (base           + 0x07880000)
#   dtb 94,494 B (Android DT image, magic 0xd7b7ab1e)
#   cmdline: bootopt=64S3,32N2,64N2 buildvariant=user androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x40000000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00080000
BOARD_RAMDISK_OFFSET := 0x11b00000
BOARD_KERNEL_TAGS_OFFSET := 0x07880000
BOARD_DTB_OFFSET := 0x07880000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 buildvariant=user androidboot.selinux=permissive
BOARD_BOOTIMG_HEADER_VERSION := 2
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image.gz
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img

BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOTIMG_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --dtb $(TARGET_PREBUILT_DTB)

# Assert
TARGET_OTA_ASSERT_DEVICE := K10 k62v1_64_bsp_S30_254_incell_1036_dianshang

# fstab
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab

# Partitions — measured from GPT /proc/partitions
BOARD_FLASH_BLOCK_SIZE := 131072   # 2048 * 64
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432     # boot_a = 32 MiB
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432

# This device has NO recovery partition: TWRP lives in boot (recovery-as-boot).
# Slot B is an empty stub (boot_b all-zero, no super extents), so we operate
# slot A exclusively; no slotselect flags are used in the fstab on purpose.
BOARD_USES_RECOVERY_AS_BOOT := true

# Dynamic partitions — measured via lpdump on-device
BOARD_SUPER_PARTITION_SIZE := 7516192768
BOARD_SUPER_PARTITION_GROUPS := main
BOARD_MAIN_SIZE := 7514095616
BOARD_MAIN_PARTITION_LIST := system vendor product

# File systems
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USES_MKE2FS := true

# MTK
BOARD_USES_MTK_HARDWARE := true

# Crypto — /data: ext4 + inlinecrypt + FBE v2 + metadata encryption
# (keydirectory=/metadata/vold/metadata_encryption, /metadata lives on md_udc)
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_CRYPTO_FBE := true
TW_USE_FSCRYPT_POLICY := 1
TW_INCLUDE_FBE_METADATA_DECRYPT := true
BOARD_USES_METADATA_PARTITION := true
BOARD_SUPPRESS_SECURE_ERASE := true

# AVB — recovery-as-boot uses BOOT key path (not RECOVERY)
BOARD_AVB_ENABLE := true
BOARD_AVB_BOOT_KEY_PATH := external/avb/test/data/testkey_rsa2048.pem
BOARD_AVB_BOOT_ALGORITHM := SHA256_RSA2048
BOARD_AVB_BOOT_ROLLBACK_INDEX := 1
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2

# Workaround for error copying files to recovery ramdisk
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# Anti-rollback hack so the build accepts the old platform security patch
PLATFORM_SECURITY_PATCH := 2099-12-31
VENDOR_SECURITY_PATCH := 2099-12-31
# NOTE: PLATFORM_VERSION / PLATFORM_VERSION_CODENAME are readonly in the
# AOSP R build system and must NOT be set in BoardConfig (they cause
# "cannot assign to readonly variable" and abort the entire config load).

# Recovery UI
# Pixel format: leave unset — minui auto-detects from fb0 (stock AOSP recovery
# renders correctly on this panel with autodetect; MTK fb is 32bpp).
TW_THEME := portrait_hdpi
TW_BRIGHTNESS_PATH := "/sys/class/leds/lcd-backlight/brightness"
TW_MAX_BRIGHTNESS := 255
TW_DEFAULT_BRIGHTNESS := 128
# Correct flag name in TWRP android-11 source (TW_NO_SCREEN_BLANK_ON_BOOT
# does not exist there; X5's tree carried the typo and it silently no-ops)
TW_NO_SCREEN_BLANK := true
# HALL_DEV is a cover sensor that emits spurious KEY_POWER events; keep the
# real key devices (mtk-kpd volume, mtk-pmic-keys power) for navigation.
TW_INPUT_BLACKLIST := "HALL_DEV"

# Internal storage only (no SD slot); /sdcard lives on /data/media
RECOVERY_SDCARD_ON_DATA := true

# Languages: include Chinese (this unit ships a Chinese-locale build)
TW_EXTRA_LANGUAGES := true
TW_INCLUDE_NTFS_3G := true

# Toolbox instead of busybox (busybox source is not part of the minimal
# twrp-11 manifest; toolbox is — proven on other MT6765 trees)
TW_USE_TOOLBOX := true

# Logging for diagnosis (prior binary ports died silently before opening
# recovery.log — keep logd/logcat available in the image)
TARGET_USES_LOGD := true
TWRP_INCLUDE_LOGCAT := true
TWRP_EVENT_LOGGING := true

# Screen: 1200x2000 @260dpi, fb0 virtual 1216x6048 — portrait_hdpi (720x1280)
# assets scale fine; no offsets needed (plain LCD, no notch in the panel UI).
