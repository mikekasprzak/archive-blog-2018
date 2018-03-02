---
id: 7671
title: Notes + Benchmarking read/write speeds of Microservers
date: 2015-10-23T19:14:49+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=7671
permalink: /2015/10/23/benchmarking-readwrite-speeds-of-microservers/
categories:
  - Uncategorized
---
The following are a bunch of notes and numbers. 

I am gauging the performance of various devices reading from and writing to their memories.

<!--more-->

## The Benchmark

<pre class="lang:default decode:true " >cd /path/to/SSD

# Write
dd if=/dev/zero of=tempfile bs=1M count=1024 conv=fdatasync,notrunc

# Clear Cache. NOTE: Will not work on OpenVZ (you don't have kernel permissions)
sudo sh -c "echo 3 &gt; /proc/sys/vm/drop_caches"

# Read
dd if=tempfile of=/dev/null bs=1M count=1024</pre>

Reference: <https://wiki.archlinux.org/index.php/SSD_Benchmarking>

## Installing an img on an SD Card

<pre class="lang:default decode:true " ># List devices
df -h

# ...

dd bs=4M if=2015-09-24-raspbian-jessie.img of=/dev/sdd</pre>

Reference: https://www.raspberrypi.org/documentation/installation/installing-images/linux.md

## Resizing an SD card Partition to utilize entire space

<pre class="lang:default decode:true " ># List partitions
df -h

# Even if not list, it's probably called /dev/mmcSOMETHING

# Start FDISK utility. NOTE: You *MUST* finish before exiting, or cancel
sudo fdisk /dev/mmcblk0    # Without pX (partitions)

p       # list partitions
d       # delete partition
2       # In our case, we're deleting the Linux partition (2).
# Be sure to remember the starting block position, otherwise this is very bad.
# If you have multiple partitions (other than boot), delete them all

n       # new partition
p       # primary partition
2       # partition number 2 (our default)
206848  # our original start sector (may be the default)
(enter) # the default is probably the true last sector
p       # list partitions, confirm it was added correctly.
# Be sure you remember the root partition name. Ours is /dev/mmcblk0p2
# At this point, the partition table should be the same, but the end sector is bigger.

w       # write partition table
# this commits the changes, writing them to disk. fdisk exits.

# you may need a reboot
sudo reboot

# reconnect

# check partition size (should be the same)
df -h

# resize the partition (we only allocated sectors before)
sudo resize2fs /dev/mmcblk0p2

# check the partition size again
df -h</pre>

Reference: <http://raspberrypi.stackexchange.com/a/501>

## Using Screen

tap ESC, then push CTRL+A, followed by a command shorthand.

<pre class="lang:default decode:true " >screen -ls           # list all screens

screen -r            # resume
ESC->CTRL+A->d       # disconnect

ESC->CTRL+A->n       # new window
ESC->CTRL+A->0 .. 9  # switch to window 0 ... 9

ESC->CTRL+A->?       # help
</pre>

Reference: <https://wiki.archlinux.org/index.php/GNU_Screen>
  
