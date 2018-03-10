---
title: I don't like Ubuntu's Gnome
layout: post
date: '2018-03-09 21:11:33'
---

I've been using Ubuntu as my main OS since 13.10 (i.e. October 2013 version). I've used Ubuntu 17.10 for several months now (i.e. the first version that doesn't ship with the Unity window manager), and frankly, I don't like it.

Unity, the window manager that has shipped with Ubuntu for a very long time, I'm not going to say it's better than 17.10's Gnome, but IMO it's not worse.

I've used other Window Managers too, from Cinamon (Gnome 2 fork), XFCE, KDE, and just today I tried Budgie (based on Gnome 3). Each of them seems to have pros and cons, but as far as I'm concerned none of them stand out.

I've used Windows since Windows 3.1, and pretty-much every release since. One thing I have to say is that through the past 25 years of Windows, at least until we hit Windows 8, newer versions of Windows never really felt worse. To contrast, the Linux I use today does feel worse.

At this point, I feel like I have enough years of Linux under my belt that I can complain. I think Ubuntu, behind the scenes is great. I happily run it on all my servers, my SBC's, and my time in the terminal is without regret. But my time in the Desktop, while Unity was passable, the Gnome I get out-of-the-box (and even after customizing) is unpleasant.

Sure, I could switch back to Unity (window manager), but other than stability, it hasn't really improved in the past 4 years.

I do spend a lot of my time in the browser. Be it research or testing, as nowadays I do ocassional web-dev. There's a proposed Windows 10 feature called [Sets](https://www.engadget.com/2017/11/28/windows-10-sets-tabs/) that caught my attention. The idea is to extend the idea of browser tabs to applications too. Run your IDE or "photoshop" in a tab, and basically keep a bunch of related tools together in one place (like your testing window, you compiling window, etc). Going one step further, you could define a set of applications as a task, so if you decide "it's time to do web dev" several applications could open at once, and/or pickup where you left off. This is interesting to me, but not interesting enough to switch back to Windows. ;)

The other day I stumbled across something new and interesting: [i3wm](/2018/03/07/notes-i3-window-manager/). It's radically different, providing a very refreshing way of splitting applications in to a customizable screen filling layout. Windows 8 had a simpler take on this (run a 2nd app in ~20% of width of the screen), but it was only supported by Windows Store (WinRT) applications. Also i3wm's use of workspaces feels good to me. I've never been particularly happy with Linux Workspaces, but my time using i3wm's Workspaces feels right (i.e. build a layout, and it exists as a workspace).

Unfortunately it's literally a feature that i3wm isn't user friendly. There's a handful of small UX tweaks that IMO would make it so much more plesant. Alas, it's not meant to be. There's a spin-off project called Sway that has re-implemented i3wm in Wayland, but again I'm not sold on i3wm as an answer (a great step, just not an answer).

I briefly started looking in to what's actually necessary to write a window manager, and actually the resources out there aren't bad. There's a lot to know, but even the new guy (Wayland) seems to have an active effort in documenting how the internals work.

I seriously doubt I'm going to convince someone that I should be listened to when it comes to UX. I have written games and game UI's, but I'm not going to pretend that makes me an expert. I just know what I'm using now isn't good enough.

I don't know if this will turn in to something, but between job-hunting and Ludum Dare, I kinda want to start deep diving in to Window Managers. If nothing else so I can figure out what's broken with one that I can fix to make passable, or to write a new one out of impatience.

We'll see. This me saying I'm frustrated. :)