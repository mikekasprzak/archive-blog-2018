---
id: 242
title: Tips for Game Archive Formats
date: 2007-03-16T21:59:56+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/2007/03/16/tips-for-game-archive-formats/
permalink: /2007/03/16/tips-for-game-archive-formats/
categories:
  - Stuffing
  - Technobabble
---
From a forum post, a set of bullet point advice on creating a custom archive format.

&#8211; &#8211; &#8211; &#8211;

&#8211; For terms: Archives are a directory/dictionary/list of filenames with offsets to chunks, and many data chunks (files). Compression comes later.
  
&#8211; Directories and subdirectories are just longer filenames. Unlimited file name length means unlimited directories.
  
&#8211; Padding the start of data chunks to 4 byte boundaries has performance advantages on many platforms when in RAM.
  
&#8211; For random access, compress chunks individually. Compressing everything at once tends to save more space, but you trade off random access.
  
&#8211; If there&#8217;s room in RAM, cache the archive. At the very least, caching the directory/dictionary can improve load times by not having to read it every time you request a file.
  
&#8211; If there&#8217;s more room in RAM, compress the archive as a whole, and cache the uncompressed copy after loading. But keep in mind, you need slightly more free memory than the sum of the uncompressed size and the compressed size.
  
&#8211; If running off a CD/DVD, seek time sucks. If you can&#8217;t cache everything important or commonly used in RAM, replicating your archive on different parts of the disk can improve seek time. A simple check of what sector the last file request was on disk, and a little math to pick the closest to where the laser sits.
  
&#8211; Seek time on memory cards/flash memory is significantly better than CDs/DVDs, but random access is still slower than continuous access.
  
&#8211; Prefer (if possible) ordering data on disk/archive in the same order it&#8217;s requested. Though that&#8217;s a bigger impact with CDs/DVDs, it&#8217;s something that can be considered when talking about your own archiving.
  
&#8211; Storing all files in the same directory in the same general part of the archive can achieve the previous point, so long as that data is of &#8220;Level 1&#8243; or &#8220;Level 2&#8243; type scope.
  
&#8211; Accessing distinctly common data first, then level specific data can save seek time if the common data is far away on disc.
  
&#8211; Storing or interweaving streamed data together can save seek time (music, video, static geometry).