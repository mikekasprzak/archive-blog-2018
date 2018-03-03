---
id: 9715
title: Chaotic Git Merging Notes
date: 2017-09-26T20:51:43+00:00
author: Mike K
layout: post
guid: /?p=9715
permalink: /2017/09/26/chaotic-git-merging-notes/
categories:
  - Uncategorized
---
I recently had a situation where a pair of devs were working on some code, and shared that code between them. I unfortunately wasn&#8217;t around to act as an intermediary and merge in to mainline for them. This resulted in 3 separate Push Requests with a number of conflicting changes. Add to that I started merging one set of changes, making my own changes, only to later realize there was all this overlap, so I&#8217;d effectively turned this in to a 4-way merge conflict. Oops!

To make this more manageable, I removed my conflict from the picture. To make my changes properly, I need to see the final result of the 3 Push Requests merged in to one. So I created a new Uber Push Request that combined (and fixed) the conflicts between the 3.

To get there, I had to learn more about GIT. 🙂

<!--more-->

## Branch Management

In our setup, every user has a personal **origin** repository, which makes reference to the **upstream** repository. Each of these are stored on **GitHub**.

Also, each user has a local instance of each branch they choose to checkout. To view the local list of branches, do the following.

<pre class="lang:default decode:true " >git branch

# * master
#   september-2017-uber-merge
#   sgstair-simulator_cache_fixes
</pre>

An asterisk will be beside the currently active branch.

When you commit a Push Request to GitHub, a new branch is created in the submitter&#8217;s repository. sS if you&#8217;re like me, you may not have realized how much branch manipulation was going on behind the scenes on GitHub.

To switch to a specific local branch.

<pre class="lang:default decode:true " >git checkout branch-name     # to checkout branch-name
git checkout master          # to return to the master branch
git checkout                 # actually does nothing
</pre>

The key thing to understand here is that the branches we see are what we have a copy of locally (on the current machine). The GitHub repos don&#8217;t necessarily have our changes (yet), just as we don&#8217;t necessarily have the changes from the GitHub repo.

To see what remotes you have available, do this:

<pre class="lang:default decode:true " >git remote

# origin
# upstream
</pre>

Unfortunately unlike `git branch`, this will not tell you which remote you are tracking. Instead you can do this to check that.

<pre class="lang:default decode:true " >git status

# On branch master
# Your branch is up-to-date with 'origin/master'.
# nothing to commit, working tree clean
</pre>

## Creating the Uber Merge

In the codebase, I have 2 active branches unrelated to these 3 merges I&#8217;m looking to combine (well not actually unrelated, but not important yet). My **master** branch has a bunch of code that&#8217;s not ready to merge, as does a branch named **private-user**. So where this would normally be straightforward, I can&#8217;t use **master** as a target for this.

The first step is to switch to the **upstream** repository.

<pre class="lang:default decode:true " >git checkout upstream/master

# Note: checking out 'upstream/master'.
#
# You are in 'detached HEAD' state. You can look around, make experimental
# changes and commit them, and you can discard any commits you make in this
# state without impacting any branches by performing another checkout.
# 
# If you want to create a new branch to retain commits you create, you may
# do so (now or later) by using -b with the checkout command again. Example:
#
#   git checkout -b &lt;new-branch-name&gt;
# 
# HEAD is now at 3502a28d... Merge pull request #1211 from sgstair/comment_avatar
</pre>

As the output above suggests, this command put us in to a detached HEAD state. Detached HEAD means GIT doesn&#8217;t know where to send the changes I make. It also offers a solution: create a branch.

<pre class="lang:default decode:true " >git checkout -b fun

# Switched to a new branch 'fun'
</pre>

There are actually a few ways to make branches. This one, using `checkout -b` creates a local branch from the active state (in this case the current known state of upstream/master), and immediately switches to it.

<pre class="lang:default decode:true " >git status

# On branch fun
# nothing to commit, working tree clean

git branch

# * fun
#   master
#   september-2017-uber-merge
#   sgstair-simulator_cache_fixes

git push

# fatal: The current branch fun has no upstream branch.
# To push the current branch and set the remote as upstream, use
#
#     git push --set-upstream origin fun
# </pre>

Notice that unlike earlier when we did a `git status`, no branch it is up-to-date with is mentioned. That said it&#8217;s a fully realized branch that currently only exist locally.

When you try to push it, it tells you how to add it to your GitHub: by setting the &#8220;upstream&#8221; of the branch. Using that exact `git push` command will make it appear on your GitHub account.

In the case of the Uber Merge, we do want this one to exist on GitHub. Later on though we&#8217;ll be creating branches that we don&#8217;t care to share with GitHub.

## Adding Pull Requests to the Uber Merge