Reference: [**http://aperiodic.net/screen/quick_reference**](http://aperiodic.net/screen/quick_reference)

## Lenovo X230t Laptop

Included to know what the upper limit should be.

Internal SSD (Samsung &#8230; something):

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 2.59162 s, 414 MB/s
1073741824 bytes (1.1 GB) copied, 2.63253 s, 408 MB/s
1073741824 bytes (1.1 GB) copied, 2.6651 s, 403 MB/s
1073741824 bytes (1.1 GB) copied, 2.36982 s, 453 MB/s (overwriting)
1073741824 bytes (1.1 GB) copied, 2.3629 s, 454 MB/s (overwriting)

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 2.06167 s, 521 MB/s
1073741824 bytes (1.1 GB) copied, 2.0529 s, 523 MB/s
1073741824 bytes (1.1 GB) copied, 2.0342 s, 528 MB/s
1073741824 bytes (1.1 GB) copied, 2.03141 s, 529 MB/s (different file)

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 0.176797 s, 6.1 GB/s
1073741824 bytes (1.1 GB) copied, 0.18551 s, 5.8 GB/s
1073741824 bytes (1.1 GB) copied, 0.156863 s, 6.8 GB/s
1073741824 bytes (1.1 GB) copied, 0.15621 s, 6.9 GB/s
1073741824 bytes (1.1 GB) copied, 0.153973 s, 7.0 GB/s

1073741824 bytes (1.1 GB) copied, 0.166121 s, 6.5 GB/s
1073741824 bytes (1.1 GB) copied, 0.139388 s, 7.7 GB/s
1073741824 bytes (1.1 GB) copied, 0.140675 s, 7.6 GB/s
1073741824 bytes (1.1 GB) copied, 0.131831 s, 8.1 GB/s
1073741824 bytes (1.1 GB) copied, 0.124236 s, 8.6 GB/s
1073741824 bytes (1.1 GB) copied, 0.12412 s, 8.7 GB/s</pre>

ADATA 128 GB **30/10** MicroSD Card (AUSDX128GUICL10-RA1) via internal SD adapter

<pre class="lang:default decode:true " ># Write (rated at 10 MB/s) - Roughly 90 seconds
1073741824 bytes (1.1 GB) copied, 93.2429 s, 11.5 MB/s
1073741824 bytes (1.1 GB) copied, 92.5107 s, 11.6 MB/s
1073741824 bytes (1.1 GB) copied, 91.6573 s, 11.7 MB/s

# Read (Uncached)
N/A (bad data)

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 0.141538 s, 7.6 GB/s
1073741824 bytes (1.1 GB) copied, 0.123572 s, 8.7 GB/s
1073741824 bytes (1.1 GB) copied, 0.132434 s, 8.1 GB/s
</pre>

Kingston 64bit **90/80** MicroSD Card (SDCA3/64GB) via USB 3.0

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 17.1442 s, 62.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 17.9567 s, 59.8 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 16.0285 s, 67.0 MB/s

# Overwrite
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 15.2259 s, 70.5 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 16.0246 s, 67.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 13.4884 s, 79.6 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 33.7348 s, 31.8 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 30.5618 s, 35.1 MB/s # repeated
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 27.4137 s, 39.2 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 27.4035 s, 39.2 MB/s

# Read (cached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.215331 s, 5.0 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.225954 s, 4.8 GB/s # repeated
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.189487 s, 5.7 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.157405 s, 6.8 GB/s
</pre>

Kingston 64 GB **90/80** MicroSD Card (SDCA3/64GB) via internal SD Adapter

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 77.0062 s, 13.9 MB/s
1073741824 bytes (1.1 GB) copied, 76.4409 s, 14.0 MB/s
1073741824 bytes (1.1 GB) copied, 76.263 s, 14.1 MB/s

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 55.6474 s, 19.3 MB/s

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 0.175764 s, 6.1 GB/s
1073741824 bytes (1.1 GB) copied, 0.152636 s, 7.0 GB/s
1073741824 bytes (1.1 GB) copied, 0.160267 s, 6.7 GB/s
</pre>

Corsair Voyager Vega 64 GB USB Key, via USB 3.0 (???)

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 80.225 s, 13.4 MB/s
1073741824 bytes (1.1 GB) copied, 76.5936 s, 14.0 MB/s (overwrite)
1073741824 bytes (1.1 GB) copied, 84.7488 s, 12.7 MB/s

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 18.6884 s, 57.5 MB/s
1073741824 bytes (1.1 GB) copied, 19.5643 s, 54.9 MB/s

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 0.173217 s, 6.2 GB/s
1073741824 bytes (1.1 GB) copied, 0.169939 s, 6.3 GB/s
1073741824 bytes (1.1 GB) copied, 0.163271 s, 6.6 GB/s
</pre>

Samsung Pro 32GB MicroSD (Gray) via USB 3.0 adapter

<pre class="lang:default decode:true " ># Write (FAT)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 14.9774 s, 71.7 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 15.3357 s, 70.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 14.8211 s, 72.4 MB/s

# Read (FAT)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.321 s, 44.1 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.3288 s, 44.1 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 24.3539 s, 44.1 MB/s

# Write (EXT4)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 15.242 s, 70.4 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 15.2753 s, 70.3 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 15.1 s, 71.1 MB/s

# Read (EXT4)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 27.0654 s, 39.7 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 27.1888 s, 39.5 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 27.1069 s, 39.6 MB/s
</pre>

Kingston 32GB MicroSD (Red SDHC I3) via USB 3.0 adapter

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 31.6442 s, 33.9 MB/s
1073741824 bytes (1.1 GB) copied, 25.5272 s, 42.1 MB/s
1073741824 bytes (1.1 GB) copied, 32.6487 s, 32.9 MB/s
1073741824 bytes (1.1 GB) copied, 32.4242 s, 33.1 MB/s

# Overwrite
1073741824 bytes (1.1 GB) copied, 28.6196 s, 37.5 MB/s
1073741824 bytes (1.1 GB) copied, 32.3355 s, 33.2 MB/s
1073741824 bytes (1.1 GB) copied, 32.0218 s, 33.5 MB/s
1073741824 bytes (1.1 GB) copied, 32.2638 s, 33.3 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB) copied, 29.0168 s, 37.0 MB/s
1073741824 bytes (1.1 GB) copied, 28.946 s, 37.1 MB/s
1073741824 bytes (1.1 GB) copied, 29.015 s, 37.0 MB/s
1073741824 bytes (1.1 GB) copied, 28.9601 s, 37.1 MB/s

# Read (cached)
1073741824 bytes (1.1 GB) copied, 0.158018 s, 6.8 GB/s
1073741824 bytes (1.1 GB) copied, 0.139792 s, 7.7 GB/s
1073741824 bytes (1.1 GB) copied, 0.135422 s, 7.9 GB/s
1073741824 bytes (1.1 GB) copied, 0.139144 s, 7.7 GB/s
</pre>

ADATA 16GB MicroSD Card (Gray Stripe) via USB 3.0 adapter

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 101.123 s, 10.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 104.218 s, 10.3 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 100.335 s, 10.7 MB/s

# Overwrite
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 97.7848 s, 11.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 97.7038 s, 11.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 97.4388 s, 11.0 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 34.3683 s, 31.2 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 34.4652 s, 31.2 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 34.4314 s, 31.2 MB/s

# Read (cached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.173477 s, 6.2 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.224436 s, 4.8 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.224006 s, 4.8 GB/s
</pre>

ADATA 16GB MicroSD Card (plain black) via USB 3.0 adapter

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 70.6687 s, 15.2 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 63.4473 s, 16.9 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 66.2539 s, 16.2 MB/s

# Overwrite
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 68.8228 s, 15.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 61.1013 s, 17.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 60.6379 s, 17.7 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 57.8704 s, 18.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 57.6801 s, 18.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 57.4006 s, 18.7 MB/s
</pre>

Kingston 16GB MicroSD Card (yellow) via USB 3.0 adapter

<pre class="lang:default decode:true " ># Write (Fat32)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 22.3552 s, 48.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 22.2474 s, 48.3 MB/s

# Read (uncached Fat32)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 33.606 s, 32.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 33.3824 s, 32.2 MB/s

# Write (EXT4)
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 30.9588 s, 34.7 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 31.1349 s, 34.5 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 25.381 s, 42.3 MB/s    # retry
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 27.2845 s, 39.4 MB/s   # retry

# Read (uncached EXT4)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 44.1094 s, 24.3 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 34.662 s, 31.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 34.8781 s, 30.8 MB/s   # retry
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 34.6417 s, 31.0 MB/s   # retry
</pre>

Xedain 8GB MicroSD Card via USB 3.0 adapter

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 90.1806 s, 11.9 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 84.621 s, 12.7 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 85.2965 s, 12.6 MB/s

# Overwrite
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 89.1368 s, 12.0 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 83.4746 s, 12.9 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 84.1791 s, 12.8 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 56.9566 s, 18.9 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 57.1012 s, 18.8 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 56.9073 s, 18.9 MB/s

# Read (cached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.223226 s, 4.8 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.225522 s, 4.8 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.215112 s, 5.0 GB/s
</pre>

## Scaleway C1

Cheap ARM server (3 EUR). 4 core ARMv7, 2 GB RAM, with 50 GB virtual SSD.

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 10.9507 s, 98.1 MB/s
1073741824 bytes (1.1 GB) copied, 11.0521 s, 97.2 MB/s
1073741824 bytes (1.1 GB) copied, 11.2315 s, 95.6 MB/s
1073741824 bytes (1.1 GB) copied, 9.42122 s, 114 MB/s (overwrite)
1073741824 bytes (1.1 GB) copied, 9.38186 s, 114 MB/s (overwrite)
1073741824 bytes (1.1 GB) copied, 9.51808 s, 113 MB/s (overwrite)

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 12.0005 s, 89.5 MB/s
1073741824 bytes (1.1 GB) copied, 12.0267 s, 89.3 MB/s
1073741824 bytes (1.1 GB) copied, 11.5052 s, 93.3 MB/s

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 1.16794 s, 919 MB/s
1073741824 bytes (1.1 GB) copied, 1.10516 s, 972 MB/s
1073741824 bytes (1.1 GB) copied, 1.29096 s, 832 MB/s
</pre>

## Scaleway VC1 (VPS)

Cheap x86_64 server (3 EUR). 2 core Atom Xeon, 2 GB RAM, with 50 GB virtual SSD.

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 11.1211 s, 96.6 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 14.9836 s, 71.7 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.89704 s, 219 MB/s

# Overwrite
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.44029 s, 242 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.33701 s, 248 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.65368 s, 231 MB/s

# Read (Uncached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.06053 s, 264 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.2412 s, 253 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.93506 s, 218 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 5.09887 s, 211 MB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.2991 s, 250 MB/s

# Read (Cached)
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.469783 s, 2.3 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.12982 s, 260 MB/s # miss
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 1.2764 s, 841 MB/s  # partial
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.4807 s, 2.2 GB/s
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.76198 s, 225 MB/s # miss
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 4.43604 s, 242 MB/s # miss
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 0.457553 s, 2.3 GB/s
</pre>

## Scaleway C2L

Cheap x86_64 server (24 EUR). 8 core Atom Xeon, 32 GB RAM, with 50 GB virtual SSD and attached 250 GB SSD.

Main 50 GB Drive (/dev/ndb0)

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 6.67994 s, 161 MB/s
1073741824 bytes (1.1 GB) copied, 7.5194 s, 143 MB/s
1073741824 bytes (1.1 GB) copied, 7.12048 s, 151 MB/s
1073741824 bytes (1.1 GB) copied, 7.78347 s, 138 MB/s
1073741824 bytes (1.1 GB) copied, 6.98133 s, 154 MB/s

# Overwrite
1073741824 bytes (1.1 GB) copied, 4.61103 s, 233 MB/s
1073741824 bytes (1.1 GB) copied, 4.6015 s, 233 MB/s
1073741824 bytes (1.1 GB) copied, 4.59822 s, 234 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB) copied, 9.03258 s, 119 MB/s
1073741824 bytes (1.1 GB) copied, 10.3847 s, 103 MB/s
1073741824 bytes (1.1 GB) copied, 8.63121 s, 124 MB/s
1073741824 bytes (1.1 GB) copied, 8.64831 s, 124 MB/s
1073741824 bytes (1.1 GB) copied, 8.05503 s, 133 MB/s

