---
id: 6673
title: 4K, HDMI, and Deep Color
date: 2014-01-10T17:16:39+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6673
permalink: /2014/01/10/4k-hdmi-and-deep-color/
categories:
  - Technobabble
---
As of this writing (January 2014), there are 2 HDMI specifications that support 4K Video (3840&#215;2160 16:9). HDMI 1.4 and HDMI 2.0. As far as I know, there are currently no HDMI 2.0 capable TVs available in the market (though many were announced at CES this week).

<div id="attachment_6674" style="max-width: 445px" class="wp-caption aligncenter">
  <a href="http://www.hdmi.org/manufacturer/hdmi_2_0/index.aspx"><img src="/wp-content/uploads/2014/01/HDMI2.png" alt="Comparing HDMI 1.4 (Black text) and 2.0 (Orange). Source: HDMI 2.0 FAQ on HDMI.org" width="435" height="327" class="size-full wp-image-6674" /></a>
  
  <p class="wp-caption-text">
    Comparing HDMI 1.4 (Black text) and 2.0 (Orange). Source: HDMI 2.0 FAQ
  </p>
</div>

A detail that tends to be neglected in all this 4K buzz is the Chroma Subsampling. If you&#8217;ve ever compared an HDMI signal against something else (DVI, VGA), and the quality looked worse, one of the reasons is because of Chroma Subsampling (for the other reason, see **xvYCC** at the bottom of this post). 

Chroma Subsampling is extremely common. Practically every video you&#8217;ve ever watched on a computer or other digital video player uses it. As does the JPEG file format. That&#8217;s why we GameDevs prefer formats like PNG that don&#8217;t subsample. We like our source data raw and pristine. We can ruin it later with subsampling or other forms of texture compression (DXT/S3TC).

In the land of Subsampling, a descriptor like **4:4:4** or **4:2:2** is used. Images are broken up in to 4&#215;2 pixel cells. The descriptor says how much color (chroma) data is lost. **4:4:4** is the perfect form of Chroma Subsampling. Chroma Subsampling uses the **YCbCr** color space (sometimes called YCC) as opposed to the standard RGB color space.

<div id="attachment_6676" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2014/01/ChromaSubSampling.png"><img src="/wp-content/uploads/2014/01/ChromaSubSampling-640x180.png" alt="Great subsampling diagram from Wikipedia, showing the different encodings mean" width="640" height="180" class="size-large wp-image-6676" srcset="http://blog.toonormal.com/wp-content/uploads/2014/01/ChromaSubSampling-640x180.png 640w, http://blog.toonormal.com/wp-content/uploads/2014/01/ChromaSubSampling-450x126.png 450w, http://blog.toonormal.com/wp-content/uploads/2014/01/ChromaSubSampling.png 965w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Great subsampling diagram from <a href="http://en.wikipedia.org/wiki/Chroma_subsampling#Sampling_systems_and_ratios">Wikipedia</a>, showing the different encodings mean
  </p>
</div>

Occasionally the term &#8220;**4:4:4 RGB**&#8221; or just &#8220;**RGB**&#8221; is used to describe the standard RGB color space. Also note, Component Video cables, though they are colored red, green, and blue, are actually <u>YPbPr</u> encoded (the Analog version of YCbCr).

Looking at the first diagram again, we can make a little more sense of it.

<center>
  <a href="http://www.hdmi.org/manufacturer/hdmi_2_0/index.aspx"><img src="/wp-content/uploads/2014/01/HDMI2.png" alt="Comparing HDMI 1.4 (Black text) and 2.0 (Orange). Source: HDMI 2.0 FAQ on HDMI.org" width="435" height="327" class="size-full wp-image-6674" /></a>
</center>

In other words: 

  * HDMI 1.4 supports **8bit RGB**, **8bit 4:4:4** YCbCr, and **12bit 4:2:2** YCbCr, all at 24-30 FPS
  * HDMI 2.0 supports **RGB** and **4:4:4** in all color depths (8bit-16bit) at 24-30 FPS
  * HDMI 2.0 only supports **8bit RGB** and **8bit 4:4:4** at 60 FPS
  * All other color depths require Chroma Subsampling at 60 FPS in HDMI 2.0
  * Peter Jackson&#8217;s 48 FPS (The Hobbit&#8217;s &#8220;High Frame Rate&#8221; HFR) is notably absent from the spec
</strong> </ul> 

Also worth noting, the most well supported color depths are **8bit** and **12bit**. The 12 bit over HDMI is referred to as **Deep Color** (as opposed to High Color).

The HDMI spec has supported only **4:4:4** and **4:2:2** since HDMI 1.0. As of HDMI 2.0, it also supports **4:2:0**, which is available in HDMI 2.0&#8217;s 60 FPS framerates. Blu-ray movies are encoded in 4:2:0, so I&#8217;d assume this is why they added this.

All this video signal butchering does beg the question: Which is the better trade off? More color range per pixel, or more pixels with color channels?

I have no idea.

If I was to guess though, because TV&#8217;s aren&#8217;t right in front of your face like a Computer Monitor, I&#8217;d expect 4K 4:2:2 might actually be better. Greater luminance precision, with a bit of chroma fringing.

Some Plasma and LCD screens use something called [Pentile Matrix](http://en.wikipedia.org/wiki/PenTile_matrix_family) arrangement of their red, green, and blue pixels.

<div id="attachment_6726" style="max-width: 460px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2014/01/Pentile.jpg"><img src="/wp-content/uploads/2014/01/Pentile-450x337.jpg" alt="The AMOLED screen of the Nexus One" width="450" height="337" class="size-medium wp-image-6726" srcset="http://blog.toonormal.com/wp-content/uploads/2014/01/Pentile-450x337.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2014/01/Pentile.jpg 640w" sizes="(max-width: 450px) 100vw, 450px" /></a>
  
  <p class="wp-caption-text">
    The AMOLED screen of the Nexus One. A green for every pixel, but every other pixel is a blue, switching red/blue order every line. Not all AMOLED screens are Pentile. The Super AMOLED Plus screen found in the PS Vita uses a <a href="http://www.edepot.com/playstation.html#PSP2_Video">standard RGB layout</a>
  </p>
</div>

So even if we wanted more color fidelity per individual pixel, it may not be physically there.

## Deep Color

Me, my latest graphics fascination is **Deep Color**. Deep Color is the marketing name for more than 8 bits per pixel of a color. It isn&#8217;t necessarily something we need in asset creation (not me, but some do want full 16bit color channels). But as we start running filters/shaders on our assets, stuff like HDR (but more than that), we end up losing the quality of the original assets as they are re-sampled to fit in to an 8bit RGB color space. 

This can result in banding, especially in near flat color gradients.

<div id="attachment_6696" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2014/01/Banding.jpg"><img src="/wp-content/uploads/2014/01/Banding.jpg" alt="From Wikipedia" width="640" height="371" class="size-full wp-image-6696" srcset="http://blog.toonormal.com/wp-content/uploads/2014/01/Banding.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2014/01/Banding-450x260.jpg 450w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    From <a href="http://en.wikipedia.org/wiki/Color_banding">Wikipedia</a>, though it&#8217;s possible the banding shown may be exaggerated
  </p>
</div>

Photographers have RAW and HDR file formats for dealing with this stuff. We have Deep Color, in all its **30bit** (10bpp), **36bit** (12bpp) and **48bit** (16bpp) glory. Or really, just **36bit (12bpp)**, but 48bit can be used as a RAW format if we wanted.

So the point of this nerding: An ideal display would be **4K**, support **12bit RGB** or **12bit YCbCr**, at **60 FPS**.

The thing is, **HDMI 2.0 doesn&#8217;t support it**!

Perhaps that&#8217;s fine though. Again, HDMI is a television spec. Most television viewers are watching video, and practically all video is 4:2:0 encoded anyway (which is supported by the HDMI 2.0 spec). The problem is gaming, where our framerates can reach 60FPS.

**The HDMI 2.0 spec isn&#8217;t up to spec.** 😉

Again this is probably fine. The now-current generation of consoles, nobody is really pushing them as 4K machines anyway. Sony may have 4K video playback support, but most high end games are still targeting 1080p and even 720p. 4K is 4x the pixels of 1080p. I suppose it&#8217;s an advantage that 4K only supports 30FPS right now, meaning you only need to push 2x the data to be a &#8220;4K game&#8221;, but still.

HDMI Bandwidth is rated in [Gigabits per second](http://en.wikipedia.org/wiki/HDMI#Version_comparison).

  * HDMI 1.0->1.2: **~4 Gb**
  * HDMI 1.3->1.4: **~8 Gb**
  * HDMI 2.0: **~14 Gb** (NEW)

Not surprisingly, 4K 8bit 60FPS is **~12 Gb** of data, and 30FPS is **~6 Gb** of data. Our good friend **4K 12bit 60FPS** though is **~18 Gb** of data, well above the limits of HDMI 2.0.

To compare, [Display Port](http://en.wikipedia.org/wiki/DisplayPort).

  * DisplayPort 1.0 and 1.1: **~8 Gb**
  * DisplayPort 1.2: **~17 Gb**
  * DisplayPort 1.3: **~32 Gb** (NEW)

They&#8217;re claiming 8K and 4K@120Hz (FPS) support with the latest standard, but 18 doesn&#8217;t divide that well in to 32, so somebody has to have their numbers wrong (admittedly I did not divide mine by 1024, but 1000). Also since 8k is 4x the resolution of 4K, and the bandwidth only roughly doubled, practically speaking DisplayPort 1.3 can only support **8k 8bit 30FPS**. Also that 4K@120Hz is **4K 8bit 120FPS**. Still, if you don&#8217;t want 120FPS, that leaves room for **4K 16bit 60FPS**, which should be more than needed (12bit). I wonder if anybody will support **4K 12bit 90FPS** over DisplayPort?

And that&#8217;s 4K.

## 1080p and 2K Deep Color

Today 1080p is the dominant high resolution: 1920&#215;1080. To the film guys, true 2K is 2048&#215;1080, but there are a wide variety of devices in the same range, such as 2560&#215;1600 and 2560&#215;1440 (4x 720p). These, including 1080p, are often grouped under the label [2K](http://en.wikipedia.org/wiki/2K_resolution). 

A second of **1080p 8bit 60FPS** data requires **~3 Gb** of bandwidth, well within the range supported by the original HDMI 1.0 spec (though why we even had to deal with 1080i is a good question, probably due to the inability to even meet the HDMI spec).

To compare, a second of **1080p 12bit 60FPS** data requires ~4.5 Gb of bandwidth. Even **1080p 16bit 60FPS** needed only ~6 Gb, well within the range supported by HDMI 1.3 (where Deep Color was introduced). Plenty of headroom still. Only when we push **2560&#215;1440 12bit 60FPS** (~8 Gb) do we hit the limits of HDMI 1.3.

So from a specs perspective, I just wanted to note this because **Deep Color** and **1080p** are reasonable to support on now-current generation game consoles. Even the PlayStation 3, by specs, supported this. High end games probably didn&#8217;t have enough processing to spare for this, but it&#8217;s something to definitely consider supporting on PlayStation 4 and Xbox One. As for PC, many current GPUs support Deep Color in full-screen resolutions. Again, full-screen, not necessarily on your Desktop (i.e. windowed). From what I briefly read, Deep Color is only supported on the Desktop with specialty cards (FirePro, etc).

## One more thing: YCrCb (YCC) and xvYCC

You make have noticed watching a video file that the blacks don&#8217;t look very black.

Due to a horrible legacy thing (CRT displays), data encoded as YCrCb use values from 16->240 (15-235?) instead of 0->255. Thats quite the loss, nearly 12% of the available data range, effectively lowering the precision below 8bit. The only reason it&#8217;s still done is because of old CRT televisions, which can be really tough to find these days. Regrettably, that does mean both of the original DVD and Bluray movies standards were forced to comply to this.

Sony proposed [x.v.Color (xvYCC)](http://en.wikipedia.org/wiki/XvYCC) as a way of finally forgetting this stupid limitation of old CRT displays, and using the full 0->255 range. As of HDMI 1.3 (June 2006), **xvYCC** and **Deep Color** are part of the HDMI spec.

Several months later (November 2006), **The PlayStation 3** was launched. So as a rule of thumb, only HDMI devices newer than the PlayStation 3 will could potentially support xvYCC. This means televisions, audio receivers, other set top boxes, etc. It&#8217;s worth noting that some audio receivers may actually clip video signals to the 16-240 range, thus ruining picture quality of an xvYCC source. Also the PS3 was eventually updated to HDMI 1.4 via a software update, but the only 1.4 feature supported is Stereoscopic 3D.

[Source](http://www.audioholics.com/home-theater-calibration/hdmi-black-levels-xvycc-rgb). [Wikipedia](http://en.wikipedia.org/wiki/XvYCC).

The point of bringing this up is to further emphasize the potential for color banding and terrible color reproduction over HDMI. An 8bit RGB framebuffer is potentially being compressed to fit within the YCbCr 16-240 range before it gets sent over HDMI. The PlayStation 3 has a setting for enabling the full color range (I forget the name used), and other new devices probably do to (unlikely named xvYCC).

According to Wikipedia, all of the Deep Color modes supported by HDMI 1.3 are xvYCC, as they should be.