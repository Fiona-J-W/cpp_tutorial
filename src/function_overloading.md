Function Overloading
====================

After having learned about both `const` and references, we now know enough about passing arguments into
functions to get pretty far. While there are some (relatively strange) other ways of doing that, the
importance for most programmers to know about them is very small, as they are mainly relevant to those
people who implement C++ itself. Since we are currently far away from doing this, we'll move that topic
to the distant future and instead take a look at something that is useful for everyone instead:
Overloading functions.

Careful readers may have noticed in the introduction to functions, that the naming-requirements did not
explicitly include, that the name has to be unique. That is because it isn't. Functions are identified
not only by their names, but also by their arguments. If the arguments of two functions differ in
number or type it is valid for them to share a name.

```cpp
#include <iostream>

void function(int n) {
	std::cout << "function(int " << n << ");\n";
}

void function(double d) {
	std::cout << "function(double " << d << ");\n";
}

int main() {
	function(3);
	function(2.718);
}
```

----

```
function(int 3);
function(double 2.718);
```

Revisiting `smallest_element()`
-------------------------------

In order to get used to this technique, we'll revisit our old companion `smallest_element()`. While the
current version is already pretty good, we might be interested in a related but not identical function
for strings: Find the smallest character. In order to keep this somewhat interesting, we'll define that
a lowercase character is always smaller than an uppercase one and characters that come earlier in the
alphabet are smaller than those that come later.

To keep this task manageable, we'll restrict ourselves to the characters of the English alphabet and
ignore all other ones. Let's take a look at the code:

<!---TODO: Should discourage passing containers, such as std::vector, as they have other templated
parameters which you would have to account for.-->

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <locale> // required for isupper and islower

// the old version for vectors of ints
int smallest_element(const std::vector<int>& vec) {
	auto smallest_value = vec[0];
	for (auto x: vec) {
		if (x<smallest_value) {
			smallest_value = x;
		}
	}
	return smallest_value;
}

// the new version for strings
// return 0 if no character is found
char smallest_element(const std::string& str) {
	std::locale l{}; // required for isupper and islower
	char smallest_char = 0;
	bool result_is_lowercase = false;
	for (char c: str) {
		if (std::islower(c, l)) {
			if(smallest_char == 0 || !result_is_lowercase || c < smallest_char) {
				smallest_char = c;
				result_is_lowercase = true;
			}
		}
		else if (!result_is_lowercase && std::isupper(c, l)) {
			if(smallest_char == 0 or c < smallest_char) {
				smallest_char = c;
			}
		}
	}
	return smallest_char;
}

int main() {
	std::cout << "the smallest character of 'Foobar' is '"
	          << smallest_element("Foobar") << ''\n'
	          << "the smallest number of 1, 3, 6, -3, 4 and 2 is: "
	          << smallest_element(std::vector<int>{1, 3, 6, -3, 4, 2})
	          << '\n';
}
```

----

```
the smallest character of 'Foobar' is 'a'
the smallest number of 1, 3, 6, -3, 4 and 2 is: -3
```

While the new code may not be very beautiful, it shows that there is no problem with creating two
different functions that share a name and an abstract behavior (finding the smallest element
in some kind of list) but differ in implementation.
