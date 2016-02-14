#!/bin/bash

echo ' ################################################################'
echo ' # Script_Name: gns3-install.sh                                 #'
echo ' # Description: Perform an automated & custom install of GNS3   #'
echo ' # on ubuntu 14.04 LTS and 15.x                                 #'
echo ' # Date: FEB 2016                                               #'
echo ' # written by: Oystein                                          #'
echo ' # Web Site: https://github.com/I7CUD4/gns3-install             #'
echo ' # Version: 0.2                                                 #'
echo ' #                                                              #'
echo ' # Credits to: Jason C. Neumann. For his article on             #'
echo ' # how to install GNS3.                                         #'
echo ' #                                                              #'
echo ' # Disclaimer: Script provided AS IS. Use it at your own risk.  #'
echo ' #                                                              #'
echo ' ################################################################'
sleep 15

# Go to user directory & create GNS3 folder

echo '......................'
echo ''Moving to ~/$user''
echo '......................'
sleep 2
cd ~
sleep 5

#Create GNS3 folder to store and install files

echo '......................'
echo 'Creating GNS3 folder'
echo '......................'
sleep 2
mkdir GNS3
sleep 5

# Fetching current release updates and perform update on the system

cd ~
echo '..............................'
echo 'Installing updates on Ubuntu '
echo '..............................'
sleep 2
sudo apt-get -y update
sudo apt-get -y install git
sleep 5

# Download GNS3 files

echo '......................................................................'
echo 'Downloading gns3 server, gui, web, reg, iouyap, dynamips and iniparser'
echo '......................................................................'
sleep 2
cd ~/$user/GNS3
git clone git://github.com/GNS3/gns3-server.git
git clone git://github.com/GNS3/gns3-gui.git
git clone git://github.com/GNS3/gns3-web.git
git clone git://github.com/GNS3/gns3-registry.git
git clone git://github.com/GNS3/iouyap.git
git clone git://github.com/GNS3/dynamips.git
git clone git://github.com/ndevilla/iniparser.git
git clone git://github.com/GNS3/ubridge.git
wget "https://sourceforge.net/projects/vpcs/files/0.8/vpcs-0.8-src.tbz/download" -O vpcs-0.8-src.tbz
sleep 5

# Install GNS3 dependencies

echo '......................................'
echo 'Installing prereqs for compiling GNS3'
echo '......................................'
sleep 2
sudo apt-get -y install python3-setuptools python3-ws4py python3-netifaces
sudo apt-get -y install python3-zmq python3-tornado python3-dev python3.4-dev python3.5-dev 
sudo apt-get -y install libqt5webkit5-dev python3-pyqt5.qtsvg python3-pyqt5.qtwebkit
sudo apt-get -y install cmake libelf-dev uuid-dev libpcap-dev
sudo apt-get -y install libssl1.0.0:i386 bison flex cpulimit qemu
sleep 2
sudo ln -s /lib/i386-linux-gnu/libcrypto.so.1.0.0 /lib/libcrypto.so.4

# Install Virtualbox and Wireshark
# Comment out Virtualbox if you only need GNS-Server without GUI

echo '..................................'
echo 'Installing Virtualbox & Wireshark'
echo '..................................'
sleep 2
sudo apt-get -y install virtualbox
sudo apt-get -y install wireshark
sleep 5

#Build and Install Dynamips

echo '..................................'
echo 'Building & Installing Dynamips'
echo '..................................'
sleep 2
cd ~/$user/GNS3/dynamips
mkdir build
cd build
cmake ..
make
sudo make install
sudo setcap cap_net_admin,cap_net_raw=ep /usr/local/bin/dynamips
cd ~
sleep 5

#Install GNS3 Server

echo '........................'
echo 'Installing GNS3 Server'
echo '........................'
sleep 2
cd ~/$user/GNS3/gns3-server
sudo python3 setup.py install
cd ~
sleep 5

#Install GNS3 GUI
#Comment out this section if you are installing
#a pure server with no GUI.

echo '......................'
echo 'Installing GNS3 GUI '
echo '......................'
sleep 2
cd ~/$user/GNS3/gns3-gui
sudo python3 setup.py install
cd ~
sleep 5

#Install GNS3 IOYAP
#This provides network support for IOU images

echo '.......................'
echo 'Installing GNS3 IOYAP '
echo '.......................'
sleep 2
cd ~/$user/GNS3/iouyap
sudo make install
sudo cp iouyap /usr/local/bin
cd ~
sleep 5

#Install GNS3 UBRIDGE
#uBridge is a simple application to create user-land bridges between various technologies.
# Currently bridging between UDP tunnels, Ethernet and TAP interfaces is supported.
# Packet capture is also supported.

echo '....................'
echo 'Installing UBRIDGE'
echo '....................'
sleep 2
cd ~/$user/GNS3/ubridge
make
sudo make install
cd ~
sleep 5

# Install VPCS
#The VPCS can simulate up to 9 PCs. You can ping/traceroute them,
# or ping/traceroute the other hosts/routers from the virtual PCs

echo '................'
echo 'Installing VPCS'
echo '................'
sleep 2
cd ~/$user/GNS3/
tar -xjf vpcs-0.8-src.tbz 
sleep 5
rm vpcs-0.8-src.tbz
cd ~
sleep 2
cd ~/$user/GNS3/vpcs-0.8/src
./mk.sh
sudo cp vpcs /usr/local/bin/
cd ~
sleep 5

# Install IOU dependencies

echo '.......................................'
echo 'Installing and moving IOU dependencies'
echo '.......................................'
sleep 2
cd ~/$user/GNS3/iniparser
make
sudo cp libiniparser.* /usr/lib/
sudo cp src/iniparser.h /usr/local/include
sudo cp src/dictionary.h /usr/local/includ
cd ~
sleep 5

echo ''
echo ''
echo ''

echo '.................................'
echo 'GNS3 has finished setting up!!! '
echo '.................................'
