---
id: 5331
title: Windows 8 C++ Notes
date: 2012-08-27T13:24:51+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5331
permalink: /2012/08/27/windows-8-c-notes/
categories:
  - Technobabble
---
This post is a living collection of notes I&#8217;ve taken whilst exploring Windows 8 development. It&#8217;s not guaranteed to be well written nor complete, but who knows, maybe it&#8217;ll be useful.

<!--more-->

## C++ on Windows 8 is C++/CX, some C++11, and WinRT API

C++/CX is a short list of extensions for C++. They&#8217;re enough to scare new coders, but in actuality they are logical and simple. A great [summary video is here](http://channel9.msdn.com/Events/BUILD/BUILD2011/TOOL-845T).

  * **^** &#8211; Hat Syntax! Biggest Surprise! Hat&#8217;s are pointers to COM objects from the WinRT API. They are a syntax sugar for dealing with objects that cross the boundaries of C++, C# and JavaScript code (the WinRT API). You use -> like any pointer to get its members. They are automatically managed as reference counts. Be aware, because they are ref counts, once the last instance goes out of scope, it is gone.
  * **ref new** &#8211; How C++/CX classes are instantiated.
  * **ref class** &#8211; When deriving from a C++/CX class, the class you are creating should be tagged as a ref class.
  * **partial class** &#8211; One of WinRT&#8217;s things is defining a layout in XAML and hooking up functions. Partial classes are vaguely like inheritance, but not. More like, you can partially define a class using the partial keyword (as the XAML->C++ converter does), then later define the full class, and it will contain all members of both the partials and the class. This could actually be a C++1y feature.
  * **class sealed** &#8211; Sealed classes mean they cannot be derived from. That&#8217;s all. Sugar.

C++11 is the latest spec C++ standard. Visual Studio 2012 isn&#8217;t fully compliant, but as of the 2010 release, many of the most useful features have been available. A good video summary about these, as well as the future of C++11 in Visual Studio [can be found here](http://channel9.msdn.com/Events/GoingNative/GoingNative-2012/C-11-VC-11-and-Beyond).

  * **auto** &#8211; automatically determine the type based on a return type
  * **decltype** &#8211; replaces typeof(), a smarter language feature for determining type
  * **lambda functions** &#8211; Short, inline, function declarations. [](int AnArgument){ DoSomething(); }. Work great with auto and asynchronous designs.

The WinRT API, not to be confused Windows RT (though in a sense Windows RT devices are devices only supporting WinRT code) is the core Windows Runtime Library of teh future. The classic Win32 API is gone, for the most part. WinRT is designed to bridge the bounderies of language, from C++, C#, and JavaScript, while still being Native. It&#8217;s design is heavily based on COM with C++ exception throwing. C++/CX was created to simplify the syntax needed to talk to WinRT. If required, there are ways of talking to the WinRT APIs without using any C++/CX features, though is far more verbose.

## Getting Started

A great place to start is the default &#8220;Visual C++ -> Windows Store -> Direct3D App&#8221;. This creates for us a barebone non-XAML app which builds off the IFrameworkView (i.e. the closest thing to a barebones to-the-metal native app). The IFrameworkView implements all common messages: Pointer Input, Window Resizing, Window Status (Active/Suspend/Resume/Visibility), as well as providing a functional entry point to both run the application and to preload data for a loading screen, and even pre-binding the Direct3D surface to it for us. 

