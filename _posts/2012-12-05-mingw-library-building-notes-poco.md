---
id: 5743
title: MinGW Library Building Notes (POCO)
date: 2012-12-05T06:09:54+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5743
permalink: /2012/12/05/mingw-library-building-notes-poco/
categories:
  - Technobabble
---
I&#8217;ve been evaluating some new libraries lately and as usual, I decided to take some notes.

## POCO

[POCO](http://pocoproject.org/) seems to be a nice complete C++ library filled with things that other languages like Python and Java have. It&#8217;s very feature filled, but it&#8217;s unfortunately obvious that the development team doesn&#8217;t spend much time working or testing on Windows (and when they do, it&#8217;s with MSVC). There is a MinGW build, but as of **POCO 1.4.5** it&#8217;s designed for Cygwin MinGW, which is a variation of MinGW that you invoke with &#8220;**-mno-cygwin**&#8221; to remove dependence on the Cygwin libraries. No good for a pure [MinGW+MSys](http://www.mingw.org) user like myself.

So, I had to make the following changes to **build/config/MinGW**:

<!--more-->

  1. Removed both instances of **-mno-cygwin** (SYSFLAGS, SYSLIBS)
  2. Remove **-I/usr/include** from SYSFLAGS and **-L/usr/lib** from SYSLIBS
  3. Add **-I/usr/local/ssl/include** to SYSFLAGS and **-L/usr/local/ssl/lib** to SYSLIBS

**#1** I&#8217;ve explained. MinGW+MSys does not support **-mno-cygwin**, and raises an error. Oops. 🙂

**#2** is the search paths of the MSys libraries, not the MinGW ones. POCO relies on iconv, which is an internationalization library that is implemented slightly differently for MSys. We don&#8217;t want to use the MSys version. With that in mind, we probably need to install iconv for MinGW. From your MSys shell, do the following:

<pre class="lang:default decode:true " >mingw-get install libiconv</pre>

After a brief download, you&#8217;ll now have the MinGW version of iconv.

**#3** is where OpenSSL installs itself, unusually, inside its own directory tree. If you want to SSL support, you will need to download and install OpenSSL. Latest sources are here:

<http://www.openssl.org/source/>

Then OpenSSL is a typical &#8220;**./configure; make; make install**&#8221; package. TIP: If you have a multi-core CPU, doing &#8220;make -j 2&#8221; builds using 2 cores, and &#8220;make -j 4&#8221; builds using 4 cores.

Great. We&#8217;re now done with the setup, so it&#8217;s time to invoke the configure script.

Now unfortunately, at least with POCO 1.4.5, the testsuite and samples are again not set up properly for MinGW+MSys, so they need to be disabled. So, your &#8220;./configure; make; make install&#8221; should look something like this:

<pre class="lang:default decode:true " >./configure --no-tests --no-samples
make -j 2
make install</pre>

The &#8220;-j 2&#8221; is optional, but most of us have multi-core CPU&#8217;s, so it should cut your build times in half.

And that&#8217;s it. POCO should now be installed in **/usr/local/include/Poco**. Go read the docs:

<http://pocoproject.org/documentation/index.html>

Link -lPocoFoundation -lPocoNet -lPocoUtil -lPocoXML as needed.

If you don&#8217;t already, be sure to use **-I/usr/local/include** on your compiles and **-L/usr/local/lib** on your linking, since MinGW does not add those paths by default (since MinGW is designed to be standalone).

## APR

The Apache Portable Runtime (APR) is another library I was looking in to. It&#8217;s C based, and used heavily in the Apache Web server. It consists of 3 packages: APR, APR-util, APR-iconv. For whatever reason I had no troubles building APR, but the other two. After a bit of digging, I seemed to come across some discussion that said fixes for MinGW were part of the upcoming 1.5 build (1.4 currently available). 

I&#8217;m not quite interested in working with such a bleeding edge library though, so for the time being I&#8217;ve put APR aside.