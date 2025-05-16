#!/bin/bash

# launch ryu controller
ryu-manager ryu_controller_ddos_snort.py --observe-links &

# Sleep so RYU controller have time to start
sleep 2
gnome-terminal -- bash -c "sudo snort -i s1-snort -A unsock -l /tmp -c /etc/snort/snort.conf; exec bash"