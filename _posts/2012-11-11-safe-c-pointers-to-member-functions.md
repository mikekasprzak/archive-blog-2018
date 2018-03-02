---
id: 5563
title: Safe C++ Pointers to Member Functions (Functors)
date: 2012-11-11T18:35:37+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5563
permalink: /2012/11/11/safe-c-pointers-to-member-functions/
categories:
  - Technobabble
---
I did a post some time ago on a threading library called **TinyThread++**. You can [find it here](/2012/09/21/cross-platform-c-threading-today/).

Like always, the following is just a collection of notes.

Item 1: **TinyThread++** is an almost functionally equivalent alternative to C++11 threads, but instead of taking multiple arguments to the thread it takes a single void\*. When C++11 support improves everywhere, that will be the time to switch. But in the meantime, a void\* is a good compromise.

Item 2: Whenever I describe how and why a member function is different than a global/static function, I often say that a member function has a &#8220;secret 1st argument, the &#8216;this&#8217; pointer&#8221;. Heck, if I was going to build a C++ compiler, I would implement it like this. So for the longest time I just assumed this is how others implemented it.

If this is true, then it should be possible to convert a member function in to a &#8220;void Func(void*)&#8221;.

\* \* *

Long story short, this behavior is forbidden by the C++ standard. That said, it works in **GCC**, but fails in **MSVC**. In GCC&#8217;s case, while it does work, it invokes a warning known as &#8220;pmf-conversions&#8221;. You can explicitly disable the warning with &#8220;-Wno-pmf-conversions&#8221;, but given that this just doesn&#8217;t work in Visual Studio it&#8217;s probably unwise to do in the first place.

My nice solution was to add a static proxy function that takes a single &#8220;this class&#8221; pointer, and call the function as if it was a member of the class (because it is).

<!--more-->

<pre class="lang:c++ decode:true " >#include &lt;stdio.h&gt;

class TheClass {
public:
	void MemberFunc() {
		printf( "My This Addr: 0x%x\n", this );
	}
	
	// Static Wrapper Function //
	static void stMemberFunc( TheClass* th ) {
		th-&gt;MemberFunc();
	}
		
	inline TheClass* GetThis() {
		return this;
	}
};

typedef void (*FVoidPtr)(void*);

int main( int argc, char* argv[] ) {
	TheClass Instance;
	Instance.MemberFunc();
	
	//FVoidPtr Func = (FVoidPtr)&TheClass::MemberFunc; // GCC Only, -Wno-pmf-conversions
	FVoidPtr Func = (FVoidPtr)&TheClass::stMemberFunc;
	
	//Func( (void*)&Instance ); // Doesn't Work //
	Func( (void*)Instance.GetThis() );

	return 0;
}</pre>

This is the basic idea.

## Improvements

Some of these improvements are certainly arguable. In fact, I&#8217;ll argue them myself.

### Void pointer GetThis()

This is a minor one, since the concept of the GetThis() function is only for getting the &#8216;this&#8217; pointer to be converted to a void pointer.

<pre class="lang:c++ decode:true " >inline void* GetThis() {
		return (void*)this;
	}

	// ... //

	Func( Instance.GetThis() );</pre>

What&#8217;s arguable about this is GetThis() loses the type data. In practice, there really isn&#8217;t any reason to get the &#8216;this&#8217; pointer from a class unless you plan to cast it to something else. The main benefit of this is that the function GetThis() can now be defined via a macro without any knowledge of type.

<pre class="lang:c++ decode:true " >#define DEFINE_FUNC_GetThis() \
	inline void* GetThis() { \
		return (void*)this; \
	}


class TheClass {
public:
	void MemberFunc() {
		printf( "My This Addr: 0x%x\n", this );
	}

	static void stMemberFunc( TheClass* th ) {
		th-&gt;MemberFunc();
	}

	DEFINE_FUNC_GetThis();	
};</pre>

### Thistype type

Alternatively, we can fake C++ having a &#8216;thistype&#8217; feature by adding a general typedef to a class.

<pre class="lang:c++ decode:true " >class TheClass {
public:
	typedef TheClass thistype;

	void MemberFunc() {
		printf( "My This Addr: 0x%x\n", this );
	}
	
	static void stMemberFunc( thistype* th ) {
		th-&gt;MemberFunc();
	}
	
	inline thistype* GetThis() {
		return this;
	}
};</pre>

Furthermore, if we do this often enough, we can simplify this code with Macros.

<pre class="lang:c++ decode:true " >#define DEFINE_thistype( __name ) \
	typedef __name thistype

#define DEFINE_GetThis() \
	inline thistype* GetThis() { \
		return this; \
	}

