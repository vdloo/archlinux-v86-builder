#!/bin/sh

# build the boxfile from the iso
(cd packer && packer build -force template.json)

# test if there is a boxfile where we expected it
if [ ! -f packer/output-qemu/Archlinux-v86 ]; then
    echo "Looks like something went wrong building the image, maybe try again?"
    exit 1
fi;
