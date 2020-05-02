---
title: 'Notes: Server Migration and Ubuntu 20.04'
layout: post
---

This is a collection of notes from a server migration.

## New Machine Setup
The destination server now runs `Ubuntu 20.04`. Some initial setup stuff.

```bash
# add a sudo user
adduser cooldude
usermod -aG sudo cooldude

# name the machine (instead of editing /etc/hostname)
hostnamectl set-hostname servername

# you should add `servername` to the /etc/hosts file
# (mainly so you can refer to the local machine by name)

# generate an ssh key (I need to ssh in to another machine so)
ssh-keygen -t rsa -b 4096

# enable firewall
ufw allow 22
ufw allow http
ufw allow https
ufw enable

# install updates
apt update
apt upgrade

# HEY! I originally installed OpenLitespeed, but it wasn't going to work
# Here is that setup code and info

## install build tools
#apt install build-essential cmake
#
## checkout litespeed
#git clone https://github.com/litespeedtech/openlitespeed.git
#cd openlitespeed
#
## the build script makes some incorrect assumptions.
## you might need to add a return to the `installCmake` function.
## the build script will attempt to install packages you need.
#sudo ./build.sh

# COOL! We're done with that
# Lets install NginX with PHP instead
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:ondrej/nginx
sudo apt update

sudo apt install nginx php7.4 php7.4-fpm php7.4-mysql php7.4-gd

# Copy files... ?
scp -P 22 nerd@server.com:/mnt/data .
rsync -azrP -e 'ssh -p 22' nerd@server.com:/mnt/data . 
```