---
id: 3364
title: As expected, twas the Cache
date: 2010-11-10T20:51:01+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3364
permalink: /2010/11/10/as-expected-twas-the-cache/
categories:
  - Smiles
  - Technobabble
---
Not much to say or show, just that the performance problem _was_ due to the textures being larger than the texture cache.

<div id="attachment_3365" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/11/Mac05.jpg"><img src="/wp-content/uploads/2010/11/Mac05-640x399.jpg" alt="" title="Mac05" width="640" height="399" class="size-large wp-image-3365" srcset="http://blog.toonormal.com/wp-content/uploads/2010/11/Mac05-640x399.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac05-450x280.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2010/11/Mac05.jpg 1600w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Under 10% CPU usage, much better
  </p>
</div>

As it is now, on my Mac mini the game runs at under 8% CPU usage in the menus and Zen, and under 10% in Drop. The largest texture is 1024&#215;1024, DXT5 compressed (4:1, or 1 MB). Before it was 1024&#215;1024 uncompressed 32bit RGBA (1:1, or 4 MB). That either means the GMA 950 in these older Mac&#8217;s has 1 MB of cache, or perhaps 2 MB (I didn&#8217;t check with 16bit RGBA textures, but it&#8217;s unlikely).