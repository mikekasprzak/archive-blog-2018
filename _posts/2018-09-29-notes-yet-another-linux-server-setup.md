---
title: 'Notes: Yet another Linux Server Setup'
layout: post
---

Here we go again! 

Linux like OpenGL is old, and though finding information how to use it isn't hard, finding the _right_ information can be. Things have changed and evolved over time, and a "best practice" from years ago might not be best anymore (i.e. every article that still uses `apt-get`). 

Sooo, like every other time I do one of these note-posts, I'm trying to make sure I'm doing each step the most current/ideal/recommended way. Here we go!

# Create Server
Create your VPS server.

## Linode
1. Pick the type (1 GB), then the data center in the drop down.
2. Click the Linode, then click the settings tab.
3. Change "Linode Label" and "Display Group" and click Save.
4. If you want a **private** IP address (i.e. LAN), click Remote Access tab and find the private IP section.
5. Click the Rebuild tab.
6. Either:
	* Select Ubuntu 18.04 and set a root password
	* Click the tiny "Deploy using Stackscripts" and choose the appropriate setup script
7. Click the Dashboard tab.
8. If you want to add an external volume, you can do so here.
9. Click **BOOT*.

# Connect and setup the server
Under Linode you can use Lish to connect directly to the machine without a need for SSH. Either way, see your hosts SSH instructions.

## Set the Hostname
```bash
hostnamectl set-hostname MyComputerName
```

(was formerly edit the `/etc/hostname` file)

Reference: [https://www.linode.com/docs/getting-started/](https://www.linode.com/docs/getting-started/)

## Update the Hosts file
Edit `/etc/hosts`:

```bash
127.0.0.1       localhost

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```

Above is what the stock Ubuntu 18.04 on Linode hosts file looks like. This is actually totally fine, but you might want to make some tweaks.

For example, the first line could be adjusted like so:

```bash
127.0.0.1       MyComputerName localhost
```

This will let you resolve `MyComputerName` as the loopback address, same as you typically do with `localhost`.

You could also include your public IP with domain name, and save yourself a DNS lookup.

```bash
127.0.0.1       MyComputerName localhost
44.55.21.11    mydomain.com
```

Reference: [https://www.linode.com/docs/getting-started/](https://www.linode.com/docs/getting-started/)

## Add a user
It's safer to do administrative work with a user other than root (because it requires confirmation before you do something).

```bash
adduser myuser
adduser myuser sudo
```

The 2nd line is a simpler way of adding a user to the group. In the above case, to the sudo'ers group.

```bash
# check information about the current user
id
# uid=1000(myuser) gid=1000(myuser) groups=1000(myuser),27(sudo)

# check what groups I'm in
groups
# myuser sudo
```

Reference: [https://www.linode.com/docs/security/securing-your-server/](https://www.linode.com/docs/security/securing-your-server/)

### Adding a service user

To add a service user (i.e. one that doesn't need a home folder), add them like so:

```bash
adduser --system --no-create-home --group serviceuser
```

* `--system` - Creates a system user (i.e. no `/etc/shadow`, system user UID range, no home folder)
* `--no-create-home` - Doesn't create a home folder (might not be necessary)
* `--group` - By default users get put in `nogroup`. Using this with `--system` creates a group of the same name as the user.

Reference: [https://askubuntu.com/a/567852](https://askubuntu.com/a/567852), [http://manpages.ubuntu.com/manpages/bionic/man8/adduser.8.html](http://manpages.ubuntu.com/manpages/bionic/man8/adduser.8.html)

Curious reference that contradicts: [https://linux.die.net/man/8/adduser](https://linux.die.net/man/8/adduser)

## SSH
### Uninstall SSH (Linode only)
```bash
sudo apt remove openssh-server --purge
```
All server maintenence must now be done via Lish.

### Secure SSH
If you're not on Linode, you're going to need SSH to maintain the server.

TODO this

Reference: [https://www.linode.com/docs/security/securing-your-server/](https://www.linode.com/docs/security/securing-your-server/)