#!/bin/sh

# build the boxfile from the iso
(cd packer && packer build -force template.json)

# test if there is a boxfile where we expected it
if [ ! -f packer/output-qemu/Archlinux-v86 ]; then
    echo "Looks like something went wrong building the image, maybe try again?"
    exit 1
fi;

# clean up previous loops and mounts
echo "Making sure mountpoint is empty"
sudo umount diskmount -f || /bin/true
sudo kpartx -d /dev/loop0 || /bin/true
sudo losetup -d /dev/loop0 || /bin/true


# map the filesystem to json with fs2json
mkdir diskmount
echo "Mounting the created image so we can convert it to a p9 image"
sudo losetup /dev/loop0 packer/output-qemu/Archlinux-v86
sudo kpartx -a /dev/loop0
sudo mount /dev/mapper/loop0p1 diskmount

# clean up mount
echo "Cleaning up mounts"
sudo umount diskmount -f
sudo kpartx -d /dev/loop0
sudo losetup -d /dev/loop0

