---
title: 'Notes: Easy OpenVPN'
layout: post
---

The recommended way of running OpenVPN is incredibly verbose. See here:

[https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04)

That's a lot of work, with a lot of places to make mistakes. That said, this is still the correct way to run OpenVPN.

An easier way is to do it via the `easy-openvpn` snap.

# 1. Setting up Easy OpenVPN
Installing `easy-openvpn` is ... well, easy. The thing to understand though is Installing openvpn is only half the battle. Your machine still needs to be configured properly to forward packets.

Reference: [https://docs.ubuntu.com/core/en/stacks/network/easy-openvpn/docs/](https://docs.ubuntu.com/core/en/stacks/network/easy-openvpn/docs/)

## Installing
Very easy.

```bash
snap install easy-openvpn
```

We'll have more configurations to do later.

# 2. IP forwarding
IP forwarding is typically disabled by default. You can check if its enabled a few ways:

```bash
# The sysctl way (0 = disabled, 1 = enabled)
sysctl net.ipv4.ip_forward

# The proc way (0 = disabled, 1 = enabled)
cat /proc/sys/net/ipv4/ip_forward
```

Whether you use a firewall or not will dictate how you do this next step. Below you can find instructions for no firewall (manual iptables), and for UFW.

### Enable forwarding with no firewall (iptables)
Edit `/etc/sysctl.conf`, and change/uncomment this line:

```bash
net.ipv4.ip_forward=1
```

You can can force the system to reload the config file like so:

```bash
sudo sysctl -p
```

Now when you check the forwarding state (see above) it should be enabled (i.e. 1).

You probably don't want this, but if you want to temporarily enable IP forwarding (until next reboot or firewall change), you could do the following:

```bash
sudo sysctl -w net.ipv4.ip_forward=1
```

This is what the easy-openvpn docs suggest, but again, this is temporary. You're going to want a permanent change.

### Enable forward with the UFW firewall
UFW uses its own config files under the `/etc/ufw/` folder.

Edit `/etc/ufw/sysctl.conf`, and change/uncomment this line:

```bash
net/ipv4/ip_forward=1
```

If you restart the firewall, forwarding will now be enabled;

```bash
sudo ufw disable
sudo ufw enable
```

## 3. Configuring the Easy OpenVPN NAT device
Before Easy OpenVPN can do anything for us, we need to know what network interface we're going to bind to it. Do the following:

```bash
ip addr
```

This will give you a list of network interfaces. Historically your network card would be named `eth0` or `wlan0`, but at some point network interfaces started getting wilder names like `ens3`, `enp0s25`, or `wlp3s0` to name a few (the VPN itself will be named something like `tun0`).  Figure out which network interface you want to use from the output of `ip addr`.

Once you know what you want, you can configure the snap variables. Set the interface like so:

```bash
sudo snap set easy-openvpn natdevice=eth0
```

Where `eth0` is whatever your network interface is called.

You can confirm it's set like so:

```bash
sudo snap get easy-openvpn
```

There's also a file `/var/snap/easy-openvpn/current/easy-openvpn.profile` that you can set nat device on. I don't believe you need to set it here, but just in case I forget this is something else I've set.

## 4. Configuring the NAT masquerade
Now here is where the Easy OpenVPN docs fail: they neglect to mention you actually need to set up the NAT to masquerade the client IPs through it. Like before, the process of doing this is different depending on whether you use a firewall or not.

### Configuring NAT masquerade with no filewall (iptables)
On Ubuntu by default a shell script `/etc/rc.local` doesn't exist. If it ever does, this script will be run on system startup. This is the typical place to put your iptables configuration.

```bash
#!/bin/bash

iptables -t nat -A POSTROUTING -s 192.168.255.0/24 -o eth0 -j MASQUERADE
```

Where `eth0` is the network interface we want to route traffic through, and `192.168.255.0/24` is the IP block and subnet that VPN addresses will be pulled from.

Make the script executable (`chmod +x /etc/rc.local`) and you can run it to get the effect right away.

### Configuring NAT masquerade with UFW
This is a bit more involved (Reference: [https://gist.github.com/kimus/9315140](https://gist.github.com/kimus/9315140)).

Edit `/etc/default/ufw` and change the DEFAULT_FORWARD_POLICY.

```bash
DEFAULT_FORWARD_POLICY="ACCEPT"
```

Edit `/etc/ufw/before.rules`, and **before** the filter rules, add this:

```bash
# OpenVPN NAT rules
*nat
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 192.168.255.0/24 -o eth0 -j MASQUERADE

COMMIT
```

Where `eth0` is the network interface we want to route traffic through, and `192.168.255.0/24` is the IP block and subnet that VPN addresses will be pulled from.

So yes, there will be two `COMMIT`'s in the file. You'll also notice this looks alot like the iptables configuration above.

Restart the firewall.

```bash
sudo ufw disable
sudo ufw enable
```

## 5. Final setup of Easy OpenVPN
Phew! We're almost done!

### Determine your public address (IP or domain)

The last thing we need is to know either our public facing IP address, or some domain that will correctly resolve to the IP of the VPN server. If you don't have a domain, you can use a dynamic DNS service. If you have a static IP or just want to test things out, you can use any online IP checker, such as this:

[https://www.ipchicken.com/](https://www.ipchicken.com/)

A better option is to [use a DNS resolver](https://unix.stackexchange.com/a/81699), but that's a bit more complicated (may also return an ipv6, which we don't necessarly want).

### Run the EasyVPN setup script
Once you've decided, the final setup step is this:

```bash
sudo easy-openvpn.setup -u udp://12.45.56.78 -N -C AES-256-CBC
```

Where `12.34.56.78` is our public facing IP address, or a domain.

The reason you probably want a domain here, especially if you have a dynamic DNS, is because later one when we start generating keys for our users, the keys will make reference to this address. If the address in the configuration is always correct, then we don't need to worry about editing our VPN configuration every time it changes.

Notably the line above is a bit different from what's mentioned in the Easy OpenVPN docs. `AES-256-CBC` is just better than the default, and the keys generated with it will trigger less errors in the logs.

### Starting the service
Do this:

```bash
sudo service snap.easy-openvpn.easy-openvpn start
```

There might be a bettery way, but this at least correctly installs the systemctl service (TODO: see if you can just do `sudo systemctl enable snap.easy-openvpn.easy-openvpn`).

From here on the systemctl service/unit is available. It can be enabled/disabled as follows:

```bash
# Disable
systemctl disable snap.easy-openvpn.easy-openvpn.service

# Enable
systemctl enable snap.easy-openvpn.easy-openvpn.service
```

(TODO: I'm not 100% sure if the service start line above properly enabled the service. To be safe I've always been doing a disable then enable as shown above, and then the service was good)

Your OpenVPN server is now ready.

## 6. Adding Users
Easy OpenVPN has a suite of commands you can now use, but there's really one one we care about now that setup is finished.

```bash
sudo easy-openvpn.add-client myuser-device >myuser-device.ovpn
```

This will generate a key file for this specific user/device. `myuser-device` are names you pick.

**TIP**: Often the filename (`myuser-device.ovpn`) will be used by the OpenVPN client software as the name of the connection. It would be wise to include something in the name that identifies which VPN you are connecting to. Example: `myvpn-user-phone.ovpn`.

## 7. Installing .ovpn keys
This is pretty straightforward, so I'm not going to say much. Download the OpenVPN client for your platform, and import the `.ovpn` file. Done.

### Android
Copy the `.ovpn` file to the device somehow (USB cable works good). Browse to it in the openvpn app, select it, and install it. Easy.

### Ubuntu 18.04
For me at least, Ubuntu 18.04 doesn't want to import the key in the GUI. Fortunately this can be done easily from a terminal:

```bash
sudo nmcli connection import type openvpn file mykey.ovpn
```

Where `mykey.ovpn` is the `.ovpn` file.

Reference: [https://www.cyberciti.biz/faq/linux-import-openvpn-ovpn-file-with-networkmanager-commandline/](https://www.cyberciti.biz/faq/linux-import-openvpn-ovpn-file-with-networkmanager-commandline/)

## Done
Yep, that's it.

You can make a more advanced configuration by changing settings in these files:

* `/var/snap/easy-openvpn/current/openvpn/openvpn.conf` 
* `/var/snap/easy-openvpn/current/openvpn/ovpn_env.sh`

End.