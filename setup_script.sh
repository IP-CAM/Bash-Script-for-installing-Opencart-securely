#!/usr/bin/bash

green='\e[32m'
red='\e[31m'
clear='\e[0m'

ColorGreen(){
    echo -ne $green$1$clear
}

ColorRed(){
    echo -ne $red$1$clear
}

sub_menu_domain(){
echo -ne "
My First Menu
$(ColorGreen '1)') Add .onion domain
$(ColorGreen '2)') Create .onion domain
$(ColorGreen '3)') Add i2p domain
$(ColorGreen '4)') Create i2p domain
$(ColorGreen '5)') Set regular domain
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) echo "Add .onion domain" ;;
	        2) echo "Create .onion domain" ;;
	        3) echo "Add i2p domain" ;;
			4) echo "Create i2p domain";;
			5) echo "Set regular domain";;
			*) echo -e $red"Wrong option."$clear; sub_menu_domain;;
        esac
}

sub_menu_db(){
	echo hello
}

security_setup(){
	echo Security setup
	echo "Update packets"
	sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
	sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
	dnf update -y
	dnf install epel-release -y
	dnf copr enable supervillain/i2pd
	dnf install tor i2pd -y
	echo "Install .onion and i2p"

}

menu(){
echo -ne "
My First Menu
$(ColorGreen '1)') Add domain .onion i2p
$(ColorGreen '2)') Create DB
$(ColorGreen '3)') Security setup 
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
	        1) sub_menu_domain;;
	        2) echo create DB ;;
	        3) security_setup;;
			*) echo -e $red"Wrong option."$clear;;
        esac
}

menu
