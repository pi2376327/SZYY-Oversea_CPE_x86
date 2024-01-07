#!/bin/sh

DATE=`date +%Y-%m-%d-%H:%M:%S`

function exist_tun0(){
       ip addr show tun0 > /dev/null 2>&1
       return $?
}

if ! exist_tun0;then
    echo tun0 not exist,restart openvpn >/root/script/openvpn_watchdog.log
    /etc/init.d/openvpn restart
    exit 0
else             
    #check gateway of vpn
    tries=0
    gw=$(ip addr show tun0 | grep 'inet ' | cut -d' ' -f6 | cut -d'.' -f1-3).1
    echo  $DATE: Start to check gateway of vpn-tun0
    echo  $DATE: Start to check gateway of vpn-tun0 >/root/script/openvpn_watchdog.log
    while [[ $tries -lt 5 ]]
    do
        if /bin/ping -c 1 $gw >/dev/null
        then
                echo $DATE: Gateway is OK
                echo $DATE: Exit
                echo $DATE: Gateway is OK >> /root/script/openvpn_watchdog.log
                exit 0
        fi
        tries=$((tries+1))
        sleep 10
        echo $DATE: tries: $tries
        echo $DATE: tries: $tries >> /root/script/openvpn_watchdog.log
    done

    echo $DATE: openvpn restart
    echo $DATE: openvpn restart >> /root/script/openvpn_watchdog.log
    /etc/init.d/openvpn restart

    #echo $DATE reboot >> /root/script/openvpn_watchdog.log
    #reboot
fi
