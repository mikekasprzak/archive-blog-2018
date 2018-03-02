---
id: 211
title: 'Engines, Names and Evolution &#8211; Part 3'
date: 2008-03-04T03:08:01+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2008/03/04/engines-names-and-evolution-part-3/
permalink: /2008/03/04/engines-names-and-evolution-part-3/
categories:
  - Ballistic Force
  - PuffBOMB
  - Technobabble
  - The Spider
---
**Ballistic Force** wasn&#8217;t a long project, but development was dense.

Early on, I attempted a poorly conceived idea of creating densely constructed particle landscape. I wanted a system sort of like molecular/planetary attraction to keep scenery together, and allow clumping like a cartoon snowball rolling down a hill. It might have worked on something highly parallel like a GPU or the PS3&#8217;s SPE&#8217;s, but my design really wasn&#8217;t well thought out. The prototype ran at less than 1 FPS, with a map that only covered a fraction of a screen.

The attraction didn&#8217;t work as expected either. A rather simple castle tower had a hard time staying together, tearing due to numeric instability. Interesting, but no good.

<center>
  <img src="/content/bftower.png" alt="Ballistic Force Tower" /><br /> <strong>Ballistic Force</strong> dense particle landscape, cracking
</center>

**Ballistic Force** &#8220;take 2&#8243; was the **Freedom** engine again, but the plan was to carve in to polygon scenery. I was already generating 2D collision from 3D geometry, so _in theory_ it didn&#8217;t seem unreasonable. Having just come off the particle landscape stuff, I decided my time was better spent diving in to the mechanics without destructible scenery. To start, that meant building a vehicle.

In the early experimentation, I built a tank-car using my equivalent of &#8220;Gishes&#8221; for tires.

<center>
  <img src="/content/bfedit2.png" alt="Ballistic Force" /><br /> <strong>Ballistic Force</strong> &#8211; Constructing the Tank-car
</center>

But like other rolling things, it had a hard time sitting on a sloped surface. Not to mention, it wasn&#8217;t pretty.

<center>
  <img src="/content/bftank3.png" alt="Ballistic Force" /><br /> <strong>Ballistic Force</strong> &#8211; Rule #1 of Tank Club is to not talk about Tank-Car.
</center>

So attempt #2, the blue tank.

<center>
  <img src="/content/bfedit.png" alt="Ballistic Force" /><br /> <strong>Ballistic Force</strong> &#8211; Constructing the better Tank
</center>

Better, but it&#8217;s obvious I wasn&#8217;t too good at texturing.

So I continued working on the mechanics. Making the tank aim and fire, adding a chase camera, and some mechanisms for righting yourself when you fall over.

<center>
  <img src="/content/bftank1.png" alt="Ballistic Force" /><br /> <strong>Ballistic Force</strong> &#8211; Tank firing, muzzle flash
</center>

<center>
  <img src="/content/bftank2.png" alt="Ballistic Force" /><br /> <strong>Ballistic Force</strong> &#8211; Genius shot himself
</center>

There was a real urgency to get something together sooner than later. This was in May of 2006. Now is not a good time to get in to the details, but it was the first time things got serious.

Art was a big concern. I wasn&#8217;t happy with my results, and we weren&#8217;t really confident enough in our tools to hire an external artist to work with them. 2D modeling, while similar to 3D modeling, is a niche if I&#8217;ve ever heard of one. My &#8220;bone like&#8221; system is tricky to work with as well, even we didn&#8217;t have it completely figured out. 

The other problem is we didn&#8217;t have a clear idea of what art we needed. The tank was only moderately playable, and the game concept was rather vague. Future work would easily break any art produced now. We can&#8217;t really afford to have an artist come in, hang out, and create assets that&#8217;ll just be thrown away.

We wanted quick results, but it became clear with so many unknowns, this project wasn&#8217;t going to come together quickly.

&#8211; &#8211; &#8211; &#8211; &#8211;

Some technical notes on **Freedom**.

Collision geometry in **Freedom** were either collections of circles/spheres connected by springs (&#8221;sphere clusters&#8221;), or nodes held together structurally by springs that enclosed a convex polygon collision volume.

Verlet/relaxation solver. 

The polygons didn&#8217;t work right, since I hadn&#8217;t figured out how the general separating-axis test worked. I was aware of it and it&#8217;s power, but how it just hadn&#8217;t clicked yet. As a result, all moving objects were &#8220;sphere clusters&#8221;.

Scenery collision was static triangles, axis aligned rectangles, and convex polygons. Eventually we added the ability to import a 3D model, and slice it with a plane to generate 2D collision polygons.

There was a loose system kinda like bones. You could weigh vertices of the display mesh to any 2 nodes of the collision mesh. It proved great for making static squish-able things, but our tools weren&#8217;t well set up for anything beyond that.

&#8211; &#8211; &#8211; &#8211; &#8211;

So when the **Ballistic Force** debacle calmed down, it was clear we should be making a game with manageable and clear content goals. So **PuffBOMB** was back on the agenda. With **PuffBOMB** we had the prototypes, and years of my collected notes and sketches to pull from.

However, **Freedom** wasn&#8217;t suitable for **PuffBOMB**. Not yet.

To start, it didn&#8217;t support animation. In fact, we were motivated to try alternative projects other than **PuffBOMB** because **Freedom** lacked animation.

While we were figuring out what else we needed, it sounded like a good idea to support collision animation. That&#8217;s not bones, that&#8217;s physically interpolated and re-orientable invisible collision geometry. Oh boy! In theory it could have made it possible to create motions and animations like bones would, but it wasn&#8217;t going to be as nice an IK system. Not to mention a whole slew of other issues brought on from dynamic collision, but that&#8217;s a topic all in itself.

I also wanted the ability to build maps by stamping (tiling) 3D geometry in to a scene. This was related to a problem where I didn&#8217;t trust my convex polygon generation code. I always suspected my triangulator was fine, but some shapes just didn&#8217;t optimize and generate correctly. So this was a double excuse to dig further in to this code and solve it on a smaller scale.

There were many more things the engine didn&#8217;t do, and things I wanted it to do differently. This was a serious overhaul. The foundation had to be rewritten, and significantly reorganized.

It was time for a new engine, and a new name.