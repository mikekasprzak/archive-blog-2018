---
id: 6659
title: Linux Device Input Notes
date: 2014-01-08T17:08:21+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6659
permalink: /2014/01/08/linux-device-input-notes/
categories:
  - Linux
  - Technobabble
---
I can use the following to list all attached USB devices.

<pre class="lang:default decode:true " >lsusb</pre>

The output will be something like the following.

<pre class="lang:default decode:true " >Bus 002 Device 006: ID 0e6f:011f Logic3 
Bus 002 Device 008: ID 17a0:0302 Samson Technologies Corp. GoMic compact condenser microphone
Bus 002 Device 007: ID 0424:4060 Standard Microsystems Corp. Ultra Fast Media Reader
Bus 002 Device 005: ID 0424:2640 Standard Microsystems Corp. USB 2.0 Hub
Bus 002 Device 004: ID 0424:2514 Standard Microsystems Corp. USB 2.0 Hub
Bus 002 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 004: ID 04f2:b217 Chicony Electronics Co., Ltd Lenovo Integrated Camera (0.3MP)
Bus 001 Device 003: ID 0a5c:217f Broadcom Corp. BCM2045B (BDC-2.1)
Bus 001 Device 009: ID 045e:02d1 Microsoft Corp. 
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
</pre>

Take note of Device 009, i.e. &#8220;Microsoft Corp.&#8221;. Thats an **Xbox One** controller plugged in to a USB port.

(Also FYI, the device known as &#8220;Logic3&#8221; is a RockCandy brand Xbox 360 controller)

I can retrieve some data about the controller as follows:

<pre>xxd /dev/bus/usb/001/009</pre>

Bus 001, Device 009.

It is not controller data though. Pressing buttons does not update any of the values.

<pre class="lang:default decode:true " >0000000: 1201 0002 ff47 d040 5e04 d102 0101 0102  .....G.@^.......
0000010: 0301 0902 6000 0301 00a0 fa09 0400 0002  ....`...........
0000020: ff47 d000 0705 0103 4000 0407 0581 0340  .G......@......@
0000030: 0004 0904 0100 00ff 47d0 0009 0401 0102  ........G.......
0000040: ff47 d000 0705 0201 e400 0107 0582 01e4  .G..............
0000050: 0001 0904 0200 00ff 47d0 0009 0402 0102  ........G.......
0000060: ff47 d000 0705 0302 4000 0007 0583 0240  .G......@......@
0000070: 0000                                     ..</pre>

Using &#8216;**lsusb -v**&#8216; provides an interpretation of all attached devices (i.e. if you follow along, you&#8217;ll note the data above is the same as the data below).

<pre class="lang:default decode:true " >Bus 001 Device 009: ID 045e:02d1 Microsoft Corp. 
Couldn't open device, some information will be missing
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          255 Vendor Specific Class
  bDeviceSubClass        71 
  bDeviceProtocol       208 
  bMaxPacketSize0        64
  idVendor           0x045e Microsoft Corp.
  idProduct          0x02d1 
  bcdDevice            1.01
  iManufacturer           1 
  iProduct                2 
  iSerial                 3 
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength           96
    bNumInterfaces          3
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0xa0
      (Bus Powered)
      Remote Wakeup
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     71 
      bInterfaceProtocol    208 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               4
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            3
          Transfer Type            Interrupt
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               4
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     71 
      bInterfaceProtocol    208 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     71 
      bInterfaceProtocol    208 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x02  EP 2 OUT
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00e4  1x 228 bytes
        bInterval               1
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x82  EP 2 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x00e4  1x 228 bytes
        bInterval               1
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     71 
      bInterfaceProtocol    208 
      iInterface              0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        2
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass       255 Vendor Specific Class
      bInterfaceSubClass     71 
      bInterfaceProtocol    208 
      iInterface              0 
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x03  EP 3 OUT
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
      Endpoint Descriptor:
        bLength                 7
        bDescriptorType         5
        bEndpointAddress     0x83  EP 3 IN
        bmAttributes            2
          Transfer Type            Bulk
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0040  1x 64 bytes
        bInterval               0
</pre>

An article on [creating Linux Drivers (kernel modules)](http://www.linuxjournal.com/article/7353).

**lsmod** can be used to list all currently installed Kernel Modules.

The other option is communicating using **usbfs**, but usbfs is legacy and no longer enabled on Ubuntu. Instead, Ubuntu uses **udev**. **udev** is what&#8217;s going on in the /dev/ folder. A dynamically generated file system of attached hardware.

If I do the following:

<pre class="lang:default decode:true " >xxd /dev/input/by-id/usb-Performance_Designed_Products_Rock_Candy_Gamepad_for_Xbox_360_05F78CA0-joystick

# which is a symlink to #
/dev/input/js1</pre>

I&#8217;ll get a realtime stream of raw input data.

That&#8217;s all. Just thought this was interesting.