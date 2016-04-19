# openshift-squid
Squid example for OpenShift Enterprise 3.1

# To use squid redirect route in iptables
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3129
