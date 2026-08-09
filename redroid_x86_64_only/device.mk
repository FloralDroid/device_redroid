PRODUCT_COPY_FILES += \
    device/redroid/mediacodec.policy.x86:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \

PRODUCT_PROPERTY_OVERRIDES += \
    ro.enable.native.bridge.exec=1 \
    ro.dalvik.vm.isa.arm64=x86_64

$(call inherit-product, system/floral/nativebridge/nativebridge.mk)

$(call inherit-product, device/redroid-prebuilts/prebuilts_x86.mk)