At this point we need to hop over to GitHub, and find the specific Pull Requests that need merging.

At the bottom of the Conversation page you&#8217;ll find the big green **Merge Pull Request** button.

[<img src="/wp-content/uploads/2017/09/mergebut-640x132.png" alt="" width="640" height="132" class="aligncenter size-large wp-image-9725" srcset="/wp-content/uploads/2017/09/mergebut-640x132.png 640w, /wp-content/uploads/2017/09/mergebut-450x93.png 450w, /wp-content/uploads/2017/09/mergebut.png 790w" sizes="(max-width: 640px) 100vw, 640px" />](/wp-content/uploads/2017/09/mergebut.png)

Beside it though is what we care about, the view **Command Line Instructions** link. This unrolls a set of instructions.

[<img src="/wp-content/uploads/2017/09/mergebut2-640x409.png" alt="" width="640" height="409" class="aligncenter size-large wp-image-9726" srcset="/wp-content/uploads/2017/09/mergebut2-640x409.png 640w, /wp-content/uploads/2017/09/mergebut2-450x288.png 450w, /wp-content/uploads/2017/09/mergebut2.png 788w" sizes="(max-width: 640px) 100vw, 640px" />](/wp-content/uploads/2017/09/mergebut2.png)

If it was safe for us to merge our changes in to **master**, we could just do what it says with **one caveat** (in Step 2, I come back to this in a later section). However our target is not **master**, so we will be making some changes.

First things first, we need a local copy of the Pull Request. That&#8217;s what **Step 1** is describing.

<pre class="lang:default decode:true " >git checkout -b sgstair-notification_api fun</pre>

Earlier we checked-out **upstream/master** in to a local repository named **fun**. In practice this isn&#8217;t a good name, but it does illustrate the change that needs to be made to this code. If we did what GitHub recommended, the new branch we&#8217;re creating would start from our **local master**, which in my case is wrong (my local **master** has changes I&#8217;m not ready to commit). 

The key takeaway is that when you use `checkout -b`, you can include an argument after the branch name to specify a branch to start from. If none is specified (like our original example), then the current active branch is used.

This is potentially where things get a bit confusing. Sorry. Maybe this will clear things up.

<pre class="lang:default decode:true " >git checkout -b branch-of-current-branch
git checkout -b branch-of-other-branch fun          # where 'fun' is another branch
git checkout -b branch-of-upstream upstream/master  # WARNING!
</pre>

All of these are valid ways to create the branch, but the last case, where we explicitly reference **upstream/master** it can cause problems.

<pre class="lang:default decode:true " >git checkout branch-of-current-branch
git status

# On branch branch-of-current-branch
# nothing to commit, working tree clean

git checkout branch-of-other-branch
git status

# On branch branch-of-other-branch
# nothing to commit, working tree clean

git checkout branch-of-upstream

# On branch branch-of-upstream
# Your branch is up-to-date with 'upstream/master'.
# nothing to commit, working tree clean
</pre>

In the last case, an upstream branch is set if you specify the upstream name explicitly (i.e. the upstream is named **upstream**, instead of **origin**).

Changing the upstream of a branch is easy. You just need to be aware that it happened.

<pre class="lang:default decode:true " >git branch --unset-upstream                             # This is usually what you want
git branch -u origin/some-branch                        # But you could set it
git branch -u origin/some-branch branch-of-upstream     # if it's not the active branch</pre>

So finally, here&#8217;s how to concisely checkout a Pull Request WITHOUT using your local master.

<pre class="lang:default decode:true " >git checkout -b sgstair-notification_api upstream/master
git branch --unset-upstream
git pull https://github.com/sgstair/ludumdare.git notification_api
</pre>

Noting that: Line 1 is now **upstream/master** (not **master**), and line 2 is new.

Do this for **every** patch you want to merge (we need a local copy).

## Merging Pull Requests in to the Uber Merge

First make sure you have your destination branch (i.e. **september-2017-uber-merge**).

Next, make sure you have local copies of every branch you want to merge in.

Start by switching to the destination branch.

<pre class="lang:default decode:true " >git checkout september-2017-uber-merge 
git branch

#   local-minimum-notification_ui
#   master
# * september-2017-uber-merge
#   sgstair-notification_api
#   sgstair-simulator_cache_fixes
</pre>

Now we merge them, one Pull Request at a time.

<pre class="lang:default decode:true " >git merge sgstair-simulator_cache_fixes
git push

# no problem, first one is always clean

git merge sgstair-notification_api

# Auto-merging sandbox/simulate_ld_event
# CONFLICT (content): Merge conflict in sandbox/simulate_ld_event
# Auto-merging public-api/vx/node.php
# CONFLICT (content): Merge conflict in public-api/vx/node.php
# Auto-merging .gitignore
# CONFLICT (content): Merge conflict in .gitignore
# Automatic merge failed; fix conflicts and then commit the result.

