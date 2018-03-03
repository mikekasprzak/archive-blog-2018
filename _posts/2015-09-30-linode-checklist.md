---
id: 7562
title: Linode Checklist
date: 2015-09-30T18:05:50+00:00
author: Mike K
layout: post
guid: /?p=7562
permalink: /2015/09/30/linode-checklist/
categories:
  - Uncategorized
---
More notes. Sorry. 🙂

<!--more-->

## 1. Hostname and TimeZone

Reference: <https://www.linode.com/docs/getting-started>

<pre class="lang:default decode:true " >echo "MyHostName"&gt;/etc/hostname
hostname -F /etc/hostname

nano /etc/hosts</pre>

Add a line below localhost and ubnutu:

<pre class="lang:default decode:true " >12.34.56.78      my.myhostname.com myhostname</pre>

To set timezone:

<pre class="lang:default decode:true " >dpkg-reconfigure tzdata</pre>

UI should be straightforward. Use command `date` to confirm it&#8217;s correct.

## 2. Add User

Reference: <https://www.linode.com/docs/security/securing-your-server/>

<pre class="lang:default decode:true " >adduser exampleuser
usermod -a -G sudo exampleuser
logout</pre>

## 3. Firewall

Reference: <https://www.linode.com/docs/security/firewalls/configure-firewall-with-ufw>

Be sure to allow SSH **before** activating the firewall, if you happen to be SSH&#8217;ing in to it.

<pre class="lang:default decode:true " ># Enable Firewall
sudo ufw enable

# Disable Firewall
sudo ufw disable

# View status and details
sudo ufw status 
sudo ufw status verbose
sudo ufw show raw

# Default settings (defaults, only necessary if you change them)
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Enable services
sudo ufw allow ssh
sudo ufw allow http/tcp
sudo ufw allow https/tcp
sudo ufw allow mysql/tcp

# Enable certain IPs access to services
sudo ufw allow from 123.45.67.89 to any port 22 proto tcp
sudo ufw allow from `dig +short somewebsite.com` to any port ftp proto tcp

# Remove services (use exact format of original with delete)
sudo ufw delete allow ssh
sudo ufw delete allow mysql/tcp
sudo ufw delete allow from `dig +short somewebsite.com` to any port ftp proto tcp

# Ban an IP address
sudo ufw insert 1 deny from 123.45.67.89</pre>

## 4. Fail2Ban

Reference: <https://www.linode.com/docs/security/securing-your-server/#installing-and-configuring-fail2ban>

Fail2Ban adds IPTABLES entries for denying users that have triggered a ban. Thus, they will be denied access to the server for a period of time.

<pre class="lang:default decode:true " >sudo apt-get install fail2ban</pre>

By default, Fail2Ban is configured to watch/track SSH connection traffic. Fail2Ban can be configured for other services as well.

<pre class="lang:default decode:true " ># Show clients that are denied SSH access
sudo fail2ban-client status ssh
</pre>

Fail2Ban plays nice with UFW (both tools manage the IPTABLES). UFW will only its own denied/allowed IPs, so the commands above are required for checking who is denied.

## 5a. Disable Root Login via SSH

<pre class="lang:default decode:true " >nano /etc/ssh/sshd_config</pre>

Made the following changes:

<pre class="lang:default decode:true " >PermitRootLogin no

...

PasswordAuthentication no</pre>

## 5b. Allow SSH only from LAN

<pre class="lang:default decode:true " >nano /etc/ssh/sshd_config</pre>

Set the `ListenAddress` to the internal IP (not the public IP).

## 5c. Remove SSH Server

<pre class="lang:default decode:true " >sudo apt-get remove openssh-server</pre>

## 6a. Install MariaDB

Reference: <https://downloads.mariadb.org/mariadb/repositories/#mirror=digitalocean-nyc>
  
Reference: <https://www.vultr.com/docs/install-mariadb-on-ubuntu-14-04>

Get latest package.

<pre class="lang:default decode:true " >sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://nyc2.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'

sudo apt-get update
sudo apt-get install mariadb-server

# A setup script that will remove bad default configurations. RECOMMENDED!
sudo mysql_secure_installation</pre>

After running **mysql\_secure\_installation**, root will only be accessible locally.

