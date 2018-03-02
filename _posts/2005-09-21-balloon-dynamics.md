---
id: 310
title: Balloon Dynamics
date: 2005-09-21T15:57:50+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=46
permalink: /2005/09/21/balloon-dynamics/
categories:
  - Scribbles
  - Technobabble
---
<img src='/content/balloonbird.gif' alt='Mmm... Reeedddd...' align="right" />Alright, this was inspired from a game idea I had a few years ago. In the midst of working on my new physics engine, I&#8217;ve decided to revisit the idea and noticed an oddity in my design. Balloons.

Balloons are interesting. Unlike most objects in a game situation, they have this odd property of opposing gravity and going up. With that alone, we can do a convincing simulation in a game by consistently giving it an upward force larger than gravity. And that&#8217;s good enough for a game.

To get more complex, lets talk real life. Now, in real life, a balloon filled with helium floats. Eventually though, it starts to droop, and slowly deflate. So, I&#8217;m sitting here thinking about physically modeling balloons, and all of a sudden I&#8217;m drawing a blank. Why the heck do they do that?

Aha, well if it ain&#8217;t our friend fluid dynamics. The dang real world makes it really easy to forget that oxygen is fluidic, just in a tad more gaseous state than water. It ends up helium is lighter than oxygen, and a balloon&#8217;s lift is a result of the molecules fighting to balance themselves. You see the same thing with a flotation device on water. Oxygen is lighter than water, so it does its darnest not to sink.

As for why it wears off and droops, well it seems the rubber balloons are made of is only so strong of a material. At the microscopic level, the fibres make up the shell of the balloon are tight enough to withstand the oxygen and helium pressure, but not necessarily tight enough to keep all the hydrogen in, and all the oxygen out.

Not to mention&#8230; well&#8230; that knot you tied, \*might\* not be the tightest. I wasn&#8217;t going to say anything. No offense.

Oh, when you look at it that way, it certainly seems like a straightforward phenomenon to simulate. A mere huge count down counter that scales your &#8220;lift&#8221; force does the trick. It could make an interesting subtlety for a game, if put to the extreme. Running to a helium pump to refill it&#8217;s lift capability, and using it before it runs out. There ya go. Minigame. That&#8217;s what I like about learning the subtleties of this math and physics engine crap. Would that idea have been as easy to come to using physics middleware?

Interesting? Fascinating? 10 years ago, in math or science class, I wouldn&#8217;t have cared. However, if it was perhaps put in to context of games, that might have been a different story.