git status

# On branch september-2017-uber-merge
# Your branch is up-to-date with 'origin/september-2017-uber-merge'.
# You have unmerged paths.
#   (fix conflicts and run "git commit")
#   (use "git merge --abort" to abort the merge)
# 
# Changes to be committed:
# 
# 	modified:   public-api/vx/note.php
# 	new file:   public-api/vx/notification.php
# 	modified:   src/shrub/src/constants.php
# 	modified:   src/shrub/src/node/node_core.php
# 	modified:   src/shrub/src/note/note_core.php
# 	new file:   src/shrub/src/notification/constants.php
# 	new file:   src/shrub/src/notification/notification.php
# 	new file:   src/shrub/src/notification/notification_core.php
# 	new file:   src/shrub/src/notification/table_create.php
#  	modified:   src/shrub/src/user/table_create.php
# 	modified:   src/shrub/src/user/user.php
# 	new file:   src/shrub/src/user/user_notification.php
# 
# Unmerged paths:
#   (use "git add &lt;file>..." to mark resolution)
# 
# 	both modified:   .gitignore
# 	both modified:   public-api/vx/node.php
# 	both modified:   sandbox/simulate_ld_event
# 
</pre>

If you know that a file should be preferred over another, you can use this special form of `checkout`.

<pre class="lang:default decode:true " >git checkout --ours .gitignore                      # to keep our version
git checkout --theirs sandbox/simulate_ld_event     # to use their version

git diff                                            # You can check if it worked with a diff

# diff --cc sandbox/simulate_ld_event
# index 1dea9916,ece62277..00000000
# --- a/sandbox/simulate_ld_event
# +++ b/sandbox/simulate_ld_event

# Result is simple (NOTE: only the sandbox/simulate_ld_event changes are shown)

# Finally, don't forget to add the files after merging them!!
git add .gitignore
git add sandbox/simulate_ld_event
</pre>

However, not all files can be outright merged as is. A useful tool to have installed in MELD.

http://meldmerge.org/

On Ubuntu it&#8217;s a simple matter of:

<pre class="lang:default decode:true " >sudo apt install meld</pre>

GIT will be automatically configured to use meld with `mergetool`.

<pre class="lang:default decode:true " >git mergetool        # run the default merge tool for all conflicts</pre>

If you make a mistake, you can always close MELD, and tell GIT that the merge was **not** successful, and try again after.

And that it. Test it, commit the changes, and finally push it.

<pre class="lang:default decode:true " >git commit -m "merged 'sgstair-notification_api'"
git push

git status

# On branch september-2017-uber-merge
# Your branch is up-to-date with 'origin/september-2017-uber-merge'.
# Untracked files:
#   (use "git add &lt;file>..." to include in what will be committed)
# 
# 	.gitignore.orig
# 	public-api/vx/node.php.orig
# 
# nothing added to commit but untracked files present (use "git add" to track)
</pre>

You may notice some `.orig` files scattered about now. You can clean them up by either deleting them by hand, or using `clean`.

<pre class="lang:default decode:true " >git clean -fd</pre>

Repeat until you&#8217;ve merged everything.

And that&#8217;s it! **We&#8217;re done!**

## The Step 2 Caveat: Squashing

I alluded to this earlier, but the default instructions GitHub gives you for merging by hand isn&#8217;t necessarily the best way to do it.

To merge, GitHub tells you this:

<pre class="lang:default decode:true " >git merge --no-ff local-minimum-notification_ui</pre>

This is fine, but you should know the `--no-ff` command actually performs a squash. What squashing means is all changes are merged in to a single commit, rather than maintaining the history of commits. 

For very large projects this might be ideal, as all the intermediary steps taken to the final result aren&#8217;t necessary. But in our case we&#8217;re a small-large project, and at the moment anyway the full history isn&#8217;t an issue.

GitHub&#8217;s default is what&#8217;s called a Merge Commit, but they actually support two other types: Squash and Rebase. There are settings for controlling which options are available to you, but at this time Merge Commit is adequate for us.

## Cleaning-up Branches

If you experimented a bit, or generally worked a long time in a folder, you&#8217;re going to have a bunch of stray branches that are no longer needed. To delete a branch do this:

<pre class="lang:default decode:true " >git branch -d branch-name

# Deleted branch branch-name (was 3502a28d).
</pre>

If there are issues with the branch (i.e. uncommitted data), you can forcefully delete it like so:

<pre class="lang:default decode:true " >git branch -D branch-name

# Deleted branch branch-name (was 3502a28d).
</pre>

TODO: Add more notes here about switching branch problems with changes.