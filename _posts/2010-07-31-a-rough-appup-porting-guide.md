---
id: 2912
title: A (rough) AppUp porting guide
date: 2010-07-31T18:14:27+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2912
permalink: /2010/07/31/a-rough-appup-porting-guide/
categories:
  - Smiles
  - Technobabble
---
One of the items on my _seemingly infinite_ TODO list is to write an article about how to port an iPhone game to AppUp. Another item is to rework my blog layout and list all the actually useful content written here. I&#8217;ve yet to do either, but I think I have here a good compromise for the 1st.

I do a-lot of emailing, and this past week I [had a chat with a fellow developer](http://www.lazy8studios.com/) who wanted some advice on porting his game. I sometimes forget about the hours of work that went in to figuring out the the right combination of Unix tools, Windows tools, cross platform libraries, and how to smash them together until they make something that actually works. So I sent him a very _to the point_ list of things that I do.

Sometime after that, I realized I should just post that e-mail.

<!--more-->


  
First of all, I want to point out two posts I made back when I did my original AppUp port of Smiles. The first is a guide on Visual Studio 2008, how to build a project with it if you come from the land of X-Code or Unix tools like make.

</2009/11/14/visual-studio-projects-for-gccmingwxcode-coders/>

And the 2nd is a list of &#8220;annoyances&#8221; I ran in to bringing code written for GCC to MSVC.

</2009/11/15/annoying-differences-between-visual-studio-and-gcc/>

Very briefly: If you want to port your code to non iOS platforms, you&#8217;ll want as much of your code to be in C or C++, and you&#8217;ll want as much of your graphics code as possible to use OpenGL ES (1.1). The number of platforms with shader capable graphics is growing (ES 2.0), but there are still many that aren&#8217;t (PSP, Wii, 3DS, Intel GMA 945). So the high concept &#8220;best of both worlds&#8221; porting advice would be: target fixed function graphics hardware like OpenGL ES 1.1, and write some &#8220;fixed function like&#8221; shaders for those oddball platforms that _only_ do shaders.

[Developing for AppUp](http://appdeveloper.intel.com) right now, you need to use Visual Studio 2008. I actually made my first versions of Smiles for AppUp using the 90 day trial.

[http://www.microsoft.com/blah-blah-blah-numbers-make-horrible-urls](http://www.microsoft.com/downloads/details.Aspx?Familyid=83c3a1ec-Ed72-4a79-8961-25635db0192b&displaylang=en)

That&#8217;s the Pro version (also the _only_ trial available). Once that runs out, I think there are cheaper options (Standard), but I was doing a Windows Mobile 6.5 port around the same time so I needed Pro. And sorry, I **don&#8217;t know** if you can make it work with Express. [MinGW](http://www.mingw.org) is my free compiler of choice, and [may get added](http://appdeveloper.intel.com/en-us/node/381) in a future SDK.

Using Intel&#8217;s AppUp SDK is very straightforward. It includes 2 API&#8217;s: A C style and a C++ style. I opted for the C version, since external C libraries tend to be far easier to work with (OpenGL, zlib). I wrap that in a simple &#8220;Store Validation&#8221; interface class, since validator functions for asking &#8220;am I a legally purchased product?&#8221; seem to be all the rage these days.

The other general advice is &#8220;Use SDL&#8221;, but after the e-mail exchange, I realize that advice alone isn&#8217;t enough.

On to the e-mail!

I&#8217;ve gone ahead and edited-out a few things, but this is for the most part this is what I sent. He started out using SDL 1.3 and an OpenGL ES emulation layer, which I always seem to hear people having troubles with.

> Here&#8217;s some tips:
> 
> 1. Use SDL, but use SDL 1.2. 1.3 is still very new, and not mature yet. Other platforms like Palm&#8217;s webOS also use SDL 1.2, making it an easy port. Actually I&#8217;ve not looked too closely at 1.3, but 1.2 has prebuilt libraries making installing very easy:
> 
> <http://www.libsdl.org/download-1.2.php>
> 
> 2. Use ordinary OpenGL. The actual difference between OpenGL 1.5 and OpenGL ES 1.1, at least if you&#8217;re coming from ES, is ES has a couple functions with F&#8217;s on the end (glProjectionf, glOrthof, and I forget the rest). Bottom line, it&#8217;s actually a really short list. So you can maintain a build that&#8217;s both OpenGL ES 1.1 and OpenGL 1.5 with just a couple #ifdefs.
> 
> MSVC 2008 ships with OpenGL 1.1 headers. To fill in the gaps, the easy way is just grab GLee, and add its 2 files to your project (GLee.c, GLee.h). Just include the header after &#8220;gl.h&#8221;, and you&#8217;re laughing.
> 
> <http://www.opengl.org/sdk/libs/GLee/>
> 
> When you&#8217;re finishing up, if you used the prebuilt SDL libraries, you&#8217;ll need a version of SDLmain.lib that doesn&#8217;t try to write standard output to a file. I have a compiled version of that here:
> 
> [http://junk.mikekasprzak.com/Research/MSVC/SDLmain\_NO\_STDIO.lib](http://junk.mikekasprzak.com/Research/MSVC/SDLmain_NO_STDIO.lib)
> 
> As for other libraries, in some cases I&#8217;m using SDL_Mixer:
> 
> <http://www.libsdl.org/projects/SDL_mixer/>
> 
> But there&#8217;s a weird bug that causes my OGG files to sound noisy after they loop. So on Windows I&#8217;m using IrrKlang, just because I didn&#8217;t want to wait for the SDL people to fix that bug.
> 
> <http://www.ambiera.com/irrklang/>
> 
> That costs money depending on your current level of indieness. It outright replaces all SDL audio code.
> 
> On other platforms (Bada/iPhone) I&#8217;m using whatever native way to stream music is good, with my own (simple) sound effect mixer.

Now the only thing not covered is how to build an .MSI installer using Visual Studio 2008. Actually just last week I built 2 more Smiles Windows SKU&#8217;s for Intel (meaning 2 Visual Studio projects and installers from scratch), but I forgot all about documenting the process. Oops!

Finally, a bonus link (since I know how troublesome it can be to find the real content here). If you&#8217;ve decided to do a Linux (Moblin/MeeGo) AppUp version, you need to make some installers. Here&#8217;s what I did:

</2010/05/22/creating-linux-installers-deb-and-rpm/>

So that&#8217;s my rough guide. Best of luck getting your games on AppUp.