---
id: 6298
title: Squirrel Class Notes
date: 2013-11-08T00:24:14+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6298
permalink: /2013/11/08/squirrel-class-notes/
categories:
  - Qk
  - Squirrel
---
Squirrel features both Delegates and Classes for creating types and providing default values and actions. They are mutually exclusive, meaning you either use a class or a delegate (attached to a table/array). 

The following is a collection of notes on Classes.

## Sample Class

The class below features a constructor, metamethods (like operator overloading), and a few additional functions.

<pre class="lang:default decode:true " >class vec2 {
	x = 0.0;
	y = 0.0;

	// with "..." as an argument, you get an array named vargv. //
	constructor (...) {
		if ( vargv.len() &gt;= 2 ) {
			x = vargv[0];
			y = vargv[1];
		}
	}
	
	// + and += operator //
	function _add(vs) {
		return ::vec2( x+vs.x, y+vs.y );
	}

	// _sub, _mul, _div go here //
	
	// negative operator //
	function _unm() {
		return ::vec2( -x, -y );
	}
	
	// name to return with typeof //
	function _typeof() {
		return "vec2";
	}

	// What gets printed when we print this. //
	function _tostring() {
		return "(" + x + "," + y + ")";
	}
	
	// a potentially useful function, at least for this class. //
	function toarray() {
		return [x,y];
	}

	function dot(vs) {
		return (x*vs.x) + (y*vs.y);
	}
		
	function tangent() {
		return ::vec2( y, -x );
	}
}</pre>

## Create instances with function syntax

Creating an instance is a lot like JavaScript.

<pre class="lang:default decode:true " >local MyVar = vec2(10,10);</pre>

The constructor is called with mentioned arguments.

Not to be confused with the _call metamethod.

<pre class="lang:default decode:true " >function _call( original_this, ... ) {
    print("I have soooo many arguments. A whole " + vargv.len() );
}

// ... //

local MyInstance = MyClass();   // Constructor //
MyInstance();                   // _call metamethod //</pre>

## Problems to consider: Functions are not overloaded, but replaced

In C++ and GLSL/HLSL, it&#8217;s common to have operators overloaded that let you Add, Subtract, and Multiply vectors by other vectors, scalars and matrices. This can (mostly) be done in squirrel by looking at the type of the argument received by your metamethods. Here&#8217;s an example that supports scalar multiplication as well as vector multiplication (component wise).

<pre class="lang:default decode:true " >function _mul(vs) {
		if ( typeof vs == "integer" )
			vs = vs.tofloat();
		if ( typeof vs == "float" )
			return ::vec3( x*vs, y*vs, z*vs );
		return ::vec3( x*vs.x, y*vs.y, z*vs.z );
	}</pre>

The problem though is this is one way. I can do &#8220;MyVec \* 10&#8221;, but &#8220;10 \* MyVec&#8221; will not work. To make it work, you would have to add a custom _mul metamethod to the number type&#8230; except I&#8217;m not sure that&#8217;s allowed by Squirrel (custom delegates are, but metamethods?).

One solution would be to create a &#8220;real&#8221; type (similar to GEL), but Squirrel doesn&#8217;t exactly provide a nice way to create custom automatic type conversions, so the syntax wouldn&#8217;t be ideal (i.e. real(10) * vec2(10,20) everywhere). I do live with this in GEL, but it would be a shame to not have a cleaner syntax here. This also assumes custom math metamethods are not supported by Squirrel (and technically I have the source, so it&#8217;s not like I couldn&#8217;t add any feature I wanted).

It&#8217;s also a shame the operator code ends up being so complex. A function that started as one line (the last line) has become 5 lines to add float and integer support. Add in Matrix multiplication too, and then I start getting scared.

An alternative solution would be to add .tovec3() and .toscalar3() functions to the default float delegate (where tovec3() is (10,0,0) and toscalar3 is (10,10,10)). This would be a cleaner option, but is somewhat wasteful, especially once we get to higher order maths like Matrix multiplication.

