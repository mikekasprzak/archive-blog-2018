---
id: 9628
title: 'Notes: CORS, the thing you wish you could ignore'
date: 2016-11-19T04:33:43+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9628
permalink: /2016/11/19/notes-cors-the-thing-you-wish-you-could-ignore/
categories:
  - Uncategorized
---
It&#8217;s 2016, and that means security&#8230; even if it&#8217;s just sandboxing.

Modern web browsers implement a protocol called CORS, i.e. Cross-Origin Resource Sharing. This is a fancy protocol that gives a web browser hints that a transaction should be allowed or not. It was a few years ago that for the sake of security, browsers switched from trusting every request to trusting no request. For the sake of compatibility, some requests are still honoured (HEAD, GET, POST with specific content-types), but some of the most useful ones are not.

Combined with Fetch, the modern/correct way to fetch data from the internet in current browsers (previously XmlHttpRequest), this can messy. But hey, it&#8217;s for the greater good&#8230; I guess.

## Fetch, Promises and Lambda Arrow Functions

JavaScript&#8217;s new **Fetch** method is the recommended way to handle what we used to call &#8220;XHR&#8221; requests (i.e. getting data by URL) for any new code that&#8217;s written. It&#8217;s supported by all the major current browsers, and can be polyfilled for backwards compatibility.

<https://developer.mozilla.org/en-US/docs/Web/API/GlobalFetch/fetch>

