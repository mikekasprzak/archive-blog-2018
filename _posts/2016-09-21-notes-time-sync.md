---
id: 9330
title: 'Notes: Time Sync'
date: 2016-09-21T01:10:16+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9330
permalink: /2016/09/21/notes-time-sync/
categories:
  - Uncategorized
---
TBH I don&#8217;t have this figured out yet.

<pre class="lang:default decode:true " ># Check the current time
date

# Check the hardware clock (slower)
hwclock

# View the Time Status
timedatectl

# Set the timezone
timedatectl set-timezone EST</pre>

In my case, the HW clock is wrong (off by 1 hour).

It should be using NTP, but NTP doesn&#8217;t seem to take effect. I&#8217;ve read a bunch of conflicting information, like using &#8220;**ntpd -qg**&#8221; (which can&#8217;t be run until you stop the ntp service), or that a command &#8220;**hwclock &#8211;systohc**&#8221; will do it. One other dude said there&#8217;s some sort of check by hwclock that wont do it unless the date is only slightly off (safety feature). I don&#8217;t really buy that though.

Ah well, I just wanted a quick note for this.