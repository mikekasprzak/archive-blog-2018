---
id: 6075
title: Squirrely things about Squirrel
date: 2013-05-06T09:40:56+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6075
permalink: /2013/05/06/squirrely-things-about-squirrel/
categories:
  - Squirrel
  - Technobabble
---
More notes. [This article](/2013/03/09/notes-and-differences-between-squirrel-and-javascript/) contains a longer more comprehensive list of differences, but I want a more concise list for both my own reference, and for when I&#8217;m teaching.

[Squirrel 3 documentation](http://www.squirrel-lang.org/doc/squirrel3.html).

<!--more-->

## Tables are Objects

In JavaScript and Squirrel, you have two types: Arrays which are indexed with an integer number, and Objects/Tables that are indexed with a string. In JavaScript the string one is called Objects, and in Squirrel one is called **Tables**. The name (and some of the original code) is borrowed from Lua.

Members of Arrays and Tables in Squirrel are called **Slots**.

The &#8220;this&#8221; member of function scope is called the **Context** or the **Environment**.

## .length is .len()

<pre class="lang:default decode:true " >MyArray &lt;- [1,2,3];
MyTable &lt;- {hello=true};

print( MyArray.len() + "\n" ); // 3 //
print( MyTable.len() + "\n" ); // 1 //</pre>

## The meaning of &#8220;this&#8221; can be changed in a function call

<pre class="lang:default decode:true " >Player &lt;- { name="Steve" };

function MyFunc() {
    print( this );
}

MyFunc.call( Player ); // "this" will be Player //

Player.Func &lt;- MyFunc;

Player.Func(); // Call as a member, "this" will be Player //

MyFunc(); // Otherwise, "this" is the root table when not called as a member.</pre>

## The "in" operator (hasOwnProperty)

To check if a Table has a member, use "in".

<pre class="lang:default decode:true " >if ( "offset_x" in Player ) {
    // Player has a member offset_x //
}

function Blah() {
    if ( "offset_y" in this ) {
        // Whatever context this function uses has a member offset_y //
    }
}

Blah.call( Player ); // An example for calling with different contexts (i.e. the "this")

if ( "Player" in getroottable() ) {
    // There is a global variable called Player //
}</pre>

## var and local are not the same

In JavaScript, you use the **var** keyword to declare a variable. Depending on the scope of that variable (in a function, in global scope), the variable is declared there. 

In JavaScript, to add a member variable to class, you don't use var but instead use dot syntax and directly set it. i.e. **MyObject.MyNewMember = value;**

In Squirrel, you have a keyword **local**, which is like **var**, but only applies to function level scope. In Squirrel, **Global Scope** is actually a table called the **Root Table**. To add a member to a Table, you use the arrow syntax.

<pre class="lang:default decode:true " >MyGlobalVar &lt;- {}; // Creates a global variable, i.e. adds to the root table
MyVar &lt;- true; // Assign any type, not just arrays and tables.

function MyFunc() { // Synonym for "MyFunc &lt;- function() {"
    local MyLocal = 12; // A local variable
    MyGlobalVar.NewMember &lt;- 10; // Adds NewMember to the table and assigns it a value
    MyGlobalVar.NewMember = MyGlobalVar.NewMember + MyLocal; // Now that it exists, = works
    if ( ::MyVar == true ) { // Double colon syntax to explicitly access Global Scope
        print( MyVar ); // Double Colon syntax isn't required, but without it uses local first
    }
    return MyGlobalVar.NewMember;
}</pre>

That said, local is allowed in the Global Scope, but it doesn't add objects to the root table. Instead, like all other locals, it adds them to the local scope (i.e. the stack).

<pre class="lang:default decode:true " >//Scooter &lt;- 10;      // Root Table (Globals) //
//const Scooter = 10; // Const Table (Global Constants) //
local Scooter = 10;   // Stack //

function Hello() {
	if ( "Scooter" in this ) {
		error( "is in this\n" ); // For now, this is the root table
	}

	if ( "Scooter" in getroottable() ) {
		error( "is on Root\n" );
	}

	if ( "Scooter" in getconsttable() ) {
		error( "is on Const\n" );
	}

	if ( "Scooter" in getstackinfos(1).locals ) {
		error( " is on Stack\n" );
	}
}
	
Hello();

// Output: is on Stack</pre>

A related topic is Free Variables.

**FYI:** getstackinfos() returns a Table, see the docs for more info. The locals member is a Table of all local variables. Also the argument to getstackinfos is the call stack level. 0=Current Function, 1=Caller, 2=Caller's Caller, etc.

## Closures

Closures are Functions. Both terms are used interchangeably.

The value of "this" can be changed using the ".call" method of a function. This is called the Environment Object.

An explicit Environment Object can also be bound to a function, forcing all calls to use that environment and ignore the typical value of "this". This may seem strange, but this whole mechanism will be useful later.

Here's a discussion on JavaScript closures that may be of interest: <https://developer.mozilla.org/en-US/docs/JavaScript/Guide/Closures>

<pre class="lang:default decode:true " >// Assume Player has a delegate that sets its _tostring to return "Player"
function MooMoo() {
	error( "** " + this + " " + getroottable() + "\n" );
}

MooMoo(); // Default Env is Root Table //
MooMoo.call( Player ); // Specific Env: Player //

Moo &lt;- MooMoo.bindenv( Player ); // Create a copy of MooMoo with Player always bound.

Moo(); // A replica with a specifically bound Environment //
Moo.call( ArtFiles2 ); // Overloading that environment (fails) //
MooMoo(); // Again just to confirm Original was unmodified //

// ** (table : 0x006B8730) (table : 0x006B8730)
// ** Player (table : 0x006B8730)
// ** Player (table : 0x006B8730)
// ** Player (table : 0x006B8730) // Unexpected result! bindenv permanent!
// ** (table : 0x006B8730) (table : 0x006B8730)</pre>

## JSON Syntax Caveats

One of the main reasons I'm so insistent of Squirrel is because it's extremely close syntactically with JavaScript. So far, I've found a way to do everything I like in JavaScript with Squirrel, but sometimes it's just works a little differently.

As of Squirrel 3, you've been able to use a JSON-like syntax for building objects. Here is a snippet ported over from TOOM:

<pre class="lang:default decode:true " >ArtFiles &lt;- [
	{ "name":"Man", "value":"art/anim.png", "tile_w":128, "tile_h":128, "anchor_y":128 },
	
	{ "name":"BG1", "value":"art/toombg_bg_01.png" },
	{ "name":"BG2", "value":"art/toombg_para_01.png" },
	{ "name":"BG3", "value":"art/toombg_para_02.png", "anchor_y":560-400 },
	{ "name":"BG4", "value":"art/toombg_para_03.png", "anchor_y":304-400 },
};</pre>

Unlike JavaScript though, all member names have to be wrapped in strings to use the colon syntax (i.e. in JS, **"name"** could be just **name**).

Alternatively, the Squirrel way is as follows:

<pre class="lang:default decode:true " >ArtFiles2 &lt;- [
	{ name="Man", value="art/anim.png", tile_w=128, tile_h=128, anchor_y=128 },
	
	{ name="BG1", value="art/toombg_bg_01.png" },
	{ name="BG2", value="art/toombg_para_01.png" },
	{ name="BG3", value="art/toombg_para_02.png", anchor_y=560-400 },
	{ name="BG4", value="art/toombg_para_03.png", anchor_y=304-400 },
];</pre>

At the moment of this writing, I'm undecided, but leaning towards the JSON syntax because the hardcoded data will be portable to JavaScript. Function syntax for JavaScript and Squirrel is identical, so porting code between the two may simply be a matter of fixing global scoped things, converting **var**'s to **local**'s, and any **in**'s to hasOwnProperty calls... well, constants/enums/operators aside.

## Generated String Indexing

This works the same as JavaScript.

<pre class="lang:default decode:true " >SomeData &lt;- { Truthy=true, Other=15, States=[1,2,3] };

if ( SomeData["Truthy"] ) {
    // This is the same as SomeData.Truthy, except //
    // you can feed any string in //
}

Text &lt;- "Other";

if ( SomeData[Text] &gt; 12 ) {
    // Indexing with a variable //
}

print( SomeData["States"][1] ); // Output: 2. Could also do SomeData.States[1] //
</pre>

## Pseudo Inheritance with Delegates

Squirrel does support classes and inheritance, but it also supports an interesting alternative called Delegates.

Tables can be assigned a Delegate, i.e. a parent Table. Delegates are used to assign Metamethods (i.e. overloaded operators) and default values.

<pre class="lang:default decode:true " >Player &lt;- { 
	name="Gentlemen",
};

print( Player + "\n" );

// Output: (table : 0x00580F18)</pre>

That's not a very useful output. Using a delegate:

<pre class="lang:default decode:true " >Character &lt;- {
	_tostring = function() {
		return this.name;
	},
}

Player &lt;- { 
	name="Gentlemen",
};

Player.setdelegate( Character );

print( Player + "\n" );

// Output: Gentlemen</pre>

That's better.

Metamethods (operators) only work using Delegates. So while you are able to add a function called _tostring directly to the Player Object, Metamethods will only fire if they are inside a Delegate.

## Default values using Delegates

If we add a member variable to the delegate, the child implicitly gets it.

<pre class="lang:default decode:true " >Character &lt;- {
	_tostring = function() {
		return this.name + " " + state;
	},
	state=0,
}

Player &lt;- { 
	name="Gentlemen",
};

Player.setdelegate( Character );

print( Player.state + " " );
print( Player + "\n" ); // implicitly calls tostring //

// Output: 0 Gentlemen 0</pre>

Finally, adding a value to the child (Player) uses its value instead.

<pre class="lang:default decode:true " >Character &lt;- {
	_tostring = function() {
		return this.name + " " + state;
	},
	state=0,
}

Player &lt;- { 
	name="Gentlemen",
	state=10
}.setdelegate( Character ); // Can do it this way too //

print( Player.state + " " );
print( Player + "\n" );

// Output: 10 Gentlemen 10</pre>

Delegates are like inheritance without classes.

## All Basic Types have Delegates

Yes. So says the documentation. That's how they get their member functions.

## Member Function Syntax

<pre class="lang:default decode:true " >SomeObject &lt;- {};

// Synonym for SomeObject.MemberFunc &lt;- function() {
function SomeObject::MemberFunc() {
    // Woo hoo! //
}</pre>

## typeof operator

<pre class="lang:default decode:true " >Player &lt;- { 
	name="Gentlemen",
};

print( typeof Player + "\n" );

// Output: table</pre>

Using Delegates, we can change the returned type string.

<pre class="lang:default decode:true " >Character &lt;- {
	_typeof = function() {
		return "Character";
	},
}

Player &lt;- { 
	name="Gentlemen",
}.setdelegate( Character );

print( typeof Player + "\n" );

// Output: Character</pre>

Even in C code, the value returned by the _typeof metamethod will be a string. Type checking is therefor:

<pre class="lang:default decode:true " >if ( typeof MyVar == "string" ) {
    // It's a string //
}</pre>

**NOTE:** Built-in type names returned are **lower case** strings.

## callee() and .getinfos()

callee() returns the currently running function object.

<pre class="lang:default decode:true " >function MyFunc() {
    return callee();
}

print( MyFunc() );

// Output: (function : 0x00470EA8)</pre>

To get information about the current function, you can use the .getinfos() method of any function.

<pre class="lang:default decode:true " >function MyFunc() {
    return callee().getinfos();
}

print( MyFunc() );

// Output: (table : 0x00470FF8)</pre>

But as you can see above, it returns a table of information. And unlike JavaScript, Table Printing is somewhat uninteresting.

<pre class="lang:default decode:true " >function InfoFunc() {
	local Text = "";
	foreach( name, value in callee().getinfos() ) {
		Text += name + ": " + value + "\n";
		if ( typeof value == "array" ) {
			Text += "  [";
			for ( local idx = 0; idx &lt; value.len()-1; idx++ ) {
				Text += value[idx] + ", ";
			}
			if ( value.len() &gt; 0 )
				Text += value[value.len()-1];
			Text += "]\n";
		}
		else if ( typeof value == "table" ) {
			foreach( name2, value2 in value ) {
				Text += "  " + name + ": " + value + ",\n";
			}
		}
	}
	return Text;
}

print( InfoFunc() );

// name: InfoFunc
// defparams: (array : 0x00571480)
//   []
// native: false
// varargs: 0
// src: fun.nut
// parameters: (array : 0x00571270)
//   [this]</pre>

**name:** The function name.
  
**defparams:** The list of default parameter values (if any)
  
**native:** Is it a native C function or Squirrel function?
  
**varargs:** How many varadic arguments (printf style).
  
**src:** What file it comes from.
  
**parameters:** Names of the parameters (NOT values, just names).

**NOTE:** Native C functions return a different set of results. name, native, paramscheck and typecheck.

## Missing _tostring pointers

The returned string "(table : 0x00112340)" is actually a sort of error code. It implies that no _tostring member of the delegate is available.

AFAIK, there is no way to get the pointer value of a table from inside Squirrel (on the stack?). I should look in to this some day, but I'm not interested right now.

## String Syntax is "" only, not ''

When it comes to strings, Squirrel has roots in C, and opts for the C syntax for string creation. This means **"this string"** is valid, but **'this other string'** is not. Squirrel treats **''** strings as ASCII values, like **'A'**, which returns the an integer value equal to the character code.

## Standalone Contexts

Okay! This is the important part for engine designers that want to scope things to game objects.

Key things to know:

  1. A Squirrel script file can be thought of as one big function
  2. The default value of "this" is the root table, but that's only the default

On that note, I'm going to change the definition of one of the earlier examples.

<pre class="lang:default decode:true " >Scooter &lt;- 10;          // Environment Table //
//::Scooter &lt;- 10;      // Root Table (Globals) //
//const Scooter = 10;   // Const Table (Global Constants) //
//local Scooter = 10;   // Stack //

function Hello() {
	if ( "Scooter" in this )
		error( "is in this\n" );

	if ( "Scooter" in getroottable() )
		error( "is on Root\n" );

	if ( "Scooter" in getconsttable() )
		error( "is on Const\n" );

	if ( "Scooter" in getstackinfos(1).locals )
		error( " is on Stack\n" );
}
	
Hello();

// Output: is in this\n is on Root\n</pre>

If this is called as is, the current Environment is the root table, so it will find Scooter in both this and the Root table. 

To change the environment, wrap this code in a function (or do the equivalent), bind a different environment, then call the wrapper function. The reason we need to bind first before calling is so that all our references to the new environment correctly resolve to the environment, and not the root table.

<pre class="lang:default decode:true " >function MyStandaloneEnv() {
	Scooter &lt;- 10;          // Environment Table //
	//::Scooter &lt;- 10;      // Root Table (Globals) //
	//const Scooter = 10;   // Const Table (Global Constants) //
	//local Scooter = 10;   // Stack //
	
	function Hello() {
		if ( "Scooter" in this )
			error( "is in this\n" );
	
		if ( "Scooter" in getroottable() )
			error( "is on Root\n" );
	
		if ( "Scooter" in getconsttable() )
			error( "is on Const\n" );
	
		if ( "Scooter" in getstackinfos(1).locals )
			error( " is on Stack\n" );
	}
		
	Hello();

	return this; // **NEW**: If you don't return this, all our efforts are wasted
}

MyEnv &lt;- {};
MyEnv = MyStandaloneEnv.bindenv(MyEnv)(); // Bind, then call (the "()" ) //

// Output: is in this</pre>

In the example above I'm calling Hello() inside the function, but it can now be safely called outside using:

<pre class="lang:default decode:true " >MyEnv.Hello();</pre>

And it will correctly set the Environment to MyEnv

Things to remember:

  1. local variables inside the MyStandaloneEnv function disappear at the end.
  2. ::MyVar syntax is for accessing the root table (globals), not the environment.
  3. Variable search order is local first, then environment, then globals (root/const).
  4. When I said earlier that bindenv forces the "this" to be what you bind no matter what, what I neglected to say is that it only applies to the wrapping function itself. So any functions defined inside your environment, your this'es will work as expected (member, argument to call, or the current environment). If this makes no sense, just ignore it.