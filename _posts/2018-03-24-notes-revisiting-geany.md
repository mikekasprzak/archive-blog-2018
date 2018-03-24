---
title: 'Notes: Revisiting Geany'
layout: post
date: '2018-03-24 10:58:49'
---

It's been a while (at least 4 years) since I considered using **Geany** as my text editor.

[https://github.com/geany/geany](https://github.com/geany/geany)

Unfortunately for me I'm rather stuck in my ways, trusting **UltraEdit** to my editing needs for over **20 years**. It's where I've felt most comfortable and home. Double unfortunately, the Linux version of **UltraEdit** is buggy at times, and limited in what its syntax highlighting can do. Modern languages with sub-languages like JavaScript+JSX are not supported. This means any time you decide to use text like `it's my way` inside , the `'` suddenly breaks all text that follows. Not to mention JavaScript now supports 3 ways to define strings (`'`, `"`, ``` ` ```), but **UltraEdit** has a limit of 2.

# Geany from Source
Interestingly, **Geany** is written in **C**, not C++.

Source is here: [https://github.com/geany/geany/tree/master/src](https://github.com/geany/geany/tree/master/src)

For the most part, an easy to follow flat tree with everything.

It uses **GTK+** for windowing (C), and a library called **Scintilla** for the actual editor (C++)? What? They mix C and C++? Huh.

### Installing
Pretty standard.

```bash
# checkout and/or fork it
./autogen.sh
./configure --disable-html-docs
make

sudo make install
```

# Themes
Out of the box, the theme choices for Geany are... lacking. Better themes can be found here:

[https://github.com/geany/geany-themes/](https://github.com/geany/geany-themes/)

To install them easily, do the following.

```bash
cd ~/.config/geany/
git clone https://github.com/geany/geany-themes.git
rmdir colorschemes
ln -s geany-themes/colorschemes colorschemes
```

Now the themes will be immediately avaliable. I'm currently using `Kudgel`.