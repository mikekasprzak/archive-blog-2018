---
id: 7813
title: MariaDB Cluster Install notes
date: 2015-11-23T16:01:20+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=7813
permalink: /2015/11/23/mariadb-cluster-install-notes/
categories:
  - Technobabble
---
I don&#8217;t write blog posts anymore. I write notes. 🙂

<!--more-->

## Preface

Prebuilt packages of mainline MariaDB 10.1 are only available for x86 and x86_64 architectures. For other architectures, you need to build it from source.

<https://downloads.mariadb.org/>

Main repository contents, find the override file for your specific distro: <http://ports.ubuntu.com/indices/> 

To check your distro, do this:

<pre class="lang:default decode:true " >lsb_release -a</pre>

**MariaDB 10.0** was added to the **universe** repository in Vivid (Ubuntu 15.04). It lacks Galera patches. No backport is available.

A broken **Galera 3** was added to the **universe** repository in Wily (Ubuntu 15.10). FWIW there is also a Percona Server Galera-3 install, but this is specifically for Percona. There is however a working copy of Galera-3 in the Ubuntu 16.04 pre-release folders.

## Building MariaDB and Galera Debian packages from source

Reference: <http://askubuntu.com/a/28373/364657>

<pre class="lang:default decode:true " ># Follow MOST of the instructions on MariaDB to set-up your nearest mirror
sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb [arch=amd64,i386] http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'
sudo add-apt-repository 'deb-src http://lon1.mirrors.digitalocean.com/mariadb/repo/10.1/ubuntu trusty main'
# We're using the main repository to check dependencies, and source repo for the code

# Install a few more packages
sudo apt-get install build-essential dpkg-dev devscripts hardening-wrapper libcrack2-dev

# Grab source and Install
sudo apt-get build-dep mariadb-server-10.1
sudo apt-get source --compile mariadb-server-10.1
# Alternatively, no "--compile". go in to directory and do:
# dpkg-buildpackage -rfakeroot -uc -b

# Next, we need to build Galera

# Install a few more packages (needed to build)
sudo apt-get install scons check libboost-program-options-dev

# Get the source code: http://galeracluster.com/downloads/
wget http://releases.galeracluster.com/source/galera-3-25.3.13.tar.gz

# Unzip and build
tar -axf galera-3-25.3.13
cd galera-3-25.3.13
dpkg-buildpackage -rfakeroot -uc -b</pre>

If successful, the packages \*can\* be installed with this&#8230;

<pre>sudo dpkg -i &lt;package>.deb</pre>

Unfortunately, that doesn&#8217;t help us when it comes to dependencies. It can be done with many &#8220;dpkg -i <package>&#8221; and &#8220;apt-get install -f&#8221; calls, but it&#8217;s ugly.

Instead, you should move the files to a folder, and set-up a Debian Packages repository.

A simple is just a folder with a Packages list. Here&#8217;s how we generate that list:

<pre class="lang:default decode:true " ># Make a folder, move files in to it.
mkdir myrepos
mv *.deb myrepos

cd myrepos

# Generate the Packages.gz file that debian/ubuntu look for
dpkg-scanpackages . /dev/null | gzip -9c &gt; Packages.gz</pre>

Now, add the repository to your sources.list:

<pre class="lang:default decode:true " >sudo nano /etc/apt/sources.list

# Assuming it's in your home directory
deb file:///home/me/myrepos /

# Alternatively, move the files to a web server and add it that way
deb http://my.website.com/myrepos /

# Another way, you can use add-apt-repository instead of editing sources
sudo add-apt-repository 'deb file:///home/me/myrepos /'</pre>

Finally, do an update, and you can install the package as expected.

<pre class="lang:default decode:true " >sudo apt-get update

# Install
sudo apt-get install mariadb-server-10.1</pre>

Reference: Building Galera: <http://galeracluster.com/documentation-webpages/installmariadbsrc.html>

Reference: Debian Repositories: <http://askubuntu.com/a/532/364657>
  
<https://www.debian.org/doc/manuals/repository-howto/repository-howto#using-a-repository>
  
<https://www.debian.org/doc/manuals/repository-howto/repository-howto#id3032359>

## Configuring MariaDB

On Ubuntu, MariaDB settings go in **/etc/mysql/my.cnf**

By default, MariaDB only listens on Localhost (127.0.0.1). To make it listen on all interfaces, comment-out the **bind-address** line. To explicitly listen to all, make it &#8220;**0.0.0.0**&#8220;.

This is insecure, but it means the Firewall is now responsible for blocking unwanted traffic.

