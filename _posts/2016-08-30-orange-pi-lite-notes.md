---
id: 9189
title: Orange Pi Lite Notes
date: 2016-08-30T04:45:29+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9189
permalink: /2016/08/30/orange-pi-lite-notes/
categories:
  - Uncategorized
---
Hey! It&#8217;s more notes!

[<img src="http://blog.toonormal.com/wp-content/uploads/2016/08/orangepi_lite_detail1-640x482.jpg" alt="orangepi_lite_detail1" width="640" height="482" class="aligncenter size-large wp-image-9190" srcset="http://blog.toonormal.com/wp-content/uploads/2016/08/orangepi_lite_detail1-640x482.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/08/orangepi_lite_detail1-450x339.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/08/orangepi_lite_detail1.jpg 816w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2016/08/orangepi_lite_detail1.jpg)

[<img src="http://blog.toonormal.com/wp-content/uploads/2016/08/Opi_gpio-640x560.png" alt="Opi_gpio" width="640" height="560" class="aligncenter size-large wp-image-9191" srcset="http://blog.toonormal.com/wp-content/uploads/2016/08/Opi_gpio-640x560.png 640w, http://blog.toonormal.com/wp-content/uploads/2016/08/Opi_gpio-450x394.png 450w, http://blog.toonormal.com/wp-content/uploads/2016/08/Opi_gpio.png 800w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2016/08/Opi_gpio.png)

Orange Pi Lite is, IMO, the only difficult Orange Pi to get working. Primarily, because it has WiFi, and no Network socket.

For an OS, use Armbian. http://armbian.com

**WARNING:** the device will be unlit, no LEDs, until the OS image begins to boot. It could be half a minute before you see anything.

It can sometimes take a few tries to program the SD card correctly (either that or I&#8217;m using bad SD cards).

**NOTE:** Armbian will reboot a few times after first inserting a fresh memory card. You should wait a few minutes before you attempt to log in. When you see the red-light flashing, that means it&#8217;s about to reboot.

You&#8217;re going to need a way to view the console. Either by plugging in a mouse/keyboard/tv, or via a USB UART cable. UART pins are beside the USB ports. According to the image above, WHITE, GREEN, BLACK (TX, RX, GND). **NEVER** use the red (doesn&#8217;t provide enough power).

**root** password is **1234**

Now for the work.

If you&#8217;re like me, you have a WPA2 protected WiFi network. I also hide my SSID, so there&#8217;s an extra step needed if you do that.

First, if you&#8217;re not already, become root.

<pre class="lang:default decode:true " >su</pre>

It&#8217;ll save you a bunch of headaches, so again, become root. Don&#8217;t try to do this with sudo.

Generate a wpa_supplicant configuration.

<pre class="lang:default decode:true " >wpa_passphrase "MY_SSID" "MY_WIRELESS_KEY" &gt; /etc/wpa_supplicant/wpa_supplicant.conf</pre>

Edit this file.

<pre class="lang:default decode:true " >nano /etc/wpa_supplicant/wpa_supplicant.conf</pre>

For security reasons, you may want to remove the line that shows your password.

If you use a hidden network, add a line &#8220;scan_ssid=1&#8221; to the network section. It should now look something like this:

<pre class="lang:default decode:true " >network={
        ssid="MY_SSID"
        psk=f8148912f124f9123894f2149214219f8489f12498f12893f49f8234f
        scan_ssid=1      # Again, do this only if you have a hidden SSID
}
</pre>

Save and close the file. You can test the configuration like so.

<pre class="lang:default decode:true " >ifconfig

# if wlan0 isn't there, you can start it like so
ifconfig wlan0 up

# Now, attempt to connect to the network
wpa_supplicant -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf

# You will have to CTRL+Z kill the app whether it succeeds or not.
# You need this working before you continue.
# When it failed for me, the reason was that I had another 
#  wpa_supplicant running in the background. Oops!

# To kill any wpa_supplicant tasks, do this
killall -q wpa_supplicant</pre>

If you wanted to manually connect to the internet, right now, you could do this.

<pre class="lang:default decode:true " >ifconfig wlan0 up

# Notice the -B. That's new. That means run in the background
wpa_supplicant -B -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf

# Get an IP address via DHCP
dhclient wlan0

# Confirm it's up, look for your IP here
ifconfig wlan0</pre>

To make this permanent, open up **/etc/network/interfaces**

Comment out or delete everything but the loopback. Your file should look something like this:

<pre class="lang:default decode:true " >auto wlan0
iface wlan0 inet dhcp
pre-up sudo wpa_supplicant -B -iwlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf
post-down sudo killall -q wpa_supplicant

auto lo
iface lo inet loopback
</pre>

You can then restart networking.

<pre class="lang:default decode:true " >service networking restart</pre>

And you should be on the internet now, and any time you reboot.

You can also now SSH in to it, and stop using your tv/mouse/keyboard. Hooray!

## References:

http://askubuntu.com/a/406167
  
http://forum.armbian.com/index.php/topic/1915-/
  
https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=25104