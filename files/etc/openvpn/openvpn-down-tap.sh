#!/bin/bash

####################################
# Tear Down Ethernet bridge on Linux
####################################

# Define Bridge Interface
br="br0"

# Define list of TAP interfaces to be bridged together
tap="tap0"
eth="eth1 eth2 eth3"

ip link set $br down
brctl delbr $br

for t in $tap; do
    openvpn --rmtun --dev $t
done

for e in $eth; do
    brctl addif br-lan $e
done
