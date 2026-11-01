#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# Inherit from our device
$(call inherit-product, device/k10/k10/device.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Device identifier. This must come after all inclusions
PRODUCT_RELEASE_NAME := k10
PRODUCT_DEVICE := k10
PRODUCT_NAME := twrp_k10
PRODUCT_BRAND := K10
PRODUCT_MODEL := K10
PRODUCT_MANUFACTURER := FATARUS

# Dynamic Partition
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# VNDK / API
PRODUCT_TARGET_VNDK_VERSION := 30
PRODUCT_SHIPPING_API_LEVEL := 30
