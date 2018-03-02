---
id: 285
title: And the Project, Part 2
date: 2006-02-05T15:51:11+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=91
permalink: /2006/02/05/and-the-project-part-2/
categories:
  - PuffBOMB
  - The Spider
---
And now, part 2. This part I&#8217;ll call&#8230;

## Spiderphobia

###### (versus the more correct Arachnophobia. Correctness is wrong)

Spiders, spiders, and more spiders. So the game concept I decided to toy with is one I like to call &#8220;The Spider&#8221;. The concept itself is most similar to the rope platformer [Umihara](http://en.wikipedia.org/wiki/Umihara_Kawase) [Kawase](http://en.wikipedia.org/wiki/Umihara_Kawase_Syun), a slick game a former employee introduced me to (thanks Gary). In indie land, the closest similar game to that would be [Wik](http://www.wikgame.com). Unlike these games, &#8220;The Spider&#8221; concept is one more about staying elevated, and not touching the ground. With that, you move around in the game with multiple ropes.

So with that in mind, I started hacking together a control prototype with the new PuffBOMB engine, and some interesting things came out of it.

<center>
  <img src='/content/engine03.gif' alt='Round and Experimentation' />
</center>

At first I started experimenting with having the scenery act extremely sticky, and created a dense several sphere surrounded sphere character. Dropping them on a sloped surface, despite it&#8217;s stickyness, made these nice squishy objects that rolled smoothly down hills. Gish like, almost. Then within a couple minutes of work, I made this in to a control scheme.

At this point, I brought my brother on to the project. For him, he was looking for a job, and I was realizing that I was going to need help to get this project done any time soon. So after some discussion and fast food bribery, I had myself an assistant.

The game&#8217;s rendering code at this time was using plain old 2D Allegro, and with enough objects being drawn at the same time, it was starting to show. So our first order of business was to port the graphics code over to AllegroGL (OpenGL, with Allegro handling input, audio, and all non graphic things). After that was out of the way, Richard was on the task of setting things up so we could build static level content in [Blender](http://www.blender.org). So, an exporter and bare bones renderer later, we had 3D scenery in a 2D game.

<center>
  <img src='/content/engine04.gif' alt='Early 3D Scenery, and rope work' />
</center>

I continued with some rope experiments. The first being an awful stick to an old position scheme. As a useful game mechanic, not a chance. The only plus about this one was it could nicely show off wrapping ropes around scenery, by sticking yourself and walking off an edge.

The next variation was the more expected and actually decent one, ballistics. Aim and shoot. A shot flies out, and sticks to the scenery. Nice.

<center>
  <img src='/content/engine05.gif' alt='Evolved Rope Action' />
</center>

With this in there, things controlled great. With an analog stick to aim, things flowed. And with two ropes to support you, you could make some really fantastic and smooth moves around a map.

<center>
  <img src='/content/engine06.gif' alt='Two are better than One' />
</center>

So yes, ropes are a go. At this point, the game seems to move and flow like a Wik with two tongues. Being a bit of an artist, my next big concern was how the character would look.

Artistically, and given how I&#8217;d like it to control, the spider as a character has it&#8217;s problems. So, after a short debate, the spider game character was ditched. However, since the control scheme it still vaguely spider like, we&#8217;ve kept &#8220;The Spider&#8221; name as our working title, until we have a final name. Now, what the character has become&#8230; in part 3.