---
id: 7834
title: Microserver Pros/Cons
date: 2015-11-21T17:20:21+00:00
author: Mike K
layout: post
guid: /?p=7834
permalink: /2015/11/21/microserver-proscons/
categories:
  - Uncategorized
---
<!--more-->

I&#8217;m looking for an ideal microserver to run locally. 

**Needs:**

  * Fast Storage (anything faster than an SD Card)
  * Lots of RAM (1 GB minimum, 2 GB ideally)
  * Multiple Cores (2 minimum, 4 ideally)
  * Low cost (Under $100, under $50 ideally)
  * Software Support (Ubuntu 15.10, Debian Jessie)

The last is probably the most important point, as I want this server to mirror what we&#8217;re running on the Live website. That means MIPS and ARMv8 are out.

## BeagleBone Black

$45 from SEEED, or $39 for the BeagleBone Green from SEEED

**Pros:**

  * **Debian Mainline** Support
  * Ubuntu Core Support
  * Single Core **ARMv7**
  * 512 MB of RAM
  * 4 GB of **Flash** storage

**Cons:**

  * 100 Mb Ethernet
  * Normal speed MicroSD storage
  * USB 2.0

## Raspberry Pi B+

$40 from SEEED, ~$30 from AliExpress

**Pros:**

  * **Debian Mainline** Support
  * Raspbian (Debian Jessie)
  * 512 MB of RAM

**Cons:**

  * Single Core ARMv6
  * 100 Mb Ethernet
  * Normal speed MicroSD storage
  * USB 2.0

## Parallella

$99 from Amazon (headless), $149 from Amazon (HDMI)

**Pros:**

  * First party Ubuntu 14.04
  * Dual Core **ARMv7**
  * 1 GB of RAM
  * **Gigabit** Ethernet

**Cons:**

  * Normal speed MicroSD storage
  * USB 2.0

## Raspberry Pi 2

$40 from Amazon?

**Pros:**

  * **Debian Mainline** Support
  * Pseudo Ubuntu Mainline Support
  * Raspbian (Debian Jessie)
  * **Quad** Core **ARMv7**
  * 1 GB of RAM

**Cons:**

  * 100 Mb Ethernet
  * Normal speed MicroSD storage
  * USB 2.0

## Banana PI M1

$30 from AliExpress

**Pros:**

  * 3rd party Debian (Jessie) and Ubuntu
  * Dual Core **ARMv7**
  * 1 GB of RAM
  * **Gigabit** Ethernet
  * **SATA** storage

**Cons:**

  * Normal speed MicroSD storage
  * USB 2.0

Likely candidate.

## Banana PI M3

$78 from AliExpress

**Pros:**

  * **Octo** Core **ARMv7**
  * **2 GB** of RAM
  * **Gigabit** Ethernet
  * WiFi b/g/n
  * **SATA** storage

**Cons:**

  * Brand new, so OS Support Unknown
  * Normal speed MicroSD storage??
  * USB 2.0

Potential candidate.

## Creator Ci20

$65 from Imagination Technologies

**Pros:**

  * First Party Debian (Jessie)
  * 1 GB of RAM
  * **8 GB** of **Flash** storage
  * **Gigabit** Ethernet

**Cons:**

  * Dual Core **MIPS** (a con because software support)
  * Normal speed MicroSD storage
  * USB 2.0

## ODROID C1+

$37 from HardKernel

**Pros:**

  * OS??
  * **Quad** Core **ARMv7**
  * 1 GB of RAM
  * **Gigabit** Ethernet
  * Optional fast **eMMC** storage

**Cons:**

  * Normal speed MicroSD storage??
  * USB 2.0

## ODROID XU4

$74 from HardKernel

**Pros:**

  * OS??
  * **2 GHz Octo** Core **ARMv7**
  * **2 GB** of RAM
  * **Gigabit** Ethernet
  * Optional fast **eMMC** storage
  * **USB 3.0**

**Cons:**

  * Normal speed MicroSD storage??

## Jetson TK1

$192 from NVidia

**Pros:**

  * First Party Ubuntu (?)
  * **4+1** Core **ARMv7**
  * **2 GB** of RAM
  * **16 GB** of **eMMC** storage
  * **Gigabit** Ethernet
  * **USB 3.0**
  * **SATA** storage
  * **Desktop Class** GPU

**Cons:**

  * Normal speed MicroSD storage??
  * Price

## Jetson TX1

$599 from NVidia

**Pros:**

  * First Party Ubuntu (?)
  * **4 GB** of RAM
  * **16 GB** of **eMMC** storage
  * **Gigabit** Ethernet
  * **USB 3.0**
  * **SATA** storage
  * **Desktop Class** GPU

**Cons:**

  * **Quad** Core **64bit ARMv8** (A con because of software support)
  * Normal speed MicroSD storage??
  * **Price** (OMFG)