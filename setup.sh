#!/bin/bash
# Author : Matt Flax <flatmax@flatmax.org>
# Date : 2016.07.08
# Copyright : Flatmax Pty Ltd

echo updating the kernel
sudo rpi-update -y

# check the device tree overlay is setup correctly ...
# firstly disable PWM audio
sudo bash -c "sed -i \"s/^\s*dtparam=audio/#dtparam=audio/\" /boot/config.txt"
# now check to see the correct device tree overlay is loaded ...
cnt=`grep -c audioinjector-wm8731-audio /boot/config.txt`
if [ "$cnt" -eq "0" ]; then
	sudo bash -c "echo '# enable the AudioInjector.net sound card
	dtoverlay=audioinjector-wm8731-audio' >> /boot/config.txt"
fi

# Author : Ilan Shachar <ishachar3@staff.haifa.ac.il>
# Date : 2021.12.01
# Copyright : ANL LAB

echo
echo The audio injector sound card is now setup.
echo Please reboot to enable the correct device tree.
echo
echo "Disable vc4 driver"
sudo bash -c "sed -i \"s/^\s*dtoverlay=vc4-kms-v3d/#dtoverlay=vc4-kms-v3d/\" /boot/config.txt"
echo "Setting up cronjobs"
echo
crontab /home/pi/crontab.txt
echo
echo "Setting up incron"
sudo apt-get install incron -y
echo
echo "Adding pi to allowed incron users"
echo "pi" | sudo tee /etc/incron.allow | grep 1
echo
echo "Adding incron jobs"
incrontab incron.table
echo
echo "Installing flac"
sudo apt-get install flac -y
echo "alias ll='ls -alF'" >> .bashrc
mkdir /home/pi/AUDIO
echo "setup rc.local for led activation"
cat /home/pi/rc_local | sudo tee /etc/rc.local | grep blah
