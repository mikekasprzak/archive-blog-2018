---
title: 'Notes: Sockets with Select, Poll, EPoll, and ENET'
layout: post
---

# File Descriptors

### References
* http://man7.org/linux/man-pages/man2/socket.2.html
* http://man7.org/linux/man-pages/man2/listen.2.html

# Select
* On Linux, `select` supports a maximum of 1024 connections
* On Windows, some historic notes suggest 64 (per thread) is the maximum, but I think this is obsolete (`winsock` vs `winsock2`)

### References
* How to use `select properly: https://stackoverflow.com/questions/32711521/how-to-use-select-on-sockets-properly

# Poll

### References
* http://man7.org/linux/man-pages/man2/poll.2.html

# EPoll

### References
* 500,000 connection limit out-of-the-box: https://stackoverflow.com/questions/28735700/what-is-the-maximum-number-of-sockets-that-epoll-can-handle
* Blocking and Non-Blocking: https://eklitzke.org/blocking-io-nonblocking-io-and-epoll
* EPoll Explained: https://medium.com/@copyconstruct/the-method-to-epolls-madness-d9d2d6378642
* epoll_create: https://linux.die.net/man/2/epoll_create
* epoll_wait: http://man7.org/linux/man-pages/man2/epoll_wait.2.html
* epoll_ctl: http://man7.org/linux/man-pages/man2/epoll_ctl.2.html

# KQueue
BSD/Apple specific.

### References
* Apple documentation: https://developer.apple.com/library/content/documentation/Darwin/Conceptual/FSEvents_ProgGuide/KernelQueues/KernelQueues.html

# Compared

### References
* Comparison: https://www.ulduzsoft.com/2014/01/select-poll-epoll-practical-difference-for-system-architects/
* The C10k Problem: http://www.kegel.com/c10k.html

---
# ENET 
* Homepage: [http://enet.bespin.org/](http://enet.bespin.org/)
* Docs: [http://enet.bespin.org/usergroup0.html](http://enet.bespin.org/usergroup0.html)

## Platform Specific Functions
These functions are found to be defined in `unix.c` and `win32.c`. When porting enet to a new platform (or API), these must exist.

### Init
Initialization functions. Out-of-the-box neither `socket`, `select` or `poll` need this, but an `epoll` implementation will.

* `int`**`enet_initialize`**`(void)`
* `void`**`enet_deinitialize`**`(void)`

### Misc
Miscaleneous functions. Primarily just time stuff.

* `enet_uint32`**`enet_host_random_seed`**`(void)`
	* `time(NULL);`
* `enet_uint32`**`enet_time_get`**`(void)`
	* `gettimeofday`
* `void`**`enet_time_set`**`(enet_uint32 newTimeBase)`
	* `gettimeofday`

### Address
* `int`**`enet_address_set_host_ip`**`(ENetAddress * address, const char * name)`
	* `inet_pton` or `inet_aton`
	* **`inet_pton`** is the modern function. It doesn't autodetect, but it can be told to encode IPv6 addresses.
* `int`**`enet_address_set_host`**`(ENetAddress * address, const char * name)`
	* `getaddrinfo`, `freeaddrinfo`, `gethostbyname_r` or `gethostbyname`
* `int`**`enet_address_get_host_ip`**`(const ENetAddress * address, char * name, size_t nameLength)`
	* `inet_ntop` or `inet_ntoa`
	* **`inet_ntop`** is the modern function. It doesn't autodetect, but it can be told to decode IPv6 addresses.
* `int`**`enet_address_get_host`**`(const ENetAddress * address, char * name, size_t nameLength)`
	* `getnameinfo`, `gethostbyaddr_r` or `gethostbyaddr`

### Socket
* `int`**`enet_socket_bind`**`(ENetSocket socket, const ENetAddress * address)`
	* `bind`
* `int`**`enet_socket_get_address`**`(ENetSocket socket, ENetAddress * address)`
	* `getsockname`
* `int`**`enet_socket_listen`**`(ENetSocket socket, int backlog)`
	* `listen`
* `ENetSocket`**`enet_socket_create`**`(ENetSocketType type)`
	* `socket`
* `int`**`enet_socket_set_option`**`(ENetSocket socket, ENetSocketOption option, int value)`
	* `fcntl` or `ioctl`, `setsockopt` (many)
* `int`**`enet_socket_get_option`**`(ENetSocket socket, ENetSocketOption option, int * value)`
	* `getsockopt`
* `int`**`enet_socket_connect`**`(ENetSocket socket, const ENetAddress * address)`
	* `connect`
* `ENetSocket`**`enet_socket_accept`**`(ENetSocket socket, ENetAddress * address)`
	* `accept`
* `int`**`enet_socket_shutdown`**`(ENetSocket socket, ENetSocketShutdown how)`
	* `shutdown`
* `void`**`enet_socket_destroy`**`(ENetSocket socket)`
	* `close`
* `int`**`enet_socket_send`**`(ENetSocket socket, const ENetAddress * address, const ENetBuffer * buffers, size_t bufferCount)`
	* `sendmsg`
* `int`**`enet_socket_receive`**`(ENetSocket socket, ENetAddress * address, ENetBuffer * buffers, size_t bufferCount)`
	* `recvmsg`
* `int`**`enet_socketset_select`**`(ENetSocket maxSocket, ENetSocketSet * readSet, ENetSocketSet * writeSet, enet_uint32 timeout)`
	* `select`
* `int`**`enet_socket_wait`**`(ENetSocket socket, enet_uint32 * condition, enet_uint32 timeout)`
	* `poll` or `select`