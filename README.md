
Top-Down C++-Tutorial
=====================

This project tries to create a top-down tutorial for the C++-programming language.

The Problem
-----------

There are countless tutorials for C++ available but the general concensus seems to be that every single
one falls into on at least one of these two categories:

* They are just bad. They teach the language by starting from a ridiculosly low level that no competent
  person would ever use to write programs in unless absolutely necessary. Basically every known
  web-tutorial falls into this category.
* The are not freely available. Some of them are said to be of very high quality, but they are
  basically of no use for all those who don't have the money for them.

On another note books also have the problem that they are rarely open-content which makes it impossible
to update them to later versions of the language if the author decides not to do so.

And last but not least: Ink on dead trees rarely gets updated at all.

The Solution
------------

A while ago some people from [cppref] started a [new project][cppref-book] to create a better
tutorial. When I heard of this I decided to participate and suggested a structure that emphasized very
strongly to use a top-down approach to avoid the problems that every other online-tutorial known to me
has.

Sadly this project lost most of it's momentum after a relatively short while. At some point I decided
that it might be the best to take what I had already written, convert it to markdown and move it to
github in the hope to solve the following problems by this:

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
  licensed under the [Creative-Commons-license Attribution-ShareAlike 4.0 International][CC-BY-SA]
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

* I am German and English is not a native language for me. I will happily accept any pull-request that
  fixes spelling or grammar.
* Obviously this project is far from completed and therefore not in a state that would allow it's use
  for practical purposes.
* This tutorial will teach C++14 and later. There is little gain in teaching old and often ugly stuff
  to people who will hopefully be spared from it for a long time.
	* All examples have to compile with the latest version of Clang and GCC though (unless the
	  example is specifically about the feature that isn't implemented).


[cppref]: http://en.cppreference.com/w/Main_Page
[cppref-book]: http://en.cppreference.com/book/Main_Page
[CC-BY-SA]: https://creativecommons.org/licenses/by-sa/4.0/
