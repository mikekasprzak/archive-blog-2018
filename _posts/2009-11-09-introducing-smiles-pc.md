---
id: 1447
title: Introducing Smiles PC
date: 2009-11-09T06:01:36+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=1447
permalink: /2009/11/09/introducing-smiles-pc/
categories:
  - Design
  - Smiles
  - Technobabble
---
This _is not_ what I&#8217;ve been up to all year, but it is what I&#8217;m up to right now.

So, let&#8217;s introduce the project.

Officially, the project is named **Smiles**. Specifically though, the project&#8217;s working title is **Smiles PC**. Just as you&#8217;d expect, it&#8217;s **Smiles** the iPhone game for PC, Mac and Linux. Actually it&#8217;s more than that, but lets stick with this for now.

At it&#8217;s core, **Smiles PC** is about removing the dependencies of the iPhone from the game. Although **Smiles** has always run on both PC and iPhone, a number of interface decisions were made to suit the iPhone as opposed to other platforms. Many were good ideas, but some things need to be tweaked to suit conventions familiar to PC users.

For me, it&#8217;s also a bit of a clean slate. There were some things in **Smiles** original design that I realized I&#8217;d like to change, but haven&#8217;t since I don&#8217;t want to break what&#8217;s familiar to existing iPhone players.

What I&#8217;d like to do is walk through and talk about the various changes I&#8217;m making to the game. Technical and design changes. Some will be improvements, and other are simply to suit more platforms.

Alright, so lets take a look at one of the first changes. The home screen.

<div id="attachment_1448" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SmilesPC01.jpg"><img src="/wp-content/uploads/2009/11/SmilesPC01-640x400.jpg" alt="Smiles home screen UI Changes... Bubble Buttons!" title="SmilesPC01" width="640" height="400" class="size-large wp-image-1448" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPC01-640x400.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPC01-450x281.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPC01.jpg 1280w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Smiles home screen UI Changes... Bubble Buttons!
  </p>
</div>

At first glance, it&#8217;s pretty much the same as the iPhone version. The buttons are still nice and large, and everything is still bright and colorful.

Probably the most noticeable change is the 4 &#8220;bubble buttons&#8221;. The familiar &#8220;?&#8221; button, the sound toggle that&#8217;s now in a bubble, a gear bubble (configuration) and an X bubble (exit/minimize). The standard way to exit an application on the iPhone was by pushing the large home button on the device itself. PC&#8217;s and other platforms don&#8217;t have a physical standard exit button, so there&#8217;s now an X for that.

Also PC&#8217;s tend to have a lot more subtle things you can tweak. On iPhone (or any closed platform for that matter) we can refine the interface to suit the system. But with computer monitors coming in many sizes, coming with numerous potential peripherals, we need need options.

Hey, and since the other 3 were in bubbles, it only makes sense to put the sound toggle in one too. 🙂

The other noticeable change is the detail. **Smiles PC** uses HD 720p versions of iPhone game art. Textures are 4x the size of the original iPhone assets (double width, double height). I also have HD 1080p assets, but I&#8217;m currently using the 720p assets because they load faster. The 1080p assets are 16x the size of iPhone (quadruple width and height).

The final detail I want to point out is the **Sykhronics** Logo. On the iPhone version I use a blue logo, but for this I&#8217;m using a brown. This is a minor thing I&#8217;m doing to differentiate the two versions of the game. The final iPhone game and PC derivatives will all be called **Smiles**, but the logo color will tell you which development branch it&#8217;s from. Generally speaking, all new non-iPhone versions will be from the brown logo branch, and where appropriate I will continue to do updates to the blue logo branch.

## So what is a PC?

Anybody that&#8217;s worked with me knows I like my theory. **Smiles** itself was a very theoretical project, designed from the ground up to remove the most frustrating aspects from matching games. Things that, in my opinion, defeat the goals of the concept &#8220;casual&#8221;.

Continuing the theoretical journey with **Smiles PC**, I want this port to suit the ever evolving concept of computers. Computer resolutions come in all shapes and sizes, the key point right now being shapes.

<div id="attachment_1469" style="max-width: 291px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SmilesPC02.jpg"><img src="/wp-content/uploads/2009/11/SmilesPC02-281x450.jpg" alt="Smiles&#039; flexible UI goes wide or tall" title="SmilesPC02" width="281" height="450" class="size-medium wp-image-1469" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPC02-281x450.jpg 281w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPC02-640x1024.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPC02.jpg 800w" sizes="(max-width: 281px) 100vw, 281px" /></a>
  
  <p class="wp-caption-text">
    Smiles' flexible UI goes wide or tall
  </p>
</div>

The 720p and 1080p artwork handles the majority of resolution cases, but one of the foundations of **Smiles** iPhone&#8217;s research was getting game to work in any orientation. All the backgrounds are generated, so the user interface elements just need to fit. And as shown above, that can be wide or tall.

Now this isn&#8217;t only theory. A number of computers today ARE doing bizarre things with resolution and orientation. The key area being Netbooks and MIDs.

<div id="attachment_1475" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SmilesPCPhoto01.jpg"><img src="/wp-content/uploads/2009/11/SmilesPCPhoto01-640x480.jpg" alt="Smiles running on a Tablet PC" title="SmilesPCPhoto01" width="640" height="480" class="size-large wp-image-1475" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPCPhoto01-640x480.jpg 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPCPhoto01-450x337.jpg 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesPCPhoto01.jpg 1277w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Smiles running on a Tablet PC
  </p>
</div>

The above is actually a Tablet PC (as I don&#8217;t have a slate Netbook), but it demonstrates the idea. Netbooks specifically are, for lack of a better word, booming. And why not? A mere couple hundred dollars for a fully working PC. Heck, I use one myself (the rectangle with the red cloth on it).

Computers have multiple input methods these days. From mice, trackpads, pens, pointers, touch screens, accelerometers, to mere keys or joysticks. So a goal of **Smiles PC** is to be inclusive as it can be (within reason). Any practical computer a consumer can buy, there should be a way of playing **Smiles** on it.

So that&#8217;s my introduction to **Smiles PC**. Hopefully I keep talking. 😀