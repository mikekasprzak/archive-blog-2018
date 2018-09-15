---
title: 'Notes: Modern C++ Android GameDev from scratch'
layout: post
---

Android has changed a lot (for the better). There are still elements of Java around, but we can avoid it. The biggest plus is that we _can_ now use the Android tools in a typical GCC/Makefile (none of this proprietary NDK garbage).

Here are some things to know.

### Starting August 2019, 64bit Binaries are REQUIRED
This is an important detail. Many devices are still 32bit devices, so from now on you NEED to make sure your toolchain builds both 32bit and 64bit ARM binaries. Since you're doing it, you might as well do x86 binaries as well (wouldn't hurt).

## Setup
If you're a command-line guy (hello), Google gives you the choice to just grab the Command Line Tools.

[https://developer.android.com/studio/#downloads](https://developer.android.com/studio/#downloads)

Go there, and scroll down until you find them.

Next you'll need the NDK. Yes, it's still separate. :sweat_smile:

[https://developer.android.com/ndk/downloads/](https://developer.android.com/ndk/downloads/)

Grabbing the latest of both is fine.

I unzipped the files here:

```
~/android/tools/ # the SDK only had a tools folder
~/android/ndk/android-ndk-r17c/ # the latest NDK
```

Out of the box the SDK needs more stuff. Before you can get any of that stuff, you need to make sure `sdkmanager` is configured properly.

### Setting up SDKMANAGER
It _should_ work out-of-the-box, but it doesn't (shame on you Google).

```
cd ~/android/tools/bin/
./sdkmanager --list
```

I followed this guide to _fix_ `sdkmanager`: [https://stackoverflow.com/a/47150411](https://stackoverflow.com/a/47150411)

Mainly this involved editing the `sdkmanager` shell script and changing the `DEFAULT_JVM_OPTS` line to this:

```
DEFAULT_JVM_OPTS='"-Dcom.android.sdklib.toolsdir=$APP_HOME" -XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
```

Now you should be able to do an `./sdkmanager --list`.

### Using SDKMANAGER
`./sdkmanager --list` will show you what packages are available. In general you want these packages.

```
sdkmanager “platform-tools” “platforms;android–28” “build-tools;28.0.2”
```
 
That said, you _should_ double check `sdkmanager` if there are newer (non-beta) versions, and use that. Running the above command will download the missing packages in to your `~/android/` folder.

## Standalone Toolchains
The next step is to extract the various toolchains from the NDK. Google provides a handy python script that does this for you. Reference: [https://developer.android.com/ndk/guides/standalone_toolchain](https://developer.android.com/ndk/guides/standalone_toolchain)

Browse here and run the tool:

```
cd ~/android/ndk/android-ndk-r17c/build/tools
./make_standalone_toolchain.py --arch arm --api 21 --install-dir ~/android/ndk-arm
./make_standalone_toolchain.py --arch arm64 --api 21 --install-dir ~/android/ndk-arm64
./make_standalone_toolchain.py --arch x86 --api 21 --install-dir ~/android/ndk-x86
./make_standalone_toolchain.py --arch x86_64 --api 21 --install-dir ~/android/ndk-x86_64
```

### Android Versions
You'll notice above that the API version is called out. At the time of this writing, Google no longer supports versions before API 16. That said, you might discover than API 16 is a bit troublesome.

Reference: [https://developer.android.com/about/dashboards/](https://developer.android.com/about/dashboards/)

From a game developers perspective, here's a quick breakdown of the various Android API versions.

* **Older APIs** - Android 2.x to 4.0 - 0.6% marketshare
* **API 16** [Jellybean] - Android 4.1 to 4.3 - 3.5% marketshare, OpenGL ES 2.0, **BAD** headers
* **API 19** [Kitkat] - Android 4.4 - 8.6% marketshare, OpenGL ES 3.0`*`, **BAD** headers
* **API 21** [Lollipop] - Android 5 and 6 - 31.9% marktshare, OpenGL ES 3.1, 64bit CPU support (ARM64 and x86_64), **GOOD** Headers
* **API 24** [Nougat] - Android 7.x - 30.8% marketshare, Vulkan, OpenGL ES 3.2, **GOOD** headers
* **Newer APIs** - Android 8+ - 14.6% marketshare

Notably (`*`) OpenGL ES 3.0 support was actually first introduced in the tail end of Jellybean, but it's more sensible to consider it an API 19+ feature.

### BAD and GOOD headers
Together, APIs 16 and 19 are still **12.1%** of the market (at the time of this writing), so you still need to care a bit about BAD and GOOD header debacle. For whatever reason, earlier versions of Android shipped with an incomplete/paired down version of the standard Linux headers. In several cases functions like `atoi` were wrapped by `#DEFINE` macros or inline functions that called other functions that did the same thing. More notoriously several functions were missing like `epoll_create1`, which at least in this case was an easy fix (change it to `epoll_create`). Ultimately the headers didn't exactly match what you'd find in a typical Linux distro yet.

That said, starting with API 21, the headers were replaced with the more-standardized Linux ones, so porting is now less effort. That said, you give up **12.1%** of all Android users if you do.

If you want to maximize the potential number of devices you can target, change the `make_standalone_toolchain` lines above and select `16` (i.e. API 16) for both of the 32bit platforms (i.e. `arm` and `x86`). The earliest API you can select for 64bit platforms is API `21`, so leaves those the same. API's before 16 are deprecated, so Google may not approve your game if you target them.

```
cd ~/android/ndk/android-ndk-r17c/build/tools
./make_standalone_toolchain.py --arch arm --api 16 --install-dir ~/android/ndk-arm
./make_standalone_toolchain.py --arch arm64 --api 21 --install-dir ~/android/ndk-arm64
./make_standalone_toolchain.py --arch x86 --api 16 --install-dir ~/android/ndk-x86
./make_standalone_toolchain.py --arch x86_64 --api 21 --install-dir ~/android/ndk-x86_64
```

If you previously ran the commands, you might have to set a different `--install-dir`, or delete the old ones.

## Using the Standalone Toolchain
The preferred compiler for Android is Clang. As of the time of this writing (NDK R17), GCC is still available, but according to release notes it will be gone in R18+. 

You can find the compilers here (and their equivalents):

```
cd ~/android/ndk-arm/bin/
```

In the above case you'll want to compile with `clang` and `clang++`, link with `arm-linux-androideabi-ld` (soon `llvm-ldd` or use `clang` as a wrapper), and make libraries with `llvm-ar`.

**Very important**: Be sure to enable Position Indepence when compiling your source files. This is required, especially when creating Unity plugins (both IL2CPP and Mono). Just be sure you get the correct PI mode.

```bash
CODE_FLAGS     :=   -fPIE -fPIC     # pass these to clang and clang++
LD_FLAGS       :=   -pie
```

**PIE** stands for Position Independent Executable, and **PIC** for Position Independent Code. Their usage can be a bit confusing

* Use `-fPIE` (and `-pie`) on executables and static libraries (i.e. `libthing.a`)
* Use `-fPIC` on shared libraries (i.e. `thing.dll`, `libthing.so`)

Or just use both always, and the correct one will be used (??? or at least my references do, and it doesn't appear to hurt).

## A note on Unity, Mono and IL2CPP
The above should be everything you need to get a working Mono `.so` shared library or a `.a` static library you can link to a Unity project. Unity is not my intent here, but much of this information came from working (see struggling) to make a file Unity could understand.

Don't forget your `AndroidManifest.xml` file. I forget what settings mattered, but neglecting that also made the above a struggle.

Don't forget your `PIE` and `PIC`!! Unity would cry about the libraries not being valid libraries if `PIE` wasn't set.

Getting a working plugin library for IL2CPP was nightmarish. Dealing with `.a` static libraries is far more temperamental than `.so` shared libraries. 

The `ar` tool has less reasons to raise a red flag (it just packs several `.o` files together, doesn't really check anything). Your errors will instead show up in Unity. If you use them, templated classes will sometimes need to be prototyped (i.e. `template class MyClass<int>;`). 

Also `#include <iostream>` has a tendency to emit bad code (i.e. `std::ios_base::Init::Init()`). You can solve that by removing the include.

If you find that `atoi`, `rand`, or a bunch of seemingly common functions are missing, or certain devices just don't start, then your game was probably built used a compiler with the GOOD headers (i.e. API 21+) instead of one with the BAD headers. Swap out your standalone toolchain for a fixed one, and try again.

## Wrapup
That covers the highlights. I haven't yet setup my new SDL2 Android toolchain, so consider this part-1. Generally though we'll be working with the tools and things we setup here.