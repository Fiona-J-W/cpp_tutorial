More Basics
===========

In the last chapter we learned about some  of the most important basics,
that we absolutely need to use C++; many of them apply with little changes to other
languages. This chapter now intends to deepen this knowledge and add some information
that are more specific to C++ and provide more structure.

Most of what is covered here is the kind of knowledge that we should have
heard about at some point, but that we don't need to worry too much about
once we pass on.


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

The final integer-types that we need for now are those to
work with containers: `std::size_t` and `std::ptrdiff_t`,
where the first one is what we need most often.

`std::size_t` is an unsigned integer that is guaranteed to
be able to index any value in an array and is *not*
necessarily the same as `unsigned int`. In fact, on
most modern system it won't be.

`std::ptrdiff_t` is basically the signed version of `std::size_t`
it's mostly needed to represent the distance between two
values in containers (distances can be negative if the first
element comes after the second). Aside from that there aren't
a lot of situations where we would reach for it.

Now, for one of those parts where c++ really shows it's age
and it becomes obvious why many consider it to be a complicated
language:

What is the result-type if an operation involves two
integers of types $I_1$ and $I_2$? The sad answer is that
this is ridicoulusly complicated, hard to predict and
strongly depends on the plattform. The best thing here really
is to make no assumptions and be very explicit for any mixed
types and hope the best for expressions where $I_1 = I_2$.

Two provide two examples of just how retarded the situation is:

1. The common type of `unsigned int` and `signed long` may well be
   `unsigned int` (though admittedly only on plattforms where
   the size of `int` and `long` are the same).
2. The common type of `std::uint8_t` and `std::int8_t` is
   `std::int32_t` on most plattforms (that is because all
   types that are smaller than `int` are promoted
   to `int` before there values are used and `int` is
   often 32 bits wide.

One very important implication of this mess is that you should
never compare signed and unsigned integers:

```cpp
if (-1 > 1u) {std::cout << "-1 is greater than 1\n";}
```

This print statement will be executed, because it will be promoted
to `unsigned int` where it will represent the largest possible value.
Again: **Never** compare signed and unsigned values directly.

Now that we swallowed this, for the good news: While there are still a
handfull of other places where C++ behaves very strange, we won't
see anything that is really worse than integer-conversions, so basically
it can only get better from here on.

To sum this section up, let's sum up what integers we actually need,
and when we need them:

---------------------------------------------------------------------------------------
Type              When to use
----------------- ---------------------------------------------------------------------
`std::size_t`     As index for containers like `std::vector` (`vec[i]`)

`std::ptr_diff_t` To safe the distance between two elements in a container

`int`             To safe a signed number of average size that is not an index

`unsigned`        To safe a non-negative number of average size that is not an index

`std::uintXX_t`   Mostly needed when a certain size is strictly required or for
`std::intXX_t`    optimisations; this is a surprisingly rare thing
---------------------------------------------------------------------------------------

Floatingpoint Numbers
---------------------

Since we have now seen C++'s integers and learned a bit about
why they are weird, we can now take a relaxing look at the way easier floats.

Or we could if they were easy, but sadly they too are surprisingly
complex. In this case it isn't C++'s fault however: The problems we
will talk about now are basically inherent properties of floating-point precission,
the standard that describes what most implementations do and the sometimes weird
behavior of x86/x64-CPUs.

Let's start with the easy part: C++ offers three floatingpoint-types:

* `float`
* `double`
* `long double`

The default one is `double` and unless you have good reasons to do
something else, you should probably use that.


Now, what is a floating-point number? Basically it is similar to
what is also known as scientific notation for numbers: Instead of
“$123.45$” we can also write “$1.2345 \cdot 10^3$”. The advantages
of that approach is that we can easily keep the relative differences
between numbers small no matter whether they are very big or very small.
While the absolute difference between $1.23\cdot10^{-23}$ and $3.5\cdot12^{-23}$
is much smaller than the difference between $10000000000$ and $10000001234$,
we will probably care much more about it, because the second number is
actually twice as big as opposed to a difference of less than one part in
a million.

Furthermore it gets much easier to save very large and very small numbers
that way: We can easily write down a number with a hundred digits or
a number with a hundred zeros between the decimal-point and the first
non-zero number: $10^{100}$ and $10^{-100}$.

Floating point numbers as the ones used in C++ basically do it like that, except
that they don't work by saving decimal but binary numbers. We don't have to
know about the details here though, since at the end of the day most things
just work.

Except when they don't: The problems that we face here are with the finite precission
of computers and the fact that they have to do rounding. Furthermore some numbers
cannot be represented exactly, so for instance the check whether `0.1 * 10.0 == 1.0`
may return false in C++.

It is important to note that this is not a problem of C++, but of basically every
programming-language that supports some kind of non-integer-numbers.

Now, how do we tackle those problems? Well, the usual workaround is to never
compare such numbers directly but always to use an „epsilon“ which is a small number
that we will accept as error. An example probably shows it best:

```cpp
#include <iostream>

int main() {
	auto size_1 = double{}:
	auto size_2 = double{};
	std::cout << "Please enter two sizes: ";
	std::cin >> size_1 >> size_2;
	if (size_1 + 0.00001 < size_2) {
		std::cout << "The first size is smaller.\n";
	} else if (size_2 + 0.00001 < size_1) {
		std::cout << "The first size is larger.\n";
	} else {
		std::cout << "Both sizes are about the same\n";
	}
}
```

As a general rule of thumb: If you can reasonably avoid floating-point, avoid it.
This doesn't say that you should never use it (in fact you should sometimes),
but that you will probably have an easier time with integers.

`auto`
----


So far we have created all our variables like this:

```cpp
	auto var = some_value;
```

This style is also known as „Almost Allways Auto“ and is recommended
by Herb Sutter (a very famous C++-guru and head of the standards-committee).

Technically it says „Create a variable named var with the value ‘`some_value`’ and the
type of ‘`some_value`’“. Since another style is also **very** common and in a small number
of cases still needed it should be mentioned here too:

```cpp
	double var1 = 0;
	int var2 = 23;
	std::string foo;

	double var2; // DON'T DO THIS
```


