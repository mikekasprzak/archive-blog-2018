---
title: 'Notes: A quick look at Autoconf and Automake'
layout: post
---

I tend to roll my own makefiles, but I work with a number of open source packages. Time to figure out how these work once and for all.

## M4
Configure scripts are shell scripts written in M4, a macro dialect that can be used in pretty-much any text file. The main `configure` script is actually a generated file, but we'll come back to that.

As a quick primer, an M4 file is treated as a text file until certain commants are hit.

```bash
# INPUT
dnl Lets begin!
one
define(`one’, `ONE’)dnl
one
define(`ONE’, `two’)dnl
one ONE oneONE
`one’

# OUTPUT
one
ONE
two two oneONE
one
```

* `define` is used to define macros.
* back-tick+quote (``` `' ```) is actually how things are quoted. If a thing is not quoted, it'll get evaluated by the macro processor.
* `dnl` stands for "delete new line". It's a command that can be used similar to a comment or REM command. Alternatively it can be used to ensure a command doesn't insert a newline after it executes.

There's a lot more to M4 than what I've described here. This article is a good place to start if you want to know more: [http://www.linux-mag.com/id/163/](http://www.linux-mag.com/id/163/)

## configure.ac -> configure
`configure.ac` (`.ac` for autoconf, sometimes named `configure.in` but this is discouraged) is perhaps the most important file in the autoconf/automake build system. Together with `makefile.am`, these 

`configure.ac` is a simple M4 script that uses several predefined macros to emit the `configure` script.

Sample:

```bash
AC_INIT([helloworm], [0.1], [bob@bob.bob])
AM_INIT_AUTOMAKE
AC_PROG_CC
AC_CONFIG_FILES([Makefile])
AC_OUTPUT
```

When you invoke `autoconf`, the above will output a large `configure` file (a file so large I wont quote it here).


Reference: (https://robots.thoughtbot.com/the-magic-behind-configure-make-make-install](https://robots.thoughtbot.com/the-magic-behind-configure-make-make-install)

## Makefile.am -> Makefile.in
`makefile.am` is the GNU Make side of the autoconf/automake pair. It's a standard GNU makefile that processed (M4?) and converted in to a file `makefile.in` (hence the `.in` confusion above). The `.in` file is then used by the generated `configure` script to emit the _real_ `Makefile`.

There can be several `Makefile.am` files if desired, and they can operate on their individual directories.

```bash
# src/Makefile.am
bin_PROGRAMS = hello
hello_SOURCES = main.c

# Makefile.am
SUBDIRS = src
dist_doc_DATA = README.md
```

Reference: [https://www.gnu.org/software/automake/manual/automake.html#Hello-World](https://www.gnu.org/software/automake/manual/automake.html#Hello-World)

## aclocal
The final piece of the puzzle is the `aclocal` tool. Without it, autoconf can't actually start. The `aclocal` tool installs an `autoconf` m4 environment for the subsiquent tools.

## Bringing it all together
Per the reference above, here's what your usage as a project maintainer should look like.

```bash
aclocal # Set up an m4 environment
autoconf # Generate configure from configure.ac
automake --add-missing # Generate Makefile.in from Makefile.am
./configure # Generate Makefile from Makefile.in
make distcheck # Use Makefile to build and test a tarball to distribute
```

And with that done, your users will be able to do this:

```bash
./configure # Generate Makefile from Makefile.in
make # Use Makefile to build the program
make install # Use Makefile to install the program
```

See references above for more details.