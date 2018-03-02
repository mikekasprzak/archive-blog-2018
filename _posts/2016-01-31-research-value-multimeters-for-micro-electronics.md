---
id: 8104
title: 'Research: Value Multimeters for Micro Electronics'
date: 2016-01-31T22:46:31+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=8104
permalink: /2016/01/31/research-value-multimeters-for-micro-electronics/
categories:
  - Technobabble
---
I did a bunch of homework on Multimeters. Here&#8217;s a good beginners guide.



And here&#8217;s a more technical guide to buying a good meter.



There&#8217;s a ton of great information packed in that video, but unfortunately dude is an experienced no-compromise electrical engineer, so his minimum recommendations cost around $100. And actually, his advice is correct if you have any interest in doing any real electronics work (Cars, AC devices, or really anything more than microcontrollers).

But for me, I&#8217;m only really interested in micro electronics. Computers and small devices that draw around 5v or 3.3v (\*maybe\* as much as 12v), and only a few Amperes. I.e. things like the Raspbery Pi, Arduino&#8217;s, old PCs, old video game consoles, etc.

Pro gear is ideal, but I&#8217;m not a pro. I do electronics to learn, not to do anything important. Still, I highly recommend that video because it&#8217;s packed with experience.

In my research, I chose a Chinese manufacturer that EEVblog doesn&#8217;t like, mainly because they compromise (but when I get to talking about Power Supplies, you&#8217;ll see other manufacturers compromise WAY more). Again, this dude is a real engineer, and he needs a reliable device that can deal with high voltages (outside the scope of my hobby). 

The devices I&#8217;ve chosen I believe are ideal for me, and are capable of some higher end work, with the understanding that **extra care** must be taken when dealing outside the 3.3-5v range, plugging in to the wall directly, etc.

## Junk Device: Generic A830L

