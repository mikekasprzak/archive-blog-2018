---
id: 1739
title: Another Port
date: 2009-12-21T19:53:08+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=1739
permalink: /2009/12/21/another-port/
categories:
  - Smiles
---
Well, I can relax now. 🙂

I have the results back from the Samsung contest, but I can&#8217;t say how that went &#8230; yet. There&#8217;s supposed to be a proper winners announcement deal on [SamsungApps](http://www.samsungapps.com/) Thursday, so if I have anything to add, I&#8217;ll do it then.

So that&#8217;s one thing off my mind.

The other thing off my mind is [Intel&#8217;s contest](http://appdeveloper.intel.com). Netbook ports were due today, the same day as the results for Samsung. So it was an&#8230; ahem&#8230; interesting night for me (that involved me omitting sleep).

I sent off my initial port around noon, the deadline being 6 PM my time. There was some confusion about how entering actually worked. I got caught up in the mistakes some people on the forum had made, so there was a good 5 hours of completely irrelevant stress mixed in. I&#8217;m tired, I&#8217;m allowed to be confused. 😀

How about some pics?

<div id="attachment_1744" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/12/DropXX.png"><img src="/wp-content/uploads/2009/12/DropXX-640x374.png" alt="Smiles Drop, now with rotation buttons" title="DropXX" width="640" height="374" class="size-large wp-image-1744" srcset="/wp-content/uploads/2009/12/DropXX-640x374.png 640w, /wp-content/uploads/2009/12/DropXX-450x263.png 450w, /wp-content/uploads/2009/12/DropXX.png 820w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Smiles Drop, now with rotation buttons
  </p>
</div>

<div id="attachment_1749" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/12/DropLose.png"><img src="/wp-content/uploads/2009/12/DropLose-640x374.png" alt="Avalanche with extra &quot;Good Job, you lost!&quot;" title="DropLose" width="640" height="374" class="size-large wp-image-1749" srcset="/wp-content/uploads/2009/12/DropLose-640x374.png 640w, /wp-content/uploads/2009/12/DropLose-450x263.png 450w, /wp-content/uploads/2009/12/DropLose.png 820w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Avalanche with extra "Good Job, you lost!"
  </p>
</div>

There&#8217;s a whole bunch of new things to talk about. I&#8217;m looking forward to some R&R, so I&#8217;ll be brief.

**8&#215;8 Playfield** &#8211; This one made it in to the Omnia II version of the game too. The iPhone version featured a slightly larger 9&#215;8 playfield, which meant ordinary games lasted a long time. Now with the 8&#215;8, games are much quicker. Spend 5-15 minutes on a round, instead of 15-25.

**Rotation Buttons** &#8211; Now that the playfield is square, it can be freely reoriented without distortion. So that&#8217;s how the PC game gets around the fact that it doesn&#8217;t have an motion sensor (accelerometer). Windows 7 was supposed to add support to the OS, but I don&#8217;t have a 7 machine (or a non phone with an accelerometer) yet to test it with.

**Wider Aspect Ratio** &#8211; Since the buttons needed room, the virtual rectangle the game lives in had to grow. The game is scaled to fit whatever shape screen it end up on. The backgrounds are generated, so they feature enough filler to fill some of the weirder Netbook screen resolutions (Sony P-Series&#8217;s 1600&#215;768). On the agenda is to properly support tall aspect ratios, since the game is already capable of reshaping how it plays.

**720p Artwork** &#8211; Though I do have 1080p ready assets, they&#8217;re not necessary for Netbooks. Though Netbooks don&#8217;t generally do 720p resolution, I have come across an Acer model that&#8217;s 1366&#215;768 (i.e. higher than 1280&#215;720). Either way, this PC version bundles the 720p Assets, so it&#8217;ll look nice and crisp on one of those, or even low resolution MID&#8217;s.

**Touch Screen and Mouse Cursor detection** &#8211; In practice, the only real way to tell the difference between a mouse and touch screen is that a touch screen doesn&#8217;t have hover events. Wacom pens do, but not touch screens. So when the game detects motion events, it shows a mouse cursor. If that cursor sits idle for a while, it hides it. That way, the game will function systems that do both mouse and touch. Eventually I&#8217;ll add a configuration option to pick which mode you prefer (or just leave it on Automatic).

So all that, plus many bugfixes that I can&#8217;t even remember half of them. One such fix is the placement of the Achievements and the thing I call &#8220;The Tony Hawk Score Popup&#8221;. On the iPhone version they overlap, so you can&#8217;t read them both at the same time. Several little things like that.

There&#8217;s still much to do. This version of the game was tuned to the Netbook experience. Automatically full-screening, lack of accelerometer, etc. That means I actually broke a few things in the game code, but not things you&#8217;d normally be able to see. This project crunch, like the Omnia II one was about getting the game working in several new platform configurations. So when I&#8217;m ready to get back to work, I have a whole bunch of code to reorganize in some unified fashion. Casualties of past month include my Linux build, which doesn&#8217;t even work anymore. Both recent ports required Visual Studio ingenuity, so I certainly let a few normally portable aspects slip.

A feature I cut from my TODO list was the configuration menu, which I consider necessary for a proper PC build. Some people might like playing in a Window, to force the tall orientation (even if there&#8217;s no motion sensor), or disable some automatic behavior feature of mine. The code&#8217;s all there to do this, it just needs to be cleaned up so it knows to do this automatically.

Now I&#8217;ve surely forgotten something, but that&#8217;s alright. The crunch is over (for now). I&#8217;ll be taking some time to rest now.

Ahhhhh!