#define DEFINE_STATIC_MEMBER_FUNC( __name ) \
	static void st ## __name( thistype* th ) { \
		th-&gt;__name(); \
	}


class TheClass {
public:
	DEFINE_thistype( TheClass );
	DEFINE_GetThis();

	void MemberFunc() {
		printf( "My This Addr: 0x%x\n", this );
	}	
	DEFINE_STATIC_MEMBER_FUNC( MemberFunc );	
};</pre>

### Template version

This can be done in a rather neat and tidy way with C++ templates.

<pre class="lang:c++ decode:true " >#include &lt;stdio.h&gt;

typedef void (*FVoidPtr)(void*);

template&lt;class Type&gt;
class tAction: public Type {
public:
	static void stAction( tAction* th ) {
		th-&gt;Action();
	}
	
	inline tAction* GetThis() {
		return this;
	}
	
	inline static FVoidPtr GetAction() {
		return (FVoidPtr)&stAction;
	}
};


struct MyAction {
	void Action() {
		printf( "My This Addr: 0x%x\n", this );		
	}
};


int main( int argc, char* argv[] ) {	
	tAction&lt;MyAction&gt; Me;
	Me.Action();
	
	FVoidPtr Func2 = Me.GetAction();
	Func2( Me.GetThis() );

	return 0;
}</pre>

Unfortunately, the above is limited to only a single function of a specific name. 

