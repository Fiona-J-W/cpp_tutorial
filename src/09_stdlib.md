The Standard-Library
====================

At this point we understand enough about the core-language in order to take a look at the
standard-library. Until now we have already made use of things like the io-facilities, `std::vector`
and `std::string`. This chapter will now try to get a somewhat more systematic view of what is already
offered and how it can be used to it's best effect.

While the standard-library of C++ is much smaller than the ones of some other languages, it is still
to big to learn completeley in one attempt. It is therefore strongly recommended to occasionaly take
some time and go reading references; sometimes one will come across real gems where there were none
expected.

Containers and Iterators
------------------------

Whenever we needed an arbitrary amount of elements so far, we resorted to `std::vector` without looking
to deep into it's concepts and features. We already saw that we can copy them, request an element at
a certain index, iterate over all elements and insert at the end:

```cpp
#include <iostream>
#include <vector>

int main() {
	std::vector<int> vec = {1, 2, 3};
	vec.push_back(4);
	for (auto&& elem: vec) {
		std::cout << elem << '\n';
	}
	auto vec2 = vec; // copy
}
```
```
>> 1
>> 2
>> 3
>> 4
```

Usually `std::vector` is exactly what we want, but sometimes we would like to use different
data-structures, because they are faster or have otherwise different semantics. The most important
container aside from `std::vector` is probably `std::array` from the `<array>`-header. It is basically
like `std::vector` except that the size is fixed at compile-time which implies that methods like
`push_back` or `pop_back` do not exist for it. In exchange it can be faster, especially for very small
element-counts.

Another container from the stdlib is `std::list`. It is a so called doubly-linked-list and allows
relatively cheap insertion in the middle of the sequence in exchange for much slower iteration and
insertion at the end. In many real-world problems it is a much worse alternative compared to `std::vector`
so you really shouldn't use it, unless **measuring(!)** shows that `std::vector` is the bottleneck for
some problem and `std::list` vastly improves this.

The reason for looking into `std::list` is at this point however not to actually use it, but because
it points us to a problem that we didn't have so far: Since we cannot access an element in the middle
of a list efficiently, the classtemplate doesn't offer us `operator[]`  or `at()`. Instead it forces us
to use the way more general *iterators*.

Iterators are C++'s answer to the question how to represent a generic range. An iterator is basically
an object that points to a certain object in a sequence. We can retrive that object or move the iterator
on. For starters, let's look at the iterators of `std::vector`:

```cpp
#include <iostream>
#include <vector>

int main() {
	std::vector<std::string> vec = {"foo", "bar", "baz"};
	
	// get an iterator that points to the first element
	// in the vector (1):
	std::vector<std::string>::iterator it = vec.begin();
	
	// retrive the element that the iterator points to
	// using the dereferencing-operator '*':
	std::cout << *it << '\n';
	
	// since the iterator is not constant we can assign
	// new values through it too:
	*it = "meow";
	std::cout << *it << '\n';
	
	// finally we can move the iterator to the next element
	// using the increment-operator:
	++it;
	std::cout << *it << '\n';
	
	// To call a method on the referenced object, we can
	// either dereference it  first or just use the
	// arrow-operator:
	std::cout << (*it).size() << ", " << it->size() << '\n';
	
	// finally we can compare iterators:
	if (it != vec.begin()) {
		std::cout << "it doesn't point to the first "
		             "element anymore.\n";
	}
	if (it == ++(vec.begin())) {
		std::cout << "it does instead point to the second.\n";
	}
}
```
```output
>> foo
>> meow
>> bar
>> 3, 3
>> it doesn't point to the first element anymore.
>> it does instead point to the second.
```

Most of the above operations are supported by all iterators. The exceptions
for this rule are comparission and ironically the methods to access the value:
Some iterators only allow reading, but not writing those, others only allow
writing, but not reading. Most however allow both.

Another possible limitation is that we are not allowed to make a copy of
the iterator, increment the original and then use the copy:

```cpp
// this may be illegal for some iterators:

auto original_iterator = get_output_iterator();
auto copy = original_iterator;

++original_iterator;
++copy;
```

Since this is quite complicated but doesn't help with understanding the
basic ideas and concepts, let's put these iterators aside for a moment
and focus on those that do allow these things.

