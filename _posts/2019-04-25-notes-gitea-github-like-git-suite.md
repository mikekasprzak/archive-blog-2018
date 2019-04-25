---
title: 'Notes: Gitea (Github-like GIT suite)'
layout: post
date: '2019-04-25 16:45:08'
---

Generally speaking I followed this guide:

[https://www.vultr.com/docs/how-to-install-gitea-on-ubuntu-18-04](https://www.vultr.com/docs/how-to-install-gitea-on-ubuntu-18-04)

My earlier attempt at installing Gitea didn't quite work right, but this went off without a hitch.

Notable changes:

* I installed Gitea on an LXD container (so this works totally-fine)
* I installed the latest stable version of MariaDB ([https://downloads.mariadb.org/mariadb/repositories/](https://downloads.mariadb.org/mariadb/repositories/))
* I installed the latest version of Gitea, which at the time of this writing is `1.8.0`. I would recommend checking the releases here: [https://dl.gitea.io/gitea/](https://dl.gitea.io/gitea/)
* I set up a hosts-file entry on my router to allow me to use an internal domian for the git server

Once installed, it required a bunch of config changes to `/etc/gitea/app.ini`. Notably the Gitea Base URL (I was able to use my internal domain, and omit the port due to the NGINX steps), and the SSH Server Domain so it could give you proper URLs to `git clone`.

I'm extremely pleased with the software. It might not have 1:1 parity to GitHub, but it's awfully close (way closer than GitLab).