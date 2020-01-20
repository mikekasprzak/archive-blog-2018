---
title: 'Notes: Creating Live OBS Motion Graphics in HTML5'
layout: post
---

This is early, but here are a collection of thoughts when it comes to creating motion graphics for OBS.

# OBS Browser source plugin
Our ability to make live motion graphics that move and even use live data is made possible thanks to the OBS Browser plugin. The plugin ships with the Windows/Mac version of OBS, but the original repo is an important reference.

* Windows, Mac: [https://github.com/obsproject/obs-browser](https://github.com/obsproject/obs-browser)
* Linux: [https://github.com/bazukas/obs-linuxbrowser](https://github.com/bazukas/obs-linuxbrowser)

I have not done much testing with Linux yet, but in quick tests it was working. See the FAQ for some notes on some funny stuff (there's an alpha glitch, but it sounds like it's fixable according to some comments).

# Running a webserver
Unfortunately, the best way to take advantage of the browser plugin is to run a webserver. There are **A LOT** of options here for what you can do.

I'm a Linux guy that uses Windows out of necessity (this blog post is being written on Linux however). For me, a Windows install is incomplete without WSL (Windows Subsystem for Linux). With it, you can install the lastest stable version of Ubuntu using Microsoft's Linux Kernel (yes, you didn't read that wrong). I wont detail how to do that here (one command in an administrator powershell, then use Microsoft store to get Ubuntu 18.04).

With WSL available, you can install helpful packages. I like PHP, and PHP has some nice features we can utilize, such as a built-in webserver:

```bash
php -S localhost:8080
```

This starts a webserver using the local directory as the document root. More details on PHP's builtin webserver: [https://www.php.net/manual/en/features.commandline.webserver.php](https://www.php.net/manual/en/features.commandline.webserver.php)

This is a single threaded server, impractical for live use, but more than adequate for something locally hosted used exclusively by OBS. You also have the option to run PHP code, including reading/writing from local files, or interfacing with a database (though setup is more work).

# window.obsstudio
The OBS Browser source plugin adds `obsstudio` to the `window` namespace, and fills it with functions, data, and events you can tap in to to learn about things happening outside the browser inside OBS. 

Obviously this will be unavailable when testing your pages in the browser. For simple motion graphics it might not be a big deal, but for more advanced work you do have another option.

# Debugging with Chrome Dev Tools
Insert details here. Long story short, you start OBS with a certain argument to specify what port it'll listen on, then use Chrome Dev Tools' remote feature to connect. You'll even get those sweet blue popups.

# OBS Events
By default, OBS loads all browser during startup. This means if you have any timing or fetch requests going on, they will kick-off all at once during application start. This is unlikely an issue, but it's something to think about.

When it comes to animated scenes (tickers, info bars, etc), you can't rely on animations to stay perfectly in sync. However, with a bit of planning, you can at least guarentee that each page is pre-loaded.

The OBS Browser plugin 

# Animated content
Generally speaking, anything you can do in a browser is allowed.

OH HEY, THIS POST IS UNFINISHED. OH WHAT WAS MIKE THINKING WHEN HE WROTE THIS? ;)