# Read (cached)
1073741824 bytes (1.1 GB) copied, 0.453691 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.446853 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.445374 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.440322 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.452762 s, 2.4 GB/s
</pre>

Attached 250 GB Drive (/dev/sda)

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 5.73234 s, 187 MB/s
1073741824 bytes (1.1 GB) copied, 5.72847 s, 187 MB/s
1073741824 bytes (1.1 GB) copied, 5.73892 s, 187 MB/s
1073741824 bytes (1.1 GB) copied, 5.7369 s, 187 MB/s
1073741824 bytes (1.1 GB) copied, 5.73622 s, 187 MB/s

# Overwrite
1073741824 bytes (1.1 GB) copied, 4.90392 s, 219 MB/s
1073741824 bytes (1.1 GB) copied, 4.90659 s, 219 MB/s
1073741824 bytes (1.1 GB) copied, 4.90955 s, 219 MB/s
1073741824 bytes (1.1 GB) copied, 4.91107 s, 219 MB/s
1073741824 bytes (1.1 GB) copied, 4.9012 s, 219 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB) copied, 3.82822 s, 280 MB/s
1073741824 bytes (1.1 GB) copied, 3.81846 s, 281 MB/s
1073741824 bytes (1.1 GB) copied, 3.82104 s, 281 MB/s
1073741824 bytes (1.1 GB) copied, 3.82015 s, 281 MB/s
1073741824 bytes (1.1 GB) copied, 3.82033 s, 281 MB/s

