FROM centos:8

RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
RUN dnf update -y
RUN dnf install dnf-plugins-core -y
RUN dnf install epel-release -y
RUN dnf copr enable supervillain/i2pd -y
RUN dnf install tor i2pd unzip httpd -y
RUN dnf install mysql-server -y
ADD setup_script.sh /
