#!/usr/bin/env bash

repo="$HOME/.dotfiles-setup"
install_pkglist() {
	PS3='Enter packages to install: '
	options=(".pkglist_base.txt" ".pkglist_full.txt")
	select opt in "${options[@]}"; do
		case $opt in
		".pkglist_base.txt")
			echo "Installing base packages"
			sudo pacman -S --needed --noconfirm - <"$repo/.pkglist_base.txt"
			break
			;;
		".pkglist_full.txt")
			echo "Installing full packages"
			sudo pacman -S --needed --noconfirm - <"$repo/.pkglist_full.txt"
			break
			;;
		*) echo "invalid option $REPLY" ;;
		esac
	done
}

dotfiles_setup() {
	install_pkglist
	git clone --separate-git-dir=$HOME/.dotfiles https://github.com/aminerwx/.dotfiles.git tmpdotfile
	rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
	rm -r tmpdotfiles
}

# TODO: handle .dotfiles
echo "######## dotfiles setup ########"
[ -d $repo ] && dotfiles_setup && rm -r $repo
