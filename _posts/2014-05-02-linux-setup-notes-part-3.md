---
id: 6878
title: Linux Setup Notes, Part 3
date: 2014-05-02T14:59:54+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6878
permalink: /2014/05/02/linux-setup-notes-part-3/
categories:
  - Linux
  - Technobabble
---
Linux notes again!!?!

Yes, as it turns out I decided to replace my dead workstation PC (with beefy specs like Water Cooled Quad Core CPU, NVidia GPUs, RAID Array, etc) with a teeny tiny PC slightly larger than a stack of coasters: A Brix BXi3.

[<img src="/wp-content/uploads/2014/05/8760_big-450x325.jpg" alt="8760_big" width="450" height="325" class="aligncenter size-medium wp-image-6879" srcset="/wp-content/uploads/2014/05/8760_big-450x325.jpg 450w, /wp-content/uploads/2014/05/8760_big-640x462.jpg 640w, /wp-content/uploads/2014/05/8760_big.jpg 1000w" sizes="(max-width: 450px) 100vw, 450px" />](http://ca.gigabyte.com/products/product-page.aspx?pid=4742)

I tried using an older NVidia ION powered Nettop, but that machine really didn&#8217;t work well with Ubuntu 14.04 (The Window Manager at least). I&#8217;m told other WMs are fine, but I&#8217;d rather install a Server disto on a lacking machine like that. 

I need a desktop machine, or at least, a 2nd machine I can test this game on easily. So now I have the Brix. The whole thing cost about $500 ($299 box, $90 for 8GB RAM, $90 for 120GB SSD, $20 for Mini-DisplayPort to DVI Video Cable), and it&#8217;s silent&#8230; OH MY!

Older posts can be found here: 

[Part 2](/2014/01/28/linux-setup-notes-part-2/), [Part 1 (Older, more mistakes)](/2013/12/29/linux-setup-notes/)

## Installing an SSH Server

&#8230; is really easy. Too easy. Why did I expect this to be difficult?

<pre>sudo apt-get install openssh-server</pre>

And you&#8217;re done. You can ssh to the machine by the IP, and login using any created account (including the default one you create upon install).

## Connecting to local machines by hostname (.local)

If you know the hostname of a local machine (what you named it upon OS install), you should be able to connect to it use the &#8216;**.local**&#8216; suffix.

So where it says this on a computer:

<pre>myname@mycomputer:~$ _</pre>

Instead of connecting/ssh&#8217;ing by IP address, you can use the hostname directly, using the &#8216;**.local**&#8216; suffix:

<pre>ssh mycomputer.local</pre>

This fancy feature is thanks to an open source app called [avahi](http://en.wikipedia.org/wiki/Avahi_(software)), that comes pre-installed on Ubuntu. It&#8217;s a daemon that listens for it&#8217;s name in a broadcast, and responds if it is them.

If you are on a distro without avahi, you may have to do something like this:

<pre>sudo apt-get install avahi-daemon</pre>

Avahi is compatible with [Apple&#8217;s Bonjour](http://support.apple.com/kb/DL999) (different zeroconf protocol, but supported). For Windows PCs, you can install [Bonjour for Windows](http://support.apple.com/kb/DL999). 

References: [This](http://askubuntu.com/questions/150617/how-to-use-host-names-rather-than-ip-addresses-on-home-network) and [This](http://askubuntu.com/questions/4434/what-does-local-do).

## Changing Host Name

Ha! Now that we know what the hostname is used for, lets change them to something useful.

Edit these two files:

<pre>sudo gedit /etc/hostname
sudo gedit /etc/hosts</pre>

You must restart for the change to fully take effect. There are methods for changing hostname (i.e. sudo hostname), but they will not do important things like reassign the hostname used by Avahi.

References: [This](http://askubuntu.com/questions/9540/how-do-i-change-the-computer-name) and [This](http://askubuntu.com/questions/87665/how-do-i-change-the-hostname-without-a-restart).

## Edit text files from terminal w/o using VIM

VIM is a monster. Let us never use it again.

<pre>nano somefile.txt</pre>

Nano and Pico (usually nano) are &#8220;more normal&#8221; terminal text editors on Linux. They&#8217;re still a little weird, but navigation is natural.

To save a file, press **CTRL+O (^O)** (or ^S on DVORAK). Saving gives you the option to change the filename if you like. Push enter if you have no changes, or when you are done.

To exit, press **CTRL+X (^X)** (or ^B on DVORAK).

## Linux shares to Synology

I&#8217;ve had a Synology fileserver for a few years now. It&#8217;s custom Linux based Mini PC that holds hard drives. And now that I&#8217;ve learned about the above, here are a few notes for myself.

HostName.local works (should be case insensitive).

When using Ubuntu/Nautilus&#8217;s &#8220;Connect to Server&#8221; feature, you can use the prefix ssh:// to open a Linux&#8217;y to the box, instead of relying on Samba/CIFS. **ssh://HostName.local**

Also works in the web browser. <http://hostname.local>

Still haven&#8217;t figured out what&#8217;s wrong with my read performance though. Threads: [one](http://arstechnica.com/civis/viewtopic.php?p=22044068), [two](http://forum.synology.com/enu/viewtopic.php?f=14&t=76549).

I think it has something to do with the whole 4k sectors &#8220;feature&#8221; of newer drives. Actually, I think I&#8217;m almost 100% sure that&#8217;s my problem. None of my drives are formatted for this.

## Synology Tips

To SSD to the synology, do it as root (users will fail).

<pre>ssh root@HostName.local</pre>

Password is the same as admin.

NOTE: If you login as admin, you wont be able to do root commands. Weirdly, there&#8217;s actually a [VPN related exploit](http://www.techienews.co.uk/977216/hard-coded-root-password-found-synology-diskstation-manager-vpn-module/) that makes the root password &#8216;synopass&#8217; from this account.

## Performance Monitoring Tools

Just a link to share.

<http://www.tecmint.com/command-line-tools-to-monitor-linux-performance/>

## Disabling the ALT key Search Feature

Go to **System Settings -> Keyboard -> Shortcuts -> Launchers**.

Find the setting &#8220;**Key to show the HUD**&#8220;, select it, push **backspace**.

[<img src="/wp-content/uploads/2014/05/VMgyr-450x299.jpg" alt="VMgyr" width="450" height="299" class="aligncenter size-medium wp-image-6903" srcset="/wp-content/uploads/2014/05/VMgyr-450x299.jpg 450w, /wp-content/uploads/2014/05/VMgyr-640x426.jpg 640w, /wp-content/uploads/2014/05/VMgyr.jpg 797w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2014/05/VMgyr.jpg)

Reference: <http://askubuntu.com/a/122232>

## OpenGL Benchmarking

First, to log details of the OpenGL driver, install mesa-utils.

<pre>sudo apt-get install mesa-utils</pre>

Then run **glxinfo**. You&#8217;ll probably want to grep some of that output. [Source](http://askubuntu.com/questions/47062/what-is-terminal-command-that-can-show-opengl-version).

To benchmark install glmark2 (or glmark2-es2, or both).

<pre>sudo apt-get install glmark2</pre>

Then simply run **glmark2**. An overlay will popup, and it&#8217;ll start testing. [Source](http://askubuntu.com/questions/31913/how-to-perform-a-detailed-and-quick-3d-performance-test).