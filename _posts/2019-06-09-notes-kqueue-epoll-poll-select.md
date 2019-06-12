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
tv.tv_sec = timeout / 1000;
tv.tv_usec = timeout % 1000;

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
Interestingly, this is actually the easiest to use, since there's nothing weird about the syntax.

```c
    // Inputs: fd, timeout

    struct pollfd ps;
    ps.fd = fd;
    ps.events = POLLIN;
    ps.revents = 0;

    int count = poll(&ps, 1, timeout);

    if (ps.revents & POLLIN) {
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
`poll` takes an array of `pollfd` structures, but in our case 1 is enough. `ps.revents` is the return value from the poll call. Clearing it might not be necessary, but it doesn't hurt.

The one downside might be the precision of the timeout is only `ms`, but chances are you probably want that (or zero).


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

Both `epoll` and `kqueue` require a new FD that you to register before you use it.

```c
    // Inputs: fd, timeout

	// ** Somewhere init **
    int epFD = epoll_create1(0);
    if (epFD == -1) {
        return nullptr;
    }
    
    struct epoll_event epEvent;
    memset(&epEvent, 0, sizeof(struct epoll_event));
    epEvent.data.fd = fd;
    epEvent.events = EPOLLIN;
    if (epoll_ctl(epFD, EPOLL_CTL_ADD, fd, &epEvent) == -1) {
        return nullptr;
    }
    
    
    // ** Somewhere looping **
    struct epoll_event epEventOut;
    int count = epoll_wait(epFD, &epEventOut, 1, timeout);

    if (epEventOut.events & EPOLLIN) {
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
       
    
    // ** Somewhere shutdown **
    close(epFD);
```

Once registered, you provide an FD (to the epoll specific FD) and one or more `epoll_event` structures for the results. If you bind only a single fd to the epoll FD, that means only 1 event max will occur.

Timeout works the same as poll.

If you wanted to poll READ+WRITE, you'd OR the bitfields together. A `EPOLL_CTL_ADD` operation only lets you use the same fd once per epoll FD. So if you wanted to be clever and allow options (Read, Write, or Both), you'd need 3 seperate epoll FD's, one for each configuration.


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

Use this similar to `epoll`

```c
    // Inputs: fd, timeout

	// ** Somewhere init **
    int kqFD = kqueue();
    if (kqFD == -1) {
        return nullptr;
    }

    struct kevent kqEvent;
    memset(&kqEvent, 0, sizeof(struct kevent));
    EV_SET(&kqEvent, fd, EVFILT_READ, EV_ADD | EV_ENABLE, 0, 0, 0);


    // ** Somewhere looping **
    struct timespec ts;
    ts.tv_sec = timeout / 1000;
    ts.tv_nsec = (timeout % 1000) * 1000000;

    struct kevent kqEventOut;
    int count = kevent(ne->kqFD, &kqEvent, 1, &kqEventOut, 1, &ts);

    if (kqOutEvent.filter & EVFILT_READ) {
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
	
	
    // ** Somewhere shutdown **
    close(kqFD);
 ```

To contrast `epoll`, you only need a single kqueue FD. Then index the start and number you want to do.

Like `select`, if the `timespec` argument is a null pointer, it polls forever. `timespec` has a much higher available precision too.


#### Reference

* [https://www.freebsd.org/cgi/man.cgi?kqueue](https://www.freebsd.org/cgi/man.cgi?kqueue)
* [https://wiki.netbsd.org/tutorials/kqueue_tutorial/](https://wiki.netbsd.org/tutorials/kqueue_tutorial/)
* [https://developer.apple.com/library/.../KernelQueues.html](https://developer.apple.com/library/archive/documentation/Darwin/Conceptual/FSEvents_ProgGuide/KernelQueues/KernelQueues.html)