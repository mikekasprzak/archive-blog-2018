---
title: 'Notes: i3 Window Manager'
layout: post
date: '2018-03-07 01:24:06'
---

I'm toying with a new Window Manager named **i3**. It's unusual, and only runs on X11.

NOTE: There is a Wayland version of i3 named **Sway**.

# Setup
```bash
sudo apt install i3
```

Now logout and select `i3` as the Window Manager.
# Hotkeys
The `MOD` key is a key you configure after initial setup. Typically this is either the **WINDOWS** key or the **ALT** key.

* `MOD+Enter`: Open Terminal
* `MOD+D`: Open DMenu, i.e. the application launcher
* `MOD+1` to `MOD+0`: Switch Workspace
* `MOD+Shift+r`: Reload i3 configuration
* `MOD+F`: Fullscreen the active window 
* `MOD+Shift+Space`: Float the active window

# Configuring
The configuration file is here `~/.config/i3/config`.

To list the available `MOD` keys, use `xmodmap`.

To lookup an application's class, use `xprop` and click on the application.

# Adding ALT+F4, ALT+Tab
```bash
# Alt+F4
bindsym Mod1+F4 kill

# Alt+Tab and Alt+Shift+Tab
bindsym Mod1+Tab focus right
bindsym Mod1+Shift+Tab focus left
```

# Adding Screenshot keys
```bash
# NOTE: Alt+Print is actually Mod1+Sys_Req

# gnome-screenshot
bindsym Print exec gnome-screenshot
bindsym --release Shift+Print exec gnome-screenshot -a
bindsym Mod1+Sys_Req exec gnome-screenshot -w

# xfce4-screenshooter
bindsym Print exec xfce4-screenshooter -f
bindsym --release Shift+Print exec xfce4-screenshooter -r
bindsym Mod1+Sys_Req exec xfce4-screenshooter -w
```

One might want to use `xfce4-screenshooter` as `gnome-screenshot` may lose the _save-as_ dialog (I did in Ubuntu 17.10). Hopefully it returns in 18.04.

# Adding Icons (via fonts)
```bash
sudo apt install fonts-font-awesome
```

See the [Cheat Sheet](https://fontawesome.com/cheatsheet) for unicode values.

# Disable Edge Borders
Edge Borders are a line along the left or bottom edge of a window that show which way new creates will go. It's helpful, but it wastes pixels.

```bash
hide_edge_borders both
```

# Customizing the Bar with i3Blocks
```bash
sudo apt install i3blocks

# copy sample configuration
cp /etc/i3blocks.conf ~/.config/i3/
```

Change `~/.config/i3/config`'s bar section from `i3status` to `i3blocks`.

```bash
bar {
        status_command i3blocks -c ~/.config/i3/i3blocks.conf
}
```

Now you can edit `~/.config/i3/i3blocks.conf` to change what's shown.

## Audio Volume
To install:
```bash
cd ~/.config/i3/plugins/

curl https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/volume-pulseaudio/volume-pulseaudio >volume-pulseaudio
chmod +x volume-pulseaudio
```

Edit `i3blocks.conf`:
```bash
[volume]
signal=1
interval=once
command=~/.config/i3/plugins/volume-pulseaudio -F 3
```

Edit `conf`:
```bash
# change volume or toggle mute
bindsym XF86AudioRaiseVolume exec amixer -q -D pulse sset Master 5%+ && pkill -RTMIN+1 i3blocks 
bindsym XF86AudioLowerVolume exec amixer -q -D pulse sset Master 5%- && pkill -RTMIN+1 i3blocks
bindsym XF86AudioMute exec amixer -q -D pulse sset Master toggle && pkill -RTMIN+1 i3blocks
```

When i3blocks gets a `Signal 1` (`-RTMIN+1`), it triggers a refresh of i3blocks.

## WiFi Status
Edit `i3blocks.conf`:
```bash
[wifi]
label=
markup=pango
interval=2
```

`pango` stops the unicode symbol from inserting garbage after it.

## CPU Usage
Edit `i3blocks.conf`:
```bash
[cpu_usage]
label=CPU
interval=2
#min_width=CPU:·100.00%
#separator=false
```

I don't like excess space, so I've disabled `min_width`. Also I don't like how much gaps separators add, but included above for reference.

## CPU Temperature
To Install:
```bash
cd ~/.config/i3/plugins/

curl https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/temperature/temperature >temperature
chmod +x temperature
```

Edit `i3blocks.conf`:
```bash
[cpu_temp]
interval=5
command=~/.config/i3/plugins/temperature
```

## System Load
Edit `i3blocks.conf`:
```bash
[load_average]
label=
markup=pango
interval=3
```

## Battery Meter
To Install:
```bash
cd ~/.config/i3/plugins/

curl https://raw.githubusercontent.com/vivien/i3blocks-contrib/master/battery2/battery2 >battery2
chmod +x battery2
```

Edit `i3blocks.conf`:
```bash
[battery]
markup=pango
interval=3
command=~/.config/i3/plugins/battery2
```

## Date+Time
Edit `i3blocks.conf`:
```bash
[time]
interval=1
command=date·'+%A·%b·%d,·%r'
```
# Hardware
* `/sys/class/power_supply/`: AC Power (`AC`) and Batteries (`BAT0`, ...)

# References
* [https://www.youtube.com/watch?v=j1I63wGcvU4](https://www.youtube.com/watch?v=j1I63wGcvU4)
* [https://wiki.archlinux.org/index.php/I3#Configuration](https://wiki.archlinux.org/index.php/I3#Configuration)