---
id: 9694
title: Last Minute VPN Notes
date: 2017-06-02T15:27:27+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9694
permalink: /2017/06/02/last-minute-vpn-notes/
categories:
  - Uncategorized
---
Just a short one. This is an excellent article on how to get OpenVPN running on Ubuntu 16, and how to utilize it on a variety of OS&#8217;s.

<https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-16-04>

This article is simpler, conversely doesn&#8217;t explain what&#8217;s going on as well. Notably though, as it tells you how to get the VPN working on an OpenVZ VPS.

<https://www.rosehosting.com/blog/install-and-configure-openvpn-on-ubuntu-16-04/>

Though as of this writing I haven&#8217;t been able to get this to route traffic correctly.

**EDIT:** Okay, I figured it out.

It seems the iptables aren&#8217;t persistent across reboots. This line:

<pre class="lang:default decode:true " >iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j SNAT --to-source &lt;YOUR_SERVER_IP&gt;</pre>

Is very important.

You can check the status of the iptables as follows.

<pre class="lang:default decode:true " ># View ... something
iptables -S

# List NATs
iptables -t nat -L</pre>

Here is a recommended way to persist iptables:

<https://askubuntu.com/a/373526>

Unfortunately BuyVM OpenVZ Ubuntu installs are misconfigured, so neither package will install.

**EDIT2:** looks like it was a DNS failure.

<https://askubuntu.com/questions/91543/apt-get-update-fails-to-fetch-files-temporary-failure-resolving-error>

After doing that, I was able to successfully install the iptables-persistent package.