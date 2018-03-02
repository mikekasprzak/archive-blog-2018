---
id: 7014
title: Dialogs as Functions
date: 2014-07-16T15:03:44+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=7014
permalink: /2014/07/16/dialogs-as-functions/
categories:
  - Technobabble
---
This is just an idea I&#8217;ve had. I wanted to write it down in some meaningful way so that I can rediscover it later. This is less a C++&#8217;ism, and more a JavaScript/Squirrel&#8217;ism.

\* \* *

In any situation where your user interface presents a popup dialog, that process of presenting the dialog should be a function call. Here is pseudocode:

<pre>function Dialog_YesNoCancel( Args ) {
	if ( Args == null ) {
		Args = ShowDialog_YesNoCancel();
		if ( Args == null )
			return false;	// Cancel state makes Args null, so return out, doing nothing //
	}

	// Handle State! //
	if ( Args.State ) {
		// Yes State //
	}
	else {
		// No State //
	}

	return true;	// We successfully did something //
}</pre>

The general idea here is that there should be 2 ways to use the function: 1. Without arguments, to bring up the entry dialog; 2. With arguments, to bypass the entry dialog (for macro/scripting use). The data in extracted from the function arguments, or the shown dialog, and the action is taken place.

Args should be the language equivalent of an object (JavaScript, Squirrel, etc). Alternatively, an array of objects could work too, but named elements would result in nicer code. Like above, it&#8217;s assumed a Yes/No/Cancel dialog would store a boolean named State to tell you which (Yes or No) was picked. 

The above assumes a synchronous environment, where it&#8217;s safe to give a function &#8220;ShowDialog_YesNoCancel&#8221; full control. 

In an asynchronous environment, you&#8217;ll want to use something like a Deferred or Future. If there are no arguments, the ShowDialog function will provide the object you bind your State handling function to. Otherwise, bind it to one that will succeed.

Alternatively, there are probably nice ways to handle this using coroutines or generators.