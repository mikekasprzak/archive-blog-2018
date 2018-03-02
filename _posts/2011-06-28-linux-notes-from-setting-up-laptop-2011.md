---
id: 4407
title: Linux Notes from setting up Laptop 2011
date: 2011-06-28T12:43:12+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4407
permalink: /2011/06/28/linux-notes-from-setting-up-laptop-2011/
categories:
  - Technobabble
---
I recently purchased a new laptop (Lenovo X220) and made some upgrades (160 GB SSD, 8 GB RAM) making it a great little development machine. I like it so much, that I want to use it even for my Linux needs.

I like to do a post or series of posts whenever I do a notable Linux install, often because there are so many nuances you need to deal with that are easy to forget.

<!--more-->Here is the last one I did:

</2010/11/12/ubuntu-on-the-zotac/>

This time though, rather than the creating a partition for Linux, I decided to try out WUBI, a utility that comes with Ubuntu. Simply place any Ubuntu LiveCD in your CD/DVD-ROM while you&#8217;re still in Windows, and it will offer to Install Ubuntu for you.

What&#8217;s nice about WUBI is it lets you Install Ubuntu to your Windows File System inside a large file. If I ever decide I need my hard drive space back, I can simply uninstall WUBI/Ubuntu as I would any other Windows program. Easy! 

WUBI has another bonus. Whatever drive it is installed on, that drive is automatically mounted as &#8220;/host/&#8221;. I always install/do my coding stuff on a 2nd partition &#8220;D:\&#8221;, so I installed my ubuntu there too. So awesomely, I can access all other files on my &#8220;D:&#8221; work drive.

Currently I am running 64bit Ubuntu 11.4 on my laptop. The install procedure was rather routine. I&#8217;ve been using the now stock &#8220;Unity&#8221; window manager on the last few Ubuntu&#8217;s, and actually like the latest incarnation (at least, as a laptop and netbook window manager).

I start off by undocking many programs from the sidebar. I then run and dock the Calculator, Terminal, and System Monitor.

To make Ubuntu boot smoothly, without prompts, I needed to change a few settings (just as I did on the install linked above).

**Applications->Installed->System Settings->System (section)->Login Screen**. Unlock by pressing the button, and set myself as the auto-login user. This fixes the need for me to login every time Ubuntu starts.

**Applications->Installed->System Settings->Personal (section)->Screensaver**. Uncheck &#8220;Lock screen when screensaver is active&#8221;.

**Applications->Installed->System Settings->Other (section)->Passwords and Encryption Keys**. Right click on the &#8220;**Passwords: login**&#8221; group, and pick &#8220;**Change Password**&#8220;. Type in your password, and leave the new password fields both blank. Yes this is unsafe, but MAAAN&#8230; it&#8217;s super annoying to have it set. This fixes the prompt for a password to connect to any wireless networks.

I fire up a terminal and install a few programs.

`sudo apt-get install geany<br />
sudo apt-get install subversion<br />
sudo apt-get install mercurial<br />
sudo apt-get install automake<br />
sudo apt-get install freeglut3-dev (for opengl/mesa)`

The next two I do for simplicities sake. I build SDL from the Mercurial repository now, but getting all the dependencies right can be a pain. I did the manual way of guessing all the packages at first, and it was nothing but annoying. In the future, I hope I just don&#8217;t bother and do the following: Simply install old SDL just to get the right dependencies.

`sudo apt-get install libSDL-dev<br />
sudo apt-get install libSDL-mixer1.2-dev`

On every Linux system I set up, I work out of a &#8220;Code&#8221; folder inside my home folder. Inside &#8220;Code&#8221; I make a &#8220;Build&#8221; folder for any 3rd party libraries i want to build (i.e. SDL).

`mkdir Code<br />
cd Code<br />
mkdir Build<br />
cd Build<br />
hg clone http://hg.libsdl.org/SDL<br />
hg clone http://hg.libsdl.org/SDL_mixer`

SDL comes pre-configured, but SDL_mixer does not. Be sure you have automake installed, then run:

`cd SDL_mixer<br />
./autogen.sh<br />
cd ..`

Now SDL Mixer can be built.

