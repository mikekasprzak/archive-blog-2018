---
id: 7512
title: Digital Ocean Notes
date: 2015-09-07T11:11:02+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=7512
permalink: /2015/09/07/digital-ocean-notes/
categories:
  - Technobabble
---
I&#8217;m experimenting with Digital Ocean for servers. Here are notes.

<!--more-->

## 0. Use &#8220;FREE&#8221; for true memory usage

Don&#8217;t mistake what TOP tells you to be the real memory usage. Try `free` instead.

<pre class="lang:default decode:true " >total       used       free     shared    buffers     cached
Mem:        501792     108444     393348        332      14644      52648
-/+ buffers/cache:      41152     460640
Swap:      1048572          0    1048572
</pre>

The `-/+ buffers/cache` line is a more realistic memory usage.

## 1. By default, Ubuntu 14 droplets lack SWAP

<https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-ubuntu-14-04>

It&#8217;s recommended to use 2x RAM for swap, at least for systems with less RAM (i.e. 512 MB). The benefit of more than 2 GB of swap may not be much (since what you&#8217;re doing \*should\* fit in RAM for optimal performance anyway).

## 2. Install LiteSpeed from Source

**NOTE:** You need to use the Beta series (14.x) for PHP 7 support.

<https://www.digitalocean.com/community/tutorials/how-to-install-the-openlitespeed-web-server-on-ubuntu-14-04>

PHP is installed through the control panel (i.e. port 7080). Default deployment port is 8088.

You can upgrade to PHP versions not presently listed in the control panel like so:

<pre class="lang:default decode:true " >nano /usr/local/lsws/admin/html/lib/util/build_php/BuildConfig.php</pre>

Simply edit the name (i.e. PHP7.0.0beta1 to PHP7.0.0RC2).

If you&#8217;re having troubles retrieving the file from mirrors, you can manually wget the file.

<pre class="lang:default decode:true " >cd /usr/local/lsws/phpbuild
wget https://downloads.php.net/~ab/php-7.0.0RC2.tar.gz</pre>

To compile PHP, you may need some additional dependencies like mcrypt ([source](https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-openlitespeed-on-ubuntu-14-04)).

<pre class="lang:default decode:true " >sudo apt-get update
sudo apt-get install libgd-dev libmcrypt-dev libcurl4-openssl-dev libgraphicsmagick-dev</pre>

After installing, go to **Server Config->External App** and change the Command to `lsapi7`.

## (sidenote) Prefer GraphicsMagick to ImageMagick

A fork of ImageMagick optimized for performance and memory usage. 

<http://www.graphicsmagick.org/>

Universally it&#8217;s considered the better of the two, but one article suggested that PSD files are extra slow to process (but only PSD). Internally use GD library to check file size/dimensions before spawning a GraphicsMagick process.

## 3. Installing APCu on PHP 7

<pre class="lang:default decode:true " >sudo apt-get install autoconf git

cd ~
git clone https://github.com/krakjoe/apcu.git
cd apcu
git checkout seven
make clean
/usr/local/lsws/lsphp7/bin/phpize
./configure --with-php-config=/usr/local/lsws/lsphp7/bin/php-config
make -j 4
sudo make install

# TODO: ./configure --disable-apc-bc, but broken

cd /usr/local/lsws/lsphp7/lib
wget https://raw.githubusercontent.com/php/php-src/master/php.ini-production -O php.ini

# add the following to php.ini

extension=apcu.so</pre>