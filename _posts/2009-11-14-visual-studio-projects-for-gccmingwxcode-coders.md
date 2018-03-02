---
id: 1532
title: Visual Studio projects for GCC/MinGW/Xcode coders
date: 2009-11-14T05:27:36+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=1532
permalink: /2009/11/14/visual-studio-projects-for-gccmingwxcode-coders/
categories:
  - Technobabble
---
One of the things on my blogging TODO list is to show how I work. Many coders find it odd to hear that I work on Windows without Visual Studio, or that I work on the Mac by rarely touching the Mac. Just me, a text editor (a good one), and a bunch of useful scripting.

In my current project though (Smiles PC), I&#8217;ve run in to a slight brick wall that requires me and my development _arch nemesis_ to join forces. It&#8217;s almost funny, but it&#8217;s been about 10 years since I&#8217;ve had to touch a Microsoft compiler. Normally I&#8217;d be reluctant, but we&#8217;re talking a distribution issue here&#8230; and that&#8217;s how I get paid. 😉

So, today&#8217;s when I swallow my command line pride and get Smiles building with Visual Studio.

This post is long, nuanced, technical, and mostly for my own benefit. So if you&#8217;re up for an over analysis of Windows Developers _favorite_ development tool, hit the link.

<!--more-->

## Overview

