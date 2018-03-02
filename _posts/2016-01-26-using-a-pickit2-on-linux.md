---
id: 8097
title: Using a PICkit2 on Linux
date: 2016-01-26T19:08:34+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=8097
permalink: /2016/01/26/using-a-pickit2-on-linux/
categories:
  - Linux
  - Technobabble
---
Summary.

<blockquote class="twitter-video" lang="en">
  <p lang="en" dir="ltr">
    I'm documenting with a video how I upgraded device firmware using a PIC programmer (generic Chinese PICKit 2). <a href="https://t.co/bYD1ZnFOny">pic.twitter.com/bYD1ZnFOny</a>
  </p>
  
  <p>
    &mdash; The Mike Kasprzak™ (@mikekasprzak) <a href="https://twitter.com/mikekasprzak/status/692126178988199936">January 26, 2016</a>
  </p>
</blockquote>



The PICkit connector is 6 pins, but the last pin is the Auxiliary pin.

<center>
  <img src="http://www.hobbytronics.co.uk/image/data/microchip/pickit2-pinout.jpg" />
</center>

This pin doesn&#8217;t seem to be used that often. The setup could be simplified by snipping the 6th pin.

<https://www.kickstarter.com/projects/1897710270/digirule-the-interactive-binary-ruler/posts/1444571>

<http://www.bradsprojects.com/the-digirule/>

After looking in to it, it seems the PICkit 2 is discontinued.

<http://www.microchip.com/Developmenttools/ProductDetails.aspx?PartNO=DV164121>

There isn&#8217;t even a download link there for the software.

I found the source code a rather backwards way. The link is here:

[http://ww1.microchip.com/downloads/en/DeviceDoc/PICkit2\_PK2CMD\_WIN32\_SourceV1-21\_RC1.zip](http://ww1.microchip.com/downloads/en/DeviceDoc/PICkit2_PK2CMD_WIN32_SourceV1-21_RC1.zip)

A newer device file is here (just overwrite):

<http://www.microchip.com/forums/download.axd?file=0;749972>

I discovered it by grabbing [this package](https://aur.archlinux.org/packages/pk2cmd-plus), opening the PKGBUILD file. As it turns out, they still have the files on their website, they&#8217;re just not linked publicly. 

I&#8217;m not entirely convinced this is the latest version, but it is what I found.

Build like so.

<pre class="lang:default decode:true " >sudo apt-get install libusb-dev libusb-1.0-0-dev libudev-dev

cd pk2cmd
cd pk2cmd
make linux
cp pk2cmd ../release     # we need to be alongside PK2DeviceFile.dat
cd ../release

# running as root is required, or you wont see the device
sudo ./pk2cmd -?v</pre>

That should output this:

<pre class="lang:default decode:true " >Executable Version:    1.21.00
Device File Version:   1.61.00
OS Firmware Version:   2.32.00


Operation Succeeded</pre>

You can then program a hex file. Before you start, figure out the PIC chip you&#8217;re programming, the name of your hex file, and adjust this accordingly.

<pre class="lang:default decode:true " >sudo ./pk2cmd -PPIC18F43K20 -M -F DigiRule\ 18F43K20\ Modified\ 15\ Dec\ 2015.HEX 
</pre>

References:

<http://hsblog.mexchip.com/en/2010/07/how-to-use-the-pickit2-programmer-under-linux/>
  
[http://curuxa.org/en/Program\_PICs\_with\_a\_PICkit2\_using\_the\_command\_line\_on\_Linux](http://curuxa.org/en/Program_PICs_with_a_PICkit2_using_the_command_line_on_Linux)
  
<http://www.waveguide.se/?article=programming-pics-using-the-pickit2-and-pk2cmd>
  
<http://askubuntu.com/questions/434948/install-archlinux-package-pk2cmd-plus-on-ubuntu-12-04-64bit>