# Read (cached)
1073741824 bytes (1.1 GB) copied, 0.440315 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.447487 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.445015 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.446727 s, 2.4 GB/s
1073741824 bytes (1.1 GB) copied, 0.438764 s, 2.4 GB/s
</pre>

## Parallella

Headless computer, Ubuntu.

ADATA 16 GB **30/10** MicroSD Card (AUSDH16GUICL10-RA1)

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 119.793 s, 9.0 MB/s
1073741824 bytes (1.1 GB) copied, 117.449 s, 9.1 MB/s
1073741824 bytes (1.1 GB) copied, 116.055 s, 9.3 MB/s

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 53.6514 s, 20.0 MB/s
1073741824 bytes (1.1 GB) copied, 53.5887 s, 20.0 MB/s

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 49.3475 s, 21.8 MB/s
1073741824 bytes (1.1 GB) copied, 49.322 s, 21.8 MB/s
1073741824 bytes (1.1 GB) copied, 53.5546 s, 20.0 MB/s
</pre>

Kingston 64 GB **90/80** MicroSD Card (SDCA3/64GB) 

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 76.0194 s, 14.1 MB/s
1073741824 bytes (1.1 GB) copied, 59.7761 s, 18.0 MB/s
1073741824 bytes (1.1 GB) copied, 58.0052 s, 18.5 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB) copied, 56.6118 s, 19.0 MB/s
1073741824 bytes (1.1 GB) copied, 56.0603 s, 19.2 MB/s
1073741824 bytes (1.1 GB) copied, 56.085 s, 19.1 MB/s

