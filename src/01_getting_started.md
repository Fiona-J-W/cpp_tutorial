Getting Started
===============

At this point you should have a working compiler and text-editor, so that we can start out with looking
into the fundamental building-blocks of the language.

This chapter may not appear to be very entertaining or of much direct use, but it is very important as
everything we will encounter here is needed to proceede to the more interessting topics that will build
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
reading and writing from and to other resources like standard-input, standard-output, files and so on.

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

Since we now know how to print stuff, we can go on to do some very basic calculations and save their
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
parentheses.

Back to our example: It surely works but it isn't very flexible and changing one value requires changes
in two different places which is always a bad thing, since it can easily create errors. Also: There is
no need to calculate the sum a second time after we have already done this. Variables solve this
problem:

```cpp
#include <iostream>

int main() {
	auto a = 3;
	auto b = 5;
	auto sum = a + b;
	std::cout << sum * sum << "\n";
}
```
```output
>> 64
```

The line `auto a = 3;` creates a new variable named “a” that holds the value 3. Since “3” is an integer
it has the type `int` in C++. The language infers the type of a variable from the value it is initialized
with and checks that all uses of all variables are consistent after that. It is important to understand
that the type of a variable will never change after it has been created; if you try to assign a value
of a different type your code may sometimes compile, but this is because the compiler found a way to
convert the argument to the type of your variable.

In all places where you can use a literal number it is also possible to use a variable, for that reason
you shouldn't be stingy with variables since they can vastly increase readability;

Let's take a closer look at the type that we are using in this example: `int`. It is the languages default
type for integers and can on most modern systems hold numbers between -2147483648
and 2147483647, which should be enough for most applications.

The third statement (`auto sum = a + b;`) demonstrates that variables can also have longer names than
just one letter (which they should have almost always) and that we can initialize them from compound
expressions like `a + b`.

Finally it should be mentioned that there are other ways to create in variables in C++ too and that
encountering them in other peoples code is basically guaranteed, but that this style is usually
recommended in the context of modern C++, because it avoids several gotchas in the language, is easy to
read and relatively consistent.

Reading User-input
------------------

In order to write programs that are not entirely static, we can read things too:

```cpp
#include <iostream>

int main() {
	auto num = 0;
	std::cout << "Please enter a number:\n";
	std::cin >> num;
	std::cout << "You entered " << num << "\n";
}
```
```output
>> Please enter a number:
<< 42
>> You entered 42
```

Reading behaves somewhat similar to writing: We have a character-stream of incoming
characters (usually from the keyboard) and push those into variables with a stream-operator.

To read more than one value, we can also chain these reads:

```cpp
#include <iostream>

int main() {
	auto i1 = 0;
	auto i2 = 0;
	auto i3 = 0;
	std::cout << "Please enter three numbers:\n";
	std::cin >> i1 >> i2 >> i3;
	std::cout << "The sum of your numbers is " << i1+i2+i3 << "\n";
}
```
```output
>> Please enter three numbers:
<< 23 42 5
>> The sum of your numbers is 70
```

We will see later that we can read a lot of types other than integers, including the not
yet covered strings that can store simple text.


Conditional Execution
---------------------

Let's write a program that prints the modulus of two numbers:

