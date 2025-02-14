#!/bin/bash
#################################
# Set up Ethernet bridge on Linux
# Requires: bridge-utils
#################################

# Define Bridge Interface
br="br0"

# Define list of TAP interfaces to be bridged,
# for example tap="tap0 tap1 tap2".
tap="tap0"

# Define list of eth interfaces to be bridged,
# for example eth="eth0 eth1 eth2".
eth="eth1 eth2 eth3"

# Create the tap adapter
for t in $tap; do
    openvpn --mktun --dev $t
done

# Create the bridge and add interfaces
brctl addbr $br
for t in $tap; do
    brctl addif $br $t
done
for e in $eth; do
    brctl delif br-lan $e
done
for e in $eth; do
    brctl addif $br $e
done

# Configure the bridge
for t in $tap; do
    ip link set $t promisc on
done
for e in $eth; do
    ip link set $e promisc on
done

ip address add 172.19.0.10/24 dev $br
