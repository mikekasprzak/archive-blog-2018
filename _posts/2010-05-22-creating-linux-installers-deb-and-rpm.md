---
id: 2653
title: Creating Linux Installers (DEB and RPM)
date: 2010-05-22T10:04:06+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=2653
permalink: /2010/05/22/creating-linux-installers-deb-and-rpm/
categories:
  - Technobabble
---
I&#8217;m kicking myself for not doing this with some of the other platforms I&#8217;ve ported to recently (or I will be kicking), so I&#8217;ve decided to quickly scribble down some notes while the process is still fresh in my mind.

<!--more-->

## Where to put files, the debate

Instead of finding a clear answer, asking the internet &#8220;where should I install my app on Linux&#8221; leads you to annoying debates instead of answers. It&#8217;s a real shame for developers trying to support the platform, since your only option is to essentially dig through conflicting documentation and forum posts and ultimately make your own decision. Redhat calls [/opt and /usr/local](http://tldp.org/HOWTO/HighQuality-Apps-HOWTO/fhs.html) the devil, but some distributions [specifically allocate more space](http://wiki.maemo.org/Documentation/Maemo_5_Developer_Guide/Packaging,_Deploying_and_Distributing/Installing_under_opt_and_MyDocs) to /opt for application developers. Redhat says you should litter the file system with your files &#8220;because RPM&#8217;s can clean themselves up properly&#8221;. That&#8217;s a terrible reason.

I will concede though, that if you&#8217;re developing a command line tool or utility, standard Unix paths is is probably a good idea, since you want system level integration. But as game developers, there&#8217;s nothing utility about us. We are standalone isolated entities of fun. No other application has a reason to care about/use our content.

