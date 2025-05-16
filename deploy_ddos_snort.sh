#!/bin/bash

# clean
sudo mn -c

# add new link for snort
sudo ip link add name s1-snort type dummy
sudo ip link set s1-snort up

# launch ryu controller
ryu-manager ryu_controller_ddos_snort.py --observe-links &

# Sleep so RYU controller have time to start
sleep 2

# launch topology and servers
sudo python2 network_topology.py