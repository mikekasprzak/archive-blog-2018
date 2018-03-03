---
id: 7531
title: VPS Host Notes
date: 2015-09-29T01:56:51+00:00
author: Mike K
layout: post
guid: /?p=7531
permalink: /2015/09/29/vps-host-notes/
categories:
  - Uncategorized
---
As of September 29th 2015, a bunch of notes on the specific bargain VPS hosts. This is mainly a feature-set comparison, but also includes some interoperability notes. 

<!--more-->

## Linode

Recommended by people I know. Bandwidth pooling is a nice feature. Can add 2 TB of bandwidth with an extra $10 plan.

**Pros:**

  * KVM Hosting (default is XEN)
  * IPv6
  * Pooled Bandwidth (Total Bandwidth is sum of all servers)
  * Indirect SSH Access
  * **$10.00/mo**: 1 GB RAM, 1 core, 24 GB SSD, 2 TB ($2.50 Backups)
  * **$20.00/mo**: 2 GB RAM, **2 core**, **48 GB SSD**, 3 TB ($5.00 Backups)
  * **$40.00/mo**: 4 GB RAM, **4 core**, **96 GB SSD**, 4 TB ($10.00 Backups)
  * **$80.00/mo**: 8 GB RAM, **6 core**, **192 GB SSD**, **8 TB** ($20.00 Backups)

**Cons:**

  * May not be the fastest hardware

## Digital Ocean

Also recommended. Has a very active/high quality community of people writing howto guides.

**Pros:**

  * KVM Hosting
  * IPv6
  * **Toronto** Datacenter
  * Can **&#8220;Bump RAM+CPU Only&#8221;**, meaning you can return to lower tiers (Flexible)
  * Fantastic Documentation/Howto Community
  * **$5.00/mo**: 512 MB RAM, 1 core, **20 GB SSD**, 1 TB ($1 Backups)
  * **$10.00/mo**: 1 GB RAM, 1 core, **30 GB SSD**, 2 TB ($2 Backups)
  * **$20.00/mo**: 2 GB RAM, **2 core**, 40 GB SSD, 3 TB ($4 Backups)
  * **$40.00/mo**: 4 GB RAM, 2 core, 60 GB SSD, 4 TB ($8 Backups)
  * **$80.00/mo**: 8 GB RAM, 4 core, 80 GB SSD, 5 TB ($16 Backups)

**Cons:**

  * No bandwidth pool
  * Must charge Tax in Canada
  * I found it unusual that my VMs were created without swap

## Vultr

Has the most RAM in a $5 plan, but less SSD and CPU cores at higher tiers.

**Pros:**

  * KVM Hosting
  * **Australia** Datacenter
  * **$5.00/mo**: **768 MB RAM**, 1 core, 15 GB SSD, 1 TB ($1 Backups)
  * **$10.00/mo**: 1 GB RAM, 1 core, 20 GB SSD, 2 TB ($2 Backups)
  * **$20.00/mo**: 2 GB RAM, **2 core**, 45 GB SSD, 3 TB ($4 Backups)
  * **$40.00/mo**: 4 GB RAM, 2 core, 90 GB SSD, 4 TB ($8 Backups)
  * **$80.00/mo**: 8 GB RAM, 4 core, 150 GB SSD, 5 TB ($16 Backups)

**Cons:**

  * No bandwidth pool

TODO: Do they have IPv6??

## BuyVM

A very good value, some features not available anywhere else. I&#8217;ve been using them since 2014 (?). Great for experiments, but I&#8217;m not sure they&#8217;re ideal for serious projects.

**Pros:**

  * OpenVZ Hosting (Burstable, better hardware usage)
  * Anycast and IP Fallback Support (3 hosts minimum)
  * Pooled Bandwidth (Total Bandwidth is sum of all servers)
  * **$1.25/mo x12**: 128 MB RAM, 1 core, 15 GB SATA, 0.5 TB
  * **~$3.00/mo x6**: 256 MB RAM, **2 core**, 30 GB SSD, 1 TB
  * **~$5.00/mo x6**: 512 MB RAM, **2 core**, 50 GB SSD, 2 TB
  * **~$11.00/mo x6**: 1 GB RAM, **4 core**, 100 GB SSD, 5 TB
  * KVM Hosting Available, at higher rates ($2/$4/etc)

