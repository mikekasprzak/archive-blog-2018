---
title: Linux Setup Notes, Part 2
id: 6770
date: '2014-01-28 15:52:42 -0500'
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6770
permalink: "/2014/01/28/linux-setup-notes-part-2/"
categories:
- Linux
- Technobabble
---

I&#8217;ve been using Linux for a month now, and while I&#8217;ve done it, I&#8217;ve been adding things to this post over here:

[/2013/12/29/linux-setup-notes/](/2013/12/29/linux-setup-notes/)

Well that post is extremely long now, and I accidentally had to reinstall it (video driver fight), so it&#8217;s time for a fresh post!

I had [some complaints](/2013/12/31/linux-complaints/) about Ubuntu 13.10, so I decided to go ahead and install the Alpha version of **Ubuntu 14.4** (2 months before release). 

So far:
  
&#8211; Nautilus (File browser) is now fixed! I can type stuff, and it jumps to files instead of invoking a tree search! Huzzah!
  
&#8211; I has Mesa 10.0.1 with OpenGL 3 drivers stock! And they work!

The way things are going, I think **Ubuntu 14.4 LTS** is going to be a really good long term update to Ubuntu. Out of the box, these annoyances were solved for me (video driver tomfoolery is what ruined my last install. No more!).

So far, no regrets.

## Fun new keys and commands to remember

<pre class="lang:default decode:true " >!!                     # Repeat last command
sudo !!                # Repeat last command as root
!-2                    # Repeat 2nd last command (and so on. !-1 for last, !-3 for 3rd, etc)
locate file            # OMG EASY WAY TO FIND A FILE!
which binary           # Which version of a binary is running (i.e. make -> /usr/bin/make)
</pre>

## ProTip: If using Ubuntu, and it says Dpkg, just don&#8217;t do it!

It&#8217;s so easy to break a Linux install. Apt and Dpkg (Synaptic) are package managers available to you. Both can be run, but these 2 managers don&#8217;t communicate at all, so if you&#8217;re not careful you can break stuff (like I did). 

So if you&#8217;re using Ubuntu, prefer:

<pre class="lang:default decode:true " >apt-get
apt-cache
tar
Ubuntu Software Center</pre>

For all your installation needs.

Or alternatively, make sure to **NEVER** use Dpkg on &#8220;drivers&#8221;. Let Apt manage this stuff, and you will save yourself a world of pain.

## Backups and Restoring

Be sure to copy your **entire** user folder, especially the root! Re-setting up applications becomes extremely simple, as you can just copy the **.hidden** folders back in to your new home folder (~). 

I got scared that I would have to waste an UltraEdit activation (ugh DRM), but nope, all I had to do was copy my **.idm** folder. Huzzah!

## Need Flash? Use Chrome

