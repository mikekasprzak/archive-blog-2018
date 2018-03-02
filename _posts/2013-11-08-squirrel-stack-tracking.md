---
id: 6336
title: Squirrel Stack Tracking
date: 2013-11-08T13:22:32+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=6336
permalink: /2013/11/08/squirrel-stack-tracking/
categories:
  - Qk
  - Squirrel
---
Squirrel native dev lives and dies by the stack, so here are some notes on the effect each function has on the stack.

NOTE: SQUserPointer&#8217;s are noted as void*&#8217;s (since that&#8217;s what they really are).

[<img src="/wp-content/uploads/2013/11/SquirrelStack1-640x206.png" alt="SquirrelStack" width="640" height="206" class="aligncenter size-large wp-image-6421" srcset="http://blog.toonormal.com/wp-content/uploads/2013/11/SquirrelStack1-640x206.png 640w, http://blog.toonormal.com/wp-content/uploads/2013/11/SquirrelStack1-450x145.png 450w, http://blog.toonormal.com/wp-content/uploads/2013/11/SquirrelStack1.png 1070w" sizes="(max-width: 640px) 100vw, 640px" />](/wp-content/uploads/2013/11/SquirrelStack1.png)

## Virtual Machine

* * *

## Stack 0

<pre class="lang:default decode:true " >vm = sq_open(initial_stack_size) // Init a VM
sq_close(vm)                     // Kill a VM
int = sq_getvmstate(vm)
hresult = sq_suspendvm(vm)       // see notes for usage (must return)
sq_setforeignptr(vm,void*)       // arbitrary data attached to a VM (SQUserPointer)
void* = sq_getforeignptr(vm)
</pre>

## Stack ?? (depends on args: 0, -1, +1, or both)

<pre class="lang:default decode:true " >hresult = sq_wakeupvm(vm,pop_retval,push_retval,raise_error,throw_error)
</pre>

## Stack +1

<pre class="lang:default decode:true " >sq_pushroottable(vm)
sq_pushconsttable(vm)
sq_pushregistrytable(vm)

sq_move(vm1,vm2,idx)                       // vm2 Stack +1
vm2 = sq_newthread(vm1,initial_stack_size) // pushes an actual VM on to the stack
</pre>

## Stack -1

Pops a value and sets it to the value found on the stack.

<pre class="lang:default decode:true " >sq_setroottable(vm)
sq_setconsttable(vm)
</pre>

## Compiler

* * *

## If (successful) Stack +1 else Stack 0

Use sq_gettop(vm) to check if it was a success.

<pre class="lang:default decode:true " >sq_compile(vm,read_func,void*,source_name,raise_errors)
sq_compilebuffer(vm,code*,code_length,source_name,raise_errors)
</pre>

## Stack Operations

* * *

## Stack 0

<pre class="lang:default decode:true " >result = sq_cmp(vm)  // looks at top 2 items on stack (does not pop). result = obj1-obj2
int = sq_gettop(vm)  // reports what index is the top of the stack
</pre>

## Stack +1

<pre class="lang:default decode:true " >sq_push(vm,idx)      // reads idx, and push it on to stack
</pre>

## Stack -1

<pre class="lang:default decode:true " >sq_poptop(vm)        // removes 1 from top
sq_remove(vm,idx)    // removes 1 from the specified index
</pre>

## Stack +N or -N

<pre class="lang:default decode:true " >sq_settop(vm,idx)    // specify the new "top", inserts nulls
</pre>

## Stack -N

<pre class="lang:default decode:true " >sq_pop(vm,count)     // number to remove from top
</pre>

## Object Creation and Handling

* * *

## Stack +1

<pre class="lang:default decode:true " >// Argument 2's are the type of data to use (where applicable). //
sq_pushnull(vm)
sq_pushbool(vm,bool)
sq_pushinteger(vm,int)
sq_pushfloat(vm,float)
sq_pushstring(vm,char*,len)     // Use negative len to have squirrel use strlen.
sq_pushuserpointer(vm,void*)

sq_newarray(vm,sz)              // Push a new array on to the stack of size sz
sq_newtable(vm)                 // Push a new table on to the stack
sq_newtableex(vm,sz)            // Same as above, but pre-allocates a number of slots
void* = sq_newuserdata(vm,sz)   // Push a new UserData of sz bytes, returns UserPointer

sq_tobool(vm,idx)               // convert object at idx to a bool and push
sq_tostring(vm,idx)             // convert object at idx to a string and push

