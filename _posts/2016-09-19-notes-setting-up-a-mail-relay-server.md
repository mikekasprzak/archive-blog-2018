---
id: 9216
title: 'Notes: Setting up a modern Mail Server and Relay'
date: 2016-09-19T19:01:04+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9216
permalink: /2016/09/19/notes-setting-up-a-mail-relay-server/
categories:
  - Technobabble
---
This is an attempt to clean up these notes:

<http://blog.toonormal.com/2016/03/20/notes-mail-server-madness/>

References go there. This post is a summary.

<!--more-->

## 0. Before we start

These notes were collected while setting up a brand new mail server, on a fresh install of Ubuntu 16.04 Server.

I assume the user is **root**.

## 1. Pick a subdomain (and domain) for your mail server

Typically this is **mail** (i.e. **mail.mydomain.com**), but it can be anything. What&#8217;s important is that you&#8217;re consistent.

**mail.mydomain.com** is often referred to as the **FQDN** (Fully Qualified Domain Name). 

You will be using all 3 variants (**mail**, **mydomain.com**, **mail.mydomain.com**) depending on what you&#8217;re doing.

## 2. Postfix (MTA)

**Postfix** is an Mail Transfer Agent (MTA) used to route and deliver e-mail. 

Postfix uses **SMTP** (Simple Mail Transfer Protocol). It listens for mail, and either delivers it to a local user, or relays it to an external address. It **does not** provide a way for users to view their local mailbox. To be able to view a mailbox, you need to use a piece of software like **Dovecot** to run an **IMAP** or **POP3** server. 

With Postfix installed, we have everything we need to send and receive e-mails (other tools make it easier though).

### 2a. Before we start

We need to edit the host files. By default, the machine doesn&#8217;t know what domain to send e-mails from.

<pre class="lang:default decode:true " >cat /etc/hostname

# /etc/hostname should be a one line file like this:
myservername</pre>

<pre class="lang:default decode:true " >cat /etc/hosts

# /etc/hosts should look something like this:
127.0.1.1       mydomain.com myservername
127.0.0.1       localhost
::1             localhost ip6-localhost ip6-loopback
ff02::1         ip6-allnodes
ff02::2         ip6-allrouters
</pre>

More than likely, the first line will be missing the domain part (**mydomain.com**). Adjust it accordingly.

<pre class="lang:default decode:true " ># Change the hosts file
nano /etc/hosts

# Reboot
reboot now</pre>

This sets the e-mail address emails from users send from (i.e. **root@mydomain.com**).

### 2b. Install Postfix and MailUtils

<pre class="lang:default decode:true " ># The mailutils package has postfix and a few more tools (mail)
apt-get install mailutils

# We're saving ourselves a bunch of trouble by installing this
#  instead of just the postfix package</pre>

Done. You now have a mailbox in **/var/mail/root**

Here are some useful commands you may want to reference.

<pre class="lang:default decode:true " ># View Root's Email
cat /var/mail/root

# Edit Config File
nano /etc/postfix/main.cf
# There are a few other config files in this folder (master.cf, etc)

# Restart Postfix
service postfix restart

# Send a mail from the current user (root, etc)
echo "text" | mail -s "subject" somebody@somedomain.com

# View Logs
cat /var/log/syslog            # system log, some messages
cat /var/log/mail.log          # mail log, more message
cat /var/log/mail.err          # mail errors
tail -n 20 /var/log/syslog     # view last 20 lines of syslog

# Update Aliases
nano /etc/aliases
newaliases                     # Required! Generates /etc/aliases.db

# Update Virtual Aliases (optional)
nano /etc/postfix/virtual
postmap /etc/postfix/virtual  # Required! Generates virtual.db</pre>

### 2c. Configuring Postfix

&#8230;

## 3. PTR (Pointer Records, i.e. Reverse DNS lookups)

PTR&#8217;s are used to convert an IP address in to a domain name.

PTR&#8217;s are set by your webhost (specifically, whomever owns/allocated your public IP address). 

It should be set your mail server&#8217;s FQDN.

<pre class="lang:default decode:true " >dig mail.mydomain.com
# should return the IP address

# using that same IP address
dig -x 123.45.67.89
# should return mail.mydomain.com</pre>

## 4. SPF (Sender Policy Framework)

