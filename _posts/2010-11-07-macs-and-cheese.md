---
id: 3330
title: Macs and Cheese
date: 2010-11-07T01:32:06+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3330
permalink: /2010/11/07/macs-and-cheese/
categories:
  - Smiles
  - Technobabble
---
This week I&#8217;ve been downloading updates for all my tools. Linux distros, as well as Apple tools and OS updates. Yesterday was spent trying to get a 64bit version of Ubuntu running on my Media Center PC (i.e. my old dual core AMD workstation PC, now hooked up to the projector). My initial attempt of installing it to a USB key didn&#8217;t work, but I did eventually get it working using [WUBI](http://www.ubuntu.com/desktop/get-ubuntu/windows-installer).

Unfortunately, my video-out setup on that PC is a bit strange (Component Video from an NVidia 7600), and the results were a little less than ideal:

<div id="attachment_3344" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Ubunblue.jpg"><img src="/wp-content/uploads/2010/11/Ubunblue-640x389.jpg" alt="" title="Ubunblue" width="640" height="389" class="size-large wp-image-3344" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Ubunblue-640x389.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Ubunblue-450x273.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Ubunblue.jpg 1094w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Feeling Blue Ubuntu?
  </p>
</div>

So I bit the bullet and put an order in for a dedicated Linux PC. So for about $250 + tax and shipping, I have [one of these](http://www.zotacusa.com/zotac-mag-hd-nd01.html) on the way. Once it arrives, I&#8217;ll be filling that 120GB/160GB hard drive (I forget which mine has) with many distros. 64&#8217;s, 32&#8217;s, Ubuntus, Fedoras, and I guess a Suse since that&#8217;s the other big one [according to the chart](http://distrowatch.com/stats.php?section=popularity).

Today was the first [#ScreenshotSaturday](http://search.twitter.com/search?q=%23ScreenshotSaturday). You can see a [compilation of images here](http://www.eggzero.com/screensat).

Here&#8217;s my contribution:

<div id="attachment_3331" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac01.jpg"><img src="/wp-content/uploads/2010/11/Mac01-640x399.jpg" alt="" title="Mac01" width="640" height="399" class="size-large wp-image-3331" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac01-640x399.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac01-450x280.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac01.jpg 1600w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    After a few hours of fighting, the Smiles builds on Mac again
  </p>
</div>

So yes, the Mac version has had some progress. I had to rebuild my project file (and mess with precompiled headers for a while), but the game is now building with the latest Xcode. 

<div id="attachment_3332" style="max-width: 562px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac02.png"><img src="/wp-content/uploads/2010/11/Mac02.png" alt="" title="Mac02" width="552" height="225" class="size-full wp-image-3332" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac02.png 552w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac02-450x183.png 450w" sizes="(max-width: 552px) 100vw, 552px" /></a>
  
  <p class="wp-caption-text">
    Tray Icons
  </p>
</div>

&#8220;The plan&#8221; as I saw it, was to quickly see if I could get a Mac App Store build of Smiles HD ready over the weekend. Since there&#8217;s so much time between now and the supposed launch date of the Mac App Store, I expect to have an update ready even before it goes live. I did run in to some issues though.

I have an older MacMini (Core2 Duo with GMA950), and recently picked up a Magic Trackpad for testing. So I gave the game a spin. The menus do well:

<div id="attachment_3336" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac03.png"><img src="/wp-content/uploads/2010/11/Mac03-640x173.png" alt="" title="Mac03" width="640" height="173" class="size-large wp-image-3336" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac03-640x173.png 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac03-450x122.png 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac03.png 828w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Ahh, a nice 6% CPU usage on my dual core
  </p>
</div>

But for some reason in-game performance is a little low&#8230; not to mention the CPU usage:

<div id="attachment_3337" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac04.png"><img src="/wp-content/uploads/2010/11/Mac04-640x173.png" alt="" title="Mac04" width="640" height="173" class="size-large wp-image-3337" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac04-640x173.png 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac04-450x122.png 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac04.png 828w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    ZOUNDS! 76%! Eek! That's the release build. The Debug build was 95%.
  </p>
</div>

I&#8217;m fairly certain this is because my textures are just too big in VRAM, which is causing a cache miss. That leads me in to the next big item on my TODO list: improve my texture format. Exactly what that entails is somewhere between adding DXT compression support, and not loading/data-compressing the largest mipmap in the same chunk as the rest of them.