**Cons:**

  * OpenVZ Hosting (worse compatibility than KVM)
  * Slow activation (hours, not minutes)
  * Only 3 data-centers (US x2, EU x1)
  * Aware of outages (only because I follow them)
  * No backups (they had them for **FREE**, but currently unavailable)
  * LAN IPv6, no Internet IPv6

## MNX.IO (NEW)

Good value. Has a $60 plan (most don&#8217;t).

**Pros:**

  * KVM Hosting
  * SSL
  * **$5.00/mo**: **768 MB RAM**, 1 core, **25 GB SSD**, 1 TB (?? Backups)
  * **$10.00/mo**: 1 GB RAM, 1 core, **40 GB SSD**, 1 TB (?? Backups)
  * **$20.00/mo**: 2 GB RAM, **2 core**, 50 GB SSD, 2 TB (?? Backups)
  * **$40.00/mo**: 4 GB RAM, 2 core, 100 GB SSD, 3 TB (?? Backups)
  * **$60.00/mo**: 6 GB RAM, 4 core, 120 GB SSD, 4 TB (?? Backups) **
  * **$80.00/mo**: 8 GB RAM, 4 core, 160 GB SSD, 5 TB (?? Backups)

**Cons:**

  * One Data Center near Chicago (Mount Prospect, Illinois)
  * No bandwidth pool
  * No IPv6 (AFAIK)
  * I haven&#8217;t tested them

## Scaleway (NEW)

Actual dedicated servers for cheap!? Custom ARM based servers with 4 cores, 2 GB of RAM, and 50 GB SSD. Wow!

**Pros:**

  * DEDICATED SERVER
  * **£3/mo** (<$5): **2 GB RAM**, **4 core**, **50 GB SSD**, 0.2 TB (?? Backups)

**Cons:**

  * Less/Expensive Bandwidth
  * ARM Software compatibility unknown
  * Single Data Center (Paris, France)
  * No IPv6
  * Untested

## Stats

**Interconnectivity of New York/New Jersey area hosts**

  * Digital Ocean NYC3 to Digital Ocean NYC3: **0.5 ms** ping
  * Digital Ocean NYC3 to Vultr New Jersey: **2.0 ms** ping
  * Digital Ocean NYC3 to Linode New Jersey: **2.2 ms** ping
  * Digital Ocean NYC3 to BuyVM New Jersey: 2.3 ms ping
  * Linode New Jersey to Linode New Jersey: **0.5 ms** ping
  * Linode New Jersey to Digital Ocean NYC: (1) 1.7 ms, (2) 1.6 ms, (3) 2.3 ms
  * Linode New Jersey to Vultr New Jersey: 2.5 ms ping
  * Linode New Jersey to BuyVM New Jersey: 2.8 ms ping
  * Vultr New Jersey to Vultr New Jersey: **0.55 ms** ping
  * Vultr New Jersey to Digital Ocean NYC: (1) 1.4 ms, (2), 1.2 ms, (3) 1.9 ms
  * Vultr New Jersey to Linode New Jersey: 2.5 ms ping
  * Vultr New Jersey to BuyVM New Jersey: **0.8 ms** ping

**Other**

  * Digital Ocean NYC3 to BuyVM Vegas: 80 ms ping
  * Vultr New Jersey to BuyVM Vegas: 72 ms ping
  * Linode New Jersey to BuyVM Vegas: 72 ms ping
  * Linode New Jersey to BuyVM Vegas: 74 ms ping
  * Vultr New Jersey to Digital Ocean Amsterdam: (1) **88 ms**, (2) 90 ms, (3) 96 ms
  * Linode New Jersey to Digital Ocean Amsterdam: (1) 101 ms, (2) **79.5 ms**, (3) 85.5 ms
  * Vultr New Jersey to Vultr Amsterdam: 98 ms
  * Linode New Jersey to Vultr Amsterdam: 85.5 ms

A **5 ms** difference between Digital Ocean&#8217;s fastest datacenter in Amsterdam (2) and Vultr&#8217;s.