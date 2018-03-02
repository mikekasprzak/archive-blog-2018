---
id: 9675
title: 'Notes: Creating an rsync jail'
date: 2017-04-01T04:25:57+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9675
permalink: /2017/04/01/notes-creating-an-rsync-jail/
categories:
  - Uncategorized
---
Configuring this properly required me to learn a few new things.

## Where to store files

If you have files that should belong to a single user, place them in the user&#8217;s home folder.

`/home/username/`

If the files are shared across multiple users, place them in a folder under the service folder.

`/srv/my-project/`

> This main purpose of specifying this is so that users may find the location of the data files for particular service, and so that services which require a single tree for readonly data, writable data and scripts (such as cgi scripts) can be reasonably placed. Data that is only of interest to a specific user should go in that users&#8217; home directory.

<http://www.pathname.com/fhs/pub/fhs-2.3.html#SRVDATAFORSERVICESPROVIDEDBYSYSTEM>

Depending on the purpose of the server, you need to decide if tasks are per-user or shared.

If you do decide to use the `/srv/` folder, consider placing a symlink to the folder each user cares about inside the user&#8217;s home folder. This is simply to remind them that the data they care about is elsewhere.

## Hardlinks, Symlinks and Mounts

As a Linux user, you probably know symlinks.

<pre class="lang:default decode:true " >ln -s TARGET name_of_link</pre>

TARGET is something we want to reference, and `name_of_link` is where we want to put it (if you omit `name_of_link`, it gets placed in the current folder).

Generally speaking, this is the preferred way to link things on Linux.

Symlinks however do require that you have access to the file linked to. In other words, you have permission to manually go to the location of the file and use it. Later on when we start talking about jailing, this will be something we don&#8217;t have.

Hardlinks are created the exact same way as Symlinks, but without the `-s`. 

<pre class="lang:default decode:true " >ln TARGET name_of_link</pre>

Internally, a hardlink creates a brand new file that references the same data (inode) used by another file.

<pre class="lang:default decode:true " >user@computer:~$ ls -il file*
2368339 -rw-r--r-- 2 user user 35 Mar 31 23:51 file1
2368758 lrwxrwxrwx 1 user user  5 Apr  1 00:14 file2 -&gt; file1         # symlink
2368339 -rw-r--r-- 2 user user 35 Mar 31 23:51 file3                  # hardlink
#       ^ symlink
#                  ^ Number of inode references
</pre>

Using `-i` with `ls` shows the inode number. Every file has one. This is how you spot a hardlink. When 2 or more files share the same inode number, it&#8217;s not that one is a link to the other, they **ARE** the same file.

With that in mind, you can&#8217;t actually detect hardlinks like you can detect symlinks. When you delete a file on Linux, it doesn&#8217;t necessarily delete the file. Not until an inode runs out of references to to it is data deleted.

**Important**: Hardlinks can only be files. They can&#8217;t link folders. For what I&#8217;m doing here, I don&#8217;t need this feature, but I&#8217;ve included it for completeness. 

