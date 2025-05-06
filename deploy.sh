#!/bin/bash

# === CONFIGURATION ===
RULES_FILE="Myrules.rules"
RULES_DEST="/etc/snort/rules"
SNORT_CONF="/etc/snort/snort.conf"
INCLUDE_LINE="include \$RULE_PATH/$RULES_FILE"
DISABLE_LINE="include \$RULE_PATH/icmp-info.rules"

# === Copy custom Snort rules ===
echo "[*] Installing custom Snort rules..."
sudo cp "$RULES_FILE" "$RULES_DEST"

# === Add custom include line if not already present ===
echo "[*] Checking if custom rule is already included in snort.conf..."
if ! grep -Fxq "$INCLUDE_LINE" "$SNORT_CONF"; then
    echo "[*] Adding custom rule include to snort.conf..."
    echo "$INCLUDE_LINE" | sudo tee -a "$SNORT_CONF"
else
    echo "[*] Custom rule already included. Skipping."
fi

# === Comment out icmp-info.rules if enabled ===
echo "[*] Disabling icmp-info.rules in snort.conf if present..."
sudo sed -i "/^$DISABLE_LINE/ s/^/#/" "$SNORT_CONF"

# Deploys the RYU controller in a new terminal for ubuntu
gnome-terminal -- bash -c "ryu-manager ryu_controller.py; exec bash"

# Sleep so RYU controller have time to start
sleep 2

# === Create and activate dummy interface for Snort ===
echo "[*] Creating dummy interface s1-snort..."
sudo ip link add name s1-snort type dummy 2>/dev/null || echo "[*] Interface s1-snort already exists."
sudo ip link set s1-snort up

# Deploys the network topology through mininet
sudo mn --custom network_topology.py --topo NetworkTopology --controller remote --switch ovsk --mac

# Wait for Mininet to fully start before adding ports
sleep 3

# === Add dummy interface to OVS switch s1 ===
echo "[*] Adding dummy interface s1-snort to switch s1..."
sudo ovs-vsctl add-port s1 s1-snort


# === Start Snort in a new terminal for ubuntu ===
echo "[*] Starting Snort..."
echo "[*] Starting Snort in a new terminal window..."
gnome-terminal -- bash -c "echo '[*] Starting Snort on s1-snort...'; sudo snort -i s1-snort -A unsock -l /tmp -c /etc/snort/snort.conf; exec bash"
