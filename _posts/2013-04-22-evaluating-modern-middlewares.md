---
id: 5987
title: Evaluating Modern Middlewares
date: 2013-04-22T01:12:01+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5987
permalink: /2013/04/22/evaluating-modern-middlewares/
categories:
  - Technobabble
  - The Business of Things
---
The following is some rambling. I have a point I&#8217;m trying to make, but I&#8217;m certain I don&#8217;t make it. My fingers kept moving, and this is what resulted. You can kinda get an idea what sort of madness is bouncing around in the &#8216;ol noodle right now though. Good luck.

* * *

\*Big Sigh\*

I&#8217;m typically a &#8220;from scratch&#8221;, &#8220;native code is best&#8221;, &#8220;c++ FTW&#8221; type of developer. The thing is, developers with my skillset and experience really are at a big disadvantage in today&#8217;s game market. I could go embed myself in some company somewhere, work on the latest greatest whatever BS FPS engine, but I&#8217;m far too independent to want to do that again. My distaste of C# has to take a backseat if I&#8217;m going to get anything serious done in a reasonable amount of time, because time&#8230; time is precious. Too precious to be fighting with low level stuff as a solo developer.

\*Bigger Sigh\*

To my credit, I started dabbling with HTML5 (JavaScript) last year, and quite liked it. It was refreshing, somewhat dirty, but enjoyable. I&#8217;ve also been picking up some little JavaScript related gigs here and there to pay the bills. So JS has been my gateway to exploring less strict languages. Squirrel is a favorite of mine, but the differences between JavaScript documented in my prior post go to show how much a change of thinking it still is. There may some day be a project for Me and Squirrel, but for now, I need to be looking elsewhere.

## Unity

<http://unity3d.com/>

Unity unity unity. It&#8217;s impossible to NOT hear about Unity these days. I was at a cabin with some gamedevs earlier this year, and nearly all of them used Unity now, and looked at me funny for NOT using it. Wow.

I was so so soooo against it. The C#, the &#8220;I&#8217;m having fun engineering&#8221; excuse, etc. Suck it up.

Then I stumbled across these tutorials:

<http://unity3d.com/learn/tutorials/modules>

As I watched each 3-10 minute short, I began to understand more and more how Unity became such an unstoppable force. And as an engine designer, I grew more and more envious how elegant some things just work inside Unity. All it took was one night, watching a majority of those videos, to realize where I may have gone wrong in my past few years.

Now, don&#8217;t get me wrong. The port frenzy that was Smiles was actually the right idea. At the time, Unity was immature, and the platforms out there were plentiful and poorly supported. I had an argument back then. When I finally picked up and started using Marmalade for the remained of ports (Android and Symbian), that was also the right idea. The world was changing. The long promise of Native Code on every device being less and less necessary was finally happening. Today I have some concerns about Marmalade&#8217;s choices, but at the time a couple years ago, they were doing the right thing.

Today I have no argument regarding Unity. I&#8217;ve tried inventing reasons not to use it, like console ports and networking, but after the Unity+Sony announcement at GDC it became clear that I&#8217;d run out of them. Given my situation as a solo developer, I am making a grave mistake NOT using it.

I credit Unity earlier for looking extremely good, but it may be because I&#8217;m starting with Unity 4. I&#8217;ve skipped much of its legacy, and certainly things must have been improved going from 3.5 to 4.0. So best I can see, Unity today is the only practical way to make a 3D game.

Oh and best part, I don&#8217;t even have to use C#. There&#8217;s something nicknamed &#8220;UnityScript&#8221;, which they call &#8220;JavaScript&#8221;, but it&#8217;s more like a strictly typed Ecmascript (i.e. Flash-like). This seems to have become a theme.

Again, I want to say I&#8217;m still evaluating Unity. That said, I may have also conceded defeat to it&#8230; however!

## Haxe NME

<http://www.nme.io/>

