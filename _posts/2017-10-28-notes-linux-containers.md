---
id: 9781
title: 'Notes: Linux Containers'
date: 2017-10-28T14:07:04+00:00
author: Mike K
layout: post
guid: /?p=9781
permalink: /2017/10/28/notes-linux-containers/
categories:
  - Uncategorized
---
Linux Containers are &#8220;the new hotness&#8221;. If there&#8217;s a feature Ubuntu has over other distros, its containers built-in. **LXD** is the modern tool used for containers. It can be installed elsewhere, but that&#8217;s not how we roll here.

<https://linuxcontainers.org/>

LXD containers are not VM&#8217;s, but are designed to work exactly like them. The key difference is they are fully native, and they access to hardware directly (well networking aside). You can even grant access to a GPU. Containers are a very flexible tool for your everyday Linux use.

Ubuntu 16.04 ships with LXD 2.0, but for some of the advanced features, you&#8217;re going to want the latest.

<https://launchpad.net/~ubuntu-lxc/+archive/ubuntu/lxd-stable>

<pre class="lang:default decode:true " >sudo add-apt-repository ppa:ubuntu-lxc/lxd-stable
sudo apt-get update</pre>

Working with containers is **A LOT** like working with vagrant boxes.

<pre class="lang:default decode:true " ># Setup (first time only, configs the environment, sets up the daemon)
sudo lxd init

# This configures where you'll store your interfaces (in a dir, on a zfs partition, etc)
# Also it sets up a DHCP server/bridge, this way your unspecific containers can acquire an IP

# Herein you use lxc, not lxd

# Create a guest machine running the latest Ubuntu LTS
lxc launch ubuntu: my-machine

# Create a guest running a specific Ubuntu
lxc launch ubuntu:16.04 my-other-machine

# list all machines
lxc list

# start/stop/restart delete (must stop before deleting)
lxc start my-machine
lxc stop my-machine
lxc restart my-machine

# delete a machine (must stop before deleting)
lxc delete my-machine

# jump in to that machine and do stuff
lxc exec my-machine bash

# Edit and copy files
lxc file edit my-machine/home/ubuntu/.bashrc
lxc file push blah.txt my-machine/home/ubuntu/
lxc file pull my-machine/home/ubuntu/somefile.txt .
</pre>

Reference: <https://www.ubuntu.com/containers/lxd>

It&#8217;s also worth noting that while LXD only runs on Linux, the client (lxc) can be run on other OS&#8217;s including Windows and Mac. What this lets you do is set up remote connections to LXD containers. I&#8217;m not going to cover remotes here, but infrastructurally speaking it can be used from other platforms (even just other Linux machines).

## Disabling IPv6

**DON&#8217;T DO THIS.**

You can optionally disable IPv6 support in LXD.

<pre class="lang:default decode:true " >lxc network set lxdbr0 ipv6.address none</pre>

Where **lxdbr0** is the ldx-br0 bridge created during setup.

Frankly though, this doesn&#8217;t change much. I thought it did more, but the containers themselves are still assuming an IPv6 IPs, just you can&#8217;t see them via `lxc list` anymore.

Reference: <https://github.com/lxc/lxd/issues/3333>

## Modern Kernels on LTS Ubuntu

Starting with Ubuntu 16.04 LTS, you are able to make your Ubuntu install subscribe to the latest changes to the Linux kernel. There are 3 channels you can subscribe to:

  * GA-16.04 (General Availability)
  * HWE-16.04 (Hardware Enablement)
  * HWE-16.04-Edge (Cutting Edge Hardware Enablement)

By default Ubuntu puts you on the GA track, meaning in Ubuntu 16.04&#8217;s case, you&#8217;re getting Kernel **4.4.x**. Switching to HWE, you get a current Kernel. At the time of this writing, that&#8217;s **4.10.x**.

HWE channels are good up until the next major LTS release of Ubuntu. Then you effectively get put on the GA track of the now current LTS release (i.e. 18.04 starting April 2018). It is then expected you&#8217;ll upgrade to the new LTS release, where you can begin again, switching to the next HWE series.