## 6b. Configure MariaDB

Reference: <https://www.linode.com/docs/databases/mariadb/mariadb-setup-debian7>

To configure:

<pre class="lang:default decode:true " >sudo nano /etc/mysql/my.cnf 

sudo service mysql restart</pre>

To enable remote connections, comment out the bind-address line:

<pre class="lang:default decode:true " >#bind-address                   = 127.0.0.1</pre>

To connect to the database.

<pre># Local connection (enter password when prompted)
mysql -u root -p

# If connecting remotely, you need the client installed locally
sudo apt-get install mariadb-client-core-10.0

# Invoke the client
mysql -h 123.45.67.89 -u username -p
</pre>

Users:

<pre class="lang:default decode:true " ># List all users
SELECT User, Host FROM mysql.user;

# View a users permissions
SHOW GRANTS FOR 'user';
SHOW GRANTS; # me

# Add/update the root user to only access via the LAN
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.1.%' IDENTIFIED BY 'my-password' WITH GRANT OPTION;

# Add a user that can access MyDatabase anywhere (% wildcard)
GRANT ALL PRIVILEGES ON MyDatabase.* TO 'myuser'@'%' IDENTIFIED BY 'my-password';

# Remove a user
DROP USER 'username';

# Remove a specific user permission
DROP USER 'username'@'localhost';

# Reload permissions (once changed)
flush privileges;
</pre>

Reference: <https://mariadb.com/kb/en/mariadb/configuring-mariadb-for-remote-client-access/>
  
Reference: <https://www.linode.com/docs/websites/hosting-a-website/#creating-a-database>

## 6c. Optimizing MariaDB

See suggestions here for things inside **my.conf** you can change:

<https://www.linode.com/docs/websites/hosting-a-website/#optimizing-mysql-for-a-linode-1gb>

i.e. Lower connections to 75 from 100, max\_allowed\_packets to 1M from 16M.

There is also an app that can look at logs and things and tell you what you should to to make it run better: **mysqltuner**

<https://www.linode.com/docs/databases/mariadb/mariadb-setup-debian7#tuning-mariadb>

Your database should operate for about 24 hours under normal usage for it to make suggestions.

## 6d. Backups

