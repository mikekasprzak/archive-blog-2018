---
id: 7157
title: When and why use UTF-8 and UTF-16? Stringy thoughts.
date: 2015-01-12T05:50:15+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7157
permalink: /2015/01/12/when-and-why-use-utf-8-and-utf-16/
categories:
  - Uncategorized
---
This was a bit of a shower thought, but until this I didn&#8217;t have a good reason to choose UTF-16 for anything.

**UTF-8** makes a lot of sense. It has all the benefits of ASCII text formatting, and the ability to support additional characters above and beyond the ASCII 127 or 254. It&#8217;s very similar to ASCII, you just have to be careful with your null and extended codes. No arguments here.

The main problem with UTF-8 is that you can&#8217;t just iterate as you do with ASCII (ch++). You need to check for special characters every step (just in case). On the plus (I think) all special characters are above a certain byte value, so the initial test is cheap, but it&#8217;s the variations that are a little costly.

**UTF-16** makes a lot of sense for the actual storage format of strings in RAM. Most characters are a single 16-bit Glyph (any product I plan on working anyway), but there is support for 32-bit two-character Glyphs as well. **UCS-2** is the name of the legacy wide-character pre-UTF encoding.

With UTF-16, if you prepare for it, you can get away with simple iterations (short* ch++). Not to mention, it&#8217;s a 2-byte read, which should effectively be faster/lest wasteful than multiple 1-byte reads. It would be wise to just discard/replace characters above the 16-bit range (no Emoji). China may have a problem ([GB 18030](http://en.m.wikipedia.org/wiki/GB_18030)), but its a controlled situation, and most glyphs will be on the [Basic Multilingual Page](http://en.m.wikipedia.org/wiki/Basic_Multilingual_Plane#Basic_Multilingual_Plane) anyway. Plus there&#8217;s a whole 6k of Private Use glyphs if needed anyway (item iconography like swords, shields, potions, etc). That&#8217;s kind-of a nice feature.

**ASCII** still makes a lot of sense for keys, script code, and file names. Since UTF-8 is backwards compatible with 7-bit ASCII, if we impose the restriction that all keys will be 7-bit ASCII, then our string are an optimal/smaller size. Also, UTF-16, though each character is wider, as long as it&#8217;s the correct endianness, it should also be 7-bit ASCII compatible. With the exception of strings and comments, it&#8217;s reasonable to impose a 7-bit ASCII restriction. After all, this is still a UTF-8 compatible file.

**16bit String Lengths** are a reasonable limitation. 0 to 65535 will cover 99.99% of string lengths. The only thing that will push it over is if you happen to have a novel worth of text, or a large body of text that&#8217;s heavily tagged (HTML/XML). So it&#8217;s bad for a web browser or text file, but fine for anything else. In an optimal use case, this means you&#8217;re using 3 extra bytes per UTF-8 string (16bit size, 8 bit terminator) or 4 extra bytes per UTF-16 string (16bit size, 16bit terminator).

This aligns well if you NEVER plan to take advantage of 32bit or 64bit reads. If you do however, then having a larger string length means the string itself will be padded to your preferred boundary. Use platform&#8217;s size_t for optimal usage.

Most standard zero-checking string functions are better fed a pointer to the data directly. This lets them work exactly like normal C strings, looping until they hit a zero terminator. But a smarter string function may want to know size faster (i.e. if equal, confirm sizes first).

A pre-padded string length can be made mostly compatible with a pre-padded datablock type. The string version will be one character longer, but any functions that deal with copies will be (mostly) the same (one extra action, pad with a 0 at the end).

**Line Chunked**, in addition to whole strings, is a useful format. A text editor would want a fast way to go from line 200 to 201. Always iterating until you find a newline is slow, so it&#8217;s best to do this initially. If the line sizes don&#8217;t need to change, you can butcher the source string by replacing CR and LF with 0, and having a pointer to each line start. If you need to change lines, and those lines will definitely grow larger than some maximum, then each line should be separately allocated, and be capable of re-allocating.

Unfortunately this doesn&#8217;t help for word wrap. Word wrapping is completely dependent on the size of the box the text is being fit in to. Ideally, you probably want some sort of array of link lists containing wrap points. Each index should know how many wraps it has, meaning you&#8217;ll need to track both what line and what wrap you are on. Process the text the same way as **Line Chunked**, but you wrap at wraps. 

**Text Interchange** formats like JSON can be padded with spaces/control characters. A padded JSON file wont be as tightly packed as a whitespace removed one, but the fastest way to read/write string data is when it&#8217;s 32-bit aligned. On many ARM chips, it&#8217;s actually a requirement that you do aligned 32-bit reads. On Intel chips it wastes less cycles.

Or if all you care about is **EFIGS** (English, French, Italian, German, Spanish), then just **ASCII** and be done with it. There should be some rarely/never used characters under the Extended ASCII set, which gives room for your custom stuff.

Long story short:

Use **UTF-8** as an external storage format. Use **UTF-16** as an in-memory storage format. Use **ASCII** for keys, script code, file names, etc. Or be lazy, do **ASCII** for **EFIGS**.