That said, this is totally fine for wrapping a simple oneshot thread (like with **[TinyThread++](http://tinythreadpp.bitsnbites.eu/)**).

<pre class="lang:c++ decode:true " >#include "TinyThread/tinythread.h"
using namespace tthread;

int main( int argc, char* argv[] ) {
	tAction&lt;MyAction&gt; Me;
	Me.Action();

	thread t( Me.GetAction(), Me.GetThis() );

	t.join(); // Wait until finished //

	return 0;
}</pre>

And at the end of the day, this is what I was aiming to do anyway. 

I&#8217;m free to add members to and operate on the data contained inside MyAction. I can set flags and add functions for checking the status of the Action;

Either directly to the Template Action:

<pre class="lang:c++ decode:true " >typedef void (*FVoidPtr)(void*);

template&lt;class Type&gt;
class tAction: public Type {
	bool Started;
	bool Finished;
public:
	tAction() :
		Started( false ),
		Finished( false )
	{
	}

	static void stAction( tAction* th ) {
		th-&gt;Started = true;
		th-&gt;Action();
		th-&gt;Finished = true;
	}
	
	inline tAction* GetThis() {
		return this;
	}
	
	inline static FVoidPtr GetAction() {
		return (FVoidPtr)&stAction;
	}

	inline const bool IsStarted() const {
		return Started;
	}

	inline const bool IsFinished() const {
		return Finished;
	}
};</pre>

Or to my Action directly:

<pre class="lang:c++ decode:true " >class MyAction {
	bool Ready;
public:
	MyAction() :
		Ready( false )
	{
	}
	
	void Action() {
		printf( "My This Addr: 0x%x\n", this );		
		Ready = true;
	}

	inline const bool IsReady() const {
		return Ready;
	}
};</pre>

Or both.

### Horrible Legacy Lambda Function

As it turns out, this is supported in **MSVC 2008**, and **GCC** as long as C++11 is enabled (&#8211;std=c++11 or &#8211;std=c++0x).

<pre class="lang:c++ decode:true " >int main( int argc, char* argv[] ) {
	struct MyAction {
		void Action() {
			printf( "My This Addr Yo: 0x%x\n", this );
		}
	};
	
	tAction&lt;MyAction&gt; Me;
	Me.Action();
	
	thread t( Me.GetAction(), Me.GetThis() );

	t.join(); // Wait until finished //

	return 0;
}</pre>

I&#8217;m assuming this will work in Clang in C++11 mode as well.

### Inline MemberFunc() and Action()

None of the above samples have the inline keyword before MemberFunc() or Action(). I did this because I started out wanting to do this and be GCC &#8216;pmf&#8217; compatible (which means the member function must exist at a specific address and cannot be inline). As a result, we&#8217;ve technically reimplemented how C++ virtual functions work. I haven&#8217;t bothered checking, but my brain seems to want to tell me that, best case, the above code should generate a similar number of instructions as typical C++ virtual functions. However, by inlining MemberFunc and Action, the functions should automatically collapse themselves in to stMemberFunc and stAction, thus requiring only a single function call: to the static function. Otherwise, the static function is called, then the member function is called.

Again, none of this is verified, but theoretical optimization says the only dependency that requires a function exist at an address is the static version (that we get a pointer to).

### Functors

As it turns out, my template example above works similarly to [Functors](http://stackoverflow.com/questions/356950/c-functors-and-their-uses). [Boost](http://www.boost.org/doc/libs/1_52_0/doc/html/function.html) and [Loki](http://loki-lib.sourceforge.net/) provide implementations, and usage is much the same, but you overload the &#8216;()&#8217; operator.

<pre class="lang:default decode:true " >struct MyAction {
		void operator () () {
			printf( "My This Addr Yo: 0x%x\n", this );
		}
	};</pre>

Thanks [Andy](http://twitter.com/twitch).

### My Functor

I&#8217;ll admit, I haven&#8217;t tested the alternatives (Boost, Loki), but from what I&#8217;ve [been reading](http://stackoverflow.com/questions/282372/demote-boostfunction-to-a-plain-function-pointer/3453616#3453616) typical Functors don&#8217;t work like I want. Plus, they all have various overheads to them (virtual function storage, calls, etc). So here&#8217;s my proposed alternative. Zero overhead, C function pointer friendly, and whatnot.

MyFunctor.h:

<pre class="lang:c++ decode:true " title="MyFunctor.h" >#ifndef __MY_FUNCTOR_H__
#define __MY_FUNCTOR_H__

typedef void (*FVoidPtr)(void*);

template&lt;class Type&gt;
class Functor: public Type {
	static void StaticFunc( Functor* th ) {
		th-&gt;operator()( );
	}
public:
	
	inline Functor* GetThis() {
		return this;
	}
	
	inline static FVoidPtr GetFunc() {
		return (FVoidPtr)&StaticFunc;
	}
};

#endif // __MY_FUNCTOR_H__ //</pre>

SampleCode.cpp:

<pre class="lang:default decode:true " title="SampleCode.cpp" >#include &lt;stdio.h&gt;
#include "MyFunctor.h"

struct MyFunc {
	inline void operator()( ) {
		printf("Hi 0x%x\n", this);
	}
};


int main( int argc, char* argv[] ) {
	Functor&lt;MyFunc&gt; Func;
	Func();
	
	FVoidPtr FuncPtr = Func.GetFunc();
	FuncPtr( Func.GetThis() );

	return 0;
}</pre>

Where this is meaningful is when dealing with C callbacks. Practically every callback system supports passing a data pointer to the function pointer you registered as the callback. So we&#8217;ve create a static function to act as a proxy that meets the requirements of being a &#8216;void(\*)(void\*)&#8217; type (i.e. takes one pointer argument). That argument is expected to be the &#8216;this&#8217; pointer of the class instance you&#8217;re trying to run as a callback. With that, all we have to do is call the desired function from the proxy through the pointer and we get full access to all the members of the class (without having to pass them as additional arguments).

From what I gather, [a functor in a C++ sense](http://en.wikipedia.org/wiki/Function_object) is an instanced function with stored data. You get this by expanding the &#8220;MyFunc&#8221; class mentioned above. You can add additional functions as well, including a constructor and destructor. Each instance is isolated, making them as thread safe as you the user choose to make them.

Boost and Loki refer to the actual instancing call as a function called &#8220;function&#8221;, but IMO that just isn&#8217;t weird enough of a name. Technically the &#8220;MyFunc&#8221; class is the functor, and it&#8217;s totally usable without the Functor template, but instancing with the Functor template can be thought to create a complete Functor.

There are some callback situations where a callback takes multiple arguments, meaning the &#8216;StaticFunc&#8217; above isn&#8217;t suitable for them. In my case, the idea of receiving a &#8216;this&#8217; pointer inside &#8216;StaticFunc&#8217; is essential to the design, and the position of the &#8216;this&#8217; pointer needs to match the position of the callback&#8217;s data pointer. Boost uses a FunctionN (Function1, Function2, &#8230;) syntax to say how many arguments there are. In my case, where the &#8216;this&#8217;/data pointer goes is fundamental. I could potentially copy the syntax idea, but I will need a way of saying whether the data pointer is at the front or the back of the argument list (or worst case: anywhere). It \*may\* be possible to simply ignore arguments past a certain point, but given that function calls are stack based and different on different architectures (on ARM, several arguments go in registers and the rest go on the stack), it may be unwise. For the truly insane, calling format may be controllable with \_\_attribute\_\_&#8217;s (cdecl, etc). No thanks. I&#8217;ll stick with the simple design above, until I really need it to change.

## Conclusion

I&#8217;m not sure why, but whenever I had to deal with member functions and function pointer in the past, I ended up butchering the class in to some sort of singleton bastardization, or series of globals. The above are several nicer, cleaner, and threading ready alternatives that I like better. 🙂