---
title: 'Notes: KCP ARQ Network Protocol'
layout: post
---

This is a deep dive in to the source code for KCP. Despite the project claiming to have good documentation, I disagree. It's simple, but it doesn't do a great job explaining itself.

The following is a breakdown of the logic of each function.

* [https://github.com/skywind3000/kcp](https://github.com/skywind3000/kcp)
* [https://github.com/skywind3000/kcp/blob/master/README.en.md](https://github.com/skywind3000/kcp/blob/master/README.en.md)

# ikcp.c
The main source file.

### ikcp_encode8u ... ikcp_encode32u, ikcp_decode8u [private]
A bunch of functions for byte-swapping. the `encode` functions write to the pointer, while the decode functions read from it, writing to the input argument.

Available in 8, 16, and 32 bit unsigned type variants, for both encode and decode.

### _imin_, _imax_, _ibound_ [private]
A bunch of min/max code. Notable is the bound code which has an unusual behavior. It takes 3 arguments: `lower`, `middle`, `upper`. Step one is to `_max_` the `lower` and `middle bounds`, then `_min_` versus the `upper` bound.

Off the top of my head I'm not sure where this exact formula is useful, but we'll see as we dive deeper.

### _itimediff [private]
Simple time subtract function.

### ikcp_malloc, ikcp_free [private]
If set, calls the `ikcp_malloc_hook` and `ikcp_free_hook` function pointers, otherwise calls standard `malloc` and `free`. Not a bad way to handle this IMO (especially for fallback reasons). That said we could save a cycle if we simply assigned `malloc` and `free` to the hooks directly in some init function, or set it via a `#DEFINE`.

### ikcp_allocator **[PUBLIC]**
Assigns the `malloc` and `free` hooks.

### ikcp_segment_new, ikcp_segment_delete [private]
Using the allocators, allocates an `IKCPSEG` structure with a bunch of data tagged on the end.

```c
struct IKCPSEG {
	struct IQUEUEHEAD node;
	IUINT32 conv;
	IUINT32 cmd;
	IUINT32 frg;
	IUINT32 wnd;
	IUINT32 ts;
	IUINT32 sn;
	IUINT32 una;
	IUINT32 len;
	IUINT32 resendts;
	IUINT32 rto;
	IUINT32 fastack;
	IUINT32 xmit;
	char data[1];
};
```

### ikcp_log **[PUBLIC]**, ikcp_canlog [private]
An printf-like wrapper for internal logging. A `writelog` function must be assigned to the `kcp` structure for this to work. `ikcp_canlog` checks if appropriate flags and pointers are set for logging to work in the first place.

Logs can include a mask, which is compared against `kcp->logmask`.

```c
#define IKCP_LOG_OUTPUT			1
#define IKCP_LOG_INPUT			2
#define IKCP_LOG_SEND			4
#define IKCP_LOG_RECV			8
#define IKCP_LOG_IN_DATA		16
#define IKCP_LOG_IN_ACK			32
#define IKCP_LOG_IN_PROBE		64
#define IKCP_LOG_IN_WINS		128
#define IKCP_LOG_OUT_DATA		256
#define IKCP_LOG_OUT_ACK		512
#define IKCP_LOG_OUT_PROBE		1024
#define IKCP_LOG_OUT_WINS		2048
```

The default `logmask` is 0, meaning all logging is disabled. Curiously there is no `IKCP_LOG_ALL` constant. The author probably hardcodes this value to `-1`.

### ikcp_output, ikcp_setoutput [PUBLIC]
Okay, `ikcp_output` is in the helper function section, but it's actually a key function.

All data that is sent by KCP goes through this function. You hook up a function by either setting `kcp->output` or calling `ikcp_setoutput`, and that function gets called to actually send data to the outside world.

The KCP structure, and the user data pointer previously passed to the `ikcp_create` function get passed to the output function you assign.

### ikcp_qprint [private]
Looks to be a dummy debug function for printing send and receieve queues. It's disabled (`#if 0`).

### ikcp_create [PUBLIC]
Allocates an `ikcpcb` structure. Uses the new/delete previously assigned (malloc/free by default).

```c
typedef struct IKCPCB {
	IUINT32 conv, mtu, mss, state;
	IUINT32 snd_una, snd_nxt, rcv_nxt;
	IUINT32 ts_recent, ts_lastack, ssthresh;
	IINT32 rx_rttval, rx_srtt, rx_rto, rx_minrto;
	IUINT32 snd_wnd, rcv_wnd, rmt_wnd, cwnd, probe;
	IUINT32 current, interval, ts_flush, xmit;
	IUINT32 nrcv_buf, nsnd_buf;
	IUINT32 nrcv_que, nsnd_que;
	IUINT32 nodelay, updated;
	IUINT32 ts_probe, probe_wait;
	IUINT32 dead_link, incr;
	struct IQUEUEHEAD snd_queue;
	struct IQUEUEHEAD rcv_queue;
	struct IQUEUEHEAD snd_buf;
	struct IQUEUEHEAD rcv_buf;
	IUINT32 *acklist;
	IUINT32 ackcount;
	IUINT32 ackblock;
	void *user;
	char *buffer;
	int fastresend;
	int nocwnd, stream;
	int logmask;
	int (*output)(const char *buf, int len, struct IKCPCB *kcp, void *user);
	void (*writelog)(const char *log, struct IKCPCB *kcp, void *user);
} ikcpcb;
```

Zeroes and initializes most things to their respected constants.

`buffer` mallocates enough space for 3x MTU's (1400 bytes) with `IKCP_OVERHEAD` (24 bytes, i.e. 1424 bytes total). Oddly a few lines before the `mss` gets set to MTU-IKCP_OVERHEAD. So at this time it's possible the math here is a little off.

Queues and Message Buffers get initialized by calling `iqueue_init` (`snd_queue`, `rcv_queue`, `snd_buf`, `rcv_buf`).

Default interval `IKCP_INTERVAL` is 100 (ms).

### ikcp_release **[PUBLIC]**


While each queue and buffer isn't empty (`snd_queue`, `rcv_queue`, `snd_buf`, `rcv_buf`), fetch the next segment, delete the iqueue entry (`iqueue_del`) and delete the segment (`ikcp_segment_delete`).

Delete the `buffer` and `acklist` (`ikcp_free`).

Initialize some other variables, and finally call `ikcp_free` on the kcp structure.

### ikcp_peeksize(const ikcpcb* kcp) **[PUBLIC]**
**Summary**: Return the number of bytes of the message(s) in the receieve queue (`rcv_queue`).

Returns `-1` if the `rcv_queue` is empty.

If the queue has a single item, return that items length.

If we don't have enough fragments (`nrcv_queue < seg->frg + 1`), the data in the receive buffer should be considered incomplete, and `-1` is returned.

Returns the sum of all segment lengths. Early out if the fragment count is zero in a segment.

### ikcp_recv(ikcpcb* kcp, char* buffer, int len) **[PUBLIC]**
**Summary**: Attempts to fill `buffer` with the complete stream of data currently sitting in the receieve queue.

If `len` is negavite, we enable peeking (`ispeek`). With peeking enabled, the segments will not be consumed after they are written to the buffer (meaning they are consumed in a future call). The negative buffer length is undone a few lines later, and treated as the length thereafter.

Bail if the receieve queue (`rcv_queue`) is empty.

`peeksize` is the number of bytes of the data in the receive queue (`ikcp_peeksize(kcp)`). It doesn't directly have an effect on the peeking feature above.

If `peeksize` is negative, it means either the data is empty or incomplete, and the function returns `-2`. 

If `peeksize` is greater than `len`, there isn't enough space to store the data, and the function returns `-3`.

If the number of items in the receive queue (`nrcv_que`) is greater than the receive window (`rcv_wnd`), enable recovery (`recover = 1`).

Merge all of the fragments together, writing them to `buffer`. `len` is reset to `0`, and we loop over every fragment until the fragment itself is `0` (`nullptr`), or if the receive queue is empty (`rcv_queue->next == rcv_queue`). Fragments are consumed if peeking is disabled.

`peeksize` and `len` should match. 

We are done this step.

The next step is to movie the next item in the receive buffer (`rcv_buf`) to the receive queue (`rcv_queue`). 

If there are no items in the receive buffer, then there is nothing to do.

If there are items, the first item is then removed from the receieve buffer (`iqueue_del`), and it is appended to the receive queue (`rcv_queue`). Counts are updated.

Something to do with window (both in the loop and 

fast recover?

**Questions**: Are the linked lists circular? Or does `rcv_queue->next` get set to itself when it is empty?

**Answer**: YES! The `IQUEUE_INIT`macro initializes `iqueue`'s with prev/next pointing to itself.