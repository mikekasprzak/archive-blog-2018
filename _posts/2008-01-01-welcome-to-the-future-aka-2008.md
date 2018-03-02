---
id: 215
title: Welcome to the Future (AKA 2008)
date: 2008-01-01T08:30:11+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2008/01/01/welcome-to-the-future-aka-2008/
permalink: /2008/01/01/welcome-to-the-future-aka-2008/
categories:
  - Ludumdare
  - Stuffing
  - Technobabble
  - VST
---
Start the year right &#8216;eh?

I think each year I&#8217;ve had a blog, I&#8217;ve told myself &#8220;Yes sir! This year we&#8217;re going to blog more often&#8230; and it&#8217;s going to be great!&#8221;. 

I&#8217;m not crazy enough to think that&#8217;s going to happen, but there&#8217;s always the intent.  <img src='/wp-includes/images/smilies/icon_smile.gif' alt=':)' class='wp-smiley' />

&#8211; &#8211; &#8211; &#8211;

Some fun code I toyed with over the past couple weeks, completely unrelated to each other. The [VST SDK](http://www.steinberg.de/324_1.html) (audio instrument/effects) and the [WinTab SDK](http://www.wacomeng.com/devsupport/ibmpc/downloads.html) (tablets). I know I&#8217;m an oddball programmer, as I prefer MinGW (GCC) to Visual Studio. That&#8217;s totally asking for headaches when it comes to _non_ open source stuff, but I don&#8217;t care.  <img src='/wp-includes/images/smilies/icon_biggrin.gif' alt=':D' class='wp-smiley' />

As expected, neither of these SDK&#8217;s ship with a [MinGW](http://www.mingw.org) or [Cygwin](http://www.cygwin.com) friendly build option (though VST SDK is portable). As far as the effort in getting them working, I gotta say, thumbs up to Steinberg, thumbs down to Wacom.

VST wise, I got started on a VST port of [sfxr](http://www.imitationpickles.org/ludum/2007/12/13/sfxr-sound-effects-for-all/). I have the sound engine working both as a [sound effect generator](http://junk.mikekasprzak.com/Research/sfxrVst/sfxrVst01.zip), and a [key&#8217;d instrument](http://junk.mikekasprzak.com/Research/sfxrVst/sfxrVst02.zip), but the real meat of sfxr is in the GUI. So if I manage to discover another day of VST inspiration by April, we could have some Instrument + Sound Effect integration for LD11.

Tablet wise, I really just wanted to know exactly what was involved in adding tablet support to an app. Apparently Windows API coding, and lots of obscure searching.  <img src='/wp-includes/images/smilies/icon_razz.gif' alt=':P' class='wp-smiley' />

&#8211; &#8211; &#8211; &#8211;

Ludum Dare #10 results went live Sunday night. 52 submissions. They can be [found here](http://www.imitationpickles.org/ludum/category/ld10/?compo_limit=52), and the entries can be [found here](http://www.imitationpickles.org/ludum/category/ld10/?tag=final+final&mythumb_nav=1).

Phil Hassey, you rock for hosting it.  <img src='/wp-includes/images/smilies/icon_biggrin.gif' alt=':D' class='wp-smiley' />

Ludum Dare #11 is scheduled for _April this year_. The exact weekend, we&#8217;ll figure out some time before then. If you want to chime in on weekend suggestions, [leave us a comment](http://www.imitationpickles.org/ludum/2007/12/31/ludum-dare-11-april-2008/). There&#8217;s mutterings of a 10.5 between then and now. If you&#8217;re interested, get on the [mailing list](http://www.gamecompo.com/mailing-list/), and we&#8217;ll let you know if it happens.