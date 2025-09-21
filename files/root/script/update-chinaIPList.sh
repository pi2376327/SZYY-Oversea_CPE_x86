#!/bin/sh
  
DATE=`date +%Y-%m-%d-%H:%M:%S`

if [ ! -d /root/script ];then
        mkdir -p /root/script
fi

#Create tmp directory and download source file of IPs
mkdir -p /tmp/china-ip/
wget -P /tmp/china-ip/ https://raw.githubusercontent.com/metowolf/iplist/master/data/special/china.txt

if [ ! -f /tmp/china-ip/china.txt ];then
        echo $DATE: IPS file download failed, EXIT !
        exit 0
else
        echo $DATE: IPs file download successful.
        #Delete empty row
        grep -vE '^#|^&}' /tmp/china-ip/china.txt  > /tmp/china-ip/ip.txt

        #Convert to ipse format and move to directory of openvpn
        sed -i 's/^/add chnroute /g' /tmp/china-ip/ip.txt
        mv -f /tmp/china-ip/ip.txt /root/script/chnroute-ipset
        echo $DATE: Format conversion done

        #Add private IPs to ipset list
        echo "add chnroute 10.0.0.0/8" >> /root/script/chnroute-ipset
        echo "add chnroute 172.16.0.0/12" >> /root/script/chnroute-ipset
        echo "add chnroute 192.168.0.0/16" >> /root/script/chnroute-ipset
        echo $DATE: Add private networks to ipset seccessfully

        #Reload new ipset list
        ipset flush chnroute
        ipset restore -f /root/script/chnroute-ipset
        echo $DATE: loading ipset list successfully

        #Delete tmp
        rm -rf /tmp/china-ip

        echo '---------------------------------------------------------------------------' > /root/script/update.log
        echo $DATE: Update ipset list from github completely at `date +%Y-%m-%d` >> /root/script/update.log
        echo '---------------------------------------------------------------------------' >> /root/script/update.log
        exit 0
fi