# Read (cached)
1073741824 bytes (1.1 GB) copied, 50.8179 s, 21.1 MB/s
1073741824 bytes (1.1 GB) copied, 51.0271 s, 21.0 MB/s
1073741824 bytes (1.1 GB) copied, 50.7336 s, 21.2 MB/s
</pre>

ADATA 128 GB **30/10** MicroSD Card (AUSDX128GUICL10-RA1)

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 110.11 s, 9.8 MB/s (first disk write post resize)
1073741824 bytes (1.1 GB) copied, 78.8937 s, 13.6 MB/s
1073741824 bytes (1.1 GB) copied, 70.4824 s, 15.2 MB/s
1073741824 bytes (1.1 GB) copied, 67.4753 s, 15.9 MB/s
1073741824 bytes (1.1 GB) copied, 65.8105 s, 16.3 MB/s
1073741824 bytes (1.1 GB) copied, 65.3539 s, 16.4 MB/s (larger block size)

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 54.9477 s, 19.5 MB/s
1073741824 bytes (1.1 GB) copied, 54.9549 s, 19.5 MB/s
1073741824 bytes (1.1 GB) copied, 55.0146 s, 19.5 MB/s

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 53.4705 s, 20.1 MB/s
1073741824 bytes (1.1 GB) copied, 53.4705 s, 20.1 MB/s
1073741824 bytes (1.1 GB) copied, 53.5365 s, 20.1 MB/s
</pre>

