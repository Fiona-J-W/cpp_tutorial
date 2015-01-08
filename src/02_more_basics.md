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
  size of `int` to eight byte, making it a realistic problem that there may be strings or
  vectors with elements that **cannot** be adressed with `int` **at all**.
* `int`s can be negative, but can get super-problematic if negative values don't make any
  sense (indexes into vectors for example).

Since these problems are not recent discoveries, C++ has answers to all of them. Some of those
are however imperfect too or have similar problems, which is why we won't cover the topic of
integer-types completely for now, but will just take a large enough look at it, to equip ourselves
with the subset that is actually usefull.

First we will take a look at integers of different width: Sometimes using 4 bytes for a number would
be a complete waste of spaces; sometimes 4 bytes are not nearly enough to store all numbers that we
might come across. To accomodate for those needs C++ also has the integer-types `short`, `long`
and `long long`; additionally `char` may is used as integer as well. Since their size is however
non standardized as well, we won't use those directly. Instead the header `<cstdint>` provides
us with aliases that finally give us what we want:

```cpp
#include <cstdint>

int main() {
	auto one_byte_integer   = std::int8_t{};  // value: 0
	auto two_byte_integer   = std::int16_t{23};
	auto four_byte_integer  = std::int32_t{42};
	auto eight_byte_integer = std::int64_t{-5};
}
```

Note that we have to state the type at the right side of the
initializations, otherwise the default (`int`) would be used
which is not what we want here.

This solves problem number one. The second problem is that we
all of those integer-types can store negative values, which
sometimes wouldn't make any sense. If we want to know for sure
that this is not the case, we can use the unsigned-family: All
the core-language-types can be prefixed with `unsigned` to
annotate that they won't store negative numbers. Instead they
may store somewhat bigger positive numbers (the maximum of the
signed version times two plus one). Be aware that this brings
some problems with it: If you subtract one from zero, the
the numbers will wrap around and result in the biggest possible
value of that type (unlike for signed integers, this is
guaranteed by the standard instead of undefined behavior).

Let's take a look at code:

```cpp
int main() {
	// unsigned without further type means unsigned int:
	auto u1 = unsigned{}; // value: 0
	
	// alternatively we may add a u after a numer
	// to make it to an unsigned int:
	auto u2 = 42u;
	
	// if we want to state the complete type we have
	// to use parenthesis because it consists of two
	// words:
	auto u3 = (unsigned int){}; // 0

	// Just for demonstration how you can use the
	// other unsigned integers:
	auto u2 = (unsigned short){23};
	auto u3 = (unsigned long){1234567890};
}
```

Obviously the parenthesis are ugly and we are back at the
problem of the unspecified sizes. The answer is the same that
we already got for the signed integers: “Use the
`<cstdint>`-header!”

The unsigned integers follow the same naming-scheme that
signed ones do, except for an added ‘u’ in front of the name:


```cpp
#include <cstdint>

int main() {
	auto one_byte_integer   = std::uint8_t{};  // value: 0
	auto two_byte_integer   = std::uint16_t{23};
	auto four_byte_integer  = std::uint32_t{42};
	auto eight_byte_integer = std::uint64_t{5};
}
```

It should be mentioned for completeness, that there is also
a `signed`-keyword which may be used instead of the
`unsigned`-keyword and has the obvious meaning. Since most
integer types are however guaranteed to be signed from the
start, it doesn't have any effect at all most of the time. The
one exception to that rule is `char`:

Unlike all other integer-types, `char` and `signed char` are
not different names for the same type, but different types.
In fact it is not guaranteed that `char` is signed (it will
most likely be on your plattform, but there are definitely
others for which this is not the case). Basically this is
just another reason to use `std::int8_t` and `std::uint8_t`
if you need integers that are one byte wide and only use
`char` if you want a character.

TODO: size_t, warnings about signed/unsigned-conversions and integer-promotions

`auto`
----




