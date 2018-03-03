---
id: 8818
title: 'Notes: Big Binary MySQL/MariaDB Logs'
date: 2016-05-17T11:36:56+00:00
author: Mike K
layout: post
guid: /?p=8818
permalink: /2016/05/17/notes-big-binary-mysqlmariadb-logs/
categories:
  - Uncategorized
---
MySQL/MariaDB has several log files.

<https://dev.mysql.com/doc/refman/5.7/en/server-logs.html>

Since moving Ludum Dare to a new server, I ran in to an issue where I was running out of hard drive space. Some details:

  * Ubuntu 14.04
  * MariaDB 10.1
  * WordPress, plus some custom stuff
  * 50 GB of SSD space (main partition)
  * 250 GB of additional SSD space (alt partition)

The database itself is on the alt partition, but I kept running out of main partition space. 

Most Google searches for my problem talk of the regular log files eating space, but my problem was specifically the binary logs. The binary logs are used by the MySQL/MariaDB family of DB engines as both a log of actions, and for synchronized replication.

I discovered the hard drive full problem by running: 

<pre class="lang:default decode:true " >df -h</pre>

I also learned that on some Linuxes, when you run out of hard drive space, it may remap /tmp/ to RAM, but not very much RAM, so some temp files may fail to create because there isn&#8217;t enough space to store them. I had to free up some hard drive space and actually reboot to make it stop doing that. This is an automatic behaviour, so it&#8217;s simpler just to reboot to make in unmap the new /tmp/ partition.

The binary logs on Ubuntu are stored here:

<pre class="lang:default decode:true " >/var/log/mysql/</pre>

And are given names like &#8220;`mariadb-bin.002412`&#8220;. You can find this mentioned in the `my.cnf` file as the &#8220;`log_bin`&#8221; basename.

Binary logs are actually automatically purged, at least in the default Ubuntu install of MariaDB. But the purge time is set to 10 days. With Ludum Dare, we so aggressively did things, that we found 10 days to be too much, and would run out of space.

I&#8217;ve since change &#8220;`expire_log_days`&#8221; to 3, as it was roughly every 4 days I had to clear the logs, so the website would return.

My temporary fix would invole going to the `/var/log/mysql` folder and deleting a bunch of files (because the mysql client can&#8217;t delete files if there is no hard drive space). 

And to make sure it was internalized correctly, I would connect to the DB via the mysql client and run a:

<pre class="lang:default decode:true " >purge binary logs before '2016-05-10';</pre>

Which should be self explanatory.