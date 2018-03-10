---
title: 'Notes: Window manager testing workflow'
layout: post
date: '2018-03-10 01:35:26'
---

This seems to be surprisingly difficult information to find. Be warned, this post is scatterbrained.

# startx
Until now, the only way I knew to start a window manager from scratch was to run `startx`:

```bash
# run X
startx
```

Then running the manager explicitly:
```bash
# run Gnome
gnome-session

# run Unity
unity

# run i3wm
i3
```

which caused the session to change. Historically you would run `gnome-session --replace` or `unity --replace` to actually replace the stock X session (or any other that was running), but this seems to be a thing of the past (Unity's mentions the `--replace` command is included for compatibility).

Well all along it turns out you colud have specified the window manager name as an argument to `startx`:

```bash
startx unity
```

Doh!

Reference: [https://unix.stackexchange.com/a/41095](https://unix.stackexchange.com/a/41095)

Edit: Digging a little deeper, it turns out `startx` is just a shell script wrapper around `xinit`. This is where `.xinitrc` seems to come in to play (`startx` checks for it).

Reference: [https://wiki.archlinux.org/index.php/Xinit](https://wiki.archlinux.org/index.php/Xinit)

### .xinitrc

There's a file `~/.xinitrc` that seems important. Out of the box this file doesn't exist, so it's unclear how Ubuntu is deciding what window manager to use on login. That said, there are details for customizing it here:

(https://wiki.ubuntu.com/CustomXSession](https://wiki.ubuntu.com/CustomXSession)

There seems to be a file `~/.dmrc` that says this:

```bash
[Desktop]
Session=i3
```

Maybe this is important?

### LightDM
LightDM the **Display Manager** appears to be the owner of this file.

> LightDM logs in using the session specified in the ~/.dmrc of the user getting logged in automatically.

Source: [https://wiki.archlinux.org/index.php/LightDM](https://wiki.archlinux.org/index.php/LightDM)

> LightDM is the display manager running in Ubuntu. It starts the X servers, user sessions and greeter (login screen). The default greeter in Ubuntu is Unity Greeter.

Source: [https://wiki.ubuntu.com/LightDM](https://wiki.ubuntu.com/LightDM)

This above page details some other information that seems relevant.

> ### Help, I can't see my Desktop! 
> * You can get to a text terminal using `alt-ctrl-F1`.

This seems to suggest a system is a setup something like:

* Kernel
* Display Manager (LightDM)
* Display Server (X11)
* Window Manager (whatever)

Suggesting the Display Manager is the fallback you rely on for getting a terminal even after everything is messed up (i.e. the `ALT+CTRL+Fx` feature, when things go bad).

### XDG_CURRENT_DESKTOP

`XDG_CURRENT_DESKTOP` and `GDMSESSION` can tell you what's currently running.

```bash
printf 'Desktop: %s\nSession: %s\n' "$XDG_CURRENT_DESKTOP" "$GDMSESSION"

# My i3wm session:
Desktop: i3
Session: i3
```

This is just informational though. Source: [https://askubuntu.com/a/227669](https://askubuntu.com/a/227669).

# Window managers in a container window? EDIT: Yes
I've seen Weston (the Wayland sample) running in a Window from another desktop. 

<iframe width="560" height="315" src="https://www.youtube.com/embed/Q0euI8FIXV0" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

In the above case they simply ran weston explicitly. Huh.

This seems a good way to develop.

[https://wayland.freedesktop.org/](https://wayland.freedesktop.org/)

EDIT: This seems to suggest the `weston` command runs Weston in an X window: [https://wiki.archlinux.org/index.php/wayland#Weston](https://wiki.archlinux.org/index.php/wayland#Weston). The actual window manager is `weston-launch`.

Quickly digging through the code, it looks like they actually implemented an x11 window by hand. No external tool required. Just x11.

# xnest and xserver-xephyr
It turns out these commands let you run X11 in a window, that you can then attach a window manager to.

```bash
# xephyr is probably already installed
sudo apt install xnest xserver-xephyr`
```

According to humans:

* `xnest` - it should allow OpenGL applications to work
* `xserver-xephyr` - better (?) support for x11 features, except OpenGL is a software renderer
	* supposedly you can use something called `virtualgl` to work around this, but there's no stock Ubuntu package (there is a PPA though)

Overwhelming Xephyr seems to be preferred, despite limitations.

Doing it seems to require a long command line and a config file.

* [https://ubuntuforums.org/showthread.php?t=620003](https://ubuntuforums.org/showthread.php?t=620003)
* [http://jeffskinnerbox.me/posts/2014/Apr/29/howto-using-xephyr-to-create-a-new-display-in-a-window/](http://jeffskinnerbox.me/posts/2014/Apr/29/howto-using-xephyr-to-create-a-new-display-in-a-window/)

I wouldn't be surprised if I'm just looking at the wrong references. I would prefer something more like `startx i3`. 
# Native x11 apps
I forgot that APIs like SDL, GTK+, and Qt are built on top of something. Here's some references for creating a barebones X11 window.

[https://rosettacode.org/wiki/Window_creation/X11](https://rosettacode.org/wiki/Window_creation/X11)

Using an API is preferred, since it means we can rely on standards for theming.

# startx/xinit breakdown
The `--` symbol in a `startx` or `xinit` invocation separates arguments about the client to be run from the arguments to the x server itself.

```bash
startx CLIENT_ARGS -- SERVER_ARGS
xinit CLIENT_ARGS -- SERVER_ARGS
```

* `startx` - simple frontend to `xinit` [https://www.x.org/archive/X11R6.7.0/doc/startx.1.html](https://www.x.org/archive/X11R6.7.0/doc/startx.1.html)
* `xinit` - x window system initializer [https://www.x.org/archive/X11R6.7.0/doc/xinit.1.html](https://www.x.org/archive/X11R6.7.0/doc/xinit.1.html)

So given this as reference:

```bash
sudo startx gnome-session -- :1 vt2
```

This starts a `gnome-session` client on display `:1` and TTY2 (i.e. `CTRL+ALT+F2`).

At least on my Ubuntu, the default display is `:0`, so it's important that you specify a different display for this.

Curiously it starts with an `xterm` window open, and when you close it, it closes.

Running `sudo startx unity -- :1 vt2` doesn't actually work. `gnome-session` sessions are stored here:

```bash
ll /usr/share/gnome-session/sessions/

-rw-r--r-- 1 root root  767 Oct  6 00:30 gnome-flashback-compiz.session
-rw-r--r-- 1 root root  771 Oct  6 00:30 gnome-flashback-metacity.session
-rw-r--r-- 1 root root  701 Oct 11 12:57 gnome-login.session
-rw-r--r-- 1 root root 2185 Oct 13 07:33 gnome.session
-rw-r--r-- 1 root root  692 Oct 13 07:33 ubuntu.session
-rw-r--r-- 1 root root  101 Oct 13 07:33 unity.session
```

Supposedly this works: `sudo startx gnome-session --session=ubuntu -- :1 vt2`

unity.session
```bash
[GNOME Session]
Name=Unity
RequiredComponents=unity-settings-daemon;
DesktopName=Unity:Unity7:ubuntu
```

gnome-login.session
```bash
[GNOME Session]
Name=Display Manager
RequiredComponents=org.gnome.Shell;org.gnome.SettingsDaemon.A11yKeyboard;org.gnome.SettingsDaemon.A11ySettings;org.gnome.SettingsDaemon.Clipboard;org.gnome.SettingsDaemon.Color;org.gnome.SettingsDaemon.Datetime;org.gnome.SettingsDaemon.Housekeeping;org.gnome.SettingsDaemon.Keyboard;org.gnome.SettingsDaemon.MediaKeys;org.gnome.SettingsDaemon.Mouse;org.gnome.SettingsDaemon.Power;org.gnome.SettingsDaemon.PrintNotifications;org.gnome.SettingsDaemon.Rfkill;org.gnome.SettingsDaemon.ScreensaverProxy;org.gnome.SettingsDaemon.Sharing;org.gnome.SettingsDaemon.Smartcard;org.gnome.SettingsDaemon.Sound;org.gnome.SettingsDaemon.Wacom;org.gnome.SettingsDaemon.XSettings;
```

gnome.session (basically the same)
```bash
[GNOME Session]
Name=Ubuntu
RequiredComponents=org.gnome.Shell;org.gnome.SettingsDaemon.A11yKeyboard;org.gnome.SettingsDaemon.A11ySettings;org.gnome.SettingsDaemon.Clipboard;org.gnome.SettingsDaemon.Color;org.gnome.SettingsDaemon.Datetime;org.gnome.SettingsDaemon.Housekeeping;org.gnome.SettingsDaemon.Keyboard;org.gnome.SettingsDaemon.MediaKeys;org.gnome.SettingsDaemon.Mouse;org.gnome.SettingsDaemon.Power;org.gnome.SettingsDaemon.PrintNotifications;org.gnome.SettingsDaemon.Rfkill;org.gnome.SettingsDaemon.ScreensaverProxy;org.gnome.SettingsDaemon.Sharing;org.gnome.SettingsDaemon.Smartcard;org.gnome.SettingsDaemon.Sound;org.gnome.SettingsDaemon.Wacom;org.gnome.SettingsDaemon.XSettings;
```

I don't know how this helps us yet, but meh.