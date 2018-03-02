---
id: 6328
title: Revised thoughts on Squirrel Math
date: 2013-11-08T02:30:01+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6328
permalink: /2013/11/08/revised-thoughts-on-squirrel-math/
categories:
  - Qk
  - Squirrel
---
Been thinking a bunch about the vector math classes mentioned in the previous post (vec2, vec3, etc). I was ready to try proposing &#8220;something&#8221; to let you add .anything to a class to access members hidden in (say) userdata. As it turns out, that already works. 

The \_get and \_set metamethods talk about indexes in the documentation, so I mistakenly assumed they were for creating array-like syntax (maybe they are too), but in actuality they do exactly what I want: let you handle .anything

<pre class="lang:default decode:true " >class Toby {
		_x = 2.0;
		_y = 50.0;
		
		function _get(idx) {
			if ( idx == "x" ) {
				return _x;
			}
			else if ( idx == "y" ) {
				return _y;
			}
			throw null;
		}
		
		function _set(idx,val) {
			if ( idx == "x" ) {
				return _x = val;
			}
			else if ( idx == "y" ) {
				return _y = val;
			}
			throw null;
		}
	};
	
	local MyTob = Toby();
	
	MyTob.y *= 2;
	Log( MyTob.y );</pre>

This is, of course, a Squirrel implementation. 

A better use would be to write these metamethods in native code. Also instead of a class, use a UserData type to hold the true data (vector parts, a matrix, a quaternion), and attach all functionality using a delegate.

Using native has the added advantage when it comes to the operators (metamethods). Types can be checked far quicker this way (as constant values like OT_FLOAT), so my concerns about wasted time doing checks for each type shouldn&#8217;t be much of a problem anymore. I have to give somewhere, and the flexibility Squirrel provides is worthwhile.

Creating instances though is the question.

We could have a delegate called &#8220;vec2\_delegate&#8221;, and a native function called &#8220;vec2&#8221; (like how JavaScript classes work). Have the function push the UserData structure on to the stack equal to the values passed, then attach the vec2\_delegate to it. The delegate has a _typeof method that returns &#8220;vec2&#8221;. Finally, so long as it&#8217;s the only new thing on the stack, the vec2 function say it returned a value, and thus will be assigned by reference to 

Copy Constructor implementation will be native, detected the same way as before, but no longer a cloning issue as it&#8217;ll be native code.

Just a few things to figure out:

1. How to &#8220;throw null&#8221; natively (required by \_get and \_set).

<pre class="lang:default decode:true " >// Maybe this:
sq_pushnull(v);
sq_throwobject(v); // sq_throwobj? Seen some documentation discrepancies //</pre>

2. How to differentiate between UserData types (vec2, vec3, mat4, etc).

<pre class="lang:default decode:true " >* sq_gettype(v,idx) returns the constant like OT_USERDATA.
* sq_settypetag(v,idx,&value) and sq_gettypetag seem set/retrieve arbitrary data. This may be it!</pre>

3. How to create and popluate Userdata.

<pre class="lang:default decode:true " >* sq_newuserdata(v,size) pushes a UserData on to the stack and returns an SQUserPointer to it.
* sq_setreleasehook lets you assign a function to be called upon deletion of UserData.
* sq_settypetag(v,idx,&tag) to set a typetag (arbitrary data).
* sq_getuserdata(v,idx,&ptr,&tag) to get the value and typetag of a UserData.

* sq_pushuserpointer(v,ptr) lets you push any arbitrary pointer on to the stack.
* sq_getuserpointer(v,idx,&ptr) to retrieve it from the stack.</pre>

Unrelated, but sq\_getmemberhandle(v,idx,&handle) looks useful for optimizing data read/writes between the VM and Native code. sq\_getbyhandle and sq\_setbyhandle. The SQMEMBERHANDLE type however only contains a bool (\_static) and an index (\_index), so I&#8217;m not entirely sure how we get quick-access to data yet. It looks like you may push the value you want to set (sq\_pushint, sq\_pushstring, etc) and then follow it with a call to sq\_setbyhandle. Reading the information though, it sounds like Member Handles may be a class-only feature, so this may not be what I&#8217;m looking for.

Classes can have UserData associated with them! sq\_setclassudsize sets the size of the UserData attached to a class. sq\_setinstanceup and sq\_getinstanceup are a pair of functions for manipulating a UserPointer associated with a class instance (not UserData). That said, calling sq\_setclassudsize will automatically set the internal classes UserPointer to the location of allocated data. Following up with a call to sq_getinstanceup will tell you where to put your data.

## What&#8217;s missing?

The only thing missing is a nice way of handling Floats with new Vector and Matrix types (as userdata).

One option is to have a &#8220;scalar&#8221; or &#8220;real&#8221; type that exists for doing math with Vectors and Matrices. MyVec.x \*= 10 is going to work fine already, but MyVec \*= 10 will not. I could put in similar code as before, a check &#8220;if ( vs.type == OT_FLOAT )&#8221; then treat it as a scalar, but that doesn&#8217;t handle the front case (MyVec = 10 * MyVec). That&#8217;s why I&#8217;m suggesting a .toscalar() or .toreal() function. toscalar() I believe makes the most sense, as the operations being performed are scalar math ones. In addition, the float can have a .tovec3() or similar to create boring (1,0,0) type conversions.

Vectors will already support using any float as arguments &#8220;vec3(0,MyFloat,12)&#8221;. So classes like 2&#215;2 or 4&#215;4 matrix should support constructing with equivalent vectors &#8220;mat2(vec2(1,0),vec2(0,1))&#8221;. If feeling very adventurous, take any combination of float and vector types.

Yeah, the only hold-out is the &#8220;NewVec = 10 * OldVec&#8221; case. 

I don&#8217;t really want to disturb the standard Float type by introducing extra check &#8220;is the previous variable a Matrix?&#8221;. Requiring conversion via .toscalar() may not be unreasonable after all, even though all operations like magnitude and normalize are available inside the Float (well, my modified float anyway).