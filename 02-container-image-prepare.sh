#!/bin/bash
openstack tripleo container image prepare --roles-file StandaloneDpdkSriov.yaml --environment-file containers-prepare-parameters.yaml --output-env-file local_registry_images.yaml
