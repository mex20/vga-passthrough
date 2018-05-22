#!/bin/bash

#wget https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/virtio-win.iso

wget http://de.archive.ubuntu.com/ubuntu/pool/universe/e/edk2/qemu-efi_0~20180503.ebafede9-1_all.deb -O /tmp/ovmf.deb

dpkg -i /tmp/ovmf.deb

apt-get install -y build-essential uuid-dev iasl git gcc g++ nasm qemu-system-x86 qemu-utils bridge-utils qemu-kvm virtinst libvirt-clients libvirt-daemon-system virt-manager qemu-efi libvirt-bin libvirt0

sed -i -e 's/(GRUB_CMDLINE_LINUX_DEFAULT=.*)"/\1 modprobe.blacklist=nouveau iommu=1 amd_iommu=on rd.driver.pre=vfio-pci"/' /etc/default/grub


sed -e "s/kvm_intel/kvm_amd/g" /etc/modprobe.d/qemu-system-x86.conf

touch /etc/modprobe.d/local.conf

cat > /etc/modprobe.d/local.conf <<EOF
options vfio-pci ids=10de:1b81,10de:10f0
EOF

update-grub

cat > /etc/initramfs-tools/modules <<EOF
vfio
vfio_iommu_type1
vfio_pci
vfio_virqfd
vhost-net
EOF

update-initramfs -u

