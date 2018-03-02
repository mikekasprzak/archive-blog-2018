---
id: 4459
title: 'Premake: My new best friend (RE: MSVC &#038; Xcode)'
date: 2011-07-31T22:19:29+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4459
permalink: /2011/07/31/premake-my-new-best-friend-re-msvc-xcode/
categories:
  - Alone, The
  - Technobabble
---
Alright, I&#8217;ve spammed the [twitterverse](http://twitter.com/mikekasprzak) enough.

Here&#8217;s something I **started** playing with today, and **finished** just a few hours later, satisfied. [Premake](http://industriousone.com/premake). In essence, it&#8217;s a build script and project file maker, just like CMake and Scons. It uses Lua scripting, to contrast custom and python for the others (CMake a Scons respectfully).

If you weren&#8217;t me, you could save yourself a slew of portability headaches with this simple script.

<pre>solution "MySolution"
  configurations { "Debug", "Release" }
project "MyProject"
  language "C++"
  kind     "ConsoleApp"
  files  { "**.h", "**.cpp" }
 
  configuration { "Debug*" }
    defines { "_DEBUG", "DEBUG" }
    flags   { "Symbols" }
 
  configuration { "Release*" }
    defines { "NDEBUG" }
    flags   { "Optimize" }</pre>

(From [here](http://industriousone.com/post/typical-c-project-0))

Stick that in a folder with code, or code found in some directories. Then from a command-line, invoke the tool **premake4** as follows:

`premake4 --file=myfile.lua vs2008`

Blam! Your prize, a Visual Studio 2008 project file and solution. Want 2010? Just change the argument.

Want it building elsewhere? Walk over to your Linux box, or your Cygwin/MinGW shell, and do this:

`premake4 --file=myfile.lua gmake`

You now have a makefile.

Of course, anyone that&#8217;s done project management knows that the above is just your most basic of projects. Standard C/C++ libraries, and whatnot. Per platform you still need to link versus external libraries (OpenGL, SDL, etc). No problem, just add new sections to your targets. includedirs, libs, libdirs, and so on. Want to apply a setting to both? just place it a level up in the hierarchy. Nearly everything you would normally do on a platform, there&#8217;s a means of adding content to that.

Honestly, there&#8217;s little point having me regurgitate how to start using it, as the docs have a wonderful tutorial that steps through it. And once you get to the files stage of the tutorial, you can generate a usable project file with just that. Here&#8217;s the link:

<http://industriousone.com/solutions-and-projects>

My one last tip though, is that the scripting interface is doing some housekeeping behind the scenes. The functions Solution, Project, and Configuration specifically. Calling them changes the scope of the calls that follow. This is important to note if you try to use normal Lua scripting activities, a &#8220;printf&#8221; will write to the console as the project is generated, but not while it runs. There&#8217;s a command for setting the actions at each stage.

Oh, and you can invoke [MSBUILD](http://msdn.microsoft.com/en-us/library/ms171452%28v=vs.90%29.aspx) from the command-line if you want to live in shell land (like me). Start a Visual Studio 2008 shell (under Start Menu/Visual Studio 2008/Visual Studio Tools/..), then browse to and invoke it as follows.

`msbuild MySolution.sln /property:Configuration=Debug`

And presto. Your actual errors will be logged to the console window.

\* \* *

So hey, ahem, back on topic. If you&#8217;re not me, you can use something like this to do your project management work. I however have and REALLY LIKE a fancy GNU make based build system I wrote. Unfortunately, this only helps me when I&#8217;m developing for Windows, Linux, and certain devices. It does no good when I am actually required to use Visual Studio (certain libraries, DRM, SDK&#8217;s), or Xcode on Mac. But that&#8217;s where Premake comes in, to take care of that stuff for me.

I have some wild plans ahead, but I wanted my original working script available somewhere. Hit the jump for the full listing. 

Remember, it&#8217;s Lua, so double dashes are line comments.

<!--more-->

<pre>-- Hello! I sync remote SVN, HG, and GIT repositories to a folder "Build".
-- Inside Build, I compile things. In the case of MSVC, I used the included
-- Solution file (VisualC/VC2008.sln), and left the files where they were.

SDL_ROOT 	= "D:/Build/SDL/"
SDL_LIB_ROOT	= SDL_ROOT .. "VisualC/SDL/"

solution "MySolution"
	configurations { "Debug", "Release" }
	location "Build"

	configuration "Debug"
		targetdir "Build/Debug"

	configuration "Release"
		targetdir "Build/Release"

	if _ACTION == "clean" then
		os.rmdir("Build/Debug")
		os.rmdir("Build/Release")
	end

	
project "Legends"
	kind "WindowedApp"
	language "C++"
	location "build"

	files {
		"../../src/GEL/**.c*",
		"../../src/Foundation/**.c*",
		"../../src/GameLegends/**.c*",
		"../../src/Main/SDL/**.c*",
		
		"../../src/External/Squirrel/**.c*",
		"../../src/External/NVTriStrip/**.c*",
		"../../src/External/Bullet/**.c*",
		"../../src/External/cJSON/**.c*",
		"../../src/External/TinyXML/**.c*",
	}
	-- In my build system, the rule is that all files beginning with . or _ are ignored.
	excludes {
		"../../src/**/_**",
		"../../src/**/.**",
	}
	
	links { 
		"SDL", "irrKlang", "opengl32", "winmm",
	}
	libdirs { 
		"../../src/External/irrKlang/lib/win32-VisualStudio/"
	}
	
	includedirs {
		"../../src/GEL/",
		"../../src/Foundation/",
		"../../src/GameLegends/",
		"../../src/Main/SDL/",

		"../../src/External/Squirrel/include/",
		"../../src/External/NVTriStrip/include/",
		"../../src/External/Bullet/",
		"../../src/External/cJSON/",
		"../../src/External/TinyXML/",
		
		(SDL_ROOT .. "/include"),
	}		
	
	defines {
		"PRODUCT_LEGENDS",
		"USES_GEL", "USES_FOUNDATION", 
		"USES_SDL", "USES_SDL_1_3", "NO_STDIO_REDIRECT", "NO_SDL_SUBDIR",
		"USES_IRRKLANG",
		"USES_OPENGL", "USES_GLEE",
		"USES_WINDOWS", 
		
		"USES_MSVC", "_CRT_SECURE_NO_WARNINGS",
	}
	
	configuration "Debug"
		kind "ConsoleApp"
		libdirs { 
			(SDL_LIB_ROOT .. "Debug/"),
		}
		postbuildcommands { 
			path.translate("copy " .. SDL_LIB_ROOT .. "Debug/SDL.dll Debug", "\\"),
		}
		defines {
			"DEBUG", "_DEBUG",
		}
		flags { "Symbols" }
		
	configuration "Release"
		libdirs {
			(SDL_LIB_ROOT .. "Release/"),
		}
		postbuildcommands {
			path.translate("copy " .. SDL_LIB_ROOT .. "Release/SDL.dll Release",  "\\"),
		}
		defines {
			"NDEBUG",
		} 
		flags { "Optimize" }
</pre>

And oh, hey, a bonus! My MSBUILD batch file (conveniently named **make.bat**).

<pre>:prebuild

msbuild Build/MySolution.sln /property:Configuration=Debug

:postbuild

@if "%1" == "run" goto :run
@goto :end

:run
@set OLDDIR=%CD%
@cd ..\..
%OLDDIR%\Build\Debug\Legends.exe -DIR .\
@chdir /d %OLDDIR%

:end</pre>