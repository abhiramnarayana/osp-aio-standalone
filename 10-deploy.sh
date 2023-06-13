#!/bin/bash
export SMDEV_CONTAINER_OFF=1
unset OS_CLOUD
sudo rm -f /run/.containerenv

sudo -E openstack tripleo deploy \
  --templates \
  --local-ip=192.168.2.190/24 \
  --control-virtual-ip 192.168.2.250 \
  --deployment-user christophefontaine \
  --local-domain mgmt.foobar.space \
  -r $(pwd)/StandaloneDpdkSriov.yaml \
  -n /usr/share/openstack-tripleo-heat-templates/network_data_undercloud.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/standalone/standalone-tripleo.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovn-standalone.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovn-dpdk.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/services/neutron-ovn-sriov.yaml \
  -e /usr/share/openstack-tripleo-heat-templates/environments/low-memory-usage.yaml \
  -e $(pwd)/local_registry_images.yaml \
  -e $(pwd)/containers-prepare-parameters.yaml \
  -e $(pwd)/standalone_parameters.yaml \
  -e $(pwd)/rhsm-private.yaml \
  --output-dir /home/christophefontaine \
  $@

# Subscription manager doesn't work because of
# https://bugs.launchpad.net/tripleo/+bug/1995237
sudo rm -f /run/.containerenv
