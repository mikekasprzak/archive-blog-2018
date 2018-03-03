---
id: 6206
title: State of the Investigation
date: 2013-05-10T21:29:10+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6206
permalink: /2013/05/10/state-of-the-investigation/
categories:
  - Opinion
  - Technobabble
---
So I&#8217;ve done a few scatterbrained posts lately that talk about things. Most of them had rather open ended conclusions, that were followed by wildly out-of-left field follow up posts. Here&#8217;s me making sense of that.

## Evaluating Middlewares: Unity does good 3D, bad at JS

Unity&#8217;s &#8220;JavaScript&#8221; isn&#8217;t JavaScript, it&#8217;s better named UnityScript. UnityScript is kinda terrible, essentially being just a different syntaxed less featured C#. But **var** is allowed, so uhhh&#8230; \*shrug\*.

I still don&#8217;t care much for C#, but I think Unity&#8217;s 3D workflow is excellent. Fantastic even. I have 3D projects I want to do, and when the time comes, I&#8217;ve convinced myself I should do them in Unity.

That&#8217;s 3D only though.

Haxe NME is cool, impressive and all, but it seems more a home for Adobe Flash refuges right now. Adobe, I know not what they&#8217;re thinking. I&#8217;m very confused by what they&#8217;re up to anymore, so I&#8217;m glad the Flash community has a way out. That said, I&#8217;m not particularly attached to the stricter typed Ecmascript language used by Flash/Haxe/Loom. I like JavaScript. I think JavaScript is great. So I don&#8217;t entirely feel right with Haxe NME. Highly recommended for Flash devs and people not me. 😉

## JavaScript is cool

JavaScript \*is\* cool. I&#8217;ve been working with it more and more lately. I made a game with [Derek Laufman](http://twitter.com/laufman) of [Halfbot](http://halfbot.com) using JavaScript for [Ludum Dare 26](http://www.ludumdare.com/compo/).

