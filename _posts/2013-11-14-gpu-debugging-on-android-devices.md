---
id: 6424
title: GPU Debugging on Android Devices
date: 2013-11-14T19:32:25+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6424
permalink: /2013/11/14/gpu-debugging-on-android-devices/
categories:
  - Technobabble
---
Here are some notes on getting the GPU/OpenGL ES debuggers working with devices.

**NVidia&#8217;s Tegra** tool seems the best (even has integrated mesh viewer). **Qualcomm&#8217;s Adreno** tool is also quite good. **ARM&#8217;s MALI** tool is difficult to set up (rooting), but covers the essentials. **Intel&#8217;s GPA** tool is a complete suite, but is only a system usage profiler for Android. **Imagination&#8217;s PowerVR** tools appear good, though I haven&#8217;t tested them yet (one tool requires rooting). **Vivante** provides no tools. Desktop tools not listed.

## Before we start

Things you must do (all tools require it):

  1. Add adb.exe to the path. I.e. the Android SDK folder/platform-tools/ will do the trick.
  2. Confirm that your device is connected by doing an &#8220;adb devices&#8221; from any command prompt or shell. 

If it&#8217;s not available, and you need a driver, you can hack Google&#8217;s USB driver to support your device. 

  1. Open up AndroidSDKDir/extras/google/usb\_driver/android\_winusb.inf in a text editor. 
  2. Note the &#8220;[Google.NTx86]&#8221; and &#8220;[Google.NTamd64]&#8221; sections. These are where you put stuff for 32bit Windows and 64bit Windows.
  3. Copy and make a new ADB definition for the device you are adding. Something like this:
`;Samsung Galaxy Tab 3<br />
%SingleAdbInterface%        = USB_Install, USB\VID_04E8&PID_6860<br />
%CompositeAdbInterface%     = USB_Install, USB\VID_04E8&PID_6860&MI_03</p>
<p>;Lenovo K900<br />
%SingleAdbInterface%        = USB_Install, USB\VID_17EF&PID_75B0<br />
%CompositeAdbInterface%     = USB_Install, USB\VID_17EF&PID_75B0&MI_01</p>
<p>;ONDA VX610W<br />
%SingleAdbInterface%        = USB_Install, USB\VID_18D1&PID_0003<br />
%CompositeAdbInterface%     = USB_Install, USB\VID_18D1&PID_0003&MI_01`

  4. VID&#8217;s and PID&#8217;s you get from the Windows Device Manager.
  1. From the Start Menu, Right click Computer and select Properties. Click Device Manager.
  2. Right Click on the &#8216;broken&#8217; device that doesn&#8217;t have a driver, and click Properties.
  3. Click the Details Tab, then select Hardware IDs from the dropdown box.
This is where you find your VID, PID, and MI. Copy those values in to a layout like shown above. If there&#8217;s extra data there, you can try it if you want, but what&#8217;s important (AFAIK) is the VID, PID, and MI.

  4. Save the file, and now update the driver to use this driver. You should now have a ADB Interface. To test, do an &#8220;adb devices&#8221; from a command prompt/shell.

  5. If a device is still not working, you may need to add the VID to your **adb_usb.ini** file. Either open the file (C:\Users\MyName\.android\adb_usb.ini) or do something like the following:
<pre class="lang:default decode:true " >adb kill-server  
echo 0x2836 &gt;&gt; "%USERPROFILE%\.android\adb_usb.ini"  
adb start-server  </pre>

Use the same VID found in the device manager. For example, 2836 is the Ouya&#8217;s VID.

Source: <https://github.com/ouya/docs/blob/master/setup.md>

## Qualcomm Adreno Profiler

Both USB and WiFi debugging.

Download Adreno Profiler (not the SDK):