SPF Records are used to say what IPs are allowed to send mail on behalf of a domain. 

Add them as TXT records to your DNS (Cloudflare, etc).

<pre class="lang:default decode:true " >Record  Name               Value
TXT     mail               v=spf1 +ip4:123.45.67.89/24 ~all
TXT     mydomain.com       v=spf1 include:mail.mydomain.com ~all
</pre>

You may also notice your DNS supports SPF records. These are optional, and set to the exact same values. SPF records were obsoleted, as AFAIK everybody used TXT records instead, and SPF was simply unable to get enough support.

The 2nd case (mydomain.com) makes reference to the FQDN. When configuring a separate domain to use your mail server, you only need a version of the 2nd line pointing to your mail server (unless you also want to get mail from mail.otherdomain.com). Mail servers will recursively follow &#8220;include:&#8217;s&#8221; until they find an SPF record with an IP (though I&#8217;ve seen it suggested you should keep recursion depth low for maximum compatibility).

&#8220;**~all**&#8221; means _softfail_ on SPF failures (i.e. don&#8217;t fail). To fail on SPF failures, use &#8220;**-all**&#8220;.

To check that records are correctly set, dig them.

<pre class="lang:default decode:true " >dig mail.mydomain.com txt
dig mydomain.com txt</pre>

\* \* *

When setting up a mail relay server, the IP address of the sender will change to the relay itself. Thus, the SPF check will now fail. If using &#8220;**~all**&#8221; this fine, but may not be ideal long term. 

To correct this, the relay needs to rewrite the sender. **SRS** should be used for this (discussed later). SRS rewrites the sender in such a way that the origin domain is included, as well as the new (your) domain. The new (your) domain becomes the part after the **@** sign, and thus, when doing an SPF check, now passes since your IP address now matches the sender domain&#8217;s SPF record.

## 5. DMARC (Domain Message Authentication Reporting & Conformance)

DMARC records do a few things. Most importantly, they tell other mail servers where to send reports.

These reports can be very helpful for debugging (huzzah).

<pre class="lang:default decode:true " >Record  Name               Value
TXT     _dmarc             v=DMARC1; p=none; rua=mailto:postmaster@mydomain.com
</pre>

Reports are XML files sent daily by all the big e-mail providers. 

If it&#8217;s working correctly, you (**postmaster@mydomain.com**) will get e-mails. 🙂

If you&#8217;re monitoring incoming mail (**/var/mail/root**), they tend to come delivered as BASE64 encoded ZIP files.

<pre class="lang:default decode:true " ># Hack. Figure out how long the latest report is.
tail -n 20 /var/mail/root
# Adjust the above line until all you have is whitespace and lines of BASE64 data.

# Once you've figured it out, you can compose a line like this.
tail -n 12 /var/mail/root | base64 --decode > out.zip
unzip out.zip

# View the output like so:
cat google.com!mydomain.com!1474156800!1474243199.xml

# In Google's case, numbers are the start/end times as Unix timestamps.
</pre>

Reports look something like this.

<pre class="lang:xhtml decode:true " >&lt;?xml version="1.0" encoding="UTF-8" ?&gt;
&lt;feedback&gt;
  &lt;report_metadata&gt;
    &lt;org_name&gt;google.com&lt;/org_name&gt;
    &lt;email&gt;noreply-dmarc-support@google.com&lt;/email&gt;
    &lt;extra_contact_info&gt;https://support.google.com/a/answer/2466580&lt;/extra_contact_info&gt;
    &lt;report_id&gt;14815660973286397553&lt;/report_id&gt;
    &lt;date_range&gt;
      &lt;begin&gt;1474156800&lt;/begin&gt;
      &lt;end&gt;1474243199&lt;/end&gt;
    &lt;/date_range&gt;
  &lt;/report_metadata&gt;
  &lt;policy_published&gt;
    &lt;domain&gt;mydomain.com&lt;/domain&gt;
    &lt;adkim&gt;r&lt;/adkim&gt;
    &lt;aspf&gt;r&lt;/aspf&gt;
    &lt;p&gt;none&lt;/p&gt;
    &lt;sp&gt;none&lt;/sp&gt;
    &lt;pct&gt;100&lt;/pct&gt;
  &lt;/policy_published&gt;
  &lt;record&gt;
    &lt;row&gt;
      &lt;source_ip&gt;123.45.67.89&lt;/source_ip&gt;
      &lt;count&gt;15&lt;/count&gt;
      &lt;policy_evaluated&gt;
        &lt;disposition&gt;none&lt;/disposition&gt;
        &lt;dkim&gt;pass&lt;/dkim&gt;
        &lt;spf&gt;pass&lt;/spf&gt;
      &lt;/policy_evaluated&gt;
    &lt;/row&gt;
    &lt;identifiers&gt;
      &lt;header_from&gt;mail.mydomain.com&lt;/header_from&gt;
    &lt;/identifiers&gt;
    &lt;auth_results&gt;
      &lt;spf&gt;
        &lt;domain&gt;mail.mydomain.com&lt;/domain&gt;
        &lt;result&gt;pass&lt;/result&gt;
      &lt;/spf&gt;
    &lt;/auth_results&gt;
  &lt;/record&gt;
