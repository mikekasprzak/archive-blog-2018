---
id: 5395
title: Cross Platform C++ Threading Today
date: 2012-09-21T00:35:26+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5395
permalink: /2012/09/21/cross-platform-c-threading-today/
categories:
  - Technobabble
---
C++11 finally brings threading in to the core C++ language. Unfortunately, as my [little investigation found](/2012/08/25/practical-c11-support-for-game-developers/), we&#8217;re not quite all there yet.

That&#8217;s okay though, &#8217;cause as it turns out, most of core function of C++ threading can be emulated using standard C and C++ features. While doing something else, I stumbled upon a library **TinyThread++**. It&#8217;s lightweight (2+1 source files), cross platform, and free+open source in the best ways possible.

<http://tinythreadpp.bitsnbites.eu/>

**TinyThread++** attempts to emulate the usage of standard C++11 threading, in a decent, good enough, compromise way. I like it, so instead of fooling around with pThreads and whatever classic Microsoft APIs do, I&#8217;m going to use it. And since it&#8217;s so simple (2+1 files), if I need something or need to fix something, it&#8217;s right there. Great.

Alternatively, there is an equivalent C variant: <http://tinycthread.bitsnbites.eu/>

<!--more-->

## Construction and Basic Use

C++11 threads are quite advanced in how they construct. They take advantage of a [variadic template](http://en.wikipedia.org/wiki/Variadic_function) for a clean simple syntax (think printf). You can find out more details here:

<http://en.cppreference.com/w/cpp/thread/thread/thread>

TinyThread++ thread construction is different, simpler, more C style. It uses a **void***.

<pre class="lang:c++ decode:true " title="Hello World code borrowed from TinyThread++ docs" >#include &lt;iostream&gt;
#include &lt;tinythread.h&gt;

using namespace std;
using namespace tthread;


// This is the child thread function
void HelloThread( void* aArg ) {
	cout &lt;&lt; "Hello world!" &lt;&lt; endl;
}

// This is the main program (i.e. the main thread)
int main() {
	// Start the child thread
	thread t( HelloThread, 0 );
	
	// Wait for the thread to finish
	t.join();
}
</pre>

This isn&#8217;t so bad. Sure, it&#8217;s not as clean as a variadic template might make it (printf style, pass all arguments right to the construction call), but it gets the job done. The 2nd argument to thread&#8217;s construction is the same void* passed to the function. You could treat it as a pointer to something, casting to whatever argument pointer you like, or reinterpret it as a size_t (i.e. 32 or 64bit depending on the architecture).

The thread runs, and we halt what we&#8217;re doing in the main thread using the join call.

Herein, tthread::thread is functionally similar as std::thread. The complete reference is here:

<http://en.cppreference.com/w/cpp/thread/thread>

Notably is the idea of detachment [ t.detach() ] and testing if a thread is joinable [ t.joinable() ]. If a thread isn&#8217;t started (constructor w/o args), then you can&#8217;t join it. Or if a thread is explicitly detached, you can&#8217;t join it. Joinable is another way of knowing if the thread is running (with the sole exception of if you decide to detach it).

It is highly recommended you .join() a thread before destroying it (either through scope, or explicit delete calls).

## Thread-local storage

Thread-local storage is a C++11 feature that has \*almost\* made its way everywhere. It&#8217;s been available since GCC 3.3 (MinGW ft GCC 4.x), and Visual C++ 2010. The only hold out is Clang, which is the compiler suite used by Xcode, Emscripten, and some other projects. However, as of Clang 3.2 it **is** available. Unfortunately, as of this writing, Clang 3.2 hasn&#8217;t been released yet. And if you&#8217;re an Apple developer, you need to wait for the next Xcode refresh where they update Clang. So literally, we are on the cusp of being able to use Thread-local storage everywhere! 6 months, give or take.

[What this is](http://en.wikipedia.org/wiki/Thread_local_storage) is a special kind of global and static variable. Typical globals and statics are shared amongst all threads. Local storage types have a unique instance per thread.

Support for local storage types has been around for a long time now as the \_\_thread or \_\_declspec(thread) keywords. Further details can be found here:

[http://en.wikipedia.org/wiki/Thread\_local\_storage#C.2B.2B](http://en.wikipedia.org/wiki/Thread_local_storage#C.2B.2B)

And the TinyThread++ version:

<pre class="lang:c++ decode:true " title="Using a thread_local" >#include &lt;tinythread.h&gt;
using namespace tthread;


thread_local int MyVariable;

void MathThread( void* aArg ) {
	MyVariable = 10 + (size_t)aArg;
}

int main() {
	thread t( MathThread, (void*)7 );
	
	// Wait for the thread to finish
	t.join();
}</pre>

## thread::hardware_concurrency()

This is a simple static function that tells you how many hardware threads are available. When porting TinyThread++ to new platforms (Marmalade), this will be a function that needs to be attended to. Also if the CPU supports Hyper Threading (Intel Atom), it will report 2 threads per core.

Will return 0 on failure (unknown number of cores).

## this_thread

Instead of having to pass details about the current thread as arguments, several helper functions can be found in the global namespace **this_thread**. **std::this_thread** for C++11, and **tthread::this_thread** for TinyThread++.

<http://en.cppreference.com/w/cpp/thread>

TinyThread++ doesn&#8217;t support all of the this_thread features, but supports enough of them.

### this_thread::yield()

When called from the current thread, it gives up the CPU until the other threads have had a chance to run.

<pre class="lang:c++ decode:true " >uses namespace tthread;

void PoliteThread( void* aArg ) {
	this_thread::yield();
}</pre>

### this\_thread::sleep\_for( &#8230; )

When paired with the chrono library, you can put the current thread to sleep for a period of time.

<pre class="lang:c++ decode:true " >uses namespace tthread;

void NappingThread( void* aArg ) {
	this_thread::sleep_for( chrono::milliseconds(100) );
}</pre>

## Mutexes

Sure great, we can run and execute several threads of code, but without some sort of locking, we&#8217;re going to be smashing over each-others shared reads and writes. Hence mutex objects (Mutual Exclusion).

<pre class="lang:c++ decode:true " >uses namespace tthread;
mutex m;

void MutexingThread( void* aArg ) {
	m.lock(); // Waits until I get a lock (I have work to do) //
	// Do something //
	m.unlock(); // Unlocks (I am done) //
}

// Alternatively, we can check if a lock is available and not block //
void MutexingThread2( void* aArg ) {
	while( true ) { // Loop forever! //
		if ( m.try_lock() ) { // Attempts to get a lock, but doesn't wait on fail //
			// I have a lock!! Be sure to unlock! //
			m.unlock();
			return; // We finally got our lock and did our thing, goodbye! //
		}
		this_thread::yield(); // Gotta do something while we wait //
	}
}
</pre>

### recursive_mutex

Hey guess what? If you call m.lock() on a regular mutex twice in a row, YOU DEADLOCK!

So instead, if you want to nest lock calls (and if you&#8217;re good about unlocking them), you can use a recursive_mutex type.

### lock_guard

Locking (blocking) with mutexes is so common. How about a C++ class for locking and unlocking?

<pre class="lang:c++ decode:true " >uses namespace tthread;
mutex m;

void GuardThread( void* aArg ) {
	lock_guard&lt;mutex> guard(m);
	// Do stuff. The mutex will be unlocked as it goes out of scope below. //
}</pre>

## Condition Variable

The final part of TinyThread++ (C++11 std::thread [has more parts](http://en.cppreference.com/w/cpp/thread)).

condition_variable is an object that can use a mutex to broadcast a signal to one or all instances. It has a slightly unusual behavior, in that the mutex you pass it becomes **unlocked** while the condition_variable::wait() function blocks, then re-locks once it gets a notice (stops waiting). You can find a usage example here:

[http://tinythreadpp.bitsnbites.eu/doc/classtthread\_1\_1condition__variable.html](http://tinythreadpp.bitsnbites.eu/doc/classtthread_1_1condition__variable.html)

TODO: Write a practical example. A manager thread that starts new job threads that die when they&#8217;re done? I dunno, I gotta brain-flex for a while to figure out something meaty.

## Conclusion

No more Windows threads and pThreads! It&#8217;s about time C++ had a standard(ish) way of threading, that isn&#8217;t the 600 lb gorilla Boost.