---
title: 'Notes: Building a Vagrant Box from Scratch'
layout: post
date: '2018-05-31 23:28:06'
---

Rather than use an out-of-date version of Scotch/Box, here are my notes on creating a custom Vagrant Box ([reference](https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one)).

NOTE: These are my notes for creating `butterbox`, the new version (not [old version](https://github.com/mikekasprzak/butterbox-original)).

## Getting Started

Pick a base distro. I'm starting with Ubuntu 18.04 "daily".

[https://app.vagrantup.com/ubuntu/boxes/bionic64](https://app.vagrantup.com/ubuntu/boxes/bionic64)

Create a folder and do the init.

```bash
# Make the working folder
mkdir butterbox
cd butterbox

# Make a folder for web pages (when creating a scotch/box like)
mkdir www

# Initialize the box
vagrant init ubuntu/bionic64
```

This creates a `Vagrantfile` for you.

Before invoking `vagrant up`, you should edit the Vagrantfile.

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # For a complete reference of configuration options, please see the online documentation at
  # https://docs.vagrantup.com.

  config.vm.box = "ubuntu/bionic64"
  config.vm.hostname = "butterbox"

  config.vm.network "private_network", ip: "192.168.33.10"
  # config.vm.network "public_network"

  config.vm.synced_folder "www", "/var/www", :mount_options => ["dmode=777", "fmode=666"]

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 2
  end
end
```

Now do a `vagrant up`.

You will probably get an error like this (trimmed):

```bash
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
==> default: Setting hostname...
==> default: Configuring and enabling network interfaces...
The following SSH command responded with a non-zero exit status.
Vagrant assumes that this means the command failed!

/sbin/ifdown 'enp0s8' || true
/sbin/ip addr flush dev 'enp0s8'
# Remove any previous network modifications from the interfaces file
sed -e '/^#VAGRANT-BEGIN/,$ d' /etc/network/interfaces > /tmp/vagrant-network-interfaces.pre
sed -ne '/^#VAGRANT-END/,$ p' /etc/network/interfaces | tac | sed -e '/^#VAGRANT-END/,$ d' | tac > /tmp/vagrant-network-interfaces.post
```

Long story short, this is because you are missing the `ifup` and `ifdown` tools ([reference)[https://github.com/cilium/cilium/issues/1918]).

```bash
vagrant ssh

sudo apt update
sudo apt install ifupdown

exit

# now shutdown the vm
vagrant halt
```

Next time you start the VM (`vagrant up`), it will use the requested IP address.

## Dev Tools Setup
Do the following for a good general setup.

```bash
sudo apt install build-essential git subversion mercurial
```

## Web Server Setup
Out-of-the-box Apache2 comes pre-installed, but the default configuration expects to find a folder `/var/www/html`. You can simple create the `html` folder inside the `www` folder and it will work. Alternatively, you can edit the server configuration.

```bash
vagrant ssh
cd /etc/apache2/sites-enabled/
sudo nano 000-default.conf

# Helpful symlink
ln -s /etc/apache2/sites-available/000-default.conf ~/apache.conf
```

With the file open, find this and adjust the path accordingly (`DocumentRoot` becomes `/var/www` instead of `/var/www/html`).

```xml
<VirtualHost *:80>
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

Restart the server.

```bash
sudo service apache2 restart
```

Install PHP 7.2:

```bash
sudo apt install php7.2 php7.2-xml php7.2-curl php7.2-bcmath php7.2-opcache php7.2-phpdbg php7.2-mysql php7.2-mbstring

# Helpful symlink
ln -s /etc/php/7.2/apache2/php.ini ~/php.ini
```

Install MariaDB 10.3 ([reference](https://downloads.mariadb.org/mariadb/repositories/#distro=Ubuntu&distro_release=bionic--ubuntu_bionic&version=10.3&mirror=coloserv)):

```bash
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64] http://mariadb.mirror.colo-serv.net/repo/10.3/ubuntu bionic main'

sudo apt update
sudo apt install mariadb-server mariadb-plugin-tokudb

# Helpful symlink
ln -s /etc/mysql/my.cnf ~/my.cnf
```

Install Redis:

```bash
sudo apt install redis php-redis

# Helpful symlink
ln -s /etc/redis/redis.conf ~/redis.conf
```

Install Memcached ([reference](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-memcached-on-ubuntu-16-04)):

```bash
sudo apt install memcached php-memcached

# Helpful symlink
ln -s /etc/memcached.conf ~/memcached.conf
```

Install Nodejs ([reference](https://github.com/nodesource/distributions)):

```bash
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## Packing up the box
First ssh in and do a cleanup ([reference](https://scotch.io/tutorials/how-to-create-a-vagrant-base-box-from-an-existing-one)).

```bash
vagrant ssh

# According to the top comment in my reference, this is needed
sudo rm /etc/udev/rules.d/70-persistent-net.rules

# clean apt cache
sudo apt clean

# zero out the rest of the unused space in the VM
sudo dd if=/dev/zero of=/EMPTY bs=1M
sudo rm -f /EMPTY

# blank the bash history
cat /dev/null > ~/.bash_history && history -c && exit
```

Then package up the box.

```bash
vagrant package --output mynew.box
```

Done.