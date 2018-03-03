---
id: 9122
title: 'Notes: Benchmarking VPS Bandwidth'
date: 2016-06-21T11:50:57+00:00
author: Mike K
layout: post
guid: /?p=9122
permalink: /2016/06/21/notes-benchmarking-vps-bandwidth/
categories:
  - Uncategorized
---
Just a quick set of benchmarks, seeing how fast my servers are at downloading and uploading. These aren&#8217;t the be-all/end-all of benchmarks. They&#8217;re just a rough look at what the performance of a machine is.

The following test is used.

<pre class="lang:default decode:true " >wget -O speedtest-cli https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py
chmod +x speedtest-cli

./speedtest-cli</pre>

## Linode, New Jersey: $10 VPS server, 1 core, 2 GB RAM

I&#8217;m pretty happy with these results. This machine has the fastest SSD I&#8217;ve tested, and provide a good benchmark for expected performance.

<pre class="lang:default decode:true " ># Linode New Jersey, $10 plan
Hosted by Optimum Online (New York City, NY) [14.40 km]: 7.7 ms
Download: 1054.00 Mbit/s
Upload: 264.65 Mbit/s

Hosted by Atlantic Metro (New York City, NY) [14.40 km]: 2.265 ms
Download: 834.91 Mbit/s
Upload: 340.14 Mbit/s

Hosted by Atlantic Metro (New York City, NY) [14.40 km]: 2.127 ms
Download: 824.56 Mbit/s
Upload: 342.17 Mbit/s

Hosted by Atlantic Metro (New York City, NY) [14.40 km]: 2.178 ms
Download: 861.00 Mbit/s
Upload: 307.06 Mbit/s</pre>

## Scaleway, Paris: €3 dedicated server, 4 core ARM CPU, 2 GB RAM

One of the most interesting features of Scaleway is that you can get ARM powered servers. This is their €3 ARMv7 powered server with 4 cores and 2 GB of RAM. They don&#8217;t perform as well as Intel servers (about half the SSD performance), but they still do a really impressive job. I&#8217;m really excited about the future of this stuff.

<pre class="lang:default decode:true " ># Scaleway Paris, €3 ARM server
Hosted by NEOTELECOMS (Paris) [1.88 km]: 3.61 ms
Download: 895.26 Mbit/s
Upload: 183.44 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 3.603 ms
Download: 919.67 Mbit/s
Upload: 189.85 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 3.706 ms
Download: 549.18 Mbit/s
Upload: 189.84 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 3.568 ms
Download: 930.56 Mbit/s
Upload: 187.71 Mbit/s</pre>

## Scaleway, Paris: €3 VPS server, 2 core (Atom Xeon), 2 GB of RAM

Their lowest end x86_64 powered server. At this price point you can&#8217;t use add-on storage, but the performance is really decent, especially given the price. 

Due to its low cost, and decent performance and disk space (50 GB), I moved Delorian to one of these.

<pre class="lang:default decode:true " ># Scaleway Paris, €3 VPS server
Hosted by NEOTELECOMS (Paris) [1.88 km]: 3.067 ms
Download: 923.81 Mbit/s
Upload: 385.84 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 3.03 ms
Download: 922.63 Mbit/s
Upload: 351.08 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 2.982 ms
Download: 927.59 Mbit/s
Upload: 391.90 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 2.928 ms
Download: 301.29 Mbit/s
Upload: 381.35 Mbit/s</pre>

## Scaleway, Paris: €24 dedicated server, 8 core (Atom Xeon), 32 GB of RAM, addon 250 GB SSD

The legacy Ludum Dare server. Given the price (a mere €24), and it being a fully dedicated server, I&#8217;m incredibly impressed by the performance. I really wish Scaleway had a domestic datacenter. I&#8217;m loving everything they&#8217;re doing.

<pre class="lang:default decode:true " ># Scaleway Paris, €24 server
Hosted by Orange (Paris) [1.88 km]: 4.299 ms
Download: 625.19 Mbit/s
Upload: 409.61 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 2.101 ms
Download: 907.41 Mbit/s
Upload: 438.38 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 2.022 ms
Download: 863.04 Mbit/s
Upload: 504.48 Mbit/s

Hosted by NEOTELECOMS (Paris) [1.88 km]: 2.275 ms
Download: 781.90 Mbit/s
Upload: 496.49 Mbit/s</pre>