# FloralDroid 设备配置

[English](README.md)

FloralDroid 在 Android 属性初始化期间只读取一次以下可选设备身份配置：

```text
/ipc/floral_stream/device.prop
```

宿主可将仓库中的 [Floral 默认模板](../examples/device.prop)或
[OPPO Find X6 Pro 完整示例](../examples/device.oppo-find-x6-pro.prop)复制为宿主实例
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

除 `build_description`、`build_flavor`、`kernel_release`、`kernel_version`、
`memory_type`、`memory_frequency`、`memory_channel`、`serial` 和
`hardware_revision` 外，上述字段都是必填项。
缺失、重复、空值、超长值或非法的已知字段会使整份文件被拒绝，绝不会应用半份配置。
未知字段会被忽略，其他 Floral 组件可以独立扩展这份共享配置。没有有效配置时使用
内置 Floral 产品、SOC 和 GPU 身份，并保留镜像原有的 board 与构建版本属性。

`brand`、`manufacturer`、`model`、`device` 和 `product` 提供 Android 对外产品
身份。`board` 通过 `ro.product.board` 提供 `Build.BOARD`，但不会改变
`ro.hardware`、`ro.board.platform`、HAL 选择或 VINTF 匹配。

`build_id`、`build_display`、`build_description`、`version_release` 和
`security_patch` 分别提供公开的构建 ID、显示构建号、构建描述、Android 版本字符串
和安全补丁日期。`build_description` 是可选字段；未配置时保留镜像原值。
`build_flavor` 和 `product` 分别覆盖 `ro.build.flavor` 与 `ro.build.product`，
避免公共构建身份继续显示 `redroid_x86_64`。
`version_release` 同时设置
`ro.build.version.release` 与 `ro.build.version.release_or_codename`。Android 使用
配置的产品身份、版本和构建 ID，以及镜像真实的 incremental、构建类型和标签派生
fingerprint。`build_display` 不参与 fingerprint。

`kernel_release` 和 `kernel_version` 是可选字段，用于 NativeBridge ARM 进程通过
bionic `uname()` 读取内核身份。原生 x86 进程和绕过 libc 的直接系统调用仍看到
真实内核值。

该文件不能替换 `SDK_INT`、ABI、VNDK、签名、bootloader、`ro.hardware` 或
`ro.board.platform`。因此版本字符串可以用于一致的公开身份展示，但不会改变镜像
实际提供的 Android API 和系统能力。

`soc_manufacturer` 和 `soc_model` 通过 `ro.soc.manufacturer`、`ro.soc.model`
提供 `Build.SOC_MANUFACTURER` 与 `Build.SOC_MODEL`。

`gpu_vendor` 和 `gpu_model` 仅用于显示。GLES 将它们报告为 `GL_VENDOR` 和
`GL_RENDERER`，Vulkan 将 `gpu_model` 报告为 `deviceName`。它们不会选择渲染器、
修改 `floral_gpu_mode`、替换 Vulkan vendor/device ID、增加扩展、修改能力限制，
也不会改变渲染及视频编码链路。

`memory_type`、`memory_frequency` 和 `memory_channel` 通过
`ro.boot.floral_memory_*` 提供给硬件信息层，但不会改变实际内存限制。
`serial` 同时提供 `ro.serialno` 与 `ro.boot.serialno`；`hardware_revision`
同时提供 `ro.hardware.revision` 与 `ro.boot.hardware.revision`。

蜂窝身份继续由 `radio.json` 管理，Wi-Fi AP 继续由 `wifi.json` 管理。显示尺寸继续
由 `floral_width`、`floral_height`、`floral_fps` 和 `floral_dpi` 启动属性控制。
因此完整机型示例不包含 IMEI、手机号、SIM 或网络运营商字段。