But perhaps the final nail, the undisputed best-selling Indie Game of recent times, [World of Goo](http://www.worldofgoo.com/dl2.php?lk=demo), uses /opt. So if you&#8217;re going to pick a standard, you may as well use a game with the largest user base as reference.

## Where to put files?

Install your game under &#8220;**/opt/mygame**&#8220;.
  
Store save-data files under &#8220;**~/.mygame**&#8220;. 

&#8220;~&#8221; is a shorthand for the current user&#8217;s home directory. And by default, any folder of file starting with a &#8220;.&#8221; is hidden in Unix land.

## What else do I need?

The above handles making your game functional in a Unix file system, but it doesn&#8217;t do you much for the window managers (Gnome, KDE, XFCE). So like setting registry entries on Windows, there are files you should create (or symlink) to make the user experience a bit more functional.

### The &#8220;.desktop&#8221; file

&#8220;.desktop&#8221; files are used to populate the application browsers of the various window managers. Place (or symlink) your .desktop file under &#8220;**/usr/share/applications/**&#8220;. Name it whatever your application should be called (Smiles.desktop).

An example &#8220;.desktop&#8221; file is as follows.

> [Desktop Entry]
  
> Type=Application
  
> Version=1.1
  
> Name=Smiles
  
> Comment=A cheerful arcade matching and strategic puzzle game
  
> Icon=SykhronicsSmiles
  
> Exec=/opt/sykhronics/smiles/Smiles
  
> Categories=Game;Puzzle

More details [can be found here](http://library.gnome.org/admin/system-admin-guide/stable/menustructure-desktopentry.html.en).

### Icon Files

Games totally need icons. Make a whole bunch of various sized PNG files, and store (or symlink) them here.

**/usr/share/icons/hicolor/16&#215;16/apps/MyApp.png** *
  
**/usr/share/icons/hicolor/22&#215;22/apps/MyApp.png** *
  
**/usr/share/icons/hicolor/24&#215;24/apps/MyApp.png**
  
**/usr/share/icons/hicolor/26&#215;26/apps/MyApp.png**
  
**/usr/share/icons/hicolor/36&#215;36/apps/MyApp.png** *
  
**/usr/share/icons/hicolor/48&#215;48/apps/MyApp.png** *
  
**/usr/share/icons/hicolor/64&#215;64/apps/MyApp.png** *
  
**/usr/share/icons/hicolor/72&#215;72/apps/MyApp.png**
  
**/usr/share/icons/hicolor/96&#215;96/apps/MyApp.png**
  
**/usr/share/icons/hicolor/128&#215;128/apps/MyApp.png** *
  
**/usr/share/icons/hicolor/192&#215;192/apps/MyApp.png**
  
**/usr/share/icons/hicolor/scalable/apps/MyApp.svg** <font color="#ff0000"><strong>**</strong></font>

Files with a * are commonly used sizes. And the <font color="#ff0000"><strong>**</strong></font> note is because the last file is an SVG file. I don&#8217;t have a scalable version of my icon, but I do have a 512&#215;512 version of it, so I fired up Adobe Illustrator and made that my icon. The SVG file format _does_ support raster artwork, but since my file is only 512&#215;512, it&#8217;ll start to get fuzzy if the window manager needs an icon larger than that.

You&#8217;ll note the Icon field in the &#8220;.desktop&#8221; file above references an icon called &#8220;**SykhronicsSmiles**&#8220;. In my case, my icon files are &#8220;**SykhronicsSmiles.png**&#8221; (or .svg) in all of those directories.

### Shell Script (optional)

There are a few reasons you may want to run a shell script instead of your executable directly. Opting to use a shell script from the start is a good idea, as it lets you add any of the things mentioned here later.

#### Set the working directory

It&#8217;s not too much effort get the executable directory of your application. Simply call readlink as follows:

> char AppBaseDir[2048];
  
> readlink( &#8220;/proc/self/exe&#8221;, AppBaseDir, sizeof(AppBaseDir) );

Then chop off the executable name.

The problem is that if you&#8217;re planning to bundle any shared libraries relative to your executable (SDL, SDL_mixer, irrKlang), if you used relative paths, they wont resolve correctly unless you&#8217;re running from the executable&#8217;s directory.

It&#8217;s good practice if porting to many platforms to always programatically figure out your executable&#8217;s directory (or specifically, your content directory, which tends to be relative your executable). On non Linux platforms, we don&#8217;t always have the luxury of a shell script to change our working directory for us. At least by doing both, you&#8217;re twice a sure it&#8217;ll be pulling the content from the right place. 😉

#### Running alternative native binaries (64bit, ARM)

Unlike Windows and Mac, the 32bit versions of programs don&#8217;t always run on the 64bit version of Linux. In addition, Linux isn&#8217;t only run on x86 CPU&#8217;s. So with a shell script in place, you can create a (seemingly) universal application installer with support for several CPU architectures.

The Unix tool &#8220;uname&#8221; can be used to tell you information about the system you&#8217;re running on. Calling it as follows tells you the CPU architecture of the Linux distribution:

> uname -m

In my tests, it returns &#8220;**i686**&#8221; when running on Ubuntu, Moblin and Cygwin. On the Nokia N900 and Palm Pre it return &#8220;**armv71**&#8220;, which is the ARM architecture that supports the NEON SIMD instruction set. And when running a 64bit Linux, it should return &#8220;**x86_64**&#8221; (I don&#8217;t have a 64bit distro handy).

### A Sample Shell Script (still optional)

A shell script you&#8217;d use to launch your game might look like the following.

> <pre>#!/bin/sh

DIR=`readlink -f "$0"`
cd "`dirname "$DIR"`"

ARCH=`uname -m`
if [ "$ARCH" = x86_64 ]; then
	EXE=./Smiles.x86_64
elif [ "$ARCH" = armv71 ]; then
	EXE=./Smiles.arm_neon
else
	EXE=./Smiles.x86
fi

$EXE $@

exit $?</pre>

Included with your game would be several executable binaries. In the example above those files are &#8220;**Smiles.x86**&#8220;, &#8220;**Smiles.x86_64**&#8220;, and &#8220;**Smiles.arm_neon**&#8220;, and the shell script is named &#8220;**Smiles**&#8221; (with no &#8220;.sh&#8221; on the end).

Making the script executable may require calling &#8220;**chmod +x Smiles**&#8220;.

## Creating a DEB installer with checkinstall

**checkinstall** is an easy to use tool that monitors an installation process, and generates a DEB or RPM installer for you. The later has some issues that I&#8217;ll explain later, but it&#8217;s a great way to create a DEB installer.

To use **checkinstall**, you first need to set up a process that installs a fresh copy of your application in all the correct places on a system. The standard way is by adding an &#8220;install&#8221; rule in your makefile, but you can use any means to properly installing your app (shell script, another built tool, etc). In my case, I added separate &#8220;install-deb&#8221; and &#8220;install-rpm&#8221; rules to my makefile, in case there was anything I wanted to do differently for one or the other.

A tip: Make sure your installer fully installs your app, and doesn&#8217;t need to overwrite any files. Or in other words, create an uninstaller too. Be sure to run that _before_ running **checkinstall**, or you may be missing some files.

An invocation of **checkinstall** to make a DEB installer may look like this:

> <pre>checkinstall --type=debian --nodoc \
		--pkgname=$(PKGNAME) --pkgversion=$(PKGVERSION) --pkglicense=$(PKGLICENSE) \
		--pkggroup=$(PKGGROUP) --pakdir=$(PAKDIR) --maintainer=$(PKGMAINTAINER) \
		--requires=$(DEB_REQUIRES) \
		make install-deb</pre>

Note: the \&#8217;s are a makefile&#8217;s way of saying &#8220;this line continues on the next line&#8221;, so that entire command is actually one line. Your actual invocation command that installs your app goes after all the command-line arguments.

For reference, the variables above are:

> <pre># - ------------------------------------------------------------------------ - #
USER_NAME		:=	mike
# - ------------------------------------------------------------------------ - #
PKGNAME			:=	smiles
PKGVERSION		:=	1.1.0
PKGLICENSE		:=	blank
PKGGROUP		:=	Amusements/Games
PAKDIR			:=	/home/$(USER_NAME)
PKGMAINTAINER		:=	'information@sykhronics.com'
# - ------------------------------------------------------------------------ - #
DEB_REQUIRES		:=	''
RPM_REQUIRES		:=	'SDL,SDL_mixer,mesa-libGL'
# - ------------------------------------------------------------------------ - #</pre>

When it finishes, a file &#8220;**smiles\_1.1.0-1\_i386.deb**&#8221; is placed in my home directory.

### description-pak

**checkinstall** expects a file named **description-pak** to be found in the working directory. This is an ordinary text file. You can either create a file containing the description of your app, or symlink to an equivalent file in your source tree.

If you don&#8217;t create this file, then **checkinstall** will prompt you for a description every time it is run.

## Creating a good reference install

Since **checkinstall** watches important places for changes, all you need do is copy and create everything where you want them to go.

A good place to start would be with directories.

> mkdir -p /opt/myapp

&#8220;-p&#8221; says make parent directories if needed.

Next, copy your files. Your executable and all your content.

> cp -u output/MyApp /opt/myapp/
  
> cp -u Art/GameSprite.png /opt/myapp/
  
> cp -u Art/Icon128x128.png /opt/myapp/

&#8220;-u&#8221; says overwrite the file only if it&#8217;s changed (i.e. update). Even though we want to feed **checkinstall** a fresh install, using the -u option can speed up any ordinary &#8220;installed&#8221; testing you&#8217;re doing, as it can skip copying large content again and again.

Copy your &#8220;.desktop&#8221; file.

> cp -u Misc/MyApp.desktop /usr/share/applications/

And either copy or symbolic link your icons.

> ln -s /opt/myapp/Icon128x128.png /usr/share/icons/hicolor/128&#215;128/apps/MyApp.png

Doing all of the above like so, when invoking **checkinstall** with your installer, it will track it and build an appropriate DEB file you can give to any Debian or Ubuntu user.

## Creating an RPM installer with checkinstall

This is incredibly easy, but it has some drawbacks. Simply change the &#8220;**&#8211;type=debian**&#8221; command to &#8220;**&#8211;type=rpm**&#8220;. Done. If you&#8217;re following my example above though, you may want to specify some RPM dependencies as I&#8217;ve done, invoking it as follows.

> <pre>checkinstall --type=rpm --nodoc \
		--pkgname=$(PKGNAME) --pkgversion=$(PKGVERSION) --pkglicense=$(PKGLICENSE) \
		--pkggroup=$(PKGGROUP) --pakdir=$(PAKDIR) --maintainer=$(PKGMAINTAINER) \
		--requires=$(RPM_REQUIRES) \
		make install-rpm</pre>

That will generate a file like &#8220;**smiles-1.1.0-1.i386.rpm**&#8221; for you.

If you don&#8217;t really care, you can call yourself done here. The problem with the above is that RPM files contain more metadata than a DEB file. So to be able to correctly set this metadata, you need to build an RPM from scratch.

NOTE: **checkinstall** does give an option to pass in an external &#8220;spec&#8221; file, but it wont append the file list for you.

## Creating an RPM installer with RPMBUILD

Okay, I&#8217;m getting a little writing lazy at this point, so I&#8217;m just going to bullet point the important details necessary for using RPMBUILD instead of explaining it.

First you need to write a spec file. Such a file may look like this:

> <pre># Spec File
Summary: Smiles, the award winning arcade matching and strategic puzzle game.
Name: Smiles
Version: 1.1.0
Release: 1
License: Copyright (C) 2008-2010 Michael Kasprzak
Provides: smiles
Requires: SDL,mesa-libGL,/bin/sh
Prefix: /opt
%{?!ignore_build_requires:BuildRequires:  ,/bin/sh}
AutoReqProv: no
Group: Amusements/Games
URL: http://www.smiles-game.com
Vendor: Michael Kasprzak, Sykhronics Entertainment
Packager: Michael Kasprzak &lt;information@sykhronics.com>

%description
Smiles, the award winning arcade matching and strategic puzzle game.

%files
</pre>

You can either append a file list to this file (or rather, a copy of this file), or pass in a list of all files in as an argument to RPMBUILD.

The license tag above is actually used for specifying a EULA or open source license (GPL). So yes, I&#8217;m using it wrong.

You must copy your files in to a virtual filesystem used by RPMBUILD. With the file above, the file system root starts here:

> /home/mike/rpmbuild/BUILDROOT/Smiles-1.1.0-1.i386/

Then it&#8217;s /opt/&#8230; or /usr/&#8230; as you would expect.

The file list you give RPMBUILD doesn&#8217;t contain that parent directory at all. It&#8217;s simply straight up &#8220;/opt/myapp/MyApp&#8221; style paths.

If you have a proper installer, you could invoke a pair of commands like this to take care of copying your /opt/ files over.

> <pre>mkdir -p /home/mike/rpmbuild/BUILDROOT/Smiles-1.1.0-1.i386/opt/sykhronics/smiles
cp -ru /opt/sykhronics/smiles/* /home/mike/rpmbuild/BUILDROOT/Smiles-1.1.0-1.i386/opt/sykhronics/smiles</pre>

Don&#8217;t forget to copy your &#8220;.desktop&#8221; file.

To copy symlinks, you can use &#8220;-d&#8221;.

> cp -du /usr/share/icons/hicolor/16&#215;16/apps/SykhronicsSmiles.png /home/mike/rpmbuild/BUILDROOT/Smiles-1.1.0-1.i386/usr/share/icons/hicolor/16&#215;16/apps/SykhronicsSmiles.png

Yes, I combined &#8220;-d&#8221; and &#8220;-u&#8221; here as &#8220;-du&#8221;.

I generate a new &#8220;.spec&#8221; file by copying my original, and appending all the file names on the end.

> <pre>@cat Target/Linux/smiles.spec >$(OUT_DIR)/generated.spec
	@$(foreach var,$(PACKAGE_DEPS),echo "$(var)" >>$(OUT_DIR)/generated.spec;)
	@echo "/usr/share/applications/Smiles.desktop" >>$(OUT_DIR)/generated.spec
	@echo "/usr/share/icons/hicolor/16x16/apps/SykhronicsSmiles.png" >>$(OUT_DIR)/generated.spec</pre>

Finally, invoke RPMBUILD.

> rpmbuild -bb generated.spec

The file will be placed under &#8220;**~/rpmbuild/RPMS/i386/**&#8220;.

## Caveats

I&#8217;ve sometimes seen my icon graphics disappear, so I think there may still be a permissions thing that needs to be set.

## Extra

You can reference shared libraries relative to the executable using the linker option RPATH.

> gcc MyApp.c ./libIrrKlang.so -o MyApp -Wl,-rpath,$ORIGIN

NOTE: &#8220;-Wl&#8221; followed by several options separated by commas is how you pass options to the linker through GCC/G++.

If used inside a makefile, you&#8217;ll need to specify the command with &#8220;$$ORIGIN&#8221;.

Alternatively, if you&#8217;re using a shell script, you can add the current (or a specific) directory to the library search path.

> export LD\_LIBRARY\_PATH=.:&#8221;$LD\_LIBRARY\_PATH&#8221;