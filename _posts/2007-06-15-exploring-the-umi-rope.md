---
id: 224
title: 'Exploring the &#8220;Umi-Rope&#8221;'
date: 2007-06-15T21:45:56+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2007/06/15/exploring-the-umi-rope/
permalink: /2007/06/15/exploring-the-umi-rope/
categories:
  - Stuffing
  - Technobabble
  - The Spider
---
Last post talked about the random thoughts I&#8217;ve had about how to pull off the rope dynamics in Umihara Kawase, this classic SNES game that drives us all mad.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

I made some bold suggestions, and decided to try them. After a couple hours of work, while not as complete as I want, it&#8217;s far enough along to be able to demonstrate to me if I have a right idea or not.

Rather than let this fun experiment disappear in to obscurity through e-mail or forums, and since I never have enough blog content, I&#8217;ll post it here and try to explain more broadly what&#8217;s going on in my test. Though really, this is just Raigan and I talking back and forth.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

![Ugly App](/content/UmiTest.gif)

[Download it here](http://junk.sykhronics.com/games/Proto/UmiRope1.zip)

ESC &#8211; Exit
  
TAB &#8211; Reset
  
SPACE &#8211; Pause

The point of this application is to simulate a stiff wrapping Umihara Kawase rope, not a nice bouncy spring built one.

Actually at this point, it doesn&#8217;t attempt to wrap around scenery. The rope is capable of it, but I&#8217;m just manually hard coding a list of points in between the end points. I&#8217;m assuming there&#8217;s will be a system that looks at the collision, notes the edges I cross, and correctly pushes them on to the front or back of an STL deque. So &#8230; uh &#8230; for now, pretend they&#8217;re pulleys, or fitting through some really fine cracks.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

What you&#8217;re seeing on screen is 4 separate rope simulations. I&#8217;ve noted on the image in a 2&#215;2 grid what is what. &#8220;Magnitude&#8221; means I use Magnitude (**length = sqrt(x\*x+y\*y)**) for all my length calculations, and &#8220;Manhattan&#8221; means I use Manhattan (**length = abs(x)+abs(y)**) for them. The &#8220;Free&#8221; row means both points move freely, and &#8220;locked&#8221; means one doesn&#8217;t.

If you&#8217;re just tuning in, Manhattan is correct when axis aligned (i.e. [10,0], [0,-4], etc), but increasingly more wrong (too long) as it approaches a 45 degree angle. It doesn&#8217;t break, it&#8217;s just different, very diamond shaped instead of circular. Think of it as a worst case square root approximation for vectors that still works. 

To solve the rope, I need a few things. The sum of the length all rope segments, which is one place where I&#8217;m using a Magnitude/Manhattan, one for every segment. I take the difference between my set length and my calculated length to see how &#8220;broken&#8221; it is, much like a spring. I then pull or contract my end points to fix it. It&#8217;s a cheap verlet solver, so all I need to do is move the point and it will work out beautifully in a few frames. So I take the vector from end to point for each side, divide it by the length of that segment (My other Magnitude/Manhattan use, one per side), which gives me a normalized vector I can use to apply part of the rope length difference. And I subtract this from each side.

So yeah, unfortunately, I did have to use two divides, one for each side. If your target never moves, you \*could\* get away with 1 divide (but what&#8217;s the fun in that?).  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

But yeah this is a quick demonstration to see how each method works. Each test case is given the exact same data.

So, my thoughts (UmiRope_Riggid.exe).

Because the error in the Manhattan versus Magnitude, the rope is shorter. The rope being shorter to me isn&#8217;t that big of a deal, and this is why I initially didn&#8217;t see Manhattan being a problem. It&#8217;s a really cheap way to calculate an approximate total length of the rope, if it has many segments.

However, Manhattan has it&#8217;s real notable flaw in calculating the new positions of the ends. In my opinion, it&#8217;s not terrible, it&#8217;s just not very natural looking. A cheaper than a &#8220;real&#8221; square root approximation would still be ideal here.

Is this Umi-like though? Not quite yet. The Umihara Kawase rope is somehow very elastic, erratic, bouncy, where this is very rigid. Alright, more bouncy then.

I included a variant that&#8217;s more bouncy, by using a 20% of the solve amount (UmiRope_Bouncy.exe).

While reacting differently, I don&#8217;t think it&#8217;s an improvement. After it calms itself down, it looks more or less the same an the rigid example.

Hmm&#8230; I am going to have to take a look at the game again. It might be possible to introduce another error that makes the Manhattan look more sproingy.

But generally speaking, this approach to solving the rope is cheap. The only bottlenecks being a division per end, two multiplications per end to scale the vector in the normalization step, and two more to scale the normalized vector up by each side&#8217;s part of the difference, and everything else can boil down to adds, subtracts, and shifts.

And if division is a problem, it can be replaced by indexing in to a table of reciprocals (1/1, 1/2, 1/3, 1/4, &#8230;), and multiplying by this reciprocal in the place of the division. So 5 multiplications plus a bunch of adds/subtracts/shifts, per side.

At least, to solve the rope.

Everything else I think is just some good &#8220;hopefully simple&#8221; logic to figure out what points to add to your list (deque). I&#8217;ll toy with that later.

&#8211; &#8211; &#8211;

Source is included. The notable functions are, all in main.cpp:

**cParticle::Step()** &#8211; which is how we move each end of the rope. The multiply there is a friction hack, removing it makes coming to rest take more time.
  
**cRope::CalcRopeLength()** &#8211; which based on it&#8217;s contents, steps through every notable point to calculate the sum of all line segments.
  
**cRope::StepRope()** &#8211; which solves the rope. The first multiply on each line is the important one, which is a vector by a scalar. The 2nd or 3rd on those lines were just to make it more flexible. They could be replaced by a shift.

cManhattanRope::CalcRopeLength() and cManhattanRope::StepRope() are the variants needed to use Manhattan instead of Magnitude (i.e. Normalize). You can see the divide here, which is normally hidden in the normalize function.

Steps are called in main, lower in the file.