[<img src="/wp-content/uploads/2013/05/Toom091.png" alt="Toom09" width="556" height="311" class="aligncenter size-full wp-image-6208" srcset="/wp-content/uploads/2013/05/Toom091.png 556w, /wp-content/uploads/2013/05/Toom091-450x251.png 450w" sizes="(max-width: 556px) 100vw, 556px" />](http://sykhronics.com/toom/ld48/)

Time was short during Ludum Dare, but we came up with some neat ideas, so we&#8217;re redoing the game. A &#8220;Director&#8217;s Cut&#8221; if you will. It&#8217;s still taking place in the one room, but we&#8217;re planning to make both the room and the interactions you have inside it way more interesting.

JavaScript is cool, but I&#8217;m hitting a limit of HTML5 Canvas 2D now in the latest builds of TOOM. Chrome is fine, but Firefox has seen a significant framedrop after adding a few more Alpha operations. I will be reintroducing frame skipping in to the code, but this doesn&#8217;t bode well for the near term &#8220;best user experience&#8221; of TOOM in the broswer.

That said, I fully intend to finish the TOOM Director&#8217;s Cut as an HTML5+JavaScript game. It just may be, before its time, when it comes to Canvas 2D performance. Working in JavaScript has been great, and inspired some really great alternative-to-Unity workflow ideas. I&#8217;ll come back to this. First though, what I think of App Packagers for Desktop HTML5 apps.

## Packaged HTML5 Apps (Tool): Abandoned

In January 2012, I ported the unreleased Beneath Darkness prototype to some HTML5 packager. The company behind the packager was running a contest, and my intention was to enter the game in that contest. I wasn&#8217;t able to finish enough in time though, so I never submitted. That was fine though, as the winning games were definitely better and more complete.

The thing is, I can&#8217;t remember what that packager or the company was called.

It doesn&#8217;t really matter though. Like the Chrome Store, apps built for this packager were only for their proprietary HTML5 app store. I seem to remember a blue acorn, which may have been their logo. What disappoints me is that packager ran the game perfect. No issues with sound, no issues disabling linear filtering on image scaling, no issues loading files. Yet today, running the same prototype in both AppJS and Node-Webkit fails to load the map file. I&#8217;d be fine if Node-Webkit had no issues loading TOOM using PreloadJS, but it does. I might have been able to get NOOK working in Node-Webkit without any changes, but long story short I&#8217;m not happy.

Google&#8217;s Chrome App Packager stuff sounds like they solve the key issue (XMLHTTPRequest&#8217;s locally are okay), but it&#8217;s proprietary, and again only available to apps intended for distribution in the Chrome Store.

Even if it&#8217;s something that would be best fixed inside PreloadJS itself (support file://), that&#8217;s fine, but that&#8217;s not working 100% right now. I still have to do all my testing via a mini webserver running locally. My intent was to build a generic editor for a TOOM related project using HTML5, but I&#8217;ve decided against it. Building a Tool in HTML5 only saves me time if it works&#8230; right now&#8230; today.

I&#8217;m very unhappy with the state of packaging HTML5 apps as Desktop Apps. 

## Renstalled Empscripten, Embracing WebGL

NOOK, BEARly SEASONed, and the unreleased Last Gun prototype were made using Emscripten (C++ and JS). TOOM and the unreleased Beneath Darkness prototype were written in pure JavaScript. 

I&#8217;m glad I went back to pure JavaScript for TOOM though, because HOLY HELL I learned how REALLY GREAT some of the features of JavaScript are. You know JSON right? Well it&#8217;s **even better** in JavaScript. 🙂

[/nice-efficiency-things-about-javascript/](/2013/05/05/nice-efficiency-things-about-javascript/)

But like the headline says, I&#8217;ve since reinstalled Emscripten. My post from earlier today details this process, which was notably different than from when I did it 1 year ago. Better&#8230; except for the build time (70 minutes to build LLVM+Clang&#8230; and I had to do it twice).

[/emscripten-2-the-emscripting/](/2013/05/10/emscripten-2-the-emscripting-or-setting-it-up-again-a-year-later/)

And like the above article mentions, there&#8217;s now the AsmJS spec, which is an effort that makes JavaScript code run at only half the speed of native, versus the 6x slower than native I was promised last year.

I&#8217;ve been sort-of against WebGL, ironically, being an OpenGL guy. Against is a harsh word. More like, ignoring it. After all, Microsoft will never add it to Internet Explorer&#8230; [or will they](http://www.theverge.com/2013/3/30/4165204/microsoft-bringing-webgl-support-internet-explorer-11-windows-blue)? Yes if the leaked Windows Blue version of Internet Explorer is to be believed, WebGL support is there now, so therefor coming soon.

Good.

What WebGL also brings is some potential Canvas graphics performance improvements. Your render code will have to be ported over to WebGL (OpenGL ES2), but with a little bit of batching, things get nice and quick.

[https://www.scirra.com/boosting-mobile-html5-game-performance-with-webgl](https://www.scirra.com/blog/107/boosting-mobile-html5-game-performance-with-webgl)

Oh and Unreal Engine 3 now [runs in the browser](http://www.unrealengine.com/html5/), thanks to WebGL and Emscripten.

So alright. If Unreal Engine 3 can do it, surely a WebGL accelerated 2D engine can.

Now for the final piece.

## Squirrel! Like JavaScript but Nuttier!

Between work on the TOOM Director&#8217;s Cut&#8230; actually the other way around, I&#8217;ve returned to my Squirrel research in a big way. As far as languages go, Squirrel is very much like JavaScript, but with everything on my JavaScript wishlist already implemented and working great (operator overloading, separate integer and float number types, 32bit, delegates woo woo, etc). Here&#8217;s some exploration:

</2013/05/06/squirrely-things-about-squirrel/>

My only beef with the language is that I&#8217;m comfortable with using **var** in JavaScript, instead of **local** like Squirrel uses. That said, they&#8217;re not the same, and even **var** in JavaScript is actually a problem: Such a big problem, that the [EcmaScript 6 spec](https://developer.mozilla.org/en-US/docs/JavaScript/ECMAScript_6_support_in_Mozilla) is introducing a new keyword **let** which works how you&#8217;d expect **var** to work.

Anyways, my mini-project of the day was to get Squirrel building in the browser (using Emscripten), and to build a very basic HTML interface for invoking the compiler and seeing the results. I&#8217;m betting that, since Unreal Engine 3 can run in the browser, it&#8217;s not unreasonable of me to expect instant execution of small Squirrel scripts. If that&#8217;s the case, then if paired WebGL, it may be reasonable to expect 30-60fps performance of a C++ game driven by Squirrel scripts. I&#8217;m not exactly interested in developing web games in Squirrel, but I&#8217;m investigating whether if I commit to Squirrel as a native game logic language, I can still generate playable web versions of games.

Long story short, I want the advantages I discovered in building TOOM in JavaScript in my Native Game Deving, and I already have proof that they do work.

Regrettably, I haven&#8217;t yet finished this Squirrel building project yet. Getting Emscripten working again ate up most of my afternoon (long Clang compiles). Then there was the power outage, and this blog post, so I think I&#8217;ve done enough for today. 

I may try just compiling Squirrel with Emscripten, then I&#8217;m calling it a night.

EDIT: Yep. So far working just fine with NodeJS.

<pre class="lang:default decode:true " >#!/bin/bash

emcc -O2 \
	-I include/ \
	squirrel/sqapi.cpp \
	squirrel/sqbaselib.cpp \
	squirrel/sqfuncstate.cpp \
	squirrel/sqdebug.cpp \
	squirrel/sqlexer.cpp \
	squirrel/sqobject.cpp \
	squirrel/sqcompiler.cpp \
	squirrel/sqstate.cpp \
	squirrel/sqtable.cpp \
	squirrel/sqmem.cpp \
	squirrel/sqvm.cpp \
	squirrel/sqclass.cpp \
	sqstdlib/sqstdblob.cpp \
	sqstdlib/sqstdio.cpp \
	sqstdlib/sqstdstream.cpp \
	sqstdlib/sqstdmath.cpp \
	sqstdlib/sqstdsystem.cpp \
	sqstdlib/sqstdstring.cpp \
	sqstdlib/sqstdaux.cpp \
	sqstdlib/sqstdrex.cpp \
	sq/sq.c \
	-o bin/sq.js

// Usage: node sq.js [args]
// FYI: Emscripten compiled things can only access files inside their virtual file
//      system, so passing a .nut file on the command line will only work if you
//      added it during build. i.e. --embed-file myfile.blah
//      NOTE: --preload-file wont work in the above example, because node.js lacks
//            a window object and XMLHTTPRequests. Must be --embed-file.</pre>

## C++11 Support Feature Complete in Clang and GCC soon!

Now this is some awesome news. Clang 3.3 and GCC 4.8.1 are expected to be fully compliant with C++11 in their upcoming next versions.

**GCC** &#8211; <http://gcc.gnu.org/projects/cxx0x.html>
  
**Clang** &#8211; <http://clang.llvm.org/cxx_status.html>

There&#8217;s still the problem of compiler vendors being slow to upgrade their GCC and Clang versions to newer ones, but this milestone should be a good kick-start.

Something also rather neat, Clang is adding C++1y (C++14?) features already. One that caught my eye, **BINARY LITERALS!** So just like you do **0x10** for the hexadecimal number 16, you&#8217;ll be able to do **0b11010011** to write binary. 😀

I have a header file, named Binary.h, that&#8217;s literally filled with every 8-bit combination of b0 to b11111111. Looks like I&#8217;ll be able to retire it some day. 🙂

## End of Report

This post grew rather large &#8216;eh? Alright then, I&#8217;m done.