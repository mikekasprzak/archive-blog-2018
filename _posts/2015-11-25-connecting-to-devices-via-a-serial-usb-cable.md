---
id: 7899
title: Connecting to devices via a Serial USB cable
date: 2015-11-25T14:55:25+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=7899
permalink: /2015/11/25/connecting-to-devices-via-a-serial-usb-cable/
categories:
  - Technobabble
---
Short set of notes.

The most reliable way I&#8217;ve found to connect to a remote device is to open a connection **immediately** after connecting the USB cable to the PC.

At this time, I haven&#8217;t figured out a clean way to disconnect and reconnect without physically unplugging. Closing the **screen** session (ESC->CTRL+A->SHIFT+D->SHIFT+D) makes follow-up connections via the same line unreliable.

EDIT: This should work: <http://askubuntu.com/a/661/364657>

![](http://elinux.org/images/d/d3/RPI_Serial.png)

Connections require the Black **GND** (Ground), White **TX** (Transmit), Green **RX** (Receieve) pins connected. Connecting the Red **VCC** (Power) pin is **STRONGLY** discouraged.

Reference: <http://linux-sunxi.org/UART> [http://linux-sunxi.org/LeMaker\_Banana\_Pi#Adding\_a\_serial_port](http://linux-sunxi.org/LeMaker_Banana_Pi#Adding_a_serial_port)

<pre class="lang:default decode:true " ># Find out what the USB device name is:
ll /dev/ttyUSB*

# Assuming it's ttyUSB0, connect to the device using GNU screen
sudo screen /dev/ttyUSB0 115200
</pre>

Other methods: <https://www.chromium.org/chromium-os/how-tos-and-troubleshooting/debugging-tips/target-serial-access>

<blockquote class="twitter-video" lang="en">
  <p lang="en" dir="ltr">
    Cool! Connecting to the Banana Pi via a Serial cable. I've wanted to figure out how to do this for quite a while. 🙂 <a href="https://t.co/1bhNG6m0Jd">pic.twitter.com/1bhNG6m0Jd</a>
  </p>
  
  <p>
    &mdash; The Mike Kasprzak™ (@mikekasprzak) <a href="https://twitter.com/mikekasprzak/status/669598889209683968">November 25, 2015</a>
  </p>
</blockquote>



And if you&#8217;re feeling silly, data can be send directly to the connected TTY like so.

<pre class="lang:default decode:true " >echo "HEY YOU! GET OFF MY COMPUTER!" &gt; /dev/ttyS0</pre>

<blockquote class="twitter-video" lang="en">
  <p lang="en" dir="ltr">
    And just for fun, sending a bunch of garbage via SSH to the connected Serial cable. 😉 <a href="https://t.co/fj9pK9PnJa">pic.twitter.com/fj9pK9PnJa</a>
  </p>
  
  <p>
    &mdash; The Mike Kasprzak™ (@mikekasprzak) <a href="https://twitter.com/mikekasprzak/status/669600187774541824">November 25, 2015</a>
  </p>
</blockquote>



## Extra

I&#8217;m running Armbian (Ubuntu 14.04) on my Banana.

<http://www.armbian.com/banana-pi/>