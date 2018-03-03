---
id: 3495
title: Eighty Five Percent
date: 2010-11-30T03:40:56+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3495
permalink: /2010/11/30/eighty-five-percent/
categories:
  - Smiles
  - Technobabble
  - The Business of Things
---
Alright, time to get back in to the routine.

It&#8217;s been two weeks since the last post. Last week became an impromptu holiday for me &#8212; I am a Canadian living in Canada, but I deal mostly with US companies, so American Thanksgiving seemed safe.

The week prior was busy though. I sent off the initial version of **Smiles HD** for the **Mac App Store**. It still sits in the approval queue, but I&#8217;m there.

<a href="http://www.desura.com" title="Games Digital Distribution" target="_blank"><img src="http://media.desura.com/images/global/desura_200x125.png" alt="Desura" border="0" hspace="10" height="125" width="200" align="right" /></a>That wasn&#8217;t the only build I submitted though. For the past month, I&#8217;ve been part of the private [**Desura**](http://www.desura.com) beta &#8212; a steam-like store from the ModDB and IndieDB people. They&#8217;re new and have _just barely_ launched, but the system is very slick (it even supports buying and selling mods). Definitely one to watch.

You can check out the **Smiles HD** page on Desura here:

<http://www.desura.com/games/smiles-hd>

Also, this is the first **Windows** version of **Smiles HD** available for sale (Smiles on AppUp is Netbook tuned) &#8212; not even my &#8220;buy direct&#8221; option is available yet (much website work to still do). The game **wont** be exclusive to Desura, but it is _**very easy**_ for me to make and push updates with them (until I get my own system in place).

Both the Mac App Store and Desura have **Smiles HD** 1.1.0. Once I add a few more things, I&#8217;ll send out a 1.1.1 update. 

One thing that held back the Linux build was a little discovery of mine. It seems the stock Intel GMA drivers that ship with Ubuntu 10.10 **don&#8217;t** support S3TC (DXT) texture compression.

Actually this isn&#8217;t a very big deal as there&#8217;s an update that should fix it, but it reminded me I may want a fallback option. So versions of Smiles HD newer than 1.1.0 will include both the full 1080p assets, and some non-texture-compressed 16bit &#8220;720p&#8221; assets. That adds about 10 MB to the game (already 40 MB). Not much really, and it guarantees compatibility. I suppose an option would be to write a software decoder for S3TC (DXT) compressed data, but for PC&#8217;s I&#8217;m okay with adding 10 MB. I&#8217;ll probably omit it from the Mac version though, since the store requires OS 10.6.6.

<div id="attachment_3529" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/LinuxWindow.png"><img src="/wp-content/uploads/2010/11/LinuxWindow-640x375.png" alt="" title="LinuxWindow" width="640" height="375" class="size-large wp-image-3529" srcset="/wp-content/uploads/2010/11/LinuxWindow-640x375.png 640w, /wp-content/uploads/2010/11/LinuxWindow-450x263.png 450w, /wp-content/uploads/2010/11/LinuxWindow.png 1024w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Tiny Window for a Tiny Netbook Screen (1024x600) -- Oh hey! I added space from the border
  </p>
</div>

One thing that didn&#8217;t make 1.1.0 was a toggle button for switching between fullscreen and windowed (the game fullscreens). I put off adding the feature for a number reasons; The main reason was that I didn&#8217;t have a good idea what resolution to make the window, and I wasn&#8217;t liking the idea of adding a resolution selection screen (it&#8217;s cluttered enough already!).

When Smiles HD starts, it checks the desktop resolution and uses that as the game resolution. Every system I&#8217;ve tested it on runs nearly 60fps. Interestingly, as the resolution of the attached monitor goes up, the computers seem to have a beefier GPU (no Intel GMA 950&#8217;s attached to 1080p screens&#8230; except for my Mac, and it runs fine there).

<div id="attachment_3542" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/SmilesWindows85.jpg"><img src="/wp-content/uploads/2010/11/SmilesWindows85-640x360.jpg" alt="" title="SmilesWindows85" width="640" height="360" class="size-large wp-image-3542" srcset="/wp-content/uploads/2010/11/SmilesWindows85-640x360.jpg 640w, /wp-content/uploads/2010/11/SmilesWindows85-450x253.jpg 450w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Hello Windows 7. My my! You have such big gutters!
  </p>
</div>

So what I&#8217;ve decided to do is create a window 85% of desktop resolution. I tried 80% initially, but it seemed too small, so I bumped it up. I figure that **\*should\*** be enough room. Worst case, you&#8217;ll always have the fullscreen button available to you if you can&#8217;t fit it all. I still have to make the button work, but that is the plan.

That&#8217;s all for now.