```cpp
#include <iostream>

int main() {
	std::cout << "Please enter two numbers seperated by whitespace:\n"
	auto num1 = 0;
	auto num2 = 0;
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
	auto num1 = 0;
	auto num2 = 0;
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
parentheses, followed by a list of statements between braces. A boolean expression is a (small) piece
of code that evaluates to a value of the type `bool` (that is either true or false). Often this is
achieved with a comparison like the above: `num2 != 0` is the C++-way of asking whether
`num2` $\ne 0$. The available comparison-operators are these:

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
To negate bigger expressions just enclose them in parentheses: `!(true == false)` will be evaluated to
`true`.

Another thing that one should know is that integers (and some other types) can be implicitly converted
to bool, if they are used as boolean expression; in that case `0` becomes `false` and every other value
becomes `true`. There is no final consensus whether one should write `if (i != 0)` instead of `if (i)`,
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
recommended since ommiting them can very easily lead to bugs (mistakes), especially in the case where you
nest conditionals.

Undefined Behavior
-------------------

At this point it is time for the safety-instructions. C++ is a language that was designed to be very
fast and portable which sometimes conflicts with ease of use. As a result the C++-standard explicitly
does not always require a certain behavior for programs that contains a given construct.

These constructs are almost always very questionable to start with and disallowing them is usually a
good thing. Examples include overflowing an `int` (calculating a value that is outside the representable
range of int, for example by executing “`2'000'000'000 + 2'000'000'000`”), reading uninitialized variables
and accessing unowned memory. Possible behavior ranges from apperently doing what the programmer expected,
over randomly crashing to severe security-holes. Testing what happens and trusting that everything is fine
won't work too, because the next version of your compiler might decide to do something completely
different. To illustrate this, let's look at a real-world example:

Postgresql, a very popular database, hat two integers `a` and `b` of type `int` that were both known to
be positive. At this point they had to calculate the sum of these two but wanted to detect the case that
the sum was outside of the representable range of `int`. They did it somewhat like this:

```cpp
auto sum = a + b;
if (sum <= b) {
	// error-handling
}
```

The assumption that the result will be smaller than `b` if an overflow occurs was funded in the fact
that practically every single modern cpu works that way. However: The C++-standard forbids that kind
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

Loops
-----

If we want to check a condition once, we can use `if`. What however if we want to execute something
a previously unknown number of times? This is where loops come into play. The simplest form is the
so-called `while`-loop. The syntax is basically the same as it is for the the `if`-statement.

The main-difference is that the condition will not be checked once, but again after every execution
of the loop-body:

```cpp
#include <iostream>

int main() {
	auto i = 0;

	while (i != 3) {
		std::cout << "i still isn't 3.\n";
		// '++i' is a shorthand-notation for 'i = i + 1'
		++i;
	}
	std::cout << "i is now 3.\n";
}
```
```output
>> i still isn't equal to 3.
>> i still isn't equal to 3.
>> i still isn't equal to 3.
>> i is now 3.
```

The way we used `i` here is quite common: A counter that counts the number of times
that the loop-body was executed and is compared then to the required number of executions.
We call this kind of variables loop-counters and they are conventionally often named `i`, `j`
and `k` (this is one of the rare cases where single-letter-names are acceptable).

Since the concept of a loop-counter is needed so often, there is also some special syntax to
support it: The `for`-loop. It has the following structure:


for (*variable-declaration*; *condition*; *loop-operation*) { *loop-body* }

* *variable-declaration* Is a place to declare variables that will live during the execution of the
  loop. At this point this will most of the time be the loop-counter.
* *condition* is a conditional statement that works exactly like it does in the while-loop.
* *loop-operation* is a statement that is executed after every execution of the loops body. It should
  only be used to do things like incrementing the loop-counter.
* *loop-body* is similar to the if's conditional body: It is executed as long as the loops condition is met.

Since this is quite theoretical, let's revisit the example that we used for the `while`-loop:

```cpp
#include <iostream>

int main() {
	// TODO: unsigned
	for(auto i = 0; i != 3; ++i) {
		std::cout << "i still isn't 3.\n";
	}
	std::cout << "i is now 3.\n";
}
```

Here `int i = 3` is the variable declaration. It creates an integer `i` and intializes it with 0.
The condition of this loop is that `i` is not equal to 3 which is of course true in the beginning.


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
	auto str = std::string{"some string.\n"};
	std::cout << str;
}
```
```output
>> some string.
```

As with integers there are several operations that `std::string` supports: Copying, assigning and comparing
all work as one would expect. In addition we can concatenate `std::string`s and string-literals using
the `+`-operator:

```cpp
#include <iostream>
#include <string>

int main() {
	auto str1 = std::string{"foo"};
	auto str2 = std::string{"bar"};
	if (str1 == str2) {
		std::cout << "ERROR: this should never happen!\n";
	}
	auto str3 = std::string{}; // str3 = ""
	str3 = str1 + str2;
	if (str3 == "foobar") {
		std::cout << "Everything is fine!\n";
	}
}
```
```output
>> Everything is fine!
```

