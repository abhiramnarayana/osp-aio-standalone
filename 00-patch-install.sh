#!bin/bash

sed -i 's/openvswitch2.17/openvswitch3.1/' /usr/share/ansible/roles/tripleo_bootstrap/vars/redhat-9.yml 

rpm --nodeps -e openvswitch2.17
rpm --nodeps -e rhosp-openvswitch-2.17-5.el9ost.noarch
dnf install -y openvswitch3.1
systemctl enable --now openvswitch

THT="/usr/share/openstack-tripleo-heat-templates/deployment"
sudo sed -i 's/\/run\/:\/run\//\/run:\/run/g' $THT/cinder/cinder-common-container-puppet.yaml
sudo sed -i 's/\/run\/:\/run\//\/run:\/run/g' $THT/deprecated/multipathd-container.yaml
sudo sed -i 's/\/run\/:\/run\//\/run:\/run/g' $THT/manila/manila-share-common.yaml
sudo sed -i 's/\/run\/:\/run\//\/run:\/run/g' $THT/unbound/unbound-container-ansible.yaml
