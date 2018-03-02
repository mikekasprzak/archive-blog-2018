---
id: 9177
title: C.H.I.P. (by Next Thing Co) Notes
date: 2016-08-29T01:49:31+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9177
permalink: /2016/08/29/c-h-i-p-by-next-thing-co-notes/
categories:
  - Uncategorized
---
Just some notes.

[<img src="http://blog.toonormal.com/wp-content/uploads/2016/08/chip_pinouts.jpg" alt="chip_pinouts" width="600" height="438" class="aligncenter size-full wp-image-9178" srcset="http://blog.toonormal.com/wp-content/uploads/2016/08/chip_pinouts.jpg 600w, http://blog.toonormal.com/wp-content/uploads/2016/08/chip_pinouts-450x329.jpg 450w" sizes="(max-width: 600px) 100vw, 600px" />](http://blog.toonormal.com/wp-content/uploads/2016/08/chip_pinouts.jpg)

To reinstall (upgrade) the OS, go here:

[flash.getchip.com](http://flash.getchip.com)

You&#8217;re going to need a USB cable, and a jumper wire/paperclip. Ground the FEL line before plugging it in to your PC. If you&#8217;re on Linux, you&#8217;ll also have to follow some funny instructions to give your account permission to access the USB port via the Chrome web browser. For me the variable that&#8217;s supposed to be your login name wasn&#8217;t working, so I just used my login name directly.

The upgrade is all-or-nothing. Kernels can&#8217;t be updated with apt-get (yet).

If you go headless, getting WiFi configured can be a pain, especially if you have a hidden SSID. Common instructions are here:

<https://bbs.nextthing.co/t/setting-up-chip-as-a-headless-server-with-minimal-tools/1505>

The key thing is the command: **nmtui**

You can \*almost\* do everything in it. Manually adding a hidden SSID didn&#8217;t want to take for me.

**SSID IS CASE SENSITIVE** (also no matter how many times you type in an incorrect SSID, it wont work, \*cough\*).

Much further down in the post is some guy that talks about how to do it entirely from the command line. This is what you need.

<https://bbs.nextthing.co/t/setting-up-chip-as-a-headless-server-with-minimal-tools/1505/36>

> nmcli con add con-name **your\_connection\_name** ifname wlan0 type wifi autoconnect no save yes ssid **your\_hidden\_ssid**
> 
> nmcli con modify **your\_connection\_name** wifi.hidden true wifi-sec.key-mgmt wpa-psk wifi-sec.psk **your_passwd**
> 
> \# To connect
  
> nmcli con up **your\_connection\_name**
> 
> \# If it&#8217;s good, permanently make it autoconnect
  
> nmcli con modify **your\_connection\_name** autoconnect yes
  
> \# or use the GUI (nmtui)
> 
> \# To disconnect
  
> nmcli con down **your\_connection\_name** 

SSH comes preinstalled on 4.4. AVAHI (zeroconf) is preconfigured to give it the network name &#8216;chip&#8217; (and chip.local), so you should be able to connect like so:

<pre class="lang:default decode:true " >ssh chip@chip</pre>

Getting the IP address is not ifconfig (though you can do sudo ifconfig).

Instead, use: **ip addr**

To not drive yourself crazy, make an alias for ll.

<pre>nano ~/.bash_aliases

#!/bin/sh

alias ll='ls -alF'
</pre>

Install NodeJS.

https://github.com/nodesource/distributions#debinstall

Setup a simple web server.

<http://stackoverflow.com/a/8427954/5678759>

AVAHI (Zeroconf) is also pre-configured. You should be able to connect to the server like so:

<http://chip:8080>

## 1 Wire

According to the &#8220;DIP&#8221; docs, the 1 Wire bus is located on **LCD_D2** on pin header U13.

<http://docs.getchip.com/dip.html#dip-identification>