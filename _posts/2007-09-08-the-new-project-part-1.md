---
id: 219
title: 'The &#8220;New&#8221; Project, Part 1'
date: 2007-09-08T05:47:31+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2007/09/08/the-new-project-part-1/
permalink: /2007/09/08/the-new-project-part-1/
categories:
  - PuffBOMB
  - Stuffing
  - The Spider
  - Video
---
Before starting work on &#8220;The Spider&#8221;, I was building the engine for the &#8220;new PuffBOMB&#8221;. The concept behind the engine, 2D characters and physics, 3D backgrounds styled to look 2D, HD ready. Pretty standard stuff.

The concept behind &#8220;The Spider&#8221; is, unlike a normal platformer where you stand on the ground, this one you wouldn&#8217;t. Instead you would hang from and move along ceilings. The best idea I had at the time for pulling it off was something I nicknamed &#8220;double ropes&#8221;, one to support, and one for action.

Eventually over the course of new PuffBOMB&#8217;s engine development, it seemed like a good idea to try a squishy ball thing, Gish like. A dense circular shaped thing supported by springs. No problem.

![Roll ball roll love hole... ?](/content/engine03.gif)

These ball things were really cool. Moving them was a simple matter of applying tangential motion to all the points making it spin, and so long as friction did something, they could move along a surface. Very cool.

I suppose it&#8217;s of note that I did my collision slightly differently than Gish/Loco Roco, placing spheres on the end of each point. I&#8217;m not sure if the method is functionally any better, but in &#8220;spring display off&#8221; mode with collision display on, I get [spirographs](http://en.wikipedia.org/wiki/Spirograph).  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

![Purty](/content/engine07.gif)

In continuing with &#8220;neat things to try&#8221;, I wanted to give ropes a try.

![I'm stuck!](/content/engine04.gif)

Here you can see a &#8220;ball thing&#8221; tethered with several points along a rope. Initially to get it working, I simply locked the end point to the scene, so this rope was more like a bungee rope than an umi rope.

This is about when I came to the conclusion that, hey, I should do _this_ game instead. I was convinced PuffBOMB couldn&#8217;t work well on a gamepad. But aiming with an analogue stick, and pressing a button to fire a rope, that was _way_ more gamepad friendly.

So a big number of things happen at this time. I get Richard involved, building tools to produce game content, and generally work with me on the game. The design evolves from &#8220;hanging spider&#8221;, to tentacle goo ball alien. I would eventually hacked in a method of firing ropes, adding a spring between the character and the point hit on the contact.

But before we get to far, while writing that original &#8220;And the Project&#8221; series, I recorded a gameplay video. I decided to sit on it until things were further along with the game. Well, now is as good enough a time to show what it was all about. 

&#8220;The Spider&#8221;, February 2006.
  

  
<font size="-2">(Click the last button on the top for fullscreen, 2nd last to toggle scaling)</font>

Here you can see Richard&#8217;s lovely test level, impaled Blender monkey head and all.

At the time I thought we were doing something pretty cool. The scenery would be built in 3D in Blender, and be arranged in such a way that parts of it crossed a &#8220;plane&#8221; conveniently assumed to be placed on the origin. I&#8217;d then slice all the 3D geometry crossing this plane, and generate 2D collision polygons for the physics to use. Technically cool, but this eventually turned in to quite a headache.

You also get to see my other mechanic that I thought was pretty clever. **Expanding**. Pressing a button toggles between being normal to doubling your size. What I really found fascinating about it was how multipurpose this mechanic was. You can use it to jump, to push things, or even to attack.

So now that we had some cool gameplay work with, it was up to me to make the game look cool. How the whole art thing went, next time.