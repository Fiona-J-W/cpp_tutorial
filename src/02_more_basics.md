More Basics
===========

In the last chapter we learned about some  of the most important basics,
that we absolutely need to use C++; many of them apply with little changes to other
languages. This chapter now intends to deepen this knowledge and add some information
that are more specific to C++ and provide more structure.


Integers
--------

So far we know `int`; it is an integer-type that is usually 4 bytes wide and can therefore
hold values between about minus and plus two billion. Historically `int` has been considered
a reasonable default-choice for integers. It did however have some problems from day one on:

* While `int` is **usually** four bytes wide, this is totaly plattform-dependent, making it
  a bad idea to use `int` for truly plattform-indipendent code.
* When 64-Bit computers became popular, compiler-vendors decided agains increasing the
  size of `int` to eight byte, making it a realistic problem that there may be strings of
  vectors with elements that **cannot** be adressed with `int` **at all**.
* `int`s can be negative, but can get super-problematic if negative values don't make any
  sense (indexes into vectors for example).


`auto`
----




