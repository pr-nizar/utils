#!/bin/bash
# Installing Google Fonts on Ubuntu
# Original author: Michalis Georgiou <mechmg93@gmail.com>
# Inspired by Andrew (http://www.webupd8.org/2011/01/automatically-install-all-google-web.html)
# Modified by pr.nizar (http://pr-nizar.blogspot.com/2015/04/google-fonts-ubuntu.html#up)

# We wrap this whole script in a function, so that we won't execute until the entire script is downloaded.
run_it () {

# Set a special exit status to exit any level of subshell
set -E; trap '[ "$?" -ne 77 ] || exit 77' ERR


if ! which hg &>/dev/null ; then
# Mercurial was not found; install it?
	if (read -p "Mercurial is needed for installation. Do you want to install it now? [y/n] " ans ; [ "$ans" = Y -o "$ans" = y ]) ; then
		sudo apt-get install -y mercurial
	else
		exit 1
	fi
fi
# Mercurial was not found and installation was cancelled or something went wrong.
if ! which hg &>/dev/null ; then
	echo -e '\e[31mMercurial was not found. (Installation went wrong?)\e[39m'; exit 1
fi

_hgroot="https://googlefontdirectory.googlecode.com/hg/"
_hgrepo="googlefontdirectory"

clear;echo "Connecting to Mercurial server...."
if [ -d $_hgrepo ] ; then
	echo -e "------------------\nHere we go...\n------------------\n\e[32mUpdating the local clone: $PWD/$_hgrepo\e[39m"
	cd $_hgrepo
	hg pull -u || ( echo -e "\e[31mFailed to update local files.\nIf the problem persists remove the folder:\n$PWD/$_hgrepo\nor move to a new location then try again. \e[39m"; exit 77 )
	echo "The local files have been updated."
	cd ..
else
	echo -e "------------------\nHere we go...\n------------------\n\e[32mThis will take a long long long time. Just relax and sit tight.\nCloning the Google Fonts repository to: $PWD/$_hgrepo\e[39m"
	sleep 4
	hg  --debug -v clone $_hgroot $_hgrepo || (echo -e "\e[31mFailed to clone the repository to $PWD/$_hgrepo\e[39m"; exit 77 )
	echo "Finished cloning into: $PWD/$_hgrepo"
fi
echo '------------------'
PS3='Do you wish to install fonts globally or for the current user or exit? '
options=("Globally" "Current user" "Exit")
select opt in "${options[@]}"
do
	case $opt in
		"Globally") _sc='sudo'; _cc='install -m644'; _tf='/usr/share/fonts/truetype/googlefonts/'; break;;
		"Current user") _sc=''; _cc='cp'; _tf='~/.fonts/truetype/googlefonts/'; break;;
		"Exit") exit;;
        *) echo  -e  "\e[31mInvalid option; please choose (1), (2) or (3).\e[39m";;
    esac
done
echo -e "\e[32mCreating fonts folder at: $_tf\e[39m"
$_sc mkdir -p $_tf || ( echo -e "\e[31mFailed to create fonts folder.\e[39m"; exit 77 )
echo -e "\e[32mInstalling fonts.\e[39m"
find $PWD/$_hgrepo/ -name "*.ttf" -exec $_sc $_cc {} $_tf \; || ( echo -e "\e[31mFailed to install fonts.\e[39m"; exit 77 )
echo -e "\e[32mUpdating fonts cache.\e[39m"
fc-cache -f > /dev/null
echo -e "\e[32mDone.\e[39m"
echo -e "------------------\nThat's all folks"'!'"\n------------------"
if which notify-send &>/dev/null ; then
	notify-send "pr.nizar" "Finished installing Google Fonts\nBe sure to visit my blog at:\nhttp://pr-nizar.blogspot.com"
fi
exit 0
}

run_it