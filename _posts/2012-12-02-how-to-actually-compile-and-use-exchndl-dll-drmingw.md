---
id: 5716
title: How to actually compile and use exchndl.dll (DrMinGW)
date: 2012-12-02T15:00:13+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5716
permalink: /2012/12/02/how-to-actually-compile-and-use-exchndl-dll-drmingw/
categories:
  - Technobabble
---
DrMinGW is a fancy crash detection program for MinGW programs. Details can be found here:

<http://code.google.com/p/jrfonseca/wiki/DrMingw>

One of the really cool features of DrMinGW is you can alternatively invoke a DLL from your program to catch your crashes, instead of requiring you or your testers to install DrMinGW.

The problem is the library and DLL aren&#8217;t available for download, and building it from sources requires SCONS, which I can&#8217;t seem to get to work with it. So, my solution is to build it manually. Unfortunately, building it requires knowledge of some of the secret defines set by SCONS.

<!--more-->After much digging, building the DLL should have been:

<pre class="lang:default decode:true " >gcc -c -I include -DPACKAGE="drmingw" -DPACKAGE_VERSION="0.4.4" exchndl.c
gcc -shared -o exchndl.dll exchndl.o -lbfd -liberty -lintl -mwindows -Wl,--out-implib,libexchndl.a
</pre>

The samples can be built now as follows:

<pre class="lang:default decode:true " >gcc -o test.exe -O0 -gstabs3 test.c exchndl2.cxx</pre>

<pre class="lang:default decode:true " >g++ -o testcpp.exe -O0 -gstabs3 testcpp.cxx exchndl2.cxx</pre>

NOTE: &#8220;-gstabs3&#8221; symbols are required by DrMingW.

Now you can run **test.exe** or **testcpp.exe** and watch them crash. Be sure copy **exchndl.dll** alongside the executables. The way it works is: If there&#8217;s no DLL, then nothing happens; If there is a DLL, an RPT report file is written.

If you read the documentation for DrMinGW, what may not be entirely obvious with **exchndl.dll** is that it doesn&#8217;t pop up a box, but instead writes an RPT file relative your executable (myapp.exe -> myapp.RPT).

[<img src="/wp-content/uploads/2012/12/rpt.png" alt="" title="rpt" width="585" height="138" class="aligncenter size-full wp-image-5723" srcset="http://blog.toonormal.com/wp-content/uploads/2012/12/rpt.png 585w, http://blog.toonormal.com/wp-content/uploads/2012/12/rpt-450x106.png 450w" sizes="(max-width: 585px) 100vw, 585px" />](/wp-content/uploads/2012/12/rpt.png)

Relative the executable is alright for debugging, but once your game/app is installed by a user you no longer have permission to write relative your executable (unless you get elevated privileges). My solution is to write the report file somewhere safe instead. Below is a modified &#8220;OnStartup()&#8221; function that places the report in your roaming profile. Overwrite the original function found inside &#8220;exchndl.c&#8221; (#includes and all).

<pre class="lang:default decode:true " >#include &lt;shlobj.h&gt;
#include &lt;direct.h&gt;

static void OnStartup(void) __attribute__((constructor));

void OnStartup(void)
{
	// Install the unhandled exception filter function
	prevExceptionFilter = SetUnhandledExceptionFilter(TopLevelExceptionFilter);
	
	// Figure out what the report file will be named, and store it away
	if(GetModuleFileName(NULL, szLogFileName, MAX_PATH))
	{
		LPTSTR lpszDot;
		
		// Look for the '.' before the "EXE" extension.  Replace the extension
		// with "RPT"
		if((lpszDot = _tcsrchr(szLogFileName, _T('.'))))
		{
			lpszDot++;	// Advance past the '.'
			_tcscpy(lpszDot, _T("RPT"));	// "RPT" -&gt; "Report"
		}
		else
			_tcscat(szLogFileName, _T(".RPT"));
	}
	else if(GetWindowsDirectory(szLogFileName, MAX_PATH))
	{
		_tcscat(szLogFileName, _T("EXCHNDL.RPT"));
	}

	{
		LPTSTR lpszSlash;
		static TCHAR szLogFileCopy[MAX_PATH];
		
		// Back up the filename part, as we're about to destroy it
		if((lpszSlash = _tcsrchr(szLogFileName, _T('\\')))) {
			lpszSlash++; // Advance past the '\'
			_tcscpy(szLogFileCopy, lpszSlash); // Copy just the name part
			
			// Overwrite szLogFileName to a safe place to write things
			SHGetFolderPath( NULL, CSIDL_APPDATA, NULL, 1, szLogFileName );

			// Modify this line to change the folder where your report is written
			_tcscpy(&szLogFileName[_tcslen(szLogFileName)],"\\MyAppDir\\");
			
			// (Just in case) Create the directory
			_tmkdir( szLogFileName );
			
			// Finally, copy the name part
			_tcscpy(&szLogFileName[_tcslen(szLogFileName)],szLogFileCopy);
		}
	}
}</pre>

Now if you&#8217;re to browse to your roaming profile directory, you&#8217;ll find the report.

[<img src="/wp-content/uploads/2012/12/rptbetter.png" alt="" title="rptbetter" width="631" height="147" class="aligncenter size-full wp-image-5727" srcset="http://blog.toonormal.com/wp-content/uploads/2012/12/rptbetter.png 631w, http://blog.toonormal.com/wp-content/uploads/2012/12/rptbetter-450x104.png 450w" sizes="(max-width: 631px) 100vw, 631px" />](/wp-content/uploads/2012/12/rptbetter.png)

Phew!

## Static libintl

When building the DLL, a static alternative to libintl (the -lintl part) can be found here:

<http://sourceforge.net/projects/libintl-windows/>

Be sure to link against &#8220;libintl.a&#8221; and &#8220;win_iconv.c&#8221;.

<pre class="lang:default decode:true " >gcc -c -I include -DPACKAGE="drmingw" -DPACKAGE_VERSION="0.4.4" exchndl.c
gcc -shared -o exchndl.dll exchndl.o -lbfd -liberty libintl/libintl.a libintl/win_iconv.c -mwindows -Wl,--out-implib,libexchndl.a
strip exchndl.dll</pre>

Stripping to cut down the size. Should be closer to 700K now instead of 5M.

## NEW: Pidgen&#8217;s Modified DrMinGW

The folks behind the Pidgen chat client have provided an improved version of the original DrMinGW (exchndl.dll):

<http://hg.pidgin.im/util/drmingw>

It exists because of a discussion over here on how exploitable it could be:

<https://developer.pidgin.im/ticket/15289>

And more details on the exploit itself are [here](http://blog.zoller.lu/2010/08/cve-2010-xn-loadlibrarygetprocaddress.html). A pretty blatant one that probably every application that loads dll&#8217;s is venerable to in some way.

[One solution](http://social.msdn.microsoft.com/Forums/en-US/vclanguage/thread/24f6950d-ad0a-428e-975c-e8033619bbc8)&#8230; maybe. MinGW lacks Softpub.h (and wintrust.lib), so this maybe a VC build only thing. I&#8217;m not sure though if MinGW&#8217;s DLL loader is the same as VC. Heh, getting very Windows meta here. 😀