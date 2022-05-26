# may/26/2022 17:00:50 by RouterOS 6.47.10
# software id = IIXQ-DFGH5
#
# model = RB750Gr3
# serial number = D5030F3VFD
/interface bridge
add name="bridgeLAN " vlan-filtering=yes
add name=bridgeWAN
/interface vlan
add interface="bridgeLAN " name=vlan10 vlan-id=10
add interface="bridgeLAN " name=vlan20 vlan-id=20
add interface="bridgeLAN " name=vlan30 vlan-id=30
/interface list
add name=WANs
add name=LANs
add name=VLANs
/ip pool
add name=dhcp_pool0 ranges=10.0.0.2-10.0.0.254
add name=dhcp_pool4 ranges=10.0.10.2-10.0.10.254
add name=dhcp_pool5 ranges=10.0.20.2-10.0.20.254
add name=dhcp_pool6 ranges=10.0.30.2-10.0.30.254
/ip dhcp-server
add address-pool=dhcp_pool0 disabled=no interface="bridgeLAN " name=dhcp1
add address-pool=dhcp_pool4 disabled=no interface=vlan10 name=dhcp2
add address-pool=dhcp_pool5 disabled=no interface=vlan20 name=dhcp3
add address-pool=dhcp_pool6 disabled=no interface=vlan30 name=dhcp4
/interface bridge port
add bridge=bridgeWAN interface=ether1
add bridge="bridgeLAN " interface=ether2
add bridge="bridgeLAN " interface=ether3
add bridge="bridgeLAN " interface=ether4
add bridge="bridgeLAN " interface=ether5 pvid=30
/interface bridge vlan
add bridge="bridgeLAN " tagged="ether1,ether2,ether3,ether4,bridgeLAN " \
    untagged=ether5 vlan-ids=30
add bridge="bridgeLAN " tagged=ether5 untagged=\
    "ether1,ether2,ether3,ether4,bridgeLAN " vlan-ids=10,1,20
/interface list member
add interface=bridgeWAN list=WANs
add interface="bridgeLAN " list=LANs
add interface=vlan10 list=VLANs
add interface=vlan20 list=VLANs
add interface=vlan30 list=VLANs
/ip address
add address=10.0.0.1/24 interface="bridgeLAN " network=10.0.0.0
add address=10.0.10.1/24 interface=vlan10 network=10.0.10.0
add address=10.0.20.1/24 interface=vlan20 network=10.0.20.0
add address=10.0.30.1/24 interface=vlan30 network=10.0.30.0
/ip dhcp-client
add disabled=no interface=bridgeWAN
/ip dhcp-server network
add address=10.0.0.0/24 dns-server=8.8.8.8,8.8.4.4 gateway=10.0.0.1
add address=10.0.10.0/24 gateway=10.0.10.1
add address=10.0.20.0/24 gateway=10.0.20.1
add address=10.0.30.0/24 gateway=10.0.30.1
/ip dns
set allow-remote-requests=yes servers=8.8.8.8,8.8.4.4
/ip firewall filter
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=accept chain=forward comment="Regla Establecido relacionado" \
    connection-state=established,related
add action=accept chain=forward comment="Aceptar de WANs a VLANs" \
    in-interface-list=WANs out-interface-list=VLANs
add action=accept chain=forward comment="Aceptar de VLANs a WANs" \
    in-interface-list=VLANs out-interface-list=WANs
add action=drop chain=forward comment="Denegar De VLANs a cualquier otro" \
    disabled=yes in-interface-list=VLANs
add action=drop chain=input comment="Denegar De VLANs a Mikrotik" disabled=\
    yes in-interface-list=VLANs
/ip firewall nat
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=passthrough chain=unused-hs-chain comment=\
    "place hotspot rules here" disabled=yes
add action=masquerade chain=srcnat out-interface-list=WANs
