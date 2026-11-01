#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := device/k10/k10

# A/B updater config (pseudo-A/B: only slot A is populated)
AB_OTA_UPDATER := true
AB_OTA_PARTITIONS += boot dtbo vbmeta vbmeta_system vbmeta_vendor

# Dynamic partitions (super: system/product/vendor, group main)
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Soong namespace isolation (device tree is self-contained)
PRODUCT_SOONG_NAMESPACES += $(LOCAL_PATH)

# resetprop is pulled in automatically by TW_INCLUDE_RESETPROP in BoardConfig;
# fastbootd intentionally omitted (it needs a bootctrl HAL this MTK device
# does not ship; the super partitions are already mapped linearly and TWRP
# can flash them directly).
