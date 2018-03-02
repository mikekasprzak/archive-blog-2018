---
id: 5623
title: C++11 Compiler Support Wishlist
date: 2012-11-12T11:41:17+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5623
permalink: /2012/11/12/c11-compiler-support-wishlist/
categories:
  - Technobabble
---
A few months back I did this little investigation in to [C++11 support across compilers](/2012/08/25/practical-c11-support-for-game-developers/). The goal here was to figure out what C++11 features I could safely use today. I also ended up creating a useful list of compiler versions sorted by platform. I will continue, at least for the near term, updating this list as I see changes.

This post is a follow up to that. I&#8217;m more familiar now with the actual use of many of these &#8216;nextgen&#8217; features, so this post is a brief on certain features I really want to use, and why I can or can not use them.

<!--more-->So to start off, the Apache C++11 support list:

<http://wiki.apache.org/stdcxx/C++0xCompilerSupport>

I realize it&#8217;s not the most comprehensive list, but it is one of the widest spectrum lists out there. There are compilers listed here that almost nobody ever talks about. That said, I only really care about the big 3: GCC, MSVC, and Clang. Still, it&#8217;s nice to see how everyone else is doing.

Lets begin.

## Bottlenecks

My main bottlenecks for features I can and can&#8217;t use are support by certain compilers.

### MSVC 11

Several features just aren&#8217;t implement yet. However, Microsoft has &#8216;made good&#8217; on their promise to release updates to Visual C++ that include more C++11 features. The very first update (referred to as the Nov 2012 update) can be found over here:

<http://blogs.msdn.com/b/vcblog/archive/2012/11/02/visual-c-c-11-and-the-future-of-c.aspx>

So in time, Visual C++ looks like it may solve its own issues.

### GCC 4.4

GCC&#8217;s bottleneck is far trickier. GCC 4.8 is expected to be released soon, and it supports most C++11 features. That said, many toolchains for platforms are stuck with GCC version 4.4. There is no rush by certain vendors to upgrade, which is a shame, since GCC 4.7 is quite stable and C++11 filled. An upgrade would make a lot of people (i.e. me) happy. 🙂

### Clang

Okay, to be honest, Clang isn&#8217;t a bottleneck at all. The only major compiler to use it is Xcode, but it is also used by Emscripten which is a neat tool. Not to mention, Clang has one of the best C++11 supports across all compilers. GCC 4.8 gives Clang a good run for its money, but Clang 3.2 should prove to be equally impressive.

Oh and really, I don&#8217;t really expect to use Clang again in the near future. I&#8217;m quite a fan of the &#8220;no brain required&#8221; side of Marmalade. I use it for my Android port of Smiles, and plan to use it to basically save me from ever having to use Xcode and ObjC ever again. The yearly fee is reasonable in my books.

Now if only Marmalade would upgrade their GCC version. 😀

## &#8216;auto&#8217; keyword

The &#8216;auto&#8217; keyword lets C++ figure out the type automatically. Given that C++ class nesting can create some really dense names for defining a type, this is a very welcome addition.

Spec 0.9: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n1984.pdf>
  
Spec 1.0: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2546.htm>

**Support:** MSVC 10 &#8211; <u>**0.9**</u>, GCC 4.4 &#8211; 1.0, Clang &#8211; 1.0

Notably, Spec 1.0 is mostly a list of removed/reworded aspects of Spec 0.9, and a lot of it is nitty gritty (support/lack of support for register types). I do wish it was a bit more clear what is supported across both, but a spec is about defining a standard and not about describing a vendors compromise.

**Why I \*AM\* using it:**

Well it is [supported](/2012/08/25/practical-c11-support-for-game-developers/) almost everywhere I care about, the only significant holdout being Adobe&#8217;s recently released Flascc compiler. As much as I like being able to port my code everywhere, I can wait for Flash support. I have waited all these years already.

## Lambda Functions

This is a syntax sugar that lets you define anonymous little inline functions. It can be thought of the ?: operator taken to the extreme.

<http://en.wikipedia.org/wiki/Anonymous_function#C.2B.2B>

One thing I want to do more is improve the locality of things. I&#8217;ve been limiting variables to the scope in which they are actually needed for a very long time. If a function is used just once, it begs the question whether it even needs to be defined at some class level or global scope. The common example is sorting operators, how you make the decision between 2 to swap them around or not, and that does happen. I suppose a best case would be to define the &#8216;<=>&#8216; operator family of functions, but for simple oneshot blocks of code (or multiple oneshots with different conditions), being able to inline the specific one would improve the locality of the code. You know what&#8217;s happening, because the code you want to see is right in front of your face.

Spec 0.9: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2550.pdf>
  
Spec 1.0: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2658.pdf>
  
Spec 1.1: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2009/n2927.pdf>

**Support:** MSVC 11 &#8211; 1.1, GCC <u>**4.5**</u> &#8211; 1.1, Clang 3.1 &#8211; 1.1

Argh! So close!

**Why I am \*NOT\* using it:**

