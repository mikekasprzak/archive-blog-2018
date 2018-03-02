---
id: 6031
title: Nice efficiency things about JavaScript
date: 2013-05-05T15:03:01+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6031
permalink: /2013/05/05/nice-efficiency-things-about-javascript/
categories:
  - Technobabble
---
So I&#8217;m typically a native C/C++ programmer, and I seem to surprise people when I say I like JavaScript yet dislike C# and Java. What I like about JavaScript is that it does things C and C++ don&#8217;t, as opposed to C# and Java that take C++ and as a base and enforce new constraints to &#8220;simplify&#8221; code. Both C# and Java do improve on C++, but I find the new strictness they impose to be a detriment or intermediary fix. I think if the point make you write code faster, then JavaScript does a better job.

That said, JavaScript does has its flaws and limits. It&#8217;s typically limited to the web, but it is the programming language of the web. Still as programmers looking for that programming zen, I think JavaScript is far closer to that zen than many other languages.

**NOTE:** When I say efficiency, I mean in getting things done, **not performance**.

## JavaScript is not Java. Stop thinking it is!

Not at all. Easily the #1 misconception, but EcmaScript just isn&#8217;t as marketable a name as JavaScript.

The main way I like to illustrate how JavaScript took a better turn is when it comes to writing the simplest program you can in the language: The classic Hello World.

<pre class="lang:default decode:true " title="Hello World in Java" >public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}</pre>

C# too:

<pre class="lang:default decode:true " title="Hello World in C#" >public class HelloWorld {
    public static void Main() {
        System.Console.WriteLine("Hello World");
    }
}</pre>

Really, it&#8217;s just a coding style difference between the two.

To compare, a simple Hello World in JavaScript is:

<pre class="lang:default decode:true " title="The JavaScript version" >console.log("Hello World");</pre>

One line of code. 

It may not seem like much, but I think this is incredibly important. 

To compare, here&#8217;s the C version:

<pre class="lang:default decode:true " title="The C version" >#include &lt;iostream.h&gt;
int main( int argc, char* argv[] ) {
	printf("Hello World");
}</pre>

Yes, the C version is only 1 line longer, but a better parallel would be this:

<pre class="lang:default decode:true " title="Hello World in Java" >import System.*;
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello World");
    }
}</pre>

The import line is implied by Java and C#. I&#8217;d say the C version makes more sense, since there is nothing implied. Nothing done for you without asking.

That said, auto-importing is good. I&#8217;d say JavaScript does this better because everything in the standard library is auto-imported. Not to mention, the code is executed as it appears, so there&#8217;s no need for a main function. The entire source file if executed is main.

Languages like Java and C# sometimes get around this initial verbosity with the tools. Your IDE, once you go File->New Project will generate your basic structure for you. And that&#8217;s fine, but it&#8217;s not really more efficient enforcing a structure/hierarchy when it comes to something simple.

## Automatic Types

<pre class="lang:default decode:true " >var Text = "Hello"; // string //
var Number = 25; // number //
var Pie = 3.14; // number //
var Truth = true; // boolean //
var Func = function() { return "Hello"; }; // function //
var Nothing = null; // null //
var MyArray = []; // array //
var MyObject = {}; // object //</pre>

This is a bit of a subtle thing, but knowing and dealing with the type isn&#8217;t really that important if everything is a number or string anyway. And again, ignoring performance, being able to set a number actually equal to null is nice because it doesn&#8217;t waste numerical space (well, the space is already wasted due to everything being a reference). That doesn&#8217;t matter though.

## Nested Arrays and Objects (Tables)

**This** is what matters. Because all types are implied based on the values you hardcode, that makes hardcoding a sophisticated structure extremely simple. You&#8217;re not wasting time building classes, you&#8217;re building exactly what you want, and changing it exactly when you need to. Added a new property? No problem, it&#8217;s already allowed, and you can just go implement it.

<pre class="lang:default decode:true " >var ArtFiles = [
	{ name:"Man", value:"art/dude_anims.png", tile_w:128, tile_h:128, anchor_y:128 },
	
	{ name:"BG1", value:"art/toombg_bg_01.png" },
	{ name:"BG2", value:"art/toombg_para_01.png" },
];</pre>

I didn&#8217;t have to go make a class for the ArtFile Objects, nor did I have to write all permutations of constructors to take only the arguments I wanted. I just hardcoded what I want. In my code that uses the ArtFile Objects, I check if certain properties exist, and if they do do something, otherwise use what I&#8217;ve decided is the default.

To use the data it&#8217;s as simple as:

<pre class="lang:default decode:true " >console.log( ArtFiles[0].name );</pre>

This saves so much time. No fuddling around types, just fill in what you want and you&#8217;re done.

That said, I think how we check for missing properties in JavaScript is a tad more clumsy than it should be.

<pre class="lang:default decode:true " >if ( ArtFiles[0].hasOwnProperty('anchor_y') ) {
    // Do Stuff //
}</pre>

That kinda makes sense, and we have to do it this way due to how inheritance sort-of works, but it could be cleaner.

For example, in Squirrel:

<pre class="lang:default decode:true " >// Squirrel, not JavaScript //
if ( "anchor_y" in ArtFiles[0] ) {
    // Do Stuff //
}</pre>

I think this is a nicer syntax.

## Generic Owner-less Functions

<pre class="lang:default decode:true " >function GetMyName() {
    return this.name;
}</pre>

This can be created at the global scope, and given to any object.

<pre class="lang:default decode:true " >var ArtFiles = [
	{ name:"BG1", value:"art/toombg_bg_01.png", GetName:GetMyName },
	{ name:"BG2", value:"art/toombg_para_01.png", GetName:GetMyName },
];</pre>