Conceptually a string is basically just a sequence of characters. In C++ there is a type called `char` that, as one
might expect, represents a character. Technically a `char` is an integer with a width of one byte. This allows a
range from either -128 to -127 or 0 to 255 (your own implementation will almost certainly use -128 to 127, but keep
in mind that this is not everywhere the case). The values between 0 and 127 are the so called ASCII-characters that
contain the latin alphabet(a-z in both upper and lower case), arabian numbers (0-9), basic punctuation (point, comma,
semi-colon, colon, …) and some stuff that basically no one uses any more.

To represent further characters like the “Ä”, “Ö”, “Ü” and “ß” several chars have to be combined to a sequence (this
is called UTF-8 and you shouldn't use anything else). The problem with this approach is, that the number of chars
and logical characters in strings differ. There is no reasonable solution to that problem (In case you heard about
UTF-32: It isn't either, since there is something called “combining characters”).

Let's take a short look at how chars can be used:

```cpp
#include <iostream>

int main() {
	auto c1 = 'A'; // Note the single-quotes!!
	auto c2 = 'B'; // a symbol encoded in them has type char
	if (c1 != c2) {
		std::cout << "Comparission works!\n";
	}

	auto c4 = char{65}; // 'A' has the value 65, so this works, but you
	                    // shouldn't really do it
	std::cout << c4 << '\n'; // newline is just one char, so this works
}
```
```output
>> Comparission works!
>> A
```

The reason we are looking so deep into characters is that you can access them in a `std::string` with the
“[]”-operator:

```cpp
#include <iostream>
#include <string>

int main() {
	auto str = std::string{"foobar"};
	std::cout << str[0] << '\n';
	str[1] = 'O';
	std::cout << str << '\n';
}
```
```output
>> f
>> fOobar
```

To access the $n$'th Character we write $n - 1$ between the square-brackets that we attach to the variable.
We will take a look into the reasons for this so-called zero-indexing later, for the meantime it is
enough to know that this is how C++ (and most other programming-languages) work and just accept that.

This leaves us with two questions: How do we find out the size of the string and what happens if our indexes
refer to nonexisting characters.

The first question is answered by the so called method `size()`. A later chapter will deal with the question
what methods are, so for the meantime it is enough to know that if you have a variable `str` of the 
type `std::string`, you can find out the number of chars in it with the following code: “`str.size()`”

The answer to the second question is more terrifying: If your index is invalid, your program contains
undefined behavior and is likely to crash in an uncontrollable way. The one exception is the value returned
by `size()`: It is guaranteed to return a char with the value zero (the value, not the character ‘0’), but it
must not be written to.

In order to somewhat reduce the dangers of this, there is another method called `at()` that mostly behaves like
the square-brackets but is guaranteed to trigger C++'s error-handling-mechanisms (Since we haven't looked into
those yet, this would currently mean a guaranteed controlled shut-down instead of undefined behavior).

Let's look at how we can use these things in practice:

```cpp
#include <iostream>
#include <string>

int main() {
	auto str = std::string{"foo"};
	std::cout << "std.size() = " << str.size() << '\n';
	for (auto i = 0u; i < str.size(); ++i) {
		std::cout << str[i] << str.at(i);
	}
	std::cout << '\n';
}
```
```output
>> 3
>> ffoooo
```

The last thing strings for now will be how to read them from standard-input. The obvious way works
but has the potential disadvantage, that it reads a word (words are seperated by whitespace in this
context). Further words will of course be just ignored in that case:

```cpp
#include <iostream>
#include <string>

int main() {
	auto str1 = std::string{};
	auto str2 = std::string{};
	std::cin >> str1 >> str2;
	std::cout << str1 << ", " << str2 << '\n';
}
```
```output
<< word1 word2 word3
>> word1, word2
```

Vectors
-------

Strings are sequences of characters, but what if we want a sequence of something else? This is what
`std::vector` is designed for. In order to use it we have to include the `<vector>`-header first and
then declare what it should contain:

```cpp
#include <vector>
#include <iostream>

int main() {
	// a vector of ints:
	auto  ints = std::vector<int>{0, 1, 2, 3, 4};

	// a vector of strings:
	auto strings = std::vector<std::string>{"Foo", "Bar"};
}
```

Aside from reading, printing and concatenating with `+` all the things that we just learned
about strings can also be done with `std::vector`:

```cpp
#include <vector>
#include <iostream>

int main() {
	auto vec1 = std::vector<int>{1, 2, 3};
	std::cout << vec[1] << ", " << vec.at(2) << '\n';
	auto vec2 = std::vector<int>{2, 3};
	if (vec1 != vec2) {
		std::cout << "the vectors contain different elements\n";
	}
}
```
```output
>> 2, 3
>> the vectors contain different elements
```

As we can see above, initializing a vector with elements is as easy as writing
the values in braces and assigning these during construction. Alternatively we can
pass it an integer (and optionally a value) in parentheses in order to create a vector
of a certain size with all elements being defaulted to the given value or, if none is given,
it's default value (empty string for strings, zero for numbers):

```cpp
#include <vector>
#include <iostream>

int main() {
	// a vector of 1000 integers:
	auto vec1 = std::vector<int>(1000);

	// a vector of 100 strings with value "foo":
	auto vec2 = std::vector<std::string>(100, "foo");
}
```


Foreach-Loops
-------------

We already know the for-loops and we have already seen how we can use them to
iterate over all elements in a `std::vector` or `std::string`:

```cpp
#include <iostream>
#include <vector>
#include <string>

int main() {
	auto vec = std::vector<std::string>{"foo", "bar"};
	for (auto i = 0u; i < vec.size(); ++i) {
		std::cout << vec[i] << '\n';
	}
}
```
```output
>> foo
>> bar
```

This works, but it is both verbose and not very general: At some point we will come
across data-structures that hold sequences, but don't allow access with square-brackets.

To solve these (and some other) problems, C++ has a so called range-based-for-loop, that
allows us to say what we really want:

```cpp
#include <iostream>
#include <vector>
#include <string>

int main() {
	auto vec = std::vector<std::string>{"foo", "bar"};
	for (std::string str: vec) { // read: for each str in vec:
		std::cout << str << '\n';
	}
}
```
```output
>> foo
>> bar
```

Nobody will deny that this code is much cleaner and easier to follow, but we
will encounter problems if we try to assign a new value to `str`: `str` is
a copy of the `std::string` in the vector, so changing it won't change the value
in the vector. Another problem is that the copy may be expensive if the string
is large. Last but not least it is tedious to repeat the type that is already
stated (in the definition of vec). The solution to these problems is to just write
“`auto&`” instead of the type. The ampersand (the “&”) makes sure that `str` is not
a copy of the element in the container, but just an alias (another name) for
the element itself.

So our final version looks like this:


```cpp
#include <iostream>
#include <vector>
#include <string>

int main() {
	auto vec = std::vector<std::string>{"foo", "bar"};
	for (auto& str: vec) { // read: for each str in vec:
		std::cout << str << '\n';
	}
}
```




Summary
-------

In this chapter we took a short look into the very basics of C++. In order to keep the
complexity at managable levels we skipped over many details and simplified a few other things.

The reason is that we will need everything we learned here in basically all of the upcoming
chapters, that will hopefully provide more of a red thread and make things clearer.

The topics that you should remember from now on, are:

* How to print stuff
* What a variable is
* What integers, strings and vectors are, and how we can use them
* The basic control-structures: `if`, `else`, normal `for` and range-`for`

Before you continue, you should do the training-tasks to get some basic feelings about how
to program and how the language behaves. It is impossible to learn programming without
writing code yourself.

Training
--------

* Write a program that asks the user for their name and prints “`Hello <username>`” after that.
	* Hint: Save the name in a `std::string`
* Write a program that will print all integral numbers between 1 and 100.
	* Hint: Use a normal `for`-loop
* Modify the above programm, so that it will print “Fizz” if the number can be cleanly divided
  by 3, “Buzz” if it can be cleanly divided by 5 and “Fizzbuzz” if it can be cleanly divided by 15.
  Otherwise keep printing the number itself.
	* Hint: `7 % 3 == 0` will tell you, if seven can be cleanly divided by three.
	* Hint: You will have to put the `if`'s and `else`'s inside the loop.

