#!/bin/bash
export OS_CLOUD=standalone


openstack flavor create --id 20 --ram 4096 --disk 16 --vcpus 4 --public \
  --property hw:mem_page_size=large \
  --property hw:cpu_policy=dedicated \
  --property hw:emulator_threads_policy=share \
  dpdk.small

openstack image set --property hw_vif_multiqueue_enabled=true rhel9.2

openstack server create --flavor dpdk.small --image rhel9.2 --key-name cfontain --network homelab homelab-vhu-rhel

openstack server create --flavor dpdk.small --image rhel9.2 --key-name cfontain --port p0-vf-a homelab-vf-rhel
openstack server create --flavor dpdk.small --image rhel9.2 --key-name cfontain --port p1-vf-a homelab2-vf-rhel --config-drive True


cat >subscription-manager <<EOF
#!/bin/sh
curl --insecure --output katello-ca-consumer-latest.noarch.rpm https://satellite.mgmt.foobar.space/pub/katello-ca-consumer-latest.noarch.rpm
dnf install -y katello-ca-consumer-latest.noarch.rpm
subscription-manager register --org=Foobar --activationkey=RHEL9
dnf update -y
dnf install -y dpdk tuned-profiles-cpu-partitioning driverctl
EOF

openstack server create --flavor osp.xl --image rhel9.2 --key-name cfontain --network homelab --network homelab-202 --network homelab-203 --user-data subscription-manager dpdk
