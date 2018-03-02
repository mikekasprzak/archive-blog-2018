---
id: 7158
title: cJSON-LAX (Relaxed) on GitHub
date: 2015-01-12T05:06:55+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7158
permalink: /2015/01/12/cjson-lax-relaxed-on-github/
categories:
  - Uncategorized
---
Today I made some modifications to cJSON, a JSON parsing C library. And like a good boy, I&#8217;ve made them available on GitHub.

<https://github.com/povrazor/cjson-lax>

The changes are against the strict JSON spec, but instead are usability improvements:

  * Add C style /\* Block Comments \*/ and C++ style // Line Comments.
  * Added support for Tail Commas on the LAST LINES of Arrays and Objects

The benefits of comments in JSON should be obvious, but Tail Commas are quite the nicety. When manually editing JSON files, you sometimes re-order your lines with copy+paste. According to the spec, all members of an Objext or Array are followed by a comma, except the last one. Removing that comma, or making sure it exists on all lines after copy+pasting is an unnecessary pain. Now its optional.