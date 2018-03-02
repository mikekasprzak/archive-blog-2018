---
id: 7494
title: Afternet.org via SSL on Ubuntu with X-Chat
date: 2015-08-18T13:50:21+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=7494
permalink: /2015/08/18/afternet-org-via-ssl-on-ubuntu-with-x-chat/
categories:
  - Ludumdare
  - Technobabble
---
Reference (but it&#8217;s vague): <http://www.afternet.org/help/connecting/ssl>

**NOTE:** AfterNET is adding a wildcard SSL certificate. This may obsolete these instructions.

**1.** Download the [certificate](https://www.afternet.org/downloads/afternetca.cer).

**2.** Create a folder `afternet.org` under `/usr/local/share/ca-certificates/`

**3.** Copy `afternet.cer` to `/usr/local/share/ca-certificates/afternet.org/`

**4.** Symlink it as `90511bdb.0`

<pre class="lang:default decode:true " >ln -s afternet.cer 90511bdb.0</pre>

**5.** run `update-ca-certificates` to update the certificates list.

<pre class="lang:default decode:true " >sudo update-ca-certificates</pre>

**6.** Open x-chat.

**7.** Edit your AfterNET entry.

**8.** Remove all the old servers and instead add.

<pre class="lang:default decode:true " >ssl.afternet.org/6697
ssl.afternet.org/9998</pre>

**9.** Check both **Use SSL for all Servers on this Network** and **Accept invalid SSL certificate**.

Done.