More details: <https://wiki.ubuntu.com/Kernel/RollingLTSEnablementStack>

How to install HWE: 

<pre class="lang:default decode:true " >sudo apt-get install --install-recommends xserver-xorg-hwe-16.04</pre>

Then reboot to apply the change.

I&#8217;m not 100% sure how necessary this is, but I was under the impression that I read something that called for newer that **4.4.x** kernel. Who knows. I&#8217;ll make a note here if I find it again.

Canonical also offers a live Kernel patching service.

<https://www.ubuntu.com/server/livepatch>

Notable because rebooting is not required, but beyond 3 machines you need to start paying for a support plan. Also (and this is key), the livepatching services is limited to **GA** releases. Yes, no **HWE** kernels via livepatch.

## Linux Network Interfaces

<pre class="lang:default decode:true " >/etc/network/interfaces</pre>

This is a key file on Ubuntu. It&#8217;s not even specific to LXD, but Linux in general. To create advanced Linux Networking configurations, from bridges to VLANs, you do it here.

<pre class="lang:default decode:true " ># This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
</pre>

A default Ubuntu Server install will give you a relatively simple configuration. The ever important loopback interface (lo), and a list of ethernet adapters. 

WiFi and some specialty services (VMs) are handled by other applications. Interestingly, my Ubuntu Desktop machine&#8217;s interfaces file is far more bare.

<pre class="lang:default decode:true " ># interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback
</pre>

It looks like in Desktop Ubuntu, another service is being run to support plug-and-play networking.

<!--more-->

## Preparing the Host machine for VLANs and Bridging

<pre class="lang:default decode:true " ># if not already installed
sudo apt install vlan bridge-utils
</pre>

Next we need to enable 802.1Q support.

<pre class="lang:default decode:true " ># explicitly enable it
sudo modprobe 8021q

# check if module is loaded
lsmod | grep 8021q

# get info about the module
modinfo 8021q

# check the list of user modules (if it's on the list)
cat /etc/modules

# To make this permanent, open up /etc/modules
sudo nano /etc/modules

# And add a line to the end that looks like this
8021q
</pre>

Now would be a good time to move your computer to a **Tagged** port on your Managed Router.

Reference:
  
&#8211; <https://ubuntuforums.org/showthread.php?t=703387>
  
&#8211; <https://askubuntu.com/questions/544971/vlan-tag-stripped-out-by-linux-box>
  
&#8211; <http://manpages.ubuntu.com/manpages/zesty/man8/vconfig.8.html>
  
&#8211; <https://wiki.ubuntu.com/vlan>
  
&#8211; <https://help.ubuntu.com/community/NetworkConnectionBridge>

## Bridges, LANs, and VLANs

The bulk of our work is going to be in **/etc/network/interfaces**

<pre class="lang:default decode:true " ># This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
</pre>

