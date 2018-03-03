---
title: Tracking Jekyll to Wordpress (Markdownify) issues
date: '2018-03-03 00:06:12'
layout: post
---

Digging a little deeper, it looks like things here haven't exactly converted over exactly as I wanted them. 

Also, in the future we are going to need a means of converting WordPress posts to Ludum Dare data, and this is a good place to start. i.e. Use [Markdownify](https://github.com/Elephant418/Markdownify).

### **YouTube** videos are missing

Interestingly, **YouTube** support on GitHub is handled by `<iframe>` tags, which are allowed.

I managed to fix this problem myself, by introducing a small hack to Markdownify. Here's a patch:

[https://github.com/benbalter/wordpress-to-jekyll-exporter/pull/115](https://github.com/benbalter/wordpress-to-jekyll-exporter/pull/115)

So technically, this one is fixed. 

**ALSO**: This fixed an HTML5 graphic demo embed. [https://toonormal.com/2014/08/21/phat-js-demo/](https://toonormal.com/2014/08/21/phat-js-demo/)

**ALSO**: A Vine Video embed is broken, since vine no longer exists. [http://localhost:4000/2014/01/06/quadruped-animation-test/](http://localhost:4000/2014/01/06/quadruped-animation-test/)

Change the embed to this:

[https://junk.mikekasprzak.com/vine/videos/1031923650816806912.mp4](https://junk.mikekasprzak.com/vine/videos/1031923650816806912.mp4)

### Ocassional direct URL
I've prepared a shell script to fix my files.

```bash
#!/bin/sh

find _posts/ -type f -exec sed -i 's/http:\/\/blog.toonormal.com//g' {} \;
```

Where `http://blog.toonormal.com` begins some URLs, and that needs to stop.

**ALSO**: An HTML5 graphic demo embed needed fixing. [https://toonormal.com/2014/08/21/phat-js-demo/](https://toonormal.com/2014/08/21/phat-js-demo/)

The original pointed to an `http://` URL. It was changed to `//`, because HTTPS is allowed.

### Source Code incorrectly being converted

I didn't notice at first, but it turns out ALL the source code I merged over is incorrect.

I rely on a WordPress plugin called **Crayon**. Crayon unfortunately made some mistakes in its implementation of preformatted source code blocks. They used `<pre>` tags, but according to the HTML spec you're supposed to use `<pre><code>` tags together. Oops!

On the plus side, I never used `<pre>` tags anywhere I didn't want source code. When I added `<pre><code>` tag pairs by hand, it didn't break the output of **Crayon**, so it might be possible to do something scary to fix this (regex). Something like replace `<pre` with `<pre><code`, noting that the **Crayon** `<pre>` tags are often longer (i.e. `<pre class="lang:default decode:true " >`).

Tracking down the issue I've been testing with this post:

Here's a post I've been working to convert: [/2012/10/18/http-get-and-posts-from-scratch-with-sockets/](/2012/10/18/http-get-and-posts-from-scratch-with-sockets/)

Here's the live version: [http://blog.toonormal.com/2012/10/18/http-get-and-posts-from-scratch-with-sockets/](http://blog.toonormal.com/2012/10/18/http-get-and-posts-from-scratch-with-sockets/)

And the original: [http://blog.toonormal.com/wp-admin/revision.php?revision=5546](http://blog.toonormal.com/wp-admin/revision.php?revision=5546)

At the time of this writing, this is still an issue.

### Missing HTML tags in code blocks
This same post is throwing away some HTML tags.

[http://blog.toonormal.com/2012/10/18/http-get-and-posts-from-scratch-with-sockets/](http://blog.toonormal.com/2012/10/18/http-get-and-posts-from-scratch-with-sockets/)

`<script>`, `<area>`, `<map>`, and others. Technically these tags should be preserved if they are found within a `<code>` block (or `<pre>` in case of Crayon, but it should really be `<pre><code>`).

At the time of this writing this is still an issue.