---
id: 6853
title: NVidia PerfHud ES, Take 2 (Linux)
date: 2014-04-12T15:46:39+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6853
permalink: /2014/04/12/nvidia-perfhud-es-take-2-linux/
categories:
  - Linux
  - Technobabble
---
PerfHud ES is the best OpenGL ES debugger I&#8217;ve used, but it can be a bit tricky to set up. And now that I&#8217;m on Linux, even more so.

[NVidia&#8217;s Page](https://developer.nvidia.com/nvidia-perfhud-es) &#8211; Troubleshooting Notes on [Forum #1](https://devtalk.nvidia.com/default/topic/686032/perfhud-es/perfhud-es-reports-adb-not-available/)

The latest PerfHud ES is now part of the [Tegra Android Development Pack](https://developer.nvidia.com/tegra-android-development-pack) (2.2 as of this writing). An older version is available standalone (2.1), but the latest is now part of the pack. The pack itself is actually a download manager, so it&#8217;s a lightweight download if you uncheck other features.

To get it working, I had to do the following:

**1.** Add adb to my path, by adding it to **~/.profile**

Something like:

<pre>export PATH="/opt/android-sdk/platform-tools:$PATH"</pre>

Which just happens to be where my Android SDK is, and adb is found in the platform-tools folder.

In context of my whole **~/.profile** file.

<pre># ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

export PATH="/opt/android-sdk/platform-tools:$PATH"</pre>

Again, that **last line** is all I added. 

**2.** Log out of Ubuntu, log back in.

You should now be able to an &#8216;adb devices&#8217; from a terminal to see all connected Android devices.

**3.** Connect an NVidia device, and do the following to enable PerfHUD.

<pre>adb shell setprop debug.perfhudes 1</pre>

This needs to be done every time the device reboots.

**4.** Start the app you want to debug (Mine is an SDL App). **\*\*IMPORTANT\*\* DO THIS FIRST!**

**5.** Start PerfHUD ES. **\*\*NOTE\*\* DO THIS SECOND!**

The order of these 2 steps matters. I was not able to get PerfHUD ES to connect to my NVidia Shield unless I started the app first. And after, if I even shutdown the app, I need to exit PerfHUD ES and repeat to reconnect.

**6.** Connect to the running session. You&#8217;ll first see a message in the lower right corner of PerfHUD ES that you are not connected. Click that.

[<img src="/wp-content/uploads/2014/04/NVP01.png" alt="NVP01" width="278" height="51" class="aligncenter size-full wp-image-6861" />](/wp-content/uploads/2014/04/NVP01.png)

If everything worked correctly, you&#8217;ll now be able to click on the currently running instance of the app.

[<img src="/wp-content/uploads/2014/04/NVP2-330x450.png" alt="NVP2" width="330" height="450" class="aligncenter size-medium wp-image-6862" srcset="http://blog.toonormal.com/wp-content/uploads/2014/04/NVP2-330x450.png 330w, http://blog.toonormal.com/wp-content/uploads/2014/04/NVP2.png 410w" sizes="(max-width: 330px) 100vw, 330px" />](/wp-content/uploads/2014/04/NVP2.png)

Click that, and click connect. Moments later the profiling should begin.

[<img src="/wp-content/uploads/2014/04/NVP03-450x253.png" alt="NVP03" width="450" height="253" class="aligncenter size-medium wp-image-6863" srcset="http://blog.toonormal.com/wp-content/uploads/2014/04/NVP03-450x253.png 450w, http://blog.toonormal.com/wp-content/uploads/2014/04/NVP03-640x359.png 640w, http://blog.toonormal.com/wp-content/uploads/2014/04/NVP03.png 1366w" sizes="(max-width: 450px) 100vw, 450px" />](/wp-content/uploads/2014/04/NVP03.png)

Click over to the Frame debugger. That&#8217;s where all the fun stuff is. Scrub through each draw command; View geometry, textures and shaders; and so on.

## Code Changes?

I&#8217;m not sure if this is required or not anymore (probably). If the frame profiling stuff is acting up, you may need to add the following snippet to your code.

<pre>#ifdef USES_EGL 
	{
	    typedef khronos_int64_t EGLint64NV;
	    typedef khronos_uint64_t EGLuint64NV;
	    typedef EGLuint64NV (EGLAPIENTRYP PFNEGLGETSYSTEMTIMEFREQUENCYNVPROC)(void);
	    typedef EGLuint64NV (EGLAPIENTRYP PFNEGLGETSYSTEMTIMENVPROC)(void);
	    PFNEGLGETSYSTEMTIMEFREQUENCYNVPROC eglGetSystemTimeFrequencyNV;
	    PFNEGLGETSYSTEMTIMENVPROC eglGetSystemTimeNV;

	    eglGetSystemTimeFrequencyNV = (PFNEGLGETSYSTEMTIMEFREQUENCYNVPROC)eglGetProcAddress("eglGetSystemTimeFrequencyNV");
		eglGetSystemTimeNV = (PFNEGLGETSYSTEMTIMENVPROC)eglGetProcAddress("eglGetSystemTimeNV");
		//if available use the extension. This enables the frame profiler in PerfHUD ES
		if (eglGetSystemTimeFrequencyNV && eglGetSystemTimeNV) {
			eglGetSystemTimeFrequencyNV();
			eglGetSystemTimeNV();
		}
	}
#endif // USES_EGL //</pre>

The &#8216;USES_EGL&#8217; is a #define of mine. Feel free to omit it. You&#8217;re going to the &#8220;egl.h&#8221; header though.

Hosted on Ubuntu 14.04 (prerelease), with an Intel HD 3000 GPU. No NVidia card (or OpenCL) required. 🙂