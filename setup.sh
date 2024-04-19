#!/usr/bin/env bash

[[ $SUDO_USER ]] && user="home/$SUDO_USER" || user=$HOME
# handle systemd-boot entries

#echo "######## Systemd-boot ########"
#PARTITION_NAME=$(lsblk | awk '$7 == "/" {print $1}' - | grep -o "\w*")

root_partition="/dev/$(lsblk | awk '$7 == "/" {print $1}' - | grep -o "\w*")"
#echo $root_partition

# /boot/loader/entries/arch.conf
sysboot_entries() {
	root_uuid="root=$(lsblk -no UUID $root_partition)"
	cat >arch.conf <<EOF
title Archlinux
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initrmfs-linux.img
options $root_uuid rw nvidia-drm.modeset=1 nvidia-drm.fbdev=1 quiet splash acpi_enforce_resources=lax
EOF

	cat >arch-fallback.conf <<EOF
title Archlinux (fallback initramfs)
linux /vmlinuz-linux
initrd /amd-ucode.img
initrd /initrmfs-linux-fallback.img
options $root_uuid
EOF
	printf "Successfully generated boot entries:\n\tarch.conf\n\tarch-fallback.conf\n"
}

ufw_setup() {
	systemctl start ufw.service
	systemctl enable ufw.service
	ufw deny all 2>/dev/null
	ufw limit ssh 2>/dev/null
	ufw allow from 192.168.1.0/24 2>/dev/null
}

dotfiles_setup() {
	[[ ! -f "/usr/bin/rsync" ]] && $(sudo pacman -S rsync --needed --noconfirm)
	rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
	rm -r tmpdotfiles
	PS3='Enter packages to install: '
	options=(".pkglist_base.txt" ".pkglist_full.txt")
	select opt in "${options[@]}"; do
		case $opt in
		".pkglist_base.txt")
			echo "Installing base packages"
			sudo pacman -S --needed --noconfirm - <"$HOME/.pkglist_base.txt"
			break
			;;
		".pkglist_full.txt")
			echo "Installing full packages"
			sudo pacman -S --needed --noconfirm - <"$HOME/.pkglist_full.txt"
			break
			;;
		*) echo "invalid option $REPLY" ;;
		esac
	done
}

# TODO: handle .dotfiles
echo "######## dotfiles setup ########"
[ -d "$user/tmpdotfiles" ] && dotfiles_setup

# [[ ! -z $root_partition ]] && sysboot_entries

# [[ -f "/usr/bin/ufw" ]] && ufw_setup

# . "$user/other.sh"
