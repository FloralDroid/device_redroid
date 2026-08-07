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
soc_manufacturer=FloralDroid
soc_model=Floral S12
gpu_vendor=FloralDroid
gpu_model=Floral GPU
```

Every field is required. Unknown, missing, duplicated, empty, oversized, or
invalid fields reject the complete file and select the same built-in Floral
identity shown above. A partial profile is never applied.

`brand`, `manufacturer`, `model`, `device`, and `product` supply Android's
public product identity. Android derives the build fingerprint from that
identity and the image's real version, build ID, build type, and tags. The file
cannot replace version, ABI, security patch, signing, board, or hardware
properties.

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