&lt;/feedback&gt;
</pre>

The data in the later half of the report tends to be most useful. Telling you if DKIM and SPF tests pass.

DMARC is not only used for error reporting, but it tells the client what to do upon failure.

The &#8220;**p=none**&#8221; tells the client to take no special actions. Alternatively, &#8220;**p=quarantine**&#8221; or &#8220;**p=reject**&#8221; can be used to take action upon failure (send to spam, reject outright).

It&#8217;s good practice to begin with &#8220;**p=none**&#8220;. Once you have some reports under your belt, you can begin to quarantine or reject messages. This can be done gradually. More details can be found in the references below:

  * <https://support.google.com/a/answer/2466563?hl=en&ref_topic=2759254>
  * <https://dmarc.org/wiki/FAQ>

## 6. DKIM (DomainKeys Identified Mail)

DKIM is used to uniquely identify a domain using a public+private key pair as a signature. This is **NOT** encryption.

Together with **SPF**, mail is validated using the sender&#8217;s IP address (**SPF**), and by confirming their signature (**DKIM**). **DMARC** then says what to do about failures (though **SPF** does too), and who to report them to.

### 6a. Installing DKIM tools

<pre class="lang:default decode:true " >apt-get install opendkim opendkim-tools</pre>

### 6b. Generating the DKIM signature and permissions!

Debian/Ubuntu has a standard folder for this: **/etc/dkimkeys/**

What&#8217;s special about this folder is that it&#8217;s owned by **opendkim:opendkim**. Don&#8217;t forget to set permissions!

<pre class="lang:default decode:true " >cd /etc/dkimkeys/

# Generate Keys (-s subdomain -d domain.com)
opendkim-genkey -s mail -d mydomain.com
# This generates 2 files: 
#   mail.private (the private key) 
#   mail.txt (the DNS record)

# Set File Permissions
chmod 600 mail.private
chown opendkim:opendkim mail.private
</pre>

### 6c. DKIM DNS Settings 

The &#8220;**opendkim-genkey**&#8221; command above generated a 2nd file, **mail.txt**.

<pre class="lang:default decode:true " >cat mail.txt

# mail.txt looks like this (edited for readability)
mail._domainkey	IN	TXT	( "v=DKIM1; k=rsa; "
	  "p=LALALA_SOME_REALLY_LONG_STRING" )
</pre>

We want what&#8217;s inside the quotes (both sets). Edit that together on one line, removing quotes, like so:

<pre class="lang:default decode:true " >v=DKIM1; k=rsa; p=LALALA_SOME_REALLY_LONG_STRING</pre>

Now you can paste that in to your DNS control panel.

Create a TXT record named **mail._domainkey**, and paste the edited line above.

### 6d. Configuring OpenDKIM

Edit the config file.

<pre class="lang:default decode:true " >nano /etc/opendkim.conf</pre>

The default file is fine, but could use a few tweaks.

<pre class="lang:default decode:true " ># Log to syslog
Syslog                  yes
SyslogSuccess           yes
#LogWhy                 yes     # Only if debugging "why"
# Required to use local socket with MTAs that access the socket as a non-
# privileged user (e.g. Postfix)
UMask                   002

# Sign for example.com with key in /etc/dkimkeys/dkim.key using
# selector '2007' (e.g. 2007._domainkey.example.com)
Domain                  mydomain.com
KeyFile                 /etc/dkimkeys/mail.private
Selector                mail
</pre>

Now comes the weird stuff.

\* \* *

On a stock Ubuntu install, Postfix is (mostly) run in a **chroot jail**. As far as Postfix is concerned, the &#8220;**/**&#8221; folder is &#8220;**/var/spool/postfix/**&#8220;. It cannot access anything outside this folder.

