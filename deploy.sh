#!/bin/bash

# clean
sudo mn -c

# Lancer le contrôleur RYU en arrière-plan (assurez-vous du chemin vers ryu_controller.py)
ryu-manager ryu_controller.py --observe-links &

# Sleep so RYU controller have time to start
sleep 2

# Lancer la topologie Mininet (exécute network_topology.py qui démarre aussi les serveurs h1)
sudo python2 network_topology.py