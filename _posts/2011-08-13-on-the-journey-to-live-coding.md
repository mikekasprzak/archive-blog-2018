---
id: 4477
title: On the Journey to Live Coding
date: 2011-08-13T14:37:28+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4477
permalink: /2011/08/13/on-the-journey-to-live-coding/
categories:
  - Alone, The
  - Technobabble
---
This past couple weeks I&#8217;ve been busily working on architecting many little things (super important things) for my new game. One of the big things I really didn&#8217;t set out to do initially, but once I realized my efforts were converging there, I decided to make it a priority: Live Coding.

I am using a scripting language [Squirrel](http://www.squirrel-lang.org) to handle the gameplay side of the programming. This is new for me, having hardcoded or written my own sub-par scripting and data entry dialects to make my prior games. 

I opted for [Squirrel](http://www.squirrel-lang.org) over LUA due to its similarities to C and C++. It&#8217;s created by a fellow gamedev, so issues we have with the LUAs of the world are taken in to serious consideration. It counts from zero (!!), uses C/C++ style comments, has an integer type, uses float instead of double, uses reference counting instead of a GC, and most importantly: uses a file extension &#8220;.nut&#8221;&#8230; LET THE TOTALLY SILLY LATE NIGHT CODER JOKES BEGIN!

Performance benchmarks of Squirrel 3.0 place it on-par with the non-JIT LUAs. There&#8217;s a [well known scripting benchmark](http://codeplea.com/game-scripting-languages) that shows Squirrel doing poorly (Version 2.2), but [a friend](http://www.polygontoys.com) did [his own benchmarking](http://pastie.org/1721408) recently that shows things have dramatically improved. Another dev informed me that LUAs JITs are now available on ARM and PPC, and at least the [ARM benchmarks are a huge improvement](http://luajit.org/performance_arm.html) (PPC not so much). Apple still has their [execution policy](http://stackoverflow.com/questions/5054732/is-it-prohibited-using-of-jitjust-in-time-compiled-code-in-ios-app-for-appstore) in place, making a JIT useless, but that aside [I value my own sanity](http://the-witness.net/news/2011/06/how-to-program-independent-games/) and prefer not-to have to switch my brain in to coding thinking too far away from my comfy C/C++, and admit there are elegance improvements to be made over that (I see working in Squirrel to be a potential improvement&#8230; maybe!).

On Live Coding again, I see it as more than just code. Right now it&#8217;s only script code, but very soon I plan to extend this to other forms of game content (textures, models, shaders, maps, etc).

My Live Coding setup is bound to the Window focus. When the game re-gains focus, a process of scanning content begins, and any assets found to have changed are reloaded. Pictures:

<div id="attachment_4478" style="max-width: 628px" class="wp-caption alignright">
  <a href="/wp-content/uploads/2011/08/TechShot03.png"><img src="/wp-content/uploads/2011/08/TechShot03.png" alt="" title="TechShot03" width="618" height="203" class="size-full wp-image-4478" srcset="http://blog.toonormal.com/wp-content/uploads/2011/08/TechShot03.png 618w, http://blog.toonormal.com/wp-content/uploads/2011/08/TechShot03-450x147.png 450w" sizes="(max-width: 618px) 100vw, 618px" /></a>
  
  <p class="wp-caption-text">
    Script before modification. Showing a no-change refresh. Currently just text printing that AWESOME line.
  </p>
</div>


  
An ALT+TAB, some munging with the Main.nut script file, an ALT+TAB back in:
  


<div id="attachment_4479" style="max-width: 628px" class="wp-caption alignright">
  <a href="/wp-content/uploads/2011/08/TechShot04.png"><img src="/wp-content/uploads/2011/08/TechShot04.png" alt="" title="TechShot04" width="618" height="299" class="size-full wp-image-4479" srcset="http://blog.toonormal.com/wp-content/uploads/2011/08/TechShot04.png 618w, http://blog.toonormal.com/wp-content/uploads/2011/08/TechShot04-450x217.png 450w" sizes="(max-width: 618px) 100vw, 618px" /></a>
  
  <p class="wp-caption-text">
    After modification, things go from AWESOME to SILLY. Tom is an instrument.
  </p>
</div>


  
Assuming there were no errors, script is recompiled and executed, so that it re-overloads the referenced functions.

I&#8217;ve given myself a relatively short timeline on this game, considering what I want from it, and considering all the distractions I have in the coming weeks (I am moving early September). I want something playable by IGF Submission time (October 17th), though I&#8217;m undecided if I am entering (unlikely far enough). I want it VERY playable for GDC (March 2012). I want to be shipping on the first platforms late Summer 2012, so roughly a 1 year timeline. Being able to SUPER-RAPIDLY do and test something in game is VITALLY important if I&#8217;m going to make it.

Currently the Live Code system is set up for [Squirrel](http://www.squirrel-lang.org) scripts, the language all gameplay code will be written in. Next up I need to add support for Shaders, Textures, and 3D models. Search paths are already set-up to pull files from the source folders first (unless a release build, then native/optimized content gets loaded first).

Next weekend is Ludum Dare, so I have a little bit of work to do there in the near term. I am hoping to have several forms of Live Code-able content ready to be used before we begin the event. Fun fun.