---
title: 'Notes: Vulkan begins now'
layout: post
date: '2018-03-05 11:47:30'
---

Vulkan was released 2 years ago right around the Game Developers Conference (usually in March). Unfortunately Windows 10 with DirectX 12 did beat them to the punch by a few months, so growth hasn't been as quick as it could have been. Vulkan will eventually become the dominant API, though it will likely be its availablity on Mobile and Consoles that ultimately pushes it there, not PC.

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

Frankly I'm not too happy with what I've been seeing, so here's a little analysis of the potential ways to initialize the data.

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
* You can read what is being asigned without looking at a reference

Cons:
* Verbose
* Need to set `VK_STRUCTURE` types and `pNext` manually
* Data isn't Zeroed

A workaround for the zeroing problem would be to include a zeroing macro. Then before your blocks you call, which lets you omit anything that isn't important and can be set to zero.

```c
#define Zero( var ) \
    memset(&var, 0, sizeof(var));
		
VkApplicationInfo ApplicationInfo;
VkInstanceCreateInfo InstanceCreateInfo;

Zero(ApplicationInfo);
ApplicationInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
// omitted pNext
ApplicationInfo.pApplicationName = "My Application";
ApplicationInfo.applicationVersion = VK_MAKE_VERSION(0, 1, 0);
ApplicationInfo.pEngineName = "My Engine";
ApplicationInfo.engineVersion = VK_MAKE_VERSION(0, 1, 0);
ApplicationInfo.apiVersion = VK_MAKE_VERSION(1, 0, 0);

Zero(InstanceCreateInfo);
// ...
```

Unfortunately, if you forget to use the Macro, then you still have the same problem.

## Initializer-list C style
This is a safer method. Initializer lists lets you fill in values, and any tail values you omit are automatically set to zero.

First the fully verbose version.

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

But the `VkInstanceCreateInfo` structure contains many tail zeros, so it could be rewritten like so: 

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
	&ApplicationInfo
};

VkInstance Instance;

if ( vkCreateInstance(&InstanceCreateInfo, nullptr, &Instance) == VK_SUCCESS ) {
	// ..
}
```

Pros:
* Omitted values are zeroed

Cons:
* Need to set `VK_STRUCTURE` types and `pNext` manually
* Zero might not be the correct default
* It's unclear what you're setting without looking at a reference

**NOTE**: You can use `0` in the place of `nullptr`.

## C++ Header style
Though the initializer list method is pretty good, there may be cases where default should **not** actually be zero. You can check out this [NVidia presentation](https://www.khronos.org/assets/uploads/developers/library/2016-vulkan-devu-seoul/4-Vulkan-HPP.pdf) for a more in depth list of Pros/Cons.

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
* Omitted values are initialized to sensible defaults as chosen by the Vulkan board
* No need to set `VK_STUCTURE` types and `pNext` manually

Cons: 
* It's unclear what you're setting without looking at a reference
* `vk::Result::eSuccess` is more verbose than `VK_SUCCESS`

## C99 and C++20 Designated Initializer style
C99 and the upcoming C++20 (yes, it took 20 years to get it) include a feature for initializer lists that is rather useful here. You can read more about it [here](https://www.geeksforgeeks.org/designated-initializers-c/) or [here](https://gcc.gnu.org/onlinedocs/gcc/Designated-Inits.html).

```c
#include <vulkan/vulkan.h>

// ...

VkApplicationInfo ApplicationInfo = {
	.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,

	.pApplicationName = "My Application",
	.applicationVersion = VK_MAKE_VERSION(0, 1, 0),
	.pEngineName = "My Engine",
	.engineVersion = VK_MAKE_VERSION(0, 1, 0),
	.apiVersion = VK_MAKE_VERSION(1, 0, 0)
};

VkInstanceCreateInfo InstanceCreateInfo = {
	.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,

	.pApplicationInfo = &ApplicationInfo
};

VkInstance Instance;

if ( vkCreateInstance(&InstanceCreateInfo, nullptr, &Instance) == VK_SUCCESS ) {
	// ..
}
```

If you're feeling adventurous, you could use it now by wrapping the code in a C block. You just need to be sure you don't need any C++ features within the blocks.

```c
// ...