Yarg, because of GCC 4.4. The 4.4 list includes a few platforms, but the main one to me is Marmalade. Every time I realize Marm is holding me back, it makes me want to investigate outright switching the GCC version bundled with it. For example a precompiled GCC 4.7.2 ARM compiler suite can be found over here:

<http://www.yagarto.de/>

And historically, Code Sorcery was a common place to grab precompiled GCC&#8217;s. Unfortunately, they&#8217;re behind a user login wall now. Bleh.

<http://www.mentor.com/embedded-software/sourcery-tools/sourcery-codebench/editions/lite-edition/>

So meh.

**An alternative? Nope!**

During my time researching better ways to handle pointers to member functions, I stumbled across 2 things: Local scoped classed and Functors. The following is an unusual hack that seemed to work:

<pre class="lang:c++ decode:true " >int main( int argc, char* argv[] ) {
	struct MyFunctor {
		void operator()( ) {
			printf( "My This Addr Yo: 0x%x\n", this );
		}
	};
	
	MyFunctor Me;
	Me();

	return 0;
}</pre>

Unfortunately though, as it turns out, this is not supported in GCC 4.4. I&#8217;m not particularly sure where this support was added, but my best guess is alongside Lambda functions in GCC 4.5 (since it is lambda like).

Ha, this section was originally going to be about this as a useful compromise, but I guess it doesn&#8217;t actually work on 4.4. Ah well. 😀

## C++ threads

Well I did this post some time ago.

</2012/09/21/cross-platform-c-threading-today/>

But after doing a bit of digging, ironically I&#8217;m starting to think C++ threads may actually be available everywhere. Thread Local Storage is partially supported (no idea what&#8217;s missing) across all the compilers.

I dunno what I&#8217;m doing. Ha!

But anyway, there are still probably platform incompatibilities regarding threading. In a quick test, I saw TinyThread++ fail on QNX GCC, so some expected headers may be missing.

## nullptr

I use null pointers quite often, arguably too much even. The nullptr type was added to better formalize the usage of null pointers, and since I use them so much, I should be using it.

<http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2431.pdf>

Unfortunately, &#8216;nullptr&#8217; is only available as of GCC 4.6&#8230; yes 4.6. Clang and MSVC have supported it for a while.

## R-Value References and std::move

This is a big improvement. Typically, classes always create and destroy temporary copies of classes. However, there are many many cases where a create->copy->destroy cycle is extremely wasteful. What would be better is if we could simply move the data to the copy, and let the husk of the original just die off. This right here is the missing link to maximizing a classes potential performance.

This feature has some of the most revisions of all the C++11 features, and has some sort of compatibility across all compilers.

**GCC:** 4.3 &#8211; <u>**1.0**</u>, 4.5 &#8211; 2.1, 4.6 &#8211; 3.0
  
**MSVC:** 11 &#8211; 2.1
  
**Clang:** Yes (ha)

So the potential problem child here is GCC again, with serious 2.1 support only available as of 4.5. That said however, 1.0 support is available as of GCC 4.3, so some research should be done to see how similar spec 1.0 is to it&#8217;s revisions. Seeing how the revision numbers are outright major versions (1.0, 2.1, 3.0), it is somewhat worry-some.

Spec 1.0: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2006/n2118.html>
  
Spec 2.0: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2009/n2844.html>
  
Spec 2.1: <http://www.open-std.org/jtc1/sc22/wg21/docs/cwg_defects.html#1138>
  
Spec 3.0: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2010/n3053.html>

So when I find time, I need to look in to this.

**Why I&#8217;m \*NOT\* using them:**

One reason: I haven&#8217;t figured out what I can use yet. Haha. 😀

## Raw and Unicode string literals

[Raw strings](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2146.html) are strings without the \n family of codes (R&#8221;Hey this is a backslash n: \n&#8221;). They also support a new syntax for inlining multiline strings as clean raw data (R&#8221;[\ &#8230; ]&#8221;). [Unicode strings](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2009.html) mean I can do u8&#8243;Blah blah&#8221; for a UTF-8 encoded string.

Spec 1.0: <http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2442.htm>

Unfortunately MSVC lacks Unicode strings, and GCC added raw strings in GCC 4.5 (and MSVC in Nov 2012). So these are &#8220;almost&#8221; usable.

## More I \*CAN\* use

These are notable features that fall within my minimum compiler support. However, they are things that I haven&#8217;t looked at closely enough to know how or what they do exactly.

  * Atomic Operations &#8211; [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2427.html)
  * decltype &#8211; [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2343.pdf), [1.1](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2011/n3276.pdf)
  * Initializer List (improvements) &#8211; (as of MSVC Nov 2012) [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2672.htm)
  * Variadic templates &#8211; (as of MSVC Nov 2012) [0.9](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2007/n2242.pdf), [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2008/n2555.pdf)
  * Static Assert (well I need to use regular assert more too) &#8211; [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2004/n1720.html)
  * Builtin type traits (may only be meaningful for virtuals, I dunno) &#8211; [1.0](http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2005/n1836.pdf)

And that&#8217;s all for now.