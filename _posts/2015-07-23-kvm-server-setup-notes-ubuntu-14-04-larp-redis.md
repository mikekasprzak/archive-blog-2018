---
id: 7440
title: 'KVM Server Setup Notes &#8211; Ubuntu 14.04 LARP (Redis)'
date: 2015-07-23T12:54:57+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7440
permalink: /2015/07/23/kvm-server-setup-notes-ubuntu-14-04-larp-redis/
categories:
  - LD2015
  - Linux
  - Ludumdare
  - Technobabble
---
I&#8217;m setting up an experimental standalone server for Ludum Dare&#8217;s static content.

<!--more-->

The server will be behind CloudFlare, which will act as a CDN for image content, and it will store (and occasionally pull) backups from Amazon S3.

The server is a KVM node from:

<http://linode.com>

I&#8217;m going with Linode part because of their reputation and price. I&#8217;ve been curious about them for a few years, so it&#8217;s time to begin the experiment.

**NOTE:** Linode is in the process of migrating to KVM from XEN. I had to manually migrate my node (clicking a button in the sidebar, and adjusting my default in my settings).

## Trying something new: Redis

I don&#8217;t necessarily need a full-on MySQL database. I just need a means of persistent storage. I tried the [online tutorial for Redis](http://try.redis.io) last night, and found it agreeable. It&#8217;s nowhere near as powerful as SQL, but as a smarter Key/Value store, I think it&#8217;s worth a try.

Going in to this, I&#8217;m fully aware Redis is single threaded, can potentially be a memory hog, and when misconfiguration can actually lose data (the latest changes). The test machine is single core with only 1 GB of RAM, so I&#8217;m going to have to keep things tight. If this project is a success, and we need more power, I see migrating it to the dual core 2 GB RAM Linode plan. For now, we&#8217;ll stick to single core.

## 0. Preface

Since I&#8217;m also running Ubuntu 14 here, many notes will be borrowed from this prior post.

</2015/07/03/openvz-server-setup-notes-ubuntu-14-04-lamp-wo-m/>

This time I&#8217;m running a true install of Ubuntu Server (not an OpenVZ Minified Server), so some of the weird workarounds aren&#8217;t necessary anymore.

## 1. PHP and Redis

NOTE: `sudo` will actually work now since it&#8217;s a true Ubuntu Server image.

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:ondrej/php5-5.6
sudo apt-get update
sudo apt-get install python-software-properties
sudo apt-get update
sudo apt-get install php5</pre>

To check your PHP version.

<pre>php5 -v
</pre>

Source: <http://www.dev-metal.com/install-setup-php-5-6-ubuntu-14-04-lts/>

Next, Redis.

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:rwky/redis
sudo apt-get update
sudo apt-get install redis-server</pre>

Source: <http://askubuntu.com/a/88288/364657>

Next, Pear and Pecl.

<pre class="lang:default decode:true " >apt-get install php-pear php5-dev

pear config-set php_ini /etc/php5/apache2/php.ini</pre>

Make sure you do that 2nd line. Otherwise, PECL scripts wont be able to auto-add themselves to the PHP configuration.

Next, PHPRedis.

<pre class="lang:default decode:true " >pecl install redis</pre>

Info: <https://pecl.php.net/package/redis>

And of course my favourite, APCu.

<pre class="lang:default decode:true " >pecl install apcu-beta</pre>

Info: <https://pecl.php.net/package/apcu>

At this point, Apache, PHP and Redis should be installed.

## 2. Disable Public SSH

Security 101 here. The best way to avoid people trying to SSH in and take over your server is to simply disable the outgoing SSH.

Like any good host, Linode will let you SSH in to your box indirectly. Linode has something like like to call Lish. For connect instructions, see the **Remote Access->Console Access** section of the Linode manager. 

Before we start, though we&#8217;ll be disabling WAN access via SSH, it may be sensible to still allow SSH access inside the LAN (i.e. the datacenter). Frankly, I&#8217;m not entirely sure how Lish works (whether it needs SSH running at all), so I did this just-in-case.

Under **Remote Access->Private/LAN Network**, generate a Private IP address (if you haven&#8217;t already). Now **reboot the box**.

Figure out your LAN IP address (i.e. `ifconfig`, or read what it says in Linode manager).

Open up your SSHD config.

<pre>nano /etc/ssh/sshd_config</pre>

Add a ListenAddress for your LAN IP.

<pre>ListenAddress 192.168.22.22
</pre>

Reboot, and your public SSH ports will now be blocked.

\* \* *

You can add an SSH key from inside **My Profile->Lish Settings**. You&#8217;ll use the same Lish connect command as before, but it&#8217;ll save you from logging in twice. Don&#8217;t forget to add an entry to your `~/.ssh/config`!

## 3. Do a Sparse Checkout

This server only needs a subset of the Ludum Dare repository, so I&#8217;ll be using a Sparse Checkout. Sparse Checkouts let you say specifically which folders you want to access to, as not every project needs everything.

<pre>cd /var/www/
git init
git remote add -f origin https://github.com/povrazor/ludumdare.git
git branch --set-upstream-to=origin/master
git config core.sparseCheckout true
</pre>

Now you need to list all the directories you want in file: `.git/info/sparse-checkout`

<pre>api.php
style.php
core/
public-static/
!*.md
</pre>

Finally, pull the code.

<pre>git pull -u
</pre>

Source: <http://stackoverflow.com/a/13738951>

If you ever change the `.git/info/sparse-checkout` file, you&#8217;ll have to do the following to apply the changes. 

<pre>git read-tree -m -u HEAD
</pre>

Source: <http://blogs.atlassian.com/2014/05/handle-big-repositories-git/>

In my case, I want Apache to pull from the `/var/www/public-static` folder and not `/var/www/html`, so I need to modify the site configuration.

<pre>nano /etc/apache2/sites-enabled/000-default.conf 
</pre>

and change the DocumentRoot.

Finally, restart Apache.

<pre>service apache2 restart        # or /etc/init.d/apache2 restart
</pre>

## 5. Setting .htaccess setting inside apache.conf

Instead of `.htaccess` files, Apache can have those configurations placed right in the config file. This is ideal, since Apache doesn&#8217;t have to scan the directory tree \*just in case\* of `.haccess` files.

Simply open up your Apache config (i.e. \`/var/apache2/apache.conf\`), and add a directory section that says where and what you&#8217;d typically have in an .htaccess file.

<pre class="lang:default decode:true " >&lt;Directory /var/www/public-static/&gt;
        # From .htaccess
        RewriteEngine on

        RewriteRule ^img/(.*) img.php/$1
        RewriteRule ^up/(.*) up.php/$1
&lt;/Directory&gt;
</pre>

Source: <http://askubuntu.com/a/48363/364657>

Now restart Apache to keep your settings.

**NOTE:** You may need to enable mod_rewrite.

<pre class="lang:default decode:true " >sudo a2enmod rewrite

service apache2 restart</pre>

## 6. uhh&#8230;

Still working&#8230;