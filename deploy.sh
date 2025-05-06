# Deploys the RYU controller running on the mininet
ryu-manager ryu_controller.py

# Deploys the network topology through mininet
sudo mn --custom network_topology.py --topo NetworkTopology --controller remote --switch ovsk --mac