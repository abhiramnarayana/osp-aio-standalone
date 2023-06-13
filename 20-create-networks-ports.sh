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


openstack network create --external --default --provider-network-type vlan --provider-segment 201 --provider-physical-network homelab homelab
openstack subnet create --network homelab --ip-version 4 --subnet-range 192.168.201.0/24  --gateway 192.168.201.254  --dhcp subnet-homelab

openstack network create  --provider-network-type vlan --provider-segment 202 --provider-physical-network homelab homelab-202
openstack subnet create --network homelab-202 --ip-version 4 --subnet-range 192.168.202.0/24 --dhcp subnet-homelab-202
openstack network create  --provider-network-type vlan --provider-segment 203 --provider-physical-network homelab homelab-203
openstack subnet create --network homelab-203 --ip-version 4 --subnet-range 192.168.203.0/24 --dhcp subnet-homelab-203

openstack port create --network homelab --vnic-type direct p0-vf-a
openstack port create --network homelab2 --vnic-type direct p1-vf-a

#openstack port create --network homelab --hint ovs-tx-steering:hash vhu-hash

