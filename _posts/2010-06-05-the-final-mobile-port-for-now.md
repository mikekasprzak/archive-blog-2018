---
id: 2794
title: The final mobile port (for now)
date: 2010-06-05T01:22:03+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2794
permalink: /2010/06/05/the-final-mobile-port-for-now/
categories:
  - Alone, The
  - Smiles
  - Technobabble
---
I actually finished on Sunday, but the _final_ mobile port of Smiles is now sent. The port is for Samsung&#8217;s Bada mobile platform. I was pleasantly surprised how straight forward it was to get things up and running there. The system API is very much like a C++ version of Apple&#8217;s ObjC iPhoneOS API. The whole endeavor took no more than 4 days worth of work.

<div id="attachment_2798" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/06/BadaSmiles.jpg"><img src="/wp-content/uploads/2010/06/BadaSmiles-640x330.jpg" alt="" title="BadaSmiles" width="640" height="330" class="size-large wp-image-2798" srcset="http://blog.toonormal.com/wp-content/uploads/2010/06/BadaSmiles-640x330.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/06/BadaSmiles-450x232.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2010/06/BadaSmiles.jpg 1200w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Running in the simulator
  </p>
</div>

So done!

I will continue to support the existing plethora of ports as needed, but now it&#8217;s time to switch gears, and get going on the **new project**!

In fact, I&#8217;ve already started digging through and refactoring my code, doing all kinds of note-taking and what have you. The reason I didn&#8217;t send the Bada port right away was because I wanted to get started. 😀

Deciding what sort of project to do next is always tricky. Like any designer worth his weight, I have several ideas in the back of my mind, each with its own rationale why I should do this as opposed to another. I tend to classify projects by their needs, unknowns, how long they should take, and how much I actually want to make them. Some ideas are potentially as short as a month, others a lot longer.

I could go on and on about the decision making process, but I&#8217;ll save us both the writing and reading effort here.

**I will be making a bigger game next, not a quickie mobile game.**

I haven&#8217;t _got rich_ with Smiles, but I am satisfied with its success. For a while I was concerned that I&#8217;d need to throw together a quickie mobile game just to inch me in to a more comfortable earnings bracket. But the recent iPad featuring of Smiles HD, and a bunch of recent news about Intel&#8217;s AppUp finally launching on devices, it was enough for me to say &#8220;okay, I think the ports will support me just fine&#8221;. This past month was good. I doubt it&#8217;ll be this good again next month, but a little fear is a good motivator too. 🙂

I&#8217;ve set myself up well. iPhone, iPad, Windows and Linux Netbook PCs, Palm Pre, Nokia N900, and Samsung Wave (Bada). And if any new opportunities come up, I&#8217;m ready to go with any new device featuring OpenGL ES 1.1 or 2.0. Plus, the past few devices have taken me less than a week to finish each. Now that&#8217;s more like it. 

And while it would be great to utilize this for making a quick game and bringing it to A LOT of platforms at once, it&#8217;ll add a whole other product for me to support, delaying my big game even more. No, lets not do that.

It is time to get started on **it**.

It&#8217;s weird being &#8220;the Smiles guy&#8221; or &#8220;the Car guy&#8221; in conversations with my colleagues. Don&#8217;t get me wrong, being &#8220;the Car guy&#8221; is totally awesome, but that&#8217;s a label that impresses only the first 2 times it comes up. It justifies Smiles and the porting frenzy, but by the time GDC rolls around next year, it&#8217;ll be old news. Smiles is nearly 2 years old now. Released some 19 months ago, but I started development 4 month prior in July. There&#8217;s not much more to prove here.

If we were to delve in to character flaws, one of mine might be that I&#8217;m overly conscious of self image. I&#8217;ve worked on a lot of games, but I&#8217;ve yet to work on something I think really qualifies my interest in games. Why did I become a game developer? I was a fanatical game making nerd growing up, so I have this picture/feeling/mood in my mind of what a game should be (i.e. &#8220;the awesome&#8221;). But my entire portfolio of games from the past 10 years is all kid (girl) games and casual games. Given the conditions I am proud of what we made. But to me the game nerd, the games that I&#8217;ve developed are what define me. They&#8217;re not bad games to have associated with me, but if that kid who wanted to be me did the math, he would **_not_** be impressed.

I turn 30 in a month (July). It&#8217;s time to start the next decade.

## What I&#8217;m working on now

To start, I&#8217;ve been refactoring my code. I now have (including unreleased) 17 supported platforms in my code base, which is A LOT! So now that I have implemented this many _real world_ targets, I can look at what&#8217;s worked or what hasn&#8217;t structurally. And it&#8217;s not that it hasn&#8217;t worked, but I can take this opportunity to make changes.

Compiling a Smiles target requires specifying several code folders (src/Game, src/OpenGL1, src/SDLMain, &#8230;), and #defining several macros that describe the platform (USES\_OPENGLES, USES\_UNIX, etc). This is fine, but I&#8217;ve come to the opinion that it&#8217;s easier to find (for example) the sound code for Platform X under Audio/PlatformX, than it is to find it under PlatformX/Audio. Every platform needs to share a common interface, otherwise it wouldn&#8217;t really be that portable.

So I will be (have been) moving a bunch of all-over-the-place code to where they make sense. That then means a whole bunch of specific define checks like &#8220;#ifdef USES\_UNIX\_TIMER&#8221; at the top of the platform specific files. But hey, that&#8217;s fine. Being able to actually find the code is totally worth a little scoping messyness.

## What about _Mystery Platform?_

That&#8217;s coming too. The Smiles for **_Mystery Platform_** port I&#8217;ve decided to do over the summer, since I want the new game to also run on _**Mystery Platform**_ (at least!). So rather than hack 1 more platform in to the code base (well actually, it&#8217;s already there and compiling), I&#8217;ve decided to tackle my refactoring plans now.

The other thing, much of the TODO list for this Smiles port meshes with my TODO list for the new game. So since I need a break from Smiles anyways, my thought is to start the new game **RIGHT NOW**, and by the time my needs are met by my library and tool changes, spend a week or two crunching the port together.

And yet another thing, Smiles makes a **REALLY GOOD** guinea-pig. Like really, it&#8217;s a fully functional complete working game. What better way to test a code base than with a fully working game?

## What&#8217;s next?

Tools. Lots of tools.

Contrary to my usual indie wisdom &#8220;make games without content&#8221;, I will be making a game with content. Lots of content! But the trick to content is it needs to be very fast to create, and to test. So I&#8217;ll be spending a lot of my time over the next few months building what I need, to make the game I want.

I&#8217;m sure I&#8217;ll do another rant eventually about doing a game you (I) want to create, as opposed to one the &#8220;market&#8221; wants. But for now, tools.

## Where are we going?

By the end of the summer I hope to have:

&#8211; Smiles for **_Mystery Platform_** finished and submitted.
  
&#8211; Tools for new game up and running, in use, and already producing content.
  
&#8211; To have run an awesome Ludum Dare (LD18 coming in August!) 😉

Like many people, I&#8217;m aiming to have something ready for IGF time. I&#8217;m confident in the concept, but there&#8217;s a lot of work ahead of me to get there. Lots of research, lots of things to make, but man, I&#8217;m soooo excited to be working on it! FINALLY! WOO!