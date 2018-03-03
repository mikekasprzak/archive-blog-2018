---
id: 6943
title: Croutons and Chromebooks
date: 2014-05-15T10:52:13+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6943
permalink: /2014/05/15/croutons-and-chromebooks/
categories:
  - Linux
  - Technobabble
---
More wacky hardware, I picked up a Samsung Chromebook for cheap.

[<img src="/wp-content/uploads/2014/05/chrome-450x281.jpg" alt="chrome" width="450" height="281" class="aligncenter size-medium wp-image-6944" srcset="/wp-content/uploads/2014/05/chrome-450x281.jpg 450w, /wp-content/uploads/2014/05/chrome-640x400.jpg 640w, /wp-content/uploads/2014/05/chrome.jpg 800w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2014/05/chrome.jpg)

I&#8217;ve specifically been waiting for a deal on the Samsung Chromebook, as it&#8217;s quite unique: It has a [Samsung Exynos](http://en.wikipedia.org/wiki/Exynos) SOC, which contains ARM CPU and GPU (MALI-T604). Next to NVidia&#8217;s efforts, these are some of the most powerful ARM CPUs out there. The GPU is a tiny bit dated though (same one as the original Google Nexus 10), but does support OpenGL ES 3.0 (with an appropriate driver at least).

Why else do I want a Chromebook? To test Ubuntu for ARM. I regularly test on 64bit Intel CPUs, but would like the option to do some more heavy-duty tests on ARM. I do have an Android build, but I want more. So I bought this very specific Chromebook for this.

## Installing Linux (Ubuntu)

[How to Enable Developer Mode and install Crouton](http://www.howtogeek.com/162120/how-to-install-ubuntu-linux-on-your-chromebook-with-crouton/)

Follow those instructions above to enable Developer Mode (ESC+REFRESH+POWER, then CTRL+D). Developer Mode wipes the system, and adds a warning message upon boot (WARNING! DEVELOPER MODE). 

If it&#8217;s a brand-new Chromebook, you may need to force an auto-update. Click on your portrait picture in the lower right corner, then go **Settings->Help** and wait a moment for auto-update to begin.

Grab Crouton ([Link](http://goo.gl/fd3zc)).

Press **CTRL+ALT+T** to open **Crosh**.

From Crosh type **shell**. This will bring up a proper terminal. You can now run Crouton.

<pre>sudo sh -e ~/Downloads/crouton -r trusty -t xfce</pre>

Where &#8216;trusty&#8217; is the Ubuntu version (14.04) and gnome is the Window Manager to install. The default Ubuntu version is &#8216;precise&#8217; (12.04), but that&#8217;s old. Other WM&#8217;s can be installed by using commas (i.e. xfce,kde,gnome,unity). NOTE: I was only able to get xfce working with Ubuntu 14.04.

Using &#8220;list&#8221; instead of a -r or -t argument will list all choices. Running crouton without arguments will list all options.

In case you ever need to uninstall, go to the **/usr/local/chroots** folder and doing:

<pre>sudo delete-chroot -y *</pre>

[Source](https://github.com/dnschneid/crouton/issues/10).

## Using Linux on the Chromebook

Crouton is magical. You actually run both ChromeOS and Ubuntu simultaneously. Dual booting is an option (see the Developer Mode article above for ChrUbuntu details), but this is slicker.

To start your alternative Linux, bring up Crosh (**CTRL+ALT+T**) and type **shell**. From the shell sudo run your WM start command like so:

<pre>sudo enter-chroot startxfce4       # for XFCE
sudo enter-chroot startkde         # for KDE (fails to find $Display)
sudo enter-chroot startgnome       # for Gnome (black screen :(
sudo enter-chroot startunity       # for Unity (if it worked)
sudo enter-chroot                  # to do whatever you want
</pre>

Then the cool part: Press **CTRL+ALT+SHIFT+FORWARD** (and **BACK**) to toggle between ChromeOS and the currently running Linux Window Manager.

## OpenGL Benchmarking

First, to log details of the OpenGL driver, install mesa-utils.

<pre>sudo apt-get install mesa-utils</pre>

Then run **glxinfo**. You&#8217;ll probably want to grep some of that output. [Source](http://askubuntu.com/questions/47062/what-is-terminal-command-that-can-show-opengl-version).

To benchmark install glmark2 (or glmark2-es2, or both).

<pre>sudo apt-get install glmark2</pre>

Then simply run **glmark2**. An overlay will popup, and it&#8217;ll start testing. [Source](http://askubuntu.com/questions/31913/how-to-perform-a-detailed-and-quick-3d-performance-test).

## Results

Initial results show that the ARM Mali driver does not ship with Ubuntu, thus it has to fall back on to software rendering. That said, it actually does a really good job on the software rendering, but we&#8217;re not taking advantage of the system yet.

ARM has provided a reference on how to create a bootable SD card with the correct drivers:

<http://malideveloper.arm.com/develop-for-mali/features/graphics-and-compute-development-on-samsung-chromebook/>

I&#8217;ve spent enough time on the Chromebook today, so I may try this another time.