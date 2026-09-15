# arm64 emulator specific definitions
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_VARIANT := generic
TARGET_CPU_ABI := arm64-v8a

include build/make/target/board/BoardConfigGsiCommon.mk

TARGET_USERIMAGES_SPARSE_EXT_DISABLED := true

BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_PARTITION_RESERVED_SIZE := 16777216
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 16777216

DEVICE_MANIFEST_FILE += device/redroid/manifest.xml

# Build the Mesa drivers used by ARM servers and development boards.
BOARD_GPU_DRIVERS := kmsro swrast virgl radeonsi nouveau freedreno panfrost v3d vc4
BOARD_MESA3D_VULKAN_DRIVERS := swrast

BOARD_VENDOR_SEPOLICY_DIRS += \
    hardware/floral/location/sepolicy/vendor \
    hardware/floral/power/sepolicy/vendor \
    hardware/floral/radio/sepolicy/vendor \
    hardware/floral/sensors/sepolicy/vendor \
    hardware/floral/wifi/sepolicy/vendor \
    packages/services/FloralDevice/sepolicy/vendor
