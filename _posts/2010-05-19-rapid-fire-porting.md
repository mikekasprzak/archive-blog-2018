---
id: 2592
title: Rapid Fire Porting
date: 2010-05-19T06:14:57+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2592
permalink: /2010/05/19/rapid-fire-porting/
categories:
  - Smiles
  - Technobabble
---
I have a goal of switching my focus entirely to a new project starting in July, which is about 6 weeks away. My 30th birthday is the 6th, so my folks have been joking that&#8217;ll be my gift to myself. Happy Birthday Mike, you can do something else now&#8230; heh.

So to make that happen, I need to power through my list of pending platforms I want to cover, before back-burner&#8217;ing the rest.

Yesterday (between a lunch outing with the folks, and Iron Man 2) I finally sat down and got the Mac port of Smiles up and running.

<div id="attachment_2593" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2010/05/SmilesMac.jpg"><img src="/wp-content/uploads/2010/05/SmilesMac-640x441.jpg" alt="" title="SmilesMac" width="640" height="441" class="size-large wp-image-2593" srcset="/wp-content/uploads/2010/05/SmilesMac-640x441.jpg 640w, /wp-content/uploads/2010/05/SmilesMac-450x310.jpg 450w, /wp-content/uploads/2010/05/SmilesMac.jpg 1335w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Hey look, an actual Mac port... not just one of those running in the simulator ones.
  </p>
</div>

[Phil](http://www.galcon.com) had a few tips for me to make the distribution process go smoother, so it has an icon, bundled frameworks and so on now. In theory I could package up and distribute the game now, assuming I felt it was ready. I have a list of PC/Mac/Linux centric features I want in first, that conveniently Netbooks don&#8217;t need. As-is, the i386 port is fully functional, but the x86-64 crashes. I could just gut the 64bit branch, but I&#8217;m admittedly intrigued by the fact that a 64bit port is nearly working. I&#8217;m going to need that on Linux proper, so I think I&#8217;m going to keep it as a reference build. PPC, I just haven&#8217;t tested yet. It&#8217;s in the tree, but I haven&#8217;t tried it (in either Rosetta or the real thing). I&#8217;m almost 100% sure I have endian-ness issues somewhere.

I took a brief tangent the other day porting Smiles to the recently released [**NativeClient SDK**](http://code.google.com/p/nativeclient-sdk/). That involved porting/fixing my shader based OpenGL 2.0 renderer branch, which now works OpenGL 2.0 and ES 2.0 style. As for the NaCL port, after some effort it does compile, but a few restrictions of the platform had me back-burner it. I rely on Unix style directory searching (or Windows style on Windows and Windows Mobile). That apparently doesn&#8217;t work yet (or wont?). I have a some things in place to allow me to generate a directory listing, and read it from a file, but the next problem convinced me to wait. Also, I&#8217;ll have switch my file reading code to pull data from URL&#8217;s instead of the local file system. All my file-io code is already wrapped, so this isn&#8217;t too hard to do, but admittedly I wasn&#8217;t in the mood to get this up and running.

**NativeClient** is a _very cool_ target platform with a lot of potential. I&#8217;m assuming that&#8217;ll be how you develop native applications for Chromium OS, but if plugin adoption grows, it&#8217;ll be an excellent way to do online game demos for PC/Mac/Linux. It compiles native binaries per CPU architecture (Currently just x86 and x86-64, but there&#8217;s an ARM branch), it features OpenGL ES 2.0, and an interface for streaming audio&#8230; pretty much everything you need. The first (new) release was a little rough in the testing area, so I&#8217;ll probably take a look at it again after another release or two.

The bulk of the past week and a bit has been learning the ins and outs of Linux installers (DEBs and RPMs). I had a rough couple days trying to get [Moblin Package Creator](http://moblin.org/projects/moblin-package-creator) to do the work for me, but I don&#8217;t use AutoConf/Configure or any of that stuff (too messy). My &#8220;savior&#8221; was a oddly named tool named &#8220;checkinstall&#8221;, which tracks all the files you create during a &#8220;make install&#8221; stage, and builds a DEB or RPM containing everything it saw you do. Easy.

That worked great for me, but checkinstall seems to be lacking some details found in RPM&#8217;s. So I ended up capturing the generated spec-file used to generate the RPM, and invoking/building it manually (RPMBuild) with my changes. Technically I don&#8217;t need checkinstall&#8217;s tracking feature, but it&#8217;s nice. I&#8217;m generate the file list for RPMBuild with my tools.

So with that, I now have proper DEB and RPM installers. All that&#8217;s left is getting the icons and symlinks in the right places for each installer format. That&#8217;s it. I suppose I could have finished that by now, but I needed to get my head out of Linux for a day or so. 🙂

My AppUp update for Windows is just pending the Linux/Moblin port. I wanted to be sure there wasn&#8217;t anything new/changed before shipping the Moblin version.

After that, I have 2 more minor ports I&#8217;m looking to get together before the end of the month. I&#8217;ll talk more about them if (and when) I finish.

If everything goes according to plan, we begin the final hoo-rah for Smiles in June. The **_Mystery Platform_** port. It&#8217;s big, and I&#8217;ve been putting it off for far too long. That&#8217;s my June. We&#8217;ll see if [E3](http://www.e3expo.com/) changes anything.

And that&#8217;s it.

The PC/Mac/Linux proper versions of Smiles HD, for my own sanity, will be delayed a bit. The follow up project I&#8217;m planning for the summer I&#8217;m expecting to only take a few months, so I&#8217;ve decided to use that as my catalyst for setting up my store. That store should launch with PC/Mac/Linux versions of my new game, and Smiles.

That&#8217;s the plan. Always subject to change, but hey, that&#8217;s where my head is at right now.