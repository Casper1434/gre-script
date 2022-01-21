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
sudo ip addr add 10.0.0.2/30 dev gre1
sudo ip link set gre1 up
sudo echo '100 GRE' >> /etc/iproute2/rt_tables
sudo ip rule add from 10.0.0.0/30 table GRE
sudo ip route add default via 10.0.0.1 table GRE