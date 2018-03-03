---
id: 9811
title: 'Notes: EdgeMax (EdgeRouter)'
date: 2017-10-29T22:32:58+00:00
author: Mike K
layout: post
guid: /?p=9811
permalink: /2017/10/29/notes-edgemax-edgerouter/
categories:
  - Uncategorized
---
Notes on working with an Ubiquiti EdgeRouter running EdgeMax.

## Factory Reset

If you ever need to start over, you can factory reset by holding the Reset button for about 10 seconds, until the eth4 LED starts flashing and then becomes solidly lit. After a few seconds, the LED will turn off, and the EdgeRouter will automatically reboot.

## Getting Started

Plug your computer in to PORT 1 (eth0). Connect to <https://192.168.1.1> (note **HTTPS**). Accept that it lacks a certificate. Default user account is &#8220;**ubnt**&#8221; with password &#8220;**ubnt**&#8221; (and no quotes).

First things first, you should do an update. At the very bottom of the page, there is buttons for **Alert** and **System**. Click **System**, and scroll further down.

In another tab, you&#8217;re going to want to open this link:

<https://www.ubnt.com/download/edgemax/edgerouter-x>

Grab the latest firmware for your EdgeRouter. Then back in the web-ui, find **Configuration Management & Device Maintenance**->**Upgrade System Image**->**Upload System Image**.

Hop over to the Wizards tab, and run the **Basic Setup**. This will reconfigure the EdgeRouter so PORT 1 (eth0) uses DHCP to fetch an IP and Gateway to the internet. This is useful for connecting it to your existing network, and for when you have a Cable internet provider (i.e. no authentication required. it&#8217;s all MAC/Serial Number based).

This also sets up **switch0**, and a variety of other settings (NAT masquerading for the WAN connection, good WAN firewall defaults, a DHCP server for a normal LAN). 

## The Dashboard

The dashboard is the main tab you use for setting up interfaces. 

After the wizard, we already have a virtual Switch (switch0) ready to go. If you drill down in to switch0&#8217;s settings (**Actions**->**Config**), you can define or change the IP address (i.e. where you see the Router on the network), or in the VLAN tab set which ports to associate with the Switch, and optionally set a fixed VLAN address for specific ports (i.e. for connecting an untagged device).

<!--more-->

## Adding VLANs

You create VLANs from the Dashboard. Click the &#8220;Add Interface&#8221; button near the top.

&#8211; VLAN ID is the VLAN ID (0-4094)
  
&#8211; Interface is which Port or Switch to associate it with (in our case, switch0)
  
&#8211; Description is a name
  
&#8211; leave MTU at 1500 to keep your packets the regular size
  
&#8211; IP Address, you might want to manually set one here. This is the address the VLAN will see, if you want to use services found on the router (DHCP, DNS, etc). This is a good idea, but you could alternatively use the same IP as your default LAN, just it means you have a slightly more complex configuration ahead of you when it comes to the firewall.

Repeat this for all the VLANs you want. 

This creates our interfaces. By default all ports of switch0 are trunked, meaning VLAN traffic will flow freely to every port. In fact, there are no restrictions in place. So traffic will pass freely through VLANs, but once they reach the router, then can return-trip up other VLANs (i.e. it&#8217;s indistinguishable from a single LAN now). We&#8217;ll address this later with firewalls.

## DHCP Server per VLAN

Right now the VLANs have no identity. So what we&#8217;ll do is create 

## DNS per VLAN

From the **Services**->**DNS** tab, we need to make sure our VLANs are included on the list of **Interfaces** that are monitored.

When you will likely have one entry for switch0, and an entry for every VLAN you want to have internet access (switch0.10, switch0.25, etc).

## Isolating VLANs (with Firewalls)

Here&#8217;s the bread and butter.

https://help.ubnt.com/hc/en-us/articles/204959444-EdgeRouter-Router-on-a-Stick-with-Inter-VLAN-Firewall-Limiting

https://help.ubnt.com/hc/en-us/articles/115010913367-EdgeRouter-DNS-Forwarding-Explanation-Setup-Options

https://help.ubnt.com/hc/en-us/articles/115006615247-Intro-to-Networking-Network-Firewall-Security