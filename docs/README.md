# FloralDroid Device Configuration

[简体中文](README.zh-CN.md)

FloralDroid reads the optional device identity profile below once during
Android property initialization:

```text
/ipc/floral_stream/device.prop
```

The host can copy either the [default Floral template](../examples/device.prop)
or the [complete OPPO Find X6 Pro example](../examples/device.oppo-find-x6-pro.prop)
to `device.prop` in the host instance directory. That directory also provides
the Floral Unix sockets, `radio.json`, and `wifi.json`. No additional Docker
mount or boot argument is required. Changes take effect after the container
restarts.

## Schema

The file uses strict `key=value` syntax:

```properties
version=1
brand=Floral
manufacturer=FloralDroid
model=Floral F12
device=floral_f12
product=floral_f12
board=floral_f12
soc_manufacturer=FloralDroid
soc_model=Floral S12
gpu_vendor=FloralDroid
gpu_model=Floral GPU
build_id=SQ1D.220205.004
build_display=Floral F12 Android 12
version_release=12
security_patch=2022-02-05
```

Every field is required. Unknown, missing, duplicated, empty, oversized, or
invalid fields reject the complete file. A partial profile is never applied.
Without a valid profile, the built-in Floral product, SOC, and GPU identity is
used while the image's original board and build version properties are kept.

`brand`, `manufacturer`, `model`, `device`, and `product` supply Android's
public product identity. `board` supplies `Build.BOARD` through
`ro.product.board`, but does not change `ro.hardware`, `ro.board.platform`, HAL
selection, or VINTF matching.

`build_id`, `build_display`, `version_release`, and `security_patch` supply the
public build ID, display build number, Android release string, and security
patch date. `version_release` sets both `ro.build.version.release` and
`ro.build.version.release_or_codename`. Android derives the fingerprint from
the configured product identity, release, and build ID together with the
image's real incremental version, build type, and tags. `build_display` is not
part of the fingerprint.

The file cannot replace `SDK_INT`, ABI, VNDK, signing, bootloader,
`ro.hardware`, or `ro.board.platform`. The release string can therefore provide
a coherent public identity without changing the Android APIs and system
capabilities actually supplied by the image.

`soc_manufacturer` and `soc_model` supply `Build.SOC_MANUFACTURER` and
`Build.SOC_MODEL` through `ro.soc.manufacturer` and `ro.soc.model`.

`gpu_vendor` and `gpu_model` are presentation strings only. GLES reports them
as `GL_VENDOR` and `GL_RENDERER`; Vulkan reports `gpu_model` as `deviceName`.
They do not select a renderer, change `floral_gpu_mode`, replace Vulkan vendor
or device IDs, add extensions, change limits, or alter the rendering and video
encoding paths.

Radio identity remains in `radio.json`. Wi-Fi access points remain in
`wifi.json`. Display geometry remains controlled by the `floral_width`,
`floral_height`, `floral_fps`, and `floral_dpi` boot properties.
The complete device example therefore does not contain IMEI, phone number,
SIM, or carrier fields.
