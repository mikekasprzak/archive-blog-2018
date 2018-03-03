---
id: 778
title: Aspects of Smiles
date: 2009-02-28T23:15:31+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=778
permalink: /2009/02/28/aspects-of-smiles/
categories:
  - Smiles
  - Technobabble
---
The first step with **Smiles** was to up the art resolution. That way, I could cleanly resize to any resolution below 4x the iPhone (1920&#215;1280).

Unfortunately, double and quadruple iPhone res are not practical resolutions. Double iPhone will work windowed on most desktop LCD and 720p screens (960&#215;640), and quadruple in a window fits on a 30&#8243; Dell or Apple Cinema display, but we could do better.

Also, not all screens are the same shape, but the solution isn&#8217;t too difficult. If we maintain a consistent [aspect ratio](http://en.wikipedia.org/wiki/Aspect_ratio), it can be fit without distortion to virtually any screen.

Dividing the width by the height gives us a scalar we can compare against the same scalar from other resolutions to know which axis we&#8217;ll have to align to.  If the scalar is larger, then we align to the top/bottom.  Otherwise, we align to the sides. If equal, both work.

The following picture shows Smiles at it&#8217;s original size (480x**320**), pushed up as large as the height (1080x**720**) can fin in a **720p** screen (1280x**720**).  Note: the &#8220;1080&#8221; here is not the same thing as 1080p. Just an amusing coincidence.

[<img class="aligncenter size-medium wp-image-834" title="stretchtoextents1" src="/wp-content/uploads/2009/02/stretchtoextents1-450x329.png" alt="stretchtoextents1" width="450" height="329" srcset="/wp-content/uploads/2009/02/stretchtoextents1-450x329.png 450w, /wp-content/uploads/2009/02/stretchtoextents1-1024x750.png 1024w, /wp-content/uploads/2009/02/stretchtoextents1.png 1280w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2009/02/stretchtoextents1.png)

This fits, but shows a good 200 pixels of empty space on the sides.

We _could_ cop out at this stage, fill them in with black.  That&#8217;s what TV does.  Or if we care, we could do something about it.

One of the design niceties of **Smiles** is that the game has both a foreground and a background. The _foreground_ is all our game stuff, fixed to the resolution and aspect ratio of the iPhone. The _background_ is a tiled moving pattern or starburst. Both are easy to grow or size.

So instead of &#8220;black baring&#8221; it, I can grow the background to fit the screen.

[<img class="aligncenter size-medium wp-image-887" title="smhd04" src="/wp-content/uploads/2009/02/smhd04-450x253.jpg" alt="smhd04" width="450" height="253" srcset="/wp-content/uploads/2009/02/smhd04-450x253.jpg 450w, /wp-content/uploads/2009/02/smhd04-1024x576.jpg 1024w, /wp-content/uploads/2009/02/smhd04.jpg 1280w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2009/02/smhd04.jpg)

At the moment I am cheating. I simply made sure I draw enough extra boxes over the sides to fill the width of the screen. Eventually I&#8217;ll have to make the backgrounds a little smarter, but GDC is coming up fast so time is short.

This looks better than filling in the sides with a solid color, but we&#8217;re not done yet. There&#8217;s still 2 things related to resolution and layout I&#8217;d like tackle before I move on. The first, overscan.