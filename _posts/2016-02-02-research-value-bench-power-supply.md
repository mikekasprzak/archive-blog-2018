---
id: 8156
title: 'Research: Value Bench Power Supply?'
date: 2016-02-02T19:30:07+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=8156
permalink: /2016/02/02/research-value-bench-power-supply/
categories:
  - Technobabble
---
I dabble with micro-sized computers. Things like this.

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/Orange_Pi_One_Large.jpg" rel="attachment wp-att-8157"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/Orange_Pi_One_Large-450x296.jpg" alt="Orange_Pi_One_Large" width="450" height="296" class="aligncenter size-medium wp-image-8157" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/Orange_Pi_One_Large-450x296.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/Orange_Pi_One_Large-640x421.jpg 640w" sizes="(max-width: 450px) 100vw, 450px" /></a>

The device above is something called the **Orange Pi One**, a cheap Chinese designed and manufactured board. Costs about [$10 + shipping](http://www.aliexpress.com/store/product/Orange-Pi-One-ubuntu-linux-and-android-mini-PC-Beyond-and-Compatible-with-Raspberry-Pi-2/1553371_32603308880.html) (~$4 to Canada). 

Unlike the highly regarded Raspberry Pi Zero, it has a Quad Core ARMv7 CPU (vs. a single core ARMv6, slooow), a full sized HDMI, full sized USB, and an Ethernet Jack. Pretty amazing little machine for a tenner.

The Orange Pi boards have 2 things that make them slightly troublesome. 

  1. Software support isn&#8217;t great. The AllWinner H3 lacks mainline support in the Linux Kernel, but it is [getting better](https://linux-sunxi.org/Orange_Pi_PC). Maybe by the end of the year.
  2. It **doesn&#8217;t** use the &#8220;standard&#8221; Micro USB port as a power connector.

The power supply part is unfortunate, but there is a workaround: The device **CAN** be powered via the expansion header.

Most of these tiny boards require 5v 2A to get the most out of them. Many modern cellphone chargers do meet this spec. I could just sacrifice one of those, chopping off the end and soldering pin headers in their place (I probably should, as this is common enough). I went down a different path though.

## Bench Power Supplies

Any true electrical engineer has a true bench power supply. Unfortunately, a good one tends to cost hundreds of dollars.

The high-quality budget alternative tends to be converting an old PC power supply in to a bench power supply.

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/004.jpg" rel="attachment wp-att-8165"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/004-450x300.jpg" alt="004" width="450" height="300" class="aligncenter size-medium wp-image-8165" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/004-450x300.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/004-640x427.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/02/004.jpg 1200w" sizes="(max-width: 450px) 100vw, 450px" /></a>

This makes a lot of sense, since PCs are already quite sensitive to voltages, so extra care is already taken by good PC Power Supply manufacturers to make reliable units. That, and the pins on the ATX connector are already the common voltages that most things need.

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/Sick-of-Beige-basic-case.jpg" rel="attachment wp-att-8167"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/Sick-of-Beige-basic-case-450x338.jpg" alt="Sick of Beige basic case" width="450" height="338" class="aligncenter size-medium wp-image-8167" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/Sick-of-Beige-basic-case-450x338.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/Sick-of-Beige-basic-case-640x480.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/02/Sick-of-Beige-basic-case.jpg 700w" sizes="(max-width: 450px) 100vw, 450px" /></a>

Alternatively, you make or buy a simple daughter-board that takes an ATX connector, and gives you the desired outputs.

That said, the right of passage of any hobby electrical engineer seems to be making your own bench-top power supply out of an old PC power supply. Some day I&#8217;d like to do this, but not today.

&#8220;Buy an old used one instead&#8221;

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/hvps01.jpg" rel="attachment wp-att-8174"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/hvps01-450x229.jpg" alt="hvps01" width="450" height="229" class="aligncenter size-medium wp-image-8174" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/hvps01-450x229.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/hvps01-640x326.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/02/hvps01.jpg 866w" sizes="(max-width: 450px) 100vw, 450px" /></a>

I&#8217;ll admit that&#8217;s kinda cool, but at the same time unwieldy and large. I don&#8217;t have a dedicated workbench. I do this so infrequently, that I have my office desk I work on. I keep some ancient hardware around (Commodore 64, retro game consoles), but for the most part I prefer newer technology. 

I like portable. I do most of my work on a laptop.

Despite the reputation of cheap sub $100 power supplies, I wanted to be 100% sure that they were &#8220;all crap&#8221;, as everyone says. 

I hate being told absolutes without evidence, so I checked the evidence.

## MCH K305D

Cost: **~$60**

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/mchpsu.jpg" rel="attachment wp-att-8176"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/mchpsu-450x450.jpg" alt="mchpsu" width="450" height="450" class="aligncenter size-medium wp-image-8176" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/mchpsu-450x450.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/mchpsu-150x150.jpg 150w, http://blog.toonormal.com/wp-content/uploads/2016/02/mchpsu-640x640.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/02/mchpsu.jpg 800w" sizes="(max-width: 450px) 100vw, 450px" /></a>

This was the first PSU I found that really got me excited. I love how tiny and small it is. And the price&#8230; well, at the time I accepted that $60 would be an acceptable price to pay.

Alas, looks can be deceiving, and a deep dive reveals what&#8217;s inside is a bit of a nightmare.



Such a shame. It&#8217;s petite, and not bad looking. Functional (?) but scary.

## KSP 305D

Cost: **~$60**

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/305d2.jpg" rel="attachment wp-att-8179"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/305d2.jpg" alt="305d2" width="350" height="350" class="aligncenter size-full wp-image-8179" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/305d2.jpg 350w, http://blog.toonormal.com/wp-content/uploads/2016/02/305d2-150x150.jpg 150w" sizes="(max-width: 350px) 100vw, 350px" /></a>

Here&#8217;s another small one like the MCH above. It has a 2nd set of knobs for fine control (I&#8217;ve heard this is a recommended feature), but only 2 lines to tap (no earth ground). 

The problem with this one though&#8230;

&#8230;it doesn&#8217;t exist.

Now, don&#8217;t get me wrong. It sort-of exists, but I can&#8217;t for the life of me find a photograph of the internals. I can find plenty of external shots. I can find dozens of alternative product codes (KSP303D, KSP605D, etc), models with different connectors, but apparently nobody owns one.

## The Flat One: CPS-3205

Cost: **~$60**

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/gophert.jpg" rel="attachment wp-att-8181"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/gophert-450x227.jpg" alt="gophert" width="450" height="227" class="aligncenter size-medium wp-image-8181" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/gophert-450x227.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/gophert-640x323.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/02/gophert.jpg 650w" sizes="(max-width: 450px) 100vw, 450px" /></a>

Instead of being tall, here&#8217;s a flat one. Of the power supplies mentioned so far, this may actually be the best so far, but it&#8217;s not without it&#8217;s problems.



It&#8217;s the first one that is able to safely power on without spiking, but Dude in the video above does actually manage to make it spike, under certain conditions. The video is a bit slow getting to this, but this does worry me that spikes may be inevitable in this cheap gear. I want to come back to this video sometime so I can hopefully better understand what he did to spike it.

It&#8217;s worth mentioning that the spikes appear to only be double the current, so a compromise appears to be setting the initial levels lower, then raising it.

Unfortunately, due to the clumsy user interface, this device requires a bunch of clicking and mode switching to change the levels. 

If only there was a device that could be cleanly powered on with per level control?

## The Anomaly: UNI-T UTP305

Cost: **~$90**

<a href="http://blog.toonormal.com/wp-content/uploads/2016/02/unitwoo.jpg" rel="attachment wp-att-8183"><img src="http://blog.toonormal.com/wp-content/uploads/2016/02/unitwoo-450x450.jpg" alt="unitwoo" width="450" height="450" class="aligncenter size-medium wp-image-8183" srcset="http://blog.toonormal.com/wp-content/uploads/2016/02/unitwoo-450x450.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/02/unitwoo-150x150.jpg 150w, http://blog.toonormal.com/wp-content/uploads/2016/02/unitwoo-640x640.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/02/unitwoo.jpg 1000w" sizes="(max-width: 450px) 100vw, 450px" /></a>

Hey! UNI-T is back with a slick little unit using their lovely black and red theme.

The asking price is about $30 more than the above units, and amazingly, it may actually be worth it.



In the video above dude was unable to make it spike at all. This seems impossible for a sub $100 device, but lo and behold.

Now, to be fair, he hasn&#8217;t done the same extensive number of tests the dude in the CPS-3205 video did. It may still be possible to spike the unit in those same conditions.

The same video author loved his unit so much, he bought a 2nd one.



He also modified it to slow down the internal fan (and thus reduce the noise). I&#8217;d be tempted to make the same mod myself, but perhaps on a switch.

Sounds great right?

It does, except for one minor detail. 

For some reason, UNI-T doesn&#8217;t acknowledge the existence of this device on their website.

<http://www.uni-trend.com/en/>

I&#8217;m sure it&#8217;s just an oversight though, but even after digging, they don&#8217;t even sell them in their Chinese online store.

However, it is worth noting they do sell a 220v white model, exact same box, different product code for about the same cost. Some stores are listing it as discontinued, so this new red box with the switchable AC voltage is probably the new model. Not to mention, it looks way cooler in Red+Black.

## Summary

UNI-T comes through again. In my research of other UNI-T devices, I found that they appear to do everything safely, but cut back in areas of little consequence (connectors that could wear out/need repairing, simulating automatic hold by using a 6 second timer). Their compromises don&#8217;t seem dangerous like the bargain models above, but I would strongly avoid pushing the limits of their devices.

I&#8217;m very tempted to grab the UNI-T device. While a modified PC power supply will do the job, I&#8217;d really like to have something that can limit the current. Maybe it&#8217;s a minor point, but that to me seems like something to have. Paired with a modified PC power supply for the big current draws, you could probably do most power work.

Tempting. Very tempting.