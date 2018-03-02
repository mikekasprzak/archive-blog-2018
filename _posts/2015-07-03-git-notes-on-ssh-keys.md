---
id: 7302
title: Git Notes on SSH Keys
date: 2015-07-03T17:52:14+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7302
permalink: /2015/07/03/git-notes-on-ssh-keys/
categories:
  - Technobabble
---
Dealing with SSH keys is confusing. Every machine you run should have a unique SSH key. 

SSH keys typically consist of 2 files:

  * `id_rsa` &#8211; Your **Private Key**. Used **ONLY** on your local machine.
  * `id_rsa.pub` &#8211; Your **Public Key**. Give it to others (pub for public).

**NEVER SHARE THE PRIVATE KEY!**

The names themselves don&#8217;t matter, so feel free to rename them. It&#8217;s what the files contain that&#8217;s important.

If you ever lose or have a key compromised, generate a new one. As long as we are using them for version control, they are perfectly disposable. **Don&#8217;t forget to delete old keys from your GitHub and Bitbucket accounts!**

* * *

Steps with ****** typically only ever need to be done once per computer.

## Step 1: Generating an SSH key **

Once you&#8217;ve generated a key, it can be used for multiple services (**GitHub**, **Bitbucket**, etc).

You can check if you have any keys installed by looking in the `~/.ssh` directory.

<pre>ls -al ~/.ssh</pre>

The default names are &#8220;`id_rsa`&#8221; and &#8220;`id_rsa.pub`&#8220;.

To generate a key, use `ssh-keygen`:

<pre>ssh-keygen -t rsa -b 4096 -C "your_email@example.com"</pre>

I&#8217;ll be keeping the default names (`~/.ssh/id_rsa` and `~/.ssh/id_rsa.pub`).

By default, when you set a _pass-phrase_, you will be prompted for it every time you access the remote repository. Phrases are strongly recommended, because security. However, this behaviour can be changed (see Appendix A and B).

Source: <https://help.github.com/articles/generating-ssh-keys/>

## Step 1b: Backup your Keys! (optional) **

This isn&#8217;t necessary, but now would be a good time to backup your keys. 

Ideally you should have some real and proper way to backup your keys, but here&#8217;s my lazy way:

<pre>cd ~/.ssh
mkdir backup
cp id_rsa* backup
</pre>

You&#8217;ll always be using the originals (`~/.ssh/id_rsa`), but in case you accidentally overwrite them, you have a copy in the `/backup` folder.

## Step 2: Install Public Key on your services **

If you haven&#8217;t already, install **xclip**.

<pre class="lang:default decode:true " >sudo apt-get install xclip</pre>

SSH Keys need to be copied exactly, so **xclip** handles your clipboard for you.

Copy your Public Key with this command:

<pre class="lang:default decode:true " >xclip -sel clip &lt; ~/.ssh/id_rsa.pub</pre>

Your clipboard will now contain your Public SSH key. 

Next, go add the Public SSH Key to your accounts. Do this by pasting the clipboard in to the box provided.

For **GitHub**, you can find it under `Settings/SSH Keys`.

For details, see **Step 4**: <https://help.github.com/articles/generating-ssh-keys/>

For **Bitbucket**, you can find it under `Manage Account/SSH Keys`.

For details, see **Step 6**: <https://confluence.atlassian.com/display/BITBUCKET/Set+up+SSH+for+Git>

Give the keys added to your accounts good names, something about the computer they belong to. That way it&#8217;s easier to know what machines they belong to if you ever need to generate new ones.

## Step 3. Change remote&#8217;s from HTTPS to SSH

To login using your SSH key, you need to change the remote from an **HTTPS** URL to an **SSH** URI.

To check your remote&#8217;s, run the following command to list them:

<pre>git remote -v</pre>

  * HTTPS URLs typically begin with `https://`
  * SSH URIs typically begin with `git@` (the user), and use a colon `:` to separate **HOST** and **PATH**, not a slash

On **GitHub**, to find out your repository SSH URI, click **SSH** below the clone URL box.

<div id="attachment_7314" style="max-width: 212px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2015/07/github-ssh.png"><img src="/wp-content/uploads/2015/07/github-ssh.png" alt="click on SSH for your SSH clone URI" width="202" height="100" class="size-full wp-image-7314" /></a>
  
  <p class="wp-caption-text">
    click on SSH for your SSH clone URI
  </p>
