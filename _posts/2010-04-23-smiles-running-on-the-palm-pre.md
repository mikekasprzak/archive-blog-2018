---
id: 2529
title: Smiles running on the Palm Pre, plus other things
date: 2010-04-23T01:54:52+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2529
permalink: /2010/04/23/smiles-running-on-the-palm-pre/
categories:
  - Smiles
  - Technobabble
---
One of the sessions I saw at GDC this year was Palm&#8217;s talk about their new PDK (i.e. their native SDK). The promise was a Linux based mobile device featuring SDL and OpenGL ES. Since my Windows and Linux code base also uses SDL and OpenGL, that certainly caught my attention. In theory, all I need to do is just recompile my Linux version with their tools and I&#8217;m done, right?



Pretty much.

There were 3 changes to the code I had to make. The first was a minor #DEFINE bug of mine that assumed SDL would always use OpenGL (rather than OpenGL ES). The second, I had to explicitly say what OpenGL ES version to use (&#8220;SDL\_GL\_SetAttribute(SDL\_GL\_CONTEXT\_MAJOR\_VERSION, 1);&#8221;). The third, I had to disable writing to the Alpha channel (&#8220;glColorMask(GL\_TRUE, GL\_TRUE, GL\_TRUE, GL\_FALSE);&#8221;), as that was conflicting with a feature on WebOS that lets you composite OpenGL on top of video&#8230; pretty cool. And really, beyond configuring my makefile correctly, that was it.

There&#8217;s still a bunch of platform specifics I need to walk through, but the majority of important stuff is in and working. This weekend I&#8217;m busy (running [Ludum Dare](http://www.ludumdare.com)), but I&#8217;m hoping to package this port up and send it off next week.

**Android**, well until Google [stops hating Canada](http://market.android.com/publish/Home), that&#8217;s not going to happen yet. (i.e. Canadians can&#8217;t create Google Checkout Merchant accounts). I have a G1, a Nexus One, and a Tegra board, but they&#8217;re all just gathering dust. Previously I had the game code compiling, but I still need to set up the dummy Java app.

**Mystery platform**, the game code compiles, but I still need to port my graphics library (it&#8217;s all just stubs). Some dramatic changes are needed to finish it, so it&#8217;s likely easier ports will come first.

**Moblin**, that should be soon. I ran in to &#8220;THE&#8221; bug with SDL_Mixer on my Windows build, so I need to either fix it, report it properly (ugh), or just do an [IrrKlang](http://www.ambiera.com/irrklang/) audio port like [Phil](http://www.galcon.com).

**Bada** and **Maemo**, I&#8217;m still waiting for _motivators_. 😉

That&#8217;s it for porting.

I have a whole bunch of website work that I&#8230; well&#8230; just haven&#8217;t started. Smiles HD needs a website, and for that matter, Smiles for everything needs a more general site. Sykhronics, it still says 2009 on it. I started a new design, but I left it needing some new artwork. And this blog STILL uses a default theme. So yes, while I fail at website progress, other stuff is certainly getting done.

I did some computer maintenance over the last week as well. Installed Windows 7 64bit in anticipation of Adobe CS5 (since nobody wants to support XP64 anymore). I&#8217;ve actually been avoiding the &#8220;Adobe way&#8221; by using Paint Shop Pro instead of PhotoShop and Illustrator. However, Corel kinda ruined the software since it bought Jasc, and hasn&#8217;t released a notable update for 5 years now, so I&#8217;m finally jumping ship. Yes, ready to join the rest of the world the _true_ way of PhotoShop.

Dabbled a bit with the new Blender 2.5, but that&#8217;s going to require a new export plugin. I&#8217;ll be sticking with 2.49 for the new project, or at least until 2.5 matures a bit more.

Doing pre-production for the new project. It&#8217;s something better suited to **mystery platform** than Smiles is. I still want to be well in to production of the vertical slice before I get in to details, so sorry, that means this will continue to be a Smiles and Ludum Dare topical blog for a few more months.

And that&#8217;s all I can think of for this light ranty post.