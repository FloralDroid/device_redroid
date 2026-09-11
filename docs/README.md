# FloralDroid Device Configuration

[简体中文](README.zh-CN.md)

FloralDroid reads the optional device identity profile below once during
Android property initialization:

```text
/ipc/floral_stream/device.prop
```

The host can copy either the [default Floral template](../examples/device.prop)
or the [OPPO PGEM10 Android 12 compatibility example](../examples/device.oppo-find-x6-pro.prop)
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
build_description=floral_f12-user 12 SQ1D.220205.004 1 release-keys
build_flavor=floral_f12-user
build_incremental=1
build_type=user
build_tags=release-keys
build_user=floral
build_host=floral-builder
build_date=Sat Sep  5 18:35:17 UTC 2026
build_date_utc=1788633317
version_release=12
security_patch=2022-02-05
kernel_release=5.10.66-android12-9
kernel_version=#1 SMP PREEMPT
memory_type=LPDDR5X
memory_frequency=4200MHz
memory_channel=16-bit Quad channel
serial=FLORALF120001
hardware_revision=EVT1
thermal_ambient_celsius=22.0
thermal_cpu_name=cpu-0
thermal_gpu_name=gpu-0
thermal_battery_name=battery
thermal_skin_name=skin
```

The 15 core fields covering `version`, product/SOC/GPU identity, `build_id`,
`build_display`, `version_release`, and `security_patch` are required. Other
fields are optional. The file is limited to 16 KiB. Missing, duplicated,
empty, oversized, or invalid fields, including an unpaired sensor name or
vendor, reject the complete file. Unknown fields are retained for independent
Floral consumers. Without a valid profile, Android properties retain the
image values and each HAL uses its Floral defaults.

`brand`, `manufacturer`, `model`, `device`, and `product` supply Android's
public product identity. `board` supplies `Build.BOARD` through
`ro.product.board`. `soc_model` supplies both `ro.soc.model` and the public
`ro.hardware`/`Build.HARDWARE`; boot scripts, ueventd, and legacy HAL loading
continue to use `ro.boot.hardware` for the actual container platform.

`build_id`, `build_display`, `build_description`, `version_release`, and
`security_patch` supply the public build ID, display build number, optional
build description, Android release string, and security patch date.
`build_flavor` and `product` supply `ro.build.flavor` and `ro.build.product`,
so the public build identity does not retain `redroid_x86_64`.
`version_release` sets both `ro.build.version.release` and
`ro.build.version.release_or_codename`. Optional `build_incremental`,
`build_type`, and `build_tags` participate in the fingerprint; `build_user`
and `build_host` set their corresponding public fields. `build_date` and the
decimal `build_date_utc` must be specified together. The main fingerprint
and the `odm`, `product`, `system`, `system_ext`, `vendor`, and `vendor_dlkm`
product identities and fingerprints are all generated from this profile.

`kernel_release` and `kernel_version` are optional userspace presentation
fields for the LXCFS `/proc/version` and `/proc/sys/kernel/osrelease` views and
the existing NativeBridge compatibility path. Kernel UTS isolation is not
implemented in this phase. Native x86 processes and direct `uname` syscalls
continue to expose the host kernel values.

The file cannot replace `SDK_INT`, ABI, VNDK, signing, bootloader, or
`ro.board.platform`. The release string can therefore provide
a coherent public identity without changing the Android APIs and system
capabilities actually supplied by the image.

`soc_manufacturer` and `soc_model` supply `Build.SOC_MANUFACTURER` and
`Build.SOC_MODEL` through `ro.soc.manufacturer` and `ro.soc.model`;
`soc_model` also supplies the public hardware identity described above.

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

Each `sensor_*` identity consists of paired `_name` and `_vendor` fields; the
complete list is in both example files. The Floral Sensors HAL consumes the
hardware identities and SensorService consumes `sensor_virtual_*`.
`thermal_ambient_celsius` sets the ambient baseline. Battery, skin, CPU, and
GPU temperatures evolve gradually above it according to load.
`thermal_*_name` changes only the public Thermal HAL zone names.

Radio identity remains in `radio.json`. Wi-Fi access points remain in
`wifi.json`. Display geometry remains controlled by the `floral_width`,
`floral_height`, `floral_fps`, and `floral_dpi` boot properties;
`/sys/class/graphics/fb0/virtual_size` and `modes` report the same effective
container display configuration.
The complete device example therefore does not contain IMEI, phone number,
SIM, or carrier fields.
