Structs and Classes
===================

Let's assume we want to calculate the distance between two points in space; the formula for this is
quite simple: Sum the squares of the distances in every dimension and take the square-root:

distance  = $\sqrt{\left|x_1-x_2\right|^2 + \left|y_1-y_2\right|^2 + \left|z_1-z_2\right|^2}$

Since this is somewhat heavy to write every time, we'll use a function for that:

<!---TODO: Note about linking the math-library-->

```cpp
#include <iostream>
#include <cmath> // needed for sqrt() and abs()

double square(double number) {
	return number * number;
}


double distance(double x1, double y1, double z1, double x2,
                double y2, double z2) {
	auto squared_x_distance = square(std::abs(x1-x2));
	auto squared_y_distance = square(std::abs(y1-y2));
	auto squared_z_distance = square(std::abs(z1-z2));
	auto sum = squared_x_distance + squared_y_distance
	           + squared_z_distance;
	return std::sqrt(sum);
}

int main() {
	std::cout << "The points (0,1,2) and (4,1,0) have the distance "
	          << distance(0,1,2,4,1,0) << '\n';
}
```
```
>> The points (0,1,2) and (4,1,0) have the distance 4.47214
```

The solution is working, but if we are honest, it isn't really nice: Passing the points into the
function by throwing in six arguments is not only ugly, but also error-prone. Luckily C++ has solutions
for this: Structs and classes. The biggest difference between these two is conventional, not technical,
so we can look into them together.

A struct is basically a collection of values. In our example a point is represented by three doubles
which even got implicit names: `x`, `y`, and `z`. So let's create a new type that is exactly that:

```cpp
#include <iostream>
#include <cmath> // needed for sqrt() and abs()

struct point {
	double x;
	double y;
	double z;
};

double square(double number) {
	return number * number;
}

double distance(const point& p1, const point& p2) {
	auto squared_x_distance = square(std::abs(p1.x-p2.x));
	auto squared_y_distance = square(std::abs(p1.y-p2.y));
	auto squared_z_distance = square(std::abs(p1.z-p2.z));
	auto sum = squared_x_distance + squared_y_distance
	           + squared_z_distance;
	return std::sqrt(sum);
}

int main() {
	std::cout << "The points (0,1,2) and (4,1,0) have the distance "
		<< distance(point{0,1,2}, point{4,1,0}) << '\n';
}
```
```
>> The points (0,1,2) and (4,1,0) have the distance 4.47214
```

Reducing six arguments to two, which in addition share semantics is clearly an improvement. It is
obvious that the code got way cleaner.

Construction
------------

