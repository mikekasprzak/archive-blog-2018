---
id: 7008
title: Checking Symbols GCC and Clang
date: 2014-06-20T14:00:40+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7008
permalink: /2014/06/20/checking-symbols-gcc-and-clang/
categories:
  - Linux
  - Technobabble
---
Just a short one.

Reference: <http://stackoverflow.com/questions/4548702/whats-the-equivalent-of-cpp-dd-for-clang>

<pre>clang -dM -E - &lt; /dev/null
clang++ -dM -E - &lt; /dev/null
gcc -dM -E - &lt; /dev/null
g++ -dM -E - &lt; /dev/null</pre>

Gives you list of all symbols defined by compilers. It's interesting, that you have to feed it something (anything blank) to get this output though. /dev/null, or pipe in a blank echo (echo "" | gcc -dM -E -), etc.

Works with NaCl (pnacl-clang), Emscripten (emcc), and pretty much every GCC toolchain known to man.