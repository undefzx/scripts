sudo iptables -I INPUT -s 206.111.0.0/16 -j DROP
sudo iptables -I FORWARD -s 206.111.0.0/16 -j DROP
sudo iptables -I INPUT -s 173.194.55.0/24 -j DROP
sudo iptables -I FORWARD -s 173.194.55.0/24 -j DROP