A detailed look at IFrameworkView can [found in a video here](http://channel9.msdn.com/Events/Windows-Camp/Developing-Windows-8-Metro-style-apps-in-Cpp/Cpp-and-DirectX-for-Metro-Style-Games).

## C Language Support

HEY! **C code (.c files) don&#8217;t work as expected!** You will get errors!

The reason is because C++/CX causes some problems with the C programming language. I am not familiar with the exact issues, but they are enough that we must, for all C files, disable C++/CX support.

For every C file, right click in to it&#8217;s properties. Go to **C/C++ -> General** and set **Consume Windows Runtime Extensions** to **No**.

## Pointer Input &#8211; Mouse, Touch and Pen

Mouse, Touch, and Pen inputs have been collapsed in to a singular concept of &#8220;Pointer Input&#8221;. Their events are available as 3 function calls (members of IFrameworkView): **OnPointerPressed**, **OnPointerMoved**, **OnPointerReleased** (NOTE: Released omitted from default app). Pressed and Released handle changes to touching/clicking states, and Moved handles changes to position via dragging and hovering. For the most part, all the data you need inside those two functions comes from the &#8220;args&#8221; argument.

  * args->CurrentPoint->Position &#8211; Where!?!
  * args->CurrentPoint->PointerId &#8211; Which multi-touch point it is
  * args->CurrentPoint->PointerDevice->PointerDeviceType &#8211; Is it Mouse, Touch, or Pen?

In the case of the missing function (OnPointerMoved), the actual event handler function is bound to the Window inside the SetWindow function of your derived IFrameworkView instance. For reference, here is the entire SetWindow function borrowed from the example &#8220;Shapes Puzzle&#8221; sample program.

<pre class="lang:c++ decode:true " >void ShapesPuzzle::SetWindow(CoreWindow^ window)
{
    m_program = ref new Program();
    m_program-&gt;Initialize(window);

    window-&gt;PointerCursor = ref new CoreCursor(CoreCursorType::Arrow, 0);

    window-&gt;PointerPressed +=
        ref new TypedEventHandler&lt;CoreWindow^, PointerEventArgs^&gt;(this, &ShapesPuzzle::OnPointerPressed);

    window-&gt;PointerMoved +=
        ref new TypedEventHandler&lt;CoreWindow^, PointerEventArgs^&gt;(this, &ShapesPuzzle::OnPointerMoved);

    window-&gt;PointerReleased +=
        ref new TypedEventHandler&lt;CoreWindow^, PointerEventArgs^&gt;(this, &ShapesPuzzle::OnPointerReleased);

    window-&gt;SizeChanged +=
        ref new TypedEventHandler&lt;CoreWindow^, WindowSizeChangedEventArgs^&gt;(this, &ShapesPuzzle::OnWindowSizeChanged);

    DisplayProperties::LogicalDpiChanged +=
        ref new DisplayPropertiesEventHandler(this, &ShapesPuzzle::OnLogicalDpiChanged);

    DisplayProperties::DisplayContentsInvalidated +=
        ref new DisplayPropertiesEventHandler(this, &ShapesPuzzle::OnDisplayContentsInvalidated);

    DirectXBase::Initialize(window, DisplayProperties::LogicalDpi);
}
</pre>

In our case, we only care about the window->PointerReleased line, but the full example is pasted above for message reference. Also of note, it seems this sample, they constructed their &#8220;Program&#8221; inside SetWindow. I don&#8217;t like this. They also use Direct2D. The Direct3D we&#8217;re basing our app off doesn&#8217;t do this, so I will assume this is unimportant.

## Direct3D 11

Windows 8 apps, no matter the device, use Direct3D 11 hardware acceleration. Of course, a classic Netbook is not expected to be able to do fancy D3D11 style effects at a reasonable framerate. So instead, a feature of D3D11 is the concept of profiles. Each profile is equivalent to a specific Direct3D spec. For example, you can target a Direct3D 9 device (i.e. classic Netbooks) whilst using the Direct3D 11 API by only using features supported by Direct3D 9.

Direct3D 11, like OpenGL ES 2, only supports shaders. In fact, it goes a little bit further than OpenGL ES 2. You are required to use:

  * Vertex and Pixel Shaders (No Immediate Mode)
  * Render Targets (The default context is one)
  * Vertex and Index Buffer Objects (No way to pass verts/indexes directly)
  * Constant Buffer Objects (How you pass globals to the shader)

Shader files have a &#8220;.hlsl&#8221; extension. Each file added to the project **MUST** be individually configured in its project properties (**Shader Type**), so Visual Studio knows what kind of shader it is.

Omitted in the documentation (or it&#8217;s just hard to find) is a VERY important note on shading languages. [The documentation says](http://msdn.microsoft.com/en-us/library/windows/desktop/bb509647(v=vs.85).aspx) Direct3D 9 shaders need to be written differently than Direct3D 11 shaders. This is true, however Visual Studio 2012 includes some new compatibility features. **Shader Model 4 Level 9_3**, and **Level 9_1** respectfully. Like the names suggest, they are the syntax of Shader Model 4 (Direct3D 11) but restricted to the feature-set of Direct3D 9.1 and 9.3 respectfully. Typically, you would have to rename some parts of your shader; SV\_TARGET->COLOR, SV\_POSITION->POSITION. This is a nicety for forward thinking code.

[HLSL documentation is here](http://msdn.microsoft.com/en-us/library/windows/desktop/bb509615(v=vs.85).aspx).

Chart of Feature Levels and supported Direct3D 11 features [is here](http://msdn.microsoft.com/en-us/library/windows/desktop/ff476876(v=vs.85).aspx#Overview).

### Compiling the Shader

I&#8217;m porting a 2D game (Smiles HD) to Windows 8, and something I rely on is being able to feed 2D vertices to the 3D hardware. When we did the Windows Phone 7 port of the game (C# XNA), one notable thing we couldn&#8217;t do was make a rendering call with a 2 part vertex (x,y). Instead, our only choice was a 3 part (x,y,z). This was due to Windows Phone 7 not actually supporting shaders; Well, it did support shaders, but nobody was allowed to write custom ones. You could only use the built in ones.

Now however with Windows 8 (and likely Windows Phone 8), we can write custom shaders.

Windows stuff tends to use a lot of &#8220;populate a structure, pass the structure&#8221; idioms. Notably, in our shader case, we need to populate a **D3D11\_INPUT\_ELEMENT_DESC** structure, which is an array describing what the input data the shader expects actually is. [Details are here](http://msdn.microsoft.com/en-us/library/windows/desktop/ff476180(v=vs.85).aspx).

What I found interesting about the details of this structure are that it describes Vertices with RGB terminology. For example, **DXGI\_FORMAT\_R32G32B32_FLOAT** is standard 3 part vector (x,y,z). So the version I was after was **DXGI\_FORMAT\_R32G32_FLOAT** (no blue). The full [list of options is here](http://msdn.microsoft.com/en-us/library/windows/desktop/bb173059(v=vs.85).aspx).

So, to define a shader, you need:

  * Vertex Shader Object (**ID3D11VertexShader***) along with its source code
  * Pixel Shader Object (**ID3D11PixelShader***) along with its source code
  * Input Layout Object (**ID3D11InputLayout***), along with an array of **D3D11\_INPUT\_ELEMENT_DESC** objects, to describe to Direct3D what sort data you are giving it, and the internal names to bind to.
  * A local copy of your Constant Buffer Data (define your own type)
  * A remote copy of your Constant Buffer Data that you send as a Buffer Object (**ID3D11Buffer***)

The code I&#8217;ll leave as an exercise to the reader. Just go look at the Direct3D 11 sample. You&#8217;ll find it in CreateDeviceResources(). The sample app loads the data asynchronously, and makes one of the first serious uses of C++11 Lambda functions I&#8217;ve seen, paired with Microsoft&#8217;s PPL Parallel Programming Library (see PPL).

Unlike OpenGL, you don&#8217;t link your shader objects to a Program object. Instead, they are specified individually every time you use it.

### Primitive Render Types

To set the rendering mode, you call **m_d3dContext->IASetPrimitiveTopology**. Direct3D 11 can only render:

  * Points
  * Line Lists and Line Strips
  * Triangle Lists and Triangle Strips

This means no Line Loops, and no Triangle Fans (Quads are not available in OpenGL ES either).

Direct3D 11 also has its own special render types: Adjacent Lines and Adjacent Triangles. 

[Details here](http://msdn.microsoft.com/en-us/library/windows/desktop/ff728726(v=vs.85).aspx).

### Buffer Objects

TODO: This.

TIP: They are much easier to use with Windows::WRL::ComPtr<>. Wrap them with ComPtr, then use & to get the type, and .Get() to get the data. They are automatically released from VRAM once the ComPtr type goes out of scope.

TODO: Confirm if it&#8217;s DATA or the Pointer you get from Get().

### Setting Render States

You populate the **D3D11\_RASTERIZER\_DESC** structure, and call a few functions.

<pre class="lang:default decode:true " >const D3D11_RASTERIZER_DESC RasterizerDesc = { 
		D3D11_FILL_SOLID,	// SOLID; WIREFRAME
		D3D11_CULL_NONE,	// NONE (no culling); BACK; FRONT
		true,				// Front faces are Counter Clockwise
		0,					// Depth Bias added to pixels
		0.0f,				// Depth Bias Clamp (maximum bias)
		0.0f,				// Slope Scaled Depth Bias
		true,				// Depth Clipping Enabled
		false,				// Scissor Test
		false,				// Multisampling
		false				// Antialiased Lines
	};

	Microsoft::WRL::ComPtr&lt;ID3D11RasterizerState&gt; RasterizerState;

	m_d3dDevice-&gt;CreateRasterizerState( &RasterizerDesc, &RasterizerState );
	m_d3dContext-&gt;RSSetState( RasterizerState.Get() );</pre>

More details [are here](http://msdn.microsoft.com/en-us/library/windows/desktop/ff476198(v=vs.85).aspx).

### Texturing

Ya

### Graphical Debugging

Exclusive to Visual Studio 2012 Professional (i.e. **NOT** Express) are a suite of GPU debugging tools. If you&#8217;re familiar with gDEBugger or PIX, it&#8217;s a set of tools similar to this. Most notably is a special kind of screenshot capture that captures the entire state of the graphics pipeline, and lets you drill down to the functions calls that hit each pixel. Very cool. You can do this both locally, or remotely (on an external ARM device for example). Install the correct version of the Remote Tools on the device (x86, x64, ARM).

To use Graphics Capture, press **ALT+F5** (instead of the usual F5) to run. Alternatively, it can be found under **Debug->Graphics->Start Diagnostics**. [Details here](http://msdn.microsoft.com/en-us/library/hh708963.aspx).

If like me, you ran in to issues on the very first frame, you can alternatively activate the capture manually in code. It&#8217;s easy to do (include a header, call a function). [More details here](http://msdn.microsoft.com/en-us/library/hh780905.aspx).

<pre class="lang:default decode:true " >#include &lt;vsgcapture.h&gt;

...
	// Do Update Code //

	g_pVsgDbg-&gt;CaptureCurrentFrame();

	// Do Render Code //
	// Do Present //
...</pre>

Fairly important is that you call CaptureCurrentFrame() **\*BEFORE\*** you render anything. This was a mistake I made (calling it after, before Present). It gave me black screen captures (lame).

If above is all you do, then it places the capture data in:

`C:\Users\MyName\AppData\Local\Packages\?????\TempState`

Where MyName is your user account name, and ????? is your apps unique number (i.e. something like 4c111710-8e11-123d-22f5-f4123d4e974f_et38arurdrp4). Knowing your number can be extremely difficult so I suggest just going to the Local\Packages folder, and sorting by date. You&#8217;ll likely be the one at the top (or near it).

**NOTE**: Including vsgcapture.h causes your &#8220;F5 to run&#8221; to enable graphics capture mode, thus slowing you down.

## File IO

The preferred method of reading in data files is to read them asynchronously. That said, changing existing game code to support an Async pattern is a lot of work.

It does seem classic FILE* and fopen are supported. However, like on the Mac and iOS, you are living in a sandboxed environment. [Reference here](http://social.msdn.microsoft.com/Forums/fi-FI/winappswithnativecode/thread/ae1dead2-5ea8-43c8-b124-986cf8b7f668).

A workaround on Mac/iOS was to build a proper path by extracting the base directory you should be working in from environment variables. This may be possible, but I think there is another problem.

I haven&#8217;t confirmed this yet, but something I was reading suggested that apps on Windows 8 are packaged in to ZIP compatible archives. I&#8217;m not 100% sure yet, but it seems Windows 8 Apps may have &#8220;the Android native problem&#8221;, meaning your data is available, but it must be extracted from the ZIP manually (one can not just build a path to it). Alternatively, using the Async calls like Microsoft suggests hides all this complexity from you.

Still investigating.

EDIT: It looks like I&#8217;m wrong. A properly installed appx is a full proper path, not a zip file (only zipped as a package file that is shared).

## PPL &#8211; Parallel Programming Library

I actually quite like this library of Microsoft&#8217;s. It&#8217;s a very slick design pattern you can use for queuing tasks to occur once something has finished (file reading, for example).

PPL uses the keyword &#8220;then&#8221; to describe a function to be called (usually a C++11 Lambda function). It&#8217;s clean (mostly), and its design actually solves a common nesting problem. 

?? Instead of nesting function inside of function inside of function, you are adding functions to a queue??

TODO: Verify above PPL behavior&#8230; just an assumption how it works better.

TODO: Add Channel 9 PPL interview video here.

## COM and ComPtr

The Windows Runtime Library borrows heavily from COM and builds on it. Aside from the ^ hat syntax (designed to make COM better), the &#8220;Microsoft::WRL&#8221; namespace contains additional borrowed items.

Microsoft::WRL::ComPtr<> is a smart pointer. It&#8217;s based on COM&#8217;s CComPtr. It calls a Release() function once the type goes out of scope.

## Printing to the Debug window

Use OutputDebugString.

<pre class="lang:default decode:true " >OutputDebugString( L"This is my wchar_t text message\n" );
OutputDebugStringA( "This is my char (Ascii) text message\n" );
// OutputDebugStringW writes unicode, but I don't know how to make a unicode string. u"hello?".</pre>

[Reference](http://seaplusplus.com/2012/06/25/printf-debugging-in-metro-style-apps/).

The link above also contains information how to enable a classic output console. However, in my tests, I was unable to change the properties of the console from the default of 25 lines to something way bigger. That makes it unusable, so I went with OutputDebugString instead.

## Certificates and Signing

TODO: Everything in this section is wrong. I was using the wrong versions of Windows 8 on both PC (RTM on Dev machine, Consumer Preview on the other). All you really need to do is package, then on the new machine, right click and run the power shell script found in the test package.

Durrrrrrr!

How to sign: http://msdn.microsoft.com/en-us/library/windows/apps/br230260.aspx

How to test on other computers: http://msdn.microsoft.com/en-us/library/windows/apps/hh975356.aspx

When you screw up your certificates, how to get in so you can edit them: http://social.technet.microsoft.com/wiki/contents/articles/2167.how-to-use-the-certificates-console.aspx

\***

&#8211; You&#8217;ll need a keyboard, as much of the actual work is done through Power Shell (run in admin mode).
  
&#8211; You&#8217;ll need to install a developer license (should only require a Microsoft account, and you can do it from the Power Shell: http://msdn.microsoft.com/en-us/library/windows/apps/hh974578.aspx )
  
&#8211; You&#8217;ll need to enable a group policy for sideloading (via gpedit.msc or setting the registry key: http://technet.microsoft.com/en-us/library/hh852635.aspx )
  
&#8211; (I think) you need to install the certificate that comes with a test build. It also must be installed in a specific location (Local Machine -> Trusted Root Certificate Authorities, or Local Machine -> Trusted People). I&#8217;m unsure about this, as the next step may do it for you (but my appx isn&#8217;t working correctly yet).
  
&#8211; To install (the easy way), you run a bundled power shell script ( http://msdn.microsoft.com/en-us/library/windows/apps/hh975356.aspx )

## Strings&#8230; char\* to wchar_t\*, std::string and std::wstring

&#8211; http://msdn.microsoft.com/en-us/library/dd319072%28v=vs.85%29.aspx
  
&#8211; http://blog.mijalko.com/2008/06/convert-stdstring-to-stdwstring.html
  
&#8211; http://social.msdn.microsoft.com/forums/en-US/vssmartdevicesnative/thread/bc0dc676-1f2c-4cd8-9bfd-84c6b94bb8d8
  
&#8211; http://stackoverflow.com/questions/2573834/c-convert-string-or-char-to-wstring-or-wchar-t
  
&#8211; http://www.cplusplus.com/reference/clibrary/cstdlib/mbstowcs/

### Debugging with system dll symbols

Often when you run a program, you get errors in the debug log about missing symbols from the DLLs. As it turns out, you can actually get these symbols by enabling a Microsoft Symbols server. Details [in this article](http://stackoverflow.com/questions/4561477/why-am-i-encountering-errors-when-i-try-to-use-the-visual-studio-analyzer).

## TODO

&#8211; ??

## Misc

&#8211; http://channel9.msdn.com/Events/Windows-Camp/Developing-Windows-8-Metro-style-apps-in-Cpp
  
&#8211; http://channel9.msdn.com/Events/BUILD/BUILD2011?sort=sequential&direction=desc&term=c%2B%2B
  
&#8211; http://msdn.microsoft.com/en-us/library/windows/apps/hh700360.aspx
  
&#8211; Life Cycle: http://msdn.microsoft.com/en-us/library/windows/apps/hh464925.aspx

&#8211; Supporting Win32 and WinRT: http://blogs.msdn.com/b/chuckw/archive/2012/09/17/dual-use-coding-techniques-for-games.aspx
  
&#8211; http://blogs.msdn.com/b/chuckw/archive/2012/09/18/dual-use-coding-techniques-for-games-part-2.aspx