extern "C" {
	VkApplicationInfo ApplicationInfo = {
		.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO,

		.pApplicationName = "My Application",
		.applicationVersion = VK_MAKE_VERSION(0, 1, 0),
		.pEngineName = "My Engine",
		.engineVersion = VK_MAKE_VERSION(0, 1, 0),
		.apiVersion = VK_MAKE_VERSION(1, 0, 0)
	};

	VkInstanceCreateInfo InstanceCreateInfo = {
		.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO,

		.pApplicationInfo = &ApplicationInfo
	};
}; // extern "C"

// ..
```

Pros:
* Omitted values are zeroed
* You can omit values inbetween (not just tail values)
* No need to set `pNext` manually
* Details you've set are clearly labeled

Cons:
* You need to set `VK_STUCTURE`
* Zero might not be the correct default
* Not available natively in C++ (yet)

## The ideal way (that doesn't exist)
Just for fun, here's a mashup that doesn't actually exist, but would be nice. For this to work, it would require that C++ acquired the ability to use the Designated Initializer feature in function arguments too.

Also if we wanted to make the code a bit less verbose, we could define the following.

```c++
namespace vk {
	const auto eSuccess = Result::eSuccess;
};
```

Code listing is as follows:

```c++
#include <vulkan/vulkan.hpp>

// ...

vk::ApplicationInfo ApplicationInfo(
	.pApplicationName = "My Application",
	.applicationVersion = VK_MAKE_VERSION(0, 1, 0),
	.pEngineName = "My Engine",
	.engineVersion = VK_MAKE_VERSION(0, 1, 0),
	.apiVersion = VK_MAKE_VERSION(1, 0, 0)
);

vk::InstanceCreateInfo InstanceCreateInfo(
	.pApplicationInfo = &ApplicationInfo
);

vk::Instance Instance;

if ( vk::createInstance(&InstanceCreateInfo, nullptr, &Instance) == vk::eSuccess ) {
    // ..
}
```

Pros:
* Omitted values are initialized to sensible defaults as chosen by the Vulkan board
* No need to set `VK_STUCTURE` types and `pNext` manually
* You can read what is being asigned without looking at a reference
* `vk::eSuccess` instead of the longer `vk::Result::eSuccess` (`vk::Success` is taken apparently)

Cons: 
* The function argument feature **doesn't exist**!!
* `vk::eSuccess` is nonstandard, and though it wont likely cause problems, `vk::Result::eSuccess` does tell us more

This would be ideal since the compiler could tell us of mistakes we make in argument names. 

## The Compromise
Document the code, bite the bullet on `vk::Result::eSuccess`. 

The C++ library helps us avoid initialization issues, and lets us omit `sType` and `pNext`. The result is standards complaint, and not weird.

```c++
#include <vulkan/vulkan.hpp>

// ...

vk::ApplicationInfo ApplicationInfo(
	/*pApplicationName*/ "My Application",
	/*applicationVersion*/ VK_MAKE_VERSION(0, 1, 0),
	/*pEngineName*/ "My Engine", 
	/*engineVersion*/ VK_MAKE_VERSION(0, 1, 0),
	/*apiVersion*/ VK_MAKE_VERSION(1, 0, 0)
);

vk::InstanceCreateInfo InstanceCreateInfo(
    /*flags*/ vk::InstanceCreateFlags(),
    /*pApplicationInfo*/ &ApplicationInfo
);

vk::Instance Instance;

if ( vk::createInstance(&InstanceCreateInfo, nullptr, &Instance) == vk::Result::eSuccess ) {
    // ..
}
```

In practice you could put the `/*pApplicationName*/` before or after, but before does mean you can safely multi-line an assignment without it getting weird.

Pros:
* Omitted values are initialized to sensible defaults as chosen by the Vulkan board
* No need to set `VK_STUCTURE` types and `pNext` manually
* You can read what is being asigned without looking at a reference

Cons:
* `vk::Result::eSuccess` is more verbose than `VK_SUCCESS`
* Compiler will not complain about mistakes in the labels

Not perfect, but the lesser of the evils.
# Wrapup
Going in to this writeup, I completely expected to side with one of the C methods. Alas, I think the C++ library is the better choice.