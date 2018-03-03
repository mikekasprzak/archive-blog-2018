---
id: 3886
title: Mike and Middleware
date: 2011-04-04T05:00:46+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=3886
permalink: /2011/04/04/mike-and-middleware/
categories:
  - Smiles
  - SYK15
  - Technobabble
---
I&#8217;ve been making games for a really long time now, but one thing I&#8217;ve found myself rather resilient to was letting myself use Middleware. By Middleware, I mean 3rd party libraries. It&#8217;s funny since I always highly recommend that people use it (to save RIDICULOUS amounts of time), but I myself am just a really slow adopter of it.

[**SDL**](http://www.libsdl.org) is one of few long-time 3rd party libraries I use. It lets me write my game code against the PC, Mac, Linux, and a few mobiles including Palm/HP&#8217;s webOS and Nokia&#8217;s Maemo. It&#8217;s a bit of a black box to me though. I know it initializes OpenGL for me, does some crazy stuff to let me access keyboard and mouse events, but if it broke I wouldn&#8217;t know where to start. Stable SDL has unfortunately been stuck at version 1.2.14 for a very long time, and 1.3 has been unfinished and &#8220;coming soon&#8221; for just as long.

Fortunately this has finally changed, as Sam the lead developer of SDL left his cozy job at Blizzard and has been pushing the project forward like a maniac. I started to familiarize myself with some of SDL&#8217;s internals due to this renewed focus, but it&#8217;s still mostly a mystery box to me. I have my codebase working against both SDL 1.2 and 1.3 branches, and last I checked (late February) 1.3 nearly did everything it was supposed to. SDL&#8217;s former glory is nearly ready to be restored, so I&#8217;m certainly feeling better about using it. If I keep using it and reporting bugs, it&#8217;ll fix itself.

\* \* *

[**SDL_Mixer**](http://www.libsdl.org/projects/SDL_mixer/) is an addon for SDL that l&#8217;ve always felt a little funny using, but it works (mostly). It provides a simple audio mixer (load an mix multiple sound effects) combined with a single track of music playback. In practice though, I ran in to multiple issues with the library. Music playback has various looping issues on numerous platforms. My Smiles for Windows builds would accumulate noise whenever a music track looped, and on webOS they would make a distinct glitch noise at the loop point. The latest Hg (Mercurial) versions seem better, but I think I demand more from my audio library nowadays than what SDL_Mixer offers. Plenty fine for Smiles, but not moving forward.

\* \* *

For my submission to Intel&#8217;s first contest (where I won the car), I licensed a piece of Middleware called [**IrrKlang**](http://www.ambiera.com/irrklang/). Irrklang is much better than SDL\_Mixer when it comes to features (sounds can actually be pitched, and you can play multiple music streams). It&#8217;s actually a really good library, but unlike the SDL family it&#8217;s even more of a black box &#8211; an Indie license does-not get you source, just some .lib, .dll, .a, and .so files. I&#8217;m sure that works fine for many people (FMod candidates for example). It works flawlessly for me on Windows, but I personally found the Linux and Mac support to be less than ideal (leading me back to SDL\_Mixer for both), but [Phil](http://www.galcon.com) swears by it. I recommend checking it out and trying for yourself &#8211; you wont find a better deal on capable sound Middleware (\*sigh\* FMod).

\* \* *

Today though I have my own sound mixing code. It developed out of necessity on platforms such as Windows Mobile 6.5 and Samsung&#8217;s Bada (both completely lacking in any useful audio playback). It supports pitched music and sound playback, some rough ADPCM compressed sound plackback support, and in my latest now adds a single track OGG decoder. I&#8217;m not silly enough to think what I have is actually flexible and user friendly (it&#8217;s not like I need to support it), but I can make it work on any device or platform that can make noise. In a way I do wish I could rely on a 3rd party audio library, but it seems my own needs grow more and more diverse every day.

I should probably mention, all my audio code is wrapped behind a simple API of mine. Loading a sound, playing a sound, playing a song, crossfading to a different song, etc. So adding/trying a new API (or even using my own) is a matter of writing a new implementation of the same interface.

\* \* *

On my watch-list is [**OpenAL**](http://connect.creativelabs.com/openal/default.aspx). Earlier this year I was asked by fellow Cannucks [Hemisphere Games](http://www.hemispheregames.com/) to help port their hit game **Osmos** to Intel&#8217;s AppUp platform (well, asked late last year but did it this year). &#8220;Port&#8221; might be pushing it, as it was more &#8220;help us test and meet these weird packaging requirements that aren&#8217;t NSIS&#8221;. A couple days later we were in business. One of the particular concerns of theirs was making the default OpenAL driver install correctly through an .MSI installer. It&#8217;s been a couple months since I did this, so while I can&#8217;t actually recall what I actually did, I was able to make it work exactly as expected and remember it not being particularly too difficult (tricky, but not stupid).

I don&#8217;t run a consumer sound card anymore (at least not in my workstation), but the theory is that if you had one of the latest-and-greatest Creative cards, you&#8217;d have a 5.1 surround sound gaming thing going on. As a bit of a home theater buff, I am fascinated by surround sound. Up until I started using pro-audio gear on my workstation PC, I was using a surround capable Creative card with a 4.1 speaker setup. But as it turns out, surround sound setups aren&#8217;t all that common. Take in to consideration that the potential total games market includes all cellphones, all tablets, all portable gaming systems, all PC&#8217;s and all consoles, and only a fraction of the high end actually use it. So as much as I want to love and embrace the wonderful world of 5.1, what matters most is what I do in classic 2.0 Stereo. Still, lack of market-share isn&#8217;t going to stop me. I love crazy tech gizmos and gimmicks &#8211; after all, I&#8217;m a programmer, and that means I get to play with new toys. [OpenAL](http://connect.creativelabs.com/openal/default.aspx) is just a mixing API though. It provides a high level interface to place sound sources in a game world, and something to listen to them. It&#8217;s practically the standard (more like, only one left) on PC, but I don&#8217;t think that&#8217;s the case on Sony, and certainly not Microsoft (whom is allergic to anything with the word &#8220;Open&#8221; in it being the de-facto standard on its platforms). Still OpenAL seems a good reference point. I don&#8217;t have access to PlayStation 3 or Xbox 360 documentation, so I&#8217;m just going to have to assume Sony and Microsoft would do something similar (sources and listeners), and structure my new player frontend around that.

Anyways, enough on Audio.

\* \* *

[**Airplay SDK**](http://www.airplaysdk.com) is a new one for me, but one I learned to appreciate more and more every time I use it. A bit over a week ago, I was working on the Nokia Symbian^3 port of Smiles for a contest, and honestly, I had enough. The toolchain is based on Eclipse, which I have to say, is one of the worst IDE&#8217;s for project management. I&#8217;m sure it works fine for a single project targeting a single platform, but it DOES NOT play nice in a situation where we need to target multiple different platforms using different API&#8217;s and schemes.

It was Wednesday evening, and I had decided that I was out. The whole process of getting a binary on to the phones was immensely clumsy, assuming you could make one that actually worked in the first place, and there was too much to learn about a platform that literally had an expiration date (April 1st). So I let out my expletives, poured myself some wine (I normally only drink to celebrate), and proceeded to wind down the port.

My post-project-frustration tweet was responded to by [Dave](http://www.bluescrn.net/), one of my favorite Ludum Dare long-time regulars (check out some of his [cool prior games here](http://www.bluescrn.net/?p=22)). He said something that made me feel stupid.

[<img src="/wp-content/uploads/2011/04/DaveReed.png" alt="" title="DaveReed" width="569" height="126" class="aligncenter size-full wp-image-3918" srcset="/wp-content/uploads/2011/04/DaveReed.png 569w, /wp-content/uploads/2011/04/DaveReed-450x99.png 450w" sizes="(max-width: 569px) 100vw, 569px" />](/wp-content/uploads/2011/04/DaveReed.png)

No no, I couldn&#8217;t possibly do that! Middleware! Eww! What about my pride? I&#8217;m Mr crazy dude that ports to every platform himself! What would my mom say?

I began my response tweet as any pig-headed fool would, but paused as I tried to come up with _the reason_ not to. I couldn&#8217;t think of one. I rushed to their website and combed the sales pitch and documentation for that one thing I could use to kill the idea. I couldn&#8217;t find it. In fact, all I could find were more and more reasons to actually switch. Damn it! \*breathe\*

Dave, Airplay, you win.

The one thing that I could not refute was Android support. My existing Android port has been sitting in a half state of completion for months, maybe years. I was finally making some notable progress early this year, but put it off for some other more important deadlines (things worth money and prizes). I still have code to write to properly support the awkward system of indexing a Jar file to get my assets.

<div id="attachment_3928" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/04/Android02.jpg"><img src="/wp-content/uploads/2011/04/Android02-640x480.jpg" alt="" title="Android02" width="640" height="480" class="size-large wp-image-3928" srcset="/wp-content/uploads/2011/04/Android02-640x480.jpg 640w, /wp-content/uploads/2011/04/Android02-450x337.jpg 450w, /wp-content/uploads/2011/04/Android02.jpg 912w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    My Android port, circa new-years day. All my ports look like this when they start (no texture title screen)
  </p>
</div>

So okay. If I could get an Android port of Smiles running in just a few days on Airplay, I&#8217;d seriously consider using it for both the Android and the Symbian^3 port. 30 day trial go!

<div id="attachment_3931" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/04/AndroidBug.jpg"><img src="/wp-content/uploads/2011/04/AndroidBug-640x480.jpg" alt="" title="AndroidBug" width="640" height="480" class="size-large wp-image-3931" srcset="/wp-content/uploads/2011/04/AndroidBug-640x480.jpg 640w, /wp-content/uploads/2011/04/AndroidBug-450x337.jpg 450w, /wp-content/uploads/2011/04/AndroidBug.jpg 1094w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    This glitchy reinterpretation was new. Cut-off S looks like a macaroni noodle.
  </p>
</div>

Huh. Okay. So you&#8217;re working, and stuff. Then&#8230; uh&#8230; How about the full game, and make it work on Symbian^3 as well?

<div id="attachment_3903" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/04/AndroidsAndSymbians.jpg"><img src="/wp-content/uploads/2011/04/AndroidsAndSymbians-640x480.jpg" alt="" title="AndroidsAndSymbians" width="640" height="480" class="size-large wp-image-3903" srcset="/wp-content/uploads/2011/04/AndroidsAndSymbians-640x480.jpg 640w, /wp-content/uploads/2011/04/AndroidsAndSymbians-450x337.jpg 450w, /wp-content/uploads/2011/04/AndroidsAndSymbians.jpg 1094w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Select Android and Symbian^3 phones... and what I mean by select are just the phones I have
  </p>
</div>

Airplay, you win.

Within 4 days I had my code running cleanly inside Airplay, with even my sound mixer hooked up to the audio interface. Music wasn&#8217;t working properly on Symbian^3, but I had a whole 3 days to spare now. Huh. So rather than having to explicitly remove the music mute & skip-track buttons, I crunched a day to get an OGG decoder working in my sound engine ([STB Vorbis](http://www.nothings.org)). And boy am I glad I did. I often forget how much the music really ads to the game. Wow I say.

So within a week, I have a fully working version of Smiles for both Symbian^3 and Android, the first already submitted to a very important Nokia contest, and the later nearly ready to be sent off to all the noteworthy Android App Stores. I did stumble across a bug in Airplay for Android, but after a short bug report, it&#8217;s now on schedule to be fixed in the update coming any day now. It feels kinda nice to have deferred a bug to someone else. I was able to take my weekend and do something for me (work on my new game), instead of painfully trying to fix bizarre compatibility problems. Ahh!

So I&#8217;m left feeling extremely positive about Airplay, too positive perhaps. With the Nokia stuff out of the way, I started thinking about relying on it more. I spent a good chunk of this past Friday getting my Airplay port working on iPhone, and as expected, it was very straightforward (given how tricky Apple-dev can be). I&#8217;ve had some wild ideas about doing some updates, adding retina/universal support and whatnot, but I just never had the time to do it. An afternoon with Airplay later, BLAM! There&#8217;s still a long list of subtle tweaks I need, but it&#8217;s there, working, and I don&#8217;t even need to turn on the Mac to test it. 😀

Long term, I&#8217;m strongly considering letting Airplay take care of my mobile platforms, with the one exception of webOS. They&#8217;re part of the SDL family, so I&#8217;d rather work with that directly, as I do now on the PC. But upcoming stuff like the Blackberry Playbook, yeah, go ahead and be my porting intermediary Airplay. Mmmm.

I see this as a pretty big step for me. My &#8220;thing&#8221; the past couple years has been me doing all the porting myself, and now I&#8217;m nearly ready to let someone else (indirectly) take over. The only version of Smiles (nearly) in a store that uses Airplay is the Symbian^3 version. That will be followed up with the Android version very soon, but everything else I did all myself. The iPhone, the iPad, the Netbooks, the webOS, the Windows Mobile 6.5, the Maemo, the few PC+Mac+Linux versions that are available, and the Windows Phone 7 version (which was a collaboration of sorts, but my code ported over to C#). And now I&#8217;m talking letting Middleware handle the platform specifics for me.

I think I&#8217;m okay with it. 

If I need an instant port for some contest or &#8220;quick buck&#8221; opportunity, I&#8217;ll probably step in and do it myself as usual. But if time isn&#8217;t of concern, I can easy it.

I&#8217;m okay with it.

I&#8217;ve admittedly been in a bit of a rut with the Smiles porting. I \*SO MUCH\* want to be working on a new game now, as Smiles itself came out nearly two and a half years ago. Doing everything myself like I am, my time is precious. Given what I do and can do, I could easily stick a dollar amount on it that would make any employer cringe. But unless I&#8217;m enjoying myself, it can be hard to be motivated.

I&#8217;m okay with it, especially after this past weekend.

\* \* *

I&#8217;m evaluating 2 new pieces of Middleware now. Not so much evaluating though, as finally sitting down and testing if my &#8220;yes, I will use this&#8221; analysis was correct. Both are things I&#8217;m expecting will make development of my new game better and easier.

\* \* *

The first is a scripting language called [**Squirrel**](http://www.squirrel-lang.org/). Common wisdom in gamedev seems to be that one should use Lua for game scripting; It&#8217;s easier for &#8220;non coders&#8221; or something, I dunno. Well I&#8217;m a coder, and I am law. If I want my artists to learn to count from zero, so be it. Grah! Truth of the matter though, I&#8217;ll be doing most of the scripting on my upcoming game, and I only want to do things that will actually improve my workflow. The more C++ like my scripting dialect, the better. Making me count from 1 and switch back to Pascal&#8217;esc begin and ends sounds like I&#8217;m back in High School. My decade of game industry experience has earned me the right to be a cranky-old-man, so I&#8217;m going to force my will upon all those that work under me. Hurah!

That said, [Squirrel](http://www.squirrel-lang.org/) is a lovely language. Contrary to some [dated benchmarks](http://codeplea.com/game-scripting-languages), as of 3.0, Squirrel is now [on par with Lua](http://pastie.org/1721408) performance wise. Sure, all languages have their weaknesses (even Lua), but performance isn&#8217;t one of Squirrels anymore. Sure, Lua has some lightning fast JIT&#8217;s available to it, but not all architectures are JIT&#8217;able (ARM and PPC specifically&#8230; we might be able to forget about MIPS though). I want to throw a special thanks out to [Pekka of Polygon Toys](http://www.polygontoys.com) (and [ScreenshotSaturday.com](http://www.screenshotsaturday.com)) for the benchmarks. I was practically sold on Squirrel already, but his numbers have solidified my commitment to it.

My use of Squirrel, contrast to Pekka, is that I want to use it as a high level data modeling language (akin to XML, but with actual function). I plan to code my engine in C++ as I would normally, but assign all specialization and logic between game-things to the script. My initial test have been extremely encouraging, roughing out the hierarchies of an extremely flexible crafting and recipe system in a matter of hours (well, if you ignore all the pre-planning that went in to it). It makes me wish I was further along on other aspects of the game. 🙂

I should also mention, [Pawn](http://www.compuphase.com/pawn/pawn.htm) was on my short list as a &#8220;raw execution speed&#8221; scripting language. It&#8217;s [terrible with strings](http://codeplea.com/game-scripting-languages), but appears a solid choice for something like particle effects. And it&#8217;s very tiny.

\* \* *

The final piece of Middleware on the table is [**Bullet**](http://bulletphysics.org/wordpress/), the physics+collision library. It&#8217;s still admittedly very early in my analysis of it, but I&#8217;ve been warming up to it.

Like Airplay, Bullet has been a difficult sell for me. As it turns out, I&#8217;m no slouch when it comes to physics programming. Me and 2D soft-body physics are like this [does some sort of finger cross gesture]. I didn&#8217;t code Box2d, but I&#8217;ve coded things like it&#8230; before it was cool. 😀 Heh okay, I&#8217;ll admit there&#8217;s certainly some bitterness left in me that I didn&#8217;t capitalize off my physics skillz back during the recent gimmick-game boom. I had my PuffBOMB HD getting good in 2007, but to me only Microsoft and Xbox 360 had the power back then. Whoda-thunk iPhone would have been a better home&#8230; [/bitter]

So what particularly attracts me to Bullet is that it&#8217;s more of a collection of components. The library is designed in such a way that you don&#8217;t even have to use physics, you could totally just use it for the extensive collection of collision tests. That&#8217;s right up my alley. I&#8217;ll probably end up using it like everyone else (for physics), but I do feel kinda good that I have options (get SOME use out of that latent game-physics knowledge). But anyways, it&#8217;s still early and I don&#8217;t know how intimately I can abuse it yet. Looks good though.

And that concludes my little Middleware rant, and what I&#8217;ve been thinking about these past couple weeks. On to my &#8220;April Fools&#8221; port, and a slew of submissions.