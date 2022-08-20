#!/bin/sh
echo -n Aplicando Reglas de Firewall...
## FLUSH de reglas
iptables -F
iptables -X 
iptables -Z 
iptables -t nat -F
## Establecemos política por defecto
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT 
## Reglas de filtrado
# El localhost permitido (por ejemplo conexiones locales a mysql)
#iptables -A INPUT -i lo -j ACCEPT
# Permitir estos puertos desde Fuera
# http
iptables -A INPUT -p tcp --dport 80 -j DROP 
# https
iptables -A INPUT -p tcp --dport 443 -j DROP
# ssh
iptables -A INPUT -p tcp --dport 22 -j  ACCEPT 
#Maltrail
iptables -A INPUT -p tcp --dport 8338 -j DROP
#Elasticsearch
iptables -A INPUT -p tcp --dport 9200 -j DROP 
#Kibana
iptables -A INPUT -p tcp --dport 5601 -j DROP
# NO Permitir el Ping
iptables -A INPUT -p icmp -m icmp --icmp-type 8 -j DROP 
iptables -A OUTPUT -p icmp -m icmp --icmp-type 8 -j DROP
## Y ahora cerramos los accesos indeseados del exterior: 
# Nota: 0.0.0.0/0 significa: cualquier red
# Cerramos el rango de puerto bien conocido
iptables -A INPUT -s 0.0.0.0/0 -p tcp --dport 1:1024 -j DROP
iptables -A INPUT -s 0.0.0.0/0 -p udp --dport 1:1024 -j DROP 
echo " OK . Verifique que lo que se aplica con: iptables -L -n" 
# Fin del script
