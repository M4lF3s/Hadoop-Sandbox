#!/usr/bin/env bash

# install necessery tools
yum install -y gcc-c++ patch \
      readline readline-devel \
      zlib zlib-devel libyaml-devel \
      libffi-devel openssl-devel make \
      bzip2 autoconf automake libtool \
      bison iconv-devel libyaml \
      rubygems ruby-devel git svn


# add the hostname to /etc/hosts
echo 127.0.0.1 $HOSTNAME >> /etc/hosts


# install Ruby + Chef
cd /tmp
curl -O ftp://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz
tar -zxvf ruby-2.3.1.tar.gz
cd ruby-2.3.1
./configure --prefix=/usr/local
make
make install
gem install chef ruby-shadow --no-ri --no-rdoc


# install chef-librarian + dependencies
mkdir /var/chef
cd /var/chef
gem install librarian-chef --no-ri --no-rdoc
librarian-chef init


# echo "cookbook 'ambari', '~> 0.2.2'" >> Cheffile
#echo "cookbook 'apt', '~> 4.0.1'" >> Cheffile
#echo "cookbook 'compat_resource', '~> 12.10.7'" >> Cheffile
echo "cookbook 'ambari', :git => 'https://github.com/jp/ambari'" >> Cheffile
librarian-chef install


# ceckout chef-branch
svn checkout https://github.com/mfraas64/Hadoop-Sandbox/branches/chef-setup/chef-setup/chef /var/chef


# change to the chef Directory and execute chef-solo
cd /var/chef
chef-solo -c solo.rb


# Turn Off Firewall
systemctl stop firewalld
systemctl disable firewalld