## C.H.I.P. by NextThingCo

CHIP uses UBIFS, which a newfangled File System designed for Flash Memory. It&#8217;s a compressed file system, so this benchmark isn&#8217;t exactly reliable (Read speeds are reported as terrible, even though they&#8217;re good).

4 GB Internal EMMC

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 32.4092 s, 33.1 MB/s
1073741824 bytes (1.1 GB) copied, 32.6061 s, 32.9 MB/s
1073741824 bytes (1.1 GB) copied, 31.6823 s, 33.9 MB/s

# Read
Unable to complete 1.1 GB test (I got tired of waiting).
835715072 bytes (836 MB) copied, 244.476 s, 3.4 MB/s
</pre>

4 GB Internal EMCC, attempt 2

<pre class="lang:default decode:true " ># Write
268435456 bytes (268 MB) copied, 5.54209 s, 48.4 MB/s
268435456 bytes (268 MB) copied, 6.17655 s, 43.5 MB/s
268435456 bytes (268 MB) copied, 6.98726 s, 38.4 MB/s

# Read
268435456 bytes (268 MB) copied, 78.4964 s, 3.4 MB/s
268435456 bytes (268 MB) copied, 79.2132 s, 3.4 MB/s
</pre>

## Linode VPS New Jersey

$10/mo plan. 1 core, 1 GB of RAM, 24 GB SSD, 2 GB Transfer.

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 1.495 s, 718 MB/s
1073741824 bytes (1.1 GB) copied, 1.03649 s, 1.0 GB/s (overwrite)
1073741824 bytes (1.1 GB) copied, 1.14237 s, 940 MB/s (overwrite)
1073741824 bytes (1.1 GB) copied, 1.31351 s, 817 MB/s

# Read (Uncached)
1073741824 bytes (1.1 GB) copied, 0.991 s, 1.1 GB/s
1073741824 bytes (1.1 GB) copied, 0.918084 s, 1.2 GB/s
1073741824 bytes (1.1 GB) copied, 0.902052 s, 1.2 GB/s

# Read (Cached)
1073741824 bytes (1.1 GB) copied, 1.09312 s, 982 MB/s
1073741824 bytes (1.1 GB) copied, 0.935663 s, 1.1 GB/s
1073741824 bytes (1.1 GB) copied, 1.02447 s, 1.0 GB/s
</pre>

## BuyVM New Jersey

**$3/mo** (6 months). **2 core**. 256 MB RAM. **30 GB SSD**. 1 TB Transfer. Open VZ.

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 5.02888 s, 214 MB/s
1073741824 bytes (1.1 GB) copied, 5.65072 s, 190 MB/s
1073741824 bytes (1.1 GB) copied, 6.70994 s, 160 MB/s

# Read
1073741824 bytes (1.1 GB) copied, 13.6156 s, 78.9 MB/s
1073741824 bytes (1.1 GB) copied, 3.40141 s, 316 MB/s
1073741824 bytes (1.1 GB) copied, 1.84613 s, 582 MB/s
1073741824 bytes (1.1 GB) copied, 11.0944 s, 96.8 MB/s
1073741824 bytes (1.1 GB) copied, 1.57487 s, 682 MB/s
1073741824 bytes (1.1 GB) copied, 8.98369 s, 120 MB/s
</pre>

