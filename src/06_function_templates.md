Function Templates
==================

Sometimes we have several almost identical functions, the only difference being that they operate on
different types. Function templates are a feature of the C++ language that allows to have a single
implementation that works for multiple types instead of duplicating the code. During compilation the
compiler will duplicate the code for us as many times as needed.

Basic principles
----------------

Function templates are defined by adding `template<`*type list*`>` before the declaration of the
function. For example, <!--TODO-->

```cpp
template<class Type>
void foo(int x) {
	/* put code here */
}
```

Now we can use `Type` within the function body as any other type such as `char` or `double`. The
template parameter list may contain multiple parameters. Each of them must be prepended with either of
`class` or `typename` keywords.

The above function can be called as e.g. `foo<char>(2)`. Each time the function is called, the compiler
“pastes“ `char` into each location where `Type` is used and checks whether the resulting code is
valid. If it's not valid, an error is raised. Otherwise, the function behaves in the same way as if
`Type` was `char` or any other given type. See the example below:

```cpp
#include <iostream>
#include <iomanip>

// Read a type from std::cin and return the value
template<class Type>
Type read() {
	auto value = Type{};
	std::cin >> value;
	return value;
}
 
int main() {
	const auto integer = read<int>();
	const auto str = read<std::string>();
	const auto c = read<char>();
	std::cout << integer << ", " << str << ", " << c << '\n';
}
```

```
<< 123 foobar x
>> 123, foobar, x
```

Deduction
---------

Template parameters can be used anywhere in the function, including the parameter list. For example,
`template<class T> void bar(T a, T b) { ... } `. If all template parameters appear in the function
parameter list, then the compiler can deduce the actual type of the parameter automatically, so the
function template can be called in the same way as any other function, e.g. `bar(2, 3)`. See the
example below:

```cpp
#include <iostream>
#include <iomanip>

// Prints the given type
template<class T>
void print(const T& x) {
	std::cout << x << "\n";
}
 
int main() {
	std::cout << std::fixed << std::setprecision(3); // setup formatting
	print(64);         // prints 64 as an int
	print(64.2);       // prints 64.2 as a double
	print(64.0);       // prints 64 as a double
	print<char>(64);   // override the automatic deduction -- force T to be char
	print('c');        // print 'c' as a char
	print("bar");      // prints "bar" as string-literal
}
```
```
>> 64
>> 64.200
>> 64.000
>> D
>> c
>> bar
```

But this is not everything: We can even infer the *parts* of the argument types:

```cpp
template<typename T>
void print_all(const std::vector<T>& vec) {
	for(const auto& element: vec) {
		std::cout << element << '\n';
	}
}

int main() {
	const auto intvec = std::vector<int>{1,2,3};
	print_all(intvec);
	const auto strvec = std::vector<std::string>{"foo", "bar"};
	print_all(strvec);
}
```
```
>> 1
>> 2
>> 3
>> foo
>> bar
```

Maybe you have already guessed that `std::vector` is some kind of template too,
which is true and we will look into the details of that soon, but for the meantime
it is enough to note that code like the above works as long as it stays relatively
simple.


In general one should almost never pass template-arguments that
can be inferred, since the compiler knows better anyways and the
function-template may do unexpected things, if you override the inferred
types.

Training
--------

* Take the `smallest_element`-function from the last chapter and turn it
  into a function-template that works on
	1. Arbitrary containers
	2. Arbitrary `std::vector`s, but not on other containers
* Modify the `print_all` example so that it doesn't append a
  newline to each element, but separates all elements with a comma
  and a space. Make sure that those characters are not printed after
  the last element.

