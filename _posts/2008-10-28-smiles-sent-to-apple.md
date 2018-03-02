---
id: 199
title: '&#8220;Smiles&#8221; sent to Apple'
date: 2008-10-28T07:15:36+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2008/10/28/smiles-sent-to-apple/
permalink: /2008/10/28/smiles-sent-to-apple/
categories:
  - Smiles
  - Technobabble
  - The Business of Things
---
I&#8217;d love to say the wait is over, but now we start the next wait. Waiting for approval.

<center>
  <img src="/content/BlogSmilesArt.png" />
</center>

As of **7:45 AM** this Tuesday October 28th morning, the game is now sent.

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

Digging through my SVN logs for some stats.

Repository was created on June 22nd, 2008. That&#8217;s a total of **4 months** and **6 days**.

All code, art (except the original TTF font, though I did design and make the logo text), and audio created by me.

Project ended on revision **826**.

Final submitted zip file was just shy of 4 MB. Should be about 4.8 MB unzipped (meaning only that much space on your iPhone/iPod touch).

All content is compressed. Art is 16 BPP assets in RGBA 4444 format with mipmaps, then compressed with LZMA (better than PNG&#8217;s ZLIB). Sound Effects are ADPCM compressed about 2:1. Except for save data files, other external data (menus, screens) is converted from binary to C files (char[]&#8217;s), and linked against the project.

Developed mostly on Windows with MinGW (GCC) in C++. Custom graphics/game library that wraps native OpenGL ES calls and ObjC on the iPhone, and SDL+GL on Windows and Linux test builds. 

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

There. I&#8217;m in some desperate need of some sleep. Video, Website, and an actual explanation coming in the next few days.