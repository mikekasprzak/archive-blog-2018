---
id: 8290
title: 'Notes: Mail Server Madness'
date: 2016-03-20T02:20:05+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=8290
permalink: /2016/03/20/notes-mail-server-madness/
categories:
  - Uncategorized
---
To avoid being flagged a spammer, your DNS server (and SMTP server) needs to be configured for:

  * PTR Records (Host)
  * SPF Records (DNS)
  * DKIM Records (DNS + SMTP)
  * DMARC Records (DNS + an email address)
  * TLS Certificate (an SSL Certifiate for your mail domain)

The last one is required to send encrypted mail.

<!--more-->

## PTR Record

Also known as the Reverse DNS. This is SUPER REQUIRED OMG!

It should reference your mail server. i.e. mail.mydomain.com

<pre class="lang:default decode:true " >dig mail.mydomain.com
# should return IP address

# using that IP
dig -x 123.45.6.78
# should return mail.mydomain.com</pre>

## SPF Records

These are easy. Add them to your DNS. TXT records are most important (one site says SPF records were obsoleted).

<pre class="lang:default decode:true " >Record  Name               Value
TXT     mail               v=spf1 +ip4:200.14.16.114/24 ~all
SPF     mail               v=spf1 +ip4:200.14.16.114/24 ~all

TXT     mydomain.com       v=spf1 include:mail.mydomain.com ~all
SPF     mydomain.com       v=spf1 include:mail.mydomain.com ~all
</pre>

## DKIM Records

This was very difficult to get working! To make matters worse, WordPress is stuid, and hasn&#8217;t fixed this even though it&#8217;s very broken and causes problems. WTF.

About the WP bug: <https://core.trac.wordpress.org/ticket/22837>

Setting up DKIM Tools:

<blockquote data-secret="z1kidvsXQZ" class="wp-embedded-content">
  <p>
    <a href="https://easyengine.io/tutorials/mail/dkim-postfix-ubuntu/">DKIM with Postfix</a>
  </p>
</blockquote>

<iframe class="wp-embedded-content" sandbox="allow-scripts" security="restricted" style="position: absolute; clip: rect(1px, 1px, 1px, 1px);" src="https://easyengine.io/tutorials/mail/dkim-postfix-ubuntu/embed/#?secret=z1kidvsXQZ" data-secret="z1kidvsXQZ" width="500" height="282" title="&#8220;DKIM with Postfix&#8221; &#8212; EasyEngine" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

A useful tool for generating the correct public/private key files (public key requires fancy formatting).

https://www.port25.com/support/domainkeysdkim-wizard/

Add a TXT record for the DKIM public key:

<pre class="lang:default decode:true " >TXT     mail._domainkey      v=DKIM1; k=rsa; p=(SOME_CRAZYLONG_STRING)
</pre>

If configured and sent correctly, your emails will include a DKIM signature section in the header (the private key).

<pre class="lang:default decode:true " >DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mydomain.com; s=mail;
	t=number; bh=hash;
	h=From:Subject:Date:From;
	b=SOME_VERY_LONG_STRING_AHHHHHHHHHHHHHHHHHHHH
</pre>

The key thing to know here is that the &#8220;s=mail&#8221; should match the name (i.e. the mail in mail._domainkey).

More DKIM:

<blockquote data-secret="411uJNO6ek" class="wp-embedded-content">
  <p>
    <a href="http://www.stevejenkins.com/blog/2010/09/how-to-get-dkim-domainkeys-identified-mail-working-on-centos-5-5-and-postfix-using-opendkim/">How to get DKIM (DomainKeys Identified Mail) working with Postfix on RHEL 5 / CentOS 5 using OpenDKIM</a>
  </p>
</blockquote>

<iframe class="wp-embedded-content" sandbox="allow-scripts" security="restricted" style="position: absolute; clip: rect(1px, 1px, 1px, 1px);" src="http://www.stevejenkins.com/blog/2010/09/how-to-get-dkim-domainkeys-identified-mail-working-on-centos-5-5-and-postfix-using-opendkim/embed/#?secret=411uJNO6ek" data-secret="411uJNO6ek" width="500" height="282" title="&#8220;How to get DKIM (DomainKeys Identified Mail) working with Postfix on RHEL 5 / CentOS 5 using OpenDKIM&#8221; &#8212; SteveJenkins.com" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

http://blog.codinghorror.com/so-youd-like-to-send-some-email-through-code/

https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-dkim-with-postfix-on-debian-wheezy

## DMARC Records

Just a simple record that tells people where to send reports.

https://support.google.com/a/answer/2466563?hl=en&ref_topic=2759254

This link above told me everything I needed. I added a simple record to my cloudflare, and it was good. Reports started showing up.

<pre class="lang:default decode:true " >TXT    _dmarc        v=DMARC1; p=none; rua=mailto:postmaster@ludumdare.com</pre>

## SSMTP

SSMTP is a sendmail compatible light client that forwards e-mails to other addresses. It&#8217;s not a mailserver.

## Installing Postfix

Postfix is an SMTP server. It should be installed like so.

https://www.digitalocean.com/community/tutorials/how-to-install-and-setup-postfix-on-ubuntu-14-04

**DON&#8217;T FORGET TO SET THE HOSTS FILES!**

<pre class="lang:default decode:true " ># /etc/hostname
machine_name

# /etc/hosts
127.0.1.1       domain.com machine_name  # domain.com will not be set
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
</pre>

