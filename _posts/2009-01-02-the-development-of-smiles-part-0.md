---
id: 408
title: The Development of Smiles, Part 0
date: 2009-01-02T04:54:26+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=408
permalink: /2009/01/02/the-development-of-smiles-part-0/
categories:
  - Blog Series
  - IGF
  - Opinion
  - Pillar Caterpillar
  - Smiles
  - SYK15
  - Technobabble
  - The Spider
---
I know my track record for completing a blog series is pretty lousy, but this one should be easier. I kept a personal log with pictures during the development of **Smiles**, so most of the work is done for me. I just need need to go through it and regurgitate my notes.

To start, I&#8217;m going to give a bit of insight in to what happened when I stopped writing my [**Engines**](/2008/03/01/engines-names-and-evolution-part-1/), [**Names**](/2008/03/04/engines-names-and-evolution-part-2/) **and** [**Evolution**](/2008/03/04/engines-names-and-evolution-part-3/) blog series last year.

I apologize, but I _am_ going to skip a significant follow up to that series for now (the **Hammer** engine), but this series should bring us back up to date.

Here we go.

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

Late 2007 and early 2008 were spent working on libraries, and foundation for my new engine **Playground**.

**Playground** was the successor to **Hammer** (**PuffBOMB HD**&#8230; will talk about this another day), which in turn succeeded [**Freedom**](/2008/03/04/engines-names-and-evolution-part-3/).

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

Before **PuffBOMB HD** was shelved in late 2007 (**Hammer** engine), I was working alone on the project. Amicably, but that&#8217;s a series for another day.

The core issue with **Hammer** is that it wasn&#8217;t very reusable. As a whole, you could certainly build a new project based on it, but it&#8217;s elements were poorly isolated. Triangulation and collision testing code was embedded right in to the physics engine, so I couldn&#8217;t use the same code elsewhere without a lot of waste.

I prototype games regularly, and the product of this year of development (2007) wasn&#8217;t as useful as it could be.

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

Late 2007, I was at a crossroads. I still had savings left, but only enough to support myself. I needed a break from **PuffBOMB HD**, so I coined a new project. A suite of libraries and tools I could personally use for prototyping and developing games faster and more efficiently. The end goal may have been to build a Metroidvania derivative, but the core of the project was to build me some tools. If the project was going to fail again, at least I&#8217;d have a foundation to try the next thing. This was the **Playground** project.

Here&#8217;s where I get technical.

As mentioned, **Playground** is a suite of libraries and tools. It started with me collecting what usable parts I could extract from **Hammer**, and my Ludum Dare games and framework.

I should also mention that by library I&#8217;m referring to an element. A directory of files. Either copy the directory in to a project, or set up an SVN External for it. Only a crazy person would compile their work in progress library to a .lib/.a file and install it. If that&#8217;s you, you&#8217;re crazy! 🙂

One of the first and most useful elements I built was the _Data and Serialization_ library. I decided to finally stop using C++ streams for binary File I/O, but wanted my file reading syntax to be nicer than fopen. The syntax for loading an arbitrary binary file from disk is as follows.

**DataBlock*** MyData **=** _new_DataBlock_( &#8220;Data.bin&#8221; );

Nice and easy. A **DataBlock** is an incredibly useful and lightweight basic type. It represents an arbitrary block of memory with a size stored in the first 4 bytes. It&#8217;s defined as followed.

`<strong>struct</strong> DataBlock {<br />
&nbsp;&nbsp;&nbsp;&nbsp;<strong>size_t</strong> Size;<br />
&nbsp;&nbsp;&nbsp;&nbsp;<strong>char</strong> Data[0];<br />
};` 

Pretty simple. For completion, the _Data and Serialization_ library includes similar calls for normal non **DataBlock** data, but they&#8217;re so lightweight and flexible I use them anyways.

The great part about writing your own I/O wrapper is you can seamlessly integrate things like compression, munging, CRC&#8217;s and checksums. For example, load and decompress a file in 3 lines (one cleanup).

**DataBlock*** Compressed **=** _new_DataBlock_( &#8220;CompressedFile.zlib&#8221; );
  
**DataBlock*** Uncompressed **=** _unpack\_ZLIB\_DataBlock_( Compressed );
  
_delete_DataBlock_( Compressed );

The library is also written in such a way that, while it supports many compressors/hash methods, they are not required to be built or linked against the project unless explicitly used. In other words, if I don&#8217;t use BZIP2, I don&#8217;t need the BZIP2 headers or C files. As lightweight as you can make a library.

The _vector math_ library is borrowed right from **Hammer**, cleaned up and isolated to be vector, scalar, and matrix math only. Types for rectangles and simple primitives are a library. Coding niceties like template types containing a,b,c or r,g,b,a components are a library. Strings, parsing a whitespace delimited file, and debug console logging as well.

Collision tests, and everything you do between primitives is a library of functions. Extremely long names, but they&#8217;re now modular in such a way they can be used in a physics engine, in a primitives library or a GUI/Menu system.

`<strong>if</strong> ( Test_Point_Vs_Polygon2D( ... ) ) ...`

Where this one returns a boolean value. I wont bother listing the arguments, but it&#8217;s a global C-like function. It takes direct types and pointers where appropriate. The functions follow the form &#8220;Action\_What\_Relationship_Who( &#8230; );&#8221;. _Action_ is the operation, _What_ and _Who_ are the terms being tested, and the _Relationship_ is the rest of grammar required to describe the operation.

`Nearest_Point_On_Chain2D( ... );<br />
Nearest_CornerPoint_OnEdgeOf_Polygon3D( ... );`

Where the **Smiles** story begins is the **Grid** library.

**Grid** was a library created for a Ludum Dare game **Pillar Caterpillar**.

Here&#8217;s some concept art.

<center>
  <a href="/wp-content/uploads/2009/01/pillarmockup.png"><img src="/wp-content/uploads/2009/01/pillarmockup-449x337.png" alt="pillarmockup" title="pillarmockup" width="449" height="337" class="alignnone size-medium wp-image-501" srcset="http://blog.toonormal.com/wp-content/uploads/2009/01/pillarmockup-449x337.png 449w, http://blog.toonormal.com/wp-content/uploads/2009/01/pillarmockup.png 760w" sizes="(max-width: 449px) 100vw, 449px" /></a>
</center>

**Pillar Caterpillar** wasn&#8217;t playable within the compo timeline. It however still featured some great pre-production work, and a useful chunk of code that became it&#8217;s own library in **Playground**. Further work was done on the project, but that mock-up is the coolest looking part.

For the time being, only minor changes were done to **Grid**.

&#8211; &#8211; &#8211; &#8211; &#8211; &#8211; &#8211;

Shortly after the iPhone SDK was official announced in March 2008, I started prototyping some game concepts. The first, **Magtraction** (since Magnetica was taken, by a game completely unrelated to magnets).

<center>
  <a href="/wp-content/uploads/2009/01/magshot04.png"><img src="/wp-content/uploads/2009/01/magshot04-450x325.png" alt="magshot04" title="magshot04" width="450" height="325" class="alignnone size-medium wp-image-512" srcset="http://blog.toonormal.com/wp-content/uploads/2009/01/magshot04-450x325.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/01/magshot04.png 486w" sizes="(max-width: 450px) 100vw, 450px" /></a>
</center>

A prototyped game concept deemed &#8220;**too boring**&#8220;.

The second, **Dungeon Legion**.

<center>
  <a href="/wp-content/uploads/2009/01/legionshot04.png"><img src="/wp-content/uploads/2009/01/legionshot04-450x325.png" alt="legionshot04" title="legionshot04" width="450" height="325" class="alignnone size-medium wp-image-513" srcset="http://blog.toonormal.com/wp-content/uploads/2009/01/legionshot04-450x325.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/01/legionshot04.png 486w" sizes="(max-width: 450px) 100vw, 450px" /></a>
</center>

A prototype game concept deemed &#8220;**too awesome**&#8220;. Too awesome to finish in a short period of time. 😀

Both of these prototypes were the projects used to get the geometry tests up and working again.

You might hear more about **Pillar Caterpillar** and/or **Dungeon Legion** in the coming months (both projects are on my list I&#8217;m considering).

For the 3rd prototype, I wanted to revisit **Grid**.