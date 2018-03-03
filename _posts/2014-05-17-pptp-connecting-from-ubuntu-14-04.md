---
id: 6956
title: PPTP Connecting from Ubuntu 14.04
date: 2014-05-17T12:05:00+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6956
permalink: /2014/05/17/pptp-connecting-from-ubuntu-14-04/
categories:
  - Linux
  - Technobabble
---
So I was having troubles opening a VPN connection from Ubuntu 14.04. I could VPN just fine on my iPad and Android devices, but I was having no luck on Ubuntu. Looking at my **/var/log/syslog**, and after much Googling, it seems my problem was &#8216;secrets&#8217;/keyring related.

<pre class="lang:default decode:true " >&lt;info&gt; Starting VPN service 'pptp'...
&lt;info&gt; VPN service 'pptp' started (org.freedesktop.NetworkManager.pptp), PID 3642
&lt;info&gt; VPN service 'pptp' appeared; activating connections
&lt;error&gt; [1400344755.481227] [nm-vpn-connection.c:1374] get_secrets_cb(): Failed to request VPN secrets #2: (6) No agents were available for this request.
&lt;info&gt; Policy set '*****' (wlan0) as default for IPv4 routing and DNS.
&lt;info&gt; VPN service 'pptp' disappeared
</pre>

Setting up a PPTP VPN connection is easy.

[<img src="/wp-content/uploads/2014/05/VPN3-450x208.png" alt="VPN3" width="450" height="208" class="aligncenter size-medium wp-image-6961" srcset="/wp-content/uploads/2014/05/VPN3-450x208.png 450w, /wp-content/uploads/2014/05/VPN3-640x296.png 640w, /wp-content/uploads/2014/05/VPN3.png 804w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2014/05/VPN3.png)

What I was lacking was one very specific checkbox with many implications, none of which were [spelled out](http://ubuntuforums.org/showthread.php?t=1528840). The important one is that &#8220;Available to All Users&#8221; skips the secrets check, and instead prompts you for a password. That&#8217;s better than no VPN at all. 🙂

[<img src="/wp-content/uploads/2014/05/VPN1-450x450.png" alt="VPN1" width="450" height="450" class="aligncenter size-medium wp-image-6960" srcset="/wp-content/uploads/2014/05/VPN1-450x450.png 450w, /wp-content/uploads/2014/05/VPN1-150x150.png 150w, /wp-content/uploads/2014/05/VPN1.png 460w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2014/05/VPN1.png)

My advanced settings look something like this, thanks to other tutorials I stumbled across:

[<img src="/wp-content/uploads/2014/05/VPN2-274x450.png" alt="VPN2" width="274" height="450" class="aligncenter size-medium wp-image-6959" srcset="/wp-content/uploads/2014/05/VPN2-274x450.png 274w, /wp-content/uploads/2014/05/VPN2.png 342w" sizes="(max-width: 274px) 100vw, 274px" />](/wp-content/uploads/2014/05/VPN2.png)

Notably, no PAP, as that&#8217;s very insecure. The rest of the options, I haven&#8217;t tried otherwise. What&#8217;s important to me is I can now connect to my VPN.