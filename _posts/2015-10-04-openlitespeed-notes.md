---
id: 7623
title: OpenLiteSpeed Notes
date: 2015-10-04T03:40:35+00:00
author: Mike K
layout: post
guid: /?p=7623
permalink: /2015/10/04/openlitespeed-notes/
categories:
  - Uncategorized
---
More notes. 🙂

<!--more-->

Running the latest beta version as of Oct 1st: 1.4.11

## Saving a few bytes

LiteSpeed will include an extra header that says what it is, and what version it is.

In **Server Configuration->General Settings**, **Server Signature** can be set to **Hide Full Header**, and it will not waste data self identifying as &#8220;LiteSpeed&#8221;.

Similarly, PHP can be tweaked to also not self identify.

<pre class="lang:default decode:true " >sudo nano /usr/local/lsws/lsphp7/lib/php.ini

# Find and make the following change
expose_php = Off</pre>

In total this shaves off 40-some bytes per request, important if you&#8217;re trying to keep responses less than the size of a TCP packet (worst case, 1280 bytes on IPv6).

## Log File Behaviour

**NOTE:** There is a bug that causes access.log files not to roll-over (error.log&#8217;s are fine). I&#8217;ve since reported it.

Log files typically go here:

<pre class="lang:default decode:true " >/usr/local/lsws/logs/error.log
/usr/local/lsws/logs/access.log
/usr/local/lsws/logs/lsrestart.log       # any time you don't gracefully restart
/usr/local/lsws/logs/stderr.log          # std error

# Admin Control Panel
/usr/local/lsws/admin/logs/error.log
/usr/local/lsws/admin/logs/access.log

# Per Virtual Host
/usr/local/lsws/Example/logs/error.log   # disabled by default (goes to main error.log)
/usr/local/lsws/Example/logs/access.log
</pre>

**PHP Errors** get written to **error.log** as **NOTICE** level events.

Also, any time you reboot, **the main error log rolls over**!

In the control panel, **Tools->Server Log Viewer** can be used to view the contents of the primary **error.log** file.

## Access Log Format

LiteSpeed supports Apache-style log strings.

This Apache-style Access Log string will correctly log what CloudFlare proxy the traffic was piped through (or &#8211; if direct).

<pre class="lang:default decode:true " >%h [%{PROXY_REMOTE_ADDR}e] %l %u %t \"%r\" %&gt;s %b \"%{Referer}i\" \"%{User-agent}i\"</pre>

The default string looks like this (also known as NCSA extended/combined):

<pre class="lang:default decode:true " >%h %l %u %t \"%r\" %&gt;s %b \"%{Referer}i\" \"%{User-agent}i\"</pre>

Reference: http://httpd.apache.org/docs/2.0/mod/mod\_log\_config.html#formats

## Compress Logs

You&#8217;ll want to enable this in several places.
  
**Server Configuration->Log->Access Log**
  
**WebAdmin Settings->General->Access Log**

Your Virtual Hosts. Your VHost Template.

## Create a Template

Duplicate a template, such as the one in &#8220;**/usr/local/lsws/conf/templates/ccl.conf**&#8220;. Give write permission.

<pre class="lang:default decode:true " >cd /usr/local/lsws/conf/templates
sudo cp ccl.conf myhost.conf
sudo chmod +x myhost.conf
sudo chown lsadm:lsadm myhost.conf</pre>

Click the Add button on the VHost Templates page, and make it point to your new template.

<pre class="lang:default decode:true " >Template Name:    MyHost
Template File:    /usr/local/lsws/conf/templates/myhost.conf
Mapped Listeners: Default
Notes:</pre>