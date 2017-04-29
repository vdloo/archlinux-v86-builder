#!/bin/bash
echo "Creating a GPT partition on /dev/sda1"
echo -e "g\nn\n\n\n\nw" | fdisk /dev/sda

echo "Formatting /dev/sda1 to ext4"
mkfs -t ext4 /dev/sda1

echo "Mounting new filesystem"
mount -t ext4 /dev/sda1 /mnt

echo "Performing pacstrap"
pacstrap -i /mnt base --noconfirm

echo "Writing fstab"
genfstab -p /mnt >> /mnt/etc/fstab

echo "Ensuring root autologin on tty1"
mkdir -p /mnt/etc/systemd/system/getty@tty1.service.d
cat << EOF > /mnt/etc/systemd/system/getty@tty1.service.d/override.conf
[Service]
ExecStart=
ExecStart=-/usr/bin/agetty --autologin root --noclear %I $TERM
EOF

echo "Writing the installation script"
cat << EOF > /mnt/bootstrap.sh
#!/usr/bin/bash
echo "Installing the grub package"
pacman -S os-prober grub --noconfirm

echo "Setting grub timeout to 0 seconds"
sed -i 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub

echo "Installing bootloader"
grub-install --target=i386-pc --recheck /dev/sda --force

echo "Writing grub config"
grub-mkconfig -o /boot/grub/grub.cfg
sync
EOF

echo "Chrooting and bootstrapping the installation"
arch-chroot /mnt bash bootstrap.sh

umount -R /mnt
