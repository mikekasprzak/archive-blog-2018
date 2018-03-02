---
id: 1138
title: The book is real, and more
date: 2009-06-15T17:10:59+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=1138
permalink: /2009/06/15/the-book-is-real-and-more/
categories:
  - In The Media
  - Smiles
  - Writing
---
First on the agenda, the book is real.

[<img src="/wp-content/uploads/2009/06/iphonebookisreal-450x271.jpg" alt="iphonebookisreal" title="iphonebookisreal" width="450" height="271" class="aligncenter size-medium wp-image-1140" srcset="http://blog.toonormal.com/wp-content/uploads/2009/06/iphonebookisreal-450x271.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2009/06/iphonebookisreal-1024x617.jpg 1024w, http://blog.toonormal.com/wp-content/uploads/2009/06/iphonebookisreal.jpg 1044w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2009/06/iphonebookisreal.jpg)

As you can see above, my three complimentary copies showed up in the mail today. Word from the [_Dread Pirate_](http://twitter.com/dreadpiratepj) himself (i.e. Lead Author/Tech Reviewer) is the books should be en route, if not already arriving at book stores all over the place. After all, the guy in Canada got his. 😉

&#8211; &#8211; &#8211; &#8211; &#8211;

Next, a Smiles update.

Smiles 1.2 is coming. It was sent to Apple Sunday afternoon. I imagine the queue is quite large at the moment, so I&#8217;d give it a week+ before it goes live. Smiles Zen, Smiles Drop, and Free Smiles 1.2&#8217;s will follow in the coming days.

Firmware 3.0 and the new iPhone launches at the end of the week, so I&#8217;ve made some appropriate compatibility updates to the game. There was a notable visual stuttering glitch seen on early firmware 3.0 beta&#8217;s. The same glitch I previously came across when testing the game on Intel GMA graphics cards. It seemed to go away in the final 3.0 firmware, but it&#8217;s an easy enough and forward compatible fix that I&#8217;ve included it anyways. At least this way it&#8217;s fixed for good.

For developers, the glitch can be best described as a triple buffering artifact, swapping buffers in a frame skipping situation when you draw nothing to a buffer. The fix being not to swap when you&#8217;ve drawn nothing. The &#8220;swap&#8221; on iPhone OS being:

`[context presentRenderbuffer:GL_RENDERBUFFER_OES];`

So, that&#8217;s included in 1.2. In addition, I&#8217;ve had a fix since GDC that actually improves the touch responsiveness of the game. It fared well on the show floor and in all my tests, but was hoping to include &#8220;something else&#8221; in the upcoming update, so I&#8217;ve been sitting on it for a while. One thing lead to another, book stuff, new project stuff, that it was just never submitted&#8230; until now.

And that&#8217;s pretty much everything. It&#8217;s a maintenance update, but familiar players should notice it feeling easier to play.

&#8211; &#8211; &#8211; &#8211; &#8211;

Smiles makes a brief appearance at WWDC, via the App Wall. Big thanks to [Jay](http://www.loomsoft.net/) for meticulously searching the wall for me.

[<img src="/wp-content/uploads/2009/06/smilesatwwdc2009-337x450.jpg" alt="smilesatwwdc2009" title="smilesatwwdc2009" width="337" height="450" class="aligncenter size-medium wp-image-1163" srcset="http://blog.toonormal.com/wp-content/uploads/2009/06/smilesatwwdc2009-337x450.jpg 337w, http://blog.toonormal.com/wp-content/uploads/2009/06/smilesatwwdc2009.jpg 600w" sizes="(max-width: 337px) 100vw, 337px" />](/wp-content/uploads/2009/06/smilesatwwdc2009.jpg)

Also, Smiles Drop snuck in to the gallery from another site. See the far left side for a very &#8220;not red&#8221; icon.

[<img src="/wp-content/uploads/2009/06/appwallwithdrop-450x337.jpg" alt="appwallwithdrop" title="appwallwithdrop" width="450" height="337" class="aligncenter size-medium wp-image-1165" srcset="http://blog.toonormal.com/wp-content/uploads/2009/06/appwallwithdrop-450x337.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2009/06/appwallwithdrop.jpg 630w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2009/06/appwallwithdrop.jpg)

&#8211; &#8211; &#8211; &#8211; &#8211;

Also, [Towlr](http://www.towlr.com) might be showing up at minimalist game exhibit soon. Once/if that happens, then I&#8217;ll have the validation necessary to be able to play the role of pretentious art-game developer. 😀

&#8211; &#8211; &#8211; &#8211; &#8211;

As for the new project, the plan was and still is to talk about it more on the blog. I scrapped a few post drafts since it&#8217;s a little tricky to talk about at this point. Technically it&#8217;s a pretty dramatic change from my usual 2D game fare, seeing how it&#8217;s actually a fixed perspective 3D game now. It conceptually began as a 2D game, but made far more sense to be 3D. So the majority of my work the past month+ has been a combination of 3D homework and experimentation (shaders, decals), tools (exporter), and such.

The goal was to be far enough along to be working on content starting at the end of this month, but I&#8217;ve fallen behind. I&#8217;ll talk more about this soon.

And that&#8217;s it for now.