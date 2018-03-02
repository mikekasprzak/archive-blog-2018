---
id: 9684
title: 'Notes: Extracting Trailer Videos from Steam for Tweeting'
date: 2017-04-06T15:17:41+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9684
permalink: /2017/04/06/notes-extracting-trailer-videos-from-steam-for-tweeting/
enclosure:
  - |
    http://cdn.akamai.steamstatic.com/steam/apps/256677064/movie_max.webm
    18870557
    video/webm
    
  - |
    http://cdn.akamai.steamstatic.com/steam/apps/256677064/movie480.webm?t=123456789
    7929671
    video/webm
    
  - |
    https://apollo2.dl.playstation.net/cdn/UP1705/CUSA04302_00/FREE_CONTENTqqfjYcD4dq5k8qLLBU5p/PREVIEW_GAMEPLAY_VIDEO_137961.mp4
    34644094
    video/mp4
    
categories:
  - Uncategorized
---
The highest quality video trailer on Steam are typically found here:

<pre class="lang:default decode:true " ><div style="width: 640px;" class="wp-video">
  <!--[if lt IE 9]><![endif]-->
  &lt;video class="wp-video-shortcode" id="video-9684-1" width="640" height="360" preload="metadata" controls="controls">&lt;source type="video/webm" src="http://cdn.akamai.steamstatic.com/steam/apps/256677064/movie_max.webm?_=1" />
  
  <a href="http://cdn.akamai.steamstatic.com/steam/apps/256677064/movie_max.webm">http://cdn.akamai.steamstatic.com/steam/apps/256677064/movie_max.webm</a>&lt;/video>
</div>
</pre>

Where `256677064` is the SteamID of the game. 

When you right click on a trailer video in Chrome, you can select &#8220;**Open Video in New Tab**&#8220;.

<pre class="lang:default decode:true " >http://cdn.akamai.steamstatic.com/steam/apps/256677064/movie480.webm?t=123456789</pre>

The `t=` part is probably some unique ID, such as your Steam UserID.

Edit the URL accordingly, from `movie480.webm` to `movie_max.webm`. Alternatively, full-screening the video, and after waiting a moment for it to go high quality, you can right click on the video and open the High Quality video in a new tab.

Save the file.

The video file is in `webm` format, but Twitter requires an `mp4`.

Twitter makes these recommendations:

<https://dev.twitter.com/rest/media/uploading-media#videorecs>

It&#8217;s worth noting that Twitter requires that videos be under 140 seconds (lol, I see what you did there) and under 512 MB. Fortunately the later shouldn&#8217;t be a problem, but if a trailer is over 2 minutes it could be an issue.

Make sure you have a recent version of FFMpeg installed. If this fails, that&#8217;s probably why.

<pre class="lang:default decode:true " title="to_mp4.sh" >#!/bin/sh

ffmpeg -i $1 -vcodec libx264 -pix_fmt yuv420p -strict -2 -acodec aac $1.mp4
</pre>

I stole the snippet from here:

<https://twittercommunity.com/t/ffmpeg-mp4-upload-to-twitter-unsupported-error/68602/2>

The script is very simple. To use it, give it a file, and after a few minutes it spits out a file with an added .mp4 extension.

<pre class="lang:default decode:true " >./to_mp4.sh infile.webm
# output: infile.webm.mp4</pre>

You should now have a file suitable for tweeting. 

Doing this has the added benefit of not wasting any of Twitter&#8217;s 140 characters per tweet, in addition to videos auto-playing.

## Bonus: PSN Store

The PSN store uses regular MP4&#8217;s that can be tweeted as-is.

Video URLs look like this:

<pre class="lang:default decode:true " ><div style="width: 640px;" class="wp-video">
  &lt;video class="wp-video-shortcode" id="video-9684-2" width="640" height="360" preload="metadata" controls="controls">&lt;source type="video/mp4" src="https://apollo2.dl.playstation.net/cdn/UP1705/CUSA04302_00/FREE_CONTENTqqfjYcD4dq5k8qLLBU5p/PREVIEW_GAMEPLAY_VIDEO_137961.mp4?_=2" /><a href="https://apollo2.dl.playstation.net/cdn/UP1705/CUSA04302_00/FREE_CONTENTqqfjYcD4dq5k8qLLBU5p/PREVIEW_GAMEPLAY_VIDEO_137961.mp4">https://apollo2.dl.playstation.net/cdn/UP1705/CUSA04302_00/FREE_CONTENTqqfjYcD4dq5k8qLLBU5p/PREVIEW_GAMEPLAY_VIDEO_137961.mp4</a>&lt;/video>
</div>
</pre>

Which as you can see is quite unsightly.

If you browse to a page on the PSN store website, open up the developer tools, from the network tab you can filter by **Media**.

[<img src="http://blog.toonormal.com/wp-content/uploads/2017/04/networkypsn.png" alt="" width="576" height="211" class="aligncenter size-full wp-image-9688" srcset="http://blog.toonormal.com/wp-content/uploads/2017/04/networkypsn.png 576w, http://blog.toonormal.com/wp-content/uploads/2017/04/networkypsn-450x165.png 450w" sizes="(max-width: 576px) 100vw, 576px" />](http://blog.toonormal.com/wp-content/uploads/2017/04/networkypsn.png)

With this open, once you **click the play button**, the video file that&#8217;s referenced will appear under Media. Open in its own tab and save it.

## Xbox One Store (No Video)

At the time of this writing, there are no videos on the Microsoft store.

<https://www.microsoft.com/en-us/store/p/candleman/bs95882kbb4f>

Xbox Wire uses YouTube.

http://news.xbox.com/2017/02/01/candleman-available-now-xbox-one/

## Nintendo Switch (HLS)

Find the game page on `Nintendo.com`.

<http://www.nintendo.com/games/detail/snipperclips-switch>

Behind the scenes, unfortunately it appears Nintendo is using a combination of Flash Player and HLS. If you dig in to flash variables you can extract the HLS URL.

<pre class="lang:default decode:true " >http://player.ooyala.com/player/all/l3Y24zYTE6AWXpRYUSetgGgQqI4zBacQ.m3u8</pre>

Through a few levels of HLS responses, you can eventually find video, but my understanding of the protocol is limited. I was able to find a short ~15 second clip without sound, when it should be a full-on few minute HD trailer.