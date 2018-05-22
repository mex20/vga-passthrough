#!/bin/bash

rmmod kvm_amd
modprobe kvm_amd

#verifying the setting, if everything was done right the output should be "Y"
echo "Verifying  nested VM capability:"
cat /sys/module/kvm_amd/parameters/nested

# Creating the windows hdd image change the size here for the total space you want available 
# for your windows installation
qemu-img create -f qcow2 \
  -o compat=1.1 -o cluster_size=65536 \
  -o preallocation=metadata -o lazy_refcounts=on \
/var/lib/libvirt/images/ovmf.windows.img 100G

virsh define ovmf.fedora.q35.template
