#!/usr/bin/env bash

repo="$HOME/.dotfiles-setup"
install_pkg() {
	PS3='Enter packages to install: '
	pkg_base=(
		'git'
		'neovim'
		'ttf-jetbrains-mono-nerd'
		'noto-fonts'
		'fastfetch'
		'alacritty'
		'base-devel'
		'bash-completion'
		'firefox'
		'lazygit'
		'man-db'
		'man-pages'
		'ripgrep'
		'rsync'
		'sudo'
		'tree'
		'alacritty'
		'base-devel'
		'bash'
		'bash-completion'
		'btop'
		'fastfetch'
	)

	pkg_full=(
		'git'
		'go'
		'btop'
		'neovim'
		'lazygit'
		'treesitter'
		'keepassxc'
		'lutris'
		'man-db'
		'man-pages'
		'noto-fonts'
		'nvidia'
		'nvidia-settings'
		'nvidia-utils'
		'base-devel'
		'bash-completion'
		'postgresql'
		'fastfetch'
		'firefox'
		'ripgrep'
		'rsync'
		'solaar'
		'sudo'
		'tree'
		'ttf-jetbrains-mono-nerd'
		'ufw'
		'yt-dlp'
	)

	options=("pkglist_base.txt" "pkglist_full.txt")
	select opt in "${options[@]}"; do
		case $opt in
		"pkglist_base.txt")
			echo "Installing base packages"
			sudo pacman -S --needed --noconfirm "${pkg_base[@]}"
			break
			;;
		"pkglist_full.txt")
			echo "Installing full packages"
			sudo pacman -S --needed --noconfirm "${pkg_full[@]}"
			break
			;;
		*) echo "invalid option $REPLY" ;;
		esac
	done
}

dotfiles_setup() {
	mkdir tmpdotfiles
	git clone --separate-git-dir="$HOME/.dotfiles https://github.com/aminerwx/.dotfiles.git" tmpdotfiles
	rsync --recursive --verbose --exclude '.git' "tmpdotfiles/" "$HOME/"
	rm -rf tmpdotfiles
}

# TODO: handle .dotfiles
echo "######## dotfiles setup ########"

install_pkg
dotfiles_setup
