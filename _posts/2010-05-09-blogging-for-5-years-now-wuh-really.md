---
id: 2558
title: 'Blogging for 5 years now&#8230; wuh, really!?'
date: 2010-05-09T02:48:45+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2558
permalink: /2010/05/09/blogging-for-5-years-now-wuh-really/
categories:
  - Smiles
  - Stuffing
  - Technobabble
---
I wont pretend this blog features much quality content, but it seems I&#8217;ve been filling it with nonsense for 5 years now (started May 1st 2005). So wow!

Completely unrelated, yet an appropriate way to celebrate, I now have an image at the top of the site. Wow &#8216;eh? Now I am a whole 2 steps away from the default WordPress theme (the 1st step was widening the layout).

The past week I&#8217;ve been busy with a variety of things. [**Smiles for Palm Pre**](http://developer.palm.com/webChannel/index.php?packageid=com.sykhronics.smiles) is available, and actually, I&#8217;ve already submitted and had an update approved. So that&#8217;s looking good.

My focus the last few days has been building and setting up my new desk. I&#8217;m not quite done setting things up, so I&#8217;ll hold off posting photos for now. My studio has/is acquiring a bunch of new furniture, so I&#8217;d like to get everything in and set-up before the tour. 🙂

This year is also my big switch from **Paint Shop Pro** (for both raster and vector art) to **Adobe CS5** (Photoshop and Illustrator). CS5 Production Premium showed up earlier in the week, but I didn&#8217;t get a chance to sit down with it until yesterday. Alongside CS5 I picked up one of the 12&#8243; Wacom Cintiq&#8217;s, since I imagine CS5 wont run well on my dated Tablet PC (Celeron). At GDC this year, I made a point of stopping by the Wacom booth to try out a Cintiq, to see if they had the same fuzzy-edge problem as my Tablet PC, which they do. Though after playing with the Cintiq for a couple days, the fuzzy-edges seem to distort less than the Tablet PC. Or it&#8217;s just &#8217;cause it&#8217;s bigger, but either way, it&#8217;s a win.

Between all this fun, I&#8217;ve been finishing my (updated) Windows and Linux ports for [AppUp](http://www.intelappup.com). I meant to have it done last weekend, but oh well, I guess I&#8217;m running behind. I replaced **SDL_mixer** with [**irrKlang**](http://www.ambiera.com/irrklang/) today. SDL_mixer has a bug with looping OGG files (after looping, sound distortions creep in to the stream), and [like Phil](http://www.galcon.com), I need something that works now. The new irrKlang sound engine is working well as a drop in replacement on Windows, but I ran in to a slight problem on Linux, though I&#8217;m fairly sure it&#8217;s an easy fix. I get the impression **irrKlang** streams everything from disk, unless explicitly played from memory. Knowing my luck there&#8217;s a flag somewhere that says &#8220;Cache sound in RAM&#8221;, but either way, it&#8217;s no trouble to load a file then pass it in. I&#8217;m mentioning this since I was expecting a similar setup to SDL_mixer (and certain other sound libraries), where WAV&#8217;s are stored in RAM, and OGG&#8217;s stream from disk. Apparently not, heh. It&#8217;s arguably a better design, but unexpected.

Also this week, **Smiles HD** was featured by Apple. Here&#8217;s a pic.

[<img src="/wp-content/uploads/2010/05/SmilesHDFeatured-640x356.png" alt="" title="SmilesHDFeatured" width="640" height="356" class="aligncenter size-large wp-image-2575" srcset="/wp-content/uploads/2010/05/SmilesHDFeatured-640x356.png 640w, /wp-content/uploads/2010/05/SmilesHDFeatured-450x250.png 450w, /wp-content/uploads/2010/05/SmilesHDFeatured.png 1024w" sizes="(max-width: 640px) 100vw, 640px" />](/wp-content/uploads/2010/05/SmilesHDFeatured.png)

You could say I&#8217;ve been looking forward to this for a year and a half now&#8230; because&#8230; well&#8230; I have been. ;). So hooray! Smiles has _finally_ been featured!

It&#8217;s been dancing around the 70&#8217;s on the top 100 grossing games chart most of the week. And if it could stay that high, that would be a pretty comfortable place for me earnings wise. Alas, this status of mine will be coming to an end Monday night. Still, it&#8217;s a welcome nod from the big A.

Once the AppUp builds of Smiles go out, the plan is to either get back on the _**Mystery Platform**_ port, or a demo/lite version of the game. I sent a pitch out last week that could introduce an immediate **3rd branch** to this agenda, but we&#8217;ll see.

As things stand, I&#8217;m probably looking at 2-3 months more Smiles work. There&#8217;s still some minor ports I may do, and always the possibility of one last big &#8220;hoo-rah&#8221; port, but soon I&#8217;ll be able to focus the my time almost entirely on the new game. With Palm done, AppUp nearly finished, my whiteboard list is clearing fast.

July, I&#8217;m coming for you!