---
id: 4497
title: I am running a Synology NAS now
date: 2011-08-23T22:29:40+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4497
permalink: /2011/08/23/i-am-running-a-synology-nas-now/
categories:
  - Technobabble
  - The Business of Things
---
[<img alt="" src="/content/newserver.jpg" class="alignright" width="350" height="287" />](/2006/10/07/new-server-aka-i-killed-a-cisco/)Last week, a drive [in my server died](/2006/10/07/new-server-aka-i-killed-a-cisco/). These drives weren&#8217;t really that old, but were Seagate&#8217;s from the [drive failing epidemic](http://www.theinquirer.net/inquirer/news/1050374/seagate-barracuda-7200-drives-failing) a few years back. I bought 6 drives around this time, 4 for the server in a RAID 10 array, 2 for my workstation. I lost 1 to the failure problem, and the rest I managed to get updated firmwares installed in time.

Since then, I have been extremely leery of Seagate drives. My server ran Windows XP (yes), and used the on-board Intel SATA RAID controller of this MOBO. On several occasions, the RAID integrity would fail for no good reason upon bootup, that I simply stopped turning my server off.

My brother the &#8220;professional network admin&#8221; has been reminding me for years that Software Linux RAID is the best RAID. So after this tragic failure (no data lost, just some hair), it was time for something different.

My brother and I have been talking NAS (Network Attached Storage) devices for a while, he himself trying a few over the years, to really sub-par results. Generally, the prices were terrible for completely sub par hardware that couldn&#8217;t perform. Popular NAS like the Drobo start at like $700, yuck! The best bang for buck always seemed to be building a server.

Actually, bang for buck wise, building your own file server is still cheaper. But Linux is a delicate mistress. I am a coder, and dealing with game console development tools and Linux setups over the years has taught me how to live comfortably in Linux. I work on Windows though, just I do it with Cygwin and MinGW/MSys.

That aside, there is still too much sh*t to learn about Linux. Time is money. Building and maintaining another server, I&#8217;ll be honest, I don&#8217;t want to do it ([FreeNAS](http://www.freenas.org/) was suggested on my Twitter, for anyone in a more adventurous mood).

It&#8217;s 2011, give me a drop in solution that&#8217;s cheap, small, fast and good!

