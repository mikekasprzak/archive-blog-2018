---
id: 6758
title: C++ typeof vs decltype
date: 2014-01-25T22:07:13+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6758
permalink: /2014/01/25/c-typeof-vs-decltype/
categories:
  - Technobabble
---
GCC and compatible (Clang) compilers implement a feature known as **typeof** (or **\_\_typeof\_\_**).

<pre class="lang:default decode:true " >struct Bork {
    typedef int Type;
    Type a, b, c;
};

int main(int argc, char* argv[]) {
    Bork MyBork;
    typeof(MyBork) MyOtherBork;
    Bork::Type N1;

    return 0;
}</pre>

<http://gcc.gnu.org/onlinedocs/gcc/Typeof.html>

This is a pre C++11 feature, omitted from the standard, and is unavailable Visual C++.

For the most part it does what you&#8217;d expect. Given a variable, it returns the type. This lets you create another instance of a type without having to use its full name. This is helpful if you happen to be using templates.

Regrettably, **typeof** seems to be somewhat flawed.

<pre class="lang:default decode:true " >template &lt;typename T>
struct Bork {
    typedef T Type;
    Type a, b, c;
};
typedef Bork&lt;int> BorkI;

int main(int argc, char* argv[]) {
    BorkI MyBork;
    typeof(MyBork) MyOtherBork;
    typeof(MyBork)::Type N1;     // NOT LEGAL!! //
    MyBork::Type         N2;     // NOT LEGAL (And never will be) //
    typeof(MyBork.a)     N3;     // Works, but may not read as you'd want //

    return 0;
}</pre>

Generally speaking, there is no way using **typeof** to read type members (typedefs, structs, unions, classes).

As of C++11, a new keyword **decltype** was introduced. It is functionally the same as **typeof**, but the case shown above works. It has been available since GCC 4.3 (2008) and Visual C++ 2010.

<pre>int main(int argc, char* argv[]) {
    BorkI MyBork;
    decltype(MyBork) MyOtherBork;
    decltype(MyBork)::Type N1;     // Works! //
    decltype(MyBork.a)     N3;

    return 0;
}</pre>

In practice, you&#8217;re often using this in conjunction with an assignment. So if you have C++11 available, you may as well just use an **auto**.

<pre>int main(int argc, char* argv[]) {
    BorkI MyBork;
    decltype(MyBork) MyOtherBork;
    auto N1 = MyBork.a;            // Better //

    return 0;
}</pre>

\*sigh\*&#8230; I wish a _certain company_ didn&#8217;t use GHS Multi, so I could &#8230; you know, use **decltype** and **auto**. 😉