One more option would be to add language level vector and matrix support. After all, a table with x,y,z slots can&#8217;t exactly be the most efficient thing. This would certainly be the most difficult though.

It&#8217;s a shame Squirrel doesn&#8217;t have a way of adding shadow members. Like a MyObject.x() without the brackets that could be assigned (MyObject.x = 10).

I shouldn&#8217;t be expecting a scripting language to be ideal for high performance math anyway. Like I&#8217;ve said, specialization is the key. That is what scripting is for. Leave the low-level to the low-level.

## Copy Constructors: meh

This is inconclusive currently. I may have found a bug with what should be the ideal way of doing it. I&#8217;ve since posted a question [to the forum on it](http://forum.squirrel-lang.org/default.aspx?g=posts&t=3336).

What I would like to do:

<pre class="lang:default decode:true " >// WARNING! THIS DOES NOT ACTUALLY WORK! FOR REFERENCE ONLY! //

class vec2 {
    x = 0.0;
    y = 0.0;
    
    constructor (...) {
        if ( vargv.len() &gt;= 2 ) {
            x = vargv[0];
            y = vargv[1];
        }
        else if ( vargv.len() &gt;= 1 ) {
            if ( typeof vargv[0] == "vec2" ) {
                this = clone vargv[0];
            }
        }
    }

    function _typeof() {
        return "vec2";
    }
};

// WARNING! THIS DOES NOT ACTUALLY WORK! FOR REFERENCE ONLY! //</pre>

What I have to do instead.

<pre class="lang:default decode:true " >class vec2 {
    x = 0.0;
    y = 0.0;
    
    constructor (...) {
        if ( vargv.len() &gt;= 2 ) {
            x = vargv[0];
            y = vargv[1];
        }
        else if ( vargv.len() &gt;= 1 ) {
            if ( typeof vargv[0] == "vec2" ) {
                x = vargv[0].x;
                y = vargv[0].y;
            }
        }
    }

    function _typeof() {
        return "vec2";
    }
};</pre>

This works, but isn&#8217;t as elegant as cloning.

## Weak References

All built-in types have a **.weakref()** function in their delegate (classes, instances, generators, tables, etc). Bools, floats and integers return the actual type, but everything else returns a **weakref** type.

The **weakref** type is exactly that, a type containing a reference. To access the data referenced, you can call the **.ref()** function.

<pre class="lang:default decode:true " >function GainFocus() {
	local MyVec = vec3(10,25,5);
	local MyWeakRef = MyVec.weakref();  // create a weak reference //
	Log( MyWeakRef.ref() );             // vec3.tostring() //
}</pre>

If the data referenced runs out of references, it is recycled. Any **weakref**s pointing to it will thereafter return null.

In addition, Squirrel does some cleverness with **weakref** types. If you omit the **.ref()** call, it will still return the data referenced. For the most part, a **weakref** will act like the real type, except **typeof** will be **weakref** instead of the original type. To get the type referenced, you do **typeof** on the value returned by **.ref()**.

<pre class="lang:default decode:true " >function GainFocus() {
	local MyVec = vec3(10,25,5);
	local MyWeakRef = MyVec.weakref();  // create a weak reference //
	Log( MyWeakRef );                   // vec3.tostring() //
	Log( typeof MyWeakRef );            // weakref //
	Log( MyWeakRef.ref() );             // vec3.tostring() //
	Log( typeof MyWeakRef.ref() );      // vec3 //
	MyVec = "No Longer a vec3";
	Log( MyWeakRef );                   // null.tostring() //
	Log( typeof MyWeakRef );            // weakref //
	Log( MyWeakRef.ref() );             // null.tostring() //
	Log( typeof MyWeakRef.ref() );      // null //
}</pre>

## Strong References

Okay, the reason for the brief exploration of weak references was because of an experiment I was doing with strong references.

<pre class="lang:default decode:true " >function Step() {
	local Pos = vec3(10,25,5);
	local Old = Pos;              // strong reference //
	Log( Old );                   // (10, 25, 5) -- Correct, but... //
}</pre>

