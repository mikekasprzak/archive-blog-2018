---
id: 7715
title: LiteSpeed+PHP Installing and Upgrading Notes
date: 2015-10-28T11:36:56+00:00
author: Mike K
layout: post
guid: /?p=7715
permalink: /2015/10/28/litespeedphp-installing-and-upgrading-notes/
categories:
  - Uncategorized
---
Another day, another note post. 🙂

<!--more-->

**NOTE:** These originally come from these notes. </2015/09/07/digital-ocean-notes/>

## 1. Installing OpenLiteSpeed

**EDIT:** Updated March 2016.

<pre class="lang:default decode:true " ># Install Dev Tools (and libmcrypt for PHP)
sudo apt-get update
sudo apt-get install build-essential libexpat1-dev libgeoip-dev libpng-dev libpcre3-dev libssl-dev libxml2-dev rcs zlib1g-dev libmcrypt-dev libcurl4-openssl-dev libjpeg-dev libpng-dev libwebp-dev
 
# Get source
cd ~
wget http://open.litespeedtech.com/packages/openlitespeed-1.4.18.tgz
 
# Unzip
tar -axf openlitespeed-1.4.15
cd openlitespeed-1.4.15

# (optional) Install any patches
patch -p1 &lt;../my.patch
 
# Build and Install
./configure
make -j 2
sudo make install

# Generate a crazy Password
head /dev/urandom | tr -dc A-Za-z0-9 | head -c 48 ; echo

# Set Password
/usr/local/lsws/admin/misc/admpass.sh

# Start Server
sudo service lsws start


# Useful links
ln -s /usr/local/lsws lsws
</pre>

## 1b. Upgrading OpenLiteSpeed

Identical to installing, but packages are likely already installed.

Your updated PHP versions will persist, since the configuration files persist. However, you may lose any installed plugigns for PHP.

## 2. Installing Lets Encrypt's CertBot

**EDIT:** Added June 2016.

As of Ubuntu 16.04, Lets Encrypt's CertBot is packaged and part of the main repos, but it's an old out-of-date version (4.1). It can be installed like so.

<pre class="lang:default decode:true " >sudo apt-get install letsencrypt </pre>

Unfortunately, this version is too old for helpful commands like `--pre-hook` and `--post-hook`. So you'll have to install it the sloppy way.

<pre class="lang:default decode:true " >cd ~
wget https://dl.eff.org/certbot-auto
chmod a+x certbot-auto</pre>

The commands `certbot`, `certbot-auto`, `letsencrypt`, and `letsencrypt-auto` are all interchangeable. The auto versions are smart scripts that also download dependencies.

When using an auto script in a cron job, be sure to include these additional parameters.

<pre class="lang:default decode:true " >--quiet --no-self-upgrade</pre>

This only applies to auto scripts.

## 2b. Fetching SSL Certificates

After LSWS installation, port 80 isn't being mapped yet, so we can get a certificate for our domain URL.

<pre class="lang:default decode:true " >./certbot-auto certonly --standalone -d website.com -d www.website.com</pre>

Once we have a real configuration though (i.e. we use port 80), we'll need to stop and start LiteSpeed any time we refresh certificates.

**NOTE:** Alternatively the CertBot webroot plugin can be used. It's not ideal, because you need to specify the public directory. That said, it means you don't need to take the server down at all.

Here's a script. I call it certbot-register:

<pre class="lang:default decode:true " >#!/bin/bash

COMMAND=./certbot-auto