The old way (&#8220;XHR&#8221;) was inelegant, and poorly named (XML HTTP Request). **Fetch** has a much improved syntax.

Fetch relies on another modern JavaScript feature: **Promises**. Promises let you wire up code that can be run asynchronously immediately after (in this case) the Fetch completes, be it a success or failure. As with Fetch, this can be introduced in older browsers with a Polyfill.

<https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Global_Objects/Promise>

Furthermore, Promises benefit from another modern JavaScript feature: **Lambda Functions** or **Arrow Functions** as they&#8217;re sometimes called. In essense, this a new syntax for creating functions in JavaScript. Unlike Fetch and Promises, **Lambda Functions** cannot be added to JavaScript with a Polyfill. They require a modern JavaScript compiler (or transpiler) to add them in a compatible way.

<pre class="lang:default decode:true " ># Normal Syntax
var MyFunc = function(arg) { return arg+arg; }

# Lambda/Arrow Function Syntax
var MyFunc = arg =&gt; arg+arg;      // Exactly the same. Function returns arg+arg

# Variants
var MyFunc = arg =&gt; { return arg+arg; };               // You can be more verbose
var MyFunc = (arg1, arg2) =&gt; arg1+arg2;                // Pass Multiple Arguments
var MyFunc = () =&gt; { console.log('hey'); return 25; }  // No Arguments, do multiple things
</pre>

Or any combination of the above.

<https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Functions/Arrow_functions>

And these can be further enhanced with some new features.

Rest parameters (i.e. &#8220;the rest of&#8221;), which let you write varadic functions.

<pre class="lang:default decode:true " >var MakeArray = (...args) =&gt; args;</pre>

<https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters>

As well as Destructuring, a new syntax that lets you expand or extract data from arrays.

<https://developer.mozilla.org/en/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment>

And at the time of this writing, Rest Destructuring is starting to pop up as a feature (currently unsupported in Buble, without a patch&#8230; a patch that exists, and is one click away from being merged in, tee hee).

## Legacy Fetch Support

We can do a number of things without worring about Preflights or Cookies, but we still need a CORS header (Access-Control-Allow-Origin). These also work if the origin (protocol+domain) is the same, but CORS is the whole mess when origins (protocol+domain) differ.

<pre class="lang:default decode:true " ># HTTP GET
fetch("http://blah.com/file");
fetch("http://blah.com/file", {method: 'GET'});

# HTTP HEAD
fetch("http://blah.com/file", {method: 'HEAD'});
</pre>

You can also do **HTTP POST**, but when we start talking **HTTP POST**, we need to start caring about **content-type**.

In legacy mode, **HTTP POST** only supports 3 different content types. 

  * text/plain
  * multipart/form-data
  * application/x-www-form-urlencoded

That doesn&#8217;t mean you can&#8217;t use other content-types, but it introduces a new &#8220;feature&#8221; that we&#8217;ll get to soon.

<pre class="lang:default decode:true " ># NOTE: PHP routes the body to php://stdin, and not $_POST
fetch( "http://blah.com/file", {
	method: 'POST',
	headers: {
		'Content-Type': 'text/plain',
	},
	body: "hello world"
})

# I wasn't able to get multipart/form-data woring easily (responses are weird looking)

# This however will populate $_POST with data
var data = {
	a: 10,
	b: true,
	c: "stringy"
};

fetch( "http://blah.com/file", {
	method: 'POST',
	headers: {
		'Content-Type': 'application/x-www-form-urlencoded',
	},
	body: Object.keys(data).map((key) =&gt; {
		return encodeURIComponent(key) + '=' + encodeURIComponent(data[key]);
	}).join('&')
})</pre>

## Bypassing CORS

There is a mode you can set&#8230;

<pre class="lang:default decode:true " >fetch( "http://blah.com/file", {
	method: 'POST',
	headers: {
		'Content-Type': 'text/plain',
		'mode': 'no-cors'
	},
	body: "hello world"
})</pre>

But this is effectively the same as a **HEAD** request. It will correctly pass (.then) or fail (.catch) depending on the response code, but you can&#8217;t look at data.

Not very useful, &#8216;eh?

<https://jakearchibald.com/2015/thats-so-fetch/>

## Preflights (i.e. the HTTP OPTIONS request)

To make matters worse, if you want to be modern and use an alternative content type (such as `application/json`), you now need to handle OPTIONS headers.

[https://developer.mozilla.org/en-US/docs/Web/HTTP/Access\_control\_CORS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Access_control_CORS)

That means JavaScript now does 2 HTTP requests per transaction. The first, an HTTP OPTIONS request, and if that succeeds, your actual requested request (HTTP GET, POST, PUT, etc).

This is the ideal case. If server handles these, then you can write optimal Fetch code.

<pre class="lang:default decode:true " >fetch('https://blah.com/submit-json', {
	method: 'post',
	body: JSON.stringify({
		email: document.getElementById('email').value
		answer: document.getElementById('answer').value
	})
});</pre>

Unfortunately if you PHP, the content type for the above is `application/json`, which is routed to **php://stdin** and not the **$_POST** variables you may be used to.

<https://davidwalsh.name/fetch>

## Server Side CORS

Somehow you need to include CORS headers on your server. You can do this with Apache.

<pre class="lang:default decode:true " ># .htaccess
Header set Access-Control-Allow-Origin "http://blah.com"
Header set Access-Control-Allow-Credentials "true"
Header set Access-Control-Allow-Headers "content-type"

# NOTE: Apache probably has a variable I can use in the place of blah.com (the requester)
</pre>

Or as part of the code that emits stuff.

<pre class="lang:default decode:true " >// PHP
header('Access-Control-Allow-Origin: '.$_SERVER['HTTP_ORIGIN']);
header('Access-Control-Allow-Credentials: true');
header('Access-Control-Allow-Headers: content-type');
</pre>

If you only need basic CORS support (no cookies), you can be simple with your headers.

<pre class="lang:default decode:true " >Access-Control-Allow-Origin: *</pre>

If you require cookies, you **NEED** to be specific about the origin.

<pre class="lang:default decode:true " >Access-Control-Allow-Origin: http://site.com
Access-Control-Allow-Credentials: true
Access-Control-Allow-Headers: content-type
</pre>

If you are not specific about the origin, **it will fail**.

<https://fetch.spec.whatwg.org/#cors-protocol-and-credentials>

Fact, this fail case is the reason this post exists. Gawd. I spent way too long trying to diagnose this, with no really good references. I had to dig through the spec to find this line:

> If credentials mode is &#8220;include&#8221;, then \`Access-Control-Allow-Origin\` cannot be \`*\`.

In hindsight, now that I knew what I was looking for, I did find a PHP example how to do it correctly.

<http://stackoverflow.com/a/9866124/5678759>

LOL.

<https://www.html5rocks.com/en/tutorials/cors/>

Anyways, I think I&#8217;ve suffered through CORS enough now. Like always, this post is here so when I have to revisit the topic (uploads), I&#8217;ll know where to start (configure server to `Allow-Origin: *` (i.e. readonly GET requests), but get specific in the PHP upload script so that credentials matter (PUT/POST)). (PS: I could stop hot-linking if Allow-Origin was specific to Jammer sites).