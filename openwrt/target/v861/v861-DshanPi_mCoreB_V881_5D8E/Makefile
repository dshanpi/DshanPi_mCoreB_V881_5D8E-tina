#
# Copyright (C) 2013-2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

ARCH:=riscv32
BOARD:=v861-DshanPi_mCoreB_V881_5D8E
BOARDNAME:=DshanPi-mCoreB-V881-5D8E
FEATURES:=audio
CPU_TYPE:=c907
CPU_SUBTYPE:=rv32imafdcv
MAINTAINER:=Allwinner
CFLAGS:=-Os -pipe -mcpu=c907fdv-rv32

KERNEL_PATCHVER:=6.6
UBOOT_PATCHVER:=2023
KERNELNAME:=Image.gz dtbs

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES:=base-files libc libgcc busybox
TARGET_CFLAGS += -D_GNU_SOURCE -D_LARGEFILE64_SOURCE -D__USE_TIME_BITS64 -D_FILE_OFFSET_BITS=64 -funwind-tables -Wno-unused-but-set-variable -Wno-unused-variable \
    -Wno-unused-function -Wno-unused-label -Wno-unused-const-variable -Wno-comment -Wno-unused-value

#-DUSE_STD_LOG
TARGET_CXXFLAGS += -std=c++11 -fno-rtti
TARGET_LDFLAGS += -Wl,-rpath=/usr/lib

$(eval $(call BuildTarget))
