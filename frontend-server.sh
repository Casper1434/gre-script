                                                                         
echo "Ipv4 of server A"
read a
echo "Ipv4 of server B"
read b
sudo modprobe ip_gre
lsmod | grep gre
sudo apt install iptables iproute2
sudo echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
sudo sysctl -p
sudo ip tunnel add gre1 mode gre local $a remote $b ttl 255
sudo ip addr add 10.0.0.1/30 dev gre1
sudo ip link set gre1 up
iptables -t nat -A POSTROUTING -s 10.0.0.0/30 ! -o gre+ -j SNAT --to-source $a
sudo iptables -A FORWARD -d 10.0.0.2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A FORWARD -s 10.0.0.2 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
echo "I confirm I have setup the GRE Tunnel on server B (If not, this can brake the code)"
read confirm
sudo iptables -t nat -A PREROUTING -d $a -p tcp -m tcp --dport 80 -j 80 --to-destination 10.0.0.2