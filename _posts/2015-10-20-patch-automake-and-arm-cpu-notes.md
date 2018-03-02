---
id: 7649
title: Patch, Automake, and ARM CPU and Microserver Notes
date: 2015-10-20T04:23:41+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=7649
permalink: /2015/10/20/patch-automake-and-arm-cpu-notes/
categories:
  - Uncategorized
---
A random collection of notes from Today&#8217;s science experiments.

<!--more-->

## Diff and Patch

To make a patch (using diff), get 2 folders: old and new.

<pre class="lang:default decode:true " ># -r=recursive -u=unified output -p=show c function -N=create new files
diff -rupN old/ new/ &gt; my.patch</pre>

To apply a patch:

<pre class="lang:default decode:true " ># If you are absolutely sure old is the same as what's said in the patch file
patch -p0 &lt; my.patch

# If the destination folder name has changed, ignore base folder (best practice)
cd old
patch -p1 &lt; my.patch

# The -pX command can be used for any depth you like

# To remove (un-apply) a patch
patch -p1 -R &lt; my.patch </pre>

To diff/patch a single file:

<pre class="lang:default decode:true " ># Make Patch, unified format
diff -u old.c new.c &gt; changes.patch

# Apply Patch
patch old.c &lt; changes.patch

# Under certain circumstances you can do this
patch &lt; changes.patch</pre>

Source: <http://jungels.net/articles/diff-patch-ten-minutes.html>

## Autocmake/Autoconf

**configure.am** is a key file in autoconf toolchains. Once you change it, you need to rebuild your tools.

AFAIK, you should be able to use **autoreconf** to rebuild configuration info, but this wasn&#8217;t enough for the Linuxes I was using.

Because the **compile** symlink was wrong, I had to invoke &#8211;add-missing. Apparently &#8211;add-missing was removed in a more recent version of autoconf/autoreconf. Instead, do this:

<pre class="lang:default decode:true " >aclocal
automake --add-missing
autoconf</pre>

I&#8217;ll be honest, I don&#8217;t entirely understand the pieces, but this is what I needed and it worked.

Source: **https://www.sourceware.org/autobook/autobook/autobook_43.html**

## TAR GZIP BZIP

<pre class="lang:default decode:true " ># -z for zip (--gzip), -j for bzip2 (--bzip2), -J for xz (--xz), -Z for "compress" (--compress)
# --lzma, --lzip, --lzop
# -x to extract, -c to compress
# -f specify a filename (instead of pipe), - as to filename for standard output

# Uncompress .tar.gz or .tgz files
tar -zxf php-7.0.0RC4.tar.gz
# Compress a .tar.gz or .tgz file
tar -czf archive.tar.gz mydir/

# Uncompress .tar.bz2 or .bz2 files
tar -jxf php-7.0.0RC4.tar.bz2
# Compress a .tar.gz or .tgz file
tar -cjf archive.tar.bz2 mydir/

# Uncompress an archive (automatically determine compressor base on name)
tar -axf php-7.0.0RC4.tar.bz2

# -caf may work *shrug*</pre>

Source: <http://www.computerhope.com/unix/utar.htm>

## ARM CPU Details on Linux

Information about the CPU can be acquired by doing a &#8220;`cat /proc/cpuinfo`&#8221;

What I&#8217;m interested in are the things on the **Features** line.

Meaning Reference: <http://unix.stackexchange.com/a/43563>

<pre class="lang:default decode:true " ># From Stack Exchange
swp:      SWP instruction (atomic read-modify-write)
half:     Half-precision extension
thumb:    Thumb (16-bit instruction set)
26bit:    "26 Bit" Model (Processor status register folded into program counter)
fastmult: 32×32→64-bit multiplication
fpa:      Floating point accelerator
vfp:      VFP (early SIMD vector floating point instructions)
edsp:     DSP extensions (the 'e' variant of the ARM9 CPUs, and all others above)
java:     Jazelle (Java bytecode accelerator)
iwmmxt:   SIMD instructions similar to Intel MMX
crunch:   MaverickCrunch coprocessor (if kernel support enabled)
thumbee:  ThumbEE
neon:     NEON (second-generation SIMD)
vfpv3:    VFP version 3
vfpv3d16: VFP version 3 limited to 16 registers
tls:      TLS register
vfpv4:    VFP version 4
idiva:    SDIV and UDIV hardware division in ARM mode
idivt:    SDIV and UDIV hardware division in Thumb mode

# More
vfpd32:   32 Double Precision Floating Point Registers (instead of 16)
</pre>

You can determine if a Linux has been compiled to use Hard Float (i.e. entirely hardware floats, instead of software floats, or software float calling conventions) like so:

Source: <http://raspberrypi.stackexchange.com/a/4681> 

<pre class="lang:default decode:true " ># Hard Float if this exists: /lib/arm-linux-gnueabihf

if [ -d "/lib/arm-linux-gnueabihf" ]; then
    # Do something for Hard Float
fi


# Soft Float if this exists instead: /lib/arm-linux-gnueabi

if [ -d "/lib/arm-linux-gnueabi" ]; then
    # Do something for Soft Float
fi

# Notice the 'hf' at the end of the string. That means hard float</pre>

OS and Linux Architecture can be checked using `uname`:

<pre class="lang:default decode:true " ># Linux, etc
OSTYPE=`uname -m`

# i686, x86_64, armv6l, armv7l
OSNAME=`uname -s`</pre>

## ARM CPUINFO Feature strings

Info: <https://wiki.debian.org/ArmHardFloatPort/VfpComparison>
  
Args: <https://gcc.gnu.org/onlinedocs/gcc/ARM-Options.html>