[<img src="/wp-content/uploads/2011/08/IMG_20110823_214643-150x150.jpg" alt="" title="IMG_20110823_214643" width="150" height="150" class="alignleft size-thumbnail wp-image-4505" />](/wp-content/uploads/2011/08/IMG_20110823_214643.jpg)**Blam!** Hello [Synology DS211j](http://www.synology.com/products/product.php?product_name=DS211j&lang=enu)!

This 2 drive consumer model rakes in at around $200, size not much larger than an eternal casing, and sporting a 1.2 GHz ARM processor. ARM! Hey! I know those!

It runs a breed of Linux, interfaces via gorgeous fast HTML UI, and support fancy Linux favorites like SSH out-of-the-box. Well not quite out-of-the-box, as you do need to download the latest firmware and a setup tool for your OS, but that&#8217;s easy.

Mine I filed with a pair of 3TB Hitachi Deskstar drives, spinning at 7200 RPMS with 64 MB of cache. Western Digital Caviar Green drives were $40 cheaper each, but are known to be slow and problematic on RAIDs (though there are fixes, a tool WDidle3 seems to address this). Again, time is da mon-nay, and wanted something I could just drop in. Benchmarks said these drives were better overall performers too, so hey, why not!

<div id="attachment_4511" style="max-width: 520px" class="wp-caption aligncenter">
  <a href="http://www.synology.com/us/products/demo/index.php"><img src="/wp-content/uploads/2011/08/main1.jpg" alt="" title="main1" width="510" height="347" class="size-full wp-image-4511" srcset="/wp-content/uploads/2011/08/main1.jpg 510w, /wp-content/uploads/2011/08/main1-450x306.jpg 450w" sizes="(max-width: 510px) 100vw, 510px" /></a>
  
  <p class="wp-caption-text">
    A stock image I borrowed from Synology. UI has lots of wild features like Music Player, Photo Viewer, and more, all built in (Java Plugins). The user interface is really great. Smooth like being right on the machine, but it's a virtual operating system that runs right in the browser, done in HTML+JS and PHP. You can actually try it online. Click the image.
  </p>
</div>

[<img src="/wp-content/uploads/2011/08/002-150x150.jpg" alt="" title="002" width="150" height="150" class="alignright size-thumbnail wp-image-4517" srcset="/wp-content/uploads/2011/08/002-150x150.jpg 150w, /wp-content/uploads/2011/08/002-450x450.jpg 450w, /wp-content/uploads/2011/08/002-640x640.jpg 640w, /wp-content/uploads/2011/08/002.jpg 1024w" sizes="(max-width: 150px) 100vw, 150px" />](/wp-content/uploads/2011/08/002.jpg)Hardware setup was a matter of unboxing, opening it (sliding case sides front and back to unlock), plugging my drives in, screwing them in, and closing the casing (opposite of opening). I think I had this done in 5 minutes, max. Didn&#8217;t even need a manual.

Building the array I wanted (MODE 1) was extremely straightforward, that I wont both talking about it.

What I will talk about is some of the advanced stuff I wanted from it, and the configuring done to make it act accordingly. After all, this blog post is actually for me, so I can know what I did in case I need to reproduce it.

<!--more-->\* \* *

The main thing I wanted was to move my SVN repository over. I enabled SSH, connected to it using putty, then followed the instructions here:

[Step-by-step guide to installing Subversion](http://forum.synology.com/wiki/index.php/Step-by-step_guide_to_installing_Subversion "Step-by-step_guide_to_installing_Subversion")

The subversion guide sends you [to the bootstrapping guide](http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc), which explains how to get the ipkg package manager installed, which you need to get other standard nix tools. Save yourself minutes of reading and go right to the **[bootstrap](http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc#Bootstrap)** section. 

Omitted from that guide is the obvious question of what CPU is inside? It seems Synology has changed processor types a few times over the years (was even PowerPC for a while), but [**here is a complete list**](http://forum.synology.com/wiki/index.php/What_kind_of_CPU_does_my_NAS_have). The 2011 models, specifically the j &#8220;Budget&#8221; models feature a &#8220;**Marvell Kirkwood mv6281 1.2Ghz ARM Processor**&#8221; (i.e. the 2nd last option).

Following the subversion guide, once I got up to the reboot stage, I was done. I was able to copy my existing repository over to the device, and it worked almost immediately. Fantastic!

\* \* *

For no good reason, I also wanted development tools installed.

As it turns out, **/opt/** maps to part of the **/volume1/** partition. The packages are set-up in such a way that anything not firmware should be stored inside opt.

So to get development tools, you ask for the optware development package.

`ipkg install optware-devel`

Anything you build should be built from the opt directory.

`./configure --prefix=/opt`

More [details here](http://forum.synology.com/wiki/index.php/Overview_on_modifying_the_Synology_Server,_bootstrap,_ipkg_etc#Toolchain).

I ran in to **problems getting optware-devel installed**. wget-ssl was complaining about the existence of wget. [No problem](http://forum.synology.com/enu/viewtopic.php?f=40&t=35322)! Uninstall it, then manually install wget-ssl.

`ipkg remove wget</p>
<p>ipkg install libidn<br />
ipkg install wget-ssl`

Actually, both of these operations will fail (WUHT!). But what they will still do is download the respected packages. You can then invoke manual installation of both with the package names (tip, use your tab key to autocomplete).

`ipkg install libidn_1.19-1_arm.ipk<br />
ipkg install wget-ssl_1.12-2_arm.ipk`

Again, those package names should reflect the actual versions you downloaded in the prior step, as they will be newer.

Now optware-devel should safely finish.

`ipkg install optware-devel`

Congratz! You now have GCC installed on your NAS! Cool!

\* \* *

Since getting that working, I&#8217;ve moved some more important files over. My FLAC encoded music collection for one. I&#8217;ve been streaming FLAC music CDs for a couple hours now as I worked on migrating more important data over. So far so good.

<div id="attachment_4530" style="max-width: 334px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/08/PerfMon.png"><img src="/wp-content/uploads/2011/08/PerfMon.png" alt="" title="PerfMon" width="324" height="485" class="size-full wp-image-4530" srcset="/wp-content/uploads/2011/08/PerfMon.png 324w, /wp-content/uploads/2011/08/PerfMon-300x450.png 300w" sizes="(max-width: 324px) 100vw, 324px" /></a>
  
  <p class="wp-caption-text">
    The Web UI has a nice performance monitor. This is my usage now, streaming my huge lossless flac files. Not bad for 1.2 Ghz and 128 MB of RAM. Usage did go up as I was downloading and moving files, but it multitasked well. Peaked at 75%'ish when I was downloading packages and copying data over. Memory usage I haven't seen go above 25%. Impressive!
  </p>
</div>

And that&#8217;s all for this post. Next I&#8217;m going to talk about moving my iOS Sales Data tracking over.

\* \* *

EDIT: I found my device doing stupid annoying worthless tasks, pushing CPU usage to max.

As it turns out, services are installed that generate thumbnails for all photos, and convert videos to flv. STUPID.

Here&#8217;s how to disable thumbnails.

<http://www.munky.net/hardware/controlling-synology-thumbnails/>

Alternatively, you could stop the service.

`/usr/syno/etc/rc.d/S77synomkthumbd.sh stop`

Then rename it.

`mv S77synomkthumbd.sh _S77synomkthumbd.sh`

This is what I did to the FLV service.

`./S88synomkflvd.sh stop<br />
mv S88synomkflvd.sh _S88synomkflvd.sh`

The stupid processes make @eaDIR folders under all directories containing JPG&#8217;s and video files. Now if I had a process to delete all the @eaDIR contents, I&#8217;d be in luck. Oh, and thumbs.db&#8217;s should go too. That Mac one as well.