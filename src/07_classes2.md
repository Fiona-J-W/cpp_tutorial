Datatypes
=========

In this chapter we will write a simple text-game in which we will visit a deep dungeon to search
for great treasures and to fight evil monsters and even more evil competitors. Along the way
we will learn how to create our very own datatypes and also make ourselves familiar with some
further stdlib-functionality.

Preparing the Loot: Enums and Structs
-------------------------------------

Starting with the creation of a player is boring, if we could instead be creating our
freakingly-huge-sword-of-doom, so let's get to the loot first!

In our dungeon we expect four kinds of loot: Armor, weapons, jewelry and junk. We could now use an
integer and some global constants to anotate what each item is, but the nice thing is that C++ already
provides this in a more convenient way as a so called enum:

```cpp
enum class item_kind {
	armor,
	weapon,
	jewelry,
	junk
};

std::string to_string(const item_kind& kind) {
	if (kind == item_kind::armor) {
		return "armor";
	} else if (kind == item_kind::weapon) {
		return "weapon";
	} else if (kind == item_kind::jewelry) {
		return "jewelry";
	} else if (kind == item_kind::junk) {
		return "junk";
	} else {
		std::cerr << "This should never happen!\n";
		std::terminate();
	}
}

int main() {
	const auto find_1 = item_kind::armor;
	const auto find_2 = item_kind::junk;
	std::cout << "Our first find is " << to_string(find_1)
		<< ", our second find is" << to_string(find_2) << '\n';
}
```

The advantage of this approach over integer-constants is that we have our own type,
which, among other things, implies that we can overload functions for it and, that it
became harder to accidentially use a different integer that was supposed to mean
something else where we wanted to know what kind of item our find is.

To show a real-live situation where types are used, we don't need to look far: From the first
grade on pupils are forced by their teachers and parents to not throw away things like meters,
seconds, liters, … when doing exercises for school and get ask questions like: “Three what?
[Bratwürste](https://en.wikipedia.org/wiki/Bratwurst)?” (Or at least the author of this text
got this question). The reasoning is again that keeping this kind of information can easily expose
a lot of errors in the used formulas or during calculation.

An dramatic example for what can happen if you do not use types is the
[Mars Climate Orbiter](https://en.wikipedia.org/wiki/Mars_Climate_Orbiter): It got to close to the
surface because one module incorrectly produced results in imperial measures,
while another one expected those to be in a sane (=metric) unit-system. The lessons from this
incident are:

* Never use the imperial system and allways use the metric system
* Do your calculations with units, as you learned in first grade.

Now, back to our loot: We want to be able to add further information
too it, so that we can have different kinds of it.


