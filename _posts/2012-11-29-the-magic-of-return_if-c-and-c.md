---
id: 5674
title: The magic of return_if (C and C++)
date: 2012-11-29T23:46:09+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5674
permalink: /2012/11/29/the-magic-of-return_if-c-and-c/
categories:
  - Technobabble
---
Here is a coding style idea I recently fell in love with. It works in C/C++ thanks to macros.

<!--more-->Take this simple block of code.

<pre class="lang:default decode:true " >const int NewGLContext() {
	GLContext = SDL_GL_CreateContext( pWindow );
	
	if ( GLContext == NULL )
		return -1;
	
	return 0;
}</pre>

For reference, GLContext is an SDL_GLContext which is a void*, so we&#8217;re actually dealing with a pointer here.

This above code is fine. It&#8217;s relatively short, and cleanly handles typical error cases by returning an error code (zero on success, anything else of failure). What&#8217;s interesting is how common this sort of thing is.

Lets change things slightly. Instead, lets say we want to actually return the value of the test. After all, if non-zero is considered an error, then it&#8217;s the same thing.

<pre class="lang:default decode:true " >const int NewGLContext() {
	GLContext = SDL_GL_CreateContext( pWindow );
	
	return (GLContext == NULL);
}</pre>

That&#8217;s pretty good. The code is shorter, simpler, maybe a little weird thanks to the type conversion (boolean equation to const int), but still okay. I&#8217;d like to propose a 3rd version.

<pre class="lang:default decode:true " >const int NewGLContext() {
	GLContext = SDL_GL_CreateContext( pWindow );
	
	if ( const int _Error = (GLContext == NULL) )
		return _Error;
	
	return 0;
}</pre>

All of the above are completely legitimate and perfectly good solutions, but if you&#8217;ll hear me out, I want to say the last one is actually the best. 

How is it the best? There&#8217;s clearly more code and it&#8217;s more complicated (a single &#8220;=&#8221; inside an if block, that&#8217;s taboo!). This is how **return_if** works. The code would then become:

<pre class="lang:default decode:true " >const int NewGLContext() {
	GLContext = SDL_GL_CreateContext( pWindow );
	
	return_if( GLContext == NULL);
	
	return 0;
}
</pre>

So great Mike, you&#8217;ve now created a different and strange dialect of the C and C++ language. Why the hell would you do that? Well, I&#8217;d like to present the next code example:

<pre class="lang:default decode:true " >const int NewGLContext() {
	GLContext = SDL_GL_CreateContext( pWindow );
	
	if ( const int Error = (GLContext == NULL) ) {
		printf( "! Error Creating GLContext %i: %i", Index, GLContext );
		return Error;
	}
	else {
		printf( "* GLContext %i Created: %i", Index, GLContext );
	}
	
	return 0;
}</pre>

**Now** things just got complicated. We&#8217;re logging different information to standard output depending on the result of the &#8220;GLContext == NULL&#8221; test. Lets fix this with a new version of return_if.

<pre class="lang:default decode:true " >const int NewContext() {
	Context = SDL_GL_CreateContext( pWindow );
	
	return_if_printf( Context == NULL, "! Error Creating Context %i: %i", Index, Context );
	printf( "* Context %i Created: %i", Index, Context );
	
	return 0;
}</pre>

This is where return\_if gets especially interesting. Those several lines of code have been cleanly compressed to 2 lines. The first argument to return\_if_printf is the test we were previously doing, and the rest are typical printf arguments.

A barebones implementation of this may look like this.

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
#ifndef __RETURN_IF_H__
#define __RETURN_IF_H__
// - ------------------------------------------------------------------------------------------ - //
#include &lt;stdio.h&gt;
// - ------------------------------------------------------------------------------------------ - //
#define return_if( __TEST ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { return __Error ## __COUNTER__; } }

#define Log( ... ) { printf( __VA_ARGS__ ); }
#define return_if_Log( __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Log( __VA_ARGS__ ); return __Error ## __COUNTER__; } }
// - ------------------------------------------------------------------------------------------ - //
#endif // __RETURN_IF_H__ //
// - ------------------------------------------------------------------------------------------ - //</pre>

You&#8217;ll note I&#8217;m now using Log instead of printf, but as you can see above, Log is printf. Also I use a C++11 auto type, but this could as easily just be an &#8220;int&#8221; if you wanted to do this in C. The \_\_COUNTER\_\_ stuff is so I generate a unique variable name inside each scope. Technically, due to C/C++ scoping rules I don&#8217;t actually need unique variable names, but I do it anyway. To help report better errors, you may want to use a better name than &#8220;\_\_Error&#8221;&#8230; something like &#8220;\_\_error\_in\_return\_if\_\_you\_probably\_meant\_to\_use\_return\_if\_void&#8221;.

