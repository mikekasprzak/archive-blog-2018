---
title: 'Notes: Migrating SVN repos to GIT'
layout: post
date: '2019-04-23 18:09:13'
---

Generally I don't have much to add. Be sure you install the GIT-SVN package first.

```bash
sudo apt install git-svn
```

I followed this guide up to step 3:

[https://gist.github.com/epicserve/1219858/9f30d5ffca7d6b6e4130c4b9b300b8167c868a5f](https://gist.github.com/epicserve/1219858/9f30d5ffca7d6b6e4130c4b9b300b8167c868a5f)

As well as this one: [https://git-scm.com/book/en/v2/Git-and-Other-Systems-Migrating-to-Git](https://git-scm.com/book/en/v2/Git-and-Other-Systems-Migrating-to-Git)

I ran in to issues initially because the SVN repository I was trying to port over **DIDN'T** follow the norm: it had no `trunk`, `tags`, or `branches` folders.

The solution was pretty straight forward once I realized this is why it wasn't working.

[https://git-scm.com/docs/git-svn](https://git-scm.com/docs/git-svn)

Using the `--trunk` command line argument to `git svn`. I passed it a blank string `--trunk ""`, and that's what I needed to find the trunk (which was the root folder).

Once migrated, it was a simple matter of adding a remote (`git remote add origin git@github.com:something/something`) and pushing. Boom!