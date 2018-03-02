---
id: 6232
title: Barebones Useful Generic Makefile
date: 2013-05-11T11:49:11+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6232
permalink: /2013/05/11/barebones-useful-generic-makefile/
categories:
  - Technobabble
---
This seems to happen a lot for me. I&#8217;m testing/playing around with some code thing, and I set up some cheeseball compiling in a shell script. Then I get to a point and it&#8217;s just not enough, the compiling is taking too long, or so one. My major projects often have a nice makefile setup going, but my experiments, not so much. That&#8217;s because writing a makefile, despite being the same thing again and again for me, is tricky to get right.

So here&#8217;s a generic makefile I&#8217;d typically use. I&#8217;m posting it here so I can steal it as needed, but feel free to use it and hack away at it; That&#8217;s what makefiles are for. 🙂

This makefile is designed for simple GCC/G++ usage. It&#8217;s designed to put temporary/object files in an &#8220;**obj/**&#8221; folder, and the final binary in the &#8220;**output/**&#8221; folder. Also the generated file can be executed from the make command (via &#8216;make run&#8217;). If you have a specific set of command line arguments you want to pass to the program, specify them in the ARGS variable.

Lines that are too long should end with a &#8220;\&#8221; character, which continues on to the next line. **Make sure there are no spaces after the &#8220;\&#8221;!!!**

I&#8217;ve also included an optional common tweak I often do. Un-comment the SRC_PREFIX line to assume all code files and paths specified are in a &#8220;**src/**&#8221; folder.

<pre class="lang:default decode:true " title="Generic Makefile" ># - ------------------------------------------------------------------------ - #
# Generic Makefile v0.1 by Mike Kasprzak (http://toonormal.com)
# usage: make | make info | make clean | make run
# - ------------------------------------------------------------------------ - #
TARGET_FILE     :=  MyGame.exe
ARGS            :=  
# - ------------------------------------------------------------------------ - #

# - ------------------------------------------------------------------------ - #
# Symbols (macros) to define ### e.g. USES_SOMETHING SOME_TEXT="Hello"
DEFINES         :=
# - ------------------------------------------------------------------------ - #

# - ------------------------------------------------------------------------ - #
# Path to individual source files ### e.g. Engine/Main.cpp Game/Player.c
SRC_FILES       :=
# - ------------------------------------------------------------------------ - #
# Folders to search for source files ### e.g. zlib zlib/extras squirrel
SRC_FOLDERS     :=  
# - ------------------------------------------------------------------------ - #
# Enable to assume all files are found in a "src/" subfolder (src/myfile.c)
#SRC_PREFIX     :=  src/
# - ------------------------------------------------------------------------ - #

# - ------------------------------------------------------------------------ - #
# Base directories to search for include files ### e.g. zlib squirrel/include
INCLUDE_DIRS    :=  
# - ------------------------------------------------------------------------ - #
# Base directories to search for library files ### e.g. /usr/local/lib mylibs
LIBRARY_DIRS    :=  
# - ------------------------------------------------------------------------ - #
# Library Files to include, with -l ### e.g. -liberty -lsdl_mixer
LIBRARY_FILES   :=  
# - ------------------------------------------------------------------------ - #

# - ------------------------------------------------------------------------ - #
# Compiler Flags ### e.g. --std=gnu++0x -fno-rtti -fno-strict-aliasing
FLAGS           :=
C_FLAGS         :=  $(FLAGS)
CPP_FLAGS       :=  $(FLAGS)
# - ------------------------------------------------------------------------ - #
# Linker Flags ### e.g. -static-libgcc -static-libstdc++ -static -mwindows
LD_FLAGS        :=
# - ------------------------------------------------------------------------ - #

# - ------------------------------------------------------------------------ - #
SRC_FILE_TYPES  :=  .c .cpp
# - ------------------------------------------------------------------------ - #
ALL_SRC_FILES   :=  $(wildcard $(addprefix $(SRC_PREFIX),$(addsuffix /*,$(SRC_FOLDERS))))
SRC_FILES       :=  $(addprefix $(SRC_PREFIX),$(SRC_FILES)) \
                    $(filter $(addprefix %,$(SRC_FILE_TYPES)),$(ALL_SRC_FILES))
# - ------------------------------------------------------------------------ - #
DEFINES         :=  $(addprefix -D,$(DEFINES))
INCLUDE_DIRS    :=  $(addprefix -I$(SRC_PREFIX),$(INCLUDE_DIRS))
LIBRARY_DIRS    :=  $(addprefix -L,$(LIBRARY_DIRS))
# - ------------------------------------------------------------------------ - #
# Where out files will output #
OUTPUT_DIR      :=  output/
OBJ_DIR         :=  obj/
# - ------------------------------------------------------------------------ - #
TARGET          :=  $(OUTPUT_DIR)$(TARGET_FILE)
# - ------------------------------------------------------------------------ - #
O_FILES         :=  $(addprefix $(OBJ_DIR),$(addsuffix .o,$(SRC_FILES)))
# - ------------------------------------------------------------------------ - #
O_DIRS          :=  $(sort $(dir $(O_FILES)))
# - ------------------------------------------------------------------------ - #
# Commands for Compiling C code, C++ code, and Linking #
CC              :=  gcc
CXX             :=  g++
LD              :=  $(CXX)
# NOTE: Using the C++ compiler for linking instead of ld because it's simpler. #
# - ------------------------------------------------------------------------ - #
RUN             :=  ./$(TARGET) $(ARGS)
# - ------------------------------------------------------------------------ - #


# - ------------------------------------------------------------------------ - #
# Link Command #
# - ------------------------------------------------------------------------ - #
$(TARGET): _makedirs $(O_FILES)
    $(LD) $(LD_FLAGS) $(LIBRARY_DIRS) $(O_FILES) $(LIBRARY_FILES) -o $@
# - ------------------------------------------------------------------------ - #

# - ------------------------------------------------------------------------ - #
# Compile Commands #
# - ------------------------------------------------------------------------ - #
$(OBJ_DIR)%.c.o: %.c
    $(CC) -c $(DEFINES) $(INCLUDE_DIRS) $(C_FLAGS) $&lt; -o $@
# - ------------------------------------------------------------------------ - #
$(OBJ_DIR)%.cpp.o: %.cpp
    $(CXX) -c $(DEFINES) $(INCLUDE_DIRS) $(CPP_FLAGS) $&lt; -o $@
# - ------------------------------------------------------------------------ - #


# - ------------------------------------------------------------------------ - #
_makedirs:
    mkdir -p $(O_DIRS) $(OUTPUT_DIR)
# - ------------------------------------------------------------------------ - #
clean:
    rm -fr $(OBJ_DIR) $(OUTPUT_DIR)
# - ------------------------------------------------------------------------ - #
run:
    $(RUN)
# - ------------------------------------------------------------------------ - #
info:
    @echo TARGET_FILE: $(TARGET_FILE) [$(TARGET)]
    @echo
    @echo SRC_FILES: $(SRC_FILES)
    @echo
    @echo O_FILES: $(O_FILES)
    @echo
    @echo O_DIRS: $(O_DIRS)
# - ------------------------------------------------------------------------ - #
.PHONY: _makedirs clean run info
# - ------------------------------------------------------------------------ - #
</pre>