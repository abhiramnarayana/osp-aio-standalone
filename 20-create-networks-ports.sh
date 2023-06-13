#!/bin/bash


export OS_CLOUD=standalone

#openstack flavor create --id 20 --ram 4096 --disk 8 --vcpus 4 --public   --property hw:mem_page_size=large   --property hw:cpu_policy=dedicated   --property hw:emulator_threads_policy=share   dpdk.small

OS_COMPUTE_API_VERSION=2.79  # Mandatory when we use a newer version of nova osc
openstack quota set --cores -1 --ram -1 admin
SG=$(openstack security group list --project admin -c ID -f value)
openstack security group rule list -c ID -f value | xargs openstack security group rule delete
openstack security group set --stateless $SG
# openstack security group set --stateful $SG
openstack security group rule create --egress --remote-ip 0.0.0.0/0 $SG
openstack security group rule create --egress --ethertype IPv6 --remote-ip ::/0 $SG
openstack security group rule create --protocol icmp $SG
openstack security group rule create $SG --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0
openstack security group rule create $SG --protocol tcp --remote-ip 0.0.0.0/0
openstack security group rule create $SG --protocol udp --remote-ip 0.0.0.0/0


openstack security group create --stateful sg_mgmt
openstack security group rule create sg_mgmt --protocol tcp --dst-port 22:22 --remote-ip 0.0.0.0/0

openstack network create --external --provider-network-type vlan --provider-segment 105 --provider-physical-network datacentre datacentre-105
openstack subnet create --network datacentre-105 --ip-version 4 --subnet-range 192.168.105.0/24  --gateway 192.168.105.254  --dhcp subnet-datacentre-105
openstack network create --external --provider-network-type vlan --provider-segment 108 --provider-physical-network datacentre datacentre-108
openstack subnet create --network datacentre-108 --ip-version 4 --subnet-range 192.168.108.0/24  --gateway 192.168.108.254  --dhcp subnet-datacentre-108

openstack network create  --provider-network-type vlan --provider-segment 106 --provider-physical-network datacentre datacentre-106
openstack subnet create --network datacentre-106 --ip-version 4 --subnet-range 192.168.106.0/24 --dhcp subnet-datacentre-106
openstack network create  --provider-network-type vlan --provider-segment 107 --provider-physical-network datacentre datacentre-107
openstack subnet create --network datacentre-107 --ip-version 4 --subnet-range 192.168.107.0/24 --dhcp subnet-datacentre-107

openstack router create router1
openstack router add subnet router1 subnet-datacentre-106
openstack router add subnet router1 subnet-datacentre-105

openstack router create router2
openstack router add subnet router2 subnet-datacentre-107
openstack router add subnet router2 subnet-datacentre-108

openstack subnet set --host-route destination=192.168.108.0/24,gateway=192.168.107.1 subnet-datacentre-107
openstack subnet set --host-route destination=192.168.105.0/24,gateway=192.168.106.1 subnet-datacentre-106