## Vultr New Jersey

$5/mo plan. 1 core, **768 MB of RAM**, 15 GB SSD, 1 TB Transfer.

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 2.59599 s, 414 MB/s
1073741824 bytes (1.1 GB) copied, 2.70799 s, 397 MB/s
1073741824 bytes (1.1 GB) copied, 2.90959 s, 369 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB) copied, 4.29447 s, 250 MB/s
1073741824 bytes (1.1 GB) copied, 4.46007 s, 241 MB/s
1073741824 bytes (1.1 GB) copied, 4.31757 s, 249 MB/s

# Read (cached)
1073741824 bytes (1.1 GB) copied, 4.27409 s, 251 MB/s
1073741824 bytes (1.1 GB) copied, 5.10931 s, 210 MB/s
1073741824 bytes (1.1 GB) copied, 5.30495 s, 202 MB/s
</pre>

## Digital Ocean New Jersey

$5/mo plan. 1 Core, 512 MB RAM, 20 GB SSD, 1 TB Transfer.

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 3.28214 s, 327 MB/s
1073741824 bytes (1.1 GB) copied, 2.15066 s, 499 MB/s
1073741824 bytes (1.1 GB) copied, 2.71021 s, 396 MB/s

# Read (uncached)
1073741824 bytes (1.1 GB) copied, 1.77433 s, 605 MB/s
1073741824 bytes (1.1 GB) copied, 2.3736 s, 452 MB/s
1073741824 bytes (1.1 GB) copied, 2.39445 s, 448 MB/s

# Read (cached)
1073741824 bytes (1.1 GB) copied, 1.90089 s, 565 MB/s
1073741824 bytes (1.1 GB) copied, 1.68883 s, 636 MB/s
1073741824 bytes (1.1 GB) copied, 1.71254 s, 627 MB/s
</pre>

## Servint Ludum Dare Server (legacy)

Uh, we&#8217;re paying nearly $200 for 12 GB of RAM and&#8230;

<pre class="lang:default decode:true " ># Write
1073741824 bytes (1.1 GB) copied, 21.7592 seconds, 49.3 MB/s
1073741824 bytes (1.1 GB) copied, 20.7526 seconds, 51.7 MB/s
1073741824 bytes (1.1 GB) copied, 19.5777 seconds, 54.8 MB/s
1073741824 bytes (1.1 GB) copied, 23.7394 seconds, 45.2 MB/s
1073741824 bytes (1.1 GB) copied, 24.7744 seconds, 43.3 MB/s

# Read (uncached) - Can't explicitly kill cache, so best simulated 
1073741824 bytes (1.1 GB) copied, 24.7744 seconds, 43.3 MB/s
1073741824 bytes (1.1 GB) copied, 15.883 seconds, 67.6 MB/s
1073741824 bytes (1.1 GB) copied, 3.32253 seconds, 323 MB/s # partial cache?
1073741824 bytes (1.1 GB) copied, 1.86324 seconds, 576 MB/s # partial cache?

# Read (cached)
1073741824 bytes (1.1 GB) copied, 0.364405 seconds, 2.9 GB/s
1073741824 bytes (1.1 GB) copied, 0.35307 seconds, 3.0 GB/s
1073741824 bytes (1.1 GB) copied, 0.34498 seconds, 3.1 GB/s
</pre>

## Conclusions

&#8211; My local computer is fast, but my Linode is faster (IO wise)
  
&#8211; Writes are 2x faster on BuyVM than Scaleway, but IO is close
  
&#8211; Because Scaleway has more RAM, cache hits for disk IO are more likely.
  
&#8211; SD Card IO is heavily bound on devices. ~20 MB read, ~15 MB write, despite specs.
  
&#8211; I don&#8217;t have a device that properly supports UHS-1. Sounds like ODroid would, but ODroid can also do eMMC.
  
&#8211; The key is USB 3.0 support. That seems to be the minimum, though my laptop got shafted.