## Growing the return_if family

Outside the logging, there are a few more variations that would be useful. For one, having a way to to write a return_if inside a void function. In addition, having a way to return a different value upon success. Lets do that right now:

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
// Conditional Return //
#define return_if( __TEST ) { if ( auto __Error ## __COUNTER__ = (__TEST) ) { return __Error ## __COUNTER__; } }
#define return_if_void( __TEST ) { if ( __TEST ) { return; } }
#define return_if_value( __RETCODE, __TEST ) { if ( __TEST ) { return __RETCODE; } }
	
// Unconditionally Return (included for syntactical completeness) //
//#define return( __TEST ) { return (__TEST); } // DUH, this already exists in the C language! //
#define return_void( __TEST ) { (__TEST); return; }
#define return_value( __RETCODE, __TEST ) { (__TEST); return __RETCODE; }
// - ------------------------------------------------------------------------------------------ - //</pre>

You&#8217;ll note I also included if-less versions on the bottom. Just as the names suggest, they work exactly the same but always return. And the ha ha moment, &#8220;return&#8221; already works with a bracket syntax in C and C++, so we don&#8217;t even need a macro for it (This is the reason for the name style). These functions aren&#8217;t too useful or interesting themselves, but when we get to expanding the logging family, they&#8217;ll make a lot more sense.

## Expanding the return\_if\_Log family

With the above library of functions as our template, we can infer a wide library of Logging variations we may want. Like these: 

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
#define Log( ... ) { printf( __VA_ARGS__ ); }
#define if_Log( __TEST, ... ) { if ( __TEST ) { Log( __VA_ARGS__ ); } }
#define return_Log( __RETCODE, ... ) { Log( __VA_ARGS__ ); return __RETCODE; }
#define return_void_Log( ... ) { Log( __VA_ARGS__ ); return; }
#define return_value_Log( __RETCODE, ... ) { Log( __VA_ARGS__ ); return __RETCODE; }
#define return_if_Log( __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Log( __VA_ARGS__ ); return __Error ## __COUNTER__; } }
#define return_if_void_Log( __TEST, ... ) { if( __TEST ) { Log( __VA_ARGS__ ); return; } }
#define return_if_value_Log( __RETCODE, __TEST, ... ) { if( __TEST ) { Log( __VA_ARGS__ ); return __RETCODE; } }
// - ------------------------------------------------------------------------------------------ - //</pre>

&#8220;if_Log&#8221; is a nice one. Conditionally choose to print something in one command.

&#8220;return_Log&#8221; is interesting. In cases like the 2nd code sample where we want to return the value of the test, we can now write a report to the Log at the same time.

The rest should be self explanatory. The same above return_if calls with Logging support.

Now with a complete library of functions, we can make a subtle improvement to the above example code.

<pre class="lang:default decode:true " >const int NewContext() {
	Context = SDL_GL_CreateContext( pWindow );
	
	return_if_Log( Context == NULL, "! Error Creating Context %i: %i", Index, Context );
	return_Log( 0, "* Context %i Created: %i", Index, Context );
}</pre>

I am not sure I would actually encourage this, since the separate &#8220;return 0&#8221; at the end actually stands out better. The &#8220;return 0&#8221; is the true end of the function, and there&#8217;s no chance of accidentally placing a line after the return_Log call and not realizing the code is unreachable. That said, your compiler should still give you warning about the unreachable code, but better safe than sorry.

## Assert and Warning

The return_log family of functions are **a lot** like the standard C function called **assert**. You or your project lead may have added an &#8220;AssertMsg&#8221; function to your library code, basically, an assert combined with a Logging print (or MessageBox).

