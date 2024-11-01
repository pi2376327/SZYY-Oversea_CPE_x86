#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

#if [ ! -d /etc/uci-defaults ];then
#        mkdir -p /etc/uci-defaults
#fi
#cat <<EOF > /etc/uci-defaults/99-custom
#EOF

#下载frp
#git clone https://github.com/kuoruan/openwrt-frp.git package/frp

#openwrt #CONFIG_PACKAGE_luci-theme-argon=y
git clone https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
