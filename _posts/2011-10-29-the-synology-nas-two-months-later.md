---
id: 4579
title: The Synology NAS, two months later
date: 2011-10-29T20:36:32+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4579
permalink: /2011/10/29/the-synology-nas-two-months-later/
categories:
  - Technobabble
  - The Business of Things
---
NAS time, again! [Like](/2011/08/23/i-am-running-a-synology-nas-now/) [before](/2011/08/23/appdailysales-and-running-on-synology-nas-devices/), I&#8217;m collecting my notes and thoughts all in one place.

## Two months later

<div id="attachment_4592" style="max-width: 160px" class="wp-caption alignright">
  <a href="/wp-content/uploads/2011/10/IMG_20111029_195344.jpg"><img src="/wp-content/uploads/2011/10/IMG_20111029_195344-150x150.jpg" alt="" title="IMG_20111029_195344" width="150" height="150" class="size-thumbnail wp-image-4592" /></a>
  
  <p class="wp-caption-text">
    Why have 1 when you can have 2? After winning the GameTree prize, I decided I should have 2
  </p>
</div>So according to my blog here, I&#8217;ve been running the Synology NAS for just over 2 months now, and I still love it. Heck, I bought a 2nd one! The NAS has become a permanent part of my development setup, and even my development workflow. It sits in the corner and just works; What more do you want?

As mentioned in my earlier posts, I&#8217;m running both SVN and AppDailySales on it (iTunes Connect Sales Stat grabber). In addition, I&#8217;ve been running an internal wiki on it. I used to host 2 different external wikis, but both have been imported and archived locally. 

I chose DokuWiki for my internal wiki because it uses flat files, meaning I don&#8217;t have to run SQL (though it is just a button to enable MySQL on the Synology). This has the added bonus that I can regularly commit the data to my SVN repository for extra redundancy (the Data and Media folders). On my TODO list is to add an automated task that commits wiki changes every morning, but hey, I decided to write this post instead. 😉

Here are are some of the more recent developments.

## Moving Hiccups

Since I moved in to my new apartment, I&#8217;ve actually been having an issue with my NAS. AppDailySales, the python script I use to get my latest sales data, it wasn&#8217;t working. This required me to manually run my script to get sales data, but unfortunately, I&#8217;ve lost just shy of 3 weeks of sales data. Seeing how Smiles is a good 3 years old now, I&#8217;m not too bothered by the loss of daily data (weekly is still available), but it&#8217;s still a bit of a disappointment.

I&#8217;m not sure what compelled me, but I decided to investigate the connection problem today. Long story short, my DNS and Gateway settings were set wrong. Looking back, getting my network setup correctly was a real pain, so this doesn&#8217;t surprise me. My DSL modem apparently also acts like a router, so to get the two to play together nicely, I set my real router use a different IP (192.168.1.2 instead of 192.168.1.1). Silly NAS was set to &#8220;.1&#8221; instead of &#8220;.2&#8221;.

Part of that network config, I changed IP blocks from 192.168.0.x to 192.168.1.x, since that&#8217;s what my new router used. I had previously set static IP addresses for the NAS (.110), so I had to re-run the windows DSAssistant tool to change the IP block (an IP in 192.168.0.x cannot see an IP in 192.168.1.x, at least not with a subnet of 255.255.255.0).

Those were the only 2 issues introduced during my move. That&#8217;s not to say I didn&#8217;t find more ways to mess things up. 😀

## Upgrading from DSM 3.1 to 3.2

About a month ago, Synology finally released the latest version of the OS for their devices. And not even a week ago, they released a bugfix for that. The changelog is extensive, including some improvements to features I&#8217;d like to start using, so today seemed a good day to update.

Updating was extremely easy. Since I started with 3.1, all I had to do was click the update button in the Control Panel. After it downloaded, just clicked install. Waited, and it was finished. Very nice.

But as expected, a few settings got messed up after updating. Nothing built in to the UI, but my cron job for running AppDailySales got removed from the /etc/crontab file. No problem, [I wrote down what I did here in a blog post](/2011/08/23/appdailysales-and-running-on-synology-nas-devices/). THAT is why I&#8217;m writing this here now.

SVN seems to be still running properly. Nothing to do there. All my settings are still set. The wiki is still running. Great.

However, the **EVIL** Thumbnail generation processes are back! These eat up 100% of the CPU usage, doing pointless thumbnail generation. Ack!

