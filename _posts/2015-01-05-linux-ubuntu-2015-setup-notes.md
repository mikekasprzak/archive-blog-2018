---
id: 7135
title: Linux (Ubuntu) 2015 Setup Notes
date: 2015-01-05T15:08:00+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7135
permalink: /2015/01/05/linux-ubuntu-2015-setup-notes/
categories:
  - Technobabble
---
Hello 2015. The laptop I&#8217;ve been using the past few years _actually_ fell apart, so I bought a new one. I started using Linux (Ubuntu) almost exactly 1 year ago, and as much as I like it, it&#8217;s not always the most logical and obvious OS to use, so I take notes. Here are notes.

The machine is a [Lenovo X230 Tablet](http://shop.lenovo.com/SEUILibrary/controller/e/web/LenovoPortal/en_US/catalog.workflow:category.details?current-catalog-id=12F0696583E04D86B9B79B0FEC01C087&current-category-id=89ECFD45CA0654775864CDBAD2606AC7&tabname=Features). It&#8217;s actually an older laptop, a 2013 model, but to put things mildly 2014 was **NOT** a good year for Lenovo Thinkpads. Fortunately, [as of CES (today/yesterday), Thinkpads will return to being useful](http://www.engadget.com/2015/01/04/lenovo-thinkpad-x1-carbon-2015/).

Notable specs: Core i5 Processor with Hyperthreading. Intel HD 4000 GPU. 2x USB 3.0 ports, 1x USB 2.0 (powered). Oh, and of course it has a TrackPad, a IBM TrackPoint (red nub joystick mouse), a Touch Screen and a Wacom Digitizer (Pen).

I dropped a 500 GB Samsung SSD in to it, dedicated a 200 GB partition to Windows 7 Pro, and the rest to Ubuntu 14.10 (~260 GB, though I&#8217;m thinking about giving Windows a little more). I&#8217;ve installed various dev tools and SDKs on both. As expected, Windows has used about 100 GB of its space, and Ubuntu about 20 GB. Typical. 😉

## Return of Oibaf (bleeding edge Video drivers)

Setting up the machine went very smoothly, except for two issues:

&#8211; The Steam UI was &#8230; strange. Not slow, but unresponsive (had to right click to refresh)
  
&#8211; the Print Screen key (and scrot) could not take screenshots (they were wrong)

The solution was to upgrade the video driver. The very latest Intel and OSS drivers are always available as part of the Oibaf graphics driver package.

<https://launchpad.net/~oibaf/+archive/ubuntu/graphics-drivers>

To add them, add the PPA, and do an upgrade:

<pre>sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt-get update
sudo apt-get upgrade</pre>

To remove them, use ppa-purge:

<pre>sudo apt-get install ppa-purge
sudo ppa-purge ppa:oibaf/graphics-drivers</pre>

The latest-and-greatest drivers can sometimes be risky to use. I normally don&#8217;t use them, but for a time I did, and all was fine until Mesa mainline got busted. Sadly oibaf doesn&#8217;t keep &#8220;last known good drives&#8221; around, only the bleeding edge, so I only recommend it if all else fails.

## Skype Tray Icon Fix

Skype is a 32bit app running on 64bit Linux. To correctly make tray icons work, this package fixes it.

<pre>sudo apt-get install sni-qt:i386</pre>

Download it, and restart Skype.

## TLP &#8211; Advanced Linux Power Management

This little piece of software dramatically improves my Linux battery life. I had used it in the past, but for a time I was using pre-release builds of Ubuntu, and no TLP update was available (I hadn&#8217;t learned about how to grab old versions of software from PPA&#8217;s yet).

<http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html>

Installation is pretty easy. First add the PPA.

<pre>sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update</pre>

Then grab the packages.

<pre>sudo apt-get install tlp tlp-rdw</pre>

I run Thinkpad laptops, which there is extra software for.

<pre>sudo apt-get install tp-smapi-dkms acpi-call-dkms</pre>

## SDL2 Setup

I always seem to forget the essentials needed to build SDL on Linux. Hopefully this list is correct.

<pre>sudo apt-get install build-essential libgl1-mesa-dev libglu1-mesa-dev mesa-common-dev</pre>

## SDL_Mixer 2.0 Prerequisites on Ubuntu

For OGG support do:

<pre>sudo apt-get install libogg-dev libvorbis-dev</pre>

And the rest:

<pre>sudo apt-get install libflac-dev
sudo apt-get install libmikmod-dev #(NOTE: MOD/Tracker Playback, and it wasn't enough)
sudo apt-get install libsmpeg-dev #(NOTE: large, and it wasn't enough)</pre>

## Running Emscripten

The **emrun** tool can be used to quickly test Emscripten compiled apps.

First, compile with the command line option **`"--emrun"`**.

Then run the script:

<pre>emrun a.html</pre>

[More details](http://kripken.github.io/emscripten-site/docs/compiling/Running-html-files-with-emrun.html).

## SDL2 and Emscripten

**NOTE:** SDL2 Emscripten support is brand-new. It was just added to mainline SDL on Xmas eve.

There are two ways to build SDL2 apps using Emscripten. The SDL way, and Emscripten way.

The SDL way is building SDL2 from source, using various Emscripten tools. There are notes about how to build SDL_mixer, but I was unable to get this working.

<https://hg.libsdl.org/SDL/file/817656bd36ec/docs/README-emscripten.md>

The Emscripten way uses Emscripten-Ports. Details can be found here:

<http://kripken.github.io/emscripten-site/docs/compiling/Building-Projects.html>

As of this writing, only SDL and SDL\_image are available in ports (not SDL\_mixer).

<https://github.com/emscripten-ports>

## Fixing the Dokuwiki

As root, give ownership of the data directory to nobody.

<pre>chown nobody:nobody data -R</pre>

## AMD Graphics and Steam

My other PC decided to be a pain.

If you&#8217;re having troubles running Steam, you may need to:

&#8211; Switch to the Open Source driver
  
&#8211; Install Steam updates
  
&#8211; Switch back to the proprietary driver

You can do this with the &#8220;**Additional Drivers**&#8221; program. 

Open it, wait a moment for it to show up, and do the above.

[<img src="/wp-content/uploads/2015/01/SauceDriver-450x352.png" alt="SauceDriver" width="450" height="352" class="aligncenter size-medium wp-image-7181" srcset="http://blog.toonormal.com/wp-content/uploads/2015/01/SauceDriver-450x352.png 450w, http://blog.toonormal.com/wp-content/uploads/2015/01/SauceDriver.png 609w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2015/01/SauceDriver.png)

You can quickly restart the graphics driver by logging out (instead of rebooting).