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

ee