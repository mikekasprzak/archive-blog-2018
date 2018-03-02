---
id: 7352
title: 'OpenVZ Server Setup Notes &#8211; Ubuntu 14.04 LAMP (w/o M)'
date: 2015-07-03T23:15:59+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7352
permalink: /2015/07/03/openvz-server-setup-notes-ubuntu-14-04-lamp-wo-m/
categories:
  - Technobabble
---
For a side project, I&#8217;m using cheap server from these guys:

<http://buyvm.net/>

I&#8217;ve decided that since it&#8217;s for development, I&#8217;d rather use Apache instead of NgineX. NgineX is much better than Apache when it comes to memory usage and performance, but Apache is a little easier to organize thanks to `.htaccess` files. And since Ludum Dare runs and will continue to run Apache for a while, I&#8217;ve decided to make my life working on both projects a little simpler.

For my reference, the following are my setup notes for the server.

<!--more-->

## 0. Nuking the server

The old NgineX install is now gone. Replaced with a fresh Ubuntu 14.04 OpenVZ image. I believe it&#8217;s the Ubuntu 14.04 Minimal image from here:

<http://wiki.openvz.org/Download/template/precreated>

SSH&#8217;ing in, I need to remember to get the login from the control panel. I also specifically only allowed my own IP address to SSH in to the server, using the Remote Access Policy &#8220;Only Allowed IPs&#8221;.

Now we can begin.

## 1. Preamble

SSH in. I am groot.

<pre>apt-get update
apt-get dist-upgrade
</pre>

To be able to add additional repositories, we need:

<pre>apt-get install python-software-properties

locale-gen en_US.UTF-8
export LANG=en_US.UTF-8
</pre>

The former solves issues with `add-apt-repository`, as apparently UTF-8 hadn&#8217;t been configured yet.

Source: <http://askubuntu.com/a/393649/364657>

**NOTE:** When we start adding launchpad repositories, we&#8217;ll eventually get an error like this when we run &#8220;`apt-get update`&#8220;:

<pre>W: GPG error: http://ppa.launchpad.net trusty Release: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY AM8147UI12ADUD
</pre>

To solve that, grab the UID after NO_PUBKEY and feed it in to this command:

<pre>apt-key adv --keyserver keyserver.ubuntu.com --recv-keys AM8147UI12ADUD

apt-get update
</pre>

Source: <http://askubuntu.com/a/15272/364657>

## 2. Basic Apache and PHP Setup

The Ubuntu repository has Apache 2.4.7 and PHP 5.5. For the latest (2.4.12+ and 5.6+), we do this:

<pre>add-apt-repository ppa:ondrej/php5-5.6
apt-get install apache2 php5 php5-mysql
</pre>

That covers the basic Apache+PHP configuration.

If you wanted to install MySQL Server, you&#8217;d do the following.

<pre>apt-get install mysql-server
</pre>

I don&#8217;t need it (the host I&#8217;m using offers an external SQL server), but for reference that&#8217;s what you need to know.

## 3. Apache Configuration

<pre>nano /etc/apache2/apache2.conf</pre>

<pre>nano /etc/apache2/ports.conf</pre>

<pre>nano /etc/apache2/sites-enabled/000-default.conf

DocumentRoot /var/www/public   # Instead of /var/www/html
</pre>

http://httpd.apache.org/docs/trunk/rewrite/avoid.html

https://servercheck.in/blog/3-small-tweaks-make-apache-fly

TODO: mod_CloudFlare 

## 4. PHP PECL Packages

To use PECL packages, we need to install Pear and PHP5 Dev.

<pre>apt-get install php-pear php5-dev

pear config-set php_ini /etc/php5/apache2/php.ini
</pre>

The last line will save you from manually adding things like &#8220;`extension=apcu.so`&#8221; to `php.ini`.

We can now use PECL.

## 4a. APCu

I&#8217;m a big fan of [APCu](https://pecl.php.net/package/APCu). It lets me share data with other PHP processes with RAM.

<pre>pecl install apcu-beta
</pre>

I&#8217;m using a low memory server (256 MB), so we should explicitly say how much memory to give APCu.

The default is 32 MB, which should be fine for now.

## 5. PHP Configuration (php.ini)

<pre>nano /etc/php5/apache2/php.ini

display_errors = on
memory_limit = 128M         # make this smaller
upload_max_filesize = 2M
</pre>

## 5b. PHP OpCache

<pre>;opcache.enable=0
;opcache.memory_consumption=64
;opcache.interned_strings_buffer=4
;opcache.max_accelerated_files=2000
</pre>

## 6. Restart Apache

Now that everything is installed, restart Apache.

<pre>/etc/init.d/apache2 restart
</pre>

## 7. Git, SSH and Source Code

<pre>apt-get install git</pre>

Now, [generate an SSH key](/2015/07/03/git-notes-on-ssh-keys/). Pass-phrase?

<pre>cat ~/.ssh/id_rsa.pub
</pre>

Copy the Public Key, and paste it to your SSH Keys configuration (GitHub/Bitbucket).

Move the placeholder website out of the www folder.

<pre>mv /var/www/html /var/
</pre>

`git clone` the source repository with an SSH URI.

## 8. Remote Database

Given a Web Server and a Database Server on the same local network.

Using Database Server&#8217;s CPanel:

  * Add a Database.
  * Add a User.
  * Give user full permissions to the database.
  * Add the Web Server&#8217;s internal IP to the &#8220;Remote Database Access Hosts&#8221; list

Then from the Web Server:

  * In PHP code, reference the database by the internal HostName/IP of the Database Server instead of &#8220;localhost&#8221;.

## 9. Automatic Updates

Details: https://help.ubuntu.com/lts/serverguide/automatic-updates.html

<pre>nano /etc/apt/apt.conf.d/50unattended-upgrades

Unattended-Upgrade::Allowed-Origins {
        "${distro_id}:${distro_codename}-security";
//      "${distro_id}:${distro_codename}-updates";
</pre>

Can enable downloading of general updates in addition to security updates by uncommenting.

<pre>nano /etc/apt/apt.conf.d/10periodic

APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";
</pre>

Apparently if we create this file, this is a decent daily configuration (see Details).

## 10. Lockdown SSH

Figure out the local IP addresses of the server, and open `sshd_config`.

<pre>ifconfig

nano /etc/ssh/sshd_config</pre>

Add a ListenAddress for your LAN IP.

<pre>ListenAddress 172.16.2.3
</pre>

Reboot, and SSH will now only allow incomming SSH connections from the local network.