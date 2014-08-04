Getting Started
===============

At this point you should have a working compiler and text-editor, so that we can start out with looking
into the fundamental building-blocks of the language.

This chapter may not appear to be very entertaining or of much direct use, but it is very important as
everything we will encounter here is needed to procede to the more interessting topics that will build
on top of it.

Hello World
-----------

```cpp
#include <iostream>

int main() {
	std::cout << "Hello World!\n";
}
```
```output
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

Basic Arithmetic and Variables
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
```output
>> 64
```

What we can see here is that numbers are directly supported by the language and that we can use the
usual notation to do calculations with them. The most basic operations on numbers supported by C++
directly (without help from libraries) are:

-------- -------
`+`      Addition
`-`      Subraction
`*`      Multiplication
`/`      Division
`%`      Modulo
-------- -------

Most of these work just as one would think that they do, the later two will however require some
further notes:

* Dividing two integers will result in an integer; this is done via truncation: `3 / 4` will have
  the result 0, since 0.75 will get rounded down. This is however not the case when calculating
  with real numbers (called `double`s in C++): `3.0 / 4` will have 0.75 as result.
* Modulo is only supported by integers, so `7.0 % 4` will *not* work.
* Since division by 0 doesn't make much sense, C++ strictly forbids to do this (same rule applies for
  modulo). Trying to do this will likely result in a crashing-program and is in fact undefined
  behavior (more about this and why you should really avoid it, will be explained soon).

Aside from these restrictions the usual rules known from school apply here: Multiplication and division
have higher precedence than addition and subtraction and if you want to change this, you have to use
parenthesis.

Back to our example: It surely works but it isn't very flexible and changing one value requires changes
in two different places which is always a bad thing, since it can easily create errors. Also: There is
no need to calculate the sum a second time after we have already done this. Variables solve this
problem:

```cpp
#include <iostream>

int main() {
	int a = 3;
	int b = 5;
	int sum = a + b;
	std::cout << sum * sum << "\n";
}
```
```output
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

Reading User-input
------------------

In order to write programs that are not entirely static, we can read things too:

```cpp
#include <iostream>

int main() {
	int num = 0;
	std::cout << "Please enter a number:\n";
	std::cin >> num;
	std::cout << "You entered " << num << "\n";
}
```
```output
>> Please enter a number:
<< 42
>>You entered 42
```

Conditional Execution
---------------------

Let's write a program that prints the modulus of two numbers:

```cpp
#include <iostream>

int main() {
	std::cout << "Please enter two numbers seperated by whitespace:\n"
	int num1 = 0;
	int num2 = 0;
	std::cin >> num1 >> num2;
	std::cout << num1 << " / " << num2
	          << " = " << num1 / num2 << "\n";
}
```
```output
>> Please enter two numbers seperated by whitespace:
<< 8 4
>> 8 / 4 = 2
```

At this point we see a great problem: What if the second number that we enter
is 0? As already noted we are not allowed to do this calculation (aside from the
fact that it doesn't make any sense). The solution is an `if`-statement:

```cpp
#include <iostream>

int main() {
	std::cout << "Please enter two numbers seperated by whitespace:\n"
	int num1 = 0;
	int num2 = 0;
	std::cin >> num1 >> num2;
	if (num2 != 0) {
		std::cout << num1 << " / " << num2
		          << " = " << num1 / num2 << "\n";
	}
}
```
```output
>> Please enter two numbers seperated by whitespace:
<< 8 4
>> 8 / 4 = 2
```

The structure of an `if`-statement is very simple: `if`, followed by a boolean expression between
parenthesis, followed by a list of statements between braces. A boolean expression is a (small) piece
of code that evaluates to a boolean value (true or false). Often this is achieved with a comparission
like the above: `num2 != 0` is the C++-way of asking whether `num2` $\ne 0$. The available 
comparission-operators are these:

C++      Meaning
-------- -----------------------
`a == b` $a = b$
`a != b` $a \ne b$
`a <  b` $a < b$
`a <= b` $a \le b$
`a >  b` $a > b$
`a >= b` $a \ge b$
-------- -------

In addition to those an expression can be prefixed with “`!`”, which negates it's value: `!true == false`.
To negate bigger expressions just enclose them in parenthesis: `!(true == false)` will be evaluated to
`true`.

Another thing that one should know is that integers (and some other types) can be implicitly converted
to bool, if they are used as boolean expression; in that case `0` becomes `false` and every other value
becomes `true`. There is no final consensus whether one should write `if (i != 0)` instead of `if (!i)`,
but for the beginning it is certainly a good idea to be explicit here.

Back to the `if`-statements: What if we want to do two different things for each case? For this, there
is the so called `else`-statement that can follow an `if`-statement. it is basically the word `else` followed
by statements between braces.


```cpp
if (num2 != 0) {
	std::cout << num1 / num2 << std::endl;
} else {
	std::cout << "Error: division by zero!\n";
}
```

This leads us to another problem: What if we have more than two cases? Then we can just use an `else if`:

```cpp
if (num == 0) {
} else if (num < 0) {
	std::cout << "num is negative\n";
} else {
	std::cout << "num is positive\n";
}
```

(Technically the braces around a single conditional statement are not mandatorry; they are however **strongly**
recommended since ommiting them can very easily lead to bugs (misstakes), especially in the case where you
nest conditionals.

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

When the first compiler introduced this behavior the postgres-maintainers protested and refused to fix
their code. Instead the used some options that GCC provided to disable this optimisation. When other
compilers also added this optimisation, they tried to continue doing similar things for them too,
but in the end they had to surrender and fix their code.

The lesson from this is that even if your code seems to work, it might stop doing this tomorow when the
next version of your compiler will be released.

**tl;dr:** Avoid undefined behavior by any means necessary.

Strings
-------

We already took a very short look at string-literals and used them when printing stuff:

```cpp
#include <iostream>

int main() {
	std::cout << "Hello World!\n";
}
```

Of course it is also possible to safe a string in a variable. In order to achieve that we have to include
the `<string>`-header and create a variable of the type `std::string`:

```cpp
#include <iostream>
#include <string>

int main() {
	std::string str = "some string.\n";
	std::cout << str;
}
```

As with integers there are several operations that `std::string` supports: Copying, assigning and comparing
all work as one would expect. In addition we can concatenate `std::string`s and string-literals using
the `+`-operator:

```cpp
#include <iostream>
#include <string>

int main() {
	std::string str1 = "foo";
	std::string str2 = "bar";
	if (str1 == str2) {
		std::cout << "ERROR: this should never happen!\n";
	}
	std::string str3;  // str3 = ""
	str3 = str1 + str2;
	if (str3 == "foobar") {
		std::cout << "Everything is fine!\n";
	}
}
```
```output
>> Everything is fine!
```

Vectors
-------

Loops
-----


Summary
-------


