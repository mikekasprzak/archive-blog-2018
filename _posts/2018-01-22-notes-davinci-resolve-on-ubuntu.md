---
id: 9846
title: 'Notes: DaVinci Resolve on Ubuntu'
date: 2018-01-22T12:32:00+00:00
author: Mike K
layout: post
guid: /?p=9846
permalink: /2018/01/22/notes-davinci-resolve-on-ubuntu/
categories:
  - Uncategorized
---
DaVinci Resolve is not designed to run on Ubuntu out-of-the-box (it&#8217;s designed for Redhat/CentOS). So we need some trickery.

Download it: <https://www.blackmagicdesign.com/ca/products/davinciresolve/>

Install pre-requisites:

<pre class="lang:default decode:true " >sudo apt-get install libssl-dev libgstreamer-plugins-base1.0-dev
sudo ln -s /lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/lib/libssl.so.10
sudo ln -s /lib/x86_64-linux-gnu/libcrypto.so.1.0.0 /usr/lib/libcrypto.so.10
</pre>

Install OpenCL:

<pre class="lang:default decode:true " >sudo apt install ocl-icd-libopencl1 opencl-headers clinfo ocl-icd-opencl-dev

# Intel IvyBridge+ Support (i.e. 3xxx)
sudo apt install beignet

# Otherwise `clinfo` can't find an OpenCL device</pre>

Install DaVinci Resolve:

<pre class="lang:default decode:true " ># Unzip and enter installer's folder
sudo ./DaVinci_Resolve_14.2_Linux.sh

# say `y` for yes

# now for ease of use, you should own the resolve folder
cd /opt/
sudo chown -R yourname:yourname resolve</pre>

This is about as far as I got.

If you ever need to repeat the genuine install step, you can delete the \`/opt/resolve\` folder and re-run the install. Be sure to re-own the folder though.

\* \* *

Without the OpenCL drivers, I get the welcome first-run, but it never actually starts once configured.

With the OpenCL drivers, the app starts, but warns me it can&#8217;t find a usable GPU.

\* \* *

Also, word has is DaVinci can&#8217;t export MP4 on Linux (at least as of Resolve 14). There&#8217;s also a lot of whining about audio support not quite working right, but I&#8217;m not sure about this yet.