Above we created our points by writing `point{0,1,2}`. This worked because point is an extremely
simple structure. In general (we'll discuss the exact circumstances later) we need to implement the
initialization ourself though.

Considering our current struct: Leaving variables uninitialized is evil and there is no exception for
variables in structs and later on classes. So let's make sure, that they are zero, unless explicitly
changed:

```cpp
#include <iostream>

struct point {
	// this makes sure that x, y and z get zero-initialized 
	// at the construction of a new point:
	double x = 0.0;
	double y = 0.0;
	double z = 0.0;
};

int main() {
	// no longer possible:
	// auto p = point{1,2,3};
	 
	// this has always been possible, but dangerous 
	// now it's safe thanks to zero-initialization:
	point p1;
	
	// this is exactly the same as above:
	point p2{};
	
	std::cout << "p1: " << p1.x << '/' << p1.y << '/' << p1.z << '\n';
	std::cout << "p2: " << p2.x << '/' << p2.y << '/' << p2.z << '\n';
}
```
```
>> p1: 0/0/0
>> p2: 0/0/0
```

This works but we lose the great advantage of initializing a point with the values we want in a
comfortable way. The solution to this is called a constructor. It is a special function that is
part of a struct and is called when the object is created.

Let's create one that behaves like the one we had in the beginning:

```cpp
#include <iostream>

struct point {
	// a constructor has neither returntype nor is it
	// possible to return a value from it. Aside from that,
	// it's name is identical with that of it's class:
	point(double x_arg, double y_arg, double z_arg) {
		// we can access all member-variables of the struct
		// inside the constructor:
		x = x_arg;
		y = y_arg;
		z = z_arg;
	}

	double x = 0.0;
	double y = 0.0;
	double z = 0.0;
};

int main() {
	// now these constructions work again:
	point p1{1,2,3};
	auto p2 = point{4,5,6};
	
	std::cout << "p1: " << p1.x << '/' << p1.y << '/' << p1.z << '\n';
	std::cout << "p2: " << p2.x << '/' << p2.y << '/' << p2.z << '\n';
}
```
```
>> p1: 1/2/3
>> p2: 4/5/6
```

If we look at the code, we see a very common situation: We have several data-members in our struct,
one argument for each of them, and we directly assign the value of the argument to the member. This is
fine, if the members are just doubles or ints, but it can create quite an overhead, if the
default-construction of the member (which must be completed upon entry of the constructor) is
expensive, like for `std::vector`. To solve this problem, C++ provides a way to initialize data-members
before the actual constructor-body is entered:

```cpp
#include <iostream>

struct point {
	// the members x, y and z are intialized with the arguments x, y, and z:
	point(double x, double y, double z) : x{x}, y{y}, z{z} {}
	//                        the actual body is now empty ↑↑

	double x = 0.0;
	double y = 0.0;
	double z = 0.0;
};

int main() {
	point p{1,2,3};
	std::cout << "p: " << p.x << '/' << p.y << '/' << p.z << '\n';
}
```
```
>> p: 1/2/3
```

This way of initializing members is almost always preferable if it is reasonably possible.
It should however be noted, that there is one danger using it: The member-variables are initialized in
the order of declaration *in the class*, not in the order of the initialization, that the constructor
seems to apply. As a result the following code is wrong:

```cpp
struct dangerous_struct {
	
	// undefined behavior: var1 gets initialized before var2.
	// -> var2 is read before initialized
	dangerous_struct(int arg) : var2{arg}, var1{var2} {}
	
	int var1;
	int var2;
};
```


Note however, that it *is* allowed to initialize data-member from already initialized other
data-members.

Methods
-------

OK, so we are now able to read and write member-variables and initialize them via constructors. If we
think about it, a constructor is just a special function that is part of the struct and their is no
real reason to disallow other functions being part of structs.

These functions are called “member-functions” by the C++-standard, but are often referred to as
“methods” by programmers. One advantage of using methods over free functions is that methods are
tightly associated with a certain object and may therefore state the intent in a clearer way (we will
learn more advantages as we will learn more about structs and classes).

So, how do we create them and how do we use them? Let's say we want to have a convenient way of getting
a string that represents our point:

```cpp
#include <iostream>

struct point {
	point(double x, double y, double z) : x{x}, y{y}, z{z} {}
	
	// note that the instance of point is passed implicitly
	std::string to_string() const {
		// as in the constructor we can access all data-members without
		// qualifying the instance of point:
		return '(' + std::to_string(x) + ", " + std::to_string(y)
				+ ", " + std::to_string(z) + ')';
	}
	
	double x = 0.0;
	double y = 0.0;
	double z = 0.0;
};

int main() {
	point p{1,2,3};
	std::cout << "p: " << p.to_string() << '\n';
}
```
```
>> p: (1.000000, 2.000000, 3.000000)
```

So we just write a function inside the class and call it by picking an instance of the class and
append the function-call with a ‘.’ to it:

```cpp
object.method(arguments)
```

The overall effect of this is somewhat similar to a free function that takes a reference to the object
as first argument and is called like this:

```cpp
function(object, arguments)
```

At this point we face a problem: We learned earlier that we should usually pass arguments as const
references if reasonably possible. But since the instance of the methods class is passed implicitly we
cannot annotate it directly. This is why the `to_string` method in our point-class has “const” at the end
of it's signature: This annotates publicly that the method won't change anything in the class. If we
really *want* to change the class, we just don't add it.

So, when should we use a method instead of a free function?

* If you mutate the internals of a struct or class, use a method.
* If the whole point of the operation is accessing internals of a struct, use a method.
* If the operation involves multiple objects and none of them is clearly the dominant subject, use a
  function.
* If the operation is not an important part of the struct or class, a function is often the better way:
  If you implement a class for numbers, make sinus a function, not a method.

Note that these are guidelines, not fixed rules, and that we will learn about further reasons to decide
one way or the other as we go on.

Classes
-------

Let's say that at this point we decide, that cartesian coordinates (x, y z) are boring and decide to
use [polar-coordinates](https://en.wikipedia.org/wiki/Polar_coordinate_system) instead. Polar
coordinates consist of two angles that point into a direction and a distance:

```cpp
#include <iostream>

struct polar_point {
	polar_point(double h, double v, double dist): h_angle{h}, v_angle{v}, distance{dist} {}

	double h_angle = 0.0;
	double v_angle = 0.0;
	double distance = 0.0;
};

int main()
{
	polar_point p{0.0, 0.0, 123};
	std::cout << "distance to origin: " << p.distance << '\n';
}
```
```
>> distance to origin: 123
```

Let's assume that the angles are represented as radians. Also we want the distance to never be
negative (in that case we would adjust the angles). This creates problems: A careless user of our point
could easily create an invalid state. The solution for this is to restrict the access to the members:
Only methods should be allowed to touch them directly. Everyone else should only be allowed to interact
with them via methods. This can achieved by making them *private*:

<!---TODO: M\_PI is not standard. better solutions?-->

```cpp
#include <cmath> // for M_PI
#include <exception> // for termiante() 
#include <iostream>

struct polar_point {
	polar_point(double h, double v, double dist):
			h_angle{h}, v_angle{v}, distance{dist} {}

	double get_h_angle() const {return h_angle;}
	double get_v_angle() const {return v_angle;}
	double get_distance() const {return distance;}

	void set_distance(double dist);
	void set_h_angle(double angle);
	void set_v_angle(double angle);

private:
	double h_angle = 0.0;
	double v_angle = 0.0;
	double distance = 0.0;
};

void polar_point::set_distance(double dist) {
	if(dist >= 0) {
		distance = dist;
	} else {
		std::terminate();
	}
}

void polar_point::set_h_angle(double angle) {
	if(angle >= 0 && angle < 2* M_PI) {
		h_angle = angle;
	} else {
		std::terminate();
	}
}

void polar_point::set_v_angle(double angle) {
	if(angle >= 0 && angle < 2* M_PI) {
		v_angle = angle;
	} else {
		std::terminate();
	}
}

int main()
{
	polar_point p{0.0, 0.0, 123};
	p.set_h_angle(3.5);
	p.set_v_angle(2.7);
	std::cout << "distance to origin: " << p.get_distance()
	          << ", angles: " << p.get_h_angle() << ", " << p.get_v_angle() << '\n';

	// this would make the program crash safely, before worse things could happen:
	//p.set_h_angle(42);
}
```
```
>> distance to origin: 123, angles: 3.5, 2.7
```

While terminate is still a harsh way of handling errors (later on exceptions will make this cleaner),
we can now be sure that nobody will touch our privates and bring them into a bad state.

To reiterate: Everything in a struct that comes after `private:` cannot be accessed from outside of the
struct. In order to get back to the initial behavior, we can put a `public:` in the same way into the
struct. There are some further details to this, but none that are currently important.

At this point we can introduce classes. Basically a class is the same as a struct with the single
exception that everything in it is by default private instead of public. While this is the only
technical difference the important difference lies in the usage-conventions. Basically all existing
coding-standards agree that everything that consists of more than a few trivial public members and
maybe some simple methods should be a class. Since it is generally considered a good idea to put the
public interface first this ends up with the somewhat ironic situation that most classes start with
`public:`.

Let's look at a simple example:

```cpp
#include <iostream>

class some_class {
public:
	some_class(int val): mem{val} {}
	
	int get_mem() const {return mem;}
	void set_mem(int val) {mem = val;}
private:
	int mem;
};

int main() {
	some_class foo{4};
	std::cout << foo.get_mem() << '\n';
}
```
```
>> 4
```

We see that there really isn't much special about it. Nevertheless we'll use `class` instead of
`struct` for most of our types from now on (with the exception of types that basically are only a
collection of some values without fancy stuff).

Destructors
-----------

A constructor is a function that is called upon the construction of an object to initialize it's state
correctly. Many languages have this feature. C++ is however one of the relatively few languages that
also have the opposite: A destructor.

A destructor is a function that will run whenever an object ceases to exist. It's main purpose is to
clean up any resources that the object might own in. Consider std::vector<int>: It is a class that
manages an arbitrary amount of integers; these have to be stored somewhere in memory and when the
vector gets destroyed, the memory has to be returned to the system. The later is done in the
destructor:

```cpp
#include<vector>

int main() {
	std::vector<int> vec; // empty vector, uses little memory
	for(int i = 0; i < 10000; ++i) {
		// fill with 10000 integers, using increasing amounts of memory
		vec.push_back(i);
	}
	// at this point we have 40KB of memory in use. However: Once we leave the function,
	// std::vectors destructor will free this memory implicitly
}
```

Now, how is a destructor created? Basically it is just a method of the class that has no returntype
and the name “~classname”, for instance:

```cpp
#include <iostream>

class myclass {
public:
	myclass(int i): i{i} {std::cout << "Hello from #" << i << '\n';}
	~myclass() {std::cout << "Goodbye from #" << i << '\n';}
private:
	int i;
};

int main() {
	myclass object1{1};
	myclass object2{2};
}
```
```
>> Hello from #1
>> Hello from #2
>> Goodbye from #2
>> Goodbye from #1
```

As we see the objects that are constructed first get destructed last. This is guaranteed by the
standard and quite important: Assume we want acquiring multiple resources, where some cannot exist
without others already existing; thanks to the guaranteed order of destruction no object will cease
to exist while other, later constructed ones, might still need it. 

We will learn more about this technique in later chapters, for now it should be enough to know, that it
is called “*'Resource Acquisition Is Initialization*'” (RAII) and that it is one the most important
techniques of C++. Some people call it C++'s greatest feature.

Summary
-------

In this chapter we learned how to create custom types. For a simple collection of values, we can use
simple structs, if we need something more advanced, a class with private members and methods is usually
a better solution.

Classes and structs can have member-functions (so called methods) of which constructors and destructors
take a special role since they create/destroy the object.