Reference: [http://webcheatsheet.com/sql/mysql\_backup\_restore.php](http://webcheatsheet.com/sql/mysql_backup_restore.php)
  
Reference: <http://dev.mysql.com/doc/refman/5.6/en/mysqldump.html>
  
A script with some nice ideas: <http://www.docplanet.org/linux/backing-up-linux-web-server-live-via-ssh/>

## 7. Litespeed

Reference: <https://www.digitalocean.com/community/tutorials/how-to-install-the-openlitespeed-web-server-on-ubuntu-14-04>
  
Reference: <https://www.digitalocean.com/community/tutorials/how-to-install-wordpress-with-openlitespeed-on-ubuntu-14-04>

Latest version: <http://open.litespeedtech.com/mediawiki/index.php/Downloads>

<pre class="lang:default decode:true " ># Install Dev Tools (and libmcrypt for PHP)
sudo apt-get update
sudo apt-get install build-essential libexpat1-dev libgeoip-dev libpng-dev libpcre3-dev libssl-dev libxml2-dev rcs zlib1g-dev libmcrypt-dev

# Get source
cd ~
wget http://open.litespeedtech.com/packages/openlitespeed-1.4.11.tgz

# Unzip
tar xzvf openlitespeed-1.4.11
cd openlitespeed-1.4.11

# Build and Install
./configure
make -j 2
sudo make install</pre>

Litespeed is now installed in **/usr/local/lsws**.

<pre class="lang:default decode:true " ># Generate a good password
openssl rand -base64 32

# Set Admin User and Password (default is 123456, so you should change it)
sudo /usr/local/lsws/admin/misc/admpass.sh

# Start Server Service
sudo service lsws start</pre>

## 7b. OpenLiteSpeed on ARM

This is something I got working with a bit of know-how.

<pre class="lang:default decode:true " ># Install a few extra packages
sudo apt-get install autoconf libtool
# If building from a clean system
sudo apt-get install zlib1g-dev libssl-dev libpcre3-dev libgeoip-dev libexpat1-dev

# Edit the configuration file
nano configure.am

# Change the two mentions of i686 to armv7
# ...

# Rebuild the configuration scripts
aclocal
automake --add-missing
autoconf

# Or just
automake --add-missing
autoreconf

./configure</pre>

Now, before you build, you need to edit a file &#8220;**include/ls_atomic.h**&#8220;.

<pre class="lang:default decode:true " >nano include/lsr/ls_atomic.h

// Near the top of the file, defining the ls_atom_xptr_t union
// there should be 2 lines like this:

#if defined( __i386__ )

// Modify them to be this:

#if defined( __i386__ ) || defined( __arm__ )


// uncomment this define
#define USE_GCC_ATOMIC


// Then, inside the USE_GCC_ATOMIC section, change another __i386__ define to this:

#if defined( __i386__ ) || defined( __arm__ )
</pre>

## 8a. Install PHP 7

<pre># Update PHP Build version(s)
nano /usr/local/lsws/admin/html/lib/util/build_php/BuildConfig.php</pre>

The latest version as of this writing is **PHP7.0.0RC4**. The build scripts are unable to fetch the RC builds, so you can manually fetch them as follows:

<pre class="lang:default decode:true " ># Log in as root
su

# Go to the build folder
cd /usr/local/lsws/phpbuild
wget https://downloads.php.net/~ab/php-7.0.0RC4.tar.gz</pre>

Now, build PHP 7 inside the UI.

NOTE: php.ini may not be copied, so you can acquire the file as follows:

<pre class="lang:default decode:true " >cd /usr/local/lsws/lsphp7/lib/
wget https://raw.githubusercontent.com/php/php-src/master/php.ini-production -O php.ini</pre>

## 8b. PHP 7 Extensions

To use PHPiz, you need autoconf.

<pre class="lang:default decode:true " >sudo apt-get install autoconf</pre>

**GD:** already installed (built-in)

**APCu (branch):** <https://github.com/krakjoe/apcu/tree/seven>

<pre class="lang:default decode:true " >cd ~
git clone https://github.com/krakjoe/apcu.git
cd apcu
git checkout seven       # PHP7 WIP Branch
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

## 9. Web Server Configuration

Under **General->Index Files**, add **index.php**.

Under **External App**, click **Edit**.

<pre class="lang:default decode:true " >Name: lsphp7

Command: $SERVER_ROOT/fcgi-bin/lsphp7</pre>

To correctly handle CloudFlare&#8217;s IP proxying in LiteSpeed, you need to set **General Settings->Use Client IP in Header** to either **YES** or **Trusted IP Only**.

If using Trusted IPs Only, under **Security->Access Control**, set the **Allowed List** to:

<pre class="lang:default decode:true " >ALL, 103.21.244.0/22T, 103.22.200.0/22T, 103.31.4.0/22T, 104.16.0.0/12T, 108.162.192.0/18T, 141.101.64.0/18T, 162.158.0.0/15T, 172.64.0.0/13T, 173.245.48.0/20T, 188.114.96.0/20T, 190.93.240.0/20T, 197.234.240.0/22T, 198.41.128.0/17T, 199.27.128.0/21T, 2400:cb00::/32T, 2405:8100::/32T, 2405:b500::/32T, 2606:4700::/32T, 2803:f800::/32T</pre>

This will change the server PHP variable **$\_SERVER [&#8216;REMOTE\_ADDR&#8217;]** from the CloudFlare IP to your IP. **$\_SERVER [&#8216;PROXY\_REMOTE_ADDR&#8217;]** will now contain the CloudFlare IP.

IPs sourced from here: <https://www.cloudflare.com/ips>

Adding a trailing T marks them as trusted.

Add a **Listener**, Port **443**, Secure **YES**. Add a **Virtual Host Mapping** to it. 

Under **SSL**, set the **Private Key File** (something.key), **Certificate File** (something.crt), and the **CA Certificate File** (ca.pem). HTTPS will not work until you do this.

Use **Listener->IP Address** of **[ALL] IPv6** to allow incoming connections over both IPv4 and IPv6. This may require a few soft resets to kick in properly (Dashboard was reporting a listener failure for me, until I reset it).