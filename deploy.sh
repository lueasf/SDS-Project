#!/bin/bash

# Deploys the RYU controller in a new terminal for ubuntu
gnome-terminal -- bash -c "ryu-manager ryu_controller.py; exec bash"

# Deploys the network topology through mininet
sudo mn --custom network_topology.py --topo NetworkTopology --controller remote --switch ovsk --mac