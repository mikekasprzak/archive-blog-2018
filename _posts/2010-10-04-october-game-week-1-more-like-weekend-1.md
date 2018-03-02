---
id: 3220
title: 'October Game &#8211; Week 1 (more like Weekend 1)'
date: 2010-10-04T00:24:27+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3220
permalink: /2010/10/04/october-game-week-1-more-like-weekend-1/
categories:
  - Ludumdare
  - The October Game
---
I&#8217;ve been doing my daily logs over at the [Ludum Dare site](http://www.ludumdare.com/compo/), to try and encourage more people to participate there. I&#8217;ve really only worked on the game for 2 days, despite my plans to start early. Today I was busy with _something else_, so this week&#8217;s update will be light.

This &#8220;week&#8221; was about getting the foundation of editor up and running. Currently it works on a 2 button mouse (right click to erase), but the editing interface will support a touch screen (tile zero is the eraser). There&#8217;s currently no UI, but I can cycle tiles with the mouse wheel. It auto saves/loads the map to a specific file.

It started out looking like this:

[<img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame03-550x338.png" alt="I don&#039;t know what it is, but in tile editors I always want to draw H&#039;s" title="PoVGame03" width="550" height="338" class="size-large wp-image-27969" />](http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame03.png)

Then by the end of the night Saturday, it looked like this:

[<img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame07-550x319.png" alt="Dirt Fortress" title="PoVGame07" width="550" height="319" class="size-large wp-image-27992" />](http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame07.png)

If you&#8217;re interested at all in the process from A to B, hit the jump for more.

I _was_ going to do some work today (Sunday), but there&#8217;s so little time left, I&#8217;m calling it a night early.

<!--more-->

## \*\\*\* Day 1 (Friday) \*\**

Well the plan _was_ to get started before October, but due to some big stuff going on, I had to delay my start.

Now, late late night October 1st, I&#8217;ve finally started.

<div id="attachment_27961" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame01.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame01-550x338.png" alt="Red boxes mean I&#039;ve started" title="PoVGame01" width="550" height="338" class="size-large wp-image-27961" /></a>
  
  <p class="wp-caption-text">
    Red boxes mean I've started
  </p>
</div>

Building an editing interface, which you can see the foundation of in the shot above. The terrain renderer has nothing to do with what I&#8217;m doing, aside from verifying mixing my 2D and 3D code works. I don&#8217;t have any immediate plans to use any 3D content, but it might be cool for effects. We shall see.

Planning to do another hour or so of work, then sleep.

## One Hour Later

Alright, it doesn&#8217;t look any different, but I made my editing a little more useful. Right click acts as an &#8220;erase&#8221; hotkey. Wow &#8216;eh?

As it turns out, my cross platform framework didn&#8217;t support multiple mouse buttons (it only supported 1 button). So I had to figure out why other buttons weren&#8217;t working. Added multiple button support, then found it wasn&#8217;t working (wuh!?). After some digging, it seems SDL button 1 is left click and 3 is right click (making 2 middle); I made the mistake of thinking right click would be 2. Oops!

So, be impressed! My crazy cross platform framework that builds for a dozen or so platforms now supports multiple mouse buttons!

&#8230; not impressed? Ah well.

<div id="attachment_27963" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame02.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame02-550x338.png" alt="Deja vu..." title="PoVGame02" width="550" height="338" class="size-large wp-image-27963" /></a>
  
  <p class="wp-caption-text">
    Deja vu...
  </p>
</div>

I wouldn&#8217;t normally make a post in the same post, but so little has changed that I am. I&#8217;ll be removing the terrain renderer now, so really, I just wanted to take at least 1 more pic of that. 😉

<div id="attachment_27969" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame03.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame03-550x338.png" alt="I don&#039;t know what it is, but in tile editors I always want to draw H&#039;s" title="PoVGame03" width="550" height="338" class="size-large wp-image-27969" /></a>
  
  <p class="wp-caption-text">
    I don't know what it is, but in tile editors I always want to draw H's
  </p>
</div>

That&#8217;s probably it for tonight. Tomorrow I need to make a texture atlas of tile properties, and overlay those instead of my red boxes. Mike, you better do this within a few hours of waking up&#8230; otherwise I&#8217;ll yell at you!

## \*\\*\* Day 2 (Saturday) \*\**

I need tools to make my game, so we&#8217;re making tools.

That texture atlas I quipped about yesterday now exists.

<div id="attachment_27973" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame04.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame04-550x340.png" alt="Solid, In-front, Ladder, ?, Density/stickyness (x4), Top collision" title="PoVGame04" width="550" height="340" class="size-large wp-image-27973" /></a>
  
  <p class="wp-caption-text">
    Solid, In-front, Ladder, ?, Density/stickyness (x4), Top collision
  </p>
</div>

Now to actually draw these icons on tiles to show their material properties.

## Several Hours Later

Tile properties are now displaying.

<div id="attachment_27987" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame05.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame05-550x338.png" alt="A solid climb around a weird room" title="PoVGame05" width="550" height="338" class="size-large wp-image-27987" /></a>
  
  <p class="wp-caption-text">
    A solid climb around a weird room
  </p>
</div>

I&#8217;m not sure what comes next.

## Hey&#8230; I know how to make it look cooler&#8230;

Yeah, here&#8217;s an idea.

<div id="attachment_27989" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame06.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame06-550x340.png" alt="Perspective == Advanced!" title="PoVGame06" width="550" height="340" class="size-large wp-image-27989" /></a>
  
  <p class="wp-caption-text">
    Perspective == Advanced!
  </p>
</div>

Whoo!

## Some 4 hours later

After having cook a fancy meal (Tacos), I now have textures working!

<div id="attachment_27992" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame07.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame07-550x319.png" alt="Dirt Fortress" title="PoVGame07" width="550" height="319" class="size-large wp-image-27992" /></a>
  
  <p class="wp-caption-text">
    Dirt Fortress
  </p>
</div>

But as you can see, I don&#8217;t have any textures yet. Still, I can now assign them to tiles, and index in to a texture Atlas. Whee.

## Even more hours later&#8230; 4:30 AM

Yes many hours have passed, but a major incremental milestone has been hit: Saving and Loading maps.

<div id="attachment_28015" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame08.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame08-550x321.png" alt="All developers should have a 5x3 font memorized" title="PoVGame08" width="550" height="321" class="size-large wp-image-28015" /></a>
  
  <p class="wp-caption-text">
    All developers should have a 5x3 font memorized
  </p>
</div>

Between all kinds of &#8220;I&#8217;m tired&#8221; slacking, I finally got this done. It&#8217;s using my chunked file format used by my Smiles UI code. Hooray for re-use!

This is definitely it for the night. I have no idea where I&#8217;ll pick up tomorrow&#8230; I don&#8217;t even want to think about it. Brain is mush, proceed to bed. Do not pass go. Do not collect $200.