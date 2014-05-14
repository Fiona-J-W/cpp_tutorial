References
==========

Functions are a great thing, but if we look closer there are problems with how the arguments are passed.
Let's look at our `smallest_element`-function again:

```cpp
#include <vector>
#include <iostream>
 
int smallest_element(std::vector<int> vec)
{
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
	std::vector<int> vec;
	for(size_t i=0; i < 10000000; ++i) {
		vec.push_back(i);
	}
 
	std::cout << "smallest element of vec is " << smallest_element(vec) << std::endl;
}
```

----

```
smallest element of vec is 0
```

The problem that we face here is somewhat non-obvious: Remember that the arguments to a function are
copied. While this is no problem for a single integer, we do not want to copy a big vector if we can
avoid it. If we examine the code we see, that there wouldn't be any problem if `smallest_element`
operated on the original vector instead of a copy.

This is where references come into play.

A reference is an alias for another variable. It must therefore be initialized with one the moment it
is constructed. It is not possible to make it alias another variable after that.
The easiest way to understand them is probably some code:

```cpp
#include <iostream>

int main()
{
	int x = 0; // a normal integer
	
	int& ref = x;
	// a reference to x. Note that the type is 
	// written almost identical with the exception
	// of the '&' that makes ref a reference.
	
	std::cout << "x=" << x << ", ref=" << ref << '\n';
	
	x = 3;
	std::cout << "x=" << x << ", ref=" << ref << '\n';
	
	ref = 4;
	std::cout << "x=" << x << ", ref=" << ref << '\n';
	
	int y = ref;
	std::cout << "x=" << x << ", y=" << y << ", ref=" << ref << '\n';

	y = 1;
	std::cout << "x=" << x << ", y=" << y << ", ref=" << ref << '\n';
	
	ref = y;
	std::cout << "x=" << x << ", y=" << y << ", ref=" << ref << '\n';

	y = 0;
	std::cout << "x=" << x << ", y=" << y << ", ref=" << ref << '\n';
	
}
```

----

```
x=0, ref=0
x=3, ref=3
x=4, ref=4
x=4, y=4, ref=4
x=4, y=1, ref=4
x=1, y=1, ref=1
x=1, y=0, ref=1
```

A reference to a certain type is itself a type. If the referenced type is `T`, then a reference to
it is written as `T&`. Note that it is impossible to create a reference to a reference; while the
syntax `T&&` exists and is related to references, it does something completely different and should
not be covered at this point.

Now that we know references we can go back to our initial problem: Passing a big vector into a
function. The solution is now very straightforward:

```cpp
#include <vector>
#include <iostream>

// pass a reference instead of a value:
//                                   ↓
int smallest_element(std::vector<int>& vec)
{
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
	std::vector<int> vec;
	for(size_t i=0; i < 10000000; ++i) {
		vec.push_back(i);
	}
	// vec is automatically passed as reference:
	std::cout << "smallest element of vec is " << smallest_element(vec) << std::endl;
}
```

----

```
smallest element of vec is 0
```

We see that it doesn't make any difference from the callside, whether a function copies it's arguments
(this is called ‘pass by value’) or just uses the original (‘pass by reference’).

Aside from the fact that passing by reference is often faster than passing by value, it allows us to
change the value of the original too:

```cpp
#include <iostream>

void increase(int& n)
{
	n += 10;
}

int main()
{
	int x = 0;
	std::cout << "the value of x is " << x << '\n';
	increase(x);
	std::cout << "the value of x is " << x << '\n';
}
```

----

```
the value of x is 0
the value of x is 10
```

Note however, that while this is possible, it is often a bad idea, since it makes reasoning about where
a variable is changed much harder. On the other hand there are situations where this really is the best
alternative. As a general advice: If you are unsure, don't do it.