<pre class="lang:default decode:true " ># Number in brackets is number of CPU cores
Scaleway C1 (4)     : swp half thumb fastmult vfp edsp vfpv3 tls 
Parallella (2)      : swp half thumb fastmult vfp edsp neon vfpv3 tls vfpd32 
Beaglebone Black (1): swp half thumb fastmult vfp edsp thumbee neon vfpv3 tls
# The original Raspberry Pi features an ARMv6 CPU, not an ARMv7
Raspberry Pi (1)    : swp half thumb fastmult vfp edsp java tls
Raspberry Pi 2 (4)  : half thumb fastmult vfp edsp neon vfpv3 tls vfpv4 idiva idivt vfpd32 lpae evtstrm
</pre>

I&#8217;m not entirely sure which CPU Scaleway uses, but there are options:
  
Armada XP Cloud Processor (Quad Core): <http://www.marvell.com/embedded-processors/armada-xp/>

Parallella:

<pre class="lang:default decode:true " >processor	: 0
model name	: ARMv7 Processor rev 0 (v7l)
Features	: swp half thumb fastmult vfp edsp neon vfpv3 tls vfpd32 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x3
CPU part	: 0xc09
CPU revision	: 0

processor	: 1
model name	: ARMv7 Processor rev 0 (v7l)
Features	: swp half thumb fastmult vfp edsp neon vfpv3 tls vfpd32 
CPU implementer	: 0x41
CPU architecture: 7
CPU variant	: 0x3
CPU part	: 0xc09
CPU revision	: 0

Hardware	: Xilinx Zynq Platform
Revision	: 0000
Serial		: 0000000000000000</pre>

Scaleway C1:

<pre class="lang:default decode:true " >Processor	: Marvell PJ4Bv7 Processor rev 2 (v7l)
processor	: 0
BogoMIPS	: 1332.01

processor	: 1
BogoMIPS	: 1332.01

processor	: 2
BogoMIPS	: 1332.01

processor	: 3
BogoMIPS	: 1332.01

Features	: swp half thumb fastmult vfp edsp vfpv3 tls 
CPU implementer	: 0x56
CPU architecture: 7
CPU variant	: 0x2
CPU part	: 0x584
CPU revision	: 2

Hardware	: Online Labs C1
Revision	: 0000
Serial		: 0000000000000000
</pre>

## Installing an OS Image on an SD Card

Download an image, and plug in an SD/MicroSD card.

<pre class="lang:default decode:true " ># List mounted volumes
df -h

# You'll get a readout like this:
Filesystem      Size  Used Avail Use% Mounted on
udev            7.7G     0  7.7G   0% /dev
tmpfs           1.6G   42M  1.5G   3% /run
/dev/sda5       218G   87G  120G  42% /
tmpfs           7.7G   77M  7.7G   1% /dev/shm
tmpfs           5.0M  4.0K  5.0M   1% /run/lock
tmpfs           7.7G     0  7.7G   0% /sys/fs/cgroup
tmpfs           1.6G   80K  1.6G   1% /run/user/1000
/dev/sda7        40G   89M   39G   1% /media/mike/Work
/dev/mmcblk0p2  3.5G  1.4G  2.0G  41% /media/mike/rootfs
/dev/mmcblk0p1  100M  5.3M   95M   6% /media/mike/boot

# Note the last 2 items, /dev/mmcblk0 is the common name for both (no p1 or p2)

# Remember the name, and unmount the partition(s)
umount /dev/mmcblk0p1
umount /dev/mmcblk0p2</pre>

Now, write the image as follows.

<pre class="lang:default decode:true " ># bs: block size
# if: input file
# of: output file
sudo dd bs=4M if=myimage.img of=/dev/mmcblk0</pre>

Noting that **/dev/mmcblk0** is the name of the SD Card reader on my machine. We write to the device directly, not a partition (p1,p2), which in turn will create partitions.

## Building MariaDB from Source

Get prerequisites.

<pre class="lang:default decode:true " ># A neat way to do it, ask apt-get for the build dependencies for mysql
sudo apt-get build-dep mysql-server</pre>

Get latest source release. Go here for a URL, then wget that.

<https://github.com/MariaDB/server/releases>

MariaDB relies on **cmake**.

<pre class="lang:default decode:true " ># Note: I haven't tested -G yet, but my initial build on ARM was slow, pretty sure unthreaded
cmake . -DBUILD_CONFIG=mysql_release -G"Unix Makefiles"

make -j 4

# Optional step, to confirm the built mysql/mariadb is correct
make test

# To build a TAR.GZ package
sudo make package

# To build a debian/ubuntu DEB package
sudo apt-get install devscripts
sudo debian/autobake-deb.sh
# Take note of the missing dependencies, and apt-get install those
</pre>

## Installing MariaDB from sources

<pre># Install
sudo make install

sudo addgroup mysql
sudo useradd -r -g mysql mysql

cd /usr/local/mysql/
sudo chown -R mysql:mysql .
sudo scripts/mysql_install_db --user=mysql
sudo chown -R root:root .
sudo chown -R mysql:mysql data
sudo /usr/local/mysql/bin/mysqld_safe --user=mysql &
</pre>

Reference: [https://mariadb.com/kb/en/mariadb/Build\_Environment\_Setup\_for\_Linux/](https://mariadb.com/kb/en/mariadb/Build_Environment_Setup_for_Linux/)
  
Reference: <https://mariadb.com/kb/en/mariadb/generic-build-instructions/>
  
Reference: <http://www.kitware.com/blog/home/post/434>
  
Reference: <https://dev.mysql.com/doc/refman/5.1/en/binary-installation.html>