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
version_release=12
security_patch=2022-02-05
```

所有字段都是必填项。出现未知字段、缺失字段、重复字段、空值、超长值或非法值时，
整份文件都会被拒绝，绝不会应用半份配置。没有有效配置时使用内置 Floral
产品、SOC 和 GPU 身份，并保留镜像原有的 board 与构建版本属性。

`brand`、`manufacturer`、`model`、`device` 和 `product` 提供 Android 对外产品
身份。`board` 通过 `ro.product.board` 提供 `Build.BOARD`，但不会改变
`ro.hardware`、`ro.board.platform`、HAL 选择或 VINTF 匹配。

`build_id`、`build_display`、`version_release` 和 `security_patch` 分别提供公开的
构建 ID、显示构建号、Android 版本字符串和安全补丁日期。`version_release` 同时设置
`ro.build.version.release` 与 `ro.build.version.release_or_codename`。Android 使用
配置的产品身份、版本和构建 ID，以及镜像真实的 incremental、构建类型和标签派生
fingerprint。`build_display` 不参与 fingerprint。

该文件不能替换 `SDK_INT`、ABI、VNDK、签名、bootloader、`ro.hardware` 或
`ro.board.platform`。因此版本字符串可以用于一致的公开身份展示，但不会改变镜像
实际提供的 Android API 和系统能力。

`soc_manufacturer` 和 `soc_model` 通过 `ro.soc.manufacturer`、`ro.soc.model`
提供 `Build.SOC_MANUFACTURER` 与 `Build.SOC_MODEL`。

`gpu_vendor` 和 `gpu_model` 仅用于显示。GLES 将它们报告为 `GL_VENDOR` 和
`GL_RENDERER`，Vulkan 将 `gpu_model` 报告为 `deviceName`。它们不会选择渲染器、
修改 `floral_gpu_mode`、替换 Vulkan vendor/device ID、增加扩展、修改能力限制，
也不会改变渲染及视频编码链路。

蜂窝身份继续由 `radio.json` 管理，Wi-Fi AP 继续由 `wifi.json` 管理。显示尺寸继续
由 `floral_width`、`floral_height`、`floral_fps` 和 `floral_dpi` 启动属性控制。
因此完整机型示例不包含 IMEI、手机号、SIM 或网络运营商字段。
