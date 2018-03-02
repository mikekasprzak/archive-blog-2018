---
id: 4891
title: A Better MinGW + MSys Shell
date: 2011-12-04T15:38:01+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4891
permalink: /2011/12/04/a-better-mingwmsys-shell/
categories:
  - Technobabble
---
[Pekka](http://www.polygontoys.com) posed a good question recently that got me thinking: The default Bash shell that comes with MinGW (MSys) kinda sucks. You can&#8217;t resize the Window, selections are this odd visible only thing, in essence: it works like an ordinary windows cmd shell.

The solution is surprisingly straight forward: Use [MinTTY](http://code.google.com/p/mintty/).

Open up a MinGW shell, and do the following:

> `mingw-get install mintty`

A few moments later, you&#8217;ll have MinTTY installed. By default, Msys.bat will use its default shell. To explicitly use MinTTY, right click on your MSys shortcut and edit the Target.

> `C:\MinGW\msys\1.0\msys.bat --mintty`

There. Done. Now your MinGW+Msys shell is as good as a typical Linux one.

### Bonus

Now if you REAAAAALY want a bad-ass looking shell, if you have Windows 7 with Aero, right click on the icon in the top left and choose &#8220;**Options&#8230;**&#8220;. Under the Window section you can change default shape of the Window, but the \*cool\* part is the Transparency. Pick the &#8220;Glass&#8221; option. You are welcome.

### Double Bonus

If you&#8217;re modifying a batch file that explicitly starts a shell (Blackberry, like in my prior article), you should call MinTTY as follows:

> `start mintty /bin/bash -l`

&#8220;**start**&#8221; is a batch command that runs the command in a separate thread, thus not halting the current batch file. MinTTY takes any command with arguments as its argument. If you reeeeally want to try something wild, pass the standard Windows CMD shell to it.

> `start mintty cmd`

How do you like them apples?