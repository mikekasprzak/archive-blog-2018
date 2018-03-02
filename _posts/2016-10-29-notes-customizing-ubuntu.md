---
id: 9437
title: 'Notes: Customizing Ubuntu'
date: 2016-10-29T23:38:52+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9437
permalink: /2016/10/29/notes-customizing-ubuntu/
categories:
  - Uncategorized
---
Yay more notes.

## Changing the File Manager (Nautilus to Nemo)

So, I hate the default file manager in Ubuntu. Unity is fine (meh), but the file manager is dumb. Super dumb.

In this article, a dude did a comparison of file managers available for Linux.

<https://artfulrobot.uk/blog/whats-best-file-manager-ubuntu-gnome-1404-trusty>

Nautilus is the default, but dude liked Nemo (very much a Sea theme going on here).

His instructions for installing Nemo weren&#8217;t too useful (old), but these are totally fine.

<http://www.webupd8.org/2013/10/install-nemo-with-unity-patches-and.html>

Long story short:

<pre class="lang:default decode:true " ># Install
sudo add-apt-repository ppa:webupd8team/nemo
sudo apt-get update
sudo apt-get install nemo nemo-fileroller

# To make sure nautilus is handling icon generation
gsettings set org.gnome.desktop.background show-desktop-icons false

# To make it the default
xdg-mime default nemo.desktop inode/directory application/x-gnome-saved-search</pre>

Keep in mind, this has changed the default. If you search applications, you should 1 or more programs named &#8220;Files&#8221;. Click on it and see if it start the correct program.

Remember, **you still have Nautilus installed**, so if you have an icon on the Unity bar for Files, it links to the old program. Start Nemo, pin it, and unpin the old one.

**UNFORTUNATELY** this has no effect on the File->Open or Save dialogs. Those are rooted in a GTK 2+ vs 3+ issue, which is unclear. Bah.