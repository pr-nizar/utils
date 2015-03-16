#!/bin/bash

# A little script to install Orchis GTK theme, Faba Icon theme and Macbuntu Yosemite Cursors theme
# Copyright goes to owners; links:
# http://mokaproject.com/orchis-gtk-theme/
# http://mokaproject.com/faba-icon-theme
# http://www.noobslab.com/2014/11/mbuntu-macbuntu-1410-transformation.html

# Inspired by https://oduso.com

echo "
------------------
Here we go...
------------------
"
echo -e '\e[32mThis might take a while. Just relax and sit tight.\n\e[39m'

sleep 2

echo "Verifying target folders."
(
	mkdir -p ~/{.themes,.icons}
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m';

echo "Downloading and extracting Orchis GTK theme"
(
	wget -qO- https://github.com/moka-project/orchis-gtk-theme/raw/master/orchis-gtk-theme-3.0.tar.gz \
	| tar xvz --strip-components=1 -C ~/.themes orchis-gtk-theme-3.0/Orchis
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m';

echo "Downloading and extracting Faba icon theme"
(
	wget -qO- https://github.com/moka-project/faba-icon-theme/raw/master/faba-icon-theme-4.0.tar.gz \
	| tar xvz --strip-components=1 -C ~/.icons faba-icon-theme-4.0/Faba
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m';

echo "Downloading and extracting cursors from Macbuntu Yosemite theme"
(
	wget -qO- https://launchpad.net/~noobslab/+archive/ubuntu/themes/+files/mbuntu-y-icons-v4_3.12-d~trusty~NoobsLab.com.tar.gz  \
	| tar  xvz --strip-components=1 -C ~/.icons MBuntu-Y-icons/mac-cursors
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m';

echo "Updating icon cache for Faba icon theme"
(
	gtk-update-icon-cache ~/.icons/Faba/
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m';

echo "Updating settings"
(
	if [ $XDG_CURRENT_DESKTOP = 'XFCE' ] ; then
		xfconf-query -c xsettings -p /Net/IconThemeName -s 'Faba'
		xfconf-query -c xsettings -p /Net/ThemeName -s 'Orchis'
		xfconf-query -c xsettings -p /Gtk/CursorThemeName -s 'mac-cursors'
	elif [ $XDG_CURRENT_DESKTOP = 'Unity' ] || [ $XDG_CURRENT_DESKTOP = 'GNOME' ]  ; then
		gsettings set org.gnome.desktop.interface icon-theme 'Faba'
		gsettings set org.gnome.desktop.interface gtk-theme 'Orchis'
		gsettings set org.gnome.desktop.wm.preferences theme 'Orchis'
		gsettings set org.gnome.desktop.interface cursor-theme 'mac-cursors'
	fi
) &> /dev/null && echo -e '\e[32mOK\e[39m' || echo -e '\e[31mFAILED\e[39m';
echo "
------------------
That's all folks..
------------------
"
notify-send "pr.nizar" "Finished installing themes\nBe sure to visit my blog at:\nhttp://pr-nizar.blogspot.com"
exit 0