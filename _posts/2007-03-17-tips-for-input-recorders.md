---
id: 240
title: Tips for Input Recorders
date: 2007-03-17T21:51:13+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2007/03/17/tips-for-input-recorders/
permalink: /2007/03/17/tips-for-input-recorders/
categories:
  - Stuffing
  - Technobabble
---
This is part of a forum post I made. Classic Mike, going completely off topic and force feeding all the random advice I had saved up.

&#8211; &#8211; &#8211; &#8211;

Be sure your input update is written/recorded immediately before the game processes it. In other words, at the end your control interpretation code/handler. That way it can &#8220;in theory&#8221; reproduce a crash, instead of coming up a frame or two short. So if it doesn&#8217;t crash, then your crash is likely related to an uninitialized variable. So you forgot to set it in a function, initialize it to zero in the constructor, or set/handle a pointer. Hardware/Driver/Compiler problems are a possibility, but there&#8217;s an incredibly good chance it isn&#8217;t. Be wary of GCC the 3.0.x series though (anything newer is much more reliable, 3.1.x+, 4.x, &#8230;).

Compressed input recording is good for attract mode and in game replays, but not so much crash reproduction (especially if you&#8217;re waiting on changes before you write).

Prefer fixed framerates for internal clocking. This&#8217;ll make reproduction/playback of non rendering bugs/crashes easier.

Recording the initial random number seed is helpful too. And if you don&#8217;t reseed, you don&#8217;t need to record reseedings. It&#8217;s so very easy to do this too, it can essentially be your file header of an input recording file. Read and populate the seed first, then playback all the following input commands. Technically, you shouldn&#8217;t ever need to reseed, unless you&#8217;re making a multiplayer game.