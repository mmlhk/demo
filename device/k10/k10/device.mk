#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/k10/k10

# A/B updater config (pseudo-A/B: only slot A is populated)
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += boot dtbo vbmeta vbmeta_system vbmeta_vendor

# Dynamic partitions (super: system/product/vendor, group main)
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# fastbootd lets users flash logical (dynamic) partitions from TWRP's
# "Advanced -> Fastboot" mode. Modules come from the twrp-11 extras
# (system/core, hardware/interfaces); missing ones are skipped thanks to
# ALLOW_MISSING_DEPENDENCIES.
PRODUCT_PACKAGES += \
    fastbootd \
    android.hardware.fastboot@1.0-impl-mock \
    resetprop

# Soong namespace (device tree is self-contained)
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# Additional system properties (ro.adb.secure=0, ro.debuggable=1, identity)
TARGET_SYSTEM_PROP += $(LOCAL_PATH)/system.prop
