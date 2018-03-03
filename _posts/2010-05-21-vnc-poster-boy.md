---
id: 2629
title: VNC Poster Boy
date: 2010-05-21T09:07:44+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2629
permalink: /2010/05/21/vnc-poster-boy/
categories:
  - In The Media
  - Smiles
  - Technobabble
---
Heh, I certainly wasn&#8217;t expecting this.

<div id="attachment_2630" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/05/VNCMike.jpg"><img src="/wp-content/uploads/2010/05/VNCMike-640x493.jpg" alt="" title="VNCMike" width="640" height="493" class="size-large wp-image-2630" srcset="/wp-content/uploads/2010/05/VNCMike-640x493.jpg 640w, /wp-content/uploads/2010/05/VNCMike-450x347.jpg 450w, /wp-content/uploads/2010/05/VNCMike.jpg 1451w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Pay no attention to the grammar tense of the first sentence
  </p>
</div>


  
RealVNC has a rotating twitter quotes on their front page, and it seems I&#8217;m now part of the rotation.

And yes, that is a real quote; I do think VNC is awesome. Admittedly, I&#8217;ve been using [UltraVNC](http://www.uvnc.com/) on my PC&#8217;s recently, though I do run their iPhone client. 😉

Thanks for the tip [Adam](http://whootek.com/).

&#8211; &#8211; &#8211;

<div id="attachment_2771" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/05/NetbookSmiles.jpg"><img src="/wp-content/uploads/2010/05/NetbookSmiles-640x605.jpg" alt="" title="NetbookSmiles" width="640" height="605" class="size-large wp-image-2771" srcset="/wp-content/uploads/2010/05/NetbookSmiles-640x605.jpg 640w, /wp-content/uploads/2010/05/NetbookSmiles-450x425.jpg 450w, /wp-content/uploads/2010/05/NetbookSmiles.jpg 889w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Moblin 2.1 running on the USB key
  </p>
</div>

I *_FINALLY_* submitted my [Moblin](http://www.moblin.org) (Linux) AppUp port of Smiles late last night. I planned on having this done a week or two ago, but between other things and some hardware I had to pick up (more USB keys), I still had a bunch to learn about Linux itself. I&#8217;ve had my game code running on Linux since the beginning (I needed it, since my laptop was a Acer Aspire One Netbook running Linpus), but creating a proper RPM and DEB bundle for distribution was something I never tackled. Heck, I didn&#8217;t even know where to put my files. 😉

So with the installer hurdle out of the way, all that&#8217;s left in the land of Linux is to tackle 64bit binaries. What Moblin provides is a pretty good [baseline GCC+Libraries collection](http://moblin.org/projects/moblin-sdk-tools-and-toolchain), that should be compatible with any notable 32bit distros out there today. I ran in to issues running the Ubuntu 10 compiled binary on Moblin, but the GCC version and libraries included in the [Moblin SDK](http://moblin.org/projects/moblin-sdk-tools-and-toolchain) worked well across both. For the future, I need to find a good baseline 64bit Linux for creating my 64bit binaries. It&#8217;s not something I can do right now (not comfortably), since my test machines (older Atom Netbooks) don&#8217;t support 64bit instructions. I think the newer Atom chips might, so I&#8217;ll have to grab one of those some day.

Next on the agenda is my update for Windows AppUp. With 1.0 I neglected to add my game to the Vista/7 game launcher. I figured out how to do it last time, but the game had a startup bug from the launcher I was trying to avoid, so I pulled it. Also there was a metadata XML file that Microsoft suggests you create, and I really wasn&#8217;t in the mood to write it. I&#8217;m not vying for a Microsoft &#8220;Games For Windows&#8221; certification right now, so I&#8217;ll probably ignore that metadata file again, but this time I&#8217;ll at least add myself to the game launcher (now that my bug is fixed).

That&#8217;ll do for now. Really, I just wanted to post the weird discovery of me on the RealVNC website. 🙂