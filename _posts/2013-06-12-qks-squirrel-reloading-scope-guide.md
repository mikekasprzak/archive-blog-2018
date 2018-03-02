---
id: 6248
title: 'Qk&#8217;s Squirrel &#8220;Reloading Scope&#8221; Guide'
date: 2013-06-12T22:01:09+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6248
permalink: /2013/06/12/qks-squirrel-reloading-scope-guide/
categories:
  - Qk
  - Squirrel
  - Technobabble
---
This is a preliminary document. A first pass, a draft, talking through implementation notes from a piece of a project with the working name &#8220;Qk&#8221;. It might be something cool. I&#8217;m not telling. ;D

The programming language seen below is [squirrel](http://www.squirrel-lang.org/), but this specific nuance is something in my engine.

* * *

## Reloading Scope

**&#8220;Reloading Scope&#8221;** is another name for the **Global Scope** of a script file. Take the follow code:

<pre class="lang:default decode:true " >Pos &lt;- [ 0.0, 0.0 ]; // Global Scope Global Var - Reloaded every change //

function Init() {
}

function Step() {
	local Pad = qkGetPad(0); // Get GamePad #0 as a Local Var (stack) //
	Pos[0] += Pad.LStick.x;
	Pos[1] += Pad.LStick.y;
}

function Draw( m ) {
	qkClear();	
	qkDrawCircle( m, Pos, 30, RGBA(128,255,128,255) );
}</pre>

The variable **Pos** is in the global scope. Any and all code found in the global scope will be executed every time a script file is changed (automatically reloaded). So every single time this file reloads, **Pos** will reset back to [0,0]. This may not be the desired effect, as you may want the position to stay the same across changes. 

To remedy this, simply move the code in to function scope.

<pre class="lang:default decode:true " >function Init() {
	Pos &lt;- [ 0.0, 0.0 ]; // Function Scope Global Var - Reloaded only during Init //
}

function Step() {
	local Pad = qkGetPad(0); // Get GamePad #0 as a Local Var (stack) //
	Pos[0] += Pad.LStick.x;
	Pos[1] += Pad.LStick.y;
}

function Draw( m ) {
	qkClear();	
	qkDrawCircle( m, Pos, 30, RGBA(128,255,128,255) );
}</pre>

**REMEMBER**: Both of these snippets effectively do the same thing, creating a global variable called Pos (in the root table). The only difference is the idea of &#8220;Reloading Scope&#8221; presented above.

### Constants in Reloading Scope

For the most part, constants should be placed in Global Scope. This way, if you decide to change their meaning, the changes will affect all future references to the variable.

<pre class="lang:default decode:true " >const PI = 3.1415926535897932384626433832795; // Just in case //

function Init() {
	Pos &lt;- [ 0.0, 0.0 ];
}

// ... //</pre>

### &#8220;Hard-coded&#8221; Data and Delagates in Reloading Scope

When code is dynamically reloaded, &#8220;hard-coded&#8221; isn&#8217;t really that &#8220;hard-coded&#8221; anymore. 😀

Delegates should be set immediately after the data is populated INSIDE the global scope. This way, during subsequent reloads when it trashes the old data, all your standard functions and default values continue to work correctly.

<pre class="lang:default decode:true " title="Hey" >Character &lt;- {
    _tostring = function() {
        return name + " " + state;
    },
    name="not specified",
    state=0
}
 
Player &lt;- {
    name="Stranger",
    state=10
}.setdelegate( Character ); // Can do it here, or as Player.setdelegate //
 
print( Player + "\n" );
 
// Output: Stranger 10</pre>

### File Dependencies in Reloading Scope

Understanding Reloading Scope is important due to the way automatic dependencies work. All files that depend on this file will be flagged and reloaded at the same time. So changing this file may inadvertently cause another file to reload.

Each file is reloaded at max 1 time per refresh in _Usage Order_.

Usage Order is the order in which the files were referenced by each-other, starting with the root file (**main.nut**). Issuing a &#8220;requires()&#8221; command **DOES NOT** load a file, but instead queues it to load **immediately after** the current list of files have finished loading. 

This is fine for code written for Function Scopes, but can be troublesome for Reloading Scope. After all, the newest version of a constant or class defined in a later file will be inaccessible/incorrect until all files have been loaded.

To work around this, push a function on to **OnReload** array. All functions in the **OnReload** array will be called immediately after all files have finished loading due to a refresh.

<pre class="lang:default decode:true " >OnReload.push( 
	function() {
		MyPICopy &lt;- PI;
	}
);

const PI = 3.1415926535897932384626433832795;</pre>

TODO: Consider priority model, giving functions inside OnReload a weight to control who gets called first/last. i.e. qkOnReloadCall( function(){}, Weight ); // Weight is optional. Default 0, highest first //

TODO: Consider &#8220;include()&#8221; function too which, if supported by squirrel compiler and VM, recursively compiles and executes code files on demand before finishing other ones. Need an #ifndef #define #endif construct, or #pragma once like function (global array of parent files, updated according to depth). Discourage the usage of this, but support it for hackability. &#8220;include()&#8221; should be thought of and used like a macro. &#8220;dofile()&#8221;. Overload sqstdlib dofile()?