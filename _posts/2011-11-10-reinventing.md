---
id: 4633
title: Reinventing
date: 2011-11-10T00:30:42+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4633
permalink: /2011/11/10/reinventing/
categories:
  - Alone, The
  - Technobabble
  - The Business of Things
---
Enough of this non-game talk.

The past month has been extremely good for progress. I did not meet my goal for the month, but I&#8217;d be silly to complain. Yadda yadda ya.

Against my better judgement, I&#8217;m going to stop beating around the bush and show you:

<div id="attachment_4634" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/11/Tease01.png"><img src="/wp-content/uploads/2011/11/Tease01-640x356.png" alt="" title="Tease01" width="640" height="356" class="size-large wp-image-4634" srcset="/wp-content/uploads/2011/11/Tease01-640x356.png 640w, /wp-content/uploads/2011/11/Tease01-450x250.png 450w, /wp-content/uploads/2011/11/Tease01.png 1051w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    A mish-mash or random objects sitting in some sculpted terrain. Subtle glow. Vignette blur.
  </p>
</div>

> _That&#8217;s cool Mike, but what is it?_

Tech.

> _Wait Mike, you could have done that in a day using Unity? It would be faster!_

So? What&#8217;s your point?

I&#8217;m a fairly capable (and technical) coder, and something I&#8217;ve wanted to do was code the 3D tech for a game. What I have after a month is nowhere near as cool as Unity or UE3, but it is comfortable and capable for me. So yes, I&#8217;m working in C++ writing OpenGL rendering code and shaders. Why? Because that&#8217;s what I&#8217;m comfortable in.

Oh, and it runs on mobile too.

<div id="attachment_4643" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/11/Tease02.jpg"><img src="/wp-content/uploads/2011/11/Tease02-640x480.jpg" alt="" title="Tease02" width="640" height="480" class="size-large wp-image-4643" srcset="/wp-content/uploads/2011/11/Tease02-640x480.jpg 640w, /wp-content/uploads/2011/11/Tease02-450x337.jpg 450w, /wp-content/uploads/2011/11/Tease02.jpg 1204w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Running on a low cost (~$100) Chinese Android device featuring an ARM MALI-400 GPU
  </p>
</div>

There really isn&#8217;t any significance to this above device, aside from the cost, or perhaps its own insignificance. Like what Smiles became, I&#8217;m testing my code across a plethora of modern devices as I go along.

I am not particularly targeting this for Moblie. If anything, PC is my primary target. In working on the tech though, I&#8217;ve found that by changing the target platform regularly, I find issues with code that I would not have discovered until much later.

My regular test devices include:
  
&#8211; PC (Windows Desktop) with an **NVidia GeForce GTS 240 GPU** (custom, my workstation)
  
&#8211; PC (Windows Desktop) with an **AMD Radeon HD 6670 GPU** (custom, my standing desk PC)
  
&#8211; PC (Windows Notebook) with an **Intel HD 3000 GPU** (Lenovo X220, my laptop)
  
&#8211; Phone (Android) with a **PowerVR SGX 540 GPU** (Nexus S, and my phone)
  
&#8211; Tablet (Android) with an **ARM MALI 400 GPU** (Onda VX610W)
  
&#8211; Tablet (Android) with a **Vivante GS800 GPU** (Window N50 DT)
  
&#8211; Tablet (webOS) with a **Qualcomm Adreno 220 GPU** (HP TouchPad)

Notably absent are iOS devices and a device featuring a Tegra 2, but as you can see the goal here was to cover every serious GPU vendor today. I&#8217;m currently only interested in shader capable GPUs that benchmark equal or faster than an iPhone 3GS (PowerVR SGX 535). At the present time, there are no plans to support fixed function rendering (Intel GMA 945, PowerVR MBX, Wii, PSP).

The thought is by having a device on hand featuring every major GPU, I&#8217;ll be able to find the most ideal and cross platform friendly way to render things. I would still like to get my hands on an NVidia Tegra based Tablet, a PlayBook, an Xperia Play, and something with a parallax barrier display. But unless I can find one stupid cheap ($100), I wont be buying them any time soon.

Though I have all these devices and am regularly testing against them, I&#8217;m not optimizing for mobile yet. Yes, I will eventually do tablet and mobile versions, but I am starting with the PC. The variety of devices are here as a sanity test for my code. If it runs everywhere, unplayable framerates aside, then it works.

> _That&#8217;s cool Mike, I see you&#8217;re still a porting nerd. </p> 
> 
> What are you actually making though?</em></blockquote> 
> 
> I&#8217;ll tell you when you&#8217;re older.
> 
> > _Oh come on!_
> 
> Alright, here&#8217;s a mockup I made back in 2009.
> 
> <div id="attachment_4665" style="max-width: 650px" class="wp-caption aligncenter">
>   <a href="/wp-content/uploads/2011/11/Mockup18.jpg"><img src="/wp-content/uploads/2011/11/Mockup18-640x512.jpg" alt="" title="Mockup18" width="640" height="512" class="size-large wp-image-4665" srcset="/wp-content/uploads/2011/11/Mockup18-640x512.jpg 640w, /wp-content/uploads/2011/11/Mockup18-450x360.jpg 450w, /wp-content/uploads/2011/11/Mockup18.jpg 720w" sizes="(max-width: 640px) 100vw, 640px" /></a>
>   
>   <p class="wp-caption-text">
>     Apparently I've been designing and redesigning this game since before I started Smiles
>   </p>
> </div>
> 
> That but better.
> 
> > _What does the post title mean?_
> 
> Reinventing? Apparently a few things.
> 
> The main one is how I typically work. I was going to sit on this, wait and keep working until it was just right, then do a big push. That sucks. It takes forever and I build no buzz/interest prior to the launch of the game. So fine, lets not repeat Smiles&#8217; mistakes.
> 
> The other is that I&#8217;m building a story driven game. I have a story I want to tell inside a game world, and I still plan to do this. However, it&#8217;s going to take me a while to get that far. According to my latest math, the soonest I&#8217;d be able to release was going to be early 2013. Yuck.
> 
> So let&#8217;s change that.
> 
> Now this doesn&#8217;t mean I&#8217;ll be releasing something tomorrow, but the plan is to make something available publicly **far** sooner. My goal is still to make this story driven game, but I&#8217;m going to make another game too, using much of the same content. In a sense, an expanded testsuite for the game I want to create. Less focus on the continuity, but a definite focus on how it plays, how it looks, and in time entertaining in its own right.
> 
> This here is the first step. Hello, yes, I am working on something. And over the next few months, it&#8217;ll start becoming something.