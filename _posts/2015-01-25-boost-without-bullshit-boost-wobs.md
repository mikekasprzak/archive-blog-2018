---
id: 7189
title: Boost without Bullshit (boost-wobs)
date: 2015-01-25T16:55:23+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7189
permalink: /2015/01/25/boost-without-bullshit-boost-wobs/
categories:
  - Uncategorized
---
After some friends were ranting about Boost on twitter, I decided to do something about the single Boost dependency in my game code&#8230; but not the usual thing (rewriting it).

I&#8217;ve been using Boost&#8217;s **operators.hpp** for nearly a decade, because it actually makes writing operator code cleaner. Alas, my trimmed down subset of Boost was bringing nearly 60 source files with it, just for one file. That&#8217;s dumb. Thus, Boost without Bullshit was born:

<https://github.com/povrazor/boost-wobs>

The idea behind **boost-wobs** is that yes, there is some good stuff in Boost, but many developers refuse to use it because of the &#8220;BS&#8221; that comes with it. You can&#8217;t just add a single header to you project and get only the feature you want. It&#8217;s all or nothing.

I&#8217;ve now fixed operators.hpp to make it standalone with zero dependencies. Optionally, it also supports operations on std::iterator&#8217;s, which is now enabled using a special define. It used to be boost::iterator&#8217;s, but boost/iterator.hpp is depricated, and actually just std::iterator, so why not just use std::iterator instead?