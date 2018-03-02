---
id: 261
title: An audio workflow with SVN (Rant)
date: 2006-08-22T04:04:49+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2006/08/22/an-audio-workflow-with-svn-rant/
permalink: /2006/08/22/an-audio-workflow-with-svn-rant/
categories:
  - Sound
  - Stuffing
  - Technobabble
---
I&#8217;ve got workflow on the brain, and a discussion about backups on [IG](http://forums.indiegamer.com/showthread.php?t=8155) got the brain juices flowing. The post is of similar quality and length to what I&#8217;d normally constitute a &#8220;blog post&#8221;, so I&#8217;m dropping it here so I don&#8217;t forget. It&#8217;s certainly not a surefire answer to anything, just a stroll through me solving a problem.

The set up: [SVN](http://tortoisesvn.tigris.org), a great tool for backups, versioning, and synchronization, can and should be used in all aspects of development. But what about audio?

&#8211;

There&#8217;s a few sides to audio. First, unless you&#8217;re still doing music with non VST driven trackers, you use several gigs for your sample libraries. Those you can (annoyingly) reloaded from their DVDs just fine. Your compositions are usually nice and small, or several megs if they embed instances of samples/loops in the file. And at this point, you&#8217;re perfectly capable for electronic music production.

A Fruity Loops, Live, Renoise, Buzz track is reasonably versionable here. You make some changes, and you can commit it. But an oddity of music here, you may decide you liked a track a few versions ago (crappy tweaks to filters, removed tracks, etc&#8230;), but you&#8217;ve introduced a bit of an annoyance having to check out older versions to go back to where you were. So because of that, it&#8217;s almost worth keeping numbered additional revisions (i.e. MyCoolSong02.rns) whenever you do something neat, or branch off in a different direction. You could then append sub-revisions via more numbers if you find an old version a worthwhile derivative (i.e. MyCoolSong02-01.rns). Then just be sure to note somewhere what file is &#8220;Gravy Train &#8211; Trainwreck Mix&#8221; once it&#8217;s final . The reason I don&#8217;t suggest using SVN&#8217;s branching facilities, is it adds complexity to the work flow. You&#8217;d have to, outside your program, create a new working folder, and the branch. Branching features are designed to facilitate the idea that you want to try something outside the main tree, and potentially could want to merge it back. Dealing with binary files, you can&#8217;t merge, and will never return to the original branch, so your hierarchy becomes a tree that never converges.

So that works great for small sample/virtual instrument driven music. You commit your songs and variants, and let SVN handle versioning of the little changes that don&#8217;t take the track in to distinctly different directions. And you can do it nicely with a several gig SVN repository. Just be sure to keep your sample library out of the repository.

However, once you introduce recording (guitar, vocals, voice overs), or per track mixing/mastering in external software, it explodes. A raw mere 20 minute session as a 32bit float samples at 96khz is nearly 500 megs. To not use gigs of space, you&#8217;ll have to compress your tracks. It&#8217;s a shame more software doesn&#8217;t support FLAC. Fortunately (at least for me), Adobe Audition 2.0 can save high/variable kbps 96khz OGG&#8217;s (though I forgot to check if it keeps the 32bit sample space), and I suspect Audacity does as well. So that&#8217;s one option. However, we&#8217;re still talking tens to a hundred of megs per track per session. SVN&#8217;s is out of the question here, though despite that you can&#8217;t merge binary, you won&#8217;t need to. The whole note taking aspect of SVN per change is a huge benefit of it&#8217;s process, but you can probably get by with voice recordings (notes) or a text file, if there&#8217;s something you&#8217;d like to remember.

The one thing Audio has going for it, unlike code, is it&#8217;s short time frame. And short of samples, there isn&#8217;t much re-use, and when there is, it&#8217;s the final product. The steps you took to get to the final track, while important and relevant, don&#8217;t do you much good anymore. When you pass a track on for remixing, you pass a final. The only exceptions being out-takes, which have nostalgia and entertainment value, and for re-mastering, though it&#8217;s unlikely you&#8217;d keep a bad quality final.

Alright. Because it&#8217;s more &#8220;nice&#8221; than necessary to have access to older tracks, a setup of stability (Mirrored RAID), hard copies for finals (DVD backup, with as much source/unused takes as you can cram) and a recent work archive (finals for the last few, and mix downs for everything else) should work nicely. A server doesn&#8217;t do you much good here, unless you want to offload the archive. An SVN archive of finals &#8220;could work&#8221;, but the point of SVN is being able to recover any version of something.

So it seems Audio is an example of a situation where you could overload your server/repository after several projects. A means of gutting a repository entirely of all traces of something \*could\* make it work, but that&#8217;s outside the scope of SVN currently (I suspect). Gutting for removal, or gutting as in exporting a repository subset of the original, for explicit backup.

&#8230;

Hooray!