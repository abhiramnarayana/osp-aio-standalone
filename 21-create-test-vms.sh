#!/bin/bash
export OS_CLOUD=standalone


openstack flavor create --id 20 --ram 16384 --disk 16 --vcpus 4 --public \
  --property hw:mem_page_size=large \
  --property hw:cpu_policy=dedicated \
  --property hw:emulator_threads_policy=share \
  dpdk.small


openstack image create rhel --container-format bare --disk-format qcow2 --file rhel-guest-image-9.2-20230414.17.x86_64.qcow2

openstack keypair create test >test.pem
chmod 600 test.pem

openstack server create --flavor dpdk.small --image rhel --key-name test --network datacentre-106 --network datacentre-107 dpdk

#openstack router add route --route destination=192.168.108.0/24,gateway=192.168.106.76 router1 
#openstack router add route --route destination=192.168.105.0/24,gateway=192.168.107.135 router2

