---
id: 3420
title: Smiles in 64 bits
date: 2010-11-13T02:48:46+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3420
permalink: /2010/11/13/smiles-in-64-bits/
categories:
  - Smiles
  - Technobabble
---
So I spent the evening getting Smiles working in 64bit Linux (Ubuntu 10.10) as well as the Mac. Here are the results:

<div id="attachment_3421" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Linux6401.jpg"><img src="/wp-content/uploads/2010/11/Linux6401-640x400.jpg" alt="" title="Linux6401" width="640" height="400" class="size-large wp-image-3421" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Linux6401-640x400.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Linux6401-450x281.jpg 450w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Smiles HD, 64bit binary running on 'The Zotac' -- Ubuntu 10.10 Desktop
  </p>
</div>

And the Mac again:

<div id="attachment_3426" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac06.jpg"><img src="/wp-content/uploads/2010/11/Mac06-640x411.jpg" alt="" title="Mac06" width="640" height="411" class="size-large wp-image-3426" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac06-640x411.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac06-450x289.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac06.jpg 1600w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Smiles HD on the Mac again, this time in 64 bits
  </p>
</div>

And a closeup of the processes section:

<div id="attachment_3427" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac07.jpg"><img src="/wp-content/uploads/2010/11/Mac07-640x109.jpg" alt="" title="Mac07" width="640" height="109" class="size-large wp-image-3427" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac07-640x109.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac07-450x76.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac07.jpg 862w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    A zoom of the process, showing 64bit mode. The CPU usage is due to it being a debug build.
  </p>
</div>

Getting it working on the Mac wasn&#8217;t really necessary, but I really like Xcode&#8217;s debugging tools. They made tracing the issue very straightforward. I had two VNC windows going almost constantly, as I&#8217;d make changes on the Workstation PC, commit to SVN, and sync on both the Mac and the Zotac.

I had a pretty good idea what was the cause of my crashes, but I still hunted for some resources.

MSDN 32-bit to 64bit: <http://msdn.microsoft.com/en-us/library/3b2e7499%28VS.71%29.aspx>
  
20 (potential) issue of 64bit porting: <http://www.viva64.com/en/a/0004/>
  
GCC Type Attributes: <http://gcc.gnu.org/onlinedocs/gcc-3.2.3/gcc/Type-Attributes.html>

The 3rd link isn&#8217;t really important, but to be sure I set the &#8220;packed&#8221; property on a potentially dangerous union type (pointer and int overlay, though I removed the pointer).

The main issue with my code was my use of **size_t**. I use it everywhere! That&#8217;s not a bad thing, but I also use it inside my container types. That&#8217;s also not a bad thing, but these container types are designed to be bulk-written to disk as-is, which I do in some of my file formats.

> <pre>struct DataBlock {
	size_t Size;
	char Data[0];
};</pre>

That was the main culprit right there. Many of my datafiles contain raw **DataBlock** data (streams of memory, 32bit size followed by data). As it turns out, **size_t** is 64bits on 64bit OS&#8217;s, causing all kinds of alignment issues. Hoo boy!

My response to this was to create my own **size_t**: **st** for the system version (size_t), **st32** for a 32bit size holding type (unsigned int), and **st64** for a 64bit size holding type (unsigned long long int).

> <pre>struct DataBlock {
	st32 Size; // NOT size_t due to 64bit compatibility //
	char Data[0];
};</pre>

Ahh, much better.

I&#8217;m not too concerned about the 32bit limit on the size of a **DataBlock**. That lets me store and allocate just under 4GB of data in one. I may _some day_ add a **DataBlock64** type, but there&#8217;s no good reason right now (maintaining code that will never be used = waste of time).

As for other bugs going 64bit: On Linux, when I enabled [GLee](http://www.opengl.org/sdk/libs/GLee/) (the OpenGL extension library, not the musical), it introduced a number of new symbols that conflicted with my code (Thanks X Windows headers!). Bool, Status, and Font. I had to rename a bunch of variables and types to fix that.

Aside from that, the 64bit Linux build is consistently detecting a double-free I&#8217;m doing on exit. That one has plagued me for a while (rarely ever caused problems), so I&#8217;m glad I now have a platform that does it every time.

That&#8217;s all for tonight.