</div>

On **Bitbucket**, click the drop-down box beside the URI to change it.

<div id="attachment_7315" style="max-width: 403px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2015/07/bitbucket-git.png"><img src="/wp-content/uploads/2015/07/bitbucket-git.png" alt="change the clone URI to SSH" width="393" height="123" class="size-full wp-image-7315" /></a>
  
  <p class="wp-caption-text">
    <strong>NOTE:</strong> IT&#8217;S A COLON &#8220;:&#8221; AFTER HOST NAME NOT A SLASH &#8220;/&#8221;!
  </p>
</div>

Once you&#8217;ve configured the SSH keys, you should always check-out using **SSH** URIs instead of **HTTPS**.

<pre>git clone git@github.com:povrazor/dairybox.git</pre>

Since you probably didn&#8217;t do that, here&#8217;s how we can change the remote:

<pre>git remote set-url origin git@github.com:povrazor/dairybox.git</pre>

Adjust the code above accordingly if you used Bitbucket instead of GitHub.

Source: <https://help.github.com/articles/changing-a-remote-s-url/>

## Step 4. Done&#8230;?

That&#8217;s actually it, assuming we don&#8217;t mind punching in our _pass-phrase_ every time.

We do mind though.

## Appendix A: ssh-agent (i.e. the temporary solution)

If we want to create a temporary shell that will remember the _pass-phrase_, use this command:

<pre>ssh-agent bash</pre>

Then to add the SSH key.

<pre>ssh-add ~/.ssh/id_rsa</pre>

Again, this is only temporary. When you invoke exit, the _pass-phrase_ will be forgotten.

Depending on the Linux configuration, doing **ssh-add** outside the `ssh-agent` shell may actually remember the pass-phrase permanently. But if you&#8217;re like me, running current Ubuntu&#8217;s, that wont cut it anymore.

Source: <http://askubuntu.com/a/362287/364657>

## Appendix B: SSH config (i.e. the permanent solution)

If it doesn&#8217;t already exist, create a file `~/.ssh/config`

Add these lines to the file.

<pre>Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa
Host bitbucket.org
    HostName bitbucket.org
    User git
    IdentityFile ~/.ssh/id_rsa
</pre>

Now **REBOOT**.

The first time you attempt to SSH to either website (i.e. any time you &#8220;`git push`&#8221; or &#8220;`git pull`&#8220;), you&#8217;ll be prompted for your **pass-phrase**. After entering it once, you shouldn&#8217;t have to enter it again until you reboot.

Source: <http://stackoverflow.com/a/4246809>, <http://nerderati.com/2011/03/17/simplify-your-life-with-an-ssh-config-file/>

## Appendix C: SSH config explained

The **Host** line in the SSH config is actually a unique name given to an SSH host. SSH will do a pattern match against what you have listed in your config as Hosts. The Host is not necessarily the host name, which we override using the HostName command (in fact, we&#8217;re also overriding the User name here).

If you were to add a section like this:

<pre>Host github-custom
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_rsa_customkey
</pre>

then you can specify a different SSH key to be used. In this case, I&#8217;m assuming I have an additional key pair named &#8220;`id_rsa_customkey`&#8221; and &#8220;`id_rsa_customkey.pub`&#8220;. I would have to add the Public Key to my GitHub account to use it.

To use the custom host, I would have to modify my URI.

<pre>git clone git@github-custom:povrazor/dairybox.git
</pre>

Notice that my URI is `github-custom` and not `github.com`.

The original SSH URIs work correctly because we specifically gave them the same **Host** as as the **HostName**. Trickery. 🙂 

## Appendix D: Permissions

In case your permissions get messed up, the default settings for Ubuntu 14.04 are:

<pre>sudo chmod 600 ~/.ssh/id_rsa
sudo chmod 644 ~/.ssh/id_rsa.pub
sudo chmod 644 ~/.ssh/known_hosts
sudo chmod 664 ~/.ssh/config
sudo chmod 700 ~/.ssh
</pre>

Details: <http://www.howtogeek.com/168119/fixing-warning-unprotected-private-key-file-on-linux/>