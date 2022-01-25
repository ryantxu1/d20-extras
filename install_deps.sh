#!/bin/bash

# Python3 >=3.7 and D20 must be installed beforehand
echo "Detecting OS"
OPERATINGSYS=""
if [ "$(lsb_release -si)" == "Ubuntu" ]
then
    echo "UBUNTU DETECTED"
    OPERATINGSYS="Ubuntu"
elif [ "$(cat /etc/centos-release)" == "CentOS Linux release 7"* ]
then 
    echo "CENTOS DETECTED"
    OPERATINGSYS="CentOS"
else
    echo "Did not detect Ubuntu or CentOS"
    exit 1
fi

echo ""
echo "Installing buildtools"
echo "---------------------"
if [ $OPERATINGSYS == "Ubuntu" ]
then
    sudo apt update
    sudo apt upgrade
    sudo apt-get install build-essential libffi-dev python3 python3-dev python3-pip libfuzzy-dev wget
elif [ $OPERATINGSYS == "CentOS" ]
then
    sudo yum update
    sudo yum upgrade
    sudo yum groupinstall "Development Tools"
    sudo yum install epel-release
    sudo yum install libffi-devel python-devel python-pip ssdeep-devel ssdeep-libs wget openssl-devel bzip2-devel zlib-devel xz-devel
fi
    
echo ""
echo "Installing exiftool"
echo "-------------------"
D20DIR=$(PWD)
TEMP="$(mktemp -d)"
cd $TEMP
wget "https://exiftool.org/Image-ExifTool-12.39.tar.gz"
gzip -dc Image-ExifTool-12.39.tar.gz | tar -xf -
cd Image-ExifTool-12.39
if [ $OPERATINGSYS == "Ubuntu" ]
then
    sudo apt-get install perl
elif [ $OPERATINGSYS == "CentOS" ]
then
    sudo yum install perl-devel
fi
perl Makefile.PL
make test
sudo make install
cd ..

echo ""
echo "Installing YARA"
echo "---------------"
if [ $OPERATINGSYS == "Ubuntu" ]
then
    sudo apt-get install automake libtool make gcc pkg-config
elif [ $OPERATINGSYS == "CentOS" ]
then
    sudo yum install autoconf libtool openssl-devel file-devel jansson jansson-devel
fi
wget "https://github.com/VirusTotal/yara/archive/refs/tags/v4.1.3.tar.gz"
tar -zxf v4.1.3.tar.gz
cd yara-4.1.3
./bootstrap.sh
./configure
make
sudo make install
cd ..
pip3 install yara-python

echo ""
echo "Installing 7ZIP and UPX"
echo "-----------------------"
if [ $OPERATINGSYS == "Ubuntu" ]
then
    sudo apt-get install p7zip-full p7zip-rar
    sudo apt-get install upx 
elif [ $OPERATINGSYS == "CentOS" ]
then
    sudo yum install p7zip p7zip-plugins
    sudo yum install upx   
fi



echo ""
echo "Installing telfhash"
echo "-----------------------"
wget https://github.com/trendmicro/tlsh/archive/master.zip -O master.zip
unzip master.zip
cd tlsh-master
make.sh
cd ..
git clone https://github.com/trendmicro/telfhash.git
cd telfhash
python3 setup.py build
python3 setup.py install
cd $D20DIR

echo ""
echo "Installing python packages"
echo "--------------------------"
pip3 install wheel
pip3 install cffi
if [ $OPERATINGSYS == "Ubuntu" ]
then
    sudo apt-get install libarchive-dev
elif [ $OPERATINGSYS == "CentOS" ]
then
    sudo yum install libarchive-devel
fi
pip3 install -r requirements.txt


# echo ""
# echo "Installing exiftool"
# echo "-------------------"
# mkdir deps
# cd deps
# wget "https://exiftool.org/Image-ExifTool-12.39.tar.gz"
# gzip -dc Image-ExifTool-12.39.tar.gz | tar -xf -
# cd Image-ExifTool-12.39
# sudo yum install -y perl-devel
# perl Makefile.PL
# make test
# sudo make install
# cd ..

# echo ""
# echo "Installing YARA"
# echo "---------------"
# sudo yum install -y epel-release autoconf libtool openssl-devel file-devel jansson jansson-devel
# wget "https://github.com/VirusTotal/yara/archive/refs/tags/v4.1.3.tar.gz"
# tar -zxf v4.1.3.tar.gz
# cd yara-4.1.3
# ./bootstrap.sh
# ./configure
# make
# sudo make install
# cd ..
# pip3 install yara-python

# echo ""
# echo "Installing 7ZIP and UPX"
# echo "-----------------------"
# sudo yum install -y p7zip p7zip-plugins
# sudo yum install -y upx


# echo ""
# echo "Installing telfhash"
# echo "-----------------------"
# wget https://github.com/trendmicro/tlsh/archive/master.zip -O master.zip
# unzip master.zip
# cd tlsh-master
# make.sh
# cd ..
# git clone https://github.com/trendmicro/telfhash.git
# cd telfhash
# python3 setup.py build
# python3 setup.py install
# cd ..
# cd ..

# echo ""
# echo "Installing python packages"
# echo "--------------------------"
# pip3 install wheel
# pip3 install cffi
# sudo yum install -y libarchive-devel
# pip3 install -r requirements.txt 
