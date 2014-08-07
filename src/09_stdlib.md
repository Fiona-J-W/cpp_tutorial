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
>>> 1
>>> 2
>>> 3
>>> 4
```


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
