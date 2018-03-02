---
id: 6520
title: Linux Setup Notes
date: 2013-12-29T04:04:06+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6520
permalink: /2013/12/29/linux-setup-notes/
categories:
  - Linux
  - Technobabble
---
So whoa, I decided to do something outlandish: I switched my primary laptop to Ubuntu Linux.

Here are some setup notes (mainly for my own reference). My Laptop is a [Lenovo X220](http://www.thinkwiki.org/wiki/Category:X220).

## Reminders

Things I ocassionally need a refresher on.

<pre class="lang:default decode:true " >gedit FileIWantToEdit
sudo gedit FileIWantToEditAsRoot
find . -name FileIAmLookingFor
grep pattern filename.txt
grep pattern * -r          # Recursive
grep -i pattern * -r       # Ignore case in pattern
grep pattern -r -I         # Recursive, ignoring binary files (-rI)
ln -s /target/file SymLinkName
# without -s creates a hard link.
# Symbolic Links are to a specific file name, meaning the file can change in place.
# Hard Links are to a file (not file name). Link still works if original is renamed.
ps -A                      # list all processes
ps -A | grep pattern       # filter ps results by a pattern (i.e. "fire" for firefox)
kill -9 PID_NUMBER         # Kill a process. Get PID_NUMBER from the above
</pre>

More Notes:

<pre class="lang:default decode:true " >file /path/to/filename     # Reports the type of file it is (notably 64bit or 32bit binary, uses shared libs, etc)
printenv                  # list all environment variables
printenv | grep pattern
xxd                       # like 'cat' but outputs hex</pre>

## BIOS Tweak

Before I was able to get Ubuntu to boot correctly, I had to change my BIOS from &#8220;both Legacy and UEFI&#8221; mode to just &#8220;UEFI Mode&#8221;. To bring up the BIOS menu you press the blue ThinkVantage button. This setting can be found on the startup (?) page.

## Lenovo Thinkpad Utils (Better Power Management)

Some notes [here](http://www.thinkwiki.org/wiki/Installing_Ubuntu_12.04_%28Precise_Pangolin%29_on_a_ThinkPad_X220).

[linrunner.de](http://linrunner.de/en/) is the home of TLP, a very useful utility for getting laptop Power Management under control.

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install tdp tlp-rdw tp-smapi-dkms acpi-call-tools

sudo tlp start</pre>

More details [here](http://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html).

## Key Remapping

The Lenovo X220 has Web Forward/Back keys beside the arrow keys. I prefer that they act like alternative PageUp and PageDown keys.

Open up **/usr/share/X11/symbols/inet** (i.e. sudo gedit /usr/share/X11/symbols/inet)

Find a key named **<I166>**. Change &#8220;XF86Back&#8221; to &#8220;**Prior**&#8220;.

Find a key named **<I167>**. Change &#8220;XF86Forward&#8221; to &#8220;**Next**&#8220;.

Browse to **/var/lib/xkb/**

Delete ***.xkm** in the /var/lib/xkb folder. You **need** to do this to force a keyboard code refresh.

Logout, then Login to refresh. (Or reboot)

Resources: [Thinkpad Special Keys](http://www.thinkwiki.org/wiki/How_to_get_special_keys_to_work#xmodmap_configuration), [XKB Question](http://askubuntu.com/questions/325272/permanent-xmodmap-in-ubuntu-13-04) 

\* \* *

Use **XEV** to check keycode information (if remapping other keys).

<pre>xev</pre>

NOTE: This **DOES NOT** work anymore. 

<pre class="lang:default decode:true " ># This used to remap the Forward/Back keys to PageUp and PageDown #
xmodmap -e "keycode 166 = Prior"
xmodmap -e "keycode 167 = Next"
xmodmap -pke &gt;~/.Xmodmap
</pre>

## Source Control

<pre class="lang:default decode:true " >sudo apt-get install subversion mercurial git</pre>

Mercurial GUI:

<pre>sudo apt-get install tortoisehg tortoisehg-nautilus

# To Commit via GUI (checkin) #
thg ci

# To Push/Pull via GUI #
thg

# NOTE: These are probably not needed. For reference, this is what I found suggested. #
sudo apt-add-repository ppa:tortoisehg-ppa/releases
sudo apt-get install tortoisehg python-nautilus
</pre>

SVN and GIT (and Mercurial) GUI:

<pre>sudo add-apt-repository ppa:rabbitvcs/ppa
sudo apt-get update
sudo apt-get install rabbitvcs-nautilus3 rabbitvcs-cli</pre>

NOTE: RabbitVCS has a somewhat ugly icon set (bombs!?). Also at this time, you cannot disable individual modes, thus running both RabbitVCS and TortoiseHG at the same time doubles the icons. Uncool.

## SDL2

Prerequisites stolen from [here](http://nothingtocode.blogspot.ca/2013/07/setting-up-sdl2-in-ubuntu-or-linux-mint.html).

<pre class="lang:default decode:true " >sudo apt-get install build-essential xorg-dev libudev-dev libts-dev libgl1-mesa-dev libglu1-mesa-dev libasound2-dev libpulse-dev libopenal-dev libogg-dev libvorbis-dev libaudiofile-dev libpng12-dev libfreetype6-dev libusb-dev libdbus-1-dev zlib1g-dev libdirectfb-dev</pre>

Get the latest code, build, and install.

<pre class="lang:default decode:true " >hg clone http://hg.libsdl.org/SDL SDL2
mkdir SDLBuild
cd SDLBuild
../SDL2/configure
make -j
sudo make install</pre>

## Updating Graphics Drivers (to WIP)

Mesa 10.0 was released in December 2013 (now Mesa 10.1), which introduces OpenGL 3.3 support. Ubuntu 13.10 came out back in October (i.e. 2013-10), so it lacks this update.

Details can be found [here](http://phoronix.com/forums/showthread.php?50038-Updated-and-Optimized-Ubuntu-Free-Graphics-Drivers).

To install Oibaf&#8217;s updated drivers:

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt-get update
sudo apt-get dist-upgrade</pre>

To revert to your stock drivers (before updating Ubuntu Major versions):

<pre class="lang:default decode:true " >sudo apt-get install ppa-purge
sudo ppa-purge ppa:oibaf/graphics-drivers</pre>

**NOTE:** The current MESA drivers (10.0.2) only support OpenGL 3.0 on the Intel HD 3000 (where as Windows supports OpenGL 3.1, plus many 3.2 and 3.3 extensions). Newer Intel GPUs (the HD 4000 and the HD 2500) should support up to OpenGL 3.3.

**NOTE 2:** The Intel HD 3000 does not support OpenCL. Newer Intel GPUs do.

## Recovery Mode

Especially while playing video drivers, if you screw something up, you can **hold SHIFT** during boot to bring up the GRUB menu.

Start a **Recovery Console** (which is by default in Read Only mode) and do the following:

<pre class="lang:default decode:true " >mount -o rw,remount /</pre>

Now you&#8217;ll be free to change files.

## CPU and Network Usage Mini Graphs

<pre>sudo apt-get install indicator-multiload</pre>

Restart X (or reboot).

## Setting up Windows 7 VM

Download the 64bit Linux &#8216;Bundle&#8217; file.

Instructions borrowed from [here](http://www.webupd8.org/2012/06/how-to-install-vmware-player-in-ubuntu.html).

<pre class="lang:default decode:true " >chmod +x VMware-Player-?????.x86_64.bundle
sudo ./VMware-Player-?????.x86_64.bundle</pre>

Follow instructions. Fairly straightforward.

Attach a DVD drive, and insert a Windows 7 CD (NOT a restore CD). Create a VM. Adjust settings accordingly (half your RAM, equal number of CPU cores, ~60 GB of space).

To support Intel GPU drivers, open up the &#8220;???.vmx&#8221; file (where ??? is your VM name). Add the following line.

<pre class="lang:default decode:true " >mks.gl.allowBlacklistedDrivers = TRUE</pre>

**NOTE:** VMWare Player 6.0.1 only supports OpenGL 2.1 on Windows 7 (i.e. on par with OpenGL ES 2.0).

## Disable Touchpad

I use a Lenovo laptop for a reason: It has a nub-mouse (joystick). I prefer this to touchpads. However, by default both input methods attempt to work at the same time. This can cause weird glitches, like random copy/pasting or focus loss. An easy fix is to just outright disable the 

<pre class="lang:default decode:true " ># To list all input devices. Look for a Synaptics TouchPad #
xinput list

# To disable a device, match up the Id number (12) with the Synaptics #
xinput set-prop 12 "Device Enabled" 0</pre>

## Firefox Backspace Key

Due to [some sillyness](http://embraceubuntu.com/2006/12/21/fix-firefox-backspace-to-take-you-to-the-previous-page/), it was decided that backspace on Linux should do nothing. For the &#8220;better&#8221; use, as a &#8220;Page Back&#8221; button, make the following tweak.

<pre>about:config                # in the url #
browser.backspace_action = 0</pre>

## Custom Right Click Actions

Place files in **~/.local/share/nautilus/scripts/** that you want to make available from the right click menu. If a shell script, be sure to set it Executable (chmod +x). Also feel free to ignore adding a &#8220;.sh&#8221; file extension.

Useful Script: [Run as Root](http://ubuntuhandbook.org/index.php/2013/10/enable-open-as-administrator-ubuntu-13-10-nautilus/)

Execute:

<pre class="lang:default decode:true " >#!/bin/bash

./$1

exit 0</pre>

## Music Player

Install **Audacious**.

Current Track can be found under the Speaker Icon in the Panel (I wish there was a track/name up there). A preinstalled plugin AOSD can be enabled for a &#8220;Current Track&#8221; popup, whenever the song changes. There&#8217;s another plugin which enables media keys (FN+Arrows).

## Image Editing

Install **GIMP**. For reals.

Run it. Go to the **Windows** menu and click **Single-Window Mode**. 

Suddenly, it&#8217;s 100x more tollerable.

PNG files are exported, not saved (unlike Paint Shop Pro and Photoshop).

## Calculator

Install **SpeedCrunch**.

## gDEBugger

This doesn&#8217;t actually work, but&#8230;

[Download it](http://www.gremedy.com/downloadLinux.php). Unzip it to /opt/gDEBugger/ (or some other nice folder).

Create a symlink so gDEBugger can find the 64bit GL libraries.

<pre class="lang:default decode:true " >sudo ln -s /usr/lib/x86_64-linux-gnu /usr/lib64
sudo ln -s /usr/lib64/mesa/libGL.so.1 /usr/lib64/libGL.so.1</pre>

Then run **/opt/gDEBugger/gDEBugger** to start it. NOTE: gDEBugger-bin wont run directly.

More OpenGL [debug tools are here](https://www.opengl.org/wiki/Debugging_Tools) (glslDevil?).

## CodeXL (OpenGL/OpenCL Debugger)

Seems easy to install, but **REQUIRES** an OpenCL capable GPU. Sorry Intel HD 3000. 🙁

## APITrace (OpenGL command logger and post-run trace tools)

Apparently this is the only Linux GPU debugger worth a damn.

<pre class="lang:default decode:true " >git clone https://github.com/apitrace/apitrace.git apitrace

sudo apt-get install cmake
sudo apt-get install phonon-backend-gstreamer phonon-backend-vlc     # To shut up qt-sdk
sudo apt-get install qt-sdk 
sudo apt-get install build-essential                                 # If not already done

cmake -H. -Bbuild -DCMAKE_BUILD_TYPE=RelWithDebInfo -DENABLE_GUI=TRUE
make -C build -j

sudo make install -C build</pre>

Then to run: 

<pre class="lang:default decode:true " >apitrace trace BinaryName Args           # To Trace
qapitrace BinaryName.trace               # To View Trace</pre>

## Restart Audio

It happens. Linux seems to sometimes get confused when I plug in a bunch of devices.

<pre class="lang:default decode:true " >pulseaudio -k && sudo alsa force-reload</pre>

[Source](http://askubuntu.com/questions/230888/is-there-another-way-to-restart-ubuntu-12-04s-sound-system-if-pulseaudio-alsa-d).

## Silence gedit warnings

<pre class="lang:default decode:true " >** (gedit:24433): WARNING **: Could not load Gedit repository: Typelib file for namespace 'GtkSource', version '3.0' not found

(gedit:24433): IBUS-WARNING **: The owner of /home/mike/.config/ibus/bus is not mike!
</pre>

<pre class="lang:default decode:true " >sudo chown mike ~/.config/ibus/bus
sudo apt-get install gir1.2-gtksource-3.0</pre>

## Install Android SDK

Easy. First install Java and Ant.

<pre class="lang:default decode:true " >sudo apt-get install openjdk-7-jdk
sudo apt-get install ant</pre>

Download the &#8220;[SDK Tools Only](https://developer.android.com/sdk/index.html)&#8221; bundle. Unzip it somewhere (i.e. **/opt/android-sdk/**)

Run the SDK Manager

<pre class="lang:default decode:true " >/opt/android-sdk/tools/android</pre>

Download the [NDK Package](https://developer.android.com/tools/sdk/ndk/index.html#Downloads). Put it somewhere similar as the sdk (i.e. **/opt/android-ndk/**)

Set path and variables.

<pre class="lang:default decode:true " >export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
export PATH=$PATH:/opt/android-sdk/platform-tools:/opt/android-sdk/tools:/opt/android-ndk</pre>

Done.

## Install NVidia PerfHud ES

IMO this is the best OpenGL debugger available (it shows geometry!), but it only supports NVidia Android devices.

Download the [Tegra Android Development Pack](https://developer.nvidia.com/tegra-resources). It&#8217;s an executable that downloads.

<pre class="lang:default decode:true " >chmod +x tadp-2.0-r7-linux-x64.run
sudo ./tadp-2.0-r7-linux-x64.run</pre>

Deselect everything but PerfHud ES. Install it somewhere common (i.e. **/opt/NVPACK/**).

## Setting up the POD Blender Exporter

Download [PowerVR SDK](http://www.imgtec.com/powervr/insider/sdkdownloads/).

Browse to **/opt/Imagination/PowerVR/GraphicsSDK/PVRGeoPOD/Plugins/Blender/Linux\_x86\_64**

Copy **PVRGeoPODScript.py** and **libPVRGeoPod.so** to your **/opt/blender/2.69/scripts/addons** folder.

Copy **libQtCore.so.4** and **libQtGui.so.4** to your **/opt/blender** folder.

Start Blender. Go to **File->User Preferences->Addons**. Search for &#8220;pod&#8221;, and click the checkbox beside **Import-Export: PVRGeoPod**.

Done. Exporter can now be found under **File->Export->PVRGeoPod**.

## Setting up Spine

Spine just works, so long as you have Java installed (see Android). 

Download it, move it to /opt/, paste in your reg code, and go.

## Lower Compiz CPU usage

Compiz has &#8220;Sync to VBlank&#8221; enabled by default. Causes a wasted 10% extra CPU usage.

<pre class="lang:default decode:true " >sudo apt-get install compizconfig-settings-manager</pre>

Open Compiz Config Settings. Click on OpenGL (not the checkbox, the name). Unselect Sync to VBlank. Reboot.

## Fix Audio Playback in Audacity

**NOTE 2:** Solved. Ignore everything below. To get audio playback working correctly in Audacity (and not silly weird glitch fast), simply select the &#8220;**Samson GoMic: USB Audio (hw:1,0)**&#8221; for output, instead of one of the many defaults. Fixed!

**NOTE**: This is incorrect. A good try though. Problem is the Samson Go Mic that I&#8217;m using as an audio interface. Audacity works fine with the internal sound card (which has a horrible mic). Oddly though, recording via the Samson appears to work though. 

Open up &#8220;**/etc/pulse/default.pa**&#8220;.

Find the following line:

<pre class="lang:default decode:true " >load-module module-udev-detect</pre>

https://wiki.archlinux.org/index.php/PulseAudio#Glitches.2C\_skips\_or_crackling
  
Change it to:

<pre class="lang:default decode:true " >load-module module-udev-detect tsched=0</pre>

Restart audio.

Sources: [Audacity Forum](http://forum.audacityteam.org/viewtopic.php?f=48&t=75613&start=10), [Pulse Audio Wiki](https://wiki.archlinux.org/index.php/PulseAudio#Glitches.2C_skips_or_crackling).

## Setting up the 3DConnexion Space Navigator 3D Mouse

Get the open source driver.

<pre class="lang:default decode:true " >svn co svn://svn.code.sf.net/p/spacenav/code/trunk spacenav</pre>

Build and install the Daemon.

<pre class="lang:default decode:true " >cd spacenavd
./configure
make
sudo make install</pre>

Daemon must be run as root (otherwise it uses 100% CPU usage)!

<pre class="lang:default decode:true " >sudo spacenavd</pre>

Build and install the config tool.

<pre class="lang:default decode:true " >sudo apt-get install libgtk2.0-dev
cd spnavcfg
./configure
make
sudo make install

spnavcfg</pre>

Run Blender.

## Disabling Bluetooth Simple Sync

I assumed this was the problem with my PS4 controller not working wirelessly (disconnecting right away). This is not the case though. Default detection via Bluetooth works fine under Linux. Now I&#8217;m just hoping the problem is that the battery is low (have it plugged in charging).

<pre class="lang:default decode:true " >sudo hciconfig hci0 sspmode 0</pre>

[Source](http://askubuntu.com/questions/68939/issues-with-bluetooth-connections-in-11-10).

## Making Backspace work as a back button in Nautilus

Open **~/.config/nautilus/accels**

Add a line (without a &#8220;;&#8221;)

<pre class="lang:default decode:true " >(gtk_accel_path "&lt;Actions&gt;/ShellActions/Up" "BackSpace")</pre>

Restart Nautilus.

<pre class="lang:default decode:true " >nautilus -q</pre>

## Making Nautilus use &#8220;normal&#8221; type-to-find-files, instead of type-to-search

This is a regression introduced in Nautilus 3.6. The Ubuntu folks appear to have solved it, but only as of the current beta of Ubuntu 14.4. My 13.10 will have to wait to get it. 🙁

## Make file sorting \*NOT\* ignore special characters

Set the current locale to the &#8220;C&#8221; language locale.

<pre class="lang:default decode:true " >gedit ~/.profile</pre>

Add the following to the file.

<pre class="lang:default decode:true " >export LC_COLLATE=C</pre>

[Source](http://askubuntu.com/questions/115741/how-do-i-force-folder-view-sort-order-to-not-ignore-special-characters).

## GDB: ptrace operation not permitted

Fix is [here](http://blog.mellenthin.de/archives/2010/10/18/gdb-attach-fails-with-ptrace-operation-not-permitted/#comment-141535).

Generally speaking, editing /etc/sysctl.d/10-ptrace.conf

Adding the following line:

<pre class="lang:default decode:true " >ptrace_scope = 0</pre>

## Re-enable whitelisting in the SysTray

From [here](http://www.webupd8.org/2013/05/how-to-get-systray-whitelist-back-in.html).

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:timekiller/unity-systrayfix
sudo apt-get update
sudo apt-get upgrade</pre>

Restart Unity (Logout, then log back in).

To whitelist things (Xchat, xchat, Truecrypt, etc):

<pre class="lang:default decode:true " >sudo apt-get install dconf-tools
dconf-editor</pre>

Go to **Desktop->Unity->Panel** and add your whitelist.

[Whitelist source](http://askubuntu.com/questions/35076/how-do-i-whitelist-truecrypt-to-show-in-the-indicator-area/35078#35078), [xchat source](http://askubuntu.com/questions/45793/xchat-disappearing-after-minimize-to-tray).

## SSHFS/Fuse: Mounting remote SSH connections as part of the file system

To connect:

<pre class="lang:default decode:true " >sshfs hostname: mountpoint</pre>

To disconnect:

<pre class="lang:default decode:true " >fusermount -u mountpoint</pre>

## The Dangers of the OIBAF drivers

Don&#8217;t get me wrong, the [OIBAF MESA drivers](https://launchpad.net/~oibaf/+archive/graphics-drivers) are great. Bleeding edge Linux graphics drivers, with the very latest supported OpenGL features (GL 3.0 on my Intel HD 3000 GPU). We&#8217;re in a transition period though. Mesa just reached a very important milestone, several months after Ubuntu 13.10&#8217;s release: OpenGL 3.x support (i.e. Mesa 10.x). The upcoming Ubuntu 14.4 will ship with these new Mesa drivers, but gosh darnit, I&#8217;m doing serious GL shader development, and I need them now!

When I first installed them, everything was great. According to **/var/log/apt/history.log**, my version of OIBAF was from January 10th, 2014. A few days ago I upgraded to the very latest, and that broke both **Chrome** and more importantly **VMware**. My game stuff unusually is working fine with the new drivers, but the current drivers from today are busted. 

So what I need to do: Uninstall OIBAF, then reinstall an older version of OIBAF.

## Uninstalling a PPA (OIBAF)

First install PPA Purge.

<pre>sudo apt-get install ppa-purge</pre>

Then use it to purge the data.

<pre>sudo ppa-purge ppa:oibaf/graphics-drivers</pre>

Now I&#8217;d recommend a reboot, but Logging out and in \*may\* work (I can&#8217;t remember).

## Checking Installed Mesa/GL version

To see your currently installed Mesa version.

<pre>glxinfo | grep OpenGL</pre>

Ubuntu 13.10 ships with Mesa 9.2

## Installing OIBAF

Is easy. I&#8217;d suggest checking your Mesa version first (see above).

<pre>sudo add-apt-repository ppa:oibaf/graphics-drivers
sudo apt-get update
sudo apt-get dist-upgrade</pre>

You may need to reboot/logout for it to take effect (I forget).

Resources: [Phoronix](http://phoronix.com/forums/showthread.php?50038-Updated-and-Optimized-Ubuntu-Free-Graphics-Drivers), [Launchpad (PPA)](https://launchpad.net/~oibaf/+archive/graphics-drivers)

## Upgrading Packages (drivers)

With the repository already added (ppa:oibaf/graphics-drivers), it&#8217;s just a matter of updating.

<pre>sudo apt-get update
sudo apt-get upgrade</pre>

Notably, the 2nd line is just **upgrade**, not **dist-upgrade**. Both functions do the same thing, but if I understand correctly, **upgrade** doesn&#8217;t uninstall obsolete packages, while **dist-upgrade** does. So **dist-upgrade** is the smart one. This means that downgrading to Mesa 9.2 (as I had to do) required a full re-download of Mesa 9.2, as it was already removed from my machine.

## Upgrading Major Ubuntu Versions

When April rolls around Mike, do this:

<pre>sudo do-release-upgrade</pre>

Gotta get away from this awful version of Nautilus. Ugh!

**NOTE:** Uninstalling OIBAF before doing a release upgrade is recommended!

## The Apt Cache

**/var/cache/apt/archives/** contains cached copies of packages you&#8217;ve downloaded. I lucked out, finding my January 10th version of the OIBAF drivers here, so there may still be some hope to downgrade.

Reference: [Here](http://www.tecmint.com/useful-basic-commands-of-apt-get-and-apt-cache-for-package-management/).

To list all installed packages, do:

<pre>apt-cache pkgnames</pre>

This is an extremely long list that omits version numbers. If you know roughly what the package you want is named, you can include the first part of the name like so:

<pre>apt-cache pkgnames blah</pre>

Though, this is really only useful if you know what a package is named.

To search the package database for something, use search:

<pre>apt-cache search blah</pre>

This also includes descriptions of packages, which can be extremely helpful for discovering exactly what package you&#8217;re looking for.

Get information about a package:

<pre>apt-cache showpkg packagename</pre>

Another way, with a slightly different output:

<pre>apt-cache show packagename</pre>

List just the install options:

<pre>apt-cache madison packagename</pre>

Yeah, whodathunk. &#8220;Madison&#8221; &#8216;eh?

## OIBAF Adventures

Long story short, don&#8217;t mess with **DPKG!** I had to reinstall Linux.

<!--more-->

\* \* *

So uh, after much digging, there may not actually be an easy way to install the older packages. OIBAF is a PPA that only has the very latest version. Older versions appear to be discarded.

<pre>Start-Date: 2014-01-10  14:42:45
Commandline: aptdaemon role='role-commit-packages' sender=':1.158'
Upgrade: libgl1-mesa-dev:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), aptdaemon-data:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), libegl1-mesa:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libopenvg1-mesa:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libssl1.0.0:amd64 (1.0.1e-3ubuntu1, 1.0.1e-3ubuntu1.1), libegl1-mesa-drivers:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libkms1:amd64 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libdrm-intel1:amd64 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libdrm-intel1:i386 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libdrm-dev:amd64 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libgl1-mesa-dri:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libgl1-mesa-dri:i386 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libdrm-radeon1:amd64 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libdrm-radeon1:i386 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libglapi-mesa:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libglapi-mesa:i386 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), gnome-control-center:amd64 (3.6.3-0ubuntu45.1, 3.6.3-0ubuntu45.2), python-aptdaemon.gtk3widgets:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), libgnome-control-center1:amd64 (3.6.3-0ubuntu45.1, 3.6.3-0ubuntu45.2), python3-aptdaemon.gtk3widgets:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), libgles2-mesa:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libgl1-mesa-glx:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libgl1-mesa-glx:i386 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), libxatracker1:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), xserver-xorg-video-intel:amd64 (2.99.907+git1401081930.a2fc9e~gd~s, 2.99.907+git1401101930.b351f4~gd~s), xserver-xorg-video-ati:amd64 (7.2.0+git1401071930.bcc454~gd~s, 7.2.0+git1401090730.3213df~gd~s), python3-aptdaemon.pkcompat:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), libdrm-nouveau2:amd64 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libdrm-nouveau2:i386 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), python-aptdaemon:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), aptdaemon:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), libgbm1:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), python3-aptdaemon:amd64 (1.1.1-0ubuntu3, 1.1.1-0ubuntu4), xserver-xorg-video-radeon:amd64 (7.2.0+git1401071930.bcc454~gd~s, 7.2.0+git1401090730.3213df~gd~s), mesa-common-dev:amd64 (10.1~git1401081930.31ec2f~gd~s, 10.1~git1401100730.903688~gd~s), openssl:amd64 (1.0.1e-3ubuntu1, 1.0.1e-3ubuntu1.1), libdrm2:amd64 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), libdrm2:i386 (2.4.50+git1401071830.9fa22a~gd~s, 2.4.51+git1401090630.dc864c~gd~s), gnome-control-center-data:amd64 (3.6.3-0ubuntu45.1, 3.6.3-0ubuntu45.2)
End-Date: 2014-01-10  14:43:28</pre>

\* \* *

Ah ha! Okay, so I figured out a (nasty) way.

I was able to get this working because all of the many copies of the OIBAF Mesa drivers have dates in their filenames. So I listed all the files in the archive folder, and grepped the results for all that matched that date. I copied those to a new folder (because from what I&#8217;ve read the cache or the log may only stick around for a month).

<pre class="lang:default decode:true " >cd /var/cache/apt/archives/
mkdir ~/gfxdriver
cp -t ~/gfxdriver/ `ls | grep 140110`</pre>

This wasn&#8217;t enough though. As it turns out, the Intel &#8216;libdrm&#8217; files were from January 9th, and not January 10th.

<pre>cp -t ~/gfxdriver/ `ls | grep 140109`</pre>

Then I explicitly installed these packages using dpkg.

<pre>cd ~/gfxdriver
sudo dpkg -i *deb</pre>

And that did it. \*phew\*

EDIT: WHOOPS! Nope! Long story short, after a reboot this ruined everything. I was able to fix it, but thereafter I had no hardware acceleration. 

\* \* *

This post is long enough.