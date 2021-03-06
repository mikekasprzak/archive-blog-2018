---
id: 6982
title: Setting up NaCL and SDL (on a fresh Ubuntu)
date: 2014-06-06T16:02:56+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6982
permalink: /2014/06/06/setting-up-nacl-and-sdl-on-a-fresh-ubuntu/
categories:
  - Linux
  - Technobabble
---
Some notes on getting NaCl working. Of course, things didn&#8217;t work out-of-the box. 

## Install nacl_sdk

Grab and follow the instructions here:

<https://developer.chrome.com/native-client/sdk/download>

i.e. download and do the following:

<pre>./naclsdk update</pre>

## Install 32bit Headers

&#8216;cmon, everybody runs 64bit Linux these days (in my case Ubuntu 14.04 64bit). You need the 32bit libraries for anything to build though.

<pre>sudo apt-get install libc6:i386 libstdc++6:i386</pre>

Source: <http://stackoverflow.com/questions/23661718/native-client-tutorial-cant-find-libstdc>

## Follow Tutorial

&#8216;make serve&#8217; will now work.

<https://developer.chrome.com/native-client/devguide/tutorial/tutorial-part1>

Test2 probably wont run though. I haven&#8217;t checked, but I think it may not be a pnacl file (pnacl is necessary to run in a stock Chrome).

**EDIT:** The problem with Test2 is that newlib is the first Toolchain. If you modify the Makefile by making pnacl the first VALID_TOOLCHAINS (or commenting out the line entirely), and change index.html, the data-tools attribute of the body tag, make pnacl first, it will work correctly.

Now, lets see how far we get compiling SDL NaCL.

## Set Environment Variables for SDL

