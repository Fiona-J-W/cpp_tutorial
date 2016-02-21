
**WARNING: This tutorial is still under development. It must not be used for actual learning at this point.**

Please also note that pandoc's markdown syntax is used to format the tutorial's content (see `src` folder)
and GitHub may display some aspects of it not quite right. Instead of viewing it at Github, have a look at
the [official website](http://cpp.florianjw.de/). It is ad-free, works without JavaScript, and the only
kind of tracking it does is keeping the webserver's `access.log`.

HTTPS is also supported but only signed by CAcert which will likely make your browser produce a warning
about an insecure connection because it's authors are utterly incompetent when it comes to understanding
the security-implications of their decission to consider an unencrypted side much more secure than an
encrypted one.

Once a usable state will be achieved, I will however look into getting a certificate from [Let's
Encrypt](https://letsencrypt.org/) which is considered as much more secure for pretty much no good reason
whatsoever. 


Top-Down C++ Tutorial
=====================

This project aims to create a top-down tutorial for the C++ programming language.


The Problem
-----------

There are countless C++ tutorials available but every single one of them seems to have at least one of the
following shortcomings:

* They are just bad.  
They teach the language by starting from a ridiculosly low level that no competent person would ever use to
write programs in, unless absolutely necessary. Basically every known web-tutorial falls into this category.
* They are not freely available.  
Some of them are said to be of very high quality, but they are of no use for all those who don't have the
money to buy them.

On another note, books also have the problem that they are rarely open-content. This makes it impossible to
update them to new versions of the language, if the author decides not to do so.

And last but not least: Ink on dead trees rarely gets updated at all.


The Solution
------------

A while ago some people from [cppref] started a [new project][cppref-book] to create a better
tutorial. When I heard of this, I decided to participate and suggested a structure that emphasized very
strongly to use a top-down approach to avoid the problems that every other online-tutorial known to me
has.

Sadly this project lost most of it's momentum after a relatively short while. At some point I decided
that it might be the best to take what I had already written, convert it to markdown and move it to
github in the hope to solve the following problems:

* Getting rid of the mediawiki-syntax in favor over pandoc-markdown. Among other things this makes
  targeting multiple plattforms (ebook, web-page, …) trivial.
* Writing in the browser with a suboptimal text-editor and being dependent on the availability of
  internet-access.
* Indentation with four spaces and opening braces on their own line ;-)

While I hope that this might result in at least me writing more again, I don't want this move to be
understood as criticism of the original project: I changed the working-environment and the tooling
but I would stil like to see the endresult (among other places) on the page that started it all.


The Concept
-----------

* This tutorial will be free as in “free beer”.
* It will also be free as in “free speech”. To ensure that this stays that way, it will be
  licensed under the [Creative-Commons-license Attribution-ShareAlike 4.0 International][CC-BY-SA].
* The general approach to every topic will be to introduce a realistic [or as realistic as we can get]
  problem that cannot be reasonably solved with the current techniques. This will then be used to show
  how the new technique works **and why it is usefull** (the later part is left out way to often).
* Contributions are very wellcome, but keep in mind, that:
	* This is a tutorial, not a language-reference. Emphasize the parts that are of
	  practical use and ignore stuff that you would only mention for completeness
	* This tutorial starts out on a high abstraction-level on purpose. There is no point
	  in teaching people details about machine-instructions before they have gained at least
	  some practical experience.


Other Notes
-----------

* I am German and English is not my native language. I will appreciate any pull request that
  fixes spelling or grammar.
* Obviously this project is far from complete and should therefore not be used for actual learning.
* This tutorial will teach C++14 and later versions. There is little benefit in teaching old and often
  times ugly stuff to people who will hopefully be spared from it for a long time.
	* However, all examples are written so they can be compiled with the latest versions of Clang and GCC.
	  In case an example is specifically about a feature not implemented in either of both, this will be noted.


[cppref]: http://en.cppreference.com/w/Main_Page
[cppref-book]: http://en.cppreference.com/book/Main_Page
[CC-BY-SA]: https://creativecommons.org/licenses/by-sa/4.0/
