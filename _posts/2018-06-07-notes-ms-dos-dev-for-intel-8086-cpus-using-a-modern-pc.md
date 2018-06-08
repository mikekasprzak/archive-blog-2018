---
title: 'Notes: MS-DOS Dev for Intel 8086 CPU''s using a Modern PC'
layout: post
---

Here's a weird one: Some notes on how to set up an environment and develop for DOS, today!

## What is the platform?
All Intel CPUs starting with the 8086 support something called [**Real Mode**](https://en.wikipedia.org/wiki/Real_mode). If you've dabbled with other retro computers and game consoles, **Real Mode** is the mode you're looking for. This is in contrast to [**Protected Mode**](https://en.wikipedia.org/wiki/Protected_mode) introduced on the 80286 and improved on the 80386 that provided a larger virtualized address space.

In **Real Mode**, the system has access to data across a 20-bit address space (even though the 8086 is a 16bit CPU). Effectively, the 20-bit address space offers 1 MB of addressable data (1,048,576 bytes, or `0xFFFFF`). This 1 MB limit is sometimes known to as the [A20 Line](https://en.wikipedia.org/wiki/A20_line). Later x86 CPUs didn't have this A20 limitation, but for compatibility, wrapping addresses at A20 could be enabled.

The notorious "640k should be enough" 'ism of computers comes from the original design of the IBM PC. The IBM PC was designed around the limitations of the address space of the 8086 CPU. The addresses in the first 640 KiB (i.e. `0x00000` to `0x9FFFF`) is allocade to RAM, and the rest is known as the UMA (upper memory area). On more advanced x86 processors, beyond the UMA is the HMA (high memory area, i.e. the first 64k above UMA) and the Extended Memory (up to 4 GB, completing the 32bit address space). [Reference](https://en.wikipedia.org/wiki/DOS_memory_management).

Within the UMA region, video memory tends to fall between `0xA0000` to `0xBFFFF` (128 KiB), `0xC0000` to `0xDFFFF` tends to be assigned to Device ROMs and RAMs (128 KiB), and `0xE0000` to `0xFFFFF` is where the the System (BIOS) ROM tends to be (128 KiB). That said, even though these regions are 128 KiB, a 16bit pointer can only address 64 KiB at a time, making them more practical to use (hence why VGA mode was `320x200` and not `320x240` as the former is only 64,000 bytes (small enough to fit within 64 KiB)).

## DOS Binaries (.com files)
This ([Reference](https://en.wikipedia.org/wiki/COM_file)) finally explains the whole `org 0x100` thing from way back. It turns out DOS (and CP/M) programs require that all programs start at the 256 byte boundary (meaning `.com` files can be a maximum of 256 bytes less than 65536 bytes in size). Other than that, `.com` files are raw and simple. Code and Data exist in the same blob.

The 256 byte region that prefixes the `.com` application is something called the PSP ([Program Segment Prefix](https://en.wikipedia.org/wiki/Program_Segment_Prefix)). One of the most notable features of the PSP is that this is how programs retrieved command-line arguments (up to 126 bytes worth), but there are some other features (including CP/M compatibility) baked in.


## Recent GCC
Can be found [here](https://sourcery.mentor.com/GNUToolchain/release3298).

## DosBox Usage
```bash
# Mount the specified folder as the C drive
mount c /home/mike/dos

 # Unmount the drive
mount -u c
```

* [Mount Reference](https://www.dosbox.com/wiki/MOUNT)