There&#8217;s really only one tool suite more prolific than Unity, and that&#8217;s [Haxe](http://haxe.org/). Combined with NME, it provides a solid 2D framework that can target anything from PC to Mobile to the Web. It&#8217;s a tool suite that lives and breathes in the command line, where doing an &#8220;nme test android&#8221;, an &#8220;nme test flash&#8221;, or an &#8220;nme test windows&#8221; nets you a working binary on your platform of choice. Very slick. This was the promise of Marmalade too, but for whatever reason Marm is quite finicky. Honestly, I&#8217;m shocked Haxe NME has this single command building down so well.

Haxe is a strictly typed Ecmascript (deja vu), inspired by ActionScript. Like Unity, I still haven&#8217;t written anything real with it, but it&#8217;s interesting.

I do not know Flash&#8230; at all, yet I&#8217;d like to be able to generate SWFs. FlasCC was on my TODO list, integrating it in to my toolchain so I can target Flash. But it after a quick first look, I&#8217;m very impressed with Haxe NME.

One big disadvantage of Haxe NME is the compile time. It does really take a while, far longer than my native stuff. Unity is very instant. I&#8217;ve seen some really interesting instant development suites, even better than Unity. If there was a way to speed up the development->test cycle, then Haxe NME would be unstoppable.

On that note&#8230;

## Loom

<http://theengine.co/loom>

The Loom folks are doing some interesting work. It&#8217;s an entire development framework designed instant update across multiple devices. They too use a strictly typed Ecmascript style language (deja vu 2), but the only targets are PC and Mobile. This isn&#8217;t enough. I also get the impression they may be heavily reworking how graphics work from some of the forum posts, where as what I&#8217;m after is stablity. But still, as a proof of concept, there&#8217;s a lot of potential here. I wish everyone (i.e. HaXE NME) was doing livecoding (make some tweaks to the NekoVM runtime yo :D).

Oh also, Loom the language/engine uses the LUA VM (despite being its own language). Smart!

## JavaScript + PhoneGap

This is one possibility I considered, again, because I like JavaScript. After some digging, I learned that PhoneGap is essentially the native browser for each platform, embedded in an app. That means the app is only as fast as HTML5 runs on the platform, and at the same time, may be as limited (audio).

\*Just JavaScript\* though, I thought about this, and I am still going to need this from time to time. Web development work especially. 

Windows 8, you can work in JavaScript. But that said, I don&#8217;t trust Windows 8 as a target. That&#8217;s my problem, I don&#8217;t trust anyone anymore. If I&#8217;m going to do something outrageous like switch my primary development tool, I better get MORE out of it than I had before.

Web presence is something I lack. My time with HTML5/JavaScript has filled in for some of that complete lack of Flash experience, but things like WebGL for IE are a whole major browser version away (maybe a whole major OS revision too). Also audio, I \*hope\* Mozilla finally adds that missing new audio API by the next Firefox version (audio is great in Chrome), but wow, I can&#8217;t believe HTML5 audio is still something that isn&#8217;t completely solved yet.

## Conclusion: Unity and Haxe NME are interesting

I need to make some time to dabble with both. Ludum Dare 26 is coming up, and I&#8217;d like to take this chance to test out Haxe NME. After LD though, I want to dive in to Unity. We&#8217;ll see.

Getting the most out of Haxe NME is going to take more work. One of the biggest, most impressive parts of Unity is how well structured and functional it is as an engine. In my native codebase, I&#8217;ve architected something that&#8217;s design wise on par with Unity, but there is just so much work to do to bring my native engine up to par. Months, the year even, and that&#8217;s if I can stay focused. Practically speaking, I can learn Unity in a month, and start seeing serious progress within days and weeks. Doing native addons for Unity does look straightforward, though that does require the pro version. At the same time, I need to spend more time with it to justify &#8216;going pro unity&#8217;.

Will I be able to satisfy my engineering needs with NME? Maybe. I like engine making. I&#8217;m going to have to see how deep the Haxe NME rabbit hole goes.

And you, Unity. I hear getting my Oculus Rift working with you is a few clicks and a matter of importing something&#8230; You bastard. 😉