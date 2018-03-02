---
id: 9296
title: 'Notes: Setting up a Webcam Server'
date: 2016-09-21T00:29:17+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9296
permalink: /2016/09/21/notes-setting-up-a-webcam-server/
categories:
  - Uncategorized
---
[<img src="http://blog.toonormal.com/wp-content/uploads/2016/09/kirbytest.png" alt="kirbytest" width="636" height="477" class="aligncenter size-full wp-image-9297" srcset="http://blog.toonormal.com/wp-content/uploads/2016/09/kirbytest.png 636w, http://blog.toonormal.com/wp-content/uploads/2016/09/kirbytest-450x338.png 450w" sizes="(max-width: 636px) 100vw, 636px" />](http://blog.toonormal.com/wp-content/uploads/2016/09/kirbytest.png)

I have a small room, also known as a closet _\*cough\*_ that I have my printer and some small computers in. Some day I plan to put a 3D printer there as well. It would be wise to set up a simple webcam, so I can check on it. You know, in case of fire and stuff. 😉

<!--more-->

## Setting up a webcam w/o a UI

It&#8217;s easy. Just plug it in. Before you do though, list your usb devices.

<pre class="lang:default decode:true " >lsusb</pre>

Now plug it in, and list them again. This will help you find the **BUS** and **DEVICE_ID** of your device.

<pre class="lang:default decode:true " >Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 002: ID 1e4e:0110 Cubeternet                    # &lt;-- This one
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 005 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
</pre>

If the device and driver is correctly initialised, you will have 1-or-more video devices in &#8220;/dev&#8221;.

<pre class="lang:default decode:true " >ls /dev/video*

# with one camera, you should get
/dev/video0</pre>

To get a whole bunch of data about your device, do a verbose lsusb.

<pre class="lang:default decode:true " ># List everything about -s BUS:DEVICE (i.e. 002:002, 2:2, etc)
lsusb -v -s 002:002

# To get the resolutions available, grep it
lsusb -v -s 002:002 | egrep "Width|Height"
</pre>

My cheap camera&#8217;s resolutions return this:

<pre class="lang:default decode:true " >wWidth                            640
        wHeight                           480
        wWidth                            352
        wHeight                           288
        wWidth                            320
        wHeight                           240
        wWidth                            176
        wHeight                           144
        wWidth                            160
        wHeight                           120
        wWidth( 0)                        640
        wHeight( 0)                       480
        wWidth( 1)                        352
        wHeight( 1)                       288
        wWidth( 2)                        320
        wHeight( 2)                       240
        wWidth( 3)                        176
        wHeight( 3)                       144
        wWidth( 4)                        160
        wHeight( 4)                       120
</pre>

Meaning my camera supports 5 resolutions:

  * **640&#215;480** (0) ** 4:3
  * **352&#215;288** (1) ** 11:9
  * **320&#215;240** (2) ** 4:3
  * **176&#215;144** (3) ** 11:9
  * **160&#215;120** (4) ** 4:3

My camera&#8217;s default seems to be **352&#215;288**.

## Setting up Motion

Install it.

<pre class="lang:default decode:true " >sudo apt-get install motion

# Next, create a config file
mkdir ~/.motion
nano ~/.motion/motion.conf</pre>

At a minimum, you need this in your config:

<pre class="lang:default decode:true " >stream_port 8081		# the port of the web server
stream_localhost off	# default is on (localhost only)
</pre>

My config looks like this:

<pre class="lang:default decode:true " >stream_port 8081		# the port of the web server
stream_localhost off	# default is on (localhost only)
stream_quality 95		# default: 50 (%)
output_pictures off		# default: on, writes jpegs every second
width 640
height 480

#videodevice /dev/video0
</pre>

You can customize it to suit your needs.

Docs: <http://www.lavrsen.dk/foswiki/bin/view/Motion/ConfigFileOptions>

**NOTE:** Be careful with the documentation above! Features like **webcam_port** are included in the documentation, but they&#8217;re actually **deprecated** and no longer supported. The docs do say this, but you may not notice this unless you read ever word.

Test it by running Motion.

<pre class="lang:default decode:true " >motion

# CTRL+C to exit</pre>

If you want it always running, you&#8217;ll have to set it up as a service.

Now simply visit **port 8081** of the machine to view the active webcam.

Motion has some neat features. As the name suggests, it can actually detect motion. Check out the docs to learn more. 

Reference: <https://gist.github.com/endolith/2052778>

## Variant: Running it when you&#8217;re not home

Here&#8217;s a clever idea:

A script that regularly checks if a machine with your phone&#8217;s mac address can be reached on the local network: 

http://superuser.com/a/512706