Therefor, the simplest way to use OpenDKIM with Postfix is with a TCP socket, but a Unix domain socket is much better.

Furthermore, the simplest way to use a Unix domain socket is as follows. Run the following commands:

<pre class="lang:default decode:true " ># Make a directory inside the chroot jail for our socket
mkdir -p /var/spool/postfix/var/run/opendkim

# Set permissions
chown opendkim:opendkim /var/spool/postfix/var/run/opendkim

# Add user "postfix" to "opendkim" group
adduser postfix opendkim</pre>

Next edit the defaults file.

<pre class="lang:default decode:true " >nano /etc/default/opendkim</pre>

Add this to the **end** of the file:

<pre class="lang:default decode:true " >SOCKET="local:/var/spool/postfix/var/run/opendkim/opendkim.sock"
</pre>

Finally, restart the OpenDKIM service.

<pre class="lang:default decode:true " >service opendkim restart
</pre>

Again, that&#8217;s the easy way (it saves a lot of headaches). See the notes for the hard way (binding).

  * <http://unix.stackexchange.com/a/74491>

### 6e. Configuring Postfix for DKIM

Add these lines to the end of your &#8220;**/etc/postfix/main.cf**&#8221; file:

<pre class="lang:default decode:true " ># DKIM settings
milter_protocol = 2
milter_default_action = accept
smtpd_milters = unix:/var/run/opendkim/opendkim.sock
non_smtpd_milters = unix:/var/run/opendkim/opendkim.sock
</pre>

Again, since Postfix is inside the chroot jail, the paths above neglect the &#8220;**/var/spool/postfix**&#8221; folder.

Restart Postfix.

<pre class="lang:default decode:true " >service postfix restart</pre>

  * <http://www.opendkim.org/opendkim.conf.5.html>

## 7. TLS (Transport Layer Security, i.e. Encryption)

whee

## 8. SRS (Sender Rewriting Scheme)

SRS is used to fix the sender, so forwarded e-mails pass the SPF (i.e. sender&#8217;s IP address) test.

How this works can be a little confusing, but essentially this happens:

<pre class="lang:default decode:true " >you@otherdomain.com -&gt; SRS0+t3fm=Cw=otherdomain.com=you@mydomain.com</pre>

SPF checks look at what follows the **@** sign in the sender address. It takes that domain, checks the matching TXT SPF record, and if the IP address of the sender and SPF record match, it succeeds. So SRS is rewriting the sender&#8217;s email to be from you (the forwarder&#8217;s) domain, thus letting the SPF check pass.

To setup, install PostSRSD:

<pre class="lang:default decode:true " >apt-get install postsrsd</pre>

Add these lines to the end of your &#8220;**/etc/postfix/main.cf**&#8221; file:

<pre class="lang:default decode:true " ># PostSRSd settings
sender_canonical_maps = tcp:localhost:10001
sender_canonical_classes = envelope_sender
recipient_canonical_maps = tcp:localhost:10002
recipient_canonical_classes= envelope_recipient,header_recipient
</pre>

  * <http://www.openspf.org/SRS>
  * Reference: <https://seasonofcode.com/posts/setting-up-dkim-and-srs-in-postfix.html>

## X. Aliases and Virtual Aliases

TODO

## X. Adding Domains

TOHDOH

## X. Dovecot (IMAP and POP3)

TODO

## X. Send-only Users

TODO

## Things to Update

Most of the settings are fine and don&#8217;t need to be touched. 

That said, some things should/need to be updated from time to time.

  * When your Domain or IP address changes, update the PTR and SPF records.
  * You shouldn&#8217;t need to, but if you need to refresh the sender identity (DKIM), be sure to update your _ file, and the **mail._domainkey** DNS record. Otherwise, depending on your DMARC/DKIM/SPF settings, mail delivery **will** begin to fail.
  * When your SSL certificate expires, you&#8217;ll need to go to your server and update your TLS. Otherwise, you **lose encryption**! In theory mail is still deliverable, but w/o encryption is bad.