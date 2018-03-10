---
title: 'Design: WiFi widget requirements'
layout: post
date: '2018-03-10 00:42:08'
---

<img style="float: right;" width="200" src="/assets/wifi.svg">
The WiFi status widget is one of the most important pieces of iconography in a portable UX. As a laptop or mobile user, you _need_ to know that you have network access. With ethernet, it's not so important that you have network access, but if you _don't_ have it, that's a problem and the user should be notified.

This is my criticism of Budgie (from Ubuntu Budgie Remix). Out-of-the-box, there's no WiFi status widget. There's a Bluetooth widget, but there's no obvious way to check WiFi. Just a popup once a connection is established.

## Things a WiFi widget must do

* Show disconnected (possibly in an extra negative way to catch the users attention)
* Show connected (this can be neutral, but you should always be aware of a connection for activity or privacy reasons)
* Show connecting

If an attempt to make a connection is happening, this _needs_ to mentioned. This is my criticism of the WiFi widget in i3ws. I've run in to this because there appears to be an ocassional bug on my laptop. My WiFi network doesn't broadcast the SSID, and waking my PC up from sleep mode probably attempts to re-open the connection too soon and gives up. On Gnome proper you get a `...` in the place of the WiFi icon as an attempt is made. If you see this, you know you don't need to _kick_ the WiFi to wake it up.

```bash
#!/bin/sh

# $1: Wifi SSID to connect to
nmcli c up id $1
```

You can almost never provide too much information when it comes to a wireless connection. Say if a password is required, you have network but no internet, or that you connection is over a VPN tunnel or socket. Other details such as the network name would be too verbose to mention in an icon, but forgettable popup on new connection to know what network was connected to doesn't hurt.