We call these *forward-iterators* since they allow us to traverse a sequence
in a “forward order”.

Forward-iterators are split into two categories: Const and mutable
iterators. As the names suggest, you are not allowed to change
a value through a const-iterator and the compiler enforces this.
Obviously it is a good idea to prefer them to mutable iterators, *if*
this is possible.

Now, sometimes we want to do more than just access all elements of a sequence
in ordern. A very simple thing that we might wish in addition is to move backwards.
This is where *bidirectional-iterators* come into play.

A bidirectional-iterator allows us to move backwards by using the
decrement-operator; this is by the way the kind of iterator that `std::list` offers:

```cpp
std::list<int> my_list = {1, 2, 3, 4, 5};
// to get an iterator to the first element, we call .begin():
auto it = list.begin(); // it -> 1
++it; // it -> 2
++it; // it -> 3
--it; // it -> 2
--it; // it -> 1
```

So far, so unsurprising. It should also be noted, that we are always allowed
to use the post-increment/decrement-operator, when we are allowed to use
the pre-versions.

Before we move on to the most powerfull iterator-category, let's take a look
at how we can use iterators to represent a range.

Obviously we need two iterators to do this: One to indicate the begining
of the range and one to indicate the end. The obvious choice for this would
be to use an iterator to the first element as start, and an iterator
to the last element as end. This would hovever lead to several problems, one
being that we could not represent an empty range.

The solution to this problem is that we use a so called half-open range: The first
iterator points to a valid element, but the last one points one element past
the last valid one. If the range is empty, both iterators are equal. Let's
take a look at this:

```cpp
#include <list>

int main() {
	std::list<int> lst;
	
	// .end() returns the past-the-end-iterator:
	if (lst.begin() == lst.end()) {
		std::cout << "The list is emtpy.\n";
	}
	
	lst.push_back(23);
	
	if (lst.begin() != lst.end()) {
		std::cout << "The list is not empty.\n";
	}
	
	// this is how we can use iterators to iterate over
	// all elements of a sequence:
	for (auto it = lst.begin(); it != lst.end(); ++it){
		std::cout << *it;
	}
}
```
```output
>> The list is empty.
>> The list is not empty.
>> 23
```

Now that we have seen that it is time to look at the most powerfull
iterators of all: *Random-access-iterators*.

Random-access-iterators are iterators that allow moving more then one
element in either direction and have the ordering-comparission-operators in
addition to the equality-operators. Let's take a look at all these things in
order.

In order to move a random-access-iterator more than one element, we use the
normal arithmetic operators (plus and minus):

```cpp
// the iterators of std::vector provide random-access,
// which is one of many reasons why std::vector is so
// awsome:
std::vector<int> vec = {0, 1, 2, 3, 4, 5, 6};

auto it = vec.begin(); // it -> 0
it += 3; // it -> 3
it -= 1; // it -> 2

// note that we can add negative offsets:
it += -2; // it -> 1

auto it2 = it + 3; // it2 -> 4
it2 += 3; // it2 = past-the-end-iterator
```

Concerning the comparission: In general we are only allowed to compare
iterators that are part of the same range for anythying but equality. As
one might expect, the iterators to elements that come earlier in a sequence
compare smaller to iterators to later elements:

```cpp
std::vector<int> vec = {0, 1, 2, 3, 4, 5, 6};

auto it1 = vec.begin();
auto it2 = it1 + 3;

assert(it1 < it2);
```

Before you continue, you should make sure, that you have understood at least
the basic concepts of iterators, since large parts of the standard-library are
basically built around them. Let's take a look at some examples for that:

* If we want to concatenate the contents of a container to a `std::vector`, we use iterators
  for that: `vec.insert(vec.end(), other_container.begin(), other_container.end());`
* If we want to write our own container and want it to be usable with range-`for`,
  all we need to do is implement iterators and the appropriate `.begin()` and `.end()`
  member-functions.
* Whenever the standard-library provides functionality that is intended to be used
  with sequences, it works on iterators.

Algorithms
----------

Tuples and Pairs
----------------



Threads and Atomics
-------------------


Random Numbers
--------------


Time and Clocks
---------------