[https://developer.qualcomm.com/&#8230;/gaming-graphics-optimization-adreno](https://developer.qualcomm.com/mobile-development/mobile-technologies/gaming-graphics-optimization-adreno)

Add the following line to your AndroidManifest.xml file:

<pre class="lang:default decode:true " >&lt;uses-permission android:name="android.permission.INTERNET"/&gt;</pre>

If you don&#8217;t know where, put it somewhere near the bottom of the file.

This is optional (tool does it automatically), but for reference the following config flag must be set. From a shell do:

<pre class="lang:default decode:true " >adb shell setprop debug.egl.profiler 1</pre>

Which enables profiling.

FYI Adreno devices only supports GPU debugging if **libq3dtools_adreno200.so** is available.

Do the following to confirm whether the file is on the device.

<pre class="lang:default decode:true " >adb shell ls -l /system/lib/egl/libq*</pre>

For me, it&#8217;s available on my 2nd gen Nexus 7.

## NVidia PerfHud ES Tegra

Supports ADB USB and WiFi debugging.

Download the Tegra Android Development Pack here:

<https://developer.nvidia.com/tegra-resources>

It&#8217;s a download installer, so you can deselect the parts you do not want.

Like Adreno, be sure to add the following line to your AndroidManifest.xml file:

<pre class="lang:default decode:true " >&lt;uses-permission android:name="android.permission.INTERNET"/&gt;</pre>

The next command has to be run every time you boot/reboot your Android device:

<pre class="lang:default decode:true " >adb shell setprop debug.perfhudes 1</pre>

NVidia&#8217;s tool, unfortunately, doesn&#8217;t do this automatically for you.

Add the following code to your app, somewhere before you create your OpenGL ES context.

<pre class="lang:default decode:true " >typedef khronos_int64_t EGLint64NV;
typedef khronos_uint64_t EGLuint64NV;
typedef void (GL_APIENTRYP PFNGLCOVERAGEMASKNVPROC) (GLboolean mask);
typedef void (GL_APIENTRYP PFNGLCOVERAGEOPERATIONNVPROC) (GLenum operation);
typedef EGLuint64NV (EGLAPIENTRYP PFNEGLGETSYSTEMTIMEFREQUENCYNVPROC)(void);
typedef EGLuint64NV (EGLAPIENTRYP PFNEGLGETSYSTEMTIMENVPROC)(void);
PFNGLCOVERAGEMASKNVPROC glCoverageMaskNV;
PFNGLCOVERAGEOPERATIONNVPROC glCoverageOperationNV;
PFNEGLGETSYSTEMTIMEFREQUENCYNVPROC eglGetSystemTimeFrequencyNV;
PFNEGLGETSYSTEMTIMENVPROC eglGetSystemTimeNV;

eglGetSystemTimeFrequencyNV = (PFNEGLGETSYSTEMTIMEFREQUENCYNVPROC)eglGetProcAddress("eglGetSystemTimeFrequencyNV");
eglGetSystemTimeNV = (PFNEGLGETSYSTEMTIMENVPROC)eglGetProcAddress("eglGetSystemTimeNV");
//if available use the extension. This enables the frame profiler in PerfHUD ES
if (eglGetSystemTimeFrequencyNV && eglGetSystemTimeNV) {
	eglGetSystemTimeFrequencyNV();
	eglGetSystemTimeNV();
}
</pre>

The Code above requires the EGL headers in addition to the OpenGL ES headers.

<pre class="lang:default decode:true " >#include &lt;GLES2/gl2.h&gt;
#include &lt;GLES2/gl2ext.h&gt;
#include &lt;GLES2/gl2platform.h&gt;

#include &lt;EGL/egl.h&gt;
#include &lt;EGL/eglext.h&gt;
#include &lt;egl/eglplatform.h&gt;</pre>

Tested on an original Nexus 7. Haven&#8217;t tried the Ouya yet.

## ARM MALI Graphics Debugger

NOTE: Requires rooted device.

Supports ADB USB and WiFi Debugging. Tricky setup.

Download is here:

<http://malideveloper.arm.com/develop-for-mali/tools/mali-graphics-debugger/>

Setup instructions for Android are hidden inside the install folder.

<pre>C:\Program Files\ARM\Mali Developer Tools\Mali Graphics Debugger v1.1.0\target\arm_android\</pre>

First, browse to the folder above.

Next mount the system folder like so:

<pre class="lang:default decode:true " >adb shell su -c mount -o remount /system</pre>

Now do the following.

<pre class="lang:default decode:true " >adb push libGLES_mgd.so /sdcard/
adb push mgddaemon /sdcard/

adb shell
su
cd /sdcard/
cp mgddaemon /system/bin/mgddaemon
chmod 777 /system/bin/mgddaemon
cp libGLES_mgd.so /system/lib/egl/libGLES_mgd.so
cp /system/lib/egl/egl.cfg /system/lib/egl/egl.cfg.bak
echo "0 0 mgd" &gt; /system/lib/egl/egl.cfg</pre>

**NOTE:** My OS lacks a &#8220;cp&#8221; command. You can alternatively use &#8220;cat&#8221;. i.e. &#8220;cat mgddaemon > /system/bin/mgddaemon&#8221;. Don&#8217;t forget to redirect!

This installs the daemon and alternative libGLES.so that captures GLES messages (forwarding them to the daemon).

The daemon has one more config option, a file &#8220;/system/lib/egl/processlist.cfg&#8221;. If you put the name of your app in that file (i.e. **org.libsdl.app** if using stock SDL2), then that will the only process traced. Otherwise omitting the file will cause the daemon and library to trace all running GLES apps (which can confuse the debugger).

Shut down all instances of your app, then decide if you want a USB or WiFi connection. 

For USB, do the following:

<pre class="lang:default decode:true " >adb forward tcp:5002 tcp:5002</pre>

This will make the IP you enter 127.0.0.1 (i.e. localhost) on port 5002.

For WiFi, you&#8217;re already ready. Just lookup the devices IP address in either Settings->Networking or About.

Finally, start the daemon.

<pre class="lang:default decode:true " >adb shell
su
mgddaemon</pre>

And you should now be able to punch in the IP address (either the device or localhost) in to the Mali Graphics Debugger App.

Tested on an obscure Chinese tablet called the ONDA VX6010W (Allwinner A10 SOC) running Android 4.1. I also have a GameStick, but I haven&#8217;t tried that yet (didn&#8217;t want to root it).

**TIPS:**
  
To disable the capture library, copy your backup (egl.cfg.bak) to &#8220;egl.cfg&#8221;.

<pre class="lang:default decode:true " >cp /system/lib/egl/egl.cfg.bak /system/lib/egl/egl.cfg</pre>

You might want to keep a copy of the mgd version around, for ease.

Another tip: I made a typo in one of my filenames (egl.cgf). Running the daemon will allow the Mali Graphics Debugger to connect to the device, but if &#8220;egl.cfg&#8221; isn&#8217;t the correct file (the mgd version) then you will get no trace data.

## Imagination (PowerVR) PVRTrace and PVRTune

NOTE: PVRTrace requires a rooted device.

Supports ADB USB and WiFi debugging (depending on tool).

Download here, as part of the PowerVR SDK.

<http://www.imgtec.com/powervr/insider/sdkdownloads/index.asp>

Have only done some initial tests with this. As it turns out, none of my PowerVR GPU devices are working with my SDL2 code (both ARM and x86 CPUs), so I can&#8217;t really verify if this is working yet (well I can, but I don&#8217;t want to).

## Intel Graphics Performance Analyzer (GPA) for Android

Supports ADB USB debugging.

Download is here:

<http://software.intel.com/en-us/vcsource/tools/intel-gpa>

Like others, be sure to add the following line to your AndroidManifest.xml file:

<pre class="lang:default decode:true " >&lt;uses-permission android:name="android.permission.INTERNET"/&gt;</pre>

After that, **Intel GPA System Analyzer** will just work. This is a profiler tool with realtime usage graphs.

Unfortunately, this is the only tool in the Intel GPA suite supported by Android.

Tested on a Lenovo K900, and a Samsung Galaxy Tab 3.

## OpenGL Extension GL\_KHR\_debug

This is an interesting extension available on certain GPUs (MALI 600 series GPUs, all OpenGL 4.3+ drivers). It provides far better debug logging of errors and things in OpenGL and OpenGL ES.

Some useful links:

<http://www.opengl.org/registry/specs/KHR/debug.txt>
  
<http://www.opengl.org/wiki/Debug_Output>
  
<http://renderingpipeline.com/2013/09/opengl-debugging-with-khr_debug/>
  
[http://malideveloper.arm.com/&#8230;/easier-opengl-es-debugging-on-arm-mali-gpus-with-gl\_khr\_debug/](http://malideveloper.arm.com/uncategorized/easier-opengl-es-debugging-on-arm-mali-gpus-with-gl_khr_debug/)

The original extension, available on AMD GPUs.

<http://www.opengl.org/registry/specs/AMD/debug_output.txt>