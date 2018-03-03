---
id: 1662
title: (Annoying) Differences between Visual Studio and GCC
date: 2009-11-15T19:38:18+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=1662
permalink: /2009/11/15/annoying-differences-between-visual-studio-and-gcc/
categories:
  - Smiles
  - Technobabble
---
Or in other words, awesome C an C++ language features you&#8217;ll learn to love in GCC, that&#8217;ll break your heart if you ever have to use Visual Studio. 😉

This is a list I collected whilst getting my Smiles PC code to compile with Visual Studio 2008. Most have no equivalent in Visual Studio, but one simply has a slightly different syntax (compatible too).

As before, long and technical. Hit the link if you&#8217;re up for the challenge. You&#8217;ve been warned. 😀

<!--more-->

## Determining if it&#8217;s Visual Studio

Generally speaking, you can check for the symbol **\_MSC\_VER**. If it exists it&#8217;s Visual Studio, otherwise it&#8217;s _probably_ GCC. From what I&#8217;ve seen, all the non GCC&#8217;s are pretty good at identifying themselves (\_\_MWERKS\_\_, _\_ARMCC\_VERSION, etc).

## Variadic Macros

In GCC, you can wrap printf and similar functions as follows.

<pre>#define Log( args... ) \
        printf( args )</pre>

Visual Studio 2008 has a slightly different syntax. To Visual Studio&#8217;s credit, this is part of the C99 standard.

<pre>#define Log( ... ) \
        printf( __VA_ARGS__ )</pre>

Recent versions of GCC support the \_\_VA\_ARGS\\_\_ syntax as well. My guess is it&#8217;s the 2.9.x and earlier series that doesn&#8217;t, but I&#8217;ve not looked in to it.

An alternate usage can be used to make &#8220;&#8230;&#8221; and \_\_VA\_ARGS\\_\_ work as zero arguments.

<pre>#define Log( message, ... ) \
        printf( "Log: " message, ## __VA_ARGS__ )</pre>

The ## syntax can be used with GCC&#8217;s &#8220;args&#8230;&#8221; variation too.

## Case ranges in switch statements

Once you&#8217;ve tried it, you wont want to go back. On GCC you can define a range as follows:

<pre>case ST_PAGES ... ST_PAGES_MAX:
case 'A' ... 'Z':
case 1 ... 5:</pre>

My &#8220;solution&#8221; has been to create a macro for when you know how many there are.

<pre>#define case3( _var ) \
	case (_var) + 0: \
	case (_var) + 1: \
	case (_var) + 2:</pre>

And yes, there&#8217;s a lot of those. The number in the name says how many to make. This is hardly a perfect solution, as range ambiguity makes the code easier to write.

## Array Initializers in Constructors

If a class contained an array of something, wouldn&#8217;t it be nice to be able to initialize it? GCC thinks so.

<pre>inline Matrix2x2( const Vector2D& _v1, const Vector2D& _v2 ) :
	Array( (Real[]) { 
		_v1.x, _v1.y,
		_v2.x, _v2.y
		} )
{
}</pre>

(Lets ignore intrinsics being better for a moment, okay?)

Visual Studio, not so much. The alternative is **not** to use an initializer list.

<pre>inline Matrix2x2( const Vector2D& _v1, const Vector2D& _v2 )
{
	Array[0] = _v1.x;
	Array[1] = _v1.y;
	Array[2] = _v2.x;
	Array[3] = _v2.y;
}</pre>

The problem with this is if type of the array has a constructor, then it&#8217;s going to call the default constructor for the initializer list stage, then the copy constructor for the assignments above. Theoretically, this example should be an easy optimization to catch (2 assignments without an access in between), so you can always hope the optimizer catches it. But it shouldn&#8217;t be much work to create a case it wont.

## Variable and zero sized arrays

This feature of GCC I love.

Allocating memory off the stack is extremely fast, and almost guaranteed to be consistent. After all, it&#8217;s implemented by a mere change of the stack pointer register. Using local variables is the normal way to do this. With this GCC extension, you can use variables or math to dynamically allocate off the stack. It can be scoped too, to control when the memory is allocated.

<pre>void MyVetexFunc( const size_t VertexCount ) {
	float Verts[ VertexCount &lt;&lt; 1 ];
	...
}</pre>

Visual Studio can't do that. I need to waste my time allocating off the heap, and cleaning up when I'm done.

<pre>void MyVertexFunc( const size_t VertexCount ) {
	float* Verts = new float[ VertexCount &lt;&lt; 1 ];
	...
	delete [] Verts;
}</pre>

This can be especially terrible for small blocks of code that, during normal use, only use a handfull of bytes. 2-3 floats worth, or such.

## Moving on

For the most part, those were the changes I had to make to the code for it to run. There were a couple #pragmas I needed to add too, to shut up some 1200 warnings I was triggering.

There were only a few outright code changes required. The first was flipping my slashes, "/" to "\", as expected of the Windows world. In addition, my directory searching code had to be rewritten. It's noticeably slower than my MinGW equivalent, so there may be something I can do to improve that. Finally, I had to upgrade LZMA, since I guess the version I was using had issues with Visual Studio 2008.

Lo and behold, Smiles built in Visual Studio 2008.

<div id="attachment_1694" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SmilesInMSVC.jpg"><img src="/wp-content/uploads/2009/11/SmilesInMSVC-640x400.jpg" alt="After a less than thrilling couple days, I&#039;m certainly Smiling" title="SmilesInMSVC" width="640" height="400" class="size-large wp-image-1694" srcset="/wp-content/uploads/2009/11/SmilesInMSVC-640x400.jpg 640w, /wp-content/uploads/2009/11/SmilesInMSVC-450x281.jpg 450w, /wp-content/uploads/2009/11/SmilesInMSVC.jpg 1440w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    After a less than thrilling couple days, I'm certainly Smiling
  </p>
</div>

And now that additional compiler compatibility hurdle is behind me. 😉