Asserts are extra tests that only get included in your debug build (#ifndef ndebug). In your release build, they should not show up. If you have a popup message that&#8217;s still Assert grade that needs to ship in release code, then Assert is probably the wrong function and you need something else for this case (i.e. ErrorLog).

That about sums me up. In the past when I was a project lead, I&#8217;d often have an AssertMsg function. Over time, I decided that Assert should always have a message attached to it, so upper case &#8220;Assert&#8221; became my standard function call for asserting, and it always takes printf style arguments.

Asserts are unrecoverable errors. If you reach one, it should be theoretically impossible to continue. That said, some errors actually cause weird behavior instead outright crashing. It may still crash and burn right away after, but sometimes you have additional Assert-like checks that would be nice if they also triggered, so you had a more complete log of the failure.

Me, I have 2 functions: **Assert**, and **Warning**. Both work exactly the same, taking the test, printf style arguments, but Assert calls exit(1) causing the program to exit immediately. In practice I rarely use Assert, but Warning gets heavy use. Again, this is because I often have several lines of Warning messages, and knowing when I trigger multiple failure cases is helpful.

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
#ifdef _MSC_VER
#define __PRETTY_FUNCTION__ __FUNCTION__
#endif // _MSC_VER
// - ------------------------------------------------------------------------------------------ - //
#ifndef ndebug
// - ------------------------------------------------------------------------------------------ - //
// Assertion //
#define Assert( ___TEST, ... ) \
	{if ( ___TEST ) { \
		Log( "-========================================================-\n" ); \
		Log( "! Assert Error: " ); \
		Log( __VA_ARGS__ ); \
		Log( "\n" ); \
		Log( "   Line: %i  File: %s\n", __LINE__, __FILE__ ); \
		Log( "   Func: %s\n", __PRETTY_FUNCTION__ ); \
		Log( "-========================================================-\n" ); \
		::exit(1); \
	}}
// - ------------------------------------------------------------------------------------------ - //
// Warnings //
#define Warning( ___TEST, ... ) \
	{if ( ___TEST ) { \
		Log( "-========================================================-\n" ); \
		Log( "! Warning: " ); \
		Log( __VA_ARGS__ ); \
		Log( "\n" ); \
		Log( "   Line: %i  File: %s\n", __LINE__, __FILE__ ); \
		Log( "   Func: %s\n\n", __PRETTY_FUNCTION__ ); \
	}}
// - ------------------------------------------------------------------------------------------ - //
#else // ndebug //
// - ------------------------------------------------------------------------------------------ - //
#define Assert( ... ) ;
#define Warning( ... ) ;
// - ------------------------------------------------------------------------------------------ - //
#endif // ndebug //
// - ------------------------------------------------------------------------------------------ - //</pre>

**Assert** and **Warning** are a lot like **if_Log**; They test, then on a non-zero value, they trigger. Since they work so similarly, it makes sense that they should become part of the return\_if\_Log family.

Notably, Assert never returns, so it doesn&#8217;t need any **return_if** variations. Warning does however.

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
#define return_Warning( __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Warning( __Error ## __COUNTER__, __VA_ARGS__ ); return __Error ## __COUNTER__; } }
#define return_void_Warning( __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Warning( __Error ## __COUNTER__, __VA_ARGS__ ); return; } }
#define return_value_Warning( __RETCODE, __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Warning( __Error ## __COUNTER__, __VA_ARGS__ ); return __RETCODE; } }

#define if_Warning( __TEST, ... ) { Warning( __TEST, __VA_ARGS__ ); }
#define return_if_Warning( __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Warning( __Error ## __COUNTER__, __VA_ARGS__ ); return __Error ## __COUNTER__; } }
#define return_if_void_Warning( __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Warning( __Error ## __COUNTER__, __VA_ARGS__ ); return; } }
#define return_if_value_Warning( __RETCODE, __TEST, ... ) { if( auto __Error ## __COUNTER__ = (__TEST) ) { Warning( __Error ## __COUNTER__, __VA_ARGS__ ); return __RETCODE; } }
// - ------------------------------------------------------------------------------------------ - //</pre>

Asserts and Warnings never don&#8217;t perform a test, so the syntax isn&#8217;t exactly consistent with Log. That said, I include both versions (with and without the word &#8220;if&#8221;) for completeness. 

## Bringing it all together

Here&#8217;s the real implementation of NewGLContext.

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
inline GelError NewGLContext() {
	return_if( DeleteGLContext() ); // Just in case //
	
	Assert( pWindow == NULL, "Window not created before SDL_GL_CreateContext called" );
	
	GLContext = SDL_GL_CreateContext( pWindow );
	
	return_if_Log( GLContext == NULL, "! Error Creating GLContext %i: %i", Index, GLContext );
	Log( "* GLContext %i Created: %i", Index, GLContext );
	
	return GEL_OK;
}
// - ------------------------------------------------------------------------------------------ - //</pre>

As opposed to the more verbose version.

<pre class="lang:default decode:true " >// - ------------------------------------------------------------------------------------------ - //
inline GelError NewGLContext() {
	if ( auto Error = DeleteGLContext() ) {
		return Error;
	}
	
	Assert( pWindow == NULL, "Window not created before SDL_GL_CreateContext called" );
	
	GLContext = SDL_GL_CreateContext( pWindow );
	
	if ( auto Error = (GLContext == NULL) ) {
		Log( "! Error Creating GLContext %i: %i", Index, GLContext );
		return Error;
	}
	
	Log( "* GLContext %i Created: %i", Index, GLContext );
	
	return GEL_OK;
}
// - ------------------------------------------------------------------------------------------ - //</pre>

**return_if** really is a subtle thing, but as functions grow due error checks, it&#8217;s a way to keep things a little cleaner.