`cd SDL<br />
./configure<br />
make -j 4<br />
sudo make -j 4 install<br />
cd ..<br />
cd SDL_mixer<br />
./configure<br />
make -j 4<br />
sudo make -j 4 install<br />
cd ..`

This installs both in /usr/local/. Done.

## Additional System Specific Tweaks

My laptop is a Lenovo (IBM). It has one of those nub mice in the middle of the keyboard. I like nub mice. My old Toshiba laptop from College had one, and I got rather good/comfortable using it.

The nub has an auto-scroll button. Under Windows this lets me press it, and whichever direction the nub points, is the way the window will scroll.

<del datetime="2011-06-28T19:17:37+00:00">To get this behavior on Linux, I had to install a program.</del>

<del datetime="2011-06-28T19:22:22+00:00"><code>sudo apt-get install gpointing-device-settings&lt;br />
gpointing-device-settings</code></del>

<del datetime="2011-06-28T19:22:22+00:00">This is an easy-to-use GUI for configuring this. Click the 2nd sidebar item &#8220;TPPS/2 IBM TrackPoint&#8221;. Click the &#8220;Use Wheel Emulation&#8221; checkbox. Click the Horizontal and Vertical checkboxes. Finally make sure the drop-down-box and change the button to &#8220;BUTTON 2&#8221;. Done! Scrolly goodness.</del>

Update: The above does work, but the settings do not save. The above relies on something called &#8220;HAL&#8221; which is no longer used.

The correct &#8220;New&#8221; solution is to create a config file as suggested in the xorg.conf.d section of this document:

[http://www.thinkwiki.org/wiki/How\_to\_configure\_the\_TrackPoint#xorg.conf.d](http://www.thinkwiki.org/wiki/How_to_configure_the_TrackPoint#xorg.conf.d)

Open a shell and go here:

`cd /usr/share/X11/xorg.conf.d<br />
sudo gedit 20-thinkpad.conf`

Now paste this file:

<pre>Section "InputClass"
	Identifier	"Trackpoint Wheel Emulation"
	MatchProduct	"TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"
	MatchDevicePath	"/dev/input/event*"
	Option		"EmulateWheel"		"true"
	Option		"EmulateWheelButton"	"2"
	Option		"Emulate3Buttons"	"false"
	Option		"XAxisMapping"		"6 7"
	Option		"YAxisMapping"		"4 5"
EndSection</pre>

Save the file, then reboot, and your settings will be correct (i.e. the nub scroller will work as expected under Windows).

\* \* *

Also, the laptop has a pair of &#8220;Web Back&#8221; and &#8220;Web Forward&#8221; keys. In Windows I changed these to extra page-up and page-down keys (with [SharpKeys](http://www.randyrants.com/sharpkeys/)). I did that in Linux as follows:

First, I created the following Shell script (startup.sh) and placed it in my home folder.

`#!/usr/bin/bash</p>
<p>xmodmap -e "keycode 166=Page_Up"<br />
xmodmap -e "keycode 167=Page_Down"</p>
<p>exit 0`

http://en.kioskea.net/faq/3348-ubuntu-executing-a-script-at-startup-and-shutdown

I opened a shell and gave the script execute permissions.

`chmod +x startup.sh`

Then under **System Settings->Personal (section)->Startup Applications**, I added my shell script.

## Windows Notes

WUBI enables the Windows bootloader. By default, the Windows Bootloader sets a 10 second timeout. Thanks to the SSD, my Windows 7 boot times are insanely fast, but having to wait 10 seconds for a bootloader is crazy talk.

Solution, a free program EasyBCD can be used to configure settings of the bootloader.

<http://neosmart.net/dl.php?id=1>

Note: I suspect the Windows Bootloader uses &#8220;whole time&#8221;, as in, it counts seconds rounded up to the nearest whole second of the current system clock. For this reason, 1 second wasn&#8217;t enough. It worked sometimes, but not always. So I&#8217;ve made the bootloader last for 2 seconds, guaranteeing at least 1 whole second.

Also, setting the web keys in Windows, I used a program SharpKeys:

<http://www.randyrants.com/sharpkeys/>

Great! All done!