SQR = sq_getbyhandle(vm,idx,member_handle*) // gets value in class at idx, pushes value
SQR = sq_createinstance(vm,idx) // push an instance of class at idx, w/o constructor call

SQObjectType = sq_typeof(v,idx) // pushes the result of _typeof() of object at idx
</pre>

Notably sq\_typeof() also returns values like OT\_FLOAT, but specific info can be retrieved from the stack. **DO NOT FORGET ABOUT THE STACK! POP IF UNUSED!**

## Stack ?? (+1, or optionally 0)

<pre class="lang:default decode:true " >SQR = sq_newclass(vm,has_base)  // If has_base, pop the base-class, and push the new class
</pre>

## Stack -N and +1

<pre class="lang:default decode:true " >SQR = sq_newclosure(vm,func*,num_freevars) // Pops 0+ freevars, pushes function
</pre>

## Stack 0

SQR &#8211; shorthand for SQRESULT (for use with SQ\_SUCCESS() and SQ\_FAILURE()).

<pre class="lang:default decode:true " >SQR = sq_getbool(vm,idx,bool*)
SQR = sq_getinteger(vm,idx,int*)
SQR = sq_getfloat(vm,idx,float*)
SQR = sq_getstring(vm,idx,char**)          // a char*, no need to store char data
SQR = sq_getuserdata(vm,idx,void**,void**) // UserData* and TypeTag* (identifier)
SQR = sq_getuserpointer(vm,idx,void**)     // just an SQUserPointer

// String, Array, Table, Class (UD), Instance (UD), UserData (UD)
int = sq_getsize(vm,idx)                   // returns the size of type, UserData, or -1

SQR = sq_setclassudsize(vm,idx,sz)         // Sets class at idx UserData size and UserPointer to it
SQR = sq_setinstanceup(vm,idx,void*)       // (alternatively) Set UserPointer directly
SQR = sq_setnativeclosurename(vm,idx,char*) // Set debugger name of a native function
SQR = sq_setparamscheck(vm,nparamscheck,char*) // Compiler/debugger helper (read me)
sq_setreleasehook(vm,idx,function*)        // Set a function to call on UserData/class delete
SQR = sq_settypetag(vm,idx,void*)          // Set a UserData/class's TypeTag (identifier)

char* = sq_getscratchpad(vm,minimum_sz)    // temp memory, valid until next scratchpad call
SQHash = sq_gethash(vm,idx)                // Gets hash-key of the object (at idx)
</pre>

## Stack -1 then +1 (effectively 0)

<pre class="lang:default decode:true " >SQR = sq_bindenv(vm,idx) // pop object, clone function at idx, set THIS to object, push function
</pre>

## Stack -1

Member names are actual members of classes. For example, &#8220;x&#8221; in a vec2 class. sq\_setbyhandle and sq\_getbyhandle are used to read/write data to class members referenced by the Member Handle. Complicated yes.

<pre class="lang:default decode:true " >SQR = sq_getmemberhandle(vm,idx,member_handle*) // pop member name, gets handle to class at idx
SQR = sq_setbyhandle(vm,idx,member_handle*) // pops value, stores it in class at idx
</pre>

## Calls

* * *

## Stack ?? (-N arguments, 0 or +1 returns)

<pre class="lang:default decode:true " >// param_count is +1 actual arguments including THIS
// push_retval says a return value will be on the stack
SQR = sq_call(vm,param_count,push_retval,raise_errors)
// Pops all arguments, but leaves function on the stack
// some wackyness if you use sq_suspend (read me)
</pre>

## Stack 0

<pre class="lang:default decode:true " >sq_reseterror(vm)                    // Clear last error
SQR = sq_throwerror(vm,char*)        // Set last error, and more... (read me)
</pre>

## Stack +1

<pre class="lang:default decode:true " >SQR = sq_getcallee(vm)               // pushes currently running function
SQR = sq_getlasterror(vm)            // pushes last error

char* = sq_getlocal(vm,level,nseq)   // (read me)
</pre>

## Stack 0 or +1

<pre class="lang:default decode:true " >SQR = sq_resume(vm,push_retval,raise_error) // generator stuff (read me)
</pre>

## Stack -1

<pre class="lang:default decode:true " >SQR = sq_throwobject(vm)             // Pops an object and throws it
</pre>

## Object Manipulation

* * *

## Stack -1

<pre class="lang:default decode:true " >SQR = sq_arrayappend(vm,idx)      // Pops a value, appends it to array (at idx)
SQR = sq_arrayinsert(vm,idx,pos)  // Pops a value, inserts it in array (at idx) at pos

