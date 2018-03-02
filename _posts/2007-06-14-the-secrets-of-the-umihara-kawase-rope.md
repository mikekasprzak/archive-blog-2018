---
id: 225
title: 'The secrets of the &#8220;Umihara Kawase&#8221; rope'
date: 2007-06-14T22:22:53+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2007/06/14/the-secrets-of-the-umihara-kawase-rope/
permalink: /2007/06/14/the-secrets-of-the-umihara-kawase-rope/
categories:
  - Opinion
  - Stuffing
  - Technobabble
  - The Spider
---
[Raigan](http://www.metanetsoftware.com) and I have had an extremely brief dialog on in game ropes. It makes sense, for a while we were both doing [rope driven games](/category/the-spider/). 

Well, due to my failings as a communicator, I _sort of_ just never got back to him. Yet, I absolutely love the topic, and certainly spent much time puzzled by it. Apparently I&#8217;ve also made the conscious effort to push my way in to obscurity. My apologies, everybody who&#8217;s mailed me.

We virtually &#8220;ran in to each other&#8221; again a few weeks back, in a discussion on 2D game water physics, and so the need to share my thought looms over me again. Now that he&#8217;s in [blog town](http://www.metanetsoftware.com/blog/), I knew I had no choice, and went ahead with zee said &#8220;scooping of theories&#8221; out of zee brain, and defaced his blog with it. I hope you don&#8217;t mind.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

The question.

**How the heck do you pull of physics like that on the SNES!?!**

As I saw, the discussion is less of a question of how to do a rope, but how do you make a rope work so beautifully on such \*nothing\* gaming hardware?

The following is the slightly edited &#8220;shotgun blast to the face&#8221; I dumped in his comments. Learn more about the [game here](http://en.wikipedia.org/wiki/Umihara_Kawase).

&#8211; &#8211; &#8211;

Here we go. My thoughts on how they pulled that off on the SNES, AKA 2-3 MHZ tiled beast. To put things in more perspective, a CPU with 8bit registers, and no internal multiplication or division. However, I think I read somewhere that there was either a hardware multiplier or divider, essentially some hardware address you plug some numbers in to, and several cycles later you can read back a result. This compared to the GBA with it&#8217;s 32bit registers, and it&#8217;s &#8220;so very nice&#8221; multiplication opcode. No big deal, it&#8217;s only 1 rope.

First off, I think the biggest thing they had to their advantage was the tile graphics hardware. All Nintendo hardware except the N64, GameCube, and Wii have tile map 2D graphics hardware. Memory for 8&#215;8 tile graphics, and memory for a map to build from those tiles. So really, you&#8217;re either making a tiled game, or your not making a game on those systems.

So that means, as far as testing against collision, you&#8217;re only testing against easy aligned tiles (surfaces with normals (1,0), (0,1), and the negatives). Our rope, technically only needs to be concerned with things in units of tiles. A 64 pixel tall wall is merely 8 tiles, and only 8 &#8220;unit tests&#8221; as we interpolate across the line.

Also, a locked framerate. So long as we don&#8217;t travel more than 8 pixels in 1 frame, we should be able to stay completely stable. Lets also say each tile only finds nearest edges on it&#8217;s exposed sides (i.e. no tile adjacent to me, then it&#8217;s an exposed side).

And an optimization for rope segments, every 2 bends we can put the previous part to sleep. We just need enough memory set aside to support a dozen or so bends.

The final big thing is something I ran in to durring my adventures deeper in to physics and maths. Something in math nerd speak called the Manhattan Length or Distance (I forget it&#8217;s proper name, I just call it the Manhattan). The Manhattan is a length formula for a line, in much the same way as magnitude (or magnitude squared, how I love thee). The formula is the sum of all the absolute value parts of a vector. I.e. Manhattan = abs(x) + abs(y). No doubt you&#8217;ve played with this yourself, and scoffed it off because it&#8217;s not an accurate length. That is, except in one key case&#8230; 

When it&#8217;s axis aligned! No square root required! (1,0) or (0,1) respectfully, the Manhattan or length is 1, and so would the magnitude. Why is this important?

Tile hardware is axis aligned! So as long as we wrap around axis aligned things, our rope segments are accurate. Even if not, so what? Worst case, our rope shrinks a bit going over a slope.

You&#8217;ve probably noticed how extra bouncy/elastic the rope in Umihara is. My best guess, is it&#8217;s because they live with the horrible innacuracies of the Manhattan Length. And truth be told, asuming that&#8217;s what it is, it still looks great. Eventually you&#8217;ll pendulum your self to a stop whilst hanging vertically.

So there you go, Mike&#8217;s &#8220;how they did [Umihara Kawase](http://en.wikipedia.org/wiki/Umihara_Kawase)&#8220;.

&#8211; &#8211; &#8211;

**Disclaimer:** This is all theory. I&#8217;m too lazy to disassemble the ROM. It&#8217;s _enough_ for me so that I can sleep at night.