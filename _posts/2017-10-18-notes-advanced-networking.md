---
id: 9754
title: 'Notes: Advanced Networking (overview)'
date: 2017-10-18T02:34:21+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9754
permalink: /2017/10/18/notes-advanced-networking/
categories:
  - Uncategorized
---
So thanks to &#8230; reasons, I recently had to rework my internal network. To do it, I had to order some new hardware, and learn a bunch new things about networking.

<!--more-->

## Connecting to Subnets with a Virtual Network Interface

This is a tip I discovered by accident that&#8217;s super-useful for setup tasks.

By default, computers on a local network can only talk to computers on the same subnet (i.e. 192.168.0.25 with a 255.255.255.0 mask can&#8217;t talk to 192.168.10.12). One super nice thing you can do from Linux is create a Virtual Network Interface.

<pre class="lang:default decode:true " ># Figure out what your working network interface is
ifconfig

# Depending on your machine, it's typically either 'eth0' or 'wlan0'

# Next, decide on a static IP address to use.
# It needs to be static (unless working with a VLAN). DHCP uses your mac address.

sudo ifconfig wlan0:0 192.168.10.25

# This creates a new interface wlan0:0, where :0 can be any number you want.
# You should now be able to reach computers in that other subnet.

# To release it, do the following:
sudo ifconfig wlan0:0 down
</pre>

Again, this generally only applies to non VLAN situations.

Reference: <https://linuxconfig.org/configuring-virtual-network-interfaces-in-linux>

## Temporary Static IPs

No DHCP server? No problem!

<pre class="lang:default decode:true " >sudo ifconfig eth0 192.168.0.5

# or if you want to change the mask
sudo ifconfig eth0 192.168.0.5 netmask 255.255.255.0</pre>

Easy. Combined with the tip above (Virtual Network Interfaces), and suddenly working with a complex network isn&#8217;t a big deal no more.

## VLANs

This is where things get extra fancy. If you&#8217;re willing to switch to Managed Switches and a better Router, you can enter &#8220;Enterprise Networking&#8221; territory and create isolated networks within the same network.

**802.1Q** defines the well supported VLAN spec. Any Managed Switch worth its salt will support this spec. Here, each port on the Switch can send Tagged or Untagged packets, Untagged being the normal traffic that most devices are used to. The new Tags are used to specify what VLAN the packets belong to, and the Tags themselves only stick around until the packet arrives at the next device (Router, Switch, or VLAN capable server).

You only tag traffic going to Tag capable device (again a Router, Switch, or VLAN capable server). Tags are a VLAN number, typically between 2 and 4096. 1 is special. Default Untagged traffic is implied to be on VLAN 1. The tag itself can also be omitted, implying again a packet belongs to VLAN 1.

That means the majority of ports on a router will have Untagged, or normal traffic. The **802.1Q** spec lets you define per port, what tag to introduce to the Untagged traffic received by it. That means your PlayStation 4 or whatever can have its traffic routed to a specific VLAN as it comes in to a Managed Switch (the Switch itself adds a Tag when pushing data to the next Tag capable interface).

A common notation used for VLANs is dot notation. For example, a standard untagged ethernet connection might be named &#8220;`eth0`&#8220;. To specifically call out a VLAN attached to eth0, you might use &#8220;`eth0.10`&#8221; for a connection on eth0 over VLAN 10.

To route multiple VLANs over a single wire, your Switch may allow you to specify the same ports for Tagged traffic for each VLAN, or you&#8217;d use a feature called Trunking. Trunking options vary depending on the hardware. In its simplest form, a Trunk is an &#8220;All VLAN Traffic&#8221; setting for a port. More advanced Switches will give you fine grained control though.

In general it&#8217;s not a difficult concept to understand, it just potentially takes a bunch of extra work to expand what you know about networking to include VLANs.

## VLAN Concerns

2 potential exploits for VLANs.

**1.** Don&#8217;t TAG ports that shouldn&#8217;t be allowed to enter any VLAN. Simply allowing tagged packets allows a PC full access to the network.

**2.** Hope that your networking gear (Managed Switches, Routers, Tagged PCs) are smart enough to strip Tags from a packet. One can just include 2 Tags in the packet (one after the other) to potentially exploit a VLAN (well, you shouldn&#8217;t get a response, but hey).

Reference: http://www.itsyourip.com/Security/vlan-hopping-layer-2-security-exploit-bypass-layer-3-security/

## DHCP

Just some small notes on how DHCP works. There was some funny literature I read that suggests EdgeRouter DHCP bypasses the firewall. This appears to be true, but just-in-case I open the ports (67-68).

As a device, you send a broadcast.

**UDP 0.0.0.0:68 -> 255.255.255.255:67**

As a DHCP server, you&#8217;re listening on **255.255.255.255:67**, and send a response &#8220;I&#8217;m over here&#8221;.

**UDP 192.168.1.1:67 -> 255.255.255.255:68**

As a client, you&#8217;re listening on **255.255.255.255:68**. As you can see the new sender is IP of the DHCP server. In the body of the reply is the IP address you are given.

Reference: <http://www.linklogger.com/UDP67_68.htm>

## Advanced Networking Hardware

Previously my network was built up of a pair of off-the-shelf all-in-one consumer routers and unmanaged switches. To properly rebuild my setup, this has required some more advanced gear.

### TP-LINK 8-Port Gigabit Easy Smart Switch TP-SG108E

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/10/tpswitch.jpg" alt="" width="621" height="263" class="aligncenter size-full wp-image-9758" srcset="http://blog.toonormal.com/wp-content/uploads/2017/10/tpswitch.jpg 621w, http://blog.toonormal.com/wp-content/uploads/2017/10/tpswitch-450x191.jpg 450w" sizes="(max-width: 621px) 100vw, 621px" />](http://blog.toonormal.com/wp-content/uploads/2017/10/tpswitch.jpg)

These are great value managed switches that can be had for $30 ($50 CAD). They give you 8 ports that can be configured a variety of ways. Keep in mind there are no uplink ports, so each additional switch/access point you connect takes up one of your 8 slots.

Oddity: Checking the box, you will find a version number on the serial number sticker. Notably you want at least version 2.0 (has the web interface). Version 3.0 is nearly identical to version 2.0, though it apparently supports fewer IGMP Snooping groups (32 vs 128). That said I wasn&#8217;t able to find much way to configure these, unless they&#8217;re hidden behind other features (IGMP Snooping is for routing multicast traffic).

Oddity 2: I&#8217;ve read online that these are supposed to have a 5 year warranty. In Canada, there is a sticker that says it&#8217;s a 2 year warranty. Not a problem, but worth noting it&#8217;s shorter for us. Canada Computers stocks them locally for a good price ($52.99), but Amazon.ca has them for $49.99, so if you&#8217;re in no rush you can save a buck.

Brand new devices come assigned the management IP of 192.168.0.1 with admin/admin as their credentials.

It supports &#8220;Port Mirroring&#8221;, if you want a device set up to monitor all traffic (yuck).

It supports a bunch of &#8220;simpler&#8221; VLAN modes, but it also supports standard 802.1Q, which is what you want for compatibility with other devices.

The &#8220;802.1Q VLAN&#8221; page is used to configure outgoing data (i.e. what VLAN traffic to forward to the different ports). The &#8220;802.1Q PVID Setting&#8221; page is used to configure what VLAN to assign incoming untagged data coming from attached clients.

When setting up a mapping, you should list all normal clients as &#8220;untagged&#8221;, and any VLAN capable devices (i.e. switches/access points/properly configured servers) as &#8220;tagged&#8221;. It took a while for me to grasp it worked this way. 

If you want to bulk-route all VLAN traffic (not just stuff set on the &#8220;802.1Q VLAN&#8221; page), you can set up Trunking on specific ports. They need to be done in groups (for some reason). That said you can alternatively just list every VLAN port you want to route, and even if doesn&#8217;t have an exit interface, you can avoid wasting ports on the Trunk.

In addition there are a variety of QOS features that can be configured. Specific bandwidth limits per port, and more. It&#8217;s really quite cool, and a bargain.

Power Usage: Max 5.4W (9V * 0.6A).

### Ubiquiti EdgeRouter-X

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/10/edgerouterx-640x433.jpg" alt="" width="640" height="433" class="aligncenter size-large wp-image-9764" srcset="http://blog.toonormal.com/wp-content/uploads/2017/10/edgerouterx-640x433.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2017/10/edgerouterx-450x305.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2017/10/edgerouterx.jpg 662w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2017/10/edgerouterx.jpg)

This is an amazing little device. For a mere $50 ($70 CAD), this is a high-end router for a respectable price. It&#8217;s NOT an all-in-one (i.e. no WiFi, no USB storage), but rather a single device that does advanced internet routing on a budget.

Behind the lovely Web UI it&#8217;s a Linux box, one you can SSH in to and do things above-and-beyond what the UI offers. That said the UI offers a lot. You can use it for VPN&#8217;s an well, but that&#8217;ll use . If you really want a VPN, you should alternatively consider setting up a dedicated VPN machine, or a full fledged pfSense box.

Depending on what you make it do, the EdgeRouter-X will cap out at 850 Mbit of bi-directional bandwidth (instead of the full gigabit/950 Mbit seen on costlier models). Deep packet inspection will slow that down, as will other features, but given that my internet caps out at 30 Mbit down, this is a non issue.

Another key feature of the router is that it gets regular updates, much like my ancient Synology NAS. Apparently my old routers were EOL, and after the KRACK debacle, decided I needed something better. Having a company that cares about security behind it is good piece of mind.

It supports POE (wow).

Long story shot, it&#8217;s the brain of the operation now.

Power Usage: Max 6.0W (12V \* 0.5A) with included adapter, or 12.0W (24V \* 0.5A) with POE.

### Ubiqiti Ubifi Access Point

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/10/ubifi-640x249.jpg" alt="" width="640" height="249" class="aligncenter size-large wp-image-9775" srcset="http://blog.toonormal.com/wp-content/uploads/2017/10/ubifi-640x249.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2017/10/ubifi-450x175.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2017/10/ubifi.jpg 717w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2017/10/ubifi.jpg)

Now this is where you really know you&#8217;ve entered a new world networking. Rather than a combination Router+Switch+Access Point, you literally have all 3 separately. This specific piece of hardware (the Access Point) is a little dumb, but not actually.

Ubiquiti&#8217;s Ubifi hardware requires that you have a dedicated configuration server (i.e. controller) _somewhere_. It itself lacks the web-ui found on most easy-to-use devices, but you get that with the Ubifi controller software. The software itself is a Java application, so it can be run on any computer capable of running a Java VM. It can even be run on a desktop, but frankly I think you&#8217;re way better off with something dedicated.

You can do the most basic of tasks with your phone, but a controller really is required for proper Ubifi configuration.

Your choices for what runs a key are quite impressive. Ubiquiti makes a standalone key (or mini PC) that can be had for ~$100 that is just set-up and ready to go.

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/10/UniFi-Cloud-Key-mit-Kabel-640x427.jpg" alt="" width="640" height="427" class="aligncenter size-large wp-image-9776" srcset="http://blog.toonormal.com/wp-content/uploads/2017/10/UniFi-Cloud-Key-mit-Kabel-640x427.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2017/10/UniFi-Cloud-Key-mit-Kabel-450x300.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2017/10/UniFi-Cloud-Key-mit-Kabel.jpg 1200w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2017/10/UniFi-Cloud-Key-mit-Kabel.jpg)

Alternatively, you can the Ubifi controller in an off site cloud VPS&#8230; yes really. This feature is really weird to me, but hey, okay! It&#8217;s super helpful as far as remote management goes. That&#8217;s not me though.

More up my alley is running a cheap microserver. Something from the Orange Pi or NanoPi family. A variety of Quad core ARMv7 and ARMv8 computers that can be had for about $20.

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/10/orangepi_one-640x640.jpg" alt="" width="640" height="640" class="aligncenter size-large wp-image-9777" srcset="http://blog.toonormal.com/wp-content/uploads/2017/10/orangepi_one-640x640.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2017/10/orangepi_one-150x150.jpg 150w, http://blog.toonormal.com/wp-content/uploads/2017/10/orangepi_one-450x450.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2017/10/orangepi_one.jpg 800w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2017/10/orangepi_one.jpg)

Setting one of these up does require some homework. Armbian, my goto distribution for these mini PCs is extremely great for mini servers. Just be aware of what devices have proper support before buying.

According to the literature I&#8217;ve read, the Ubifi Access Points can be configured for up to 8 SSID&#8217;s. So far I&#8217;ve only seen how to do 2 (a 2.4 GHz and 5 GHz), but I don&#8217;t doubt it&#8217;s there somewhere. The key again is having that Ubifi Controller running&#8230; something at the time of this writing (this paragraph) I&#8217;m still working on.

Ubifi Access Points are powered by POE or Power Over Ethernet. An adapter is included with single units, so no additional hardware is required. In a proper deployment, you can buy multi-packs for cheaper, but you would often need to pair them with a POE switch.

## Breakdown of NAT/SNAT/DNAT, IN/OUT/LOCAL and other concepts

This is some information I&#8217;ve lifted from a thread on the Ubiquiti forums. 

I didn&#8217;t write this, I just want to be sure I have a copy. Author deleted his account.

Source: <https://community.ubnt.com/t5/EdgeMAX/Layman-s-firewall-explanation/m-p/1436103#M91494>

* * *

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/10/ERL1-640x362.png" alt="" width="640" height="362" class="aligncenter size-large wp-image-9793" srcset="http://blog.toonormal.com/wp-content/uploads/2017/10/ERL1-640x362.png 640w, http://blog.toonormal.com/wp-content/uploads/2017/10/ERL1-450x255.png 450w, http://blog.toonormal.com/wp-content/uploads/2017/10/ERL1.png 956w" sizes="(max-width: 640px) 100vw, 640px" />](http://blog.toonormal.com/wp-content/uploads/2017/10/ERL1.png)

A firewall policy is a set of rules with a default action. Firewall policies are applied before **SNAT** (Source Network Address Translation) and after **DNAT** (Destination Network Address Translation).

<https://help.ubnt.com/hc/en-us/articles/205231540-EdgeMAX-Add-access-control-list-ACL->

#### IN, OUT, and LOCAL

**WAN_IN** = From the internet, through the router, and onward to your LAN. In very general terms, you want to drop 90% of this mess &#8211; it&#8217;s script kiddies, port scans, nigerian princes, and anyone else you don&#8217;t want able to head through your router. Obviously, you&#8217;re gonna want to allow ports 80, 443, 25, and others if you&#8217;re running those types of services. 

**WAN_OUT** = traffic that has been forwarded through the router and about to leave exit out the interface.

NOTE: &#8220;WAN_OUT&#8221; to the &#8220;out&#8221; direction on the WAN interface, it only applies to forwarded traffic so the requests from the router itself does not go through these rules

**WAN_LOCAL** = Traffic destined for the router (for example if you wanted to use the web UI on the router you&#8217;d need to allow port 443 on LOCAL. This firewall is for packets destined to the router itself (i.e. &#8220;localhost&#8221;) from the wan

**LAN_IN** = everything inbound to the router from your LAN (e.g. 192.168.1.0/24) that&#8217;s destined for somewhere else (WAN, other LAN such as 192.168.2.0/24). In a SMB, or SOHO setup, this is probably explicitly permissive. In an enterprise setting, this may or may not be permissive (e.g. blocking all outgoing traffic except for SFTP on a non-standard port)

**LAN_LOCAL** = everything inbound to the router from your LAN destined for the router. Again, unless you&#8217;re doing enterprise routing, this is probably fairly open &#8211; although good SMB setups with guest networks may block the guest network range.

In terms of using IN or OUT rules, some will say that IN is better because if you&#8217;re going to drop a packet it&#8217;s better to do it on input rather than go through the full packet processing path only to drop it before it leaves the router. Also note that creating a firewall ruleset without applying it to an interface/direction does nothing.

Firewall for IPv6 is separate from IPv4 firewall and currently it needs to be configured using the CLI (&#8220;set firewall ipv6-name &#8230;&#8221; etc.). OR the Config Tree in the Web UI, so you&#8217;ll need to create IPv6 rules separately and apply them to the appropriate interface/direction.

Easiest addressing to IPv6 firewalling is either DHCPv6 with reservations OR static IP. Once you have a fixed address for the device, you apply firewall policy just like you would in IPv4. Currently (v1.6.0) the NAT configuration is IPv4-only. So for now you might try using the &#8220;ip6tables&#8221; command directly to manipulate the IPv6 nat table (sudo ip6tables -t nat &#8230;). <http://networkingnerd.net/2011/12/01/whats-the-poi​nt-of-nat66/> <http://blog.ipspace.net/2011/12/we-just-might-need​-nat66.html>

Disabling IPv6 on the router = set system ipv6 disable

#### NAT &#8211; Symmetric type

NAT changes the addressing of packets. 

A NAT rule tells the EdgeRouter what action to take with a specific packet. Define the following:

&#8211; Criteria for matching packets
  
&#8211; Action to take with matching packets

Rules are organized into a set and applied in the specified Rule Order. If the packets match a rule’s criteria, then its action is performed. If not, then the next rule is applied.

#### Source NAT Rules

Source NAT Rules change the source address of packets; a typical scenario is that a private source needs to communicate with a public destination. A Source NAT Rule goes from the private network to the public network and is applied after routing, just before packets leave the EdgeRouter. SNAT = Source NAT = Translation / Manipulation from Internal to External (masqueraded to the Internet).

**SNAT vs MASQUERADE**: Both are network address translation (NAT) techniques whereby the source (LAN) address gets automatically converted to another address (typically the WAN address) by the router.

&#8211; MASQUERADE converts the address to the WAN address, whatever it happens to be. In other words, at every conversion, it has to check what the WAN address is.

&#8211; SNAT converts the address to a fixed address, set to the WAN address by the firewall initialization.

In theory, SNAT should be faster, since both are performing the same translation but MASQUERADE has to perform that extra lookup. In practice, we&#8217;re only talking about a few machine instructions here, so the difference is not noticeable.

Masquerade only uses the primary address of the interface. Now say my ISP gives me a /29 with 5 addresses. Then I might have something like:

<pre>ubnt@R3# show interfaces ethernet eth6
address 1.1.1.2/29
address 1.1.1.3/29
address 1.1.1.4/29
address 1.1.1.5/29
address 1.1.1.6/29
duplex auto
speed auto
[edit]
</pre>

Now say I want LAN1 to use 1.1.1.3 and LAN2 to use 1.1.1.6. To do that I need source NAT = SNAT.

#### Destination NAT Rules

Destination NAT Rules change the destination address of packets; a typical scenario is that a public source needs to communicate with a private destination. A Destination NAT Rule goes from the public network to the private network and is applied before routing. SEE ALSO “PORT FORWARDING”. DNAT = Translation / Manipulation from External to Internal = Wan to LAN mapping

#### Hairpin NAT

Enabled by default. If you want to allow a host on the internal network to use the public IP address to access an internal server, then keep Hairpin NAT enabled. (Hairpin NAT is also known as NAT loopback or NAT reflection.) Note: If Hairpin NAT is enabled, then it only enables Hairpin NAT for the port forwarding rules defined in the wizard; it does not affect the Destination NAT Rules defined on the Security > NAT tab (refer to “Destination NAT Rules”)

NAT Hairpin = &#8220;NAT inside-to-inside&#8221; = &#8220;NAT Loopback&#8221; = &#8220;NAT Reflection&#8221; = SNAT Loopback.

<http://community.ubnt.com/t5/EdgeMAX/SNAT-Loopback-aka-Hairpin-Question/td-p/1552015>

The routers which support this specifically look for traffic which should hairpin. The routers which don&#8217;t support this do normal routing, and they send traffic destined for external addresses out the WAN interface, per the routing table.

This is completely dependent on the router make, model, and software version.

What happens on the routers which don&#8217;t support this is that the traffic from the inside host to the external server address has the destination address looked up in the routing table, and that points to the WAN interface, so the the traffic is sent to the WAN interface, which is an outside interface, so the inside source address gets translated, per the inside source NAT rules, to an outside address (usually the WAN interface address), and the traffic is sent out the WAN interface. This is all based on normal routing rules.

The traffic will travel to the ISP router, which will promptly drop it since it is coming in from an interface where the destination address is. Routers drop traffic destined for the network from which it originates.

#### UPnP

Instead of manually configuring port forwarding rules, you can use UPnP for automatic port forwarding when you have hardware that supports UPnP.

Typically, a NAT Port Forwarding rule is used from the outside network to get to a server on the inside network by using the public address of the router (or hostname). But in cases where the same local server address must be accessed from inside the local network, NAT Hairpin applies.

* * *

#### Difference between various firewall actions

**ACCEPT** &#8211; let the packet through
  
**DROP** &#8211; drop the packet, don&#8217;t let the source know
  
**REJECT** &#8211; drop the packed, but let the source know

* * *

**IN** &#8211; traffic entering the router from an interface (and later exiting via another interface)
  
**OUT** &#8211; traffic exiting the router to an interface (previously entered via another interface)
  
**LOCAL** &#8211; traffic entering the router and destined to router itself</p> 

* * *

**Source NAT**: Source Network Address Translation
  
**Destination NAT**: Destination Network Address Translation

#### Use-Case for Source NAT:

A local client behind Firewall or NAT device wanted to browse Internet

Local Client IP: 10.10.10.10/24
  
Website URL to visit: http://www.quora.com
  
IP Address of Quora: 54.84.216.68
  
Now when you type the URL in browser, your browser will establish a connection like this
  
Source Address: 10.10.10.10
  
Destination Address: 54.84.216.68

Now, when you send a TCP syn, destination has to send ack. Now, ACK will have a
  
source address: 54.84.216.68
  
Destination: 10.10.10.10

Now, as 10.10.10.10 is not globally unique, it may so happen that Quora may be using 10.10.10.10 in some local systems, so packets instead of going to you will reach their local system and you will not be able to establish connection.

So, what you do now is translate your source IP (10.10.10.10) to something which is globally routable (for example : 14.10.10.10).

Now, you will have source address as 14.10.10.10, your NAT device will need to maintain NAT Table.

#### Use case Destination NAT (DNAT)

Now imagine a scenario, you are hosting a website and your website local address is 172.19.18.10 (private IP), now people cannot connect to your website from internet because your IP is private and not-globally reachable.

So what you do now is to create a destination NAT entry where public IP is mapped to private IP.

You will have one public for example: 14.10.10.20 and you NAT it to 172.19.18.10 (Your local IP) so any request meant for 14.10.10.20 is actually translated to 172.19.18.10 by your NAT device.