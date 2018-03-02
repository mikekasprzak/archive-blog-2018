---
id: 4959
title: Ludum Dare Prototyping
date: 2011-12-22T20:33:35+00:00
author: Mike K
layout: post
guid: http://www.toonormal.com/?p=4959
permalink: /2011/12/22/ludum-dare-prototyping/
categories:
  - Alone, The
  - Ludumdare
  - The Demake
---
I wont talk too much about how Ludum Dare itself went, as I&#8217;ve already done that [over here](http://www.ludumdare.com/compo/2011/12/19/ludum-dare-22-has-ended-891-entries-juding-begins/).

But in addition to running the event, I participated for the first time in a long time. The theme was &#8220;**Alone**&#8220;, which I find funny given [the title of my game](http://www.alonethe.com). Could I not enter? 😉

About a week before Ludum Dare, I started toying with the idea of creating a demake of my game. I didn&#8217;t put too much thought in to it at the time, but it seemed like a good idea and a change of pace. Oh, and I decided to do it in JavaScript using an HTML5 Canvas 2D. Again, a change of pace.

What I didn&#8217;t realize though is that it was a **GREAT** idea.

The past few months I&#8217;ve been spending majority of my time building the tech I need for the game, but not spending so much time on the gameplay, the mechanics, and so on. So I have a bunch of pieces working together, but not much game. 

So once the Ludum Dare theme is announced, I ran with the demake idea, and about 3 days later I have something _far more fun and interesting_ than I had before&#8230; Written from scratch, in JavaScript.

<div id="attachment_4960" style="max-width: 650px" class="wp-caption aligncenter">
  <a href="/wp-content/uploads/2011/12/Shot09.png"><img src="/wp-content/uploads/2011/12/Shot09-640x366.png" alt="" title="Shot09" width="640" height="366" class="size-large wp-image-4960" srcset="http://blog.toonormal.com/wp-content/uploads/2011/12/Shot09-640x366.png 640w, http://blog.toonormal.com/wp-content/uploads/2011/12/Shot09-450x257.png 450w, http://blog.toonormal.com/wp-content/uploads/2011/12/Shot09.png 1047w" sizes="(max-width: 640px) 100vw, 640px" /></a>
  
  <p class="wp-caption-text">
    Fighting some Bats
  </p>
</div>

It&#8217;s short and not a deep game, but it is a functional prototype that demonstrates some ideas and goals of the design. That&#8217;s what prototypes are for: trying out ideas.

You can try it here: <http://www.alonethe.com/prototype/>

&#8211; Best played in Firefox, in Full Screen (F11).
  
&#8211; F5 to reload (WHEN you die, MUAHAHA!)
  
&#8211; If using Flash Block or NoScript, **enable Flash**. It needs Flash Player 9+ for Sound.
  
&#8211; Arrow Keys, Mouse, or Touch Screen.
  
&#8211; Works on all current Browsers. Some may lack sound.
  
&#8211; Works on **all** current **Mobile Browsers** too! Best in Firefox Mobile (w/o Sound).

I wont say anymore. If you&#8217;re up for something quick, give it a try. Let me know how your first play-through went, how well you were able to do, and perhaps how many deaths it took. 😉

I actually **did not** finish the game within the 48/72 hours of Ludum Dare, but just a few hours later than that. It was a mostly good event without too many website problems, but right at the end the **ENTIRE INTERNET** decided to link us and considered us newsworthy! We were a headline news story on IGN PC nearly all day. Sure, the story was about [Notch](http://notch.tumblr.com) and the game he made during Ludum Dare, but still. Holy cow! IGN, Kokaku, Joystiq, Rock Paper Shotgun, Destructoid, The Escapist, Edge, PC World, BBC, Wired, Venture Beat, The Verge and Geek to name just a few. 🙂

So, I had a pretty good excuse for being late. 😀

Creating the demake has been an incredibly beneficial to the design. For one, I have something playable right now that can be critiqued. There&#8217;s going to be a lot of iteration and improvements, before it becomes a shippable product. And I honestly cannot complain about it taking only 3 days to get it working. That is fast. I am seriously, almost committed now to finishing this HTML5 incarnation of the game, and releasing it as a sort of prequel. That way I can step entirely through the design, start to finish, and have a better well-tested core design for the one I want to charge money for.

Admittedly, I&#8217;ve been avoiding prototyping and experimenting in languages that aren&#8217;t C++. I was never comfortable with the idea of writing code that \*must\* be thrown away, due to syntactical differences. I have, on a few occasions, wanted to write a sort-of language converter; Write code in some general dialect, and export to the variants. I briefly looked in to haXe, but really didn&#8217;t like how fat the C/C++ generation was. Nothing ever came of that desire though.

JavaScript I rationalized by the rather safe assumption that &#8220;JavaScript will never die&#8221;. I certainly don&#8217;t plan to stop using the Internet any time soon, and HTML+JavaScript are pretty much _all internet_. So learn to love it, and you&#8217;re better off.

And actually, I do quite like the language. Unlike Java, it does not force OOP style designs. You can OOP, but you don&#8217;t have to. It feels more like a really wacky version of C, with super flexible macros, than it does Java. Structure can start hacky, dirty, or essentially functional, and over time it can be cleaned up. It&#8217;s nice.

The future of Flash is a bit uncertain, though it sounds like Adobe will be making it more of a general 3D gaming VM, to solve the whole WebGL problem on the desktop (i.e. Microsoft&#8217;s Arrogant Pride X). And that&#8217;s cool. That sounds useful to my native codebase. But I&#8217;m left concerned about where that leaves a large codebase built over the next few years. It may do sound, but it&#8217;s still not going to run on iPad. So Mike, [Mr Portable Code](http://www.smileshd.com), has decided JavaScript should be his #2. Prototyping, game jams, and since _it&#8217;s the whole internet_, we can accept it.

What&#8217;s also nice about JavaScript is its similarity to [Squirrel](http://www.squirrel-lang.org). Sure, JavaScript/EcmaScript is the old man, the daddy, the parent of the relationship, but after much homework Squirrel is what I chose for my embedded scripting in the new game. It has distinct floating point and integer types, among other things. In general it&#8217;s designed as a Lua alternative, embedded scripting, conscious of the things us game developers care about (memory usage. GC is optional). And hey, best part, it counts from **zero** instead of one, unlike Lua. It&#8217;s been a while since I dabbled with it, and honestly I haven&#8217;t done much with it. But after a review of it this morning, I&#8217;m actually quite pleased to see much, if not all of the syntactical features I got comfortable using in JavaScript are available in Squirrel. Heck, it looks like I&#8217;ll be able to bring over some of the code as is; Rename a few &#8220;var&#8217;s&#8221; to &#8220;local&#8217;s&#8221;, a few other minor tweaks, and that&#8217;s it. 

Very encouraging.

So that&#8217;s my little rambling. I&#8217;m still shooting to meet my &#8220;Learn more GDC time&#8221; goal, which means March, which means ~2 months from now. What exactly I&#8217;ll have for then is a little different than I had hoped originally, but just as good. Back to work! Lets see what I can finish before the end of 2011. Go go me!