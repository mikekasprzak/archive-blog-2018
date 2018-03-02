---
id: 6142
title: Evaluating JavaScript to Native-App Packagers
date: 2013-05-07T23:31:51+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6142
permalink: /2013/05/07/evaluating-javascript-to-native-app-packagers/
categories:
  - Technobabble
---
EDIT: For reference I&#8217;m leaving this post as-is (except for the new ending), but it seems AppJS is a lot more painful to use after all. Ugh.

* * *

Long story short, I need to write a tool with a UI. I want it to be portable, just in case. And because JavaScript is &#8220;fine&#8221;, I&#8217;m investigating what packaging options there are. 

I&#8217;m not doing a very scientific test. All I&#8217;m doing is throwing TOOM, an adventure game Derek Laufman and I made for Ludum Dare 26 at it. If it works, I&#8217;m happy. If it fails, I&#8217;m not. 

TOOM uses SoundJS and PreloadJS. PreloadJS wont work if the browser is reading from the local file system (i.e. file:///blah.html). So developing TOOM, I&#8217;ve had to use a tiny webserver running locally (currently [Mongoose](http://code.google.com/p/mongoose/), was [MiniWeb](http://sourceforge.net/projects/miniweb/)).

## Chrome Packaged Apps

<http://developer.chrome.com/apps/about_apps.html>

Despite the name, despite the wording, this doesn&#8217;t create standalone apps. It creates content for distribution by Google&#8217;s Chrome App Store only. 

It&#8217;s also not officially live yet. You can make apps, test them, but can&#8217;t Publish. Beh.

## Node-Webkit

<https://github.com/rogerwang/node-webkit>

A good simple solution, based on NodeJS and Chromium, regularly updated (Intel Sponsored), but fails the TOOM test. It starts loading, but dies at an unusual place (complaining about one of my source files missing&#8230; which is definitely there if it can start loading at all).

Adds about **54 MB** to the total size (~23 MB zipped).

## AppJS

<http://appjs.org/>

A fantastic solution, also based on NodeJS and Chromium, and so far the only thing to pass the TOOM test (no audio and slower, so clearly using an older version of Chromium). The very very saddening part however is that there&#8217;s [only 1 guy on the project](https://groups.google.com/forum/#!topic/appjs-dev/IWRN8FaAheU), and he&#8217;s too busy.

Also adds about **54 MB** to the total size (~22 MB zipped).

## Visual Studio 2012

<http://www.microsoft.com/visualstudio/eng#downloads>

Untested, but this option is Windows only, and there may be other caveats. Any code written for DiskIO and file manipulation will only work on Windows. No WebGL support. That said, the JS code may compile down to CLI bytecodes (dot net), so performance might be better. Also how an app is structured may not mirror how a web project is created (index.html and all files). Untested though.

## Adobe Air

<http://www.adobe.com/devnet/air/air-sdk-download.html>

Nope. Created my [descriptor file](http://help.adobe.com/en_US/air/build/WS5b3ccc516d4fbf351e63e3d118666ade46-7ff1.html), modified it to use the HTML file, then ran it with adl (adl D:\Toom\application.xml). After fixing the one bug it reported, it just sits there&#8230; waiting. Running I assume, but there&#8217;s no action.

**NOTE:** Instructions for running and packaging I found inside &#8220;AIR SDK Readme.txt&#8221; in AirSDK.

## TideSDK

<http://www.tidesdk.org/>

Formerly known as Appcelerator Titanium for Desktop.

Finally, another one that passes the TOOM test. TideSDK is based on Webkit, but a seemingly an older version of webkit. CSS Fonts did not work, the framerate was even slower than AppJS, and no audio. Still, it was interesting. Downside is they seem to be short on funds too; Their blog reminds me of PBS.

## More choices, no good ones

<http://stackoverflow.com/questions/11015811/html5-desktop-wrapper-framework>

## Conclusion

There&#8217;s no safe/good/active choice, but AppJS impressed me the most. As far as portability goes, I think what I want to be using is something that combines Chrome and NodeJS, but not Webkit. Plus it gives me a reason to learn NodeJS too. My Browser performance and debugging experience is just so much better with Chrome, even though I don&#8217;t use it as a primary browser (I use Firefox instead).

Regrettably AppJS right now today is a bit of a gamble, since it&#8217;s just one dude behind it, and he&#8217;s made it clear he doesn&#8217;t have the time. But it does exactly what I want, so \*shrug\*. There&#8217;s talk of a Kickstarter, and I hope this sees the light of day. Totally a worthwhile project.

## PLOT TWIST!

Not a good one though.

Something I hadn&#8217;t really realized before was how AppJS is actually working. From what I can tell, it&#8217;s actually running a small web server, i.e. the NodeJS part. Your main JS script file is standalone and disconnected from what runs in the browser context&#8230; YET, you control maximizing/minimizing windows, the contents of menus, task bar appearance from the NodeJS side. Your app is standalaone, caged inside the browser context.

Now, there may be a way to pass data between the NodeJS side and Chromium side, similar to making web requests in general. It&#8217;s not documented though, so \*sigh\* not sure where to start.

Node-Webkit might actually be more of what I want, since it&#8217;s about introducing the Node features in to Webkit. That said, it failed the TOOM test.

Ah well, enough of this for now.

<!--more-->

## More (Unrelated) Notes

Appcelerator&#8217;s Titanium I missed when looking at HTML5 to Mobile options. 

Free, or ~$12000 a year (haha): 

<http://www.appcelerator.com/platform/titanium-platform/>

Jo is an interesting JS UI Kit I wasn&#8217;t aware of before.

<http://joapp.com/>

There&#8217;s a thing called Chromium Embedded:

[stackoverflow.com/how-to-develop-desktop-apps-using-html-css-javascript](http://stackoverflow.com/questions/12232784/how-to-develop-desktop-apps-using-html-css-javascript)