Over the past few, days I grabbed the [Visual Studio 2008 trial](http://www.microsoft.com/downloads/details.aspx?FamilyID=83c3a1ec-ed72-4a79-8961-25635db0192b&displaylang=en) and [Service Pack](http://www.microsoft.com/downloads/details.aspx?familyid=27673C47-B3B5-4C67-BD99-84E525B5CE61&displaylang=en). Four some gigabytes and several hours later, we have a couple ISO images ready for burning and installing.

Now, I&#8217;m not going to walk through the entire process. That would just take too long (and be pointlessly boring). Instead, I&#8217;m just going to dive in to some note taking. Things I wanted to know as soon as I clicked on the _technicolor figure eight_. My goal with Visual Studio right now is to CLEANLY integrate a Visual Studio project file in to a shared hierarchy of MinGW, Linux, and XCode branches. It should be useful to Mac or Linux coders coming from the other side, or REALLY WEIRD Windows coders like myself.

## Installing SDL in Visual Studio

I use SDL for my Windows and Linux ports, so the first step was to install the libraries. It&#8217;s pretty easy to do these days, as the SDL people provide [pre-built libraries](http://www.libsdl.org/download-1.2.php) for Visual Studio and MinGW. I&#8217;m using Visual Studio 2008 (i.e. Visual C++ 9.0), so I grabbed the VC8 files.

SDL is something I consider a core library when I work, so I have no qualms about putting its files right in the default folders. So I grabbed the **include** and **lib** folders from the SDL package and placed the contents in the appropriate places here (with **ONE** change&#8230; see below):

> C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\include
  
> C:\Program Files (x86)\Microsoft Visual Studio 9.0\VC\lib

For those unfamiliar with 64bit Windows, your 32bit apps get installed in a **Program Files (x86)** folder, so you can differentiate.

That change I spoke of was instead of copying the **include** folder _as is_, I renamed it to SDL and placed it under the VC include folder. I did this because this is what SDL for MinGW does. For some reason it&#8217;s _not_ the same, I&#8217;m not sure why, but whatever. It&#8217;s consistent now.

<div id="attachment_1578" style="max-width: 460px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SDLInclude.png"><img class="size-medium wp-image-1578" title="SDLInclude" src="/wp-content/uploads/2009/11/SDLInclude-450x290.png" alt="Storing SDL includes inside an SDL folder" width="450" height="290" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/SDLInclude-450x290.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/SDLInclude-640x412.png 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/SDLInclude.png 690w" sizes="(max-width: 450px) 100vw, 450px" /></a>
  
  <p class="wp-caption-text">
    Storing SDL includes inside an SDL folder
  </p>
</div>

Now that this is done, I can simple include it as:

<pre>#include &lt;SDL/SDL.h&gt;</pre>

and add the **SDL.lib** and **SDLmain.lib** as appropriate.

If you&#8217;re following me along, be sure to grab **SDL.dll**, as you&#8217;re going to need it later.

## Modern Visual Studio Projects

The next part involves tearing apart a generated stock project hierarchy. Visual Studio has a common way it structures projects, but that doesn&#8217;t mean it&#8217;s good. Lets break it.

SDL uses a derivative of the _Win32 Application_ settings. It&#8217;s actually not that difficult to switch modes inside the project settings, but we may as well start from something that will require the fewest changes.

<div id="attachment_1549" style="max-width: 460px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/NewProject.png"><img class="size-medium wp-image-1549" title="NewProject" src="/wp-content/uploads/2009/11/NewProject-450x310.png" alt="Creating a new project in Visual Studio 2008" width="450" height="310" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/NewProject-450x310.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/NewProject-640x441.png 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/NewProject.png 683w" sizes="(max-width: 450px) 100vw, 450px" /></a>
  
  <p class="wp-caption-text">
    Creating a new project in Visual Studio 2008
  </p>
</div>

A rule of thumb with portable game development is you **always** work from the lowest spec or version of something possible. I suspect .NET is not actually used in stock Win32 Applications, but none the less, I&#8217;ve chosen .NET 2.0 as opposed to 3.5 that was the default setting.

Visual Studio 2008 uses some unusual terminology with projects. The idea is that you create **solutions**, and a solution contains 1 or more projects. Projects are a single target, be it an executable, a DLL library, or an include library (.lib). You may be familiar with this arrangement called _workspaces_ in other development suites.

In the create dialog above, the **name** you specify is the name for the project, and all the elements it generates (folder, .cpp files, executable). The solution name on the bottom defaults to the name above, but you can change it easy enough. The entire product gets wrapped in a **solution named** folder, and all the code is placed under the **named** folder. This can look weird at first, as the default behavior creates a folder of the same name inside the solution folder.

## Files from a stock project

I had to experiment and dig through MSDN for a while to figure out exactly what the various element files were. Here&#8217;s a list.

> **SolutionName.ncb** &#8211; The Intellisense database (i.e. code completion), generated at runtime. This gets pretty large, so **omit it** from **version control** (SVN).
  
> **SolutionName.sln** &#8211; The XML based solution file. References all projects.
  
> **SolutionName.suo** &#8211; A binary accessory file for the solution. May be hidden.
  
> **Project/Project.vcproj** &#8211; The XML based project file. References all code files and contains build settings.
  
> **Project/Project.vcproj.COMPUTERNAME.UserName.user** &#8211; I&#8217;m assuming this is local computer related settings (I.e. what files I have open, as opposed to other users). You can delete it and things work just fine. You can **omit this** from **version control** (SVN).
  
> **Project/stdafx.cpp** and **.h** &#8211; Precompiled header support files. You _can_ disable this feature from the project settings, and shut up a whole bunch of warnings related to not having them.
  
> **Project/Project.rc** &#8211; Windows resource file (text). Vaguely similar to an X-Code &#8220;.plist&#8221; and &#8220;.xib&#8221; files, except it&#8217;s only for specifying things like the icon, window layout templates, and so on.
  
> **Project/Project.ico** &#8211; Windows icon file. Despite what Windows explorer may report, it actually contains several icon sizes.
  
> **Project/small.ico** &#8211; Legacy small icon file? Exactly the same as **Project.ico**.
  
> **Project/targetver.h** &#8211; Minimum Windows version requirements for the resource file. Inside the resource file, you can can just comment this out.

The rest of the files are the sample code (+ a text file).

<div id="attachment_1566" style="max-width: 460px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/DummyWin32.png"><img class="size-medium wp-image-1566" title="DummyWin32" src="/wp-content/uploads/2009/11/DummyWin32-450x388.png" alt="Files generated by a stock Win32 Project in Visual Studio 2008" width="450" height="388" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/DummyWin32-450x388.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/DummyWin32-640x553.png 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/DummyWin32.png 854w" sizes="(max-width: 450px) 100vw, 450px" /></a>
  
  <p class="wp-caption-text">
    Files generated by a stock Win32 Project in Visual Studio 2008
  </p>
</div>

## The Solution Explorer

With our _&#8220;solution&#8221;_ loaded, we can start hacking it to bits. The majority we can do right from the Solution Explorer itself.

<div id="attachment_1583" style="max-width: 434px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SolutionExplorer.png"><img class="size-full wp-image-1583" title="SolutionExplorer" src="/wp-content/uploads/2009/11/SolutionExplorer.png" alt="The Solution Explorer... err... project viewer" width="424" height="409" /></a>
  
  <p class="wp-caption-text">
    The Solution Explorer... err... project viewer
  </p>
</div>

Right clicking on the files and folders here, we can add new ones or remove existing ones.

However unlike Xcode, folders here are not actually folders. Visual Studio uses a term &#8220;**filters**&#8220;, since the hierarchy you create is completely virtual and doesn&#8217;t exist on disk.

Also unlike Xcode, you _can&#8217;t_ set up folder like links that reference all files in a directory. I use this feature myself with Xcode, as I have several generated &#8220;.cpp&#8221; for data that&#8217;s just too small to keep external, and embed in to the binary instead (menus). Instead, this means you&#8217;ll have to drag+drop directories you want in to your project any time there is an update. On the plus side, you **CAN** drag+drop folders containing other folders of code. On the down side, your folder hierarchy isn&#8217;t preserved when you do it. Meh.

<div id="attachment_1592" style="max-width: 454px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/NoHierarchy.png"><img class="size-full wp-image-1592" title="NoHierarchy" src="/wp-content/uploads/2009/11/NoHierarchy.png" alt="Dragging a tree over dumps all the file in the same place" width="444" height="612" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/NoHierarchy.png 444w, http://blog.toonormal.com/wp-content/uploads/2009/11/NoHierarchy-326x450.png 326w" sizes="(max-width: 444px) 100vw, 444px" /></a>
  
  <p class="wp-caption-text">
    Dragging a tree over dumps all the file in the same place
  </p>
</div>

## Project Properties

Project usability aside, we can easily make the compiler and build process behave exactly as we want. Right clicking on the Project&#8217;s name and selecting properties gives us a comprehensive list of compiler, linker, and target options. Many special variables exist too for building useful paths.

<div id="attachment_1597" style="max-width: 460px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/Properties.png"><img class="size-medium wp-image-1597" title="Properties" src="/wp-content/uploads/2009/11/Properties-450x313.png" alt="IDE complaints aside, I can make the compiler do what I want" width="450" height="313" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/Properties-450x313.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/Properties-640x445.png 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/Properties.png 749w" sizes="(max-width: 450px) 100vw, 450px" /></a>
  
  <p class="wp-caption-text">
    IDE complaints aside, I can make the compiler do what I want
  </p>
</div>

Each section after Debugging (C/C++, Linker, etc) has an option called Command Line. It gives you a complete listing of all command line arguments you&#8217;re passing to CL, set by enabling/disabling the options you&#8217;ve chosen here in properties. This would be an invaluable reference if you wanted to set up a makefile for building. Mike is pleased. 🙂

There&#8217;s a lot of options here, so I&#8217;ve gone through and made a list of several that seem useful. I&#8217;ve placed a star (<span style="color: #ff00ff;"><strong>*</strong></span>) beside the ones I find most important to _creative_ structural uses.

  * **General** 
      * **Output Directory** &#8211; Where the .exe goes <span style="color: #ff00ff;"><strong>*</strong></span>
      * **Intermediate Directory** &#8211; Where junk (.obj) goes <span style="color: #ff00ff;"><strong>*</strong></span>
  * **Debugging** 
      * **Command Arguments** &#8211; Arguments for the .exe
      * **Working Directory** &#8211; Where to execute from. Default is the project folder (i.e. blank). <span style="color: #ff00ff;"><strong>*</strong></span>
      * **Environment** &#8211; Custom environment variables to set
  * **C/C++** 
      * **General** 
          * **Additional Include Directories** &#8211; Where to find more .h files <span style="color: #ff00ff;"><strong>*</strong></span>
          * **Detect 64bit Portability Errors** &#8211; Default is no
          * **Treat Warnings as Errors** &#8211; Default is no
      * **Preprocessor** 
          * **Preprocessor Defenitions** &#8211; #DEFINE&#8217;s for the command line. Semicolon delimited. <span style="color: #ff00ff;"><strong>*</strong></span>
      * **Code Generation** 
          * **Enable C++ Exceptions** &#8211; Default is Yes
          * **Runtime Library** &#8211; Multithreaded _with_ or _without_ DLL. Default is with.
      * **Precompiled Headers** 
          * **Create/Use Precompiled Headers** &#8211; Default is Use (**Yes**). Can stop many errors with **No**. <span style="color: #ff00ff;"><strong>*</strong></span>
      * **Advanced** 
          * **Calling Convention** &#8211; Default is \_\_cdecl. Some DLLs rely on or expect \_\_stdcall.
          * **Force Includes** &#8211; Specify 1 or more .h files to include in **every** compiled file. <span style="color: #ff00ff;"><strong>*</strong></span>
          * **Undefine Preprocessor Definition** &#8211; Remove a system default define
  * **Linker** 
      * **General** 
          * **Output File** &#8211; Where and what the .exe is called <span style="color: #ff00ff;"><strong>*</strong></span>
          * **Version** &#8211; Version number in the .exe header
          * **Additional Library Directories** &#8211; Where to find more .lib files <span style="color: #ff00ff;"><strong>*</strong></span>
      * **Input** 
          * **Additional Dependencies** &#8211; Any extra .lib files you use. **SPACES** not semi colons.<span style="color: #ff00ff;"><strong>*</strong></span>
          * Examples: SDL.lib SDLmain.lib opengl32.lib glu32.lib
    
      * **Advanced** 
          * **Entry Point** &#8211; Change the startup function from main to something else
          * **Target Machine** &#8211; Default is MachineX86
  * **Resources** 
      * **General** 
          * **Preprocessor Definitions** &#8211; #DEFINEs for resource files. Semicolon delimited.
          * **Additional Include Directories** &#8211; Where to find .h, .def, or .res files, when manually scripting resources.
  * **Build Events** 
      * **Pre-Build Event -> Command Line**
      * **Pre-Link Event -> Command Line**
      * **Post-Build Event -> Command Line**

Next I just want to comment on a few of them that are important to structure.

## General -> Output Directory <span style="color: #ff00ff;"><strong>*</strong></span>

This is where the executable goes. The default is **$(SolutionDir)$(ConfigurationName)**, which says put them in the root solution folder under **Debug** and **Release** respectfully (i.e. the configuration name). My sample project goes here:

> D:\VCProj\SolutionName\Debug\**Project.exe**

That&#8217;s probably an alright location for a Windows only project, but that adds clutter to your root directory. I&#8217;d go with the following myself.

> **$(SolutionDir)output/$(ConfigurationName)**

Which places your binary here:

> D:\VCProj\SolutionName\output\Debug\**Project.exe**

That way, the root folder only contains a single output folder no matter how many configurations there are.

You can refer to this directory elsewhere with the **$(OutDir)** variable.

## General -> Intermediate Directory <span style="color: #ff00ff;"><strong>*</strong></span>

This is where the &#8220;.obj&#8221; and other temporary files go. The default location is **$(ConfigurationName)**, which is rather sloppy if you ask me. This evaluates to a **Debug** or **Release** folder under the project directory.

> D:\VCProj\SolutionName\Project\Debug\ <&#8211; Sloppy!

I especially dislike this because it&#8217;s placing junk folders along with your source code. Instead, I&#8217;d go with this

> **$(SolutionDir)obj/$(ProjectName)/$(ConfigurationName)**

Which places your junk files here:

> D:\VCProj\SolutionName\obj\Project\Debug\

A single location for all your intermediate files. Then if you&#8217;re like me, you can add a simple SVN rule to ignore everything under the obj folder.

You can refer to this variable elsewhere with the **$(IntrDir)** variable.

## Debugging -> Working Directory <span style="color: #ff00ff;"><strong>*</strong></span>

Rather important, as you may have a certain place outside the project or source tree where you want your game to find it&#8217;s content. The default is the project folder itself (i.e. blank). You may want to make it &#8220;**$(SolutionDir)**&#8220;, or perhaps something like &#8220;**$(SolutionDir)Content/**&#8220;. Your application will search for files relative to that base directory.

## Property Final Notes

It should be noted that, just like Xcode, you need to configure the options of each build separately. The configuration drop-down list-box at the top of the window is especially useful for this. Default there being your currently Active configuration, and the last option allows you to edit them all at once. **Beware**, you might ruin the **stock DEFINES** using all.

That&#8217;s everything we need to know to make some structure decisions.

## The Dummy Solution

Using our newfangled Visual Studio powers, we&#8217;re going to create a solution for dummies. No, not exactly, but I&#8217;ll be creating a dumb solution and project file that I&#8217;ll gut.

I don&#8217;t like all the junk files a solution creates though. We&#8217;re talking 3 files, plus a directory of stuff. Xcode, or rather, OS X does something I like to call Magic Folders. From the Mac&#8217;s side, Application Bundles and Project Files appear to be self contained files. In fact, they&#8217;re actually directories with a special property that makes double clicking on them do something else. On Windows you&#8217;d enter the folder, but on OS X it either launches the Application or fires up Xcode.

I can&#8217;t really achieve the same behavior on Windows, but I can borrow some cleanlyness ideas. All the projects data for Xcode projects lives in a **MyProject.xcodeproj** folder. I&#8217;m going to do the same thing. Place my solution and project inside a **MyProject.msvcproj** folder. One folder, instead of 3+1 files. That&#8217;s a far cleaner root directory.

## The Result

<div id="attachment_1631" style="max-width: 460px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SmilesMSVC.png"><img src="/wp-content/uploads/2009/11/SmilesMSVC-450x395.png" alt="Gutted Visual Studio Project and Solution. Only kept the resources." title="SmilesMSVC" width="450" height="395" class="size-medium wp-image-1631" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesMSVC-450x395.png 450w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesMSVC-640x562.png 640w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesMSVC.png 699w" sizes="(max-width: 450px) 100vw, 450px" /></a>
  
  <p class="wp-caption-text">
    Gutted Visual Studio Project and Solution. Only kept the resources.
  </p>
</div>

The solution I actually named with a &#8220;.msvcproj&#8221; in it&#8217;s name. I was worried at first it would generate something broken (using dots), but it works just fine. The project I called &#8220;Project&#8221; for some reason. That then means the output executable will be called Project (default), at least until I change it. I alternatively could have named it Smiles, since I am calling the solution something different (Smiles.msvcproj).

Next I &#8220;_sort of_&#8221; rebuilt my hierarchy. My code is further broken up in to topical directories. Each directory I created a &#8220;filter&#8221; for inside the project, and dragged the contents in.

<div id="attachment_1633" style="max-width: 383px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2009/11/SmilesMSVCProj.png"><img src="/wp-content/uploads/2009/11/SmilesMSVCProj.png" alt="How the project looks in Visual Studio" title="SmilesMSVCProj" width="373" height="497" class="size-full wp-image-1633" srcset="http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesMSVCProj.png 373w, http://blog.toonormal.com/wp-content/uploads/2009/11/SmilesMSVCProj-337x450.png 337w" sizes="(max-width: 373px) 100vw, 373px" /></a>
  
  <p class="wp-caption-text">
    How the project looks in Visual Studio
  </p>
</div>

For an idea of what each of these are:

> **Game** is the game code.
  
> **Shared** is common game unspecific code.
  
> **SDL** is the SDL specific code (i.e. main, input).
  
> **OpenGL1** is the Fixed Function version of my graphics library (OpenGL 1.x, ES 1.1).
  
> **libc** is the libc version of my data and file serialization code (uses fopen, memcopy).
  
> **Windows** is Windows specific code, which is currently only timers.

Depending on which platform I&#8217;m targeting, the **Game** and **Shared** stay the same, but I mix and match the other 4 as needed. For example, iPhone OS uses the **iPhone** startup code in place of SDL, and the **Unix** timer code in place of Windows.

As for project settings, I used the following.

> **Output Dir:** $(SolutionDir)..\output\msvc\$(ConfigurationName)
  
> **Intermediate:** $(SolutionDir)..\obj\msvc\$(ConfigurationName) 

That way, the Visual Studio build can share the same **output** and **obj** tree used by the makefiles, placing garbage files in the same place. The specific build goes in the **msvc/Debug** and **msvc/Release** directories, just so it&#8217;s clear that&#8217;s the Visual Studio target and not the MinGW.

The working directory is a folder back from the solution directory, since I currently look from the root directory for my content.

> **Working Directory:** $(SolutionDir)..\

I have several include directories to add. Every single directory above needs to be added since I use <> style includes to access files outside the local directory.

> **Additional Include Dirs:** ..\..\src\Game;..\..\src\libc;..\..\src\OpenGL1;..\..\src\SDL;..\..\src\Shared;..\..\src\Windows

You&#8217;ll also note I&#8217;m using double ..&#8217;s to specify paths. I could have alternatively used **$(SolutionDir)..\** in it&#8217;s place, but **..\..\** is shorter.

I have several defines as well, to say what variations of code I should be using. OpenGL versus OpenGL ES, SDL versus iPhone, etc.

> **Preproccessor Defines:** USES\_SDL;USES\_OPENGL;USES_WINDOWS

Precompiled headers are disabled, as I didn&#8217;t want to include the silly stdafx file in my source.

Output file I renamed as suggested above.

> **Output File:** $(OutDir)\Smiles.exe

Finally, the libraries I link. SDL and OpenGL.

> **Additional Dependencies:** SDL.lib SDLmain.lib opengl32.lib glu32.lib

And that&#8217;s it. Everything I needed to get the game to compile on MSVC.

## Conclusion

The perfect way to end this post would be to show a screenshot of the game built and running from Visual Studio, but alas I still have more work ahead of me. GCC has _far better_ C++ initializer list support, which I promptly took advantage of in my Matrix Math code. However this isn&#8217;t GCC, so I still have a little bit of work ahead of me to make it work on both.

That&#8217;s it for now. If you made it this far, wow!