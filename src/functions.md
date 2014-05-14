Functions
=========

A function is a construct available in virtually all programming languages. By the simplest definition,
functions are reusable snippets of code. Reducing repetition is the main purpose of functions; doing so
makes the code better understandable and reduces the chance of errors.

It's perhaps best to start describing functions by a simple example: Let's say we have a vector of ints
and we want to find the biggest element. The code to accomplish this is pretty simple:

```cpp
#include <vector>
#include <iostream>

int main() {
	std::vector<int> vec {5, -3, 2, 7, 11};
	
	auto smallest_element = vec[0];
	for (auto x: vec) {
		if (x<smallest_element) {
			smallest_element = x;
		} 
	}
	std::cout << "smallest element is " << smallest_element << '\n';
}
```
```
>> smallest element of vec is -3
```

This solution works, but the problem is, that every time we want to do this again, we have to write
those lines again, which is unpleasant at best but most likely also error-prone. Functions give us the
flexibility to avoid rewriting this:

```cpp
#include <vector>
#include <iostream>

int smallest_element(std::vector<int> vec) {
	auto smallest_value = vec[0];
	for (auto x: vec) {
		if (x<smallest_value) {
			smallest_value = x;
		}
	}
	return smallest_value;
}

int main() {
	std::vector<int> vec1 {5, -3, 2, 7, 11};
	std::vector<int> vec2 {0, 1, 2, 3};
	
	std::cout << "smallest element of vec1 is "
	          << smallest_element(vec1) << '\n'
	          << "smallest element of vec2 is "
	          << smallest_element(vec2) << '\n';
}
```
```
>> smallest element of vec1 is -3
>> smallest element of vec2 is 0
```

The amount of saved typing is obvious. We also have the advantage that we are now able to improve the
algorithm in one place so that the improvements are right away in the whole program.

The signature of a function
---------------------------

Now: How does this work? Let's look at the first line of the function:

```cpp
int smallest_element(std::vector<int> vec)
```

This is called the functions signature. It consists of three parts: The name of the function
(`smallest_element`), it's returntype (`int`) and a comma-separated list of it's arguments.

The name is probably the easiest part to understand: It identifies the function. The same restrictions
that exist for variable names (may not start with a digit, may not contain whitespace or special
characters other than underscore, …) apply also for names of functions.

The returntype is the type of the thing, that a function returns. We gave it a vector of ints and
request the smallest element, so the returntype is of course int. If there is nothing to return, the
returntype is `void`.

The arguments are the data on which the function should operate. Since we want to inspect a vector of
ints it has to get into the function somehow, so we pass it as argument. The list may be empty, in
which case we just write `()`; otherwise we write the type of the argument, followed by the name with
which we refer to it in the function. If their are further arguments they have to be written in the
same way, divided by commas.

The body of a function
----------------------

Since we should now have a basic idea of how the signature works we can examine the rest of it, the so
called body:

```cpp
{
	auto smallest_value = vec[0];
	for (auto x: vec) {
		if (x<smallest_value) {
			smallest_value = x;
		}
	}
	return smallest_value;
}
```

The first thing that should be noted are the braces that start and end the function. They also create
a new scope so that every variable in it only exists in the function.

The first five lines inside that scope are pretty normal C++ without any real surprises.

The last line however contains a so called return-statement. It consists of the word `return` followed
by whitespace, followed by a statement that has a type, followed by a semicolon. „statement followed
by a type“ mainly refers to either a literal, a variable, a call to a function that returns a value or
some term that involves operators (which can be seen as functions). So all of these are valid
return-statements:

```cpp
// literal 1:
return 1;

// variable:
int returnvalue = 2;
return returnvalue;

// the result of some calculations involving operators:
return 2*3 + 4*5;

// the returnvalue of some function:
return some_function(1, 3);
```

It is important that the type of the used expression is either identical to the returntype of the
function or can be trivially converted to it:

```cpp
double fun_1() {
	return 1.0;
	// fine: 1.0 is double, as is the returntype of
	// the function.
}

double fun_2() {
	return 1;
	// fine too: while 1 has type int, it can be trivially
	// converted to double.
}

double fun_3() {
	return "some string";
	// error: a string-literal cannot be trivially converted
	// to double.
}
```

Calling a Function
------------------

Calling a function is probably the easiest part in this chapter: Just write the name of the function
followed by parenthesis that contain the arguments. Note that the arguments are copied into the
function, so any changes that are made to them there wont change the value of the argument at the
callside.

```cpp

#include <iostream>

void print_string(std::string str) {
	std::cout << str << std::endl;
}

void print_ints(int i1, int i2) {
	std::cout << i1 << ", " << i2 << std::endl;
}

void print_hello_world() {
	std::cout << "Hello World!" << std::endl;
}

int main() {
	print_string("some string");
	print_ints(1, 3);
	print_hello_world();
}


```
```
>> some string
>> 1, 3
>> Hello World!
```

If we are interested in the returnvalue, we can just use the call as if it would be a value:

```cpp
#include <iostream>

int add(int i1, int i2) {
	return i1 + i2;
}

// implemented according to http://xkcd.com/221/
int get_random_number() {
	//chosen by fair dice-roll:
	return 4;
}

int main() {
	int a = add(1,2);
	std::cout << "The value of a is " << a << ".\n"
	          << "A truly random number is: "
	          << get_random_number() << '\n';
}
```
```
>> The value of a is 3.
>> A truly random number is: 4.
```

Some examples
-------------

```cpp
#include <iostream>

// a function that takes no arguments and returns
// an int:
int function_1() {
	return 1;
}

// a function that prints an int that is passed to it and
// returns nothing:
void print_int(int n) {
	std::cout << n << std::endl;
}

// a function that returns nothing, takes no arguments and
// does nothing:
void do_nothing() {}

```
