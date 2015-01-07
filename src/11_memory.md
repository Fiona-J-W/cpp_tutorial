Memory
======

In this chapter we will take a first look into the memory-model
of C++. It should be noted beforehand that while these things are
often very useful in order to understand the behavior or
design-decissions of the language, things like naked pointers are
usually **not** language-features that should be used in regular
code.

It should also be noted, that the compiler is usually very good
in making highlevel-code fast, so using these things won't make
your code faster. In fact the chances are good, that using the
stdlib-facilities will usually be faster due to more optimization
there.

Finally, these things are dangerous. In this chapter we will come
around undefined behavior more often then in any other chapter so
far (only multithreading will rival us in that regard). The
things here are like the nuclear weapons of C++ and you should
treat them with the proper respect.

What is memory?
---------------