Reference: [how-to-configure-mysql-and-mariadb-to-accept-remote-connections.html](http://www.itworld.com/article/2861513/how-to-configure-mysql-and-mariadb-to-accept-remote-connections.html)

## Configuring Galera Cluster

Also inside **/etc/mysql/my.cnf**:

<pre class="lang:default decode:true " >sudo nano /etc/mysql/my.cnf

# Find the Galera section of the file

# For primary server, do something like this:

[galera]
# Mandatory settings
wsrep_on=ON
wsrep_provider=/usr/lib/libgalera_smm.so
wsrep_cluster_name=my_cluster_name
wsrep_cluster_address="gcomm://ip_of_primary,ip_of_secondary" # Optional for primary??
wsrep_node_name=my_node_name
#wsrep_node_address=    # Set this to your Ethernet IP, if not connected directly to the internet
wsrep_provider_options="pc.weight=3"  # See Galera docs. Say this server is more important.
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
innodb_doublewrite=1

# For clients, do something like this

[galera]
# Mandatory settings
wsrep_on=ON
wsrep_provider=/usr/lib/libgalera_smm.so
wsrep_cluster_name=my_cluster_name
wsrep_cluster_address="gcomm://ip_of_primary,ip_of_secondary"
wsrep-node-address=my_ethernet_adapter_ip_address
wsrep_node_name=my_node_name
#wsrep_provider_options="pc.weight=1"  # default
binlog_format=row
default_storage_engine=InnoDB
innodb_autoinc_lock_mode=2
innodb_doublewrite=1
wsrep_sst_method=rsync    # default is rsync, but rsync locks writes
wsrep_sst_receive_address=my_public_ip_address
</pre>

## Starting the Primary Server in a Galera Cluster

Start the primary server like so:

<pre class="lang:default decode:true " ># 'service mysql restart' ignores arguments, so we need to do it this way
sudo service mysql stop
sudo service mysql start --wsrep-new-cluster
</pre>

You can permanently set it to restart by editing &#8220;/etc/init.d/mysql&#8221;. 

Change the call to mysql_safe as follows:

<pre class="lang:default decode:true " ># Change this:
/usr/bin/mysqld_safe "${@:2}" &gt; /dev/null 2&gt;&1 &

# To this:
/usr/bin/mysqld_safe --wsrep-new-cluster "${@:2}" &gt; /dev/null 2&gt;&1 &</pre>

Source: <http://stackoverflow.com/a/25827488>

The node that calls &#8211;wsrep-new-cluster is the master. The clients are started normally without it.

The clients will fail if there&#8217;s no server. Even the main server, if you don&#8217;t run &#8211;wsrep-new-cluster, it&#8217;ll think it&#8217;s a client.

The list of servers a client will attempt to connect to is the **wsrep\_cluster\_address** line in your config.

## Allowing Clients of your Galera Server

You need to unblock some ports on the primary server&#8217;s firewall.

  * **3306** &#8211; MySQL port, TCP. Used for **mysqldump SST** (State Snapshot Transfer, i.e. Init via mysqldump)
  * **4567** &#8211; TCP & UDP. Used for Galera Cluster replication traffic (??)
  * **4568** &#8211; TCP. Used for **IST** (Incremental State Transfer)
  * **4444** &#8211; TCP. Used for **SST** (State Snapshot Transfer, everything but mysqldump)

**SST** is how a client node is fully initialized. **IST** is how clients get their incremental updates.

SST methods have varying degrees of blocking. RSYNC (default) blocks writes, MySQLDump blocks everything (ugh), XtraBackup is **non-blocking** (see below).

Port Reference: <http://galeracluster.com/documentation-webpages/firewallsettings.html>

SST Reference: <http://galeracluster.com/2015/07/node-can-not-join-the-cluster-how-to-debug-issues-with-sst/>

## Starting Clients

Once you&#8217;ve correctly configured the clients, you can simply start mysql. No changes are required. It should just work.

<pre class="lang:default decode:true " >sudo service mysql stop
sudo service mysql start</pre>

All tables will by synchronized with the original.

Most importantly, that **includes the user table**. Login credentials will be the same no matter which node you connect to.

This can be a problem for Debian and Ubuntu installs, thanks to a worker user named **debian-sys-maint**. This is used by &#8216;service mysql&#8217; (start, stop, etc). Its password is stored in **/etc/mysql/debian.cnf**

<pre class="lang:default decode:true " >cat /etc/mysql/debian.cnf
# the file looks something like this:

[client]
host     = localhost
user     = debian-sys-maint
password = 37he7ar43hau7a38
socket   = /var/run/mysqld/mysqld.sock
[mysql_upgrade]
host     = localhost
user     = debian-sys-maint
password = 37he7ar43hau7a38
socket   = /var/run/mysqld/mysqld.sock
basedir  = /usr
</pre>

You&#8217;ll want to look at this file on the Primary server, and copy the passwords to all the clients. That seems to be the easiest way to handle this.

Reference: <https://blog.mariadb.org/installing-mariadb-galera-cluster-on-debian-ubuntu/>

## Viewing Galera Cluster Status

<pre class="lang:default decode:true " >SHOW STATUS LIKE 'wsrep_%';

wsrep_connected           # If Galera is enabled
wsrep_cluster_size        # How many nodes in the cluster
wsrep_local_state_comment # Current status of Synchronization (Synced, Donor/Desynced)</pre>

**TODO:** http://galeracluster.com/documentation-webpages/monitoringthecluster.html

Reference: <https://mariadb.com/kb/en/mariadb/getting-started-with-mariadb-galera-cluster/>

## Further Galera Configuration

TODO

<http://galeracluster.com/documentation-webpages/mysqlwsrepoptions.html#wsrep-sst-method>

[https://mariadb.com/kb/en/mariadb/galera-cluster-system-variables/#wsrep\_sst\_receive_address](https://mariadb.com/kb/en/mariadb/galera-cluster-system-variables/#wsrep_sst_receive_address)

## Listing Users

<pre class="lang:default decode:true " ># List users with a query string
SELECT User,Host FROM mysql.user;

# To build your own query string, here's what you can ask for:
SHOW COLUMNS FROM mysql.user;

# List users who have passwords
SHOW GRANTS;</pre>

Reference: <http://dev.mysql.com/doc/refman/5.7/en/show-grants.html>

## Creating Users

Prefer **CREATE USER**. Inserting directly in to the mysql.user table will not replicate correctly across a Galera cluster.

<pre class="lang:default decode:true " >CREATE USER my_username IDENTIFIED BY 'my_password';</pre>

Reference: <http://galeracluster.com/documentation-webpages/userchanges.html>

## Resetting (and setting) MySQL Passwords

If you ever find yourself in a situation where you can&#8217;t log in, you can disable authentication and log in to the server locally.

**NOTE:** If this is a client node of a Galera cluster, your passwords were likely taken from the Primary node (both your users, and debian-sys-maint). See the **Starting Clients** section above.

<pre># Stop the service
service mysql stop
# If you can't stop, you can alternatively do:
pkill mysql
# The service will gracefully shut down.

mysqld --skip-grant-tables &
mysql
update mysql.user set Password=PASSWORD('your_password') WHERE User='username'
service mysql stop
service mysql start
</pre>

Reference: [https://www.debian-administration.org/article/442/Resetting\_a\_forgotten\_MySQL\_root_password](https://www.debian-administration.org/article/442/Resetting_a_forgotten_MySQL_root_password)

## Building XtraBackup Debian packages from source

Reference: <https://www.percona.com/doc/percona-xtrabackup/2.3/installation/apt_repo.html>

<pre class="lang:default decode:true " ># Add key and repos
sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
echo "deb [arch=amd64,i386] http://repo.percona.com/apt "$(lsb_release -sc)" main" | sudo tee /etc/apt/sources.list.d/percona.list
echo "deb-src http://repo.percona.com/apt "$(lsb_release -sc)" main" | sudo tee -a /etc/apt/sources.list.d/percona.list

# Update packages list
sudo apt-get update

# Install dependencies
sudo apt-get install build-essential flex bison automake autoconf libtool cmake libaio-dev mysql-client libncurses-dev zlib1g-dev libgcrypt11-dev libev-dev libcurl4-gnutls-dev
sudo apt-get build-dep percona-xtrabackup

# Fetch and build DEB from sources
sudo apt-get source --compile percona-xtrabackup
</pre>

## Using XtraBackup

TODO

<pre class="lang:default decode:true " >sudo apt-get install xtrabackup</pre>

Reference: [digitalocean.com/&#8230;/percona-xtrabackup-on-ubuntu-14-04](https://www.digitalocean.com/community/tutorials/how-to-create-hot-backups-of-mysql-databases-with-percona-xtrabackup-on-ubuntu-14-04)

https://www.percona.com/doc/percona-xtrabackup/2.3/xtrabackup\_bin/xtrabackup\_binary.html

https://www.percona.com/doc/percona-xtrabackup/2.3/innobackupex/privileges.html

## Configuration Optimization

Reference: <https://www.percona.com/blog/2014/11/17/typical-misconceptions-on-galera-for-mysql/>

I did some benchmarks. My read speed for small queries was around **4ms**, and write speeds were around **80ms**. That seemed a bit much.

Making the following changes improved it.

<pre class="lang:default decode:true " ># Make sure you have each of these lines set in your my.cnf

log_bin                     # Should already be set (default Ubuntu file)
log_slave_updates           # I believe this makes daisy chaining possible ?

binlog_format = ROW         # Part of our Galera config


# Finally, down in your Galera config, set this:

innodb_flush_log_at_trx_commit = 2</pre>

> You can achieve better performance by setting [innodb\_flush\_log\_at\_trx_commit] different from 1, but then you can lose up to one second worth of transactions in a crash. With a value of 0, any mysqld process crash can erase the last second of transactions. With a value of 2, only an operating system crash or a power outage can erase the last second of transactions.

Reference: [http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar\_innodb\_flush\_log\_at\_trx\_commit](http://dev.mysql.com/doc/refman/5.1/en/innodb-parameters.html#sysvar_innodb_flush_log_at_trx_commit)

With these changes, my write speed dropped from **~80ms** to **~5ms**.