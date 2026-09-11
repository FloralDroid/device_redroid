# FloralDroid 设备配置

[English](README.md)

FloralDroid 在 Android 属性初始化期间只读取一次以下可选设备身份配置：

```text
/ipc/floral_stream/device.prop
```

宿主可将仓库中的 [Floral 默认模板](../examples/device.prop)或
[OPPO PGEM10 Android 12 兼容性示例](../examples/device.oppo-find-x6-pro.prop)复制为宿主实例
目录下的 `device.prop`。该目录同时提供 Floral Unix Socket、`radio.json` 和
`wifi.json`，不需要增加 Docker 挂载或启动参数。修改文件后重启容器即可生效。

## 格式

文件使用严格的 `key=value` 格式：

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

`version`、产品/SOC/GPU 身份、`build_id`、`build_display`、
`version_release` 和 `security_patch` 共 15 个核心字段为必填项；其余字段可选。
文件上限为 16 KiB。缺失、重复、空值、超长值、非法字段以及只配置名称或厂商一侧的
传感器身份都会使整份文件被拒绝，绝不会应用半份配置。未知字段会被统一解析器保留，
供其他 Floral 组件独立扩展。没有有效配置时，Android 属性保留镜像原值，各 HAL 使用
自己的 Floral 默认身份。

`brand`、`manufacturer`、`model`、`device` 和 `product` 提供 Android 对外产品
身份。`board` 通过 `ro.product.board` 提供 `Build.BOARD`。`soc_model` 同时提供
`ro.soc.model` 和公开的 `ro.hardware`/`Build.HARDWARE`；系统启动脚本、ueventd
和 legacy HAL 仍使用 `ro.boot.hardware` 选择实际容器平台。

`build_id`、`build_display`、`build_description`、`version_release` 和
`security_patch` 分别提供公开的构建 ID、显示构建号、构建描述、Android 版本字符串
和安全补丁日期。
`build_flavor` 和 `product` 分别覆盖 `ro.build.flavor` 与 `ro.build.product`，
避免公共构建身份继续显示 `redroid_x86_64`。
`version_release` 同时设置
`ro.build.version.release` 与 `ro.build.version.release_or_codename`。
`build_incremental`、`build_type`、`build_tags`、`build_user` 和 `build_host` 可选；
前三者参与 fingerprint；`build_date` 与十进制 `build_date_utc` 必须成对配置。
主 fingerprint、`odm`、`product`、`system`、`system_ext`、
`vendor` 和 `vendor_dlkm` 的产品身份及 fingerprint 均由同一份配置生成。

`kernel_release` 和 `kernel_version` 是可选的用户态展示字段，用于 LXCFS 的
`/proc/version`、`/proc/sys/kernel/osrelease` 以及已有 NativeBridge 兼容路径。
本阶段未实现内核 UTS 隔离；原生 x86 进程和绕过 libc 的直接 `uname` syscall
仍看到宿主内核值。

该文件不能替换 `SDK_INT`、ABI、VNDK、签名、bootloader 或
`ro.board.platform`。因此版本字符串可以用于一致的公开身份展示，但不会改变镜像
实际提供的 Android API 和系统能力。

`soc_manufacturer` 和 `soc_model` 通过 `ro.soc.manufacturer`、`ro.soc.model`
提供 `Build.SOC_MANUFACTURER` 与 `Build.SOC_MODEL`；`soc_model` 还提供上述公开
硬件身份。

`gpu_vendor` 和 `gpu_model` 仅用于显示。GLES 将它们报告为 `GL_VENDOR` 和
`GL_RENDERER`，Vulkan 将 `gpu_model` 报告为 `deviceName`。它们不会选择渲染器、
修改 `floral_gpu_mode`、替换 Vulkan vendor/device ID、增加扩展、修改能力限制，
也不会改变渲染及视频编码链路。

`memory_type`、`memory_frequency` 和 `memory_channel` 通过
`ro.boot.floral_memory_*` 提供给硬件信息层，但不会改变实际内存限制。
`serial` 同时提供 `ro.serialno` 与 `ro.boot.serialno`；`hardware_revision`
同时提供 `ro.hardware.revision` 与 `ro.boot.hardware.revision`。

每个 `sensor_*` 身份由成对的 `_name` 和 `_vendor` 字段组成，完整字段见两个示范
文件。硬件传感器由 Floral Sensors HAL 使用，`sensor_virtual_*` 由 SensorService
使用。`thermal_ambient_celsius` 设置环境温度基线；电池、skin、CPU 和 GPU 温度在此
基线上按负载缓慢变化。`thermal_*_name` 只设置 Thermal HAL 的公开热区名称。

蜂窝身份继续由 `radio.json` 管理，Wi-Fi AP 继续由 `wifi.json` 管理。显示尺寸继续
由 `floral_width`、`floral_height`、`floral_fps` 和 `floral_dpi` 启动属性控制；
`/sys/class/graphics/fb0/virtual_size` 和 `modes` 同步呈现这组实际容器显示配置。
因此完整机型示例不包含 IMEI、手机号、SIM 或网络运营商字段。
