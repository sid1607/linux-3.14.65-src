#!/bin/bash
sudo make modules_install
sudo cp arch/x86_64/boot/bzImage /boot/vmlinuz-linux31465ARCH
sudo mkinitcpio -k /boot/vmlinuz-linux31465ARCH -c /etc/mkinitcpio.conf -g /boot/initramfs-linux31465ARCH.img
sudo cp /boot/System.map /boot/System.map-linux31465ARCH
sudo ln -sf /boot/System.map-linux31465ARCH /boot/System.map
