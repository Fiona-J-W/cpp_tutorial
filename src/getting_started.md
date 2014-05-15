Getting Started
===============

At this point you should have a working compiler and text-editor, so that we can start out with looking
into the fundamental building-blocks of the language. This chapter may not appear to be very
entertaining or of much direct use, but it is very important as everything we will encounter here
is needed to procede to the more interessting topics that will build on top of it.

Hello World
-----------

```cpp
#include <iostream>

int main() {
	std::cout << "Hello World!\n";
}
```
```
>> Hello World!
```

This program prints the text “Hello World!”, followed by a newline to the standard-output. Let's look
at it line by line:

```cpp
#include <iostream>
```

This line tells the compiler to use a “header” with the filename “iostream” when compiling.
A header is basically another C++-file that will be pasted to the place where the include-statement
appears.

The “iostream”-header is part of the standard-library that should be shipped with every compiler and
has therefore be available on every system. “iostream” contains lots of stuff that are related to
reading and writing from and to other ressources like standard-input, standard-output, files and so on.

```cpp
int main() {
```

This defines the main-function. Basically everything from the opening brace will now be executed in the
order it appears until we reach the matching closing brace.

```cpp
std::cout << "Hello World!\n";
```

`std::cout` is a construct from the iostream-header that we included and linked to the standard-output.
Via it we can write a lot of different things by “pushing them into it” with the output-operator “<<”.
In this case we just push a so called string-literal into it. A string-literal is a text surrounded by
two quotes (‘\"’); for the case that one wants to include a character that could create ambiguities,
there are also some escape-sequences: A “\\n” becomes a newline, a “\\t” becomes a tab, a “\\\"”
becomes a quote and a “\\\\” becomes a backslash.

So the string-literal in our example becomes the text “Hello World!” directly followed by a newline.

Now for the last line:

```cpp
}
```
This is just the closing brace of the main-function an the point where the program ends.

Variables and basic Arithmetic
------------------------------

Since we now know how to print stuff, we can go on to do some very basic calculations and safe their
results.

Say we want to calculate the sum of two numbers and multiply the result with itself. A very simple
approach would be this:

```cpp
#include <iostream>

int main() {
	std::cout << (3 + 5) * (3 + 5) << "\n";
}
```
```
>> 64
```

This works but it isn't very flexible and changing one value requires changes in two different places
which is always a bad thing, since it can easily create errors. Also: There is no need to calculate 
the sum a second time after we have already done this. Variables solve this problem:

```cpp
#include <iostream>

int main() {
	int a = 3;
	int b = 5;
	int sum = a + b;
	std::cout << sum * sum << "\n";
}
```
```
>> 64
```

`int` is the default type for integers. On most modern systems it can hold numbers between -2147483648
and 2147483647, which should be enough for most applications. The statement `int a = 3;` now creates
a new integer with the name `a` and the value 3. `a` is called a variable since it holds a value
that can be changed. Almost everything that can be done with literal numbers in the code can also be
done with variables.

The third statement (`int sum = a + b;`) demonstrates that variables can also have longer names than
just one letter (which they should have almost always) and that we can initialize them from compund
expressions like `a + b`.

Conditional Execution
---------------------

Undefined Behaviour
-------------------

At this point it is time for the safety-instructions. C++ is a language that was designed to be very
fast and portable which sometimes conflicts with ease of use. As a result the C++-standard explicitly
does not always require a certain behaviour for programs that contains a given construct.

These constructs are almost always very questionable to start with and disallowing them is usually a
good thing. Examples include signed-integer-overflow, reading uninitialized variables and accessing
unowned memory. Possible behaviour ranges from apperently doing what the programer expected, over
randomly crashing to severe security-holes. Testing what happens and trusting that everything is fine
won't work too, because the next version of your compiler might decide to do something completely
different. To illustrate this, let's look at a real-world example:

Postgresql, a very popular database, hat two integers `a` and `b` of type `int` that were both known to
be positive. At this point they had to calculate the sum of these two but wanted to detect the case that
the sum was outside of the representable range of `int`. They did it somewhat like this:

```cpp
int sum = a + b;
if (sum <= b) {
	// error-handling
}
```

The assumption that the result will be smaller than `b` if an overflow occurs was funded in the fact
that practically every single modern cpu works that way. However: The C++-standard forbidds that kind
of code and compilers started to optimize on the assumption that `a + b` would *never* overflow.

As a result of this compilers deduced that adding a positive number to another number would never result
in something smaller than the second numbers. Therefore the check whether `sum <= b` would always be
false and could be removed.

When the first compiler introduced this behavior the postgres-maintainers protest and refused to fix
their code. Instead the used some options that GCC provided to disable this optimisation. When other
compilers also added this optimisation, they tried to continue doing similar things for them too,
but in the end they had to surrender and fix their code.

The lesson from this is that even if your code seems to work, it might stop doing this tomorow when the
next version of your compiler will be released.

**tl;dr:** Avoid undefined behavior by any means necessary.

Vectors
-------


Loops
-----


Summary
-------
