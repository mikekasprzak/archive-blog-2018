---
id: 739
title: Evolving Smiles
date: 2009-02-23T07:47:09+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=739
permalink: /2009/02/23/evolving-smiles/
categories:
  - Smiles
  - Technobabble
---
Alright, I don&#8217;t see a reason _not_ to talk about this publicly. So if I&#8217;m a good boy, I&#8217;ll be walking through my process of up-scaling, converting, and porting **Smiles** as it happens. Ideally, I&#8217;d like to have the game available for all 3 desktop platforms (Windows, Mac, Linux).

Quickly, **Smiles** is an [IGF Mobile nominated](http://www.igfmobile.com/02finalists.html) collection of puzzle games for iPhone. You can learn more about the game at [smiles-game.com](http://www.smiles-game.com), or try it for free by grabbing &#8220;**Free Smiles**&#8221; from the App Store.

[<img class="aligncenter size-full wp-image-741" title="shot01" src="/wp-content/uploads/2009/02/shot01.png" alt="shot01" width="480" height="320" srcset="http://blog.toonormal.com/wp-content/uploads/2009/02/shot01.png 480w, http://blog.toonormal.com/wp-content/uploads/2009/02/shot01-450x300.png 450w" sizes="(max-width: 480px) 100vw, 480px" />](/wp-content/uploads/2009/02/shot01.png)

The irony of an HD matching game amuses me, so that&#8217;s something I really would like to push with **Smiles**. At this stage, it&#8217;s not really much more work going straight to HD, so why not?

This new product tentatively called &#8220;**Smiles HD**&#8221; I&#8217;d like to be completely true to the original. That might sound like nothing special if all you&#8217;ve seen is the screenshot above. But what should be noted is that **Smiles** uses the iPhone&#8217;s accelerometer to follow gravity. In other words, as you tilt an iPhone, things now fall the direction the system is oriented. For some games it&#8217;s a gimmick, but a very real part of advanced play involves rock breaking. Sometimes, an easier falling/breaking scenario is 90 degrees away.

There&#8217;s certain much more to say on the subject, but I&#8217;ll save that for later.

The first step as I saw it was to up the resolution of the game art. When I started **Smiles** back in June 2008, I was sure to make my original art large enough that I _could_ fit it in to textures suitable for HD. The first demonstration of this in action was a screenshot I posted over the weekend.

[<img class="aligncenter size-medium wp-image-731" title="smhd03" src="/wp-content/uploads/2009/02/smhd03-450x300.jpg" alt="smhd03" width="450" height="300" srcset="http://blog.toonormal.com/wp-content/uploads/2009/02/smhd03-450x300.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2009/02/smhd03-1024x682.jpg 1024w, http://blog.toonormal.com/wp-content/uploads/2009/02/smhd03.jpg 1440w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2009/02/smhd03.jpg)

This involved rebuilding the texture atlas&#8217; the game uses, as the original iPhone one was a fraction of the size.

[<img class="aligncenter size-full wp-image-748" title="smilesarttohd" src="/wp-content/uploads/2009/02/smilesarttohd.png" alt="smilesarttohd" width="405" height="339" />](/wp-content/uploads/2009/02/smilesarttohd.png)

This actually works out quite nice. The iPhone version fit enough detail nicely in to a 512&#215;512 texture. Doubling that to 1024&#215;1024 gives enough for SD and HD 720p.  Doubling again to 2048&#215;2048 gives enough for HD 1080p displays, and a little extra for those running a _monstrous_ 2560&#215;1600 30&#8243; display. Weather there is a market or not, I have no idea. But _you just know_ there will be that _1 guy or gal_ who wants to brag. 😀

In actuality, the game board of **Smiles** doesn&#8217;t need this high resolution of art. However, there are a few places in game where the art is scaled (clicking, or on the side bar). I&#8217;ve been running a PC development version of **Smiles** at 2x iPhone since the beginning, and well, the low-res side bar art bothered me. ;).  So _I want_ what&#8217;s considered the HD version of the game to be entirely _of_ the resolution, or better.

As of right now, many of the assets are converted. All the buttons and fonts are vector art, so they were a simple matter of setting the new resolution and exporting. There&#8217;s still a few little things that were raster, or snapped from vector. I don&#8217;t unload textures, since there _was_ enough memory to store them all. Amusingly, a fresh start of the game currently uses about 160 MB of video RAM. If I change the theme, we hit 210 MB.  By the time I finish, I&#8217;d estimate the uncompressed textures to take between 260 MB and 300 MB.  Wow! 😀

That&#8217;s&#8230; a lot.  All assets are uncompressed 32bit textures, so an easy fix would be to start using DXT/S3TC texture compression. That&#8217;s something I&#8217;ll probably try out today.  If I was to port this to an Xbox 360 or PS3, I&#8217;d pretty much have no choice (well, some choice).  The last thing anyone wants is to constantly have to decompress (not crazy enough to ship raw), push in and out huge 2048&#215;2048 uncompressed textures between RAM and VRAM every frame.  Ideally, put &#8217;em in, and let the system perform like the monsters they are.

Still, for PC&#8217;s, I&#8217;m thinking it may be worth having 2 sets of assets around.  DXT/S3TC compressed ones, and uncompressed.  That way if you _do_ have a 512 MB+ video card around, and a huge 30&#8243; Dell or Apple Cinema display, you can flaunt your computer envy in glorious uncompressed full resolution&#8230; with a matching game. 😉

An under served niche? 🙂

Next on the on the agenda, dealing with aspect ratios.