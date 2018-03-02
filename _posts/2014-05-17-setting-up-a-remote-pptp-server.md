---
id: 6966
title: Setting up a remote PPTP server
date: 2014-05-17T08:48:47+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6966
permalink: /2014/05/17/setting-up-a-remote-pptp-server/
categories:
  - Linux
  - Technobabble
---
So I&#8217;ve been working on netcode recently. LAN/Local testing is only so effective, when the real internet is so laggy. Ideally, if I could be in 2 places at once, I could test the game under a more natural lagged internet.

So that&#8217;s what I&#8217;ve done. I&#8217;ve split in two and sent my other half down south&#8230; okay no. I recently set up an inexpensive unmanaged [BuyVM](https://my.frantech.ca/aff.php?aff=984) VPS server (256 MB RAM, Dual Core) in Las Vegas running a trimmed down version of Ubuntu 14.04 Server. From where I&#8217;m at (2 hours south of Toronto), the ping between myself and the Las Vegas server is around 100ms.

Like always, here are my notes.

## Setting up [BuyVM](https://my.frantech.ca/aff.php?aff=984) Server as a PPTP VPN

Setting up, I started by &#8220;Reinstalling&#8221; a fresh Minimized Ubuntu 14.04 64bit Server. At the time, Ubuntu 14.04 wasn&#8217;t yet available as a pre-install. It was something I had to do after creating my account.

From that fresh install, I need to first do an APT update:

<pre>sudo apt-get update</pre>

Next, install IPTABLES.

<pre>sudo apt-get install iptables</pre>

Follow these instructions:

<https://help.ubuntu.com/community/PPTPServer>

At the very end though, we&#8217;re setting the IPTables in &#8220;/etc/rc.local&#8221;. Do this instead:

<pre>iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -j SNAT --to-source YOUR_SERVER_IP
iptables -A FORWARD -p tcp --syn -s 192.168.0.0/24 -j TCPMSS --set-mss 1356</pre>

The change is the first line. We&#8217;re not binding to an interface, but setting a source.

Done. Can now VPN using the PPTP protocol, and route all your internet traffic through it.

Reference: <http://wiki.buyvm.net/doku.php/ipsec> (combined the Ubuntu notes and this)

\* \* *

To connect: Use the server IP address, login and password set in the secrets file.