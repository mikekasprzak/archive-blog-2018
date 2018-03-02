---
id: 5022
title: 'Nook and Emscripten: A technical look at C++ GameDev in the Browser'
date: 2012-04-27T15:44:59+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5022
permalink: /2012/04/27/nook-and-emscripten-a-technical-look-at-c-gamedev-in-the-browser/
categories:
  - Ludumdare
  - Technobabble
---
I run an online game-jam event called [**Ludum Dare**](http://www.ludumdare.com), and this past weekend I got together with a friend ([Derek Laufman](http://twitter.com/laufman) of [**Halfbot**](http://www.halfbot.com)) and we made a game. What did we make? A platformer about size.

<div id="attachment_5025" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="http://www.sykhronics.com/nook/60/"><img src="/wp-content/uploads/2012/04/SS_01.png" alt="" title="Click to Play!" width="640" height="480" class="size-full wp-image-5025" srcset="http://blog.toonormal.com/wp-content/uploads/2012/04/SS_01.png 640w, http://blog.toonormal.com/wp-content/uploads/2012/04/SS_01-450x337.png 450w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Nook - A game where size matters. Click the image to Play!
  </p>
</div>

The game was created over a period 72 hours. Somehow, amazing to me, we managed to pull it together despite our responsibilities.

  * Me running the event (Ludum Dare)
  * Family gathering at my brothers I attended on the Saturday
  * Car appointment on Monday
  * Derek taking care of his baby

Fortunately, running Ludum Dare is only busy for me before the event, and at submission time (two of them, 3-5 hours each). During the event I&#8217;m free to sit down and do whatever I want. This weekend was the **Diablo 3 beta test**, and if I was a [lesser man](http://www.markfassett.com), I&#8217;d have played that. Fortunately for me, Derek came to me a couple weeks ago and suggested we make a game together, I said yes, and the rest is history.

It&#8217;s totally silly, but I&#8217;m actually proud of the fact that I managed to attend the family gathering and the car appointment. Stupid me, I could have actually cancelled/rescheduled the appointment for Tuesday or Wednesday, but I decided to go ahead with it anyway. The car appointment was my [yearly service for my smartcar](/2010/04/08/automobiles-interviews-all-smiles/), and I ended up staying in the neighborhood of the dealership for about 5 hours of that day. Working on my Ludum Dare game on my laptop, I had WIFI at the dealership, and also McDonalds, where I parked myself for a couple hours. To be honest, this was probably the first time I seriously &#8220;Coffee Shop Developed&#8221;, and where I actually got some serious work done. It was fun, because it was out of the ordinary. 🙂

Anyways, that&#8217;s enough back story. Lets get nerdy.

<!--more-->

## Emscripten

[**Emscripten**](https://github.com/kripken/emscripten) is a wonderful tool. I&#8217;ve been jokingly referring to it as witchcraft and other colloquialisms for evil, since it does something rather outrageous: Compiles C++ to JavaScript. To some programmers (vocal programmers), that just might be one of the greatest heresies ever committed to page (thou shall not mix chocolate and peanut butter). Me, I actually quite like JavaScript, having [developed a taste for it last Ludum Dare](/2011/12/22/ludum-dare-prototyping/). 

I&#8217;ve been a big supporter of the idea behind similar &#8220;C++ to Web&#8221; technologies (Adobe Alchemy, Google Native Client), but both seem to have some issues to deal with today (was not part of the early access program, not enabled by default in Chrome). Emscripten on the other hand is out there, it&#8217;s free for everyone, and it **works on all browsers today**. Emscripten&#8217;s problem seems to be one of obscurity (success stories forthcoming), how unbelievable the idea of C++ to JS is to most developers, and the technical know-how needed to use it.

### Setting Up Emscripten

I wont bother with a step by step description. You should go here for details:

<https://github.com/kripken/emscripten/wiki/Tutorial>

I will however talk about my specific configuration.

Me, I run Emscripten inside [MSys](http://www.mingw.org), which is [MinGW](http://www.mingw.org)&#8216;s faux Unix shell. If you&#8217;re not familiar with MinGW, it&#8217;s a [GCC](http://gcc.gnu.org) compiler suite and libraries needed for building apps for Windows. Emscripten&#8217;s &#8220;emcc&#8221; works just like GCC, but generates JavaScript code. So a nice bonus with my setup, I have everything needed to make both Windows and Web &#8220;binaries&#8221;.

To use Emscripten, you need version 3.0 of [LLVM](http://www.llvm.org) and [Clang](http://clang.llvm.org) installed. As a Windows user, for whatever reason, 3.0 binaries were unavailable (older binaries were). So I had to manually build them on my PC via the MSys shell.

[Read the instructions](http://clang.llvm.org/get_started.html) on installing Clang. Clang and LLVM are built at the exact same time via LLVM. Building is done in a typical &#8220;./configure; make; make install&#8221;, like you would do on a Linux. Browse to the LLVM root folder, run configure (&#8220;./configure&#8221;), make it (&#8220;make&#8221;), and make install it (&#8220;make install&#8221;).

If configure complains about a missing Linux&#8217;y package, you can use the tool &#8220;mingw-get&#8221; from the command-line to install additional packages (just like on a Linux). `mingw-get install package`

Grab [Python 2.7](http://www.python.org), and add the path to it to your &#8220;path&#8221; environment variable. Parts of Emscripten are Python.

Grab [Node.js](http://nodejs.org/). This is needed to run JavaScript code from the command line. Parts of Emscripten are written JS.

Grab the [Java Runtime](http://www.java.com/en/download/index.jsp) (OpenJDK if on Linux). This is needed by Google&#8217;s closure compiler, which is a tool that will later help you obfuscate and optimize.

That&#8217;s everything. [Follow the tutorial](https://github.com/kripken/emscripten/wiki/Tutorial) and build something pretty now.

## Using Emscripten

Emscripten uses magic, also known as LLVM and Clang to convert C and C++ code to bytecodes, and reconstructs new JavaScript code based on those generated bytecodes. You should have an understanding of JavaScript coming in to this, as it&#8217;s often wise to check the generated code to see what LLVM+Clang+Emscripten are doing, especially when starting out. The project is mature and functional, but you will learn more from seeing and doing than you will from reading documentation. The documentation is good for filling in the gaps of things that aren&#8217;t typical with a normal GCC-like C and C++ compiler.

A typical project generated by Emscripten will be an HTML file (eg. index.html) and a JS file (eg. mycode.js). I like having a separate HTML file, as it means you can include other things (external map data files) inside it. If you wanted to though, you could include the JavaScript code right inside the HTML file.

### Crunch Time Compile Script

I didn&#8217;t have much time this weekend to think, so I did all my compiling via simple shell script that I tweaked and added to whenever I needed. Normally I&#8217;d have a proper makefile system for building, but I was still learning the ins and outs of Emscripten, so I opted for more hackibility.

<pre class="lang:sh decode:true " >#!/bin/sh

#export CC='~/Code/emscripten/emcc'
export CC='/d/Build/em2/emcc'

export CFLAGS='-O2 --closure 0'
export DEFINES='-D NOT_GCC -D EMSCRIPTEN -D USES_UNIX_DIR'
export INCLUDES='-I ../GEL -I ../External/cJSON'
export FILES='src/Main.cpp ../GEL/Math/Real.cpp ../GEL/Debug/LogEmscripten.cpp ../GEL/Math/Vector/Vector3D.cpp ../External/cJSON/cJSON.c'

mkdir -p obj output

echo "// Begin PreJS.txt //"&gt;obj/PreJS.txt
cat external/buzz.js&gt;&gt;obj/PreJS.txt
#cat external/soundmanager2-nodebug-jsmin.js&gt;&gt;obj/PreJS.txt
#cat GelHTML/GelAudio.js&gt;&gt;obj/PreJS.txt
cat GelHTML/GelAudioBuzz.js&gt;&gt;obj/PreJS.txt
#cat GelHTML/GelAudioDummy.js&gt;&gt;obj/PreJS.txt

#echo "var ContentMapData = "&gt;&gt;obj/PreJS.txt
#cat Content/MapData.json&gt;&gt;obj/PreJS.txt
#echo ";"&gt;&gt;obj/PreJS.txt

cat GelHTML/GelUtil.js&gt;&gt;obj/PreJS.txt
cat GelHTML/GelMath.js&gt;&gt;obj/PreJS.txt
cat GelHTML/GelGeometry.js&gt;&gt;obj/PreJS.txt
cat GelHTML/GelGraphics2D.js&gt;&gt;obj/PreJS.txt
cat Main.js&gt;&gt;obj/PreJS.txt
cat Load.js&gt;&gt;obj/PreJS.txt


$CC $DEFINES $INCLUDES $CFLAGS $FILES --pre-js obj/PreJS.txt -o output/nook.emcc.js 

java -jar bin/compiler.jar --compilation_level WHITESPACE_ONLY --js output/nook.emcc.js 2&gt;output/nook.emcc.js.txt&gt;output/nook.js
</pre>

Some notes:

  * I explicitly disabled the closure compiler in the optimizations (&#8211;closure 0). Eventually I re-added it, but manually (last line). I tracked down some very very unusual Chrome only performance bugs that were caused by closure Compiler optimizations. Whitespace removal works fine and is totally safe, so I&#8217;m doing only that now.
  * &#8211;pre-js takes only a single file, so I had to combine all my JS code in to a single file first. Someone should really put in a feature request in to allow multiple &#8211;pre-js calls. 😀
  * Audio support in browsers is \*shrug\*, so I have 3 audio libraries I enable/comment out between (SoundManager 2, Buzz, and none).
  * For a brief time, I was including my map file alongside my other JS code. I eventually moved mention of it in to the HTML file, so that file would be read every time (without the need to re-link the binary).

### C and C++ Code

A C function named &#8220;MyFunction&#8221; will become &#8220;_MyFunction&#8221; inside JavaScript scope. Conversely, a JavaScript function prefixed with an underscore will be accessible from your C code. Just prototype it before hand (&#8220;void MyFunction();&#8221;) and you&#8217;re golden.

I&#8217;d recommend using basic types when passing data between JS and C++. Floats and Integers where possible, and char*&#8217;s for strings. Strings require a little more work to use, but aren&#8217;t bad. See the &#8220;Other Methods&#8221; section for details:

<https://github.com/kripken/emscripten/wiki/Interacting-with-code> 

C++ functions are a little tricker. If you&#8217;ve ever tried mixing and matching C and C++ code, you&#8217;re probably familiar with C++ Name Mangling. You need to deal with mangling here if you want to use C++ code.

`<strong>void GameDraw()</strong> becomes __Z8GameDrawv();<br />
<strong>void GameInput( float X, float Y, int New, int Old )</strong> becomes __Z9GameInputffii( var, var, var, var );`

The encoding isn&#8217;t too hard to decipher, but it&#8217;s probably easiest to just open the output JavaScript file, and search for the symbol. &#8220;GameDraw&#8221;, and keep looking until you get one that&#8217;s wacky like those mangled names above.

Too keep things simpler on the JS->C++ side, I&#8217;d recommend sticking with single underscores and wrapping your prototypes in &#8220;extern C&#8221; sections.

<pre class="lang:c++ decode:true " >// - --------------------------------------------------------- - //
extern "C" {
// - --------------------------------------------------------- - //
	void gelGraphicsInit( int Width, int Height );
	void gelGraphicsExit();
	
	void gelSetColor( int r, int g, int b, int a );
	void gelDrawCircle( float x, float y, float Radius );
	void gelDrawCircleFill( float x, float y, float Radius );
// - --------------------------------------------------------- - //
};
// - --------------------------------------------------------- - //
</pre>

### Graphics

Emscripten ships with a version of the popular SDL game library. In addition, there&#8217;s a bunch of work done on a OpenGL port, based on WebGL. I&#8217;d expect to see more and more things ported as the GL libraries mature.

Me I&#8217;m slightly impatient, and have my own libraries that wrap OpenGL on the PC/Mobile side. I didn&#8217;t use any of my existing graphics code, but created a new JavaScript library based on the same naming scheme. Before this weekend, I had only minimal experience using Emscripten, so I didn&#8217;t want to pigeonhole myself in to my existing libraries. I don&#8217;t use floats in my libraries, but instead I use a type &#8220;Real&#8221; which is synonymous, and includes some extra features. After today, a change I would make is have my drawing libraries accept floats, and lightly wrap them with versions that take Real&#8217;s. That would make building a consistent interface across targets nicer.

For understanding Canvas 2D&#8217;s rendering capabilities, I recommend Mozilla&#8217;s tutorial.

<https://developer.mozilla.org/en/Canvas_tutorial>

All my art assets are PNG files that I load from disk.

<pre class="lang:js decode:true " >var ImageData = new Array();
var CurrentImage;

function _gelLoadImage( FileName ) {
	var NewImage = new Image;
	NewImage.src = Pointer_stringify(FileName);
	
	var Index = ImageData.length;
	ImageData.push( NewImage );
	return Index;
}

function _gelBindImage( ImageId ) {
	CurrentImage = ImageData[ ImageId ];
}

function _gelDrawImage( sx, sy ) {
	Module.ctx.drawImage( CurrentImage, sx, sy );
}</pre>

### Music and Audio

I wrote a generic interface to load and play sound files. All JS sound libraries use MP3 or OGG files, which makes them suitable for music playback too. However, unfortunately, no matter what library you use, looping of music has an annoying gap and isn&#8217;t seamless.

Options include:

  * **[Buzz](http://buzz.jaysalvat.com/)** &#8211; Purely HTML5 library
  * **[SoundManager 2](http://www.schillmania.com/projects/soundmanager2/)** &#8211; HTML5 or Flash (A or B, or both)

I use both. I started with SoundManager 2, because I occasionally notice weirdness in native HTML5 playback. But for the updated version (the link above), I switched back to Buzz. There are cases when the sound gets broken on Chrome, but SoundManager 2 has a delay. I prefer delayless.

SoundManager 2 also supports multi-shot sound playing (i.e. the sound doesn&#8217;t interrupt the last one played), but only with its Flash 9 based noisemaker. This is cool, but for the style of game we were making, interrupting sounds wasn&#8217;t a problem. 

## Optimizations and Performance

If you&#8217;ve ever implemented a scripting language in to a game engine, you&#8217;ll be familiar with the idea that native code is faster. A &#8220;Draw&#8221; function that blits a sprite or renders some 3D geometry should always be in native code, and not implemented in script. Working with Emscripten is _a bit_ of that. For the most part, Emscripten does a really good job optimizing, and often does things you would forget if optimizing by hand. However, there are times when going native (in this case JavaScript) will speed up your game.

### File IO

Emscripten includes a suite of function for faking data in a filesystem. They work fine and are totally easy to use (can be automatically done via command-line arguments to the linker). However, using a JSON parsing library written in C to read a 400k JSON file that has been artificially encoded in to the virtual file system can be &#8230; wasteful.

This is actually what I did at first. The map was originally a 200k JSON file, exported by [Tiled](http://www.mapeditor.org). It was a bit horrible, taking about 4 seconds to parse, but tolerable. Once we grew the map to a >400k file, things got out of hand (12 seconds).

Since JSON stands for JavaScript Object Notation (duh, the native object format of JavaScript), my solution was to include the JSON file alongside the rest of the JavaScript code in the HTML page.

<pre class="lang:js decode:true " >&lt;script src='Content/MapData.json.js' type='text/javascript'&gt;&lt;/script&gt;</pre>

A JSON file however lacks an actual usable name in JavaScript. So to avoid weird cross-file crying by a &#8220;secure&#8221; browser, I wrote a tool to append an appropriate name on to the file.

<pre class="lang:c++ decode:true " >#include &lt;stdio.h&gt;

#include &lt;Core/DataBlock.h&gt;
#include &lt;Core/GelFile.h&gt;

int main( int argc, char* argv[] ) {
	if ( argc == 1 ) {
		printf( "You did it wrong!\n" );
		return -1;
	}
	
	char Text[4096];
	sprintf( Text, "%s.js", argv[1] );
	
	DataBlock* InData = new_read_DataBlock( argv[1] );
	GelFile* OutFile = open_writeonly_GelFile( Text );
	
	sprintf( Text, "var ContentMapData = " );	
	write_GelFile( OutFile, Text, strlen( Text ) );
	
	write_GelFile( OutFile, InData-&gt;Data, InData-&gt;Size );

	sprintf( Text, ";" );	
	write_GelFile( OutFile, Text, strlen( Text ) );
	
	close_GelFile( OutFile );
	delete_DataBlock( InData );
		
	return 0;
}</pre>

The tool was placed alongside the JSON file, so we could simply drag+drop the exported JSON file on top of it to regenerate a usable game map. Oh and my apologies, the above code uses a FileIO library of mine, but what it&#8217;s doing should still make sense. A better tool would generate a type name based on the filename. Me, I hardcoded it to save time and thinking.

Finally, I wrote a series of functions for looking at the data. With the JSON C loader, I would pinpoint the map data and the dimensions of the map file inside the JSON file. I wrote similar functions, one for each piece of data I wanted, and dropped them in to my existing loader code. 

Done. We now had instant file loading, and a way for the artist to change/edit the map and see his changes.

### Graphical Rendering and Performance

Firefox and Chrome both have good profiling tools. If you happen to fire them up, and play the game for about 30 seconds, you&#8217;ll notice a few functions stand out. The one I want us to take note of is &#8220;**_gelDrawTiles**&#8220;. This is a function written in JavaScript that draws a layer of the map. That&#8217;s lots and lots of little 8&#215;8 tiles. The function itself is rather complicated, but it&#8217;s an improvement before. Originally, the C++ code called a function &#8220;**_gelDrawTile**&#8221; (note the lack of S on the end), one for every single tile in the world. At 40 by 30 tiles, by 4 layers, that&#8217;s potentially A LOT of overhead wasted by function calls. Since this draw function was written in JS, it couldn&#8217;t exactly be inlined (as expected in C++).

So, I changed the tilemap layer rendering in to a single function call written in JavaScript.

The map data was located inside the C++ code though, so I had to get a pointer and call an Emscripten provided function &#8220;getValue&#8221; to get the actual data. However, this was a BRAND NEW wasteful excessive function call, so like the author of Emscripten suggests, I went in to the code to see how to access the data I wanted (HEAP16[Pointer+Offset]).

The other heavy functions seen by the profiler relate to the collision detection. While writing this though, I just realized I might be able to improve that, so \*ahem\* disregard them, okay? 🙂

### Standard Template Library &#8211; STL

This isn&#8217;t particularly a speed optimization, but a size one. If you&#8217;ve ever worked with STL as both a C and C++ programmer, you&#8217;ll note that STL adds quite a lot of size to program. It performs well, but depending on the compiler, you can see a whopping 500k to 1MB increase in file size over a C program, or a C++ program simply using your own C++ containers.

If you read above, you&#8217;ll see that I have my own suite of libraries for doing various things. I use C++, but a number of my libraries use a C style aesthetic (or Pure Functions if you&#8217;re in a buzzword mood). So instead of STL, I used my own equivalents and variants.

That said, I&#8217;m not saying don&#8217;t use STL. If you like it, use it. I like it actually, but I&#8217;ve been coding professionally for over a decade now, and have built up my own libraries and ways of doing things. There are some things STL does well, and others STL doesn&#8217;t. I actually was planning to use it at first, but after I saw the code size grow by ~500k, I decided not to.

### RequestAnimationFrame instead of setInterval

This I was informed of after Ludum Dare.

<http://paulirish.com/2011/requestanimationframe-for-smart-animating/>

In my tests, it seemed to make Chrome work a little better.

I did like the elegance of this better though:

<pre class="lang:js decode:true " >IntervalHandle = setInterval( Main_Loop, FrameRate );</pre>

And manipulating the IntervalHandle to stop (lost focus), and restarting it via setInterval again (focus gained).

But hey, the RequestAnimationFrame stuff is supposed to be better.

## Wrapup

That&#8217;s all I can think of at the moment. If there&#8217;s something you want to know about that I didn&#8217;t cover, feel free to ask. I may expand this post accordingly.