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

Obviously each piece should have at least have name that describes it
and a value in goldpieces. Carrying those informations arround manually
by passing them around as additional arguments would however be very
cumbersome. The good news is that C++ provides us a way to create a new type
that is basically just a collection of different values: A `struct`:

```cpp
struct item {
	std::string name;
	int value; // some pieces might be so terrible that you have to pay people to take them
	item_kind kind;
}; // note the ';', it is important!
```

This defines a new type `item` that will safe us from all the trouble by making sure that it contains
all the information we might ever need. The syntactic requirements to create such
a thing should be relatively obvious from the example: First you declare your
intent to define a struct by writing `struct` followed by the name it should have; after that you
declare all the variables it should hold by specifying their types and names inside a
pair of braces and finally put a semicolon there. **Do not forget that semicolon!** This is
probably the most common error that even advanced programmers make when it comes to
defining simple types.

So how can we use that? Again, by just declaring a variable of that type and using it's
members:

```cpp
int main() {
	auto find = item{};
	item.name = "Sword of Doom";
	item.value = 100'000'000; // if we have a number with a lot of digits,
	                          // we can increase readability like this
	                          // by inserting some apostrophes
	item.kind = item_kind::weapon;
	std::cout << "You just found a " << item.name << " which is worth "
	          << item.value << " golden coins!\n";
}
```

Passing it to a function or defining a function that takes an item as argument
is completely identical to how we did it up to now too:

```cpp
// try to sell your item for the specified
// amount of coins; negative offers mean
// that you are willing to pay the merchant
// for taking it
bool sell(const item& find, int offer) {
	// A merchant only buys if he get's an item for
	// less than it is worth
	return find.value > offer;
}
```

However, there is one problem: We haven't defined the default-values of
the structs members, so what are those?

Well, the sad answer is “it depends”: The types of the standard-library
will be initialized with an empty/zero state, but the build-in types like
integers will not recieve that treatment and reading them results in **undefined
behavior**! A first fix for that is to directly assign those variables a value:

```cpp
struct item {
	std::string name;
	int value = 0;
	item_kind kind = item_kind::junk;
};
```

For some types that really is all we need, but in our case it certainly is not
optimal, because what kind should an item have by default (why junk?) and what
value (why nothing?). Furthermore an empty name is not very convincing either.

For those more advanced cases, C++ offers a solution too: So called “constructors”.

Basically those are functions that create instances of the type in question. Some
are created by default and may disappear if we define others. One of the examples
for this is the implicitly created default-constructor that takes no arguments
which we implicitly used above. It will disappear the moment we define any other
constructor but can easily be brought back if we so desire. What we would like
here is however for it to stay deleted and instead we want a constructor that
takes all the requred arguments. Let's see how that works:

```cpp
struct item {
	// A constructor is a function that is declared INSIDE
	// the struct to which it belongs. It has the same name
	// as the struct and no explicit return-values:
	item(const std::string& name, int value, item_kind kind);
	std::string name;
	int value = 0;
	item_kind kind = item_kind::junk;
};

// We could have defined it right inside the class, but let's put
// it behind it, so we also know how to do that.
//
// Note that to do this, we have to specify that the 'function' we
// want to use is inside the struct item (this is somewhat similar
// to specifyin the std:: when refering to stdlib-types, though
// there are also quite a few differences):
//
// Also note again the missing return-type!
item::item(const std::string& n, int v, item_kind kind) {
	// note that we can refere to the structs members without
	// specifying anything now, but we should make sure that
	// our arguments are named different from them!
	// For that purpose it is legal (though very questionable!)
	// to give other names to the function arguments than in
	// the declaration.
	name = n;
	value = v;
	// if for some reason we have the same name or we just want
	// to be explicit that we want to talk about members, we
	// can just prepend 'this->'. Why the arrow instead of a point?
	// Well, because 'this' is a very old feature with bad behavior.
	// It is not a good thing that it is that way, but we have to accept it:
	this->kind = kind; // the argument hides the member, so we can just use it.
}
```


