---
id: 9709
title: 'Notes: Linux video-to-giffing'
date: 2017-06-30T13:39:15+00:00
author: Mike K
layout: post
guid: /?p=9709
permalink: /2017/06/30/notes-linux-video-to-giffing/
categories:
  - Uncategorized
---
References:
  
&#8211; conversion: http://xmodulo.com/convert-video-animated-gif-image-linux.html
  
&#8211; monitor: https://www.imagemagick.org/discourse-server/viewtopic.php?t=15860
  
&#8211; remove every-other: https://stackoverflow.com/a/12604488/5678759

Create a folder, and move the video file in to the folder.

<pre class="lang:default decode:true " ># ffmpeg -t &lt;duration&gt; -ss &lt;starting position in hh:mm:ss format&gt; -i &lt;input_video&gt; out%04d.png
# NOTE: the original output of the article was GIF, but I changed it. Might be a source of problems

ffmpeg -t 5 -ss 00:00:10 -i funny.mp4 out%04d.png
# Starts at 10 seconds, lasts for 5 seconds</pre>

At this point you have files. Viewing the folder should let you see the thumbnails. You can pre and post delete any files you grabbed by accident.

If the images come from an animation, you might want to delete every-other-file.

<pre class="lang:default decode:true " >rm -f *[13579].png</pre>

Next use ImageMagick to build the GIF.

<pre class="lang:default decode:true " ># convert -delay &lt;ticks&gt;x&lt;ticks-per-second&gt; -loop 0 out*png &lt;output-gif-file&gt;

convert -monitor -delay 1x20 -loop 0 out*.png anim.gif</pre>

I added \`-monitor\` myself to see what was happening. In my case it was freezing, hence the need to remove excess frames.

The original article then recommends using ImageMagick again for optimizing, but my file was too big.

Alternatively, gifsicle.

<pre class="lang:default decode:true " ># -O = optimize
# --resize-width = specify a proportional scale

gifsicle -O anim.gif --resize-width 480 -o anim2.gif</pre>