---
id: 9344
title: 'Notes: USB/IP'
date: 2016-09-25T02:11:15+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9344
permalink: /2016/09/25/notes-usbip/
categories:
  - Uncategorized
---
USB/IP is a Linux tool for sharing USB ports with other computers on your network.

It&#8217;s been available as part of the Kernel since 3.2, but thanks to the older package still being in the Ubuntu repository, it causes confusion. The following is the proper way to use it.

<!--more-->

## Installing USB/IP on the Server

More than likely, USB/IP is already installed. If not, you **may** have to do the following.

<pre class="lang:default decode:true " ># Uninstall bad version
apt-get remove --purge usbip* libusbip*

# Install good version
apt-get install linux-tools-generic

# To backup the modules file (optional but recommended)
cp /etc/modules /etc/modules-`date +%Y%m%d-%H%M%S`.bak

# Start the host driver
modprobe usbip_host
# Start the module on boot (NOTE: this is scary. Be careful that it's a &gt;&gt;)
sh -c "echo 'usbip_host' &gt;&gt; /etc/modules"

# Start the Daemon
/usr/lib/linux-tools/`uname -r`/usbipd -D</pre>

Reference: <https://github.com/solarkennedy/wiki.xkyle.com/wiki/USB-over-IP-On-Ubuntu>

## Installing USB/IP on the Client

Again, it may already be installed:

<pre class="lang:default decode:true " >apt-get install linux-tools-generic

# To backup the modules file (optional but recommended)
cp /etc/modules /etc/modules-`date +%Y%m%d-%H%M%S`.bak

# start the client driver
modprobe vhci-hcd
# Start the module on boot (NOTE: this is scary. Be careful that it's a &gt;&gt;)
sh -c "echo 'vhci-hcd' &gt;&gt; /etc/modules"</pre>

## Binding a local USB port

Now do the following.

<pre class="lang:default decode:true " ># List devices on $remote_host (IP or name)
usbip list -r $remote_host

# Attach to a device
usbip attach -r $remote_host -b 2-1</pre>

Now if you list your usb devices, you should see a brand new bus and all the attached devices.

<pre class="lang:default decode:true " >lsusb

# results
Bus 005 Device 004: ID 1e4e:0110 Cubeternet 
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
...</pre>

## Post Setup Notes

I tried setting up my remote webcam, and it works. 

However, I ran in to an issue that I can&#8217;t stream a 640&#215;480 camera picture, just the default lower resolution one.

Other than that, it&#8217;s working great. Not entirely sure why I&#8217;m limited.

<pre class="lang:default decode:true " ># List all devices (mine is on Bus 2, item 1)
usbip list -l

# Bind a device
usbip bind -b 2-1</pre>

## Fun with Armbian/SunXI

At the time of this writing, Armbian lacks a &#8220;**linux-tools-4.7.3-sunxi**&#8221; package (for Armbian 5.20).

A workaround is to install the generic package as mentioned above.

<pre class="lang:default decode:true " >apt-get install linux-tools-generic</pre>

This should make the following folders available (or something like them):

<pre class="lang:default decode:true " ># /usr/lib/linux-tools-4.4.0-38/

drwxr-xr-x  2 root root    4096 Sep 25 00:26 ./
drwxr-xr-x 47 root root    4096 Sep 25 00:36 ../
-rwxr-xr-x  1 root root   35240 Sep  6 13:12 cpupower*
-rwxr-xr-x  1 root root 1067840 Sep  6 13:12 perf*
-rwxr-xr-x  1 root root   46716 Sep  6 13:12 usbip*
-rwxr-xr-x  1 root root   38568 Sep  6 13:12 usbipd*

# /usr/lib/linux-tools/4.4.0-38-generic/

drwxr-xr-x 2 root root 4096 Sep 25 01:10 ./
drwxr-xr-x 3 root root 4096 Sep 25 01:10 ../
lrwxrwxrwx 1 root root   35 Sep  6 14:08 cpupower -&gt; ../../linux-tools-4.4.0-38/cpupower*
lrwxrwxrwx 1 root root   31 Sep  6 14:08 perf -&gt; ../../linux-tools-4.4.0-38/perf*
lrwxrwxrwx 1 root root   32 Sep  6 14:08 usbip -&gt; ../../linux-tools-4.4.0-38/usbip*
lrwxrwxrwx 1 root root   33 Sep  6 14:08 usbipd -&gt; ../../linux-tools-4.4.0-38/usbipd*
</pre>

The **usbip** and **usbipd** tools expect to find a **/usr/lib/linux-tools/4.7.3-sunxi/** folder.

Make a symlink from generic to that.

<pre class="lang:default decode:true " >cd /usr/lib/linux-tools
ln -s 4.4.0-38-generic 4.7.3-sunxi

# Alternatively, `uname -r` can be used anywhere 4.7.3-sunxi is expected
ln -s 4.4.0-38-generic `uname -r`</pre>

**EDIT:** As of January 2017, the `hwdata` package is required

<pre class="lang:default decode:true " >sudo apt-get install hwdata
</pre>