---
id: 6467
title: 'An Experiment: OpenGL Class Targets'
date: 2013-11-15T12:30:09+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6467
permalink: /2013/11/15/an-experiment-opengl-class-targets/
categories:
  - Technobabble
---
According to [the documentation](http://wiki.libsdl.org/SDL_GLattr), SDL\_GL\_CONTEXT\_MAJOR\_VERSION was primarily used to tell SDL which method to use to construct the Window on desktop Open. OpenGL 3.x introduces a new way of context creation, so this would have been used to suggest which way to create (old way or new way). Of course, Mobile needed a way to handle ES 1.1 vs ES 2.0 (and sort-of ES 3.0 too, but so far the ES 3.0 devices are 2.0 compatible).

Rather than just repeat what everyone seems to say and quote, I&#8217;m going to try doing just this.

<pre class="lang:default decode:true " >SDL_Init( SDL_INIT_VIDEO );
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
</pre>

I call this a &#8220;Class 2&#8221; OpenGL target, referring to an OpenGL 2.x or OpenGL ES 2.0 target (i.e. GL with Shaders).

No #ifdefs. Same code across Desktop SDL and Mobile SDL. Hypothetically speaking it should just work, and if not, I&#8217;m not sure why SDL\_GL\_CONTEXT\_PROFILE\_MASK is being anal about its mask bit when there really is only one choice (ES on Mobile, OpenGL on desktop).

The other options would be a &#8220;Class 3&#8221; OpenGL target, i.e. OpenGL 3.x and OpenGL ES 3.0, as well as &#8220;Class 1&#8221; (OpenGL 1.x and OpenGL ES 1.1).

First I need to see if &#8220;Class 2&#8221; works safely across PC and mobile devices (FYI I&#8217;m only testing Windows, Linux and Android). Then I&#8217;m curious if I can set my class to &#8220;Class 3&#8221;, and whether that safely Inits on &#8220;Class 2&#8221; devices.

The point: I&#8217;d like to just do this, and have it work everywhere.

<pre class="lang:default decode:true " >SDL_Init( SDL_INIT_VIDEO );
SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 3);
</pre>

Two lines. It&#8217;s my responsibility to determine if devices even support 3.x features (like it always has been). As far as I know, no hardware optionally goes in to 2.0 mode if 3.0 is available. On desktop GL, you always get the highest version of GL. It&#8217;s on mobile GL that we see a distinct ES 1.1 versus ES 2.0 switch.

If I come across any issues, I&#8217;ll update the post.

## Results: Class 3 will not work on non ES 3.0 mobile devices

Well this was quick. Tried both 2 and 3 on a 2.0 tablet (Galaxy Tab 3), and the 3 setting failed.

Alright then. So the experiment continues with &#8220;2&#8221; always set.

## Results: Class 2

Platforms tested so far:

<pre class="lang:default decode:true " title="Windows: Core i5 with Intel HD 3000 GPU" >// Windows 7 Laptop: Core i5 with Intel HD 3000 GPU
OpenGL Vendor: Intel
OpenGL Renderer: Intel(R) HD Graphics 3000
OpenGL Version: 3.1.0 - Build 9.17.10.3223
OpenGL Shading Language Version: 1.40 - Intel Build 9.17.10.3223
</pre>

<pre class="lang:default decode:true " title="Samsung Galaxy Tab 3 with Intel CPU and PowerVR GPU" >// Samsung Galaxy Tab 3 with Intel CPU and PowerVR GPU
OpenGL Vendor: Imagination Technologies
OpenGL Renderer: PowerVR SGX 544MP
OpenGL Version: OpenGL ES 2.0 build 1.9@2291151
OpenGL Shading Language Version: OpenGL ES GLSL ES 1.00 build 1.9@2291151
</pre>

<pre class="lang:default decode:true " >// Google Nexus 7 (1st Gen) with NVidia Tegra 3 GPU
OpenGL Vendor: NVIDIA Corporation
OpenGL Renderer: NVIDIA Tegra 3
OpenGL Version: OpenGL ES 2.0 14.01003
OpenGL Shading Language Version: OpenGL ES GLSL 1.00
</pre>

<pre class="lang:default decode:true " >// Google Nexus 7 (2nd Gen) with Qualcomm Adreno GPU
OpenGL Vendor: Qualcomm
OpenGL Renderer: Adreno (TM) 320
OpenGL Version: OpenGL ES 3.0 V@14.0 AU@  (CL@)
OpenGL Shading Language Version: OpenGL ES GLSL ES 3.00
</pre>

<pre class="lang:default decode:true " >// ONDA VX610W with ARM Mali GPU
OpenGL Vendor: ARM
OpenGL Renderer: Mali-400 MP
OpenGL Version: OpenGL ES 2.0
OpenGL Shading Language Version: OpenGL ES GLSL ES 1.00
</pre>

<pre class="lang:default decode:true " >// Sony Tablet S with NVidia Tegra 2 GPU
OpenGL Vendor: NVIDIA Corporation
OpenGL Renderer: NVIDIA Tegra
OpenGL Version: OpenGL ES 2.0 14.01002
OpenGL Shading Language Version: OpenGL ES GLSL 1.00
</pre>

<pre class="lang:default decode:true " >// Google Nexus One with Qualcomm Adreno GPU
OpenGL Vendor: Qualcomm
OpenGL Renderer: Adreno 200
OpenGL Version: OpenGL ES 2.0 1044053
OpenGL Shading Language Version: OpenGL ES GLSL ES 1.00
</pre>

<pre class="lang:default decode:true " >// Window/Yuandao N50 with Vivante GPU
OpenGL Vendor: Vivante Corporation
OpenGL Renderer: GC800 core
OpenGL Version: OpenGL ES 2.0
OpenGL Shading Language Version: OpenGL ES GLSL ES 1.00
</pre>

<pre class="lang:default decode:true " >// Amazon Kindle Fire (1st Gen) with PowerVR GPU
OpenGL Vendor: Imagination Technologies
OpenGL Renderer: PowerVR SGX 540
OpenGL Version: OpenGL ES 2.0
OpenGL Shading Language Version: OpenGL ES GLSL ES 1.00
</pre>

<pre class="lang:default decode:true " >// Ouya with NVidia Tegra 3 GPU
OpenGL Vendor: NVIDIA Corporation
OpenGL Renderer: NVIDIA Tegra 3
OpenGL Version: OpenGL ES 2.0 16.05001
OpenGL Shading Language Version: OpenGL ES GLSL 1.00
</pre>

**Untested:** Tegra 2 Development Board, Google G1 (no ES 2.0), Netbooks with Intel GMA (no GL 2.x), PocketTV (MALI 400 MP), Workstation PC with NVidia GPUs (broken), GameStick (MALI 400 MP), AMD Netbook, Zotac w/ NVidia ION, AMD PC, IvyBridge Ultrabook.