Download it **[directly from Google](https://www.google.com/chrome/)**.

I&#8217;ve been a loyal Firefox user for a very long time. That said, as someone involved in games, Flash content is still kind of important. There was a debacle some time back, Mozilla refusing to support Chrome&#8217;s PPAPI. Or basically, a new sandboxed API similar to the legacy NPAPI used by all the other browsers. PPAPI has another advantage in that it&#8217;s not only sandboxed from the browser, but sandboxed from the OS. It&#8217;s the foundation for Native Client (NaCl).

Adobe declared that it will not support Linux anymore. The last version of Flash for Linux is 11.2. They just didn&#8217;t want to maintain the old NPAPI version on Linux. Unusually though, to better support the Chrome Browser, Adobe makes a PPAPI port of Flash.

Recently, Google announced that they will be discontinuing NPAPI support in Chrome. To a lot of folks, this sounded like &#8220;no more Flash on Linux&#8221;, but most people seemed to have missed the memo that Flash supports PPAPI.

And since PPAPI is really only supported by Chrome, PPAPI Flash comes bundled with Chrome. Easy.

As of this writing, the Flash bundled in Chrome is version 12, the same as on Windows.

So really, the hardest part about Flash on Linux is switching away from Firefox.

## VMware Player on Ubuntu 14.4 Alpha

The latest Ubuntu has a brand new version of the Linux kernel. That broke the network bridge driver code that VMware Player 6.0.1 ships with. The solution, a patch, can be found here:

<http://dandar3.blogspot.ca/2014/01/vmware-player-601-on-ubuntu-1404-alpha.html>

## Remapping keys on Ubuntu 14.4

Well it looks like the keyboard symbol files moved in the latest Ubuntu. Now they&#8217;re under **/usr/share/X11/<u>xkb</u>/symbols/**. Below is the modified snippet from my original post.

> The Lenovo X220 has Web Forward/Back keys beside the arrow keys. I prefer that they act like alternative PageUp and PageDown keys.
> 
> Open up **/usr/share/X11/xkb/symbols/inet** (i.e. sudo gedit /usr/share/X11/symbols/inet)
> 
> Find a key named **<I166>**. Change &#8220;XF86Back&#8221; to &#8220;**Prior**&#8220;.
> 
> Find a key named **<I167>**. Change &#8220;XF86Forward&#8221; to &#8220;**Next**&#8220;.
> 
> Browse to **/var/lib/xkb/**
> 
> Delete ***.xkm** in the /var/lib/xkb folder. You **need** to do this to force a keyboard code refresh.
> 
> Logout, then Login to refresh. (Or reboot)

## Power user GUI config tools

Install **CompizConfig Settings Manager**.

Install **Unity Tweak Tool**.

TODO: figure out the name of the tool I installed that made the taskbar work again. No, it wasn&#8217;t dconf-tools / dconf-editor.

## Setting default file Associations to any program

[Source](http://askubuntu.com/questions/369967/how-do-i-set-the-default-file-association-in-ubuntu-13-10-nautilus-files-with-un).

<pre>mimeopen -d file_to_associate.ext
4
/path/to/app</pre>

## Emit Keypresses (when being clever)

Use [XDoTool](http://www.semicomplete.com/projects/xdotool/).

<pre class="lang:default decode:true " >xdotool key Ctrl+c
xdotool key Super+a
xdotool key Control+Alt+Right
xdotool key Control+Alt+Left</pre>

On Windows, use [nircmd](http://nircmd.nirsoft.net/sendkeypress.html).

<pre>nircmd sendkeypress lwin</pre>

## Notable Patches

[Minimize on Click](https://launchpad.net/~ojno/+archive/unity-minimize-on-click) (out of date, but a simple edit)
  
[Disable Middle Button Paste](https://wiki.ubuntu.com/X/Config/Input)
  
Taskbark Whitelisting. \*sigh\*&#8230; or a fix for Xchat.

## FUIbuntu/FUXbuntu

TODO: Start a repos/ppa that undoes/fixes some of the annoying UI &#8220;fixes&#8221; Mr Shuttleworth has introduced in to Ubuntu and Unity. The F stands for what you think it stands for, and the UI is to polite&#8217;n up the U, and to be specific that the tweaks are UI related. Alternatively, FUXbuntu if feeling angry.

I want to still use a stock Ubuntu, but holy hell there are some frustrating UI decisions in Ubuntu.

UPDATE: Ubuntu 14.4 does fix the file browser.

## SOURCE YOUR SHELL SCRIPTS!

Very important thing I \*just\* learned: Source!

If you write a shell script that (for example) sets environment variables, they will set the variables for any commands run in that script, but will not propagate outside of the script and in to the shell. The solution is to run the script inside the source shell, like so:

<pre>source ./MyScript.sh</pre>

or

<pre>. ./MyScript.sh</pre>

## Startup and Environment Variables

To run things on startup, add them to <del datetime="2014-04-12T19:46:37+00:00">.bashrc</del> **~/.profile**

<pre>export PATH="/opt/android-sdk/platform-tools:$PATH"</pre>

Simply log-out and log back in again for the changes to take effect.

[More details](https://help.ubuntu.com/community/EnvironmentVariables).