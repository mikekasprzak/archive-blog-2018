---
title: 'Notes: Configuring Avahi (Zeroconf) Internal (.local) Domains'
layout: post
date: '2018-06-03 20:08:06'
---

To get a `.local` domain on your network, you need to install avahi.

```bash
sudo apt-install avahi-daemon
```

From herein, `hostname.local` will work for accessing that machine (where `hostname` is the value of `/etc/hostname`).

If you want to change the name or extension, you can edit `/etc/avahi/avahi-daemon.conf`.