And thus called:

<pre class="lang:default decode:true " >console.log( ArtFiles[0].GetName() );</pre>

It can also be cleanly applied to any object, without adding it to the object.

<pre class="lang:default decode:true " >var ArtFiles = [
	{ name:"BG1", value:"art/toombg_bg_01.png" },
	{ name:"BG2", value:"art/toombg_para_01.png" },
];

console.log( GetMyName.call(ArtFiles[0]) );</pre>

Where the first argument to call is what to use as &#8216;this&#8217;.

## Anonymous Functions

<pre class="lang:default decode:true " >var ArtFiles = [
	{ name:"BG1", value:"art/bg1.png", onaction:function(){console.log("AWESOME");} },
	{ name:"BG2", value:"art/bg2.png" },
];</pre>

Only BG1 is awesome, so why waste time adding a short global function only used once?

## No Function/Variable Prototypes or Externals Required

JavaScript code is executed in linear order. Functions are declared, but unused until called. Therefor, as long as all your functions get defined before the first is called, then your references to each-other work as expected. No funny circular include/extern logic required.

<pre class="lang:default decode:true " >function Parent() {
	return "Parent " + Child();
}

//console.log( Parent() ); // Fail //

function Child() {
	return "Child";
}

console.log( Parent() ); // Okay //</pre>

## Global Scope

One of the first things you learn about Object Oriented Programming is that the Global Scope is bad. Yes, the Global Scope is bad&#8230; a bad place to put local and member variables, but it&#8217;s an awesomely efficient way to access things. In C/C++, global variables resolve down to a single pointer reference to where the data is in memory, rather than a pointer reference/offset for every level deep it is. Nobody really cares about the few cycles lost resolving an address anymore, but it&#8217;s still worth knowing that globals are fast, and back in the day that was sometimes why you used them.

That said, care must be taken when dealing with objects in the Global Scope. You have to be sure you choose names that don&#8217;t conflict with other things in the Global Scope, such as standard libraries. If you can do that, you can end up creating simpler code too.

<pre class="lang:default decode:true " >var Player = new cPlayer(); // Probably best in a GameInit Function, but proves the point //

var RoomBGLayer = [
	{ img:"Couch",x:-320,y:78,onaction:function(){Player.SetState(ST.SIT_COUCH);} },

	{ img:"Table",x:-170,y:78 },

	{ img:"Head",id:"Head2",x:-178,y:78-38,active:false },
	{ img:"Meat",id:"Meat2",x:-178,y:78-38,active:false },
	{ img:"Soda",id:"Soda2",x:-186,y:78-38,active:false },
];</pre>

I just told the player to set his &#8220;Sit on the Couch&#8221; state and animation on the same line of code I defined where the couch is in the world, and what artwork to use. 

**That** is the magic of Global Scope and Anonymous Functions in action.

## Need to add a state or property? Add it when needed!

You \*could\* create a structure to store states, or edit the base class to include a state and default state.

&#8230; or you could just add it as needed.

<pre class="lang:default decode:true " >function DoLayerItem( item ) {
    if ( !item.hasOwnProperty('state') ) {
        item.state = 0; // lets say the default state is 0 //
    }

    if ( item.state == 0 ) {
        // Do State 0 //
    }
    else if ( item.state == 1 ) {
        // Do State 1 //
    }
}

DoLayerItem( RoomBGLayer[0] );</pre>

For efficiency, you probably want to populate your data with states, missing properties, etc during some initialization stage, but the above demonstrates the point.

## TODO: Add More

I&#8217;m going to add more examples as I think of them. I blog for me as much as anyone that reads them.

## Problems of JavaScript

JavaScript isn&#8217;t perfect. No programming language is. I&#8217;ve already mentioned my &#8220;hasOwnProperty&#8221; beef, but there are more.

## Problem 1: No Operator Overloading

This is the one crappy part of JavaScript that I just can&#8217;t fix. I like having a Vector class, and I like that Vector class to do math easily with operators like +, -, *, and so on.

That said, Squirrel to the rescue.

## Conclusion

These are some of the key reasons I like JavaScript. C/C++ does a lot of the same stuff Java/C# does, but Java/C# prove you a better language by constraining and restricting you (one String type, everything a class, everything in specific folders). They also give you a far better set of starting libraries. C/C++ definitely fail at providing a good stock libraries, but that is part of the point. 

C and C++ are fundamental, like a better Assembly. You can write C/C++ code and know the assembly it will generate. If you don&#8217;t care about the generated code at that level, then that&#8217;s fine. I just don&#8217;t think Java and C# do enough to provide a core language that&#8217;s faster to work in.

## Squirrel?

If you ask me about scripting languages, you&#8217;ll probably get a glowing recommendation of Squirrel out me. It seems to fix most of the things I don&#8217;t like about JavaScript, from having separate Integer and Float types, 32bit instead of 64bit, operator overloading, nicer property checking syntax, and so on.

That said, I haven&#8217;t made a serious project with Squirrel&#8230; yet.

I have done projects with JavaScript, I really like a lot of things about JavaScript (as you can see above). JavaScript targets the web, which is a huge advantage, but also a disadvantage. 

I&#8217;ve done some simple experiments with Chrome&#8217;s V8. It works, and I like it. But when I&#8217;m writing games, I really use vector math a lot&#8230; A LOT&#8230; HOLY!

So that&#8217;s the trade off. I can have a language that&#8217;s web compatible (JavaScript), or one more game dev specific (Squirrel). Using Squirrel does keep me off the web (unless using NaCl, FlasCC, or Emscripten). I dunno. Web technology is in a bit of flux right now. 

That said, I like JavaScript. It&#8217;s different enough from C/C++/C#/Java that it can do some things better.