It can be configured as a &#8220;SEND ONLY&#8221; server.

https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-postfix-as-a-send-only-smtp-server-on-ubuntu-14-04

Details on how it can be CHROOT&#8217;ed are in the documentation:

http://www.postfix.org/BASIC\_CONFIGURATION\_README.html

Some useful commands:

http://www.cyberciti.biz/tips/howto-postfix-flush-mail-queue.html

(mailq, postfix flush, postsuper)

Apparently easy to add to PHP (if not already working&#8230; it might be).

[Configure Postfix/Sendmail for PHP mail() in&nbsp;Ubuntu](http://eureka.ykyuen.info/2011/02/06/configure-postfixsendmail-for-php-mail-in-ubuntu/)

## Testing

http://mxtoolbox.com/SuperTool.aspx?action=smtp

<pre class="lang:default decode:true " ># Get MX Records
dig legacy.ludumdare.com MX

# Get NS Records (to know Authority server)
dig legacy.ludumdare.com NS

# Get MX Records from Authority server (the @)
dig @angela.ns.cloudflare.com legacy.ludumdare.com MX

# View Mail/Sendmail/PostFix log
cat /var/log/mail.log

# Clear Log (trick! redirect nothing to it, not append)
&gt; /var/log/mail.log

# Verify email by sending a message to port25
echo " " | mail -s "test" check-auth@verifier.port25.com

# dkim key needs to be limited to whom can read it  
chmod 600 /etc/postfix/dkim.key 
</pre>

## TLS Encryption

Encrypting emails is another issue that needs to be dealt with.

Create/follow the instructions here, and generate a free certificate for your **mail.website.com** domain.

<blockquote data-secret="16Jlw4Zjds" class="wp-embedded-content">
  <p>
    <a href="http://www.stevejenkins.com/blog/2011/09/how-to-use-a-free-startssl-certificate-in-postfix-for-ssltls/">Configure Postfix TLS with a Free StartSSL Certificate</a>
  </p>
</blockquote>

<iframe class="wp-embedded-content" sandbox="allow-scripts" security="restricted" style="position: absolute; clip: rect(1px, 1px, 1px, 1px);" src="http://www.stevejenkins.com/blog/2011/09/how-to-use-a-free-startssl-certificate-in-postfix-for-ssltls/embed/#?secret=16Jlw4Zjds" data-secret="16Jlw4Zjds" width="500" height="282" title="&#8220;Configure Postfix TLS with a Free StartSSL Certificate&#8221; &#8212; SteveJenkins.com" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

It required a passphrase to generate the CSR+KEY. However, Postfix does not support KEYs with a password.

<pre class="lang:default decode:true " ># Check if key is good (or requires passphrase)
openssl rsa -in in_file.key -check -noout

# Unencrypt a key
openssl rsa -in in_file.key -out out_file.key</pre>

I tried this reference without luck (though I didn&#8217;t follow all configuration instructions).

http://forums.sentora.org/showthread.php?tid=46

This is how to force TLS, but not necessary once configured correctly.

http://serverfault.com/questions/120123/forcing-smtp-outgoing-mail-encryption-on-postfix

## Getting root emails forwarded

Was pretty easy.

http://blog.dastrup.com/?p=53=1

Add a line &#8220;root: blah@blah.com&#8221; to &#8216;/etc/aliases&#8217;. run &#8216;newaliases&#8217;. Magic.

## SRS Forwarding

The above is easy, but will fail SPF checks. The sender needs to be modified to correctly forward an e-mail, then the SPF can be regenerated. This is done using SRS.

https://seasonofcode.com/posts/setting-up-dkim-and-srs-in-postfix.html

The &#8216;postsrsd&#8217; package \*IS\* available on Ubuntu now, so just apt-get it.

More info on SRS:

http://www.openspf.org/SRS

## rsyslogd-2007: action &#8216;action 9&#8217; suspendend

When you look at the syslog (/var/log/syslog), you see lines like the above.

This (or lines like it) are caused by a default Ubuntu/Debian configuration. At the bottom of &#8220;/etc/rsyslog.d/50-default.conf&#8221;, there are a several lines that describe logging to xconsole. Xconsole, AFAIK is the XWindows logger. Oops! So that&#8217;s not going to work while running a headless server.

https://www.raspberrypi.org/forums/viewtopic.php?f=91&t=122601

## Socket Madness

You can bind the default /var/run folder to use the default unix domain socket config.

<pre>mkdir -p /var/spool/postfix/var/run/opendkim
mount --bind /var/run/opendkim /var/spool/postfix/var/run/opendkim
</pre>

**NOTE:** The OpenDKIM service does some funny stuff regarding settings. If you customize the socket, it sometimes appends your socket settings to &#8220;**/etc/default/opendkim**&#8220;.

To work around this, I had to start from scratch.

<pre class="lang:default decode:true " >apt-get remove --purge opendkim</pre>

Purge is required. Otherwise, the old config files will stick around.

<http://www.binarytides.com/postfix-mail-forwarding-debian/>

More:

<http://www.postfix.org/aliases.5.html>
  
<http://www.postfix.org/virtual.5.html>
  
<http://wiki.dovecot.org/MailboxFormat/dbox>
  
<https://help.ubuntu.com/community/PostfixBasicSetupHowto>
  
<http://www.courier-mta.org/maildir.html>
  
<http://unix.stackexchange.com/questions/132654/how-to-make-postfix-create-maildir>
  
<https://rimuhosting.com/support/bindviawebmin.jsp>