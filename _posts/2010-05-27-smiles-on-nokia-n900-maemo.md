---
id: 2751
title: Smiles on Nokia N900 (Maemo)
date: 2010-05-27T10:10:49+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2751
permalink: /2010/05/27/smiles-on-nokia-n900-maemo/
categories:
  - Smiles
  - Technobabble
---
The latest in the seemingly endless stream of ports (the first of the two implied quicker ports I&#8217;m doing&#8230; though the 2nd one is sounding not so quick after all).



The N900 is a Linux (Maemo) based device, so I was literally able to pick up where I finished the Moblin (Linux) ports.

Admittedly, it was a bit of a scary port, since I was only initially able to get the game to do about 10 fps. But it seems luck was on my side, as [an OS update](http://www.engadget.com/2010/05/25/nokia-updates-n900-to-version-1-2-in-uk-closes-door-on-meego/) came out just the other day (the first one in a while), and _quite literally_ saved my butt. Now the game runs flawlessly, as you can see above.

Also, first port to a system featuring a stylus! Oooh! I think it plays pretty good with one. 😀

Other savings, the NativeClient port I started last week helped out here. It&#8217;s what encouraged me to get my OpenGL 2.0/ES 2.0 graphics rendering branch back up and running, which I needed (preferred) to get the game running on the N900. I had to bundle a bunch of libraries with my binary, but thanks the switch to GL ES 2.0, that saved me from bundling one more.

Anyways, that port has now entered the Nokia machine, so we&#8217;ll see how things go there.

I meant to get on my update for the Windows netbooks after Moblin, but I figured I was still in the Linux mood. So that&#8217;s probably next, getting that update together. That followed by the other &#8220;quick&#8221; port, but we&#8217;ll see how quick that really is. I&#8217;d clock the N900 port at about 5 days, start to finish. And it was playable/visible on the first day (albeit slow).

Then early June we can _finally_ return to **mystery platform**. How I&#8217;ve missed thee. 😉