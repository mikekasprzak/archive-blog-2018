---
id: 3372
title: Ubuntu on the Zotac
date: 2010-11-12T20:13:37+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3372
permalink: /2010/11/12/ubuntu-on-the-zotac/
categories:
  - Smiles
  - Technobabble
---
Before I get to the meat of this post, last night I finished my &#8220;early&#8221; Mac App Store TODO list. I \*COULD\* submit it now, but there&#8217;s a bug with submissions. My iPad version is called Smiles HD, and so will be the Mac App Store version. Right now the names conflict, so I have to wait until this is fixed.

For now it&#8217;s &#8220;done&#8221;. I sent the binary to some friends to double-check compatibility. So while I wait, it&#8217;s time to get on other ports.

Notably, my Mac binary is only a 32bit Intel binary. My source _does_ compile in 64bit mode, but runs in to issues. Smiles isn&#8217;t a game that needs 64bit addressing, but unlike Windows and OSX, 64bit Linux doesn&#8217;t support 32bit applications (not stock at least). So one of my next portability challenges is making my Smiles codebase support 64bit Intel and AMD chips.

\* \* *

Aside from my Workstation PC and Macs, I have a lot of Netbooks. The Netbooks are what I usually use for Linux development. Unfortunately, all the Netbooks I currently have don&#8217;t support 64bit instructions (the current generation Intel Atom CPU&#8217;s do).