Contrary to C++, instead of an assignment operator being called, a strong reference is created. Thus both Pos and Old point to the same data. In this way, Squirrel works like Java/JavaScript/C#, in that everything (other than int/float/bool) are references.

<pre class="lang:default decode:true " >function Step() {
	local Pos = vec3(10,25,5);
	local Old = Pos;            // STRONG REFERENCE! WHOA! //
	Old.x += 0.5;
	Pos.y += 0.25;
	Log( Pos );                 // (10.5, 25.25, 5) -- Yuck! //
}
</pre>

Instead, one should use clone to make a copy.

<pre class="lang:default decode:true " >function Step() {
	local Pos = vec3(10,25,5);
	local Old = clone Pos;      // Copy //
	Old.x += 0.5;
	Pos.y += 0.25;
	Log( Pos );                 // (10, 25.25, 5) -- That's Better! //
}</pre>

Clone performs a shallow copy, meaning all top-level members are copied. Integers, Floats, and Bools work as expected, but most other types are references, which may not be the behavior you desire.

## Cloning Classes

In the case of a class, you can write a simple _cloned metamethod to handle the above case..

<pre class="lang:default decode:true " >class cObject {
	Id = 0;
	Pos = vec3(0,0,0);
	Old = vec3(0,0,0);
	
	function _cloned(orig) {
		// NOTE: Id not required, as it will be correctly copied during the shallow copy
		Pos = clone orig.Pos;
		Old = clone orig.Old;
	}
}</pre>

If a table, you can use a delegate like the following to automatically clone all members.

<pre class="lang:default decode:true " >CloneChildren &lt;- {
	function _cloned( original ) {
		foreach ( idx, val in original ) {
			local Type = typeof val;	// Squirrel raises errors on cloning these types
			if ( (Type != "integer") && (Type != "bool") && (Type != "float") ) {
				this[idx] = clone val;
			}
		}
	}
};

MyTable.setdelegate( CloneChildren );</pre>

## No General Purpose Copier for Classes

The general purpose copier doesn&#8217;t seem to work very well with classes. At least when I was trying to do it, I couldn&#8217;t get it working properly. Here&#8217;s a snapshot.

<pre class="lang:default decode:true " >// WARNING! THIS DOES NOT ACTUALLY WORK! DEMONSTRATION ONLY! //

// Generalized the clone function to be used in both classes and tables
clonemychildren &lt;- function( original ) {
	foreach ( idx, val in original ) {
		local Type = typeof val;
		if ( (Type != "integer") && (Type != "bool") && (Type != "float") ) {
			this[idx] = clone val;
		}
	}
};

// The Table version. Do a .setdelegate( clonechildren ) on your Table. Works fine.
clonechildren &lt;- {
	function _cloned( original ) {
		return clonemychildren.call(this,original);
	}
};

class MyClass {
	Pos = vec3(0,0,0);
	Old = vec3(0,0,0);

	// How this should have worked... //	
	function _cloned(original) {
		clonemychildren.call(this,original);
	}
	
	// However doing a foreach on a class requires one of these... //
	function _nexti(prev) {
		if ( prev == null )
			return 0;
		else
			return prev + 1;
	}
	
	// Which needs one of these... //
	function _get(idx) {
		if ( idx == 0 ) {
			return Pos;
		}
		else if ( idx == 1 ) {
			return Old;
		}
		throw null;
	}
	
	// To be honest, this code isn't working so I don't know if I need this. //
	function len() {
		return 2;
	}
};

// WARNING! THIS DOES NOT ACTUALLY WORK! DEMONSTRATION ONLY! //</pre>

## _get metamethod: are you even useful?

I have this code in my 3D vector class.

<pre class="lang:default decode:true " >function _get(idx) {
		if ( idx == 0 )
			return x;
		else if ( idx == 1 )
			return y;
		else if ( idx == 2 )
			return z;
		throw null;
	}</pre>

It&#8217;ll let you syntactically use the class like an array, but it&#8217;s not an array. So this is fine for inside Squirrel code, but if you have native code expecting an array, these will be useless.