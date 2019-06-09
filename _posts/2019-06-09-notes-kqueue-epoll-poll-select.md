---
title: 'Notes: KQueue, EPoll, Poll, Select'
layout: post
---

Polling methods on Unix. In generall, all methods provide a way to monitor file descriptors. So in network programming, you'd either make a list of socket FD's, or use a single one if entirely transmitting over UDP.

# Select
The original.

```c
/* According to POSIX.1-2001, POSIX.1-2008 */
#include <sys/select.h>

/* According to earlier standards */
#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
			 
int select(int nfds, fd_set *readfds, fd_set *writefds, fd_set *exceptfds, struct timeval *timeout);

void FD_CLR(int fd, fd_set *set);
int  FD_ISSET(int fd, fd_set *set);
void FD_SET(int fd, fd_set *set);
void FD_ZERO(fd_set *set);
```

In general, Select is the most widely supported (even on Windows), but most limited. There's a hard limit on number of FD's, and has a curious usage: you must pass MaxFD+1 to its first arument, which is the highest numbered FD used in the function. 

```c
// Inputs: fd, timeout

struct timeval tv;
tv.tv_sec = timeout / 1000000;
tv.tv_usec = timeout % 1000000;

fd_set readSet;
FD_ZERO(&readSet);
FD_SET(fd, &readSet);

int count = select(fd + 1, &readSet, 0, 0, &tv);

if (FD_ISSET(fd, &readSet)) {
    // Read
}

if (count == 0) {
    // Empty
}
else if (count < 0) {
    if (errno == EINTR) {
        // Interrupted
    }
    else {
        // Error
    }
}
```

ReadSet, WriteSet, and ExceptFds are optional. So is time, but it will block forever if you pass a null pointer.

If monitoring the same file descriptor, it's wise to only pass a single one of the read/write sets in. Write sets will almost always return immediately, making it somewhat wasteful to wait for both when what you're really waiting for is something incoming.


#### Reference:

* [http://man7.org/linux/man-pages/man2/select.2.html](http://man7.org/linux/man-pages/man2/select.2.html)
* [https://www.freebsd.org/cgi/man.cgi?select](https://www.freebsd.org/cgi/man.cgi?select)

# Poll
The improved.

```c
#include <poll.h>

int poll(struct pollfd *fds, nfds_t nfds, int timeout);

struct pollfd {
    int   fd;         /* file descriptor */
    short events;     /* requested events */
    short revents;    /* returned events */
};
```




#### Reference

* [http://man7.org/linux/man-pages/man2/poll.2.html](http://man7.org/linux/man-pages/man2/poll.2.html)
* [https://www.freebsd.org/cgi/man.cgi?poll](https://www.freebsd.org/cgi/man.cgi?poll)

# EPoll
The penguin.

```c
#include <sys/epoll.h>

int epoll_create1(int flags);

int epoll_ctl(int epfd, int op, int fd, struct epoll_event *event);

int epoll_wait(int epfd, struct epoll_event *events, int maxevents, int timeout);

typedef union epoll_data {
    void*        ptr;
    int          fd;
    uint32_t     u32;
    uint64_t     u64;
} epoll_data_t;

struct epoll_event {
    uint32_t     events;      /* Epoll events */
    epoll_data_t data;        /* User data variable */
};
```

#### Reference

* [http://man7.org/linux/man-pages/man7/epoll.7.html](http://man7.org/linux/man-pages/man7/epoll.7.html)

# KQueue
The daemon.

```c
#include <sys/event.h>

int kqueue(void);

int kevent(int kq, const struct kevent *changelist, int nchanges, struct kevent *eventlist, int nevents, const struct timespec *timeout);

EV_SET(kev, ident, filter,	flags, fflags, data, udata);

struct kevent {
    uintptr_t ident;	     /*	identifier for this event */
    short     filter;	     /*	filter for event */
    u_short   flags;	     /*	action flags for kqueue	*/
    u_int     fflags;	     /*	filter flag value */
    int64_t   data;	         /*	filter data value */
    void*     udata;	     /*	opaque user data identifier */
    uint64_t  ext[4];	     /*	extensions */
};
```

#### Reference

* [https://www.freebsd.org/cgi/man.cgi?kqueue](https://www.freebsd.org/cgi/man.cgi?kqueue)