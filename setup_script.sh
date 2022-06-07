#!/usr/bin/bash

green='\e[32m'
red='\e[31m'
blue='\e[34m'
clear='\e[0m'

ColorGreen(){
    echo -ne $green$1$clear
}

ColorRed(){
    echo -ne $red$1$clear
}

ColorBlue(){
    echo -ne $blue$1$clear
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

mysql_opencart(){
        echo "Input opencart USER"
        read opencart_user
        echo "Input opencart password"
        read opencart_password
        echo "CREATE USER $opencart_user@localhost IDENTIFIED BY '$opencart_password';"
        mysql -u root -p$1 -e "create database opencart;"
        mysql -u root -p$1 -e "CREATE USER $opencart_user@localhost IDENTIFIED BY '$opencart_password';"
        mysql -u root -p$1 -e "GRANT ALL PRIVILEGES ON opencart.* to $opencart_user@'localhost';;"
}


security_setup(){
	echo Security setup
	echo "Update packets"
	sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
	sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
	dnf update -y
	dnf install epel-release -y
	echo "Install .onion and i2p unzip httpd"
	dnf copr enable supervillain/i2pd -y
	dnf install tor i2pd unzip httpd -y
	systemctl start tor
	systemctl enable tor
	systemctl start i2pd
	systemctl enable i2pd
	echo "Install LAMP for opencart"
	dnf install mysql-server -y
	systemctl start mysqld
	ColorBlue "Input root passwd for mysql length >8"
	read mysql_root
	echo "Setup mysql root passwd"
	mysqladmin -u root password $mysql_root
	echo "Setup opencart DB"
	mysql_opencart $mysql_root
	# mysql_secure_installation
	echo "Download Opencart"
	curl -LO https://github.com/opencart/opencart/archive/refs/heads/master.zip
	unzip master.zip
	echo "Enable remirepo for php8"
	dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm
	dnf module enable php:remi-8.0 -y
	dnf install -y php php-mysqlnd php-gd php-zip
	echo "Copy opencart to /var/www/[your.domain.com]"
	ColorBlue "Input your domain"
	read regular_domain
	mkdir /var/www/$regular_domain
	cp -r opencart-master/* /var/www/$regular_domain
	echo "Go to browser to setup opencart"

}

menu(){
echo -ne "
My First Menu
$(ColorGreen '1)') Add domain .onion i2p
$(ColorGreen '2)') Create DB
$(ColorGreen '3)') Security setup, install tor i2p opencart and etc
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
