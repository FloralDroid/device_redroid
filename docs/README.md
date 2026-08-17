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
build_description=floral_f12-user 12 SQ1D.220205.004 1 test-keys
build_flavor=floral_f12-userdebug
version_release=12
security_patch=2022-02-05
kernel_release=5.10.66-android12-9
kernel_version=#1 SMP PREEMPT
memory_type=LPDDR5X
memory_frequency=4200MHz
memory_channel=16-bit Quad channel
serial=FLORALF120001
hardware_revision=EVT1
```

Every field listed above except `build_description`, `build_flavor`,
`kernel_release`, `kernel_version`, `memory_type`, `memory_frequency`,
`memory_channel`, `serial`, and `hardware_revision` is required. Missing,
duplicated, empty, oversized, or invalid
known fields reject the complete file. Unknown fields are ignored so other
Floral components can extend the shared profile independently. A partial
profile is never applied.
Without a valid profile, the built-in Floral product, SOC, and GPU identity is
used while the image's original board and build version properties are kept.

`brand`, `manufacturer`, `model`, `device`, and `product` supply Android's
public product identity. `board` supplies `Build.BOARD` through
`ro.product.board`, but does not change `ro.hardware`, `ro.board.platform`, HAL
selection, or VINTF matching.

`build_id`, `build_display`, `build_description`, `version_release`, and
`security_patch` supply the public build ID, display build number, optional
build description, Android release string, and security patch date.
`build_flavor` and `product` supply `ro.build.flavor` and `ro.build.product`,
so the public build identity does not retain `redroid_x86_64`.
`version_release` sets both `ro.build.version.release` and
`ro.build.version.release_or_codename`. Android derives the fingerprint from
the configured product identity, release, and build ID together with the
image's real incremental version, build type, and tags. `build_display` is not
part of the fingerprint.

`kernel_release` and `kernel_version` are optional and supply the bionic
`uname()` identity for translated NativeBridge ARM processes in `hybrid` mode.
`direct` mode, native x86 processes, and direct syscalls that bypass libc
continue to expose the real kernel values.

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

`memory_type`, `memory_frequency`, and `memory_channel` are exposed as
`ro.boot.floral_memory_*` identity fields for the hardware information layer;
they do not change the actual memory cgroup limit. `serial` supplies both
`ro.serialno` and `ro.boot.serialno`. `hardware_revision` supplies
`ro.hardware.revision` and `ro.boot.hardware.revision`.

Radio identity remains in `radio.json`. Wi-Fi access points remain in
`wifi.json`. Display geometry remains controlled by the `floral_width`,
`floral_height`, `floral_fps`, and `floral_dpi` boot properties.
The complete device example therefore does not contain IMEI, phone number,
SIM, or carrier fields.
