---
id: 6238
title: 'SquirrelyJS &#8211; Squirrel Programming Language in the browser'
date: 2013-05-11T20:39:49+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6238
permalink: /2013/05/11/squirrelyjs-squirrel-programming-language-in-the-browser/
categories:
  - Squirrel
  - Technobabble
---
Phew! Okay, my little science experiment from today (i.e. why I needed a makefile): **SquirrelyJS**.

[<img src="/wp-content/uploads/2013/05/Shot01-640x359.png" alt="Shot01" width="640" height="359" class="aligncenter size-large wp-image-6239" srcset="http://blog.toonormal.com/wp-content/uploads/2013/05/Shot01-640x359.png 640w, http://blog.toonormal.com/wp-content/uploads/2013/05/Shot01-450x253.png 450w, http://blog.toonormal.com/wp-content/uploads/2013/05/Shot01.png 1366w" sizes="(max-width: 640px) 100vw, 640px" />](http://sykhronics.com/squirrelyjs/)

SquirrelyJS is a [Squirrel Programming Language](http://www.squirrel-lang.org/) compiler and VM running in the browser. So it&#8217;s a bunch of JavaScript code, a bunch of C/C++ code compiled using Emscripten, all wired up to a <del datetime="2013-05-12T01:36:01+00:00">shitty</del> web page.

It&#8217;s barebones at the moment. You can edit/change/replace the code in the left side, and hit the **Compile** buttons to recompile it. Then click the **Run** buttons to run it, outputting to the left side.

The only commands that have any control are &#8220;print&#8221; and &#8220;error&#8221;. Both print text. print is **black**, and error is <font color="red">red</font>.

<pre class="lang:default decode:true " >print( "Hello World" );

error( "DANGER! DANGER! WORLD SAID HELLO BACK!" );</pre>

For more **Squirrely** programming ideas (and an explanation of the test program) go here:

</2013/05/06/squirrely-things-about-squirrel/>

Ultimately, the reason I made this was to do some benchmarking, but I&#8217;m too tired today to do anymore (I nearly didn&#8217;t even blog about it once finished).

So ya, Squirrels.