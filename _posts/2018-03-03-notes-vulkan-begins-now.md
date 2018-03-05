---
title: 'Notes: Vulkan begins now'
layout: post
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

* C Library - [https://github.com/KhronosGroup/Vulkan-Docs/tree/1.0/src/vulkan](https://github.com/KhronosGroup/Vulkan-Docs/tree/1.0/src/vulkan)
* C++ Library - [https://github.com/KhronosGroup/Vulkan-Hpp](https://github.com/KhronosGroup/Vulkan-Hpp)

Strange how the C library is part of the "Vulkan Docs" repo, but hey.

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

# Super Structure
Most Vulkan structures are defined as follows:

```c
typedef struct VkEventCreateInfo {
    VkStructureType       sType;
    const void*           pNext;
    VkEventCreateFlags    flags;
} VkEventCreateInfo;
```

* A two part header consisting of a constant set to a fixed value (`VK_STRUCTURE_TYPE_EVENT_CREATE_INFO`, i.e. `10` in the above case), and a pointer set to 0 (`nullptr`) or the next item in a linked list.
* One or more additional fields

I quite like this actually. To OpenGL's credit, I quite liked how clear it was in its naming. You could infer a lot from a name.

This isn't entirely unique though, comparing it to DirectX 11:

```c
typedef struct D3D11_MAPPED_SUBRESOURCE {
  void *pData;
  UINT RowPitch;
  UINT DepthPitch;
} D3D11_MAPPED_SUBRESOURCE;
```

Coding style is very similar, including `p`'s for pointers, just Microsoft chose a more _upper-case_ style. That continues in to DirectX 12.

```c
typedef struct D3D12_COMMAND_SIGNATURE_DESC {
  UINT                               ByteStride;
  UINT                               NumArgumentDescs;
  const D3D12_INDIRECT_ARGUMENT_DESC *pArgumentDescs;
  UINT                               NodeMask;
} D3D12_COMMAND_SIGNATURE_DESC;
```

Suffice to say, OpenGL immediate mode is a thing of the past. Modern APIs are all about the phat structures.

# Populating info structures
With that out of the way, next comes the issue of populating the structures.

## Microsoft/Red Book C style
This style is commonly seen in DirectX reference code. It's also the style used in the Vulkan "Red Book".

```c
#include <vulkan/vulkan.h>

// ...

VkApplicationInfo ApplicationInfo;
VkInstanceCreateInfo InstanceCreateInfo;

ApplicationInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
ApplicationInfo.pNext = nullptr;
ApplicationInfo.pApplicationName = "My Application";
ApplicationInfo.applicationVersion = VK_MAKE_VERSION(0, 1, 0);
ApplicationInfo.pEngineName = "My Engine";
ApplicationInfo.engineVersion = VK_MAKE_VERSION(0, 1, 0);
ApplicationInfo.apiVersion = VK_MAKE_VERSION(1, 0, 0);

InstanceCreateInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
InstanceCreateInfo.pNext = nullptr;
InstanceCreateInfo.flags = 0;
InstanceCreateInfo.pApplicationInfo = &ApplicationInfo;
InstanceCreateInfo.enabledLayerCount = 0;
InstanceCreateInfo.ppEnabledLayerNames = nullptr;
InstanceCreateInfo.enabledExtensionCount = 0;
InstanceCreateInfo.ppEnabledExtensionNames = nullptr;

VkInstance Instance;

if ( vkCreateInstance(&InstanceCreateInfo, nullptr, &Instance) == VK_SUCCESS ) {
	// ..
}
```

Pros:
* You ca

Cons:
* Verbose
* Data isn't Zeroed

A workaround for the zeroing problem would be to include a zeroing macro.

```c
#define Zero( var ) \
    memset(&var, 0, sizeof(var));
		
VkApplicationInfo ApplicationInfo;
VkInstanceCreateInfo InstanceCreateInfo;

Zero(ApplicationInfo);
// ...
Zero(InstanceCreateInfo);
// ...
```

Unfortunately, if you forget to use the Macro, then you still have the same problem.

## Verbose initializer-list C style
```c
#include <vulkan/vulkan.h>

// ...

VkApplicationInfo ApplicationInfo = {
	VK_STRUCTURE_TYPE_APPLICATION_INFO,
	nullptr,

	"My Application", VK_MAKE_VERSION(0, 1, 0),
	"My Engine", VK_MAKE_VERSION(0, 1, 0),
	VK_MAKE_VERSION(1, 0, 0)
};

VkInstanceCreateInfo InstanceCreateInfo = {
	VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,
	nullptr,

	0,
	&ApplicationInfo,
	0,
	nullptr,
	0,
	nullptr
};

VkInstance Instance;

if ( vkCreateInstance(&InstanceCreateInfo, nullptr, &Instance) == VK_SUCCESS ) {
	// ..
}
```

Pros:
* None

Cons:
* Verbose
* Need to set `VK_STRUCTURE` types and Next manually
* It's unclear what you're setting without looking at a reference

**NOTE**: You can use `0` in the place of `nullptr`.

## C++ Header style

```c++
#include <vulkan/vulkan.hpp>

// ...

vk::ApplicationInfo ApplicationInfo(
    "My Application", VK_MAKE_VERSION(0, 1, 0),
    "My Engine", VK_MAKE_VERSION(0, 1, 0),
    VK_MAKE_VERSION(1, 0, 0)
);

vk::InstanceCreateInfo InstanceCreateInfo(
    vk::InstanceCreateFlags(),
    &ApplicationInfo
);

vk::Instance Instance;

if ( vk::createInstance(&InstanceCreateInfo, nullptr, &Instance) == vk::Result::eSuccess ) {
    // ..
}
```

Pros:
* Briefer code
* Omitted values are initialized to sensible defaults as chosen by the Vulkan board

Cons: 
* It's unclear what you're setting without looking at a reference
* Checking for `vk::Result::eSuccess` is rather common, and it's more verbose than `VK_SUCCESS`


### Comparing the styles
Comparing the two, at least in my opinion the C++ version is clean and clearer. Things you don't care about are omitted, and 

A downside though: you can't infer what is being set from the code above. You can infer that you're setting an application and engine name and version, but the last part (API version) isn't clear, not to mention the 5 omitted arguments of the `VkInstanceCreateInfo` structure. You have to refer to the docs (or intellisense) to figure out exactly what's being shown above.

## The Zero Macro
```c
#define Zero( var ) \
    memset(&var, 0, sizeof(var));
		
VkEventCreateInfo EventInfo;
Zero(EventInfo);
```