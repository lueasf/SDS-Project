#!/bin/bash

# add new link for snort
sudo ip link add name s1-snort type dummy
sudo ip link set s1-snort up

# clean
gnome-terminal -- bash -c "sudo mn -c; exec bash" &

# launch topology and servers
sudo python2 network_topology.py &

sleep 5

# adds the s1-snort link to switch s1
# need to check port if s1-snort is the same as in ryu_controller_ddos_snort.py!
gnome-terminal -- bash -c 'sudo ovs-vsctl add-port s1 s1-snort; sudo ovs-ofctl show s1; echo "[*] check if port of s1-snort is the same as ryu_controller_ddos_snort.py! Then exceute script part2"; exec bash'
