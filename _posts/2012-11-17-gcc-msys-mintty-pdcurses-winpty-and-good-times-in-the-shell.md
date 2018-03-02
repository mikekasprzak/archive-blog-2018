---
id: 5641
title: GCC, MSYS, MinTTY, PDCurses, WinPTY, and good times in the shell
date: 2012-11-17T14:29:39+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5641
permalink: /2012/11/17/gcc-msys-mintty-pdcurses-winpty-and-good-times-in-the-shell/
categories:
  - Technobabble
---
I am a strange developer. 

My preferred development environment is [GCC](http://gcc.gnu.org) running in a simulated BASH shell on Windows. This madness all started well over a decade ago when I first discovered [DJGPP](http://www.delorie.com/djgpp/), a [GCC](http://gcc.gnu.org) for DOS. This means GCC was my first C and C++ compiler.

Now sure, like most kids (?!) I used Visual C++ in College. That was mainly for my school projects though. Whenever it was me time, I was rocking the DJGPP. To be honest, I can&#8217;t really remember when I switched away from DJGPP, but I&#8217;m fairly certain I was still using it in 1999.

<img src="/wp-content/uploads/2012/11/pdm-03.gif" alt="Poke Da Mon" title="Poke Da Mon" width="160" height="144" class="alignright size-full wp-image-5645" /><img src="/wp-content/uploads/2012/11/csc-03.gif" alt="Combat Soccer" title="Combat Soccer" width="160" height="144" class="alignright size-full wp-image-5646" />End of 1999 I was hired by long forgotten game developer Sandbox Studios as a GameBoy programmer. I had been dabbling with the GameBoy homebrew during the summer of 1999, made some little games, and won some stuff in a contest (Flashcarts). This lead to me using a GameBoy assembler called [RGBDS](http://www.otakunozoku.com/rednex-gameboy-development-system/) (Rednex GameBoy Development Suite), which was a great little macro assembler suite. All command line.

My point: I&#8217;ve been comfortably working in command lines and shells for a long time. And I do it on Windows, where everybody else uses Visual Studio. I treat my Windows as a Linux box.

For the past decade, [Cygwin](http://www.cygwin.com) and [MinGW/MSYS](http://www.mingw.org) have been the go-to ways of working Linux&#8217;y on Windows. I used to use a lot of Cygwin, especially since all the major video game console toolchains of the time were GCC based, and Cygwin did a much better job at simulating/hosting/building a GCC cross compiler. GameBoy Advance, PlayStation, though there were some alternatives (SN, CodeWarrior), in my books GCC was the way to go.

Today I rarely use Cygwin, but I always keep it around. Instead I use MinGW, which is a GCC port with a mostly compatible set of Win32 libraries, and MSYS (a minimal Bash/Cygwin like environment). It&#8217;s had its rough moments over the years, but for my needs I find it to be the better of the two. Cygwin&#8217;s goals are to simulate Unix on Windows. MinGW/MSYS&#8217;s goals are to target Windows with GCC. Why half-ass it?

<!--more-->Installing MinGW has dramatically improved since the early days. You just have to go here:

<http://sourceforge.net/projects/mingw/files/>

And grab the installer. There&#8217;s a blatant link there you are supposed to click (beside the &#8220;Looking for the latest version?&#8221; text). Admittedly, it&#8217;s hard to notice, but that&#8217;s what you&#8217;re looking for.

With the installer, it&#8217;s just a few checkboxes to include MSYS and G++ with it, and you&#8217;re good to go.

Why I especially like MSYS over Cygwin is because MSYS features a package manager. From the shell you can use &#8220;mingw-get&#8221; to install things, just like on Linux with &#8220;apt-get&#8221; and &#8220;yum&#8221;. Any time you&#8217;re missing a typical Linux package, library, or tool, a quick invocation to &#8220;mingw-get install toolname&#8221; is sometimes all you need.

So lets grab something.

<pre>mingw-get install mintty</pre>

Something you may notice when working with the MSYS or Cygwin shell is that the Window it&#8217;s in really lacks nice resizing features. You can change the shape and size, but you have to do it inside the properties. You can&#8217;t just grab a corner and size it. The other thing is they don&#8217;t exactly support ANSI color sequences. You sometimes see colors, but the way colors work isn&#8217;t the same as shells on Linux. 

The solution is to install MinTTY, a much nicer shell for working on Windows. Doing the above mingw-get installs it, but to use it you need to make 1 more change. I typically have a shortcut to msys.bat, so I modify my shortcut directly to have it start in MinTTY.

<div id="attachment_5656" style="max-width: 396px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2012/11/MinTTY.png"><img src="/wp-content/uploads/2012/11/MinTTY.png" alt="" title="MinTTY" width="386" height="384" class="size-full wp-image-5656" srcset="http://blog.toonormal.com/wp-content/uploads/2012/11/MinTTY.png 386w, http://blog.toonormal.com/wp-content/uploads/2012/11/MinTTY-150x150.png 150w" sizes="(max-width: 386px) 100vw, 386px" /></a>
  
  <p class="wp-caption-text">
    Modifying a shortcut to Msys.bat to include an argument &#8220;&#8211;mintty&#8221;
  </p>
</div>

And now we&#8217;re in MinTTY town. If you&#8217;re on Windows 7 (Aero), you can even make your MinTTY Windows semi-transparent.

<div id="attachment_5659" style="max-width: 557px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2012/11/MinTTYGlass.png"><img src="/wp-content/uploads/2012/11/MinTTYGlass.png" alt="" title="MinTTYGlass" width="547" height="384" class="size-full wp-image-5659" srcset="http://blog.toonormal.com/wp-content/uploads/2012/11/MinTTYGlass.png 547w, http://blog.toonormal.com/wp-content/uploads/2012/11/MinTTYGlass-450x315.png 450w" sizes="(max-width: 547px) 100vw, 547px" /></a>
  
  <p class="wp-caption-text">
    MinTTY in Glass mode
  </p>
</div>

So that&#8217;s cool.

MinTTY does have some limitations though. Honestly, I hadn&#8217;t noticed them until I recently started using a library [PDCurses](http://pdcurses.sourceforge.net/). PDCurses is a cross platform implementation of the [Curses](http://en.wikipedia.org/wiki/Curses_%28programming_library%29) library for controlling a terminal. If you&#8217;re familiar with [Conio](http://en.wikipedia.org/wiki/Conio.h), Curses is the Unix version of that. On Linux you&#8217;d use [NCurses](http://en.wikipedia.org/wiki/Ncurses), and on Windows you&#8217;d use PDCurses.

<http://sourceforge.net/projects/pdcurses/files/>

Same as before. The link you want is beside the &#8220;Looking for the latest version?&#8221; text.

MinTTY&#8217;s limitation is that it that despite everything it does support, it doesn&#8217;t support PDCurses.

<div id="attachment_5660" style="max-width: 484px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2012/11/MinTTYNetty.png"><img src="/wp-content/uploads/2012/11/MinTTYNetty.png" alt="" title="MinTTYNetty" width="474" height="96" class="size-full wp-image-5660" srcset="http://blog.toonormal.com/wp-content/uploads/2012/11/MinTTYNetty.png 474w, http://blog.toonormal.com/wp-content/uploads/2012/11/MinTTYNetty-450x91.png 450w" sizes="(max-width: 474px) 100vw, 474px" /></a>
  
  <p class="wp-caption-text">
    Sorry folks, MinTTY can&#8217;t run your PDCurses code
  </p>
</div>

The reason for this is [long and complicated](http://code.google.com/p/mintty/issues/detail?id=56) (which I admittedly don&#8217;t understand), but generally it&#8217;s some to do with MinTTY being implemented as pipes instead of something that directly encapsulates a Windows console. 

Solution: Near the end of that discussion comes a tool called WinPTY. This is a tool that launches a program in a typical Windows console, captures the data, and forwards it to MinTTY seamlessly.

<https://github.com/rprichard/winpty>

There were more tools suggested in the discussion, but WinPTY is the one that worked immediately for me. Like the instructions said, I needed the following to build it:

<pre>mingw-get install msys-dvlpr</pre>

After that I was able to &#8220;./configure&#8221;, &#8220;make&#8221;, an &#8220;make install&#8221;. 

Then it&#8217;s simple. Prefix the program you&#8217;re calling with a call to a program &#8220;console&#8221;, and it&#8217;ll now work inside MinTTY.

<pre>console Netty.exe -server 1024</pre>

This can help with other programs like Python (with can alternatively be run in a -i mode), but things that use curses is the mean reason I use it.

WinPTY is new to me, and is actually the reason I wrote this post. This is me writing things down so \*I\* don&#8217;t forget. 🙂

\* \* *

And some curses usage notes. [Color](http://uw714doc.sco.com/en/SDK_charm/_Color_Manipulation.html).

<pre class="lang:default decode:true " >initscr();
    cbreak();
	halfdelay(1);
    noecho();

	start_color();
	init_pair( 1, COLOR_RED, COLOR_BLACK );
	attron( COLOR_PAIR(1) );

	printw( "This is a curse\n" );
</pre>