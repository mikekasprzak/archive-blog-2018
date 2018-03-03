---
title: 'Notes: Vulkan begins now'
---

Vulkan was released 2 years ago right around the Game Developers Conference (usually in March). Unfortunately Windows 10 with DirectX 12 did beat them to the punch by a few months, so growth hasn't been as quick as it could have been, but by design Vulkan will eventually become the dominant API, though it's going to be Mobile and Consoles that push it there. That said, being able to dev on PC is super important.

It's taken a bit, but as of Ubuntu 17.04 you've been able to install Vulkan for Intel GPUs easily out of the box (though admittedly I wasn't able to get it working until 17.10). Come April, Ubuntu 18.04 will ship, and all the many derivative Linux distros can upgrade their Long Term Support version of Ubuntu finally, and Vulkan will finally be acessible to the "mass market" on Linux.

This is an important milestone. No, Linux wont suddenly become a haven for gamers, but something similar happened with Ubuntu 14.04: It got OpenGL 3.x and 4.x MESA drivers out-of-the-box. For me personally, this was when I was finally able to switch my core development machine to Linux. OpenGL 3.x meant you could write GLSL shader code on Linux, and actually run it on a machine with more headroom than the high end Phones of the time. It was a weird time when Mobile Phones could use modern GPU features, but your Laptop couldn't.

Just the other day MoltenVK launched, so suddenly OSX support for Vulkan is a thing. It's unfortunate that Apple isn't on the ball here, but it's nice that there's a solution. Supposedly the iOS version isn't ready yet, but "soon" they say. Not bad. All that's missing now is an implementation of Vulkan on top of DirectX 12, and we're laughing.

So okay! Alright! I'm out of excuses. I can add Vulkan to my repitoire now.

I've had a Vulkan "Red Book" since it came out, but it sat on my shelf. I'm as informed as I can be, without actually sitting down and trying to write code. So lets go!

# First Impressions
I ended up powering through the "Red Book" a couple nights ago, just to get a big picture. It really reminds of DirectX 11, though it goes way further. Classic OpenGL was about calling functions with many arguments, but Vulkan is very Windows API/DirectX'ish, where you need to populate a structure and pass it to a function.

Interestingly, the API itself now ships with 2 implementations: a C library (`vulkan.h`), and a C++ library (`vulkan.hpp`). There are other headers, but for the most part they are small dependencies (in seperate files for convenience).

Also different is that using the API requires you to define a symbol , something like `VK_USE_PLATFORM_XLIB_KHR`, to actually use the library. Yet another departure, where this was detected by the existence of `WIN32` or other such symbols in the past.

The current list (at the time of this writing).

* `VK_USE_PLATFORM_WIN32_KHR` - Windows
* `VK_USE_PLATFORM_ANDROID_KHR` - Android
* `VK_USE_PLATFORM_XLIB_KHR` - X11
* `VK_USE_PLATFORM_XCB_KHR` - Also X11, but a newer reimplementation
* `VK_USE_PLATFORM_WAYLAND_KHR` - Nextgen X11 replacement
* `VK_USE_PLATFORM_MIR_KHR` - Nextgen X11 replacement (that was aborted)
* `VK_USE_PLATFORM_MACOS_MVK` - OSX port (Molten VK)
* `VK_USE_PLATFORM_IOS_MVK` - iOS port (Molten VK)
* `VK_USE_PLATFORM_VI_NN` - Nintendo Switch

Notable is that last one. It's pretty cool to see Nintendo on that list.

* [https://www.khronos.org/registry/vulkan/](https://www.khronos.org/registry/vulkan/)
* [https://www.khronos.org/registry/vulkan/specs/1.0-extensions/html/vkspec.html#VK_NN_vi_surface](https://www.khronos.org/registry/vulkan/specs/1.0-extensions/html/vkspec.html#VK_NN_vi_surface)

Though when you do look at the spec, it's mainly an NVidia contribution. It does keep things simpler though (no need to use a proprietary header that's out-of-sync with mainline).

At this time, no Sony Vulkan headers or extensions are public.

blah blah

* C Library - [https://github.com/KhronosGroup/Vulkan-Docs/tree/1.0/src/vulkan](https://github.com/KhronosGroup/Vulkan-Docs/tree/1.0/src/vulkan)
* C++ Library - [https://github.com/KhronosGroup/Vulkan-Hpp](https://github.com/KhronosGroup/Vulkan-Hpp)

Strange how the C library is part of the "Vulkan Docs" repo, but hey.