#!/bin/sh
clear

# edit /etc/pacman.conf file
nano /etc/pacman.conf

clear

# timezone
echo 'Example: Europe/Istanbul, Europe/Zurich, America/New_York'
read -p 'Timezone: ' time_zone
ln -sf /usr/share/zoneinfo/$time_zone /etc/localtime
hwclock --systohc

clear

read -p "Select locale [en/tr]: " localeset

if [ $localeset == "en" ];
then
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    touch /etc/vconsole.conf
    echo "KEYMAP=us" >> /etc/vconsole.conf
else
    echo "tr_TR.UTF-8 UTF-8" >> /etc/locale.gen
    locale-gen
    touch /etc/vconsole.conf
    echo "KEYMAP=trq" >> /etc/vconsole.conf
fi

clear

# host
read -p 'Hostname: ' host_name
echo $host_name >> /etc/hostname

echo '127.0.0.1       localhost' >> /etc/hosts
echo '::1             localhost' >> /etc/hosts
echo '127.0.1.1       '$host_name'.localdomain     '$host_name >> /etc/hosts

clear

# root password
echo 'Root password'
passwd

clear

# packages
pacman -Sy networkmanager
systemctl enable NetworkManager
sleep 2
clear

# touchpad support
pacman -S xf86-input-libinput
clear

# NTFS filesystem support
pacman -S ntfs-3g
clear

# GRUB
pacman -S grub efibootmgr os-prober
clear

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id='Arch Linux'
sleep 1
clear

grub-mkconfig -o /boot/grub/grub.cfg
sleep 3
clear

# useradd
read -p 'Username: ' user_name
clear
useradd -m -g users -G wheel,storage,power,audio,video,network -s /bin/bash $user_name
echo $user_name 'password'
passwd $user_name

# sudo privileges
EDITOR=nano visudo
clear