So I ordered [one of these](http://www.zotacusa.com/zotac-mag-hd-nd01.html), a **Zotac MAG** Nettop PC. For about $250 CAD (with a rebate), it&#8217;s a dual core Atom 330 running at 1.6 GHz, 2 GB of RAM, 160 GB Hard Drive, with an [NVidia ION](http://en.wikipedia.org/wiki/Nvidia_Ion) chipset (GeForce 9400M). I&#8217;m technically lacking an AMD and ATI test machine, but I do have one of each elsewhere I can turn to if I run in to problems (both running Windows).

<div id="attachment_3373" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/maghd-nd01-u_image1.jpg"><img src="/wp-content/uploads/2010/11/maghd-nd01-u_image1-640x475.jpg" alt="" title="maghd-nd01-u_image1" width="640" height="475" class="size-large wp-image-3373" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/maghd-nd01-u_image1-640x475.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/maghd-nd01-u_image1-450x334.jpg 450w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    The orange ring lights up when the computer is on (faint light). Black when off.
  </p>
</div>

The version I ordered isn&#8217;t the most up to date (original NVidia ION, last year&#8217;s Dual Core Atom), which is on purpose. This is both a development and a test machine, and if I can buy one for $250, so will other people looking for a low cost PC&#8230; not that an NVidia 9400M is anything to shake a stick at either. This gives me a good cross section of graphics hardware I can test in Linux (Intel GMA on the Netbooks, NVidia on the Nettop).

When I purchased my first Netbook a couple years back (an Acer Aspire One), I started a secondary blog where I recorded all my setup notes, thoughts, and learnings (new word!!).

<http://aspireonedev.blogspot.com/>

> So here&#8217;s an extra little blog I created to share the super technical and super nuance details of a little project of mine. Turning a stock 8GB SSD Acer Aspire One running Linpus Linux in to an ideal lightweight coding machine.

More than anything, it was a blog about me learning to use Linux for development. I know a lot more about working inside Linux now, but posts of mine like this I found extremely helpful when I started doing things like Moblin:

<http://aspireonedev.blogspot.com/2008/10/intalling-console-applications.html>

So the remainder of this blog post will be me walking through the setup steps taken to set up this new machine for development, and get my 32bit makefile running and building code. In retrospect, the recorded setup details should be identical no matter the CPU architecture (32bit or 64bit, though this was me doing it 64bit style).

<!--more-->

### The Goal

The goal here is to set up my **Zotac MAG Nettop** with **Ubuntu 10.10 Desktop 64bit**. Specifically, to let me remotely connect to it over VNC, no mouse or keyboard attached (controlling is done over VNC), sync my source code from my repository, and build my game on it. This is only about setting up the computer, not the source code.

### Installing the OS

Installing the OS was very easy. Following [the instructions here](http://www.ubuntu.com/desktop/get-ubuntu/download), I &#8220;burned&#8221; the ISO images to an 8 GB USB Key (1GB would be more than enough). I plugged the key in to the back of the PC, a keyboard in to the front, and booted. I had to **hit a key** after booting to actually start the Ubuntu bootloader. Then simply booted in to the Ubuntu Live Image (default option), and ran the installer.

Since I plan to install several Linuxes on this system, I manually created my partitions. This stuff is **very dangerous** if you don&#8217;t know what you&#8217;re doing. I deleted the FAT32 partition the Zotac came preinstalled with. I then created a 1 GB SWAP partition, and a 50 GB EXT4 partition with the &#8220;/&#8221; mount point. The minimum you need for a Linux install is one &#8220;/&#8221; partition. The rest of the folders it fills in itself, relative to that. The target for the boot device is set to same drive, since it has only one.

### Configuring the Linux Install

&#8211; Under **System->Preferences->Remote Desktop**, I enabled Sharing. This is a VNC Server that comes preinstalled on the system, and just like on the Macs it has to be enabled. I disabled &#8220;You must confirm each access to this machine&#8221;, since that was annoying.

&#8211; Under **System->Preferences->Passwords and Encryption Keys**, I had to change the Login password to nothing, to stop the OS from bringing up a keyring password request every time I attempted to connect over VNC. The OS will still ask for root/sudo passwords, but the keyring problem is especially annoying (since it requires a password the first time someone connects to the local machine&#8230; maybe WIFI too).

&#8211; Under **System->Administration->Login Screen**, I disabled the &#8220;Allow 10 seconds for anyone else to login&#8221; option.

At this point, my VNC configuration is done. I can remotely connect to the computer after booting now. Notably, it takes a bit of time before the login box pops up when connecting to this machine. I&#8217;m not sure why, but it&#8217;s unexpected (My Mac and XP Server pop up right away by comparison).

&#8211; Rebooted. OS offered to install NVidia driver for me. Did that, and rebooted again.

&#8211; I wanted to use 1680&#215;1050 Instead of 1920&#215;1200 of my monitor. I set the resolution inside the **NVidia X Server Settings** app, but noticed you NEED to press the &#8220;Save to X Configuration File&#8221; button. Otherwise, it&#8217;ll stay on Autodetect.

&#8211; Viewing the **System->Administrator->System Monitor**, the computer shows up as having 4 CPU cores. Hyperthreading is cool. 😉

That covers all of the configuring I did.

### Installing Development Tools

From **Applications->Ubuntu Software Center**, you can find all kinds of stuff. On Windows I&#8217;m a user of UltraEdit, though that costs money. A decent alternative I found in Linux is **Geany**, which can be installed easily from here. Also, though I haven&#8217;t tried it, **kDBG** is **GDB** frontend that looks like it might be helpful.

After that, you&#8217;ll want to install your compiler, tools, and libraries. GCC the C compiler comes preinstalled, but not much else. Fire up a terminal and **apt-get** everything you need. Here&#8217;s my list:

> sudo apt-get install g++
  
> sudo apt-get install subversion
  
> sudo apt-get install libSDL-dev
  
> sudo apt-get install libSDL-mixer1.2-dev

### Work Environment

On Windows, I always make sure I have 20 GB+ &#8220;Work Drive&#8221; partition available to me (D:\). I dedicate this entire drive to code, artwork, and any writing stuff I do (web, biz, creative, etc). The only things I don&#8217;t put on it are Audio and Video, since they&#8217;re often too big and work best on an unfragmented drive (I put game-ready assets on it, but not the working assets/intermediate files).

On Linux and the Mac though, I always create a &#8220;Code&#8221; folder in my home directory (~), and my projects go there. I tend not to use Mac and Linux for things that aren&#8217;t programming, so I don&#8217;t have content creation rules there.

So I created a folder for my game under Code. Did an SVN checkout of my source in to that folder (svn co svn://myserver-ip/repos/ outfolder/), then attempted to build it.

Something I forgot, I have a shell script called &#8220;TreeTool&#8221;. It uses the command &#8220;**uname -m**&#8221; to determine the current CPU architecture, and runs the appropriately pre-compiled version version of TreeTool for the current architecture. By default though, this shell script doesn&#8217;t have execute permissions, so I had to do this:

> chmod +x Tools/TreeTool

Now I can run it. TreeTool is a little utility of mine that works a-lot like the Linux &#8220;find&#8221; command, with some niceties given how I like to structure my code (ignore files and directories beginning with &#8220;.&#8221; or &#8220;_&#8221;). I wrote the tool years ago before actually learning about &#8220;find&#8221;, so it&#8217;s fortunate that there is at least 1 difference. 😉

Building TreeTool for the new architecture was straightforward. A simple invocation of G++ (g++ TreeTool\_src/TreeTool.cpp -o TreeTool\_x86_64 -O3), and we&#8217;re laughing.

Now that TreeTool is built for me, I can compile the game. I get bombarded with warnings, but it does make it through all the way to the end.

That&#8217;s it for this post. Now I get to step through and see if I can figure out what I&#8217;ve been doing 64bit wrong.