Reference: [https://hg.libsdl.org/SDL/file/ae720d61d14d/README-nacl.txt](https://hg.libsdl.org/SDL/file/ae720d61d14d/README-nacl.txt#l16)

Do something like the following.

<pre>export NACL_SDK_ROOT=`readlink -f ../nacl_sdk/pepper_35/`
export CFLAGS="$CFLAGS -I$NACL_SDK_ROOT/include"
export CC="$NACL_SDK_ROOT/toolchain/linux_pnacl/bin/pnacl-clang"
export AR="$NACL_SDK_ROOT/toolchain/linux_pnacl/bin/pnacl-ar"
export LD="$NACL_SDK_ROOT/toolchain/linux_pnacl/bin/pnacl-ar"
export RANLIB="$NACL_SDK_ROOT/toolchain/linux_pnacl/bin/pnacl-ranlib"</pre>

&#8216;readlink -f&#8217; takes a path and converts it in to an absolute path (by following symlinks, ..&#8217;s, etc). If you&#8217;re on Windows, substitute it for the absolute path to your pepper directory. Mine is **/home/mike/Work/Build/nacl\_sdk/pepper\_35**

And of course, edit your pepper version accordingly (35 or whatever).

## Build SDL2 in NaCL mode

SDL must be built outside the main SDL directory. I like to call my SDL directory &#8220;SDL2&#8221;, and do builds in directories like &#8220;SDLBuild&#8221;. I invoke my build like follows:

<pre>../SDL2/configure --host=pnacl --prefix `readlink -f $NACL_SDK_ROOT/SDL`
make
make install</pre>

Notably, I&#8217;m putting the output (make install) inside the SDL subdirectory of the pepper SDK folder.

## The Makefile

**EDIT:** For the makefile to work, I had to make a few changes. Here is the full modified makefile.

<pre># Copyright (c) 2013 The Chromium Authors. All rights reserved.
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

# GNU Makefile based on shared rules provided by the Native Client SDK.
# See README.Makefiles for more details.

VALID_TOOLCHAINS := pnacl

# NACL_SDK_ROOT ?= $(abspath $(CURDIR)/../../..)
include $(NACL_SDK_ROOT)/tools/common.mk


TARGET = sdl_app
DEPS = ppapi_simple nacl_io
# ppapi_simple and SDL2 end up being listed twice due to dependency solving issues -- Gabriel
LIBS = SDL2_test SDL2 ppapi_simple SDL2main SDL2 $(DEPS) ppapi_gles2 ppapi_cpp ppapi pthread 

CFLAGS := -Wall -I$(NACL_SDK_ROOT)/SDL/include/SDL2
SOURCES ?= ../testgles2.c

PNACL_LDFLAGS += -L$(NACL_SDK_ROOT)/SDL/lib

# Build rules generated by macros from common.mk:
# Overriden macro from NACL SDK to be able to customize the library search path -- Gabriel
# Specific Link Macro 
#
# $1 = Target Name
# $2 = List of inputs
# $3 = List of libs
# $4 = List of deps
# $5 = List of lib dirs
# $6 = Other Linker Args
#
# For debugging, we translate the pre-finalized .bc file.
#
define LINKER_RULE
all: $(1).pexe 
$(1)_x86_32.nexe : $(1).bc
	$(call LOG,TRANSLATE,$$@,$(PNACL_TRANSLATE) --allow-llvm-bitcode-input -arch x86-32 $$^ -o $$@)

$(1)_x86_64.nexe : $(1).bc
	$(call LOG,TRANSLATE,$$@,$(PNACL_TRANSLATE) --allow-llvm-bitcode-input -arch x86-64 $$^ -o $$@)

$(1)_arm.nexe : $(1).bc
	$(call LOG,TRANSLATE,$$@,$(PNACL_TRANSLATE) --allow-llvm-bitcode-input -arch arm $$^ -o $$@)

$(1).pexe: $(1).bc
	$(call LOG,FINALIZE,$$@,$(PNACL_FINALIZE) -o $$@ $$^)

$(1).bc: $(2) $(foreach dep,$(4),$(STAMPDIR)/$(dep).stamp)
	$(call LOG,LINK,$$@,$(PNACL_LINK) -o $$@ $(2) $(PNACL_LDFLAGS) $(foreach path,$(5),-L$(path)/pnacl/$(CONFIG)) -L./lib $(foreach lib,$(3),-l$(lib)) $(6))
endef

$(foreach dep,$(DEPS),$(eval $(call DEPEND_RULE,$(dep))))
$(foreach src,$(SOURCES),$(eval $(call COMPILE_RULE,$(src),$(CFLAGS))))

ifeq ($(CONFIG),Release)
$(eval $(call LINK_RULE,$(TARGET)_unstripped,$(SOURCES),$(LIBS),$(DEPS)))
$(eval $(call STRIP_RULE,$(TARGET),$(TARGET)_unstripped))
else
$(eval $(call LINK_RULE,$(TARGET),$(SOURCES),$(LIBS),$(DEPS)))
endif

$(eval $(call NMF_RULE,$(TARGET),))

serve: all
	$(HTTPD_PY) -C $(CURDIR) --no-dir-check
</pre>

The changes are lines 19 and 20. Line 22 is new, as are lines 67 and 68. The last 2 lines are a hack to make &#8220;make serve&#8221; work the same as it does in the NaCl demos.

Here&#8217;s a diff.

<pre>--- a/test/nacl/Makefile	Fri Jun 13 14:52:26 2014 -0400
+++ b/test/nacl/Makefile	Sat Jun 14 13:44:39 2014 -0400
@@ -16,8 +16,10 @@
 # ppapi_simple and SDL2 end up being listed twice due to dependency solving issues -- Gabriel
 LIBS = SDL2_test SDL2 ppapi_simple SDL2main SDL2 $(DEPS) ppapi_gles2 ppapi_cpp ppapi pthread 
 
-CFLAGS := -Wall
-SOURCES ?= testgles2.c
+CFLAGS := -Wall -I$(NACL_SDK_ROOT)/SDL/include/SDL2
+SOURCES ?= ../testgles2.c
+
+PNACL_LDFLAGS += -L$(NACL_SDK_ROOT)/SDL/lib
 
 # Build rules generated by macros from common.mk:
 # Overriden macro from NACL SDK to be able to customize the library search path -- Gabriel
@@ -61,3 +63,6 @@
 endif
 
 $(eval $(call NMF_RULE,$(TARGET),))
+
+serve: all
+	$(HTTPD_PY) -C $(CURDIR) --no-dir-check
</pre>

For reference, my old notes (before I got it working by changing the makefile):

<del datetime="2014-06-14T17:29:31+00:00">Okay, this didn&#8217;t actually work. I&#8217;m not sure exactly how it&#8217;s supposed to be configured, but it&#8217;s not configured correctly. It should only be used as a reference. Some other notes of things I had to do to get it to work:</p> 


  <pre>export C_INCLUDE_PATH=$NACL_SDK_ROOT/../SDL/include/SDL2 $C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=$NACL_SDK_ROOT/../SDL/include/SDL2 $CPLUS_INCLUDE_PATH
export LIBRARY_PATH=$NACL_SDK_ROOT/../SDL/lib $LIBRARY_PATH

Use CPATH instead of C_INCLUDE_PATH and CPLUS_INCLUDE_PATH. It's both.</pre>



  <p>
    </del>
  </p>



  <h2>
    naclbuild script
  </h2>



  <p>
    Alternatively, once the environment is set correctly (I think just NACL_SDK_ROOT) it&#8217;ll work. In the &#8216;build-tools&#8217; folder is a script &#8216;naclbuild&#8217;. Run that, and it&#8217;ll put some output in the Build folder. Once it finishes, it gives you a string to copy+paste in to your shell. Do it.
  </p>



  <p>
    Vine Videos: <a href="https://vine.co/v/MDnA1x9aPMe">https://vine.co/v/MDnA1x9aPMe</a>, <a href="https://vine.co/v/MDn6I6UFWPF">https://vine.co/v/MDn6I6UFWPF</a>
  </p>



  <p>
    Currently works on Desktop Chrome, and Chrome OS. Will not work on Android (<a href="https://groups.google.com/forum/#!topic/native-client-discuss/PEZP458cVQY">yet</a>).
  </p>