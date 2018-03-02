---
id: 2895
title: Porting to Palm Journal/Article
date: 2010-07-14T13:32:42+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2895
permalink: /2010/07/14/porting-to-palm-journalarticle/
categories:
  - Technobabble
---
Somewhere on my agenda is writing up some articles on how to port from iPhone to some of the other cool platforms out there (PC/AppUp, Palm, etc). I&#8217;m always rather busy though, when I finish one thing I&#8217;m often on to the next one.

I have [numerous](http://www.galcon.com) [developer](http://www.madgarden.net) [friends](http://www.ancient-workshop.com) I regularly chat with on IRC, Forums and e-mail, since we tend to be doing the same things with our games (porting, marketing, etc). I promised [Phil](http://www.galcon.com) both that doing a Palm port would be easy, and that I&#8217;d give him some pointers on doing it. So I scribbled down a whole bunch of tips and notes for him while he worked. Two and a half days later he submitted his binary to Palm.

During that process though, he did a good thing. He decided to journal it. So here&#8217;s Phil&#8217;s Palm porting journal, along with some of the notes I gave him.

<http://www.philhassey.com/blog/2010/07/14/porting-to-palm-webos/>

Not covered in much detail is the _core port_. Phil and I both started our iPhone adventures by simultaneously making a PC SDL+OpenGL version (Me on Windows, Phil on Linux) in addition to the iPhone version. The first step to any of the above will be to get your game working on your PC with SDL. Then it&#8217;s a matter of making only a few minor additions to your SDL+GL code, and using your OpenGL ES rendering branch. For those not already aware, the difference between OpenGL ES 1.1 and desktop OpenGL 1.x is that Desktop OpenGL has a few functions **without** F&#8217;s in the name (so do an #ifdef). Also, prefer OpenGL ES, since Desktop OpenGL has extra functions not found in OpenGL ES.

Anyways, it&#8217;s not a full howto guide, but some useful pointers. More than I have time to write at the moment. 😉

I&#8217;ll make a post with the transcript of my notes soon. Since it was for private use, I need to double check I didn&#8217;t include any &#8220;under NDA&#8221; information in it.