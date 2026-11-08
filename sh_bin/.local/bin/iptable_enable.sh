sudo iptables -I FORWARD -i waydroid0 -o wlan0 -j ACCEPT
sudo iptables -I FORWARD -i wlan0 -o waydroid0 -m state --state RELATED,ESTABLISHED -j ACCEPT
