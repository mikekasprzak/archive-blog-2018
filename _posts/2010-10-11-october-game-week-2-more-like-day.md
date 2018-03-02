---
id: 3225
title: 'October Game &#8211; Week 2 (more like day++)'
date: 2010-10-11T00:24:36+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3225
permalink: /2010/10/11/october-game-week-2-more-like-day/
categories:
  - Ludumdare
  - The October Game
---
Busy busy. I didn&#8217;t get to put much time in to the October game this week, but their certainly was progress.

Before:

[<img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame09-550x321.png" alt="Map is getting dizzy" title="PoVGame09" width="550" height="321" class="size-large wp-image-28092" />](http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame09.png)

and after&#8230; some element are mocked up (character and outlining):

[<img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame17-550x321.png" alt="Zoomed in to what I assume will be more what the real zoom will be... will try 1 more." title="PoVGame17" width="550" height="321" class="size-large wp-image-28242" />](http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame17.png)

For the full transformation, hit the jump.

<!--more-->

## Day 3 &#8211; Back in the Saddle

After a few days of other work (Smiles for Windows Phone 7), and [making un-interactive interactive movies with silly internet tools](http://www.xtranormal.com/watch/7296999/), I have finally resumed working on my October game.

For the next while I wont be using perspective, even though it looks fancier.

<div id="attachment_28092" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame09.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame09-550x321.png" alt="Map is getting dizzy" title="PoVGame09" width="550" height="321" class="size-large wp-image-28092" /></a>
  
  <p class="wp-caption-text">
    Map is getting dizzy
  </p>
</div>

What you couldn&#8217;t see before was the room size was actually 32&#215;32 (most of that was cut off). I like squares, but in practice, screens aren&#8217;t square. So the new room size is now 32&#215;24, or in other words 4:3. That&#8217;s sounds like a weird choice given we&#8217;re all about HDTV 16:9 these days, but I actually don&#8217;t intend to show the entire room at once on screen (except when zoomed). I want some scrolling per room, but not much. I haven&#8217;t decided the optimal zoom yet, but it will depend on the target system.

Anyways, though I haven&#8217;t done much work yet, I need to head out to the grocery story while there&#8217;s still light. More progress to come! (Hopefully!)

## Day 4 &#8211; A less lame day (11:30 AM)

I said on my day 3 post that I &#8220;hope I come back and do more work&#8221;&#8230; which I didn&#8217;t.

I got up early today (9 AM&#8230; which should make you wonder when &#8220;normal&#8221; is), and did some work. I&#8217;m ignoring IRC at the moment, so I can make a whole bunch of progress.

<div id="attachment_28176" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame10.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame10-550x321.png" alt="It says &quot;Behind&quot; not Eehind... not that you would have thought otherwise" title="PoVGame10" width="550" height="321" class="size-large wp-image-28176" /></a>
  
  <p class="wp-caption-text">
    It says 'Behind' not Fehind... not that you would have thought otherwise
  </p>
</div>

Been tweaking the code and rough editing interface to support multiple layers and a transformation matrix. Currently it&#8217;s limited to a single room, but neighboring room editing should be soon&#8230; hopefully today.

Back to work.

### More Control (1:30 PM)

Now only displaying the layer info from the current layer.

<div id="attachment_28181" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame11.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame11-550x321.png" alt="You can&#039;t tell, but it&#039;s spinning and doing cool perspective depthy stuff" title="PoVGame11" width="550" height="321" class="size-large wp-image-28181" /></a>
  
  <p class="wp-caption-text">
    You can't tell, but it's spinning and doing cool perspective depthy stuff
  </p>
</div>

<div id="attachment_28183" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame12.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame12-550x321.png" alt="As you change layers, the camera zooms in.  In game will work the same." title="PoVGame12" width="550" height="321" class="size-large wp-image-28183" /></a>
  
  <p class="wp-caption-text">
    As you change layers, the camera zooms in. In game will work the same.
  </p>
</div>

Fun fun.

### Adjacent Room Drawing and Editing (2:30 PM)

<div id="attachment_28187" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame13.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame13-550x321.png" alt="Brown things in the background?  Lets pretend those are some sort of pillar." title="PoVGame13" width="550" height="321" class="size-large wp-image-28187" /></a>
  
  <p class="wp-caption-text">
    Brown things in the background? Lets pretend those are some sort of pillar.
  </p>
</div>

### Camera Panning (7:15 PM)

After a 2 hour walk, dinner, and a some bugfixing (some editor alignment bugs), we now have some very basic Camera panning.

<div id="attachment_28196" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame14.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame14-550x319.png" alt="Two rooms.  The one with the red tile markers is the one we are editing." title="PoVGame14" width="550" height="319" class="size-large wp-image-28196" /></a>
  
  <p class="wp-caption-text">
    Two rooms. The one with the red tile markers is the one we are editing.
  </p>
</div>

Just about done for the night. A little more minor tweaking, then movie time.

### Building maps in all directions (7:40 PM)

I can now build maps in all directions.

<div id="attachment_28199" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame15.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame15-550x321.png" alt="That&#039;s where the staircase goes." title="PoVGame15" width="550" height="321" class="size-large wp-image-28199" /></a>
  
  <p class="wp-caption-text">
    That's where the staircase goes.
  </p>
</div>

There seems to be a crash bug when I go to far (or at least there was earlier). I&#8217;ll tackle that tomorrow.

Overall, a good day.

## Day 5 &#8211; Very Short

Not much to show today. I&#8217;ve been drawing, but I&#8217;m not really satisfied with the results.

What did work out was something I wanted to try: building textures and a texture atlas in Adobe Illustrator. I&#8217;m still new to Illustrator, but I \*LOVE\* the &#8220;Linked Files&#8221; feature (i.e. a reference to other files).

So with a new &#8220;generic grass&#8221;, I did this mockup testing what auto-outline code would look like (showing in front/collision tiles). 

<div id="attachment_28239" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame16.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame16-550x321.png" alt="Mockup.  Character shown roughly at size.  Art from the old stuff.  Will have to redo for readability." title="PoVGame16" width="550" height="321" class="size-large wp-image-28239" /></a>
  
  <p class="wp-caption-text">
    Mockup. Character shown roughly at size. Art from the old stuff. Will have to redo.
  </p>
</div>

I also placed some old character art, just to see. As I can see, I&#8217;ll need to make it more &#8220;super deformed&#8221; so not to lose details.

### Zoomed

Trying out a mockup with more zoom.
  


<div id="attachment_28242" style="max-width: 560px" class="wp-caption aligncenter">
  <a href="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame17.png"><img src="http://www.ludumdare.com/compo/wp-content/uploads/2010/10/PoVGame17-550x321.png" alt="Zoomed in to what I assume will be more what the real zoom will be... will try 1 more." title="PoVGame17" width="550" height="321" class="size-large wp-image-28242" /></a>
  
  <p class="wp-caption-text">
    Zoomed in to more what the real zoom will be.
  </p>
</div>