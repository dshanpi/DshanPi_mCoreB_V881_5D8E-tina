# DshanPi_mCoreB_V881_5D8E-tina

用于 Tina V861 v1.1 SDK 的 DshanPi_mCoreB_V881_5D8E 板型配置，从已烧录验证的 bga_perf1 配置克隆。
仓库按 SDK 相对路径组织，只包含本板型配置、配套 RTOS 工程和必要注册项。

## 复制到 SDK

```sh
CONFIG_REPO="$HOME/work/DshanPi_mCoreB_V881_5D8E-tina"
SDK="$HOME/tina-v861-v1.1"
cp -a "$CONFIG_REPO/device" "$CONFIG_REPO/openwrt" "$CONFIG_REPO/rtos" "$SDK/"
```

三个顶层目录均为覆盖层，不是完整 SDK。两份共享 RTOS 注册文件基于同一个 Tina V861 v1.1 SDK，增加了本板型注册。

## 选择、编译和打包

```sh
cd "$SDK"
source build/envsetup.sh
lunch v861-DshanPi_mCoreB_V881_5D8E-tina
# 按提示选择 V881 / MX-XXX / 0.92V，与已验证镜像一致。
export TINA_TOPDIR="$PWD"
./build.sh
./build.sh pack
```

已选择芯片型号后，也可通过以下非交互命令切换板型：

```sh
./build.sh autoconfig -o openwrt -i v861 -b DshanPi_mCoreB_V881_5D8E -n default
```

V881MX-XXX 对应镜像输出：`out/v881mx-xxx_linux_DshanPi_mCoreB_V881_5D8E_uart0.img`。

## 配置范围

| 路径 | 用途 |
| --- | --- |
| device/config/chips/v861/configs/DshanPi_mCoreB_V881_5D8E | DDR/eMMC、纯 PMC 电源控制、内核及 U-Boot 设备树、分区、环境变量、quick_config |
| openwrt/target/v861/v861-DshanPi_mCoreB_V881_5D8E | lunch 注册、OpenWrt 配置、板级文件与启动脚本 |
| rtos/board/v861_e907/DshanPi_mCoreB_V881_5D8E | RTOS 板级配置 |
| rtos/lichee/rtos/projects/v861_e907/DshanPi_mCoreB_V881_5D8E | 配套 RTOS 工程与 defconfig |
| rtos/lichee/rtos/projects/Kconfig | 本板型 RTOS 配置项注册 |
| rtos/lichee/rtos/projects/v861_e907/Makefile | 本板型 RTOS 构建入口 |

使用 SDK 原厂 PMC 实现，board.c 保持原厂代码，无需 GPIO 接管补丁。
对应硬件：R6 不装、R93 装100kΩ、RS27接通、RS13不装。
继承 DDR3 1056MHz、eMMC 8bit/3.3V/最高50MHz与 USB VBUS supply 引用修复。

不包含固件 .img、SDK out/、生成的 .buildconfig、板型 bin/ 和 dtbo 编译产物；完整构建会重新生成这些产物。
dtbo/ 下的 dtco、mkdtimg 是原厂配置目录附带的工具，保留其执行权限。
board.dts 是指向 linux-6.6-xuantie/board.dts 的相对符号链接，请在 Linux 中保留。

2026-10-27 导出自已通过 Lynx 烧录校验和启动测试的新板型配置；本次仅复制并核对配置，没有重新构建或烧录。

## OpenWrt 目录名称

实际文件目录为 `openwrt/target/v861/v861-DshanPi_mCoreB_V881_5D8E/`，与其他原厂工程保持相同的 `v861-` 前缀。
该路径是实目录，不再使用兼容符号链接，也不再保留不带前缀的板级目录。
Makefile 的 BOARD、CONFIG_TARGET 和 lunch 入口保持原厂命名；SDK 构建脚本和板级参数未修改。

GitHub 仓库仍为 `dshanpi/DshanPi_mCoreB_V881_5D8E-tina`。
已验证固件备份位于[Releases 页面](https://github.com/dshanpi/DshanPi_mCoreB_V881_5D8E-tina/releases)，发布包附带 SHA-256；配置仓库不加入 .img 编译产物。

从之前的“无前缀实目录＋兼容链接”版本升级时，先备份并替换旧目录结构，再复制本版本；首次覆盖到原厂 SDK 可直接使用上面的 cp -a 命令。
