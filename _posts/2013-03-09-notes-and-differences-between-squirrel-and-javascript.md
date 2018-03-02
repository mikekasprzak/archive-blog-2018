---
id: 5867
title: Notes and Differences between Squirrel and JavaScript
date: 2013-03-09T01:30:13+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=5867
permalink: /2013/03/09/notes-and-differences-between-squirrel-and-javascript/
categories:
  - Squirrel
  - Technobabble
---
Here are my notes on [Squirrel](http://www.squirrel-lang.org) and JavaScript.

  * **JS**: Number, String, Array, Object (Table), Function, Null (object named null), Undefined
  * **SQ**: Integer, Float, String, Array, Table (Object), Function, Null (null), Class, ClassInstance, Generator, Thread, Weak Reference, UserData, UserPointer
  * **JS**: false, undefined, null, 0, NaN, &#8220;&#8221; **SQ**: false, null, 0, 0.0 <font color="red">(&#8220;&#8221; untested)</font>
  * **JS**: var MyVariable = Value; /\*Global\*/ **SQ**: MyVariable <- Value; /\*Root Table\*/
  * **JS**: {var MyVariable;} /\* Undefined, Local \*/ **SQ**: {local MyVariable;}
  * **Squirrel has Integers AND Floats!** JavaScript is only Numbers (Doubles).
  * **JS**: <font color="red">Use JQuery or MooTools</font> **SQ**: local MyCopy = clone Original;
  * **SQ**: The .weakref() method of Integers, Floats, Booleans does not return a reference, but instead just returns the values (native). Using it on Tables, Arrays, Strings and Functions **does** return a weak reference.
  * **JS**: alert( typeof(MyString) ) /\* &#8220;String&#8221; \*/ **SQ**: print( typeof MyString ) /\* &#8220;String&#8221; \*/
  * **JS**: var Code = eval(&#8220;/\*code\*/&#8221;); **SQ**: local Code = compilestring(&#8220;/\*code\*/&#8221;);
  * **JS**: console.log(&#8220;Hey&#8221;); **SQ**: error(&#8220;Hey&#8221;);
  * **JS**: [arguments.callee](http://stackoverflow.com/questions/280389/how-do-you-find-out-the-caller-function-in-javascript) <font color="red">(deprecated)</font> **SQ**: print( callee() ); /\*currently running closure\*/
  * **JS**: [<font color="red">complicated</font>](http://www.docsteve.com/DocSteve/Samples/JS/js_version.html) **SQ**: print( \_version\_ + &#8221; (&#8221; + \_versionnumber\_ + &#8220;)&#8221; ); /\* 304 for 3.04 \*/
  * **SQ**: print( &#8220;char: &#8221; + \_charsize\_ + &#8221; int: &#8221; + \_intsize + &#8221; float: &#8221; + \_floatsize_ );
**Strings and Numbers (mostly Strings)**

  * **JS**: var MyString = &#8220;Hello&#8221;; **SQ**: local MyString = &#8220;Hello&#8221;;
  * **JS**: MyString.toString() **SQ**: MyString.tostring()
  * **JS**: var Num=&#8221;5&#8243;; Num = +Num; **SQ**: local Num=&#8221;5&#8243;; Num = Num.tointeger(); **or** Num.tofloat();
  * **JS**: MyString.toLowerCase().toUpperCase(); **SQ**: MyString.tolower().toupper();
  * **JS**: MyString.length; **SQ**: MyString.len()
  * **JS**: MyString.slice( StartPos [, Count] ); **or** substr **or** substring **SQ**: MyString.slice( StartPos [, Count] );
  * **JS**: if ( MyString.indexOf(&#8220;Hey&#8221;[,StartPos]) != -1 ) {} **SQ**: if ( MyString.find(&#8220;Hey&#8221;[,StartPos]) != null ) {}
  * **JS**: if ( MyString.lastIndexOf(&#8220;Hey&#8221;[,StartPos]) != -1 ) {} **SQ**: <font color="red">???</font>
  * **JS**: MyString.search(&#8230;) has no optional StartPos parameter.
  * **JS**: MyString.replace( &#8220;Hello&#8221;, &#8220;Halo&#8221; ); **SQ**: <font color="red">???</font>
  * **JS**: var FirstLetter = MyString[0]; **SQ**: local FirstLetter = MyString[0]
  * **JS**: var Str = &#8220;Hello&#8221; + &#8220;World&#8221;; **SQ**: local Str = &#8220;Hello&#8221; + &#8220;World&#8221;;
  * **JS**: var MyStr = String.fromCharCode(65); /\*A\*/ **SQ**: local MyStr = (65).tochar(); /\*Ints or Floats\*/
  * **SQ**: foreach can be used on strings to iterate over all characters
**Arrays**

  * **JS**: var MyArray = []; **SQ**: local MyArray <- [];
  * **JS**: var MyArray = [1,&#8221;hello&#8221;,3]; **SQ**: local MyArray <- [1,"hello",3];
  * **JS**: var MyArray = Array(10); /\*10 elements\*/ **SQ**: local MyArray = array(10 [,fill]);
  * **JS**: MyArray.push(value); **SQ**: MyArray.push(value) **or** append /\*push_back\*/
  * **JS**: var Value = MyArray.pop(); **SQ**: local Value = MyArray.pop() /\*pop_back\*/
  * **JS**: var Value = MyArray.shift(); **SQ**: local Value = MyArray[0]; MyArray.remove(0); /\*pop_front\*/
  * **JS**: var Val = MyArray[MyArray.length-1]; **SQ**: local Val = MyArray.top() /\*pop_back w/o pop\*/
  * **JS**: MyArray = Array.concat(MyArray,Array2); **SQ**: MyArray.extend( Array2 ) /\*push_back an array\*/
  * **JS**: MyArray.splice(Index,0,Value[,Value2,&#8230;]); **SQ**: MyArray.insert( Index, Value );
  * **JS**: MyArray.splice(Index,1); /\* How Many \*/ **SQ**: MyArray.remove( Index );
  * **JS**: MyArray.length = Size; <font color="red">(unconfirmed) </font>**SQ**: MyArray.resize( Size [,Fill] );
  * **JS**: MyArray.length = 0; <font color="red">(unconfirmed) </font>**SQ**: MyArray.clear();
  * **JS**: MyArray.sort() **SQ**: MyArray.Array.sort( [CompareFunction] );
  * **JS**: MyArray.reverse(); **SQ**: MyArray.reverse();
  * **JS**: var MySlice = MyArray.slice(Start [,End]); **SQ**: local MySlice = MyArray.slice(Start [,End]);
  * **JS**: for(var idx=0;idx<MyArray.length;idx++) { MyFunction(MyArray[idx]) } **SQ**: MyArray.apply( MyFunction );
  * **SQ**: MyArray.reduce( &#8230; ) /\* leave All but one, call function on removed \*/
  * **SQ**: MyArray.filter( ) /\* make new list based on all that match pattern \*/
**Objects (JS) and Tables (SQ)**

  * **JS**: var MyObject = {}; **SQ**: local MyTable = {};
  * **JS**: var MyObject = {}; **SQ**: MyTable <- {};
  * **JS**: var MyObject.Member = Value; **SQ**: MyTable.Member <- Value; /\* Create Only. Can use = after \*/
  * **JS**: delete MyObject.Member; **SQ**: delete MyTable.Member; /\* returns old value \*/
  * **JS**: if ( [(typeof MyTable.Member)](http://stackoverflow.com/questions/4186906/check-if-object-exists-in-javascript) != &#8220;undefined&#8221; ) Has(); **SQ**: if ( &#8220;Member&#8221; in MyTable ) Has();
  * **JS**: alert( MyObject.join() ); /\* output contents to string \*/ **SQ**: <font color="red">???</font> (do a loop)
  * **JS**: [<font color="red">no but you can make a function</font>](http://stackoverflow.com/questions/5223/length-of-javascript-object-ie-associative-array) **SQ**: print( MyTable.len() );
  * **JS**: [<font color="red">nope</font>](http://stackoverflow.com/questions/684575/how-to-quickly-clear-a-javascript-object) **SQ**: MyTable.clear();
  * **SQ**: MyTable.rawget(key) /\* Get w/o delegation \*/
  * **SQ**: MyTable.rawset(key,value) /\* Set w/o delegation. Creates if doesn&#8217;t exist \*/
  * **SQ**: MyTable.rawdelete() /\* Deletes and returns value w/o delegation. null if doesn&#8217;t exist \*/
  * **SQ**: MyTable.rawin(key) /* true if exists (same as **in** operator) w/o delegation */
  * **SQ**: MyTable.setdelegate( MyDelegate ) /\* null clears \*/
  * **SQ**: MyTable.getdelegate() /\* returns delegate, or null if none \*/
**Functions**

  * **JS**: function MyFunc() { } **SQ**: function MyFunc() { }
  * **JS**: function MyFunc(arg1,arg2) { } **SQ**: function MyFunc(arg1,arg2) { }
  * **JS**: var MyFunc = function() { } **SQ**: local MyFunc = function() { }
  * **JS**: <font color="red">none</font> **SQ**: if ( (@(arg1,arg2) arg1 + arg2) > 0 ) {&#8230;}
  * **JS**: MyFunc.call(MyThis [,args,&#8230;]); **SQ**: MyFunc.call(MyThis [,args,&#8230;]);
  * **SQ**: pcall(&#8230;) ignores error callback. acall(&#8230;) takes an array; arg[0] is this. pacall is array pcall.
  * **SQ**: local BoundFunc = MyFunc.bindenv(OtherEnv); /\* replaces .this with OtherEnv (Table) \*/
  * **SQ**: MyFunc.getinfos() returns an object containing information about a function.
TODO: Class Inheritance

  * SQ: if ( MyInstance instanceof MyClass ) {&#8230;}
  * SQ: Metamethods: \_add, \_sub, \_mul, \_div, \_unm, \_modulo, \_set, \_get, \_typeof, \_nexti, \_cmp, \_call, \_delslot, \_tostring, \_newmember, \_inherited
TODO: Generators
  
yield, resume

TODO: Coroutines (i.e. N/A JS, but sort of. TODO C++ Coroutine)

TODO: Try Catch