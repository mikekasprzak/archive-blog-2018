---
id: 5241
title: Practical C++11 Support for Game Developers
date: 2012-08-25T18:47:50+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5241
permalink: /2012/08/25/practical-c11-support-for-game-developers/
categories:
  - Technobabble
---
So it&#8217;s Ludum Dare 24 weekend (Aug 24th), and I&#8217;m finally catching up on some work I had to put off as I &#8230; ahem &#8230; [attended to my duties](http://www.ludumdare.com). Now that the event is going strong, it&#8217;s reading time!

The main thing I need to do is some Windows 8 research. I installed the Windows 8 RTM (release) Trial on a new machine earlier this week, as well as the Visual Studio 2012 Express. I generated a basic Direct 3D app to discover, &#8220;oh crap, there&#8217;s some C++11 stuff going on here now&#8221; (EDIT: Yes it was some C++11, but specifically [WinRT](http://en.wikipedia.org/wiki/WinRT) and [C++/CX](http://en.wikipedia.org/wiki/C%2B%2B/CX) [[video](http://channel9.msdn.com/Events/BUILD/BUILD2011/TOOL-845T)]). So I decided to look more closely at what C++11 features can be practically used in a cross platform sense in apps written today.

References: [C++0x](http://wiki.apache.org/stdcxx/C++0xCompilerSupport) on Apache Wiki, [C++11 FAQ](http://www.stroustrup.com/C++11FAQ.html), [MSDN Blog C++11 Support](http://blogs.msdn.com/b/vcblog/archive/2011/09/12/10209291.aspx) ([2](http://blogs.msdn.com/b/vcblog/archive/2012/08/14/10339695.aspx)), [C++ Rocks](http://www.cpprocks.com/a-comparison-of-c11-language-support-in-vs2012-g-4-7-and-clang-3-1/) ([2](http://www.cpprocks.com/c11-a-visual-summary-of-changes/))

For a good reference of new things added in C++11, check out [Wikipedia](http://en.wikipedia.org/wiki/C%2B%2B11).

## The 3 Compilers: GCC, Clang, and MSVC

First a quick summary of the [data found here](http://wiki.apache.org/stdcxx/C++0xCompilerSupport).

Clang has extremely quickly matured in to the most C++11 compliant compiler available. As of May of this year, Clang 3.1 was released, and supports most C++11 features. If I was to place a bet, my bet would be that Clang reaches 100% compliance before the other two.

GCC 4.7 is a very complaint C++11 compiler. GCC 4.4 was one of the first GCC versions to add a significant number of C++11 features. It&#8217;s been around since April 2009, with the latest version 4.4.7 released in March of this year. Because of its age, it&#8217;s fairly common now, and at the point where we can expect nearly all modern devices to use at least this.

Visual Studio 2012 was released a week ago (Mid August), though it&#8217;s been in public beta for a while longer. With the impending Windows 8 Launch in October, this one will be getting some heavy usage over the next few years. Visual Studio 2010 added several C++11 features, but the [list has grown since](http://blogs.msdn.com/b/vcblog/archive/2011/09/12/10209291.aspx).

## Target Platforms

A list of current targets and platforms that have C++ compilers, and what they are based on.

Updated: **Nov 4th, 2012**

  * **Android** &#8211; NDK 8b (ARM, x86, MIPS) &#8211; **GCC 4.6**
  * **iOS 5** &#8211; Xcode 4.4.1 (ARM) &#8211; **Clang 3.1** <font color="#fF00FF">??</font>
  * **Mac OS X 10.8** &#8211; Xcode 4.4.1 (x86, x64) &#8211; **Clang 3.1** <font color="#fF00FF">??</font>
  * **BlackBerry 10** (and PlayBook) &#8211; Native SDK 2.1 (ARM) &#8211; **GCC 4.4.2** <font color="#00FFFF">*</font>
  * **Marmalade 6** &#8211; iOS+Android+BB10 (ARM, x86, MIPS) &#8211; **GCC 4.4.1** <font color="#00FFFF">*</font>
  * **Chrome** &#8211; **Native Client/Pepper** 21 (x86, x64) &#8211; **GCC 4.4.3** <font color="#00FFFF">*</font>
  * **HTML5** &#8211; **Emscripten** (JS) &#8211; **Clang 3.1**
  * **Ubuntu 12.04 LTS** &#8211; (x86, x64, ARM) &#8211; **GCC 4.6.3**
  * **Ubuntu 12.10** &#8211; (x86, x64, ARM) &#8211; **GCC 4.7.2**
  * **Windows** &#8211; **MinGW** (x86) &#8211; **GCC 4.7**
  * **Windows XP, Vista, 7** &#8211; Visual Studio 2010 Express (x86, x64) &#8211; **VC<u>10</u>**
  * **Windows 7 and 8** &#8211; Visual Studio 2012 Pro (x86, x64, ARM) &#8211; **VC11**
  * **Windows 8** &#8211; Visual Studio 2012 Express (x86, x64, ARM) &#8211; **VC11**
  * **Windows Phone 8** &#8211; Visual Studio 2012 Express (ARM) &#8211; **VC11**
  * **FreeBSD 9** &#8211; **<font color="red">GCC 4.2.1</font>** <font color="#00FFFF">*</font>
  * **Adobe Flash** &#8211; **Flascc** &#8211; **<font color="red">GCC 4.2.1</font>** <font color="#00FFFF">*</font>

(<font color="#fF00FF">??</font> &#8211; Unconfirmed, <font color="#00FFFF">*</font> &#8211; Legacy GCC)

All that said, if what you care about are Open and App platforms, (aside from FreeBSD and Flascc) you can target every platform today with some C++11 features!

### What I can I use?

The safest feature choices seem to be a cross section of things that are available in **GCC 4.4** and **VC10/VC11**. Be sure to enable C++11 or C++0x mode if you&#8217;re [using GCC](http://gcc.gnu.org/projects/cxx0x.html) or Clang (Google it yourself).

### Features Available (GCC 4.4+, Clang, VC10+)

  * Atomic Operations &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2427.html) (VC11)
  * **auto** &#8211; Spec [0.9](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n1984.pdf), [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2546.htm), [MSDN](http://msdn.microsoft.com/en-us/library/dd293667.aspx)
  * **decltype** &#8211; Spec [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2343.pdf) (Final is 1.1), [MSDN](http://msdn.microsoft.com/en-us/library/dd537655.aspx)
  * extern template &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n1987.htm)
  * New function declaration syntax for deduced return types &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2541.htm)
  * Right Angle Brackets &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2005/n1757.html)
  * R-Value References &#8211; Spec [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n2118.html) (Final is 4.0, so it may be unwise)
  * static_assert &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2004/n1720.html)
  * Strongly-typed enums &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2347.pdf) (VC11)
  * Thread-Local Storage &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2659.html) (partial support with __thread keyword)
  * Built-in Type Traits &#8211; [Spec](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2005/n1836.pdf)

Data and Links above are sourced from [here](http://wiki.apache.org/stdcxx/C++0xCompilerSupport) and [here](http://blogs.msdn.com/b/vcblog/archive/2011/09/12/10209291.aspx).

### But wait, I don&#8217;t need those weird ones

If Marmalade, Chrome&#8217;s Native Client, BlackBerry 10, FreeBSD and Flascc don&#8217;t matter to you, then you&#8217;re in C++11 town. You can use **all features** supported by Visual Studio 2012 **except**:

  * Extended friend declarations
  * override and final

You can find the complete [Visual Studio 2012 supported list here](http://blogs.msdn.com/b/vcblog/archive/2011/09/12/10209291.aspx).

## Summary

Aside from FreeBSD and Flascc, amazingly, it&#8217;s actually possible today to use some C++11 features in your code, and that code will work in compilers from the other 2 vendors. And depending on your needs, you can today use almost everything Visual Studio 2012 supports. Wider C++11 platform support is just a GCC upgrade away&#8230; and then we wait for Microsoft&#8217;s next compiler upgrade cycle.