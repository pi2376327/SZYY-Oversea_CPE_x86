#!/bin/sh

DATE=`date +%Y-%m-%d-%H:%M:%S`
tries=0
echo  $DATE: Start to check gateway of vpn-tun0
echo  $DATE: Start to check gateway of vpn-tun0 >>openvpn_watchdog.log
while [[ $tries -lt 5 ]]
do
        if /bin/ping -c 1 172.30.0.1 >/dev/null
        then
                echo $DATE: Gateway is OK
                echo $DATE: Exit
                echo $DATE: Gateway is OK >> openvpn_watchdog.log
                exit 0
        fi
        tries=$((tries+1))
        sleep 10
        echo $DATE tries: $tries
        echo $DATE tries: $tries >> openvpn_watchdog.log
done

echo $DATE openvpn restart
echo $DATE openvpn restart >> openvpn_watchdog.log
/etc/init.d/openvpn restart

#echo $DATE reboot >> openvpn_watchdog.log
#reboot
