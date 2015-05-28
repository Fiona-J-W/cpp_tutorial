Const
=====

As we have seen in the last chapter, there are mainly two reasons to pass an argument to a function by
reference: It may be faster and we are able to change the original value.

We also saw that it is often unnecessary inside the function to be able to change the value of the
argument and noted that it is often a bad idea because it makes reasoning about the code harder. The
problem boils down to the fact, that we are currently unable to see from the signature of a function
whether it will change the value of it's arguments. The solution to this problem is called `const`.

Immutable values
----------------

`const` behaves somewhat similar to references: It is an annotation to an arbitrary type that
ensures, that it will not be changed. Let's start by looking at const variables, also called constants:

```cpp
#include <iostream>
#include <string>

int main() {
	const auto zero = 0;
	const auto one = 1;
	const auto str = std::string{"some const string"};
	
	// reading and printing constants is perfectly fine:
	std::cout << "zero=" << zero << ", one=" << one
	          << ", str='" << str << '\n';
	
	// even operations that do not change the values are ok:
	std::cout << "the third letter in str is '"
	          << str[2] << '\n';
	
	// doing calculations is no problem:
	std::cout << "one + one + zero = " << one + one + zero
	          << '\n';
	
	// trying to change the value results in a compiler-error:
	//zero = 2;
	//one += 1;
}
```
```
>> zero=0, one=1, str='some const string'
>> the third letter in str is 'm'
>> one + one + zero = 2
```

Aside from the possibility that the purpose of restricting what can be done with variables may be
unclear at this point, it is probably relatively easy to understand what the above code does and how
`const` works so far.

So, why should we use constants instead of variables and literals? The answer has to be split into two
parts, concerning both alternatives:

A constant may be more suitable than a variable if the value will never change, because it may both
enable the compiler to produce better code (knowing that a certain multiplication is always by two
instead of an arbitrary value will almost certainly result in faster code) and programmers to
understand it faster as they don't have to watch for possible changes.

On the other hand constants are almost always better then literal constants. Consider the following
examples:

```cpp
#include <iostream>

int main() {
	for(auto m = 0.0; m <= 2.0; m+=0.5) {
		std::cout << m << "kg create " << m * 9.81
		          << " newton of force.\n";
	}
}
```
```
>> 0kg create 0 newton of force.
>> 0.5kg create 4.905 newton of force.
>> 1kg create 9.81 newton of force.
>> 1.5kg create 14.715 newton of force.
>> 2kg create 19.62 newton of force.
```

```cpp
#include <iostream>

//gravitational_acceleration of earth
const double g_earth = 9.81;

int main() {
	for(double m = 0.0; m <= 2.0; m+=0.5) {
		std::cout << m << "kg create "
		          << m * g_earth
		          << " newton of force.\n";
	}
}
```
```
>> 0kg create 0 newton of force.
>> 0.5kg create 4.905 newton of force.
>> 1kg create 9.81 newton of force.
>> 1.5kg create 14.715 newton of force.
>> 2kg create 19.62 newton of force.
```

Even this pretty small example gets easier to understand, once we give names to constant values. It
should also be obvious that the advantage in readability increases even further if we need the value
multiple times. In this case there is even another advantage: Should we be interested to change the
value (for example because we want to be more precise about it), we just have to change one line in
the whole program.

Constant References
-------------------

At this point we understand how constant values work. The next step are constant references. We recall
that a reference is an alias for a variable. If we add constness to it, we annotate, that the aliased
variable may not be changed through this handle:

```cpp
#include <iostream>

int main() {
	auto x = 0;
	const auto y = 1;
	
	auto& z = x;
	
	const auto& cref1 = x;
	const auto& cref2 = y;
	const auto& cref3 = z;
	
	// auto& illegal_ref1 = y; // error
	// auto& illegal_ref3 = cref1; // error
	
	std::cout << "x=" << x << ", y=" << y << ", z=" << z
		<< ", cref1=" << cref1 << ", cref2=" << cref2
		<< ", cref3=" << cref3 << '\n';
	
	x = 10;
	
	std::cout << "x=" << x << ", y=" << y << ", z=" << z
		<< ", cref1=" << cref1 << ", cref2=" << cref2
		<< ", cref3=" << cref3 << '\n';
	
	// ++ref1 // error
	// ++ref2 // error
}
```
```
>> x=0, y=1, z=0, cref1=0, cref2=1, cref3=0
>> x=10, y=1, z=10, cref1=10, cref2=1, cref3=10
```

We note several things:

* It is allowed to create const references to non-const values, but we may not change them through this
reference.
* References may be constructed from other references.
* We may add constness when we create a reference, but we may not remove it.

Functions and Constants
-----------------------

With this knowledge it is pretty easy to solve our initial problem of passing arguments to functions by
reference: We just pass them by `const` reference which unites the performance-advantage with the
ease of reasoning about possible changes to variables.

```cpp
#include <iostream>
#include <vector>

//pass by const-reference
int smallest_element(const std::vector<int>& vec) {
	auto smallest_value = vec[0];
	for (auto x: vec) {
		if (x<smallest_value) {
			smallest_value = x;
		}
	}
	return smallest_value;
}
 
int main()
{
	auto vec = std::vector<int>{};
	for(auto i = -1'000'000; i < 1'000'000; ++i) {
		vec.push_back(i);
	}
	// getting a const reference to any variable is trivial,
	// therefore it is done implicitly:
	std::cout << "smallest element of vec is "
	          << smallest_element(vec) << '\n';
}
```
```
>> smallest element of vec is 0
```


This leaves us with the question of how to pass arguments into a function. While they may not be
entirely perfect, the following two rules should apply in most cases:

* If you just need to look at the argument: Pass by const reference.
* If you need to make a copy anyways, pass by value and work on the argument.

The rationale for this rule is simple: Big copies are very expensive, so you should avoid them. But if
you need to make one anyways, passing by value enables the language to create much faster code if the
argument is just a temporary value like in the following code:

```cpp
#include <iostream>
#include <cctype> // for toupper()
#include <string>

std::string get_some_string() {
	return "some very long string";
}

std::string make_loud(std::string str) {
	for(auto& c: str){
		// toupper converts every character to it's equivalent
		// uppercase-character
		c = std::toupper(c);
	}
	return str;
}

int main() {
	std::cout << make_loud(get_some_string()) << '\n';
}
```
```
>> SOME VERY LONG STRING
```

Let's ignore the details of the function `toupper()` for a moment and look at the other parts of
`make_loud`. It is pretty obvious that we need to create a complete copy of the argument if we don't
want to change the original (often the only reasonable thing). On the other hand: In this special
instance changing the original would not be a problem, since it is only a temporary value. The great
thing at this point is, that our compiler knows this and will in fact not create a copy for this but
just “move” the string in and tell the function: “This is as good as a copy; change it as you want.”