# NOTE: Bash syntax, not Dash or Sh
if [[ $# -eq 0 ]] ; then
    echo "usage: $0 domain.com"
    exit 1
fi

$COMMAND certonly --standalone --pre-hook "service lsws stop" --post-hook "service lsws start" --standalone-supported-challenges http-01 -d $1
</pre>

**NOTE:** pre-hook and post-hook use smarts, only shutting down the server temporarily if a certificate needs to be refreshed. Also, we need to use the `http-01` (port 80) and not `tls-sni-01` (port 443) because of the way CloudFlare wraps SSL for you.

Usage:

<pre class="lang:default decode:true " >./certbot-register mydomain.com</pre>

If configured correctly, the server will temporarily take the LiteSpeed server down, and acquire an SSL certificate.

## 2c. Renewing SSL Certificates

To renew, do...

## 2d. Renewing SSL Certificates in a CRON job

moo

## 2e. Configuring Webroot for LSWS Admin

WebAdmin Settings -> Listeners -> View "adminListener" -> SSL

Adjust `my.domain.com` accordingly.

<pre class="lang:default decode:true " ># SSL Private Key & Certificate
Private Key File        /etc/letsencrypt/live/my.domain.com/privkey.pem
Certificate File        /etc/letsencrypt/live/my.domain.com/fullchain.pem
Chained Certificate     Yes</pre>

Restart the server, then refresh the page (wont kick in until you do). 

## 3. Installing PHP 7

<pre># Update PHP Build version(s)
nano /usr/local/lsws/admin/html/lib/util/build_php/BuildConfig.php</pre>

Now, build PHP 7 inside the UI.

You may need to add (for proper GD library support):

<pre class="lang:default decode:true " >--with-jpeg-dir --with-png-dir --with-webp-dir</pre>

NOTE: php.ini may not be copied, so you can acquire the file as follows:

<pre class="lang:default decode:true " >cd /usr/local/lsws/lsphp7/lib/
wget https://raw.githubusercontent.com/php/php-src/master/php.ini-production -O php.ini</pre>

## 3b. PHP 7 Extensions

To use PHPiz, you need autoconf.

<pre class="lang:default decode:true " >sudo apt-get install autoconf</pre>

**GD:** already installed (built-in)

**APCu (branch):** <https://github.com/krakjoe/apcu/tree/seven>

<pre class="lang:default decode:true " >cd ~
git clone https://github.com/krakjoe/apcu.git
cd apcu
make clean               # Just in case
/usr/local/lsws/lsphp7/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp7/bin/php-config
make -j 2
sudo make install

# Add to php.ini
sudo sed -i '1i extension=apcu.so' /usr/local/lsws/lsphp7/lib/php.ini
</pre>

**Imagick (branch)** or Gmagick: <https://github.com/mkoppanen/imagick/tree/phpseven>

<pre class="lang:default decode:true " ># Prerequisites
sudo apt-get install pkg-config libmagickwand-dev

cd ~
git clone https://github.com/mkoppanen/imagick.git
cd imagick
git checkout phpseven
make clean
/usr/local/lsws/lsphp7/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp7/bin/php-config
make -j 2
sudo make install

# Add to php.ini
sudo sed -i '1i extension=imagick.so' /usr/local/lsws/lsphp7/lib/php.ini
</pre>

## 4. Upgrading PHP 7

Because we build PHP from tarballs, we need to repeat the entire install procedure (minus packages).

That said, due to one of the upgrades (LiteSpeed or PHP, I foget), you'll need to reinstall your PHP plugins.

<pre class="lang:default decode:true " ># Reinstall APCu
cd ~
cd apcu
sudo make install

# Reinstall ImageMagick
cd ~
cd imagick
sudo make install

# Restart LSWS
sudo service lsws restart</pre>

## 4b. Upgrading PHP 7 Plugins

The plugins are installed from Github repos.

<pre class="lang:default decode:true " ># APCu
cd ~
cd apcu
git pull -u
make clean
make -j 4

sudo make install

# ImageMagick
cd ~
cd imagick
git pull -u   # had no changes last I checked... what?
make clean
make -j 4

sudo make install</pre>

## 5. Redis Sessions

For improved PHP Session speed and reliability, one can install Redis.

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:chris-lea/redis-server
sudo apt-get update
sudo apt-get install redis-server

# check if it works by doing a 
redis-cli ping</pre>

Grab the PHPRedis package from here.

<https://github.com/phpredis/phpredis>

Unzip it (assuming you grabbed a release). 

Navigate to the folder. Setup is identical to apcu.

<pre class="lang:default decode:true " >/usr/local/lsws/lsphp7/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp7/bin/php-config
make -j 2
sudo make install

# Add to php.ini
sudo sed -i '1i extension=redis.so' /usr/local/lsws/lsphp7/lib/php.ini
</pre>

Restart the server.

<pre class="lang:default decode:true " >sudo service lsws restart

# or do it via the UI</pre>

Before moving on, check that there are no keys.

<pre class="lang:default decode:true " >redis-cli

# From the CLI client
keys *

# Output
# (empty list or set)</pre>

Edit PHP.ini

<pre class="lang:default decode:true " >sudo nano /usr/local/lsws/lsphp7/lib/php.ini

# make the following changes

session.save_handler = redis

session.save_path = tcp://127.0.0.1:6379</pre>

That's it. Reboot the server.

<pre class="lang:default decode:true " >sudo service lsws restart

# or do it via the UI</pre>

Do some stuff that would create sessions. Now check for keys.

<pre class="lang:default decode:true " >redis-cli

# From the CLI client
keys *
</pre>

Reference (and how to configure it remotely): <https://www.digitalocean.com/community/tutorials/how-to-set-up-a-redis-server-as-a-session-handler-for-php-on-ubuntu-14-04>