SQR = sq_setdelegate(vm,idx)      // Pops a table, and sets it as the delegate of obj (at idx)

SQR = sq_setfreevariable(vm,idx,fv_idx) // Pops value, sets free variable at offset fv_idx
</pre>

## Stack -2

<pre class="lang:default decode:true " >SQR = sq_createslot(vm,idx)       // Pops a key and value, assigns to table/class.
SQR = sq_newslot(vm,idx,static)   // Pops key, value, calls _newslot on table/class (at idx)

SQR = sq_set(vm,idx)              // Pops key and value, calls _set on Table/Class/UserData
SQR = sq_rawset(vm,idx)           // Same as above, but doesn't call _set. Table/Class.

SQR = sq_setattributes(vm,idx)    // Pops key and value, sets the attribute of key (read me)
</pre>

TODO: Push value first, then key?

## Stack -3

<pre class="lang:default decode:true " >SQR = sq_newmember(vm,idx,static) // Pops key, value, attribute, calls _newslot on class (at idx)
SQR = sq_rawnewmember(vm,idx,static) // Same as above, but doesn't call _newslot.
</pre>

TODO: Push value first, then key?

## Stack ?? (-1 or 0 if return)

<pre class="lang:default decode:true " >SQR = sq_deleteslot(vm,idx,push_deleted) // Pops a key, deletes from table, optionally push value
SQR = sq_rawdeleteslot(vm,idx,push_deleted) // same as above, but doesn't call _delslot.
</pre>

## Stack ??

<pre class="lang:default decode:true " >SQR = sq_next(vm,idx)             // For iterating arrays, classes, tables (read me)
</pre>

## Stack -1 then +1 (effectively 0)

<pre class="lang:default decode:true " >SQR = sq_get(vm,idx)              // Pops a key, calls _get on Object at idx, pushes result
SQR = sq_getattributes(vm,idx)    // Pops a key, gets attribute, pushes value
SQR = sq_rawget(vm,idx)           // Same as sq_get, but doesn't use _get. Tables/Arrays.
</pre>

## Stack 0

<pre class="lang:default decode:true " >SQR = sq_arraypop(vm,idx)         // NOT STACK! Pops a value from back of array (at idx).
SQR = sq_arrayremove(vm,idx,pos)  // Removes a value from an array (at idx)
SQR = sq_arrayresize(vm,idx,sz)   // Resize an array (at idx). Inserts nulls.
SQR = sq_arrayreverse(vm,idx)     // Reverses order of elements in an array (at idx)
SQR = sq_clear(vm,idx)            // Removes all objects from a Table or Array (at idx)

SQR = sq_getclosureinfo(vm,idx,params_count*,freevar_count*) // Gets function info
char* = sq_getfreevariable(vm,idx,fv_idx) // Returns name of freevar, null ptr, or "@NATIVE"
bool = sq_instanceof(vm)          // Returns true if -2 is an instance of -1.
</pre>

## Stack +1

<pre class="lang:default decode:true " >SQR = sq_clone(vm,idx)            // Clones an object and pushes it.
SQR = sq_getclass(vm,idx)         // Pushes the class of "class instance" at idx.
SQR = sq_getdelegate(v,idx)       // Pushes the delegate of table (at idx)
SQR = sq_getweakrefval(vm,idx)    // Pushes the value of a weakval (at idx). like ref()
sq_weakref(vm,idx)                // Pushes a weakref to the object (at idx).
</pre>

## Raw Object Handling

* * *

## Stack 0

<pre class="lang:default decode:true " >sq_addref(vm,obj*)                  // add a reference to Object
was_released = sq_release(vm,obj)   // remove a reference from Object, true if last

sq_resetobject(vm,obj*)             // Init an Object

SQR = sq_getstackobj(vm,idx,obj*)   // Get Object from Stack //

SQR = sq_getobjtypetag(obj*,void**) // Get TypeTag from Object
int = sq_getrefcount(obj*)          // How many references.
bool = sq_objtobool(obj*)           // get bool value (or false if not bool)
float = sq_objtofloat(obj*)         // get float value (or int as float, or 0)
int = sq_objtointeger(obj*)         // get int value (or float as int, or 0)
char* = sq_objtostring(obj*)        // get string (or null pointer)
void* = sq_objtouserpointer(obj*)   // get UserPointer (or null pointer)
</pre>

## Stack +1

<pre class="lang:default decode:true " >sq_pushobject(vm,obj)                 // push an Object on to the stack
</pre>