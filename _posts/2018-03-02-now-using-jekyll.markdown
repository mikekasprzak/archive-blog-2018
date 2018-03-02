---
title: Now running Jekyll
layout: post
date: '2018-03-02 13:28:06 -0500'
categories: jekyll update
---

Okay! I've migrated my blog to Jekyll (and GitHub).

I followed this tutorial: https://girliemac.com/blog/2013/12/27/wordpress-to-jekyll/

Notably since I ran a very old WordPress blog, I had to manually copy over all the images and things NOT found in the `/wp-content/` folder. This has made my tree a bit less organized (`/content/`, `/wp-includes/`) but at least it's all there.

Repo is here: https://github.com/mikekasprzak/blog

(not that anyone other than me cares)

## Other Setup issues

The default layout Jekyll doesn't show any post content, just a list of posts. This required some tweaking of the scripts.

Jekyll themes are implicit. If a file exists in your layout, your version is used instead. Files use liquid syntax: https://gist.github.com/smutnyleszek/9803727

I'm using the `minima` theme as my base: https://github.com/jekyll/minima

Doing a `gem install minima` installs the theme in `/var/lib/gems/2.3.0/gems/minima-2.3.0/`.


This post here suggested how to show the first post, but neglected the actual render code: https://stackoverflow.com/questions/17890493/how-can-i-show-just-the-most-recent-post-on-my-home-page-with-jekyll

This Gist included the correct code: https://gist.github.com/nimbupani/1421828

Notably you can only include files in the `_includes` folder, so you can't just use the default article renderer without moving it.

The problem with the above code is markdown is disabled. This thread lists solutions: https://github.com/jekyll/jekyll-archives/issues/28

The one I used is `content | markdownify`.

## In closing

Below is the default **Welcome** text, just as a reminder.

## Welcome to Jekyll!

You’ll find this post in your `_posts` directory. Go ahead and edit it and re-build the site to see your changes. You can rebuild the site in many different ways, but the most common way is to run `jekyll serve`, which launches a web server and auto-regenerates your site when a file is updated.

To add new posts, simply add a file in the `_posts` directory that follows the convention `YYYY-MM-DD-name-of-post.ext` and includes the necessary front matter. Take a look at the source for this post to get an idea about how it works.

Jekyll also offers powerful support for code snippets:

{% highlight ruby %}
def print_hi(name)
  puts "Hi, #{name}"
end
print_hi('Tom')
#=> prints 'Hi, Tom' to STDOUT.
{% endhighlight %}

Check out the [Jekyll docs][jekyll-docs] for more info on how to get the most out of Jekyll. File all bugs/feature requests at [Jekyll’s GitHub repo][jekyll-gh]. If you have questions, you can ask them on [Jekyll Talk][jekyll-talk].

[jekyll-docs]: https://jekyllrb.com/docs/home
[jekyll-gh]:   https://github.com/jekyll/jekyll
[jekyll-talk]: https://talk.jekyllrb.com/