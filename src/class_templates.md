Class-Templates
===============

In the last chapter we created a struct for Cartesian points:

```cpp
#include <iostream>

struct point {
	point(double x, double y, double z) : x{x}, y{y}, z{z} 
	{}

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

This still works great, but their is one problem: What should we do, if we want a point that only
consists of integral coordinates? Or with floats instead of doubles? Or with complex numbers?

The obvious and bad solution would be to create one struct for each and give them different names like
“`point_f`”, “`point_i`” and so on. This is repetitive, boring, error-prone and therefore hard to
maintain. Especially since the only difference in these structs will be type of the values.

To solve this problem C++ has so called class-templates (they work with structs too). So if we want a
point-class for every type T, we can just write this:

```cpp
#include <iostream>

template<typename T>
struct point {
	// use const-references because T might be a 'heavy' type:
	point(const T& x, const T& y, const T& z) : x{x}, y{y}, z{z} {}
	
	T x = 0;
	T y = 0;
	T z = 0;
};

int main()
{
	point<int> p_int{1,2,3};
	std::cout << "p_int: " << p_int.x << '/' << p_int.y << '/' << p_int.z << '\n';
	
	point<float> p_float{1.5,2.3,3.2};
	std::cout << "p_float: " << p_float.x << '/' << p_float.y << '/' << p_float.z << '\n';
}
```
```
>> p_int: 1/2/3
>> p_float: 1.5/2.3/3.2
```

This is not really different from writing normal functions so far, so let's see how we can create
methods.

If we implement the method directly in the class, there is no difference at all. If we want to
implement it outside of the class, there are two small changes:

* Instead of `foo::bar()` we have to write `template<typename T> foo<T>::bar()` in the signature,
since there is now more than one class called foo.
* The implementation must be available to every user (and since not be put into another file). Since
we haven't yet grown out of just using one file, this is currently no big deal.

Let's see an example:


```cpp
#include <iostream>

template<typename T>
struct point {
	point(const T& x, const T& y, const T& z) : x{x}, y{y}, z{z} {}
	
	T x = 0;
	T y = 0;
	T z = 0;
	
	//definition in class-template:
	void print() {
		std::cout << x << '/' << y << '/' << z << '\n';
	}
	
	// definiton outside
	void reset();
};

template<typename T>
void point<T>::reset() {
	x = 0;
	y = 0;
	z = 0;
}

int main() {
	point<int> p{1,2,3};
	p.print();
	p.reset();
	p.print();
}
```
```
>> 1/2/3
>> 0/0/0
```


That is basically it. There really shouldn't be any surprises so far. We will learn more about this
mechanism in the future, for example how we can create special versions for certain instantiations and
why this mechanism is way more powerfull than it currently appears.
