---
id: 213
title: 'Engines, Names and Evolution &#8211; Part 1'
date: 2008-03-01T15:51:42+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2008/03/01/engines-names-and-evolution-part-1/
permalink: /2008/03/01/engines-names-and-evolution-part-1/
categories:
  - PuffBOMB
  - Technobabble
  - Zooble
---
Over the years, I&#8217;ve given names to game engines I&#8217;ve worked on. Most of my professional experience has been working on platformers and mini-game collections. Mini-games rarely share much in common, so by engines I&#8217;m referring to platformers, or engines for games very much like platformers. 

I&#8217;d like to start talking about what I&#8217;ve been thinking about whilst designing my next engine. I need to set some context though, so I&#8217;ll be walking through some of more significant engines I&#8217;ve worked on. 

Going way back, I really didn&#8217;t start naming my engines until after **Secret Agent Barbie** (Gameboy Advance). I did name my GCC driven Gameboy Advance tool-chain &#8220;**ATK**&#8221; for Advance Toolkit, but my priorities eventually changed. As a team we used the interal code name of &#8220;**Bond**&#8220;, but I&#8217;m sure that was just us wishing we were doing a James Bond game instead.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

&#8220;**Bond**&#8220;, like each of my platformer engines before it, was a &#8220;**Megaman Physics**&#8221; engine. **Megaman Physics** are what I call platformers that solve moving characters against static scenery, but do something artificial to solve object vs. object collisions. Pretty much every 2D Megaman games sets you to an injured state and gives you a brief constant velocity opposite your facing direction, followed by temporary invincibility. That meant you could walk right through the enemies after that brief interruption. In retrospect, I&#8217;ve started to think **Megaman Physics** might be superior for playability, but that&#8217;s a topic in itself.

Before I left DICE, I was working on a project with a coworker that we referred to as &#8220;**Brown Box**&#8220;. The name was a play on the idea of a [black box](http://en.wikipedia.org/wiki/Black_box), with a cynical inside joke a handful of us had. The essense of the joke was, if you came in one day and found a brown cardboard box on your desk, you were fired. Pleasant.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

**Brown Box** was a 3D R&D project. On my own time, I was working on some 2D physics experiments. My early efforts became the **[Zooble](http://www.sykhronics.com/zooble/)** prototype (with it&#8217;s very wrong physics), a verlet testbed **Phiz**, and a series of further physics experiments adopting such strange names as **Popcorn**, **Cactus**, and **Canadianese Simulator**.

<center>
  <img src="/content/phiz.png" alt="Phiz" /><br /> <strong>Phiz</strong>, where my verlet fascination began
</center>

<center>
  <img src="/content/canadasim.png" alt="Canadianese Simulator" /><br /> <strong>Canadianese Simulator</strong>&#8230; isn&#8217;t it obvious&#8230; they&#8217;re red.
</center>

**Destructure** was conceived as my &#8220;Post DICE&#8221; engine effort. The name was chosen &#8217;cause it sounded cool. I left in June 2004, just over a year after making the original **[PuffBOMB](http://www.puffbomb.com/)** prototype. I left with the intention of building an engine for the **PuffBOMB** remake (and other projects), and eventually to help out a friend at his new company. I left as quickly as was appropriate, hoping to get a couple months of work on **Destructure** in. Alas, all I had time for was a couple weeks of R&R, and to _start_ a compo game before I was called upon. 

**Destructure** eventually became the engine for **Atomic Betty** (Gameboy Advance). I was well versed in classic and verlet physics at this point, and was using that experience to build a low spec cross platform game/physics engine. Beefy goals as usual. We landed the Atomic Betty project, so I re-purposed my design to suit the game. A fun aspect of **Destructure** is it, for a while at least, it compiled both on the PC (with Allegro) and for the Gameboy Advance. As the project kicked off, the GBA specific code grew so fast, it wasn&#8217;t practical (or necessary) to concurrently develop.

<center>
  <img src="/content/destructure.png" alt="Destructure" /><br /> Early PC version of <strong>Destructure</strong>. Red boxes are the overlap.
</center>

Some technical notes. Objects in **Destructure** used circles and axis aligned rectangles for collision, though **Atomic Betty** only used the rectangles. Objects were moved and solved with a bare bones verlet/relaxation solver. The rectangles were actually the 2 corner points, with a pair of verlet spring constraints (width and height) keeping it from collapsing in on itself. No square roots required  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />. Solving two rectangles was rather novel. I took the overlap/union rectangle of the two, and used it&#8217;s shape to determine how to solve. If the overlap was wider than tall, I&#8217;d push them each half the height up/down out of each other, and vice versa. Unlike moving a center point, this actually squished the rectangles. Then the next frame, the springs restored it&#8217;s size to normal.

The next engine&#8217;s name and story is a little complicated, so we&#8217;ll save that for next time.