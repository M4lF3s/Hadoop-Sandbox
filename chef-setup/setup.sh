#!/usr/bin/env bash

# install necessery tools
yum install -y gcc-c++ patch \
      readline readline-devel \
      zlib zlib-devel libyaml-devel \
      libffi-devel openssl-devel make \
      bzip2 autoconf automake libtool \
      bison iconv-devel libyaml \
      svn rubygems ruby-devel wget


# install Ruby + Chef
cd /tmp

wget ftp://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.1.tar.gz
tar -zxvf ruby-2.3.1.tar.gz
cd ruby-2.3.1
./configure --prefix=/usr/local

make
make install

gem install chef ruby-shadow --no-ri --no-rdoc


# get the Chef-Cookbook
mkdir /var/chef
svn checkout https://github.com/mfraas64/Hadoop-Sandbox/branches/chef-setup/chef-setup/chef /var/chef


# install chef-librarian + dependencies
cd /var/chef
gem install librarian-chef --no-ri --no-rdoc
librarian-chef init
echo "cookbook 'ambari', '~> 0.2.2'" >> Cheffile
librarian-chef install


# change to the chef Directory and execute chef-solo
cd /var/chef
chef-solo -c solo.rb


# Turn Off Firewall
systemctl stop firewalld
systemctl disable firewalld
