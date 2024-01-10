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

# Modify default IP
sed -i 's/192.168.1.1/192.168.150.1/g' package/base-files/files/bin/config_generate

#修改默认主机名
sed -i 's/OpenWrt/JYWX-CPE/g' package/base-files/files/bin/config_generate

#修改欢迎banner
#cat >package/base-files/files/etc/banner<<EOF
#EOF

#修改默认密码
sed -i '1c\root:$1$KFkimD6C$KSpEWi1IcwqWYrESv2fQy/:19074:0:99999:7:::' package/base-files/files/etc/shadow

#替换版本和名字，以及设备型号
sed -i 's/R23.3.3/R23.12.08/g' package/lean/default-settings/files/zzz-default-settings
sed -i 's/OpenWrt/JYWX-CPE/g' package/lean/default-settings/files/zzz-default-settings
#sed -i "/exit 0/i\sed -i \'s#Zbtlink ZBT-WG3526#JYWX-WIFI-4G#g\' \/proc\/cpuinfo" >>  package/lean/default-settings/files/zzz-default-settings

#更改默认主题
sed -i 's/luci-theme-bootstrap/luci-theme-argon/' feeds/luci/collections/luci/Makefile

#增加vpn0\wg0\4G_LTE\gre接口,更改wan\lan的默认物理接口
#Ovpn
sed -i "/exit 0/i\uci set network.vpn0=interface" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.vpn0.ifname=\'tun0\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.vpn0.proto=\'none\'" package/lean/default-settings/files/zzz-default-settings
#genarate wireguard-key
sed -i "/exit 0/i\if \! test -d \/etc\/wireguard;then mkdir -p \/etc\/wireguard;fi" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\mkdir \/etc\/wireguard  && wg genkey | tee \/etc\/wireguard\/privatekey | wg pubkey > \/etc/wireguard\/publickey" package/lean/default-settings/files/zzz-default-settings
#wireguard
sed -i "/exit 0/i\uci set network.wg0=interface" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0.proto=\'wireguard\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0.private_key=\$(cat \/etc\/wireguard\/privatekey)" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0.listen_port=\'51820\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0.addresses=\'172.31.1.1\/30\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0.mtu=\'1440\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0.nohostroute=\'1\'" package/lean/default-settings/files/zzz-default-settings
#wireguard peer
sed -i "/exit 0/i\uci set network.wg0_peer1=wireguard_wg0" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0_peer1.public_key=\$(cat \/etc\/wireguard\/publickey)"
sed -i "/exit 0/i\uci set network.wg0_peer1.endpoint_host=\'172.30.8.11\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0_peer1.persistent_keepalive=\'25\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0_peer1.endpoint_port=\'51820\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wg0_peer1.allowed_ips=\'172.31.0.0\/30\'" package/lean/default-settings/files/zzz-default-settings 
#gre
sed -i "/exit 0/i\uci set network.gre=interface" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre.ipaddr=\'172.30.4.12\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre.peeraddr=\'172.30.8.11\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre.mtu=\'1440\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre.proto=\'gre\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre.nohostroute=\'1\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre.zone=\'vpn\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre_tun=\'interface\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre_tun.proto=\'static\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre_tun.ifname=\'@gre\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre_tun.ipaddr=\'172.31.0.1\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.gre_tun.netmask=\'255.255.255.252\'" package/lean/default-settings/files/zzz-default-settings
#wan\lan physic interface
sed -i "/exit 0/i\uci set network.lan.ifname=\'eth1 eth2 eth3\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wan.ifname=\'eth0\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set network.wan6.ifname=\'eth0\'" package/lean/default-settings/files/zzz-default-settings
#confirm configuration
sed -i "/exit 0/i\uci commit network" package/lean/default-settings/files/zzz-default-settings

#更改ssh、web默认端口
sed -i "/exit 0/i\uci set dropbear\.\@dropbear\[0\]\.Port=\'24680\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci delete dropbear\.\@dropbear\[0\]\.Interface" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci commit dropbear" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set uhttpd.main.listen_http=\'0.0.0.0:24681\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci set uhttpd.main.listen_https=\'0.0.0.0:24682\'" package/lean/default-settings/files/zzz-default-settings
sed -i "/exit 0/i\uci commit uhttpd" package/lean/default-settings/files/zzz-default-settings 

#添加文件权限
sed -i "/exit 0/i\chmod +x /root/script/openvpn-watchdog.sh" package/lean/default-settings/files/zzz-default-settings

#增加crontab任务
sed -i "/exit 0/i\echo \'\*\/5 \* \* \* \* sh \/root\/script\/openvpn-watchdog\.sh\' >> \/etc\/crontabs\/root" package/lean/default-settings/files/zzz-default-settings
