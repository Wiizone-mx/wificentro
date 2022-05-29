# may/29/2022 10:54:15 by RouterOS 6.47.10
# software id = IIXQ-GHF5
#
# model = RB750Gr3
# serial number = D503HGDAFB38
/interface bridge
add name=bridgeLAN
add name=bridgeWAN
/interface ethernet
set [ find default-name=ether5 ] comment="ip 10.0.50.0/24 En este puerto"
/interface vlan
add interface=bridgeLAN name=vlan10 vlan-id=10
/interface list
add name=WANs
add name=LANs
add name=VLANs
/ip pool
add name=dhcp_pool0 ranges=10.0.0.2-10.0.0.254
add name=dhcp_pool1 ranges=10.0.10.2-10.0.10.254
add name=dhcp_pool2 ranges=10.0.50.2-10.0.50.254
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface=bridgeLAN name=dhcp1
add address-pool=dhcp_pool1 disabled=no interface=vlan10 name=dhcp2
add address-pool=dhcp_pool2 disabled=no interface=ether5 name=dhcp3
/interface bridge port
add bridge=bridgeWAN interface=ether1
add bridge=bridgeLAN interface=ether2
add bridge=bridgeLAN interface=ether3
add bridge=bridgeLAN interface=ether4
/interface list member
add interface=bridgeWAN list=WANs
add interface=bridgeLAN list=LANs
add interface=ether5 list=LANs
/ip address
add address=10.0.0.1/24 interface=bridgeLAN network=10.0.0.0
add address=10.0.10.1/24 interface=vlan10 network=10.0.10.0
add address=10.0.50.1/24 interface=ether5 network=10.0.50.0
/ip dhcp-client
add disabled=no interface=bridgeWAN
/ip dhcp-server network
add address=10.0.0.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=10.0.0.1
add address=10.0.10.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=10.0.10.1
add address=10.0.50.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=10.0.50.1
/ip firewall nat
add action=masquerade chain=srcnat out-interface-list=WANs
/system clock
set time-zone-name=America/Mexico_City
