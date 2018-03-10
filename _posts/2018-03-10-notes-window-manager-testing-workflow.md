---
title: 'Notes: Window manager testing workflow'
layout: post
date: '2018-03-10 01:35:26'
---

This seems to be surprisingly difficult information to find. Be warned, this post is scatterbrained.

Other than starting X:

```bash
# run X
startx
```

Then running them explicitly:
```bash
# run Gnome
gnome-session

# run Unity
unity

# run i3wm
i3
```

causing the session to change.

It turns out you can use the WM name as an argument to `startx`:

```bash
startx unity
```

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