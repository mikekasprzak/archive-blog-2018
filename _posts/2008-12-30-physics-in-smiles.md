---
id: 365
title: Physics in Smiles
date: 2008-12-30T21:17:37+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=365
permalink: /2008/12/30/physics-in-smiles/
categories:
  - Smiles
  - Technobabble
  - Video
---
At first glance you wouldn&#8217;t think a matching game like **Smiles** would feature physics, but it does. In several places actually.

The most obvious example is the particle effects.

![](http://www.smiles-game.com/press/Shot01.png)

Particles were used when ice and rocks break, and also for the tile clearing effect. The tile would be erased instantly from the board, and a particle would be created in it&#8217;s place. The particle would zoom in, slow down, then zoom out with a twist. This was achieved entirely with initial settings upon creation of the particle.

You can see this in action in the video below.

The particle system has was what I like to refer to as a Position+=Velocity+=Acceleration+=Drift simulation. Each of the 4 components adds itself to the prior one as the integration step (except Position). Since a particle lives for only so long, Acceleration and Drift are often enough to control where the particle goes. Acceleration will push an upward Velocity down (gravity), where Drift gives you the freedom to pull it left to right, or pulse it back to where it came from (faking combustion nuances).

The simulation also supported a number of other stepping factors. Animation rate change, color/opacity change (allow values greater/less than 0 and 1, but clamp them as used), size and rotation. An Acceleration is usually paired up with a Drift for all these too.

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

The next simulation I want to talk about is the block falling/squishing one in **Drop**.

<center>
</center>

Every tile in **Smiles** is made up of 2 particles (the center and the distorter), a spring, and a floor constraint. It&#8217;s a verlet style integrator (Position and Old_Position).

Each tile is a self contained simulation. Behind the scenes the tiles fall instantly, but their physical position is remembered. Once all the clearing effects and the floater timer finishes, the simulation begins. Each tile is given a slight bump upward, and gravity pulls them downward until they impact the ground.

The first particle (the center) is the only one actually affected by gravity. The 2nd particle&#8217;s job (the distorter) is to follow the first particle (the center). The spring pulls it along. The distance between the two is used as a distortion scalar. It&#8217;s plugged in to a matrix that is used to squash or stretch the graphic.

The game also features automatic tips and blinking. To help make a tile stand out, the length of the spring it changed/pulsed between a few values. This in turn causes the 2nd particle (the distorter) to chase after the real position it should be at, and the distortion scalar changes appropriately.

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

Finally, the last simulation I want to talk about is the &#8220;water&#8221; simulation in **Zen**.

<center>
</center>

This simulation was mathematically cool since it was 1 dimensional. A Position value that tried to become zero (the spring), with an Old\_Position that made sure it bounced around a bit (velocity, and a scalar that eventually reduces velocity to nothing). Getting a tile to jump around was a matter of setting the Old\_Position (velocity).

To create the ripple effect, each tile looked at it&#8217;s neighbors Positions. The difference between positions would be taken, scaled down, and subtracted from us (so that we follow our freaking out neighbors).

This one was eventually toned down, since it made even me queasy watching it. 😀

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

And that about covers the physics in Smiles. There were other physics-like behavior found in the game, but they were done with tables. 20-40 values showing gradual acceleration, deceleration, pushing too far, etc. Menu&#8217;s used this, swapping used this (scale), and holding your finger down and scribbling shows it in action. I thought I had a video, but it seems I don&#8217;t. Ah well. 🙂