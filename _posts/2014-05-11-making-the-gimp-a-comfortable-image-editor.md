---
id: 6905
title: Making The GIMP a comfortable Image Editor
date: 2014-05-11T13:02:36+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6905
permalink: /2014/05/11/making-the-gimp-a-comfortable-image-editor/
categories:
  - Linux
  - Technobabble
---
I&#8217;m a long time [Paint Shop Pro](http://en.wikipedia.org/wiki/PaintShop_Pro) user. I&#8217;ve used it since Paint Shop Pro 3, but I stopped upgrading after Paint Shop Pro 10. Corel acquired it between versions 9 and 10, and after 10 it was never the same. Paint Shop Pro used to be an exciting image editor that uniquely combined Raster and Vector image editor together. The killer feature would have been support for importing and exporting vector artwork as vector files (you could import vector as raster, but not vector), but alas, after the Corel acquisition, vector got ignored (Can&#8217;t compete with Corel Draw after all, that piece of sh**). Paint Shop Pro used to be a serious piece of software with the potential to compete with Photoshop (and Illustrator), but Corel changed its course towards a shovelware Photoshop LE competitor.

Two great art editors I&#8217;ve also used are [Autodesk Sketchbook Pro](http://www.autodesk.com/products/sketchbook-pro/overview) and [Paint Tool Sai](http://www.systemax.jp/en/sai/). Both are wonderful streamlined interfaces for creating art, but are incomplete image editing packages (no font support). Paint Tool Sai is also frighteningly similar to Paint Shop Pro (sans Vector), but a much better painting workflow. Alas, Sketchbook is Windows/Mac only, and Sai Windows only.

A few years ago I started spending some time with Photoshop and Illustrator CS5. Illustrator I love, but Photoshop has always felt clumsy and awkward. So if it&#8217;s going be clumsy and awkward, I may as well be using The GIMP. 😉

It seems The GIMP has made some serious progress over the years. I still have things I hate, but it&#8217;s getting there. Here are some notes to make it good.

## Switch to Single-Window Mode&#8230; NOW!

Ignore everything and immediately click this checkbox.

[<img src="/wp-content/uploads/2014/05/Gimp01.png" alt="Gimp01" width="485" height="189" class="aligncenter size-full wp-image-6909" srcset="/wp-content/uploads/2014/05/Gimp01.png 485w, /wp-content/uploads/2014/05/Gimp01-450x175.png 450w" sizes="(max-width: 485px) 100vw, 485px" />](/wp-content/uploads/2014/05/Gimp01.png)

90% of what you hate about The GIMP is now fixed.

## Set Mouse Wheel Zoom

Go to **Edit -> Preferences -> Input Devices -> Input Controllers (listed)**.

Under **Active Controllers**, click on **Main Mouse Wheel** and then the Gear.

[<img src="/wp-content/uploads/2014/05/Gimp04-640x306.png" alt="Gimp04" width="640" height="306" class="aligncenter size-large wp-image-6920" srcset="/wp-content/uploads/2014/05/Gimp04-640x306.png 640w, /wp-content/uploads/2014/05/Gimp04-450x215.png 450w, /wp-content/uploads/2014/05/Gimp04.png 782w" sizes="(max-width: 640px) 100vw, 640px" />](/wp-content/uploads/2014/05/Gimp04.png)

Click **Scroll Up (should be blank) -> Edit**, then pick **View -> Zoom In**.
  
Click **Scroll Down (should be blank) -> Edit**, then pick **View -> Zoom Out**.

## Default Grids

TODO

## The Pixel Brush

Use the Pencil, Pixel Brush, and a Size of 1.

[<img src="/wp-content/uploads/2014/05/Gimp03.png" alt="Gimp03" width="447" height="407" class="aligncenter size-full wp-image-6918" />](/wp-content/uploads/2014/05/Gimp03.png)

Now on to some things I really don&#8217;t like.

## What&#8217;s wrong with The GIMP (as of 2.8.10)

The **Right Click** button of the mouse is **amazingly useless**. It brings up the Taskbar Menu, but as a Right Click dropdown menu. AFAIC, this is an artifact of Single-Window Mode NOT being the default. 

[<img src="/wp-content/uploads/2014/05/Right_Click.png" alt="Right_Click" width="178" height="251" class="aligncenter size-full wp-image-6938" />](/wp-content/uploads/2014/05/Right_Click.png)

Right Click _should really_ do:

  * Paint with the 2nd Color (if in a paint mode)
  * Deselect a current Selection (if in a selection mode)

This isn&#8217;t hard. It&#8217;s pretty obvious too. You can google many threads of people asking this basic question (how do I right click paint). This really needs to be fixed. 

In the same vein, Wacom pens often have a &#8216;right click&#8217; finger button. This finger button should be a toggle for the 1st and 2nd color. While holding the button, you paint with Color 2, and while released you paint with Color 1. This feels very natural. More editors need to support it.

In general, The GIMP needs to support actually doing stuff with Color 2, beyond just using it as color storage.

\* \* *

Also there&#8217;s an annoying jitter in the Triangle Color Mixer. 

[<img src="/wp-content/uploads/2014/05/Gimp02.png" alt="Gimp02" width="259" height="323" class="aligncenter size-full wp-image-6911" />](/wp-content/uploads/2014/05/Gimp02.png)

I&#8217;m fairly certain somebody is screwing up their Integer to Float conversions when drawing/picking.

\* \* *

**ENTER** needs to act like an accelerator key when in Dialogs.

[<img src="/wp-content/uploads/2014/05/Gimp05.png" alt="Gimp05" width="406" height="408" class="aligncenter size-full wp-image-6924" srcset="/wp-content/uploads/2014/05/Gimp05.png 406w, /wp-content/uploads/2014/05/Gimp05-150x150.png 150w" sizes="(max-width: 406px) 100vw, 406px" />](/wp-content/uploads/2014/05/Gimp05.png)

You&#8217;ll note that &#8220;Scale&#8221; is lit up. As long as I&#8217;m in a text field, it stays that way. I should be able to push **ENTER** right now to accept the settings; Otherwise, why the heck have you wasted my time highlighting Scale?

\* \* *

Editing Brush Size feels clumsy.

[<img src="/wp-content/uploads/2014/05/Gimp06.png" alt="Gimp06" width="204" height="78" class="aligncenter size-full wp-image-6929" />](/wp-content/uploads/2014/05/Gimp06.png)

This wacky multi-control has multiple zones, a, big tall text cursor, multiple overlay cursors, and is way more confusing and awkward than it needs to be. Setting small sizes (1-20), no matter how many times I do it, never feels right. If brush sizes weren&#8217;t decimals by default, that would be a start. Nobody ever means to set a size of 943.72 when scrubbing (the point 72), so why are you giving me 11.34 instead of 11?

\* \* *

That&#8217;s all I can think of right now.