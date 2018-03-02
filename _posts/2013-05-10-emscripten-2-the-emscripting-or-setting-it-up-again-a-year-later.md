---
id: 6165
title: 'Emscripten 2: The Emscripting (or setting it up again, a year later)'
date: 2013-05-10T12:45:18+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6165
permalink: /2013/05/10/emscripten-2-the-emscripting-or-setting-it-up-again-a-year-later/
categories:
  - Technobabble
---
So last year, [Derek](http://twitter.com/laufman) and I created a little game called [Nook](http://sykhronics.com/nook/). Nook was an interesting game that was half JavaScript and half C++, running in the browser (as 100% JavaScript). Things were still new with [Emscripten](https://github.com/kripken/emscripten/wiki). At the time it had only recently reached the point where it could work with standard C++ libraries without issue. Performance claims were about 6x slower than native. Everything worked out great, so I did little writeup on it:

[/nook-and-emscripten-a-technical-look/](/2012/04/27/nook-and-emscripten-a-technical-look-at-c-gamedev-in-the-browser/)

There were some talks at GDC this year on [Empscripten](https://github.com/kripken/emscripten/wiki), and regrettably I missed those. And just last week [Unreal Engine 3](http://www.unrealengine.com/html5/) was ported to the browser using Emscripten. Thanks to recent optimization work, and the new [AsmJS](http://asmjs.org/) spec, its seems Emscripten code is close to [2x slower than Native](https://github.com/kripken/emscripten/wiki/FAQ) in AsmJS optimized browsers. And as always, a great place to hear about interesting new things with Emscripten is on the lead developers blog and twitter.

<http://mozakai.blogspot.ca/> | [@kripken](http://twitter.com/kripken)

* * *

Now formalities are out of the way, I&#8217;ve given myself a new project: **Squirrel VM** in the browser.

This blog post wont cover &#8220;SquirrelyJS&#8221; (a nickname I just came up with for the project), but setting up Emscripten again.

## Setting Up Emscripten

I&#8217;ve just recently installed a new hard drive in my laptop, so I need to reinstall Emscripten. I&#8217;ll be following the tutorial here:

<https://github.com/kripken/emscripten/wiki/Tutorial>

Starting with the downloads, I had to install GIT (I&#8217;m an SVN guy). I like [TortoiseGIT](http://code.google.com/p/tortoisegit/), because I also like [TortoiseSVN](http://tortoisesvn.net/downloads.html) (and [TortoiseHG](http://tortoisehg.bitbucket.org/)). [TortoiseGIT](http://code.google.com/p/tortoisegit/) requires [MSysGIT](http://code.google.com/p/msysgit/) to work.

It&#8217;s worth knowing that the Emiscripten you get out of GIT is the full thing usable as-is. No compiling is required. Once everything is installed correctly (Clang, Python), and your paths are set up correctly, it will work.

Python 2.7 I already had installed in **C:\Python27**. Emscrpten tries to be clever and use a file python2.exe, which doesn&#8217;t exist by default. This can be fixed later, but you can create a symlink, or make a copy of python.exe as python2.exe in the python directory. It&#8217;s 27k, so an extra copy of python.exe wont hurt.

**NOTE:** Java is required to use the closure compiler (i.e. JavaScript optimizer). For some reason this isn&#8217;t mentioned in the setup instructions.

## Building LLVM+Clang

I use [MinGW with MSys](http://sourceforge.net/projects/mingw/files/latest/download?source=files), and while yes there is an &#8220;experimental&#8221; download on the Clang/LLVM page, I wasn&#8217;t able to get it working. So instead, I had to build it from source.

**WARNING:** [DO NOT BUILD FROM SVN!](https://github.com/kripken/emscripten/issues/959) EMSCRIPTEN IS ONLY COMPATIBLE WITH THE CURRENT STABLE RELEASE! (Also skip the test-suite)

I followed the instructions here, with one change:

<http://clang.llvm.org/get_started.html>

**EDIT:** USE AS REFERENCE ONLY! You should only ever use the [stable sources](http://llvm.org/releases/download.html#3.2). Uncompress clang in to the tools folder as suggested (renaming clang-3.2.src to just clang), and **optionally** in projects compiler-rt (renaming compiler-rt-3.2.src to just compiler-rt). Skip the test-suite.

My change I did &#8220;**../llvm/configure [&#45;&#45;enable-optimized &#45;&#45;disable-assertions](http://llvm.org/docs/GettingStarted.html)**&#8220;, since I wanted a nice fast release build of LLVM+Clang, not a slower debug build with Asserts.

I also had to disable my current install of Clang, as it was trying to use Clang to build Clang+LLVM, which was broken. Only a problem if you tried to use the experimental package they provided.

An unfortunate downside, I was unable to use &#8220;**make -j 4**&#8220;, which uses multiple cores to compile. This is the 2nd time in the years I&#8217;ve been using MinGW+Msys I&#8217;ve come across something that make&#8217;s -j hasn&#8217;t worked (I can&#8217;t remember what the other one was, but it was a few weeks ago). It deadlocked on compiling the 4th file, which is not a good way to finish building anything. 😉

Compiling in a single thread took me **over an hour**. 🙁

Once built, &#8220;**make install**&#8221; to put it in my /usr/local/bin.

## Configuring your system for Emscripten

First things first, we&#8217;re going to need to set some environment variables. You can do that here:

**Control Panel->System->Advanced System Settings->Environment Variables**

The **Path** is often the most important variable to tweak. Add new paths separated by semicolons (;). I added:

**;C:\Python27\;C:\Emscripten\**

There are some **optional** environment variables you can add here too.

**EMSCRIPTEN** &#8211; Where emscripten is (e.g. &#8220;C:\Emscripten\&#8221;).
  
**LLVM** &#8211; Where Clang+LLVM is. (e.g. &#8220;c:\MinGW\\msys\\1.0\\local\\bin&#8221;).
  
**PYTHON** &#8211; Python executable. (i.e. &#8220;C:\Python27\python.exe&#8221;).

Browse to the Emscripten directory with MSys, and run the following.

**python emcc**

Because its the first run, this will create an Emscripten configuration file in your home folder. Mine was here:

**C:\MinGW\msys\1.0\home\Mike\.emscripten**

In this file you can edit/set the location of Python, Clang/LLVM, etc. You can also change it from using **python2.exe** to **python.exe** if you want.

**IMPORTANT:** You need to set your temp directory. I modified the TEMP_DIR line as follows:

<pre class="lang:default decode:true " >TEMP_DIR = os.path.expanduser(os.getenv('TMP') or '/tmp')</pre>

After all, the rest of the lines in the file use this os.getenv function, so why not temp too?

Okay! That should be it.

Now if everything is set up correctly, you should be able to run **clang** and have it not crash. 

<pre class="lang:default decode:true " >clang /c/Emscripten/tests/hello_world.cpp
./a.out</pre>

You should also be able to run **emcc** without explicitly invoking python now.

<pre class="lang:default decode:true " >emcc /c/Emscripten/tests/hello_world.cpp
node a.out.js</pre>

Node is NodeJS, the tool for running JS files on the command line (without an .html page).