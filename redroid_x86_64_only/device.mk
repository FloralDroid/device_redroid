PRODUCT_COPY_FILES += \
    device/redroid/mediacodec.policy.x86:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.enable.native.bridge.exec=1 \
    ro.dalvik.vm.isa.arm64=x86_64

$(call inherit-product, system/floral/nativebridge/nativebridge.mk)

# Build and install AOSP's guest userspace. The bionic patch keeps the host
# NativeBridge libc variant non-installable so guest libc owns the libc.so path.
PRODUCT_SOONG_NAMESPACES += frameworks/libs/native_bridge_support/libc
include frameworks/libs/native_bridge_support/native_bridge_support.mk
PRODUCT_PACKAGES += $(NATIVE_BRIDGE_PRODUCT_PACKAGES)

$(call inherit-product, device/redroid-prebuilts/prebuilts_x86.mk)