(NOTE: Your default interface might not be named eth0, but what&#8217;s important is that you use the correct name anywhere eth0 is used)

Starting with our bare-bones interfaces file above, we&#8217;re going to add a VLAN.

At the bottom of the file do the following.

<pre class="lang:default decode:true " >auto eth0.10
iface eth0.10 inet manual
    vlan-raw-device eth0
</pre>

This creates a VLAN interface. Notably, the `.10` included after the interface name. It is true that VLANs are a bit of a hack, but they&#8217;re quite useful.

In theory this above code should actually work without the `vlan-raw-device` line (because the interface name matches), but alas it didn&#8217;t want to work for me. It took a lot of iteration and reading to really nail down the right way to do this. 😉

Another thing I want to point out is &#8220;manual&#8221; keyword above. Depending on your needs, you could have alternatively gone with &#8220;static&#8221; or &#8220;dhcp&#8221;, but if you want a hook up a VLAN socket to a LXD container, you should set this to &#8220;manual&#8221;.

Speaking of LXD, we&#8217;re not done.

LXD cannot directly connect to an interface (at least not without fully taking it over). Also its VLAN support is limited. 

So what you can do instead is create a bridge!

Creating a bridge is extremely similar. To bridge the main interface, letting your LXD container connect to the LAN with its own IP and MAC address, do the following.

<pre class="lang:default decode:true " >auto br0
iface br0 inet manual
    bridge-ports eth0
</pre>

Our bridge named br0, we can safely connect to this with an LXD container.

Bridging a VLAN is much the same.

<pre class="lang:default decode:true " >auto br0.10
iface br0.10 inet manual
    bridge-ports eth0.10
</pre>

Notably, we have bridged the VLAN interface we created.

You can name your bridges whatever you want. Bridges can be re-used across multiple LXD containers, hence the generic names &#8220;br0&#8221; and &#8220;br0.10&#8221;. There&#8217;s nothing special about the name &#8220;br0&#8221;. You don&#8217;t even need a &#8220;br0&#8221; to exist if all you want is a &#8220;br0.10&#8221;.

Once an interface exists in **/etc/network/interfaces**, you can do the following to start the interface.

<pre class="lang:default decode:true " ># to start the interface
sudo ifup br0
sudo ifup eth0.10
sudo ifup br0.10

# to stop the interface
sudo ifdown br0.10
sudo ifdown br0
sudo ifdown eth0.10</pre>

Put all together.

<pre class="lang:default decode:true " ># This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp

# The eth0 bridge (for LXD)
auto br0
iface br0 inet manual
    bridge-ports eth0

# VLAN 10 and its bridge (for LXD)
auto eth0.10
iface eth0.10 inet manual
    vlan-raw-device eth0
auto br0.10
iface br0.10 inet manual
    bridge-ports eth0.10
</pre>

Instead of bringing up all the interfaces manually, you can just reboot. That&#8217;s the point anyway. Make sure they work on boot.

You can check the status of your VLANs easily.

<pre class="lang:default decode:true " ># List all active VLANs
sudo ls /proc/net/vlan/

# More details on VLANs
sudo cat /proc/net/vlan/config</pre>

## LXD Containers

Working with containers is extremely easy. We&#8217;ve covered the basic syntax above. Once you&#8217;ve bash&#8217;d in to a container, you treat it like it&#8217;s a standalone Linux machine (sudo apt update; sudo apt upgrade).

I didn&#8217;t bother with ZFS myself, though many docs seems to recommend it. The **dir** interface type is really nice, meaning the files exist on your normal file system (meaning you can access files as the host without starting or mounting the volume). I ran in to conflicting information about ZFS, or more specifically, analysis that suggested it wasn&#8217;t actually worthwhile. This was in a context outside of LXD containers though. There may be some advantage here, or not. It&#8217;s hard to know without trying it and benchmarking it.

Lets move on to the next key feature of LXD: Profiles.

## LXD Container Profiles

By default, all LXD containers use a profile named &#8220;default&#8221;. We can view it by doing the following.

<pre class="lang:default decode:true " >lxc profile show default</pre>

You&#8217;ll get something like this.

<pre class="lang:default decode:true " >config:
  environment.http_proxy: ""
  user.network_mode: ""
description: Default LXD profile
devices:
  eth0:
    name: eth0
    nictype: bridged
    parent: lxdbr0
    type: nic
  root:
    path: /
    pool: default
    type: disk
name: default
used_by: []
</pre>

Great starting point, but we have some parts we&#8217;d like to change.

Lets create a profile for our direct LAN bridge. Start by copying the default.

<pre class="lang:default decode:true " ># we'll call this profile "lan"
lxc profile copy default lan
</pre>

Now to make our &#8220;lan&#8221; profile use our LAN bridge, we change the parent. Currently it&#8217;s set to **lxdbr0**, which is the bridge created when LXD was initialized. We&#8217;d prefer **br0**.

<pre class="lang:default decode:true " ># set lan's eth0/parent device to br0
lxc profile device set lan eth0 parent br0
</pre>

Easy. Now when you restart your container, it&#8217;ll request an IP over DHCP via it&#8217;s new virtual network interface.

VLANs work identically, but again, we must reference a bridge.

<pre class="lang:default decode:true " ># create a profile copy named vlan10
lxc profile copy default vlan10

# set vlan10's eth0/parent to the vlan bridge
lxc profile device set vlan10 eth0 parent br0.10
</pre>

Done.

Now that we have profiles, we need to apply the profiles to our our containers.

<pre class="lang:default decode:true " ># to apply a profile on creation
lxc launch ubuntu: MyContainer -p vlan10

# to apply a profile after creation
lxc profile apply MyContainer vlan10
</pre>

## Installing UniFi Controller in an LXD container

Phew! Here&#8217;s what this was all for.

Create/edit a new source for packages.

<pre class="lang:default decode:true " >sudo nano /etc/apt/sources.list.d/100-ubnt.list</pre>

Paste this in the file for the Stable packages.

<pre class="lang:default decode:true " >deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti</pre>

Install the GPG key and install.

<pre class="lang:default decode:true " ># Add GPG Key
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 06E85760C0A52C50

# Update package list
sudo apt update

# Install Unify
sudo apt install unifi</pre>

Now figure out the IP address of LXD container. From inside:

<pre class="lang:default decode:true " ># new way
ip addr

# old way (I know, I'm still getting used to not using this)
ifconfig</pre>

Or outside:

<pre class="lang:default decode:true " >lxc list</pre>

For example, lets say it&#8217;s &#8220;**192.168.10.104**&#8220;.

Once you know the IP, connect to port 8443 over HTTPS (yes S).

<https://192.168.10.104:8443>

And you&#8217;re in!

References:
  
&#8211; <https://help.ubnt.com/hc/en-us/articles/220066768-UniFi-How-to-Install-Update-via-APT-on-Debian-or-Ubuntu>
  
&#8211; <https://community.ubnt.com/t5/UniFi-Wireless/Unable-to-access-Unifi-WebGUI-on-Linux-box-Ubuntu-16-04/td-p/1903505>

## Appendix: How to allow SSH to work again

Haha! It looks like somewhere along the line I lost the ability to SSH in to my host machine.

Anyways, I saw a solution somewhere, but I forgot where. Update this later when I have time.

## Appendix: References

I&#8217;ve lost track of what is referenced where, so here&#8217;s a link dump.

LXD:
  
&#8211; <https://bayton.org/docs/linux/lxd/lxd-zfs-and-bridged-networking-on-ubuntu-16-04-lts/>
  
&#8211; <https://www.digitalocean.com/community/tutorials/how-to-set-up-and-use-lxd-on-ubuntu-16-04>
  
&#8211; <https://askubuntu.com/questions/846258/where-are-the-lxc-container-configuration-files-located>
  
&#8211; <https://github.com/tych0/tycho.ws/blob/master/src/blog/2016/04/lxdbr0.md>
  
&#8211; <https://roots.io/linux-containers-lxd-as-an-alternative-to-virtualbox-for-wordpress-development/>
  
&#8211; <https://insights.ubuntu.com/2015/11/10/converting-eth0-to-br0-and-getting-all-your-lxc-or-lxd-onto-your-lan/>
  
&#8211; <https://insights.ubuntu.com/2016/03/22/lxd-2-0-your-first-lxd-container/>
  
&#8211; <https://github.com/lxc/lxd/issues/3273>
  
&#8211; <https://github.com/lxc/lxd/issues/2551>
  
&#8211; <https://github.com/lxc/lxd/blob/master/doc/containers.md>
  
&#8211; <https://github.com/lxc/lxd/issues/3379>

Interfaces:
  
&#8211; <https://unix.stackexchange.com/questions/128439/good-detailed-explanation-of-etc-network-interfaces-syntax>
  
&#8211; <http://manpages.ubuntu.com/manpages/precise/man5/vlan-interfaces.5.html>
  
&#8211; <https://wiki.debian.org/NetworkConfiguration>
  
&#8211; <https://www.theo-andreou.org/?p=1733>
  
&#8211; <https://www.simpleprecision.com/ubuntu-16-04-lxd-networking-simple-bridge/>