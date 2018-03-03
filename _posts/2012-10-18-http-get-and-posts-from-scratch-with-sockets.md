---
id: 5462
title: 'HTTP GET and POST&#8217;s from scratch with Sockets'
date: 2012-10-18T14:25:53+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5462
permalink: /2012/10/18/http-get-and-posts-from-scratch-with-sockets/
categories:
  - Technobabble
---
So I&#8217;ve done a bunch of networking research lately, and have actually decided I&#8217;m _not_ going to continue writing my own HTTP GETter and POSTer. Instead, I&#8217;ll be using [libcurl](http://curl.haxx.se/libcurl/). That said, I am not that comfortable using 3rd party libraries and tools _unless_ I have a solid understanding of how they work internally. 

So this is a collection of notes on how to do HTTP GET and POST requests, in case I ever need to come back and do this from scratch (because I&#8217;m not going to remember all this). So lets get started.

## Functions Needed

Dealing with HTTP, we&#8217;re going to need to interpret data in a bunch of ways. Here are a list of things not handled by socket libraries:

  * Key/Value Line Reader. Data in an HTTP header is returned as &#8220;Key: Value\n&#8221;
  * Hexadecimal String to integer conversion. &#8220;5c\n&#8221; means 92 bytes of data follow.
  * Functions for extracting parts of a URL. Host Name (blah.domain.com), Path (/somedir/somefile.php).
  * Functions for encoding and decoding as: action=list&info=Hello+World+%28Woo%21%29&num=1
  * A linked list or similar structure to collect subsequent random sized parts of a TCP stream before final data assembly.

## HTTP in a nutshell

This is a good reference: <http://www.jmarshall.com/easy/http/>

Getting data over HTTP is a matter of exchanging HTTP headers. An HTTP header is a line delimited set of key/value pairs. Notably, the first line is not a key/value pair, but the lines that follow are. Finally, the header ends is a blank line (just a newline CRLF).

Here&#8217;s how we ask for data. Open a TCP socket, and stuff a packet containing this data in to it.

<pre class="lang:default decode:true " title="HTTP Request Header" >GET /_robots.txt HTTP/1.1
Host: toonormal.com
User-Agent: Mozilla/5.0 (whatever)
                                                                                                         [shh! this line is blank]
</pre>

The above is called an HTTP Request Header. It&#8217;s our way of asking a webserver for data. It&#8217;s the same thing as punching the following in to a web browser:

<pre>http://toonormal.com/_robots.txt</pre>

The domain part is extracted (known as the Host Name), as is the path. The HTTP part is discarded, or rather, is what tells us that we will be exchanging data using HTTP Headers. Had the protocol been something else, like ftp://, we would be doing this a completely different way (not using HTTP headers).

Following the packet, the webserver should respond by sending you the following packet. All you need to do is receive it (well, and interpret it too):

<pre class="lang:default decode:true " title="HTTP Response Header" >HTTP/1.1 200 OK
Date: Mon, 24 Sep 2012 17:50:30 GMT
Server: Apache
X-Pingback: /xmlrpc.php
Transfer-Encoding: chunked
Content-Type: text/plain; charset=utf-8

1a
User-agent: *
Disallow: /</pre>

Long story short, the above is what sending a text file containing the following looks like.

<pre>User-agent: *
Disallow: /</pre>

Don&#8217;t be confused by its similarity, this is a real file: <http://toonormal.com/_robots.txt>

That roughly summarizes all internet browser traffic. There is certainly more to it, but nearly everything is just variations of the above.

## Nuances of HTTP Headers

Here&#8217;s what I know:

  * Don&#8217;t use only &#8220;\n&#8221; in Headers!! On Windows this is fine, since &#8220;\n&#8221; maps to hex 0D 0A (CR LF), but instead you should explicitly do the CR LF, so your constructed HTTP Headers are portable. You can do this with &#8220;\r\n&#8221;, or with octal codes &#8220;\015\012&#8221;. Unfortunately, this generates double CR codes when you sprintf on Windows (CRCRLF, hex 0D 0D 0A). That is fine though, since it seems web servers seem to understand this. You should always be eliminating whitespace around key/value pairs anyway, and that includes any CR and LF codes alongside your tabs and spaces.
  * HTTP Headers always end with a double newline. That means CRLF or CRCRLF. The double newline is the only way of knowing when the header ends, and the data (or chunks) begin.

## Nuances of the HTTP Request Header

Here&#8217;s some more:

  * The Request Line (the 1st one) takes one of several request types. **GET**, **POST**, **HEAD**, PUT, DELETE, OPTIONS, and TRACE. Generally speaking, the first 3 are the only ones we care about. GET&#8217;s are what almost all HTTP requests should be. HEAD&#8217;s are exactly like GET&#8217;s, except they only return the Header part (no data). POST&#8217;s are a variation of GET that sends data alongside the Request Header, much like how an HTTP Response Header sends you files and other data. More on this later.
  * Socket connections are with IP addresses, not hosts. The point of the &#8220;Host: &#8221; field in a HTTP Request Header is to tell the webserver where to route the request. If you happen to host multiple domain and subdomains on a web host, the &#8220;Host: &#8221; field is what actually differentiates between each and every domain. It is a requirement of the HTTP/1.1 protocol (so if you&#8217;re feeling stupid you can change to HTTP/1.0 and omit the Host field, but that would be pointless). Without a Host field, it&#8217;s the same thing as punching in a website by its IP address.
  * &#8220;Accept-Encoding: gzip&#8221; and &#8220;Accept-Encoding: gzip, deflate&#8221; can be used to tell the webserver that you understand compressed data. So for a slight CPU hit, the data will be compressed before sending. This may mean the data needs to finish generating first as well. If your returned data is less than 200 bytes, compression may not actually be less size.
  * Google App Engine also requires that &#8220;gzip&#8221; be included in the User-Agent if it will be returning gzipped data.
  * Compression support across webhosts isn&#8217;t very reliable (at least cheap ones). You may be better off explicitly compressing, caching, and sending that instead of expecting automatic file compression to work its magic.
  * More information on Compression: <http://www.http-compression.com/>
  * User-Agent: <http://en.wikipedia.org/wiki/User_agent> 

## Nuances of HTTP Response Headers

And again:

  * &#8220;Transfer-Encoding: chunked&#8221; is a common encoding for text and JSON files. You will receive multiple chunks until the file finishes. Regrettably, you sometimes don&#8217;t actually know the length of file you are receiving (especially if it&#8217;s generated). If you&#8217;ve ever noticed that behavior in a web browser download (file download unknown length and time), this is what was going on. You were receiving the file and the header neglected to include a &#8220;Content-Length: &#8220;.
  * &#8220;Transfer-Encoding: gzip&#8221; is what is returned to tell you the data is coming in gzip compressed. This is a non-chunked format. From everything I&#8217;ve seen, a &#8220;Contente-Length: &#8221; is always included. The data is raw binary, and unlikely to be finished in the first packet. Subsequent packets (I assume) contain headerless, sizeless, raw data.

## Code &#8211; BSD Sockets vs WinSock2

BSD Sockets are the long time standard way to do network communications. Practically all socket libraries are derivatives of the original BSD standard.

WinSock2 is actually an implementation of BSD Sockets. It&#8217;s 80-90% functionally compatible with BSD Sockets, so if you really wanted to, you could implement both in one codebase with just some ocassional #ifdefs. That said, WinSock2 does have a plethora of other functions, but they all seem to map to BSD Socket features.

The one big difference between BSD Sockets and WinSock2 is that WinSock2 needs to be initialized before any socket code will work, and shutdown once finished.

<pre class="lang:default decode:true " >WSADATA wsaData;
	WSAStartup( MAKEWORD(2,0), &wsaData );
	atexit( (void(*)())WSACleanup );
</pre>

The above code uses an atexit() callback, but if you really wanted to, you could call WSACleanup() yourself at program end. More details on WSAStartup() can be found here: 

<http://msdn.microsoft.com/en-us/library/windows/desktop/ms742213%28v=vs.85%29.aspx>

### Host Name Lookup

Sockets are connections between computers known by IP addresses. The internet however heavily uses the idea of a host name. &#8220;google.com&#8221; is a hostname. So before we can talk to a website, we need to send a request to a DNS Nameserver to have them look-up a domain name for us.

A side story on DNS nameservers, I recently set up a computer at my parents place that I could connect to remotely over the internet from my home. This required setting up specific ports on their internet router to be forwarded to the computer. Unfortunately, this meant assigning a static IP address to the computer. What sucks about this is you need to explicitly say where the internet gateway is (the router&#8217;s IP address), and the DNS Nameservers (typically assigned by your ISP, but [Google shares](https://developers.google.com/speed/public-dns/), [as do others](http://compnetworking.about.com/od/dns_domainnamesystem/tp/top-free-internet-dns-servers.htm)). Normally this stuff is assigned automatically when you ask a DHCP server for an IP. If you neglect the DNS Nameserver, you can&#8217;t look up domains. Networking 101, but I&#8217;m a coder not a networking guy. 

Anyways, I just wanted to talk about this to give context to it&#8217;s importance. It&#8217;s literally the backbone of what most people consider the internet. If you can&#8217;t type in a website name, then as far as you&#8217;re concerned the internet is down. I have run in to DNS issues many times in the past, even strange cases where the DNS server is down but IP traffic works fine. If you happen to have an IP cached/remembered somewhere, you can still connect. Of course, it&#8217;s not our responsibility as developers to handle DNS outages, but it&#8217;s an issue that always impresses me. The internet is &#8220;down&#8221;, yet it&#8217;s still working. Even if your own DNS server is down, but IP is still up, then the outside world can still connect to you. You can&#8217;t search for computers by domain name, but your own domain records still exist in other DNS databases.

Ahem! Now that we&#8217;re out of that rathole, this is a shockingly simple thing to do.

<pre class="lang:default decode:true " >// FYI: Do not release this memory. Winsock stores a single HostEnt structure per thread. //
	hostent* HostEnt = gethostbyname( HostName );

	if ( HostEnt ) {
		printf( "HostEnt-&gt;h_name: %s\n", HostEnt-&gt;h_name );
	}</pre>

The HostEnt structure is an interesting way of understanding the internet. 

Here&#8217;s a more featured snippet:

<pre class="lang:default decode:true " >hostent* HostEnt = gethostbyname( HostName );

	// Output the contents of the HostEnt structure //
	if ( HostEnt ) {
		printf( "HostEnt-&gt;h_name: %s\n", HostEnt-&gt;h_name );
		
		{
			int AliasCount = 0;
			while( HostEnt-&gt;h_aliases[AliasCount] != 0 ) {
				printf( "HostEnt-&gt;h_aliases[%i]: %s\n", AliasCount, HostEnt-&gt;h_aliases[AliasCount] );
				AliasCount++;
			}
			printf( "%i Aliases Found\n", AliasCount );
		}
		
		printf( "HostEnt-&gt;h_addrtype: %i\n", HostEnt-&gt;h_addrtype );
		printf( "HostEnt-&gt;h_length: %i\n", HostEnt-&gt;h_length );
		
		{
			int AddrListCount = 0;
			while( HostEnt-&gt;h_addr_list[AddrListCount] != 0 ) {
				printf( "HostEnt-&gt;h_addr_list[%i]: %u.%u.%u.%u\n", 
					AddrListCount, 
					(unsigned char)HostEnt-&gt;h_addr_list[AddrListCount][0], 
					(unsigned char)HostEnt-&gt;h_addr_list[AddrListCount][1], 
					(unsigned char)HostEnt-&gt;h_addr_list[AddrListCount][2], 
					(unsigned char)HostEnt-&gt;h_addr_list[AddrListCount][3] 
					);
				AddrListCount++;
			}
			printf( "%i Addresses Found\n", AddrListCount );
		}		
	}
	else {
		printf( "gethostbyname failed!\n" );
		return -1;
	}</pre>

Here&#8217;s a couple outputs. First, my blog here.

<pre>HostName: toonormal.com

HostEnt->h_name: toonormal.com
0 Aliases Found
HostEnt->h_addrtype: 2
HostEnt->h_length: 4
HostEnt->h_addr_list[0]: 184.172.176.66
1 Addresses Found</pre>

Fairly straightforward, nothing too weird going on.

However, lets take a look at Google App Engine.

<pre>HostName: someapp.appspot.com

HostEnt->h_name: appspot.l.google.com
HostEnt->h_aliases[0]: someapp.appspot.com
1 Aliases Found
HostEnt->h_addrtype: 2
HostEnt->h_length: 4
HostEnt->h_addr_list[0]: 74.125.133.141
1 Addresses Found</pre>

This one, what I thought was the actual host name is actually an alias. Visiting that appspot host uselessly returns me to the Google homepage, but the alias runs my Google App Engine application. I&#8217;m not going to pretend I totally understand what&#8217;s going going on behind the scenes, but what I imagine is going on is that appspot host is the real app that, based on the host name given (the alias) executes the specific users app. Google chooses to handle the ownership of the app itself (by the given host name), where as my web server (a shared host) is also the primary domain.

All that fun discovery aside, the only thing that matters to us is the h\_addr\_list. This is the IP address. It is stored as 4 bytes (unsigned char&#8217;s) in the case of IPv4. IPv6 is larger, but we don&#8217;t care about that right now. This is the data we need to open a socket.

### Opening a Socket

Lets open.

<pre class="lang:default decode:true " >SOCKET Sock = socket( PF_INET, SOCK_STREAM /*SOCK_DGRAM*/, 0 );
	setsockopt( Sock, SOL_SOCKET, SO_KEEPALIVE, 0, 0 );

	// A data structure for describing what we want to connect to (i.e. an IP) //
	sockaddr_in Server;
	memset( (char*)&Server, 0, sizeof(Server) ); // Zero, to be safe //
	memcpy( (void*)&Server.sin_addr, HostEnt-&gt;h_addr_list[0], HostEnt-&gt;h_length );	// Cheat, take Addr 0 //
	Server.sin_family = HostEnt-&gt;h_addrtype;
	Server.sin_port = (unsigned short)htons( 80 ); // I assume we want port 80 //

	// Open Socket Connection //
	int Err = connect( Sock, (const sockaddr*)&Server, sizeof(Server) );

	if ( Err &lt; 0 ) {
		printf( "Connection Failed!\n" );
		return -1;
	}
	</pre>

SOCK\_STREAM is the TCP streaming protocol, and SOCK\_DGRAM is the UDP datagram protocol. HTTP is a TCP protocol, so we open one of those. There are actually other arguments that explicitly say &#8220;TCP&#8221; and &#8220;UDP&#8221; as the 3rd argument to create socket function, but pretty much all the code I&#8217;ve seen explicitly does not ever specify a 3rd argument. It&#8217;s weird, but there it is.

### Closing a socket

&#8230;is Easy!

<pre class="lang:default decode:true " >// Close Socket Connection //
	closesocket( Sock );	// 'close( Sock );' in BSD Sockets //
</pre>

### Sending the HTTP Request Header

Send me a website please!

<pre class="lang:default decode:true " >const char* HostName = "sykhronics.com";
	const char* Path = "/";
	
	{
		// Build an HTTP Header //
		char Header[4096];	
		sprintf( Header, "%s %s HTTP/1.1\r\nHost: %s\r\nUser-Agent: %s\r\n\r\n",
			"GET",
			Path,
			HostName,
			"Mozilla/5.0 (en-us)",
			);
		size_t HeaderLength = strlen( Header );
				
		// Send the Header //
		int ByteCount = send( Sock, Header, HeaderLength, 0 );
		
		printf( "%i Bytes Sent (Request Header)\n\n", ByteCount );
	}</pre>

### Receiving the HTTP Response

Gimme!

<pre class="lang:default decode:true " >{
		char Buffer[4096+1];
		
		// Get the Response //
		int ByteCount = recv( Sock, Buffer, 4096, 0 );
		
		Buffer[ByteCount] = 0; // Zero terminate the returned data //
		
		printf( "Data: \n%s\n", Buffer );
		
		printf( "%i Bytes Received (Response)\n\n", ByteCount );
	}
</pre>

And the output looks something like this.

<pre>HTTP/1.1 200 OK
Date: Thu, 18 Oct 2012 18:12:15 GMT
Server: Apache
Last-Modified: Tue, 01 May 2012 00:28:29 GMT
ETag: "ff42a3-6d0-4f9f2e2d"
Accept-Ranges: bytes
Content-Length: 1744
Content-Type: text/html






<table height="99%" width="100%" cellpadding="0" border="0">
  <td valign="middle" align="right" width="100%">
    <table cellspacing="0" cellpadding="0" border="0" width="100%">
      <td align="center" >
        <img src="GamePage.png" border="0" USEMAP="#nav" /><br />
                                
      </td>
                      
    </table>
            
  </td>
          
</table>
        &lt;/td>

&lt;/table>

        




</pre>

However, the above code is a cheat. It&#8217;s best case scenario, serving a small HTML webpage. 

In practice, if there is any delay (a generated page), you will get several fragments of a page, one after the other.

<pre class="lang:default decode:true " >HTTP/1.1 200 OK
Date: Thu, 18 Oct 2012 18:17:17 GMT
Server: Apache
X-Powered-By: PHP/5.3.13
Transfer-Encoding: chunked
Content-Type: application/json

13 
{
"Action":"List",</pre>

That is hardly a valid JSON file (it&#8217;s incomplete!).

This is one of the reasons why I&#8217;ve decided to use libcurl. Writing code to extract information from an HTTP header, a decoder for HTTP chunked data, a decoder for data you know the size of, and so on. The work adds up, and it also needs to be well tested. Still, this is how you communicate via the HTTP protocol. It&#8217;s not hard. But I figure, I can spend a half day recording my findings, plus no more than an hour getting libcurl working. That, or a few days building and testing all the pieces necessary, then later discovering cases I don&#8217;t handle correctly. Not to mention, the above code also assumes a perfectly clean and working internet connection. It doesn&#8217;t handle errors at all (well barely). That said, there may come a time I need to hack in/hack out a library I&#8217;m using, and I wanted to be much more aware of what actually is going on.

## Sending Data via HTTP Get

You may be familiar with URL&#8217;s like the following.

<pre>http://google.com/?q=chickens</pre>

Placing the strangely encoded data after a question mark in the URL is one way of passing data over HTTP. Rather, it&#8217;s the &#8220;GET&#8221; way. If you familiar with PHP, a global variable **$_GET** is filled with these values. These are key/value pairs. A key &#8220;q&#8221; is equal to the value &#8220;chickens&#8221;. Additional arguments are separated by an &#8220;&&#8221;. Spaces are replaced by &#8220;+&#8221;. Other symbols are replaced with % codes (%20 = space [ascii 32], %28 %29 = brackets [ascii 40,41], etc).

HTML URL encoding reference: <http://www.w3schools.com/tags/ref_urlencode.asp>

Punching the following URL in to a browser sends 3 variables:

<pre>http://www.someurl.com/?action=list&info=Hello+World+%28woo%21%29&num=1</pre>

The equivalent HTTP Request header is:

<pre>GET /?action=list&info=Hello+World+%28woo%21%29&num=1 HTTP/1.1
Host: www.someurl.com
User-Agent: Mozilla/5.0 (en-us)
                                                                                                         [shh! this line is blank]</pre>

And the result has fed the following 3 variables to the receiving webpage.

<pre>action = "list"
info = "Hello World (woo!)"
num = 1</pre>

The amount of data you can send via HTTP GET is limited by the webservers themselves. If a header is too large, they will often raise an error. The average limit is about 8k, but it may be worth keeping the header under 4k because:

  * 4k &#8211; Nginx default
  * 8k &#8211; Apache default
  * 16k &#8211; IIS default

<http://stackoverflow.com/questions/686217/maximum-on-http-header-values>

If you need to send more than that, you can do so via an HTTP POST.

## Sending Data via HTTP Post

The above is all about sending and receiving data as an HTTP GET request. Doing other requests is a simple matter of changing the word &#8220;GET&#8221; in the first line of the HTTP Request Header to something else (i.e. &#8220;POST&#8221;).

HTTP POST&#8217;s are nearly identical to HTTP GET&#8217;s, but they now include a data section. The data section follows the same rules as when you receive data via an HTTP Response. Another way to think about it: HTTP GET Request Headers are equivalent to HTTP HEAD Response Headers (i.e. headers only). HTTP POST Request Headers are equivalent to HTTP GET Response Headers (i.e. header+data). Hopefully that&#8217;s not confusing (Requests and Responses are different). If it is, just ignore it. Generally speaking, HTTP POST is what gives us full 2 way communication over the HTTP protocol.

Lets dive in head first.

<pre>POST / HTTP/1.1
Host: www.someurl.com
User-Agent: Mozilla/5.0 (en-us)
Content-Type: application/x-www-form-urlencoded
Content-Length: 47

action=list&info=Hello+World+%28woo%21%29&num=1
</pre>

The HTTP POST Request header resembles the HTTP GET Response header more, in that we are now including a &#8220;Content-Type&#8221; of our own. The content type, &#8220;x-www-form-urlencoded&#8221; just happens to be the name for the same encoding used by HTTP GET data passed after a ? in a URL. This is how HTML forms work. If the form is a GET form, it adds it to the URL. If the form is a POST form, it places it in the data HTTP POST Request.

Notice the double newline (i.e. blank space). That means the header has ended. The rest of the file is pure data. Again, data is not limited in size like the header. Your &#8220;Content-Length&#8221; can be large if you want, and can be many many packets.

So on that note, if one was to implement large transfers over HTTP POST, you would have to similarly break up packets in to smaller parts, giving the responsibility of reassembling them to the host (just like it&#8217;s your responsibility to assemble them on your side when you HTTP GET).

Phew!

## Conclusion?

That about sums up my notes on doing HTTP requests from scratch&#8230;

&#8230;But like I said, I plan to use libcurl now.

## libCurl

.. is easy. Heck, the library is called easy.

<http://curl.haxx.se/libcurl/c/libcurl-tutorial.html>

To Init, do:

<pre>curl_global_init(CURL_GLOBAL_ALL);</pre>

If you&#8217;re playing nice with another networking library (eNet, for example), you may actually not want to the above. There are details in the tutorial link above. I&#8217;m pretty sure the flag CURL\_GLOBAL\_WIN32 (part of CURL\_GLOBAL\_ALL) calls WSAStartup (which as mentioned in the beginning, needs to be called for sockets to work at all). So if eNet is going to do it for us, we don&#8217;t have to.

<pre>CURL *curl;
 
  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "http://example.com");
 
    /* Perform the request, res will get the return code */ 
    CURLcode res = curl_easy_perform(curl);

    /* Check for errors */ 
    if(res != CURLE_OK)
      fprintf(stderr, "curl_easy_perform() failed: %s\n", curl_easy_strerror(res));
 
    /* always cleanup */ 
    curl_easy_cleanup(curl);
  }</pre>

And then there are functions for adding things to the header, for encoding key/value pairs used GET/POST data, and so on.

Sounds so much nicer than doing this entirely from scratch. 🙂

## Real Conclusion

I do think a background in Socket programming and HTTP requests make everything about using libcurl make way much more sense, and that is what makes this little research project of mine worthwhile. I now know what goes on inside the black box.