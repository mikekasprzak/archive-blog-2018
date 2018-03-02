---
id: 259
title: New Server (AKA. I killed a Cisco)
date: 2006-10-07T14:26:34+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2006/10/07/new-server-aka-i-killed-a-cisco/
permalink: /2006/10/07/new-server-aka-i-killed-a-cisco/
categories:
  - Stuffing
  - Technobabble
---
You see, what&#8217;s fun about big computers is&#8230; oh wait&#8230; there&#8217;s no fun here.

Back sometime in &#8216;98, whilst I was working in a computer store, my fascination with big computer crap began. And I purchased this massive &#8220;Server&#8221; case, which was PC&#8217;s case for a couple years. Eventually, this behemoth of a case was &#8220;promoted&#8221; to an actual server, since routine maintenance/upgrades were painful given it&#8217;s shear mass.

Then in &#8216;04, I had the brilliant idea to purchase the biggest, fattest Laptop mankind has ever seen. The original Dell XPS.

![](/content/xps.jpg)

9 pounds of desktop replacement power. Actually, let me rephrase that. _Notebook_, not Laptop. When placed on ones lap, it doubles as a device that makes you forget you have legs.

So it took me far too long to come to the conclusion that big & heavy computers != good. Great. Why are we here?

![](/content/oldserver.jpg)

Well, _The Behemoth \*cough\*_ case, and server for that matter, is on it&#8217;s way in to retirement. This _was_ something our little 2 man operation planned to deal with _after_ the game was out. Alas, a number of factors have encouraged us to act sooner.

**1.** We killed the Cisco!
  
**2.** Reading/Writing from the old server was slower than something really slow
  
**3.** Hearing the sound of &#8220;water dripping&#8221; coming from a computer is&#8230; discerning
  
**4.** Building a new computer _might_ be fun (the _new_ part, more than the _building_ part)

We kill routers. Doesn&#8217;t matter who makes them, we&#8217;ve killed one or two from that manufacturer. I&#8217;m sure glad Future Shop/Best Buy offers extended warranties. Thus, in response to our discovery of there being no such thing as a reliable consumer router, we did what any pack of blood sucking marsupials would do. We ordered a used Cisco router on eBay. $200, and some mis-shipped power supplies later, we were in Cisco town.

However, it recently decided that forwarding HTTP requests was stupid or _above it_, and quit. Thanks _Crisco_. I hope you enjoy life on the cold dank shelf of unused computer crap.

I suspect we could have fixed it just fine, but that was hardly the first problem we&#8217;ve had with it. One XBox Live connection at a time only? No thanks. Pain to configure for someone with Cisco certification? _Double_ no thanks.

So in an effort to kill 37 birds with one really freaking sharp stone, we&#8217;ve researched, devised, and developed brand new server. The _lowest end_ Intel Core 2 Duo money can buy, a Gig of RAM, 4 320GB drives in a RAID 5 array, 3 NIC&#8217;s (1+2), and a small case actually large enough to hold all that.

![](/content/newserver.jpg)

And it&#8217;s blue.

![](/content/blueserver.jpg)

She&#8217;s all built, the bulk of the data&#8217;s been migrated over (SVN repository, data, reference material), and she&#8217;s humming nicely in the corner running Fedora Core 6, 64bit style. There&#8217;s no point going in to detail about our Linux complications, but it&#8217;s \*cough\* a good sign when the first version you get to work right was released 3 days ago.