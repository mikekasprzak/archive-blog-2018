---
id: 6456
title: The correct way to SDL_Init
date: 2013-11-15T04:10:32+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6456
permalink: /2013/11/15/the-correct-way-to-sdl_init/
categories:
  - Technobabble
---
By correct, I mean the way that will work across multiple devices, and give you OpenGL (ES) **shaders**.

<pre class="lang:default decode:true " >SDL_Init( SDL_INIT_VIDEO );
 
#ifdef MOBILE    // Some #define of yours that says it's a mobile build. //
SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
#endif // MOBILE //</pre>

If you don&#8217;t need shaders (i.e. OpenGL 1.x, OpenGL ES 1.1), a lone SDL_Init will suffice (default behavior).

<pre class="lang:default decode:true " >SDL_Init( SDL_INIT_VIDEO );</pre>

If you are using SDL\_GL\_LoadLibrary, you \*MUST\* put the calls in the following order.

<pre class="lang:default decode:true " >SDL_Init( SDL_INIT_VIDEO );

#ifdef MOBILE    // Some #define of yours that says it's a mobile build. //
SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES);
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
#endif // MOBILE //

SDL_GL_LoadLibrary( NULL );</pre>

I had to do it this way (between these 2 calls), otherwise Android devices with PowerVR GPUs would not work (Nexus S, Intel powered devices, Kindle Fire?, etc).

That said, I&#8217;m actually not sure of the benefits of SDL\_GL\_LoadLibrary. Removing it from my code works just fine. The documentation suggests having to manually use SDL\_GL\_GetProcAddress as a result of SDL\_GL\_LoadLibrary, which doesn&#8217;t sound cool.

[http://wiki.libsdl.org/SDL\_GL\_LoadLibrary](http://wiki.libsdl.org/SDL_GL_LoadLibrary)

I&#8217;ve noticed I&#8217;ve never had to do this, but I am using an updated version of [GLEE](http://www.opengl.org/sdk/libs/GLee/) (haven&#8217;t switched to [GLEW](http://glew.sourceforge.net/) yet). Huh.

**TL;DR**: Don&#8217;t use SDL\_GL\_LoadLibrary.