Cost: [**$3-$6**](http://www.aliexpress.com/item/Modern-LCD-Digital-Multimeter-battery-Ammeter-Voltmeter-Ohmmeter-Current-Tester-Grey-White-Blue-Black-Sep02/32455581515.html)

<a href="http://blog.toonormal.com/wp-content/uploads/2016/01/junkmeter.jpg" rel="attachment wp-att-8141"><img src="http://blog.toonormal.com/wp-content/uploads/2016/01/junkmeter-450x450.jpg" alt="junkmeter" width="450" height="450" class="aligncenter size-medium wp-image-8141" srcset="http://blog.toonormal.com/wp-content/uploads/2016/01/junkmeter-450x450.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/01/junkmeter-150x150.jpg 150w, http://blog.toonormal.com/wp-content/uploads/2016/01/junkmeter-640x640.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/01/junkmeter.jpg 807w" sizes="(max-width: 450px) 100vw, 450px" /></a>

To be honest, the product code isn&#8217;t even that useful, but there a bunch to be found.

This meter is junk. It&#8217;s one of 2 meters that hover around the $3 price range. I&#8217;ve included it just to list the cons.

**Pros**

  * It beeps
  * Resistance tester
  * Diode tester
  * Transistor tester (hFE) *
  * Backlight *
  * Kickstand

Only two (*) redeeming features, but that doesn&#8217;t mean they&#8217;re good.

**Cons**

  * Manual range!
  * Poor precision options
  * Combined Voltage and Ampere plug (Unsafe)
  * Manual hold button (not automatic, need a free hand to use it)
  * No Capacitor tester
  * No Oscillator tester
  * No Duty Cycle tester
  * No Temperature tester
  * Low quality connectors
  * Unfused 10A line
  * May have bad leads (order some [better leads](http://www.aliexpress.com/item/High-Quality-1-Pair-Universal-Needle-Tip-Probe-Test-Leads-Pin-For-Digital-Multimeter-Meter-Tester/32383303198.html))
  * 4 digits of precision (????)
  * Kickstand might break
  * Don&#8217;t plug in to AC Mains

Frankly, you might spend more money on the 9V battery.

We can do better!!

## Value Low End Device: UNI-T UT-136B

Cost: [**~$16**](http://www.aliexpress.com/item/UNI-T-UT136B-Auto-Range-Digital-Multimeter-AC-DC-Frequency-Resistance-Tester-free-shipping/1926170184.html)
  
Manual: <http://www.uni-trend.com/uploads/soft/wanyongbiao/UT136ABCD-Manual-en.pdf>

<a href="http://blog.toonormal.com/wp-content/uploads/2016/01/unit-ut136b.jpg" rel="attachment wp-att-8113"><img src="http://blog.toonormal.com/wp-content/uploads/2016/01/unit-ut136b-450x450.jpg" alt="unit-ut136b" width="450" height="450" class="aligncenter size-medium wp-image-8113" srcset="http://blog.toonormal.com/wp-content/uploads/2016/01/unit-ut136b-450x450.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/01/unit-ut136b-150x150.jpg 150w, http://blog.toonormal.com/wp-content/uploads/2016/01/unit-ut136b-640x640.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/01/unit-ut136b.jpg 800w" sizes="(max-width: 450px) 100vw, 450px" /></a>

After doing my research, to me this appears to be the minimum quality meter you should own. I currently own 2 junk meters I bought from Radio Shack, and I&#8217;m pretty sure I spent $60+ on the one because it was &#8220;automatic&#8221;. What a difference a decade makes.

**Pros**

  * Separate Voltage and Ampere lines (Safety!)
  * Micro Ampere and Milliampere measurements
  * Automatic decimal place (manual isn&#8217;t cool)
  * Good+Fast beeper (lagged sound is really stupid)
  * Resistance tester
  * Diode tester
  * Capacitor tester
  * Oscillator Hz tester
  * Square Wave Duty Cycle tester
  * Some sort of Sine Wave feature (I forget why this is useful, maybe AC power \*shrug\*)
  * Fused 10A line
  * Kickstand&#8230;
  * Support for sleeved banana connectors on leads

**Cons**

  * Manual hold button (not automatic, need a free hand to use)
  * Some Capacitor testers have a socket for caps, but not this one
  * Not the best quality banana connectors
  * May have bad leads (order some [better leads](http://www.aliexpress.com/item/High-Quality-1-Pair-Universal-Needle-Tip-Probe-Test-Leads-Pin-For-Digital-Multimeter-Meter-Tester/32383303198.html))
  * Fuses are not best quality
  * 4 digits of precision (4000)
  * No transistor tester (not that important, but some devices do this)
  * Kickstand might break
  * No backlight
  * No Temperature tester (UT136C model replaces a feature with temperature)

Here&#8217;s a comparison versus a better meter, and while it&#8217;s not perfect, it does keep up where it counts.



And more specific breakdown.



I&#8217;ve ordered one of these. I think it&#8217;s adequate for my needs, but of course I want one of these:

## Value High End Device: UNI-T UT-61E

Cost: [**~$47**](http://www.aliexpress.com/item/UNI-T-UT-61E-UT61E-22-000-count-AC-DC-bench-Modern-meter-Digital-Multimeter-Volt/1926170329.html)
  
Manual: <http://uni-trend.com/manual2/UT61English.pdf>

<a href="http://blog.toonormal.com/wp-content/uploads/2016/01/UNIT-UT61E.jpg" rel="attachment wp-att-8124"><img src="http://blog.toonormal.com/wp-content/uploads/2016/01/UNIT-UT61E-450x450.jpg" alt="UNIT-UT61E" width="450" height="450" class="aligncenter size-medium wp-image-8124" srcset="http://blog.toonormal.com/wp-content/uploads/2016/01/UNIT-UT61E-450x450.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/01/UNIT-UT61E-150x150.jpg 150w, http://blog.toonormal.com/wp-content/uploads/2016/01/UNIT-UT61E-640x640.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/01/UNIT-UT61E.jpg 800w" sizes="(max-width: 450px) 100vw, 450px" /></a>

It includes a few accessories.

<a href="http://blog.toonormal.com/wp-content/uploads/2016/01/accessory.png" rel="attachment wp-att-8125"><img src="http://blog.toonormal.com/wp-content/uploads/2016/01/accessory-450x306.png" alt="accessory" width="450" height="306" class="aligncenter size-medium wp-image-8125" srcset="http://blog.toonormal.com/wp-content/uploads/2016/01/accessory-450x306.png 450w, http://blog.toonormal.com/wp-content/uploads/2016/01/accessory.png 616w" sizes="(max-width: 450px) 100vw, 450px" /></a>

**Pros**

  * Separate Voltage and Ampere lines (Safety!)
  * Micro Ampere and Milliampere measurements
  * Automatic display with voltage range graph (I forget the name)
  * 5 digits of precision (22000)
  * 6 second automatic hold (not truly automatic, but 6 seconds works)
  * Supports removing the delta of the lead resistance (RMS?)
  * Track and toggle the Peak (Min/Max) Levels
  * Good+Fast beeper (lagged sound is really stupid)
  * Resistance tester
  * Diode tester
  * Capacitor tester with socket accessory
  * Oscillator Hz tester
  * Square Wave Duty Cycle tester
  * PC Connectivity via SERIAL
  * Fused 10A line
  * Kickstand&#8230;
  * Support for sleeved banana connectors on leads

**Cons**

  * It occasionally spikes (rarely)
  * May have bad leads (order some [better leads](http://www.aliexpress.com/item/High-Quality-1-Pair-Universal-Needle-Tip-Probe-Test-Leads-Pin-For-Digital-Multimeter-Meter-Tester/32383303198.html))
  * Fuses are better than the other model, but may not be the best
  * Not the best quality banana connectors
  * No transistor tester (not that important, but some devices do this)
  * Kickstand might break
  * No backlight
  * No Temperature tester (UT-61B and UT-61C models replaces features with temperature)

You can find a very in-depth 4 part video series here that tests and even calibrates the device:



And a comparison of other meters in the same quality range (albeit higher cost). 



It&#8217;s not his favourite, but admits that it&#8217;s ideal for what I describe as my usage scenario (plus it has very high resolution).

EEVblog hates it because of the quality compromises.

## Anything better?

A better device would have the following:

  * Backlight
  * Fast Display Refresh Rate
  * Good/Sharp Leads
  * Better Fuses
  * Better Banana Connectors
  * Rubberized Casing (to help when you drop on a hard surface)
  * Better accuracy and precision
  * Clean levels (no false spikes, likely a software bug)
  * Temperature tester
  * Safer lifetime on AC mains

I&#8217;m nowhere near experienced enough to take advantage of a better meter though. Better stuff costs more (Over $100), and as a hobbiest, I don&#8217;t need it. Because I don&#8217;t have pro gear, there will be times I shouldn&#8217;t trust my meter (i.e. occasional spikes, get a 2nd opinion), but it will be more than enough for what I do.

From what I&#8217;ve seen, in the price range (~$50), there is nothing better. 

## Wrapup

At the time of this post I&#8217;ve ordered both the junk tester (A830L) and the UNI-T UT-136B. Why the junk? As a backup mainly (or worst case, parts). The meters I have today are really bad.

<a href="http://blog.toonormal.com/wp-content/uploads/2016/01/mycrappymeters.jpg" rel="attachment wp-att-8145"><img src="http://blog.toonormal.com/wp-content/uploads/2016/01/mycrappymeters-450x337.jpg" alt="mycrappymeters" width="450" height="337" class="aligncenter size-medium wp-image-8145" srcset="http://blog.toonormal.com/wp-content/uploads/2016/01/mycrappymeters-450x337.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2016/01/mycrappymeters-640x479.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2016/01/mycrappymeters.jpg 1429w" sizes="(max-width: 450px) 100vw, 450px" /></a>

The Radio Shack meter, while automatic, is lacking a lot of useful features like a beeper. Even the junk meter has a beeper!

Some weeks ago I ordered one of those temperature guns (a cheap one), so I&#8217;m hoping that&#8217;s enough for temperature measurement.

Things from China take weeks, even months to arrive. It&#8217;s Chinese New Year, so there&#8217;s at least 2 extra weeks to wait, so I probably wont see any of this until mid to late March.

At this time I have \*NOT\* purchased the UNI-T UT-61E, but you might say it&#8217;s on my xmas list. 🙂