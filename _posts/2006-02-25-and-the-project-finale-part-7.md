---
id: 279
title: And the Project Finale, Part 7
date: 2006-02-25T23:55:36+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=97
permalink: /2006/02/25/and-the-project-finale-part-7/
categories:
  - PuffBOMB
  - Scribbles
  - The Spider
---
Low fat disposable hats present, part 7:

## A Sunset in Stone

###### Which is probably quite warm, despite the cold imagery of anything in stone&#8230;&#8230; Why are you looking at me like that?

Okay, I wanted an epic name to finish my cheesy little series of updates. Then it&#8217;s **actual updates when they happen!!**! Wow! That actually makes this a blog, instead of story time!

###### But I like story time &#8230;

So back to the technical. Don&#8217;t worry, I&#8217;ll put a stupid image at the end to better transition artfulness to technicallityfullness.

Way back, I mentioned the engine used the monkey of a library AllegroGL, as a wrapper to hardware, and OpenGL. Well, some time in December, we decided we couldn&#8217;t stand the instability of AllegroGL. Yes, AllegroGL, the not so updated piece of honk honk is unstable. I&#8217;m actually impressed the game worked at all. I had to disable deletion and destruction of any GL or related objects so the game wouldn&#8217;t crash on exit, and trust XP to handle all the recovery of memory. It was that bad.

So eventually, on and off busy with _some other obligation_, the code was ported and made a tad more generic as we moved to SDL/OpenGL. Hurah. And an exciting story that was.

And wow, that&#8217;s it? We&#8217;re all caught up!!

Okay, well, I guess we&#8217;ve been building some tools as well. These past few weeks, Richard has been working on the object editor. Collision/Spring placement is all there now, and he&#8217;s started working on our little interface for associating display polygons with these fancy collision thingies we can make.

<center>
  <img src='/content/editor01.gif' alt='I\&#39;m advanced' />
</center>

Sophisticated looking isn&#8217;t it? So, soon we&#8217;ll be playing with and building game content.

Then there&#8217;s me. As mentioned last time, I&#8217;m working on art stuffs at the moment. I gave myself a crash course in [Blender](http://www.blender.org), and I seem to have that reasonably well figured out. Though, I wish the scaling via the normals feature was a tad less destructive. Anyways, prior to that, I&#8217;ve been toying with game mechanics, and fixing stuff to make the editing interface work. One item from the mechanic playing was switching to a segmented rope, instead of just the big spring between point A and point B.

<center>
  <img src='/content/engine08.gif' alt='Subdivided ropes, that suck' />
</center>

Visually it&#8217;s nice, as it&#8217;s all bendy, curvy and swingy. But what you can&#8217;t see in this image, is that compared to the old rope, this one&#8217;s functionality is crap. So, it appears [Umihara Kawase](http://en.wikipedia.org/wiki/Umihara_Kawase) got it right, with the stiff rope that bends only when it crosses collision. Unfortunately that means a bunch more work, making the rope a really special case in the engine&#8217;s design.

There&#8217;s also this \*other\* gameplay element I&#8217;ve been toying with, with some encouraging success. But I&#8217;m going to be an ass, and sit on it for now. I&#8217;ll try not to tease it like it&#8217;s some super clever gameplay element or something. It&#8217;s more of an &#8220;oh! hey cool!&#8221; type mechanic, than a &#8220;Holy shoe!&#8221; type mechanic. That&#8217;s right, shoe.

And there it is. You&#8217;re caught up. I&#8217;m experimenting with art stuffs now, so expect something on that front to pop up. I can&#8217;t vouch for exact days or frequency of updates. Every couple weeks though, there should be something. Or just RSS me, and know. RSS, it&#8217;s an ESP for us non psychics.

And, your wacky image.

<center>
  <img src='/content/tryhate.gif' alt='Have you had your glass of hate this morning?' />
</center>

Have a good week.