But [like before](/2011/08/23/i-am-running-a-synology-nas-now/), this is easily fixed.

`cd /usr/syno/etc/rc.d/<br />
S77synomkthumbd.sh stop<br />
S88synomkflvd.sh stop`

But unlike my old notes, I have since found that renaming the files was not enough. The better solution is to move them out of the **rc.d** folder.

`mkdir ../rc.d.I_REALLY_HATE_THUMBNAILS<br />
mv S77synomkthumbd.sh ../rc.d.I_REALLY_HATE_THUMBNAILS<br />
mv S88synomkflvd.sh ../rc.d.I_REALLY_HATE_THUMBNAILS`

After waiting a while double checking &#8220;top&#8221;, I then saw a process **fileindexd** start up and eat my CPU. no problem.

`S66fileindexd.sh stop`

This one I did not remove from the folder, so it&#8217;ll certainly start up again once the NAS reboots. Thumbnails are useless to me, but file indexes I need to look in to. I don&#8217;t yet know if these file indexes are a Synology thing or a Linux thing.

That&#8217;s everything I&#8217;ve had to fix since upgrading.

Now, lets try out some new features!

## Remote Backups

At long last, I finally set up remote backups on the device. I&#8217;m actually backing up my data 2 places:

  1. To the &#8220;other&#8221; NAS
  2. To Amazon S3

Both options are built-in to the device, you simply have to provide login credentials&#8230; oh, and one thing each. 

  * On your &#8220;other&#8221; Synology NAS, you need to enable Network Backup mode (in the control panel).
  * On Amazon S3, you need to create a bucket to store the data.

I&#8217;m especially fond of the Amazon option, not only because it&#8217;s remote, but because it lets me experiment with Amazon AWS services. Amazon gives you a whole bunch of free data and services for 12 months, and if my math is correct, once those 12 months expire it&#8217;ll cost me less than $0.50 a month to host my 3 GB repository mirror. Not bad&#8230; Heck, that&#8217;s a bargain given what that data is worth to me (my whole biz relies on this).

Best I can tell, it only stores a single copy of each file on the backup destination (as it should), and only sends files that have changed. There is an optional addon extension called &#8220;Time Backup&#8221;, which as far as I can tell works just like Apple&#8217;s Time Machine. Time Backup only works with remote Synology devices, or attached external drives (no Amazon).

## VPN

<div id="attachment_4599" style="max-width: 160px" class="wp-caption alignright">
  <a href="/wp-content/uploads/2011/10/IMG_20111029_205854.jpg"><img src="/wp-content/uploads/2011/10/IMG_20111029_205854-150x150.jpg" alt="" title="IMG_20111029_205854" width="150" height="150" class="size-thumbnail wp-image-4599" /></a>
  
  <p class="wp-caption-text">
    Remote access to my network, on an iPod
  </p>
</div>Now this very cool. For a while I was (figuratively) bashing my head against a wall trying to come up with a solution for accessing my SVN repository and wiki remotely. The repository was the tricky part, as the local PCs on my network tend to use the local Windows share name or the IP in the SVN url. Local IPs don&#8217;t exist outside your LAN foo!

So today I set up a VPN. This is an addon feature for the Synology that&#8217;s pretty great. I wont bother describing the setup, since it&#8217;s literally a checkbox and some minor configuration. I&#8217;m using PPTP, since it seems to be supported everywhere. It&#8217;s literally a feature of Windows, OSX, iOS, Android, and I would not be surprised if it worked on stock Ubuntu too (I have not checked as of this writing).

The only real work was opening the port on my router, and calling that work is pretty silly. After opening the port, I was able to access the VPN locally by using my IP. That wasn&#8217;t enough of a test for for me though, so I picked up my laptop and visited my parents to &#8220;borrow&#8221; their WIFI. Yep, worked great. Once connected, I can commit and checkout from my SVN repository, view my wiki, and even access devices on my network&#8230; all from far far away.

I figure I&#8217;ll only be using this when I&#8217;m out of town, or hanging/jamming at a friends place. Still, it perfectly solves my SVN problems, and gives me a bunch of nice features. My router easily lets me turn this off too, so I can keep my local network nice and secure in the off season.

## Summary-ology

The Synology DS211j NAS &#8211; Easily the best $200 (+drives) I&#8217;ve spent in a long time.