To get the equivalent of a hardlink on a folder (i.e. access to the original isn&#8217;t required), you&#8217;ll need a binding mount.

<pre class="lang:default decode:true " >mount --bind /some/where /else/where</pre>

This makes `/else/where` appear to contain everything `/some/where` did. Beware of recursion when mounting!

A mount can be made read-only like so:

<pre class="lang:default decode:true " >mount --bind /some/where /else/where
mount -o remount,ro,bind /else/where
</pre>

The `-o` option is used to pass alternative options to mount. `--bind` is actually a shorthand for `-o bind`.

Reference: <http://askubuntu.com/a/801191>
  
Reference: <http://unix.stackexchange.com/a/198591>

## Creating a jailed user

Before we make the jail, we need user(s) to put in the jail.

<pre class="lang:default decode:true " >adduser --disabled-password username</pre>

The disabled password is to disallow them from logging in via password authentication. Also for security&#8217;s sake, try to avoid making a jailed user a sudoer.

<pre class="lang:default decode:true " >passwd --status username</pre>

The above can be used to check the status of a user.

> Display account status information. The status information consists of 7 fields. The first field is the user&#8217;s login name. The second field indicates if the user account has a locked password (L), has no password (NP), or has a usable password (P). The third field gives the date of the last password change. The next four fields are the minimum age, maximum age, warning period, and inactivity period for the password. These ages are expressed in days.

If we did things correctly, our user should have a locked password (L).

Reference: <http://unix.stackexchange.com/a/184975>

## Setting up and generating RSA SSH keys for jailed users

On the client PC, you&#8217;ll need to generate a public+private key pair.

<pre class="lang:default decode:true " >ssh-keygen -b 4096</pre>

The default these days is RSA 2048. RSA 4096 is a bit safer, but it&#8217;s encryption so who knows for how long that will be the case. ECDSA (specifically ED25519) is on track to replace RSA, but the situation is a bit fishy right now (ECDSA has a potential hole, which ED works around, but it&#8217;s new&#8217;ish).

Then you&#8217;ll need to install the public key.

As root, you&#8217;d typically want to do this:

<pre class="lang:default decode:true " >su - username      # switches to user 'username'
cd ~
mkdir .ssh         # if it doesn't exist
cd .ssh
nano authorized_keys</pre>

Then paste the contents of your `id_rsa.pub` file here.

Save the file, exit the user, and restart the SSH server.

<pre class="lang:default decode:true " >exit
service ssh restart</pre>

You should now be able to connect to the server over ssh as the jailed user.

<pre class="lang:default decode:true " >ssh username@host</pre>

**Addendum**: There&#8217;s also a command `ssh-copy-id` that can be used to install the public key for you, but only if have password access.

<pre class="lang:default decode:true " >ssh-copy-id username@host</pre>

Without access, this command is useless (included here just for reference).

Reference: <http://askubuntu.com/a/46935>

## Setting up the Jail

Enabling the jail is actually really simple. The problem is the jail will have nothing in it.

Open up `/etc/ssh/sshd_config`

For simplicity, you should change the Subsystem line to the following:

<pre class="lang:default decode:true " >Subsystem sftp internal-sftp</pre>

Then at the end of the file you can add tiny bit of script to immediately lock the user in the jail.

<pre class="lang:default decode:true " >Match User username
        ChrootDirectory /home/username/my-prison
        AllowTcpForwarding no</pre>

Where username is the user&#8217;s name, and `/home/username/my-prison` is any folder you decide to make in to the root `/` folder. The folder should belong to the `root` user (even if it&#8217;s their home folder).

Save and restart the ssh server, and from now on, any time that user attempts to SSH in, they&#8217;ll get locked to that folder.

**HOWEVER!** The user lacking some basic tools. Most important: `/bin/bash`. Without `/bin/bash`, the connection will close immediately after logging in. 

Now you need to build a filesystem.

Reference: <https://www.linode.com/docs/tools-reference/tools/limiting-access-with-sftp-jails-on-debian-and-ubuntu>
  
Reference: <https://www.marcus-povey.co.uk/2015/04/09/cross-server-ssh-rsync-backups-done-more-securely/>

## Building the jailed users file system

You should do this as the `root` user.

**NB:** When I first started writing this note article, I expected I was going to use hardlinks to reference the currently installed version of all tools and libraries. While this does work, I realized there is an issue: dependency filenames. As long as dependencies don&#8217;t change filenames this is a non issue, but there is a change they may, as the OS updates. The chance of changes might be lower on an LTS version of Ubuntu, but I&#8217;m using a derived version of Ubuntu that regularly switches-out the Kernel. So instead, one should just `cp` the files, not hardlink them, and keep an ear out for known exploits of the tools you use.

Installing Bash (required to open an SSH connection and execute commands).

<pre class="lang:default decode:true " >cd /home/username/my-prison
mkdir bin
cd bin
cp /bin/bash .
ldd bash</pre>

This will report to us what library dependencies `bash` needs to be run. The printout may look something like this.

<pre class="lang:default decode:true " >linux-vdso.so.1 =&gt;  (0xbefa1000)
	libtinfo.so.5 =&gt; /lib/arm-linux-gnueabihf/libtinfo.so.5 (0xb6ef1000)
	libdl.so.2 =&gt; /lib/arm-linux-gnueabihf/libdl.so.2 (0xb6edd000)
	libc.so.6 =&gt; /lib/arm-linux-gnueabihf/libc.so.6 (0xb6df1000)
	/lib/ld-linux-armhf.so.3 (0x7f5d2000)
</pre>

What&#8217;s important is to pay attention to the lines with paths. All those `/lib/`&#8216;s.

<pre class="lang:default decode:true " >cd ..                          # leave bin/
mkdir lib
cd lib
mkdir arm-linux-gnueabihf      # I'm working in an ARM port of Ubuntu
cd arm-linux-gnueabihf

cp /lib/arm-linux-gnueabihf/libtinfo.so.5 .
cp /lib/arm-linux-gnueabihf/libdl.so.2 .
cp /lib/arm-linux-gnueabihf/libc.so.6 .
cd ..
cp /lib/ld-linux-armhf.so.3 .</pre>

Using `cp` here makes this process far simpler. Many of these files are actually symlinks, so using a hardlink would create a dependency on yet another file.

That is everything needed to use Bash.

Installing rsync:

<pre class="lang:default decode:true " >cd ..
cd bin
cp /usr/bin/rsync .
ldd rsync

#	linux-vdso.so.1 =&gt;  (0xbec1b000)
#	libattr.so.1 =&gt; /lib/arm-linux-gnueabihf/libattr.so.1 (0xb6ed4000)
#	libacl.so.1 =&gt; /lib/arm-linux-gnueabihf/libacl.so.1 (0xb6ebd000)
#	libpopt.so.0 =&gt; /lib/arm-linux-gnueabihf/libpopt.so.0 (0xb6ea4000)
#	libc.so.6 =&gt; /lib/arm-linux-gnueabihf/libc.so.6 (0xb6db8000)
#	/lib/ld-linux-armhf.so.3 (0x7f5be000)

cd ..
cd lib/arm-linux-gnueabihf

# As you install more tools, some of these will already exist
cp /lib/arm-linux-gnueabihf/libattr.so.1 .
cp /lib/arm-linux-gnueabihf/libacl.so.1 .
cp /lib/arm-linux-gnueabihf/libpopt.so.0 .
cp /lib/arm-linux-gnueabihf/libc.so.6 .
cd ..
cp /lib/ld-linux-armhf.so.3 .</pre>

The process is fairly similar for other tools.

With the above 2 tools installed, you should be able to rsync to this machine&#8230; and that&#8217;s it. Other commands like `ls` or `cp` wont be available out-of-the-box, but an rsync-only user really shouldn&#8217;t need them anyway.