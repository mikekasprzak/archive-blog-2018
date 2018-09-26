---
title: 'Notes: Systemd and systemctl'
layout: page
---

For clarity: there's lots of references online that say use "upstart" to manage auto-starting applications. Don't! Upstart was obsoleted, and as of Ubuntu 14.10 it's no longer available.

The ideal way to start applications is with **Systemd**.

## Status
To check the status of services, do the following:

```bash
systemctl status
```

This will give you a tree of all the started services.

If you see that your state is **degraded**, this means a service failed to start.

Do this to see the list of failed services.

```bash
systemctl --failed
```

## Adding a service
A service in systemd is called a **Unit**.

Create a `.service` file in `/etc/systemd/system/`, something like `unitycache.service`.

```bash
[Unit]
Description=Unity Cache
After=network.target

[Service]
Type=simple
User=unitycache
Group=unitycache
WorkingDirectory=/usr/lib/node_modules/unity-cache-server/
ExecStart=/usr/bin/unity-cache-server
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

Then start it.

```bash
sudo systmctl start unitycache.service
```

Reference: [https://wiki.archlinux.org/index.php/systemd](https://wiki.archlinux.org/index.php/systemd),  [https://www.devdungeon.com/content/creating-systemd-service-files](https://www.devdungeon.com/content/creating-systemd-service-files), [https://unix.stackexchange.com/questions/224992/where-do-i-put-my-systemd-unit-file](https://unix.stackexchange.com/questions/224992/where-do-i-put-my-systemd-unit-file)

## Viewing Logs
You use `journalctl` to check on the logs output by a Unit:

```bash
# To view the log
sudo journalctl -u unitycache

# To tail the log
sudo journalctl -f -u unitycache
```

Which says "show me the journal from the Unit named unitycache".