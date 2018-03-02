---
id: 8275
title: Using LetsEncrypt with OpenLiteSpeed on Ubuntu
date: 2016-03-09T18:11:32+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=8275
permalink: /2016/03/09/using-letsencrypt-with-openlitespeed-on-ubuntu/
categories:
  - Linux
  - Technobabble
---
These notes are [based on this](https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04).

Install GIT and BC.

<pre class="lang:default decode:true " >sudo apt-get install git bc</pre>

Get the latest version of LetsEncrypt using GIT, placing it in /opt/.

<pre class="lang:default decode:true " >sudo git clone https://github.com/letsencrypt/letsencrypt /opt/letsencrypt</pre>

For the next step, we&#8217;re going to need access to Port 80, so temporarily shut down your webserver.

<pre class="lang:default decode:true " >service lsws stop</pre>

Run LetsEncrypt.

<pre class="lang:default decode:true " >cd /opt/letsencrypt
./letsencrypt-auto certonly --standalone -d example.com

# You can include multiple "-d blah.com" strings to certify multiple domains</pre>

The first time this runs, it&#8217;s going to ask for an e-mail address.

If everything worked correctly, you&#8217;ll find your certificate files here:

<pre class="lang:default decode:true " >/etc/letsencrypt/live/example.com/</pre>

Where `example.com` is your domain name.

Next, inside your OpenLiteSpeed configuration, go in to your **Listener->SSL** settings. Add or modify them as follows:

> **Private Key:** `/etc/letsencrypt/live/example.com/privkey.pem`
  
> **Certificate File:** `/etc/letsencrypt/live/example.com/fullchain.pem`
  
> **Chained Certificate:** Yes 

The rest of the fields should be blank. 

That&#8217;s it. Start the server.

<pre class="lang:default decode:true " >service lsws start</pre>

## Updating your certificates

Your certificate is good for 90 days, but it&#8217;s recommended you update it every 60.

Updating is exactly the same as requesting, and **requires you free up Port 80!**

<pre class="lang:default decode:true " >cd /opt/letsencrypt
./letsencrypt-auto certonly --standalone -d example.com</pre>

That will overwrite the certificate. The new certificate will be good for another 90 days.

I haven&#8217;t automated this myself yet, but there are suggestions how to do this in the article linked at the top.