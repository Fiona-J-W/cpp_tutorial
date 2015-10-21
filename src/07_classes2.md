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

A dramatic example for what can happen if you do not use types is the
[Mars Climate Orbiter](https://en.wikipedia.org/wiki/Mars_Climate_Orbiter): It got to0 close to the
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
	// as the struct and no explicit return-type:
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

This works great will do so most of the time, but for completeness sake, let's
see what our constructor really does: It initializes members with the arguments that
we passed it. This is a very common thing, so there is some special alternative syntax:
for it:

```cpp
item::item(const std::string& n, int v, item_kind kind): // note the colon
	name{n}, // constructs the member name by copying the argument n
	value{v},
	kind{kind} // Here we can actually ignore name-clashes to a certain degree
{} // The constructor still needs a body, but quite often it can be empty
```

The main-advantage of this method is that it allows us to controllthe actual
construction of the member instead of having it default-constructed just so that
we can reassign a new value to them. (This may seem irrelevant now, but we will
come across types where this will really matter.)

Another advantage is that most experienced programmers will consider it cleaner and
easier to understand at a glance.

There are however some traps:

* The members will always be initialized in the order in which they are declared
  inside the struct, not in the order that is used in the initialization-list
  (which is the name that these constructor-calls outside the body have).
* The expressions to initialize a value may refer both to other struct-members
  as well as to the constructor arguments. **Never** refer to struct-members
  that are declared behind the member that you currently initialize, since that
  is a very bad case of **undefined behavior**.
* The expressions may also be more complex than just copying a value, basically
  everything one wants to do can be done in them (this doesn't mean everything
  that can be done in them *should* be done in them).

Some further examples:

```cpp
struct example_1 {
	// this is how you define a constructor inline:
	example_1(const std::string& str): str{str} {}
	std::string str;
};

struct example_2 {
	// we can also pass multiple arguments to the constructor,
	// this will create a string that holds n occurences of c:
	example_2(char c, std::size_t n): str(n, c) {}
	std::string str;
};


struct example_3 {
	// Mixed order: This specific instance will work,
	// but don't do that!
	example_3(int i1, int i2): i2{i2}, i1{i1} {}

	// This would  be undefined behavior because i2 is
	// read before it is initialized. NEVER do that!!

	//example_3(int i): i2{i}, i1{i2} {}

	int i1;
	int i2;
};
```

Drops and Random Numbers
------------------------

Since we have now defined how we would like to represent the games items, we
need a list of them. For the meantime we don't want to change what items are
available, so a global constant is perfectly fine here:

```cpp
// just put this into the global scope:
const auto items = std::vector<item>{
	// the language knows that we want to call the
	// constructor here, so there is no need to
	// type the name again and again:
	{"Cheap Sword", 100, item_kind::weapon},
	{"Sword", 500, item_kind::weapon},
	{"Sword of Doom", 10000, item_kind::weapon},
	{"Mail", 500, item_kind::armor},
	{"Necklace", 5000, item_kind::jewelry},
	{"Dirt", 0, item_kind::junk},
	{"toxic Dirt", -100, item_kind::junk}
};
```

Now we need a function that returns a random item:

```cpp
item random_item() {
	const auto item_index = ????
	return items[item_index];
}
```

Obviously we need some way to get a random number. There are several
ways to achieve that in C++ and most of them are bad for various reasons.
Even though it may look a bit like overkill at first, we will use the right
way from the beginning, because the supposedly simpler (because they are usually
wrong) ways won't save us from learning the right way at some point, they
just postpone it.

The very first thing we have to do in order to use the random-facilities is including
the `<random>`-header. After that we will have a lot of partially hard to
understand things at our hands, most of which we don't need now (this doesn't
mean that it isn't usefull or good, it's just for more advanced tasks). What
we should understand at first is that C++ separates the notions a random-number-generator
and a random distribution. Now, what is the difference between those two?

A real-life example may be a good way to explain it: Say we want to pick a
random number between one and three (1, 2 or 3), but we only have a coin to
produce random bits (zero or one). In order to avoid bias when selecting a
number we now have to think up an algorithm of how to throw the coin multiple
times to select any of those three numbers with the same propability.

What we will do is to throw the coin two times and memorize the results. There are now
four possiblities for the result:

* twice heads -> we pick 1
* twice tails -> we pick 2
* first head, then tail -> we pick 3
* first tail, then head -> If we pick anything in this case,
  we will favor that, so we won't pick anything but redo the whole thing from the
  beginning with new random numbers.

In this case, the coin serves as a random-number-generator, while our algorithm
creates a distribution of random-numbers. Obviously a distribution needs access
to a random-number-generator and has to be able to use it arbitrarily often.

C++ offers us both several random-number-generators as well as several distributions,
for now it should be sufficient to know two of them:

* `std::random_device` this random-number-generator produces unpredictable
  high-quality random numbers, but it may potentially be slow. For our purposes
  it is by far fast enough though, so we shouldn't worry about that.
* `std::uniform_int_distribution<Integer>` This distribution produces random
  integers of the specified type in a range that can be specified by the user,
  where every possible value will be choosen with the same likelyhood.

So how do we use it? Basically we will create a variable of each type and use
the distribution as a function that recieves the generator as the only argument.
It may sound strange, but in C++ we can actually create types that behave like
functions in some circumstances and this is one example:

```cpp
#include <random>

int main() {
	// std::random_device is one of the
	// few types in c++ that doesn't allow the creation
	// of instances with 'auto name = type{};', so we
	// have to do it like this:
	std::random_device rd;
	// this will create random numbers between 23 and 42 inclusive.
	// In other words: 23 and 42 may very well be created too:
	auto dist = std::uniform_int_distribution<int>{23, 42};
	std::cout << dist(rd) << '\n';
}
```

Executing this multiple times should yield different results, where each is equally likely.

In order to use this for our item-selection we will create a small helper-function that
creates a random-index for a container of size `n`:

```cpp
#include <iostream>
#include <cstdint>

std::size_r random_index(std::size_t container_size) {
	std::random_device rd;
	// we need to decrement the container size, since it isn't a valid index itself!
	auto dist = std::uniform_int_distribution<std::size_t>{0, container_size - 1u};
	return dist(rd);
}
```

After that we can implement our item-selection again:

```cpp
item random_item() {
	return items[random_index(items.size())];
}
```

Putting everything that we have so far together into a program in which
we kick in ten doors and loot everything of value that we find behind
them, we get this:

```cpp
#include <cstdint>
#include <iostream>
#include <random>
#include <string>
#include <vector>

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

struct item {
	item(const std::string& name, int value, item_kind kind);
	std::string name;
	int value = 0;
	item_kind kind = item_kind::junk;
};

item::item(const std::string& n, int v, item_kind kind):
	name{n}, value{v}, kind{kind} {}

const auto items = std::vector<item>{
	{"cheap Sword", 100, item_kind::weapon},
	{"Sword", 500, item_kind::weapon},
	{"Sword of Doom", 10000, item_kind::weapon},
	{"Mail", 500, item_kind::armor},
	{"Necklace", 5000, item_kind::jewelry},
	{"Dirt", 0, item_kind::junk},
	{"toxic Dirt", -100, item_kind::junk}
};

std::size_t random_index(std::size_t container_size) {
	std::random_device rd;
	// we need to decrement the container size, since it isn't a valid index itself!
	auto dist = std::uniform_int_distribution<std::size_t>{0, container_size - 1u};
	return dist(rd);
}

item random_item() {
	return items[random_index(items.size())];
}

int main() {
	auto backpack = std::vector<item>{};
	for (auto i = 0u; i < 10u; ++i) {
		std::cout << "Kicking in door " << i << "...\n";
		const auto item = random_item();
		std::cout << "We found '" << item.name << "' ";
		if (item.value > 0) {
			std::cout << "and loot it!\n";
			backpack.push_back(item);
		} else {
			std::cout << "and discard it because it isn't worth anything.\n";
		}
		std::cout << "We now have " << backpack.size() << " item(s) in our backpack.\n";
	}
}

```

Classes
-------

Now that we are able to loot, it is time to create the characters
(both the player and NPCs). For the start every character has to have
a name, a current health-level and a maximum health_level.

A simple implementation might look like this:

```cpp
struct character {
	character(const std::string& name, unsigned health = 100u, max_health = 100u):
		name{name}, health{health}, max_health{max_health} {}
	std::string name;
	unsigned health = 100u;
	unsigned max_health = 100u;
	// invariant: health <= max_health
};
```

This will work, but the problem is, that due to the fact that everyone can
access everything, it would be easy to either increase `health` over `max_health` or,
even worse, decrease it below zero which will have it wrap around to a gigantic value.

The solution to this are of course methods that will add all those checks and cut the
de/increase of (if a character has zero health it is dead, there is no point in negative health):


```cpp
struct character {
	character(const std::string& name, unsigned health = 100u, max_health = 100u):
		name{name}, health{health}, max_health{max_health} {}
	void heal(unsigned strength);
	void injure(unsigned strength);
	std::string name;
	unsigned health = 100u;
	unsigned max_health = 100u;
	// invariant: health <= max_health
};

void character::heal(unsigned strength) {
	// This is the explicit way to do
	// the check:
	if (health + strenth > max_health) {
		health = max_health;
	} else {
		health += strenth;
	}
}

void character::injure(unsigned strength) {
	// and this is the elegant, nice
	// way to do it:
	health -= std::min(health, strength);
	// Exercise: how can heal be implemented better?
}
```

However, this still doesn't prevent fiddling with those values from
the outside, it only offers a better alternative. Since a lot of
programmers tend to be not diciplined well enough only to use those,
the language offers us a way to ensure that they won't do it by
accident or lazyness: Access specifiers.

These are are annotations to areas in our struct that tell whether everyone
or only it's methods may access those parts of it. The two access-specifiers
that we care about are “`public`” and “`private`” (there is also one
called “`protected`”, but it has few uses, especially at this point).

As one may guess `public` means that those things can be accessed by everyone,
while `private` things are only for the class itself. Let's see an example:


```cpp
struct character {
public: // everything that follows is public, which is the default in structs
	character(const std::string& name, unsigned health = 100u, max_health = 100u):
		name{name}, health{health}, max_health{max_health} {}

	void heal(unsigned strength);   // the implementation of the methods doesn't
	void injure(unsigned strength); // change at all, so there is no need to repeat them

private: // everything that follows is private and can only be accessed from above methods
	std::string name;
	unsigned health = 100u;
	unsigned max_health = 100u;
	// invariant: health <= max_health
};
```

The problem now is that while we have prevented bad fiddling with the internals from the outside,
we can no longer read the values, which really wouldn't be a problem. The solution to this is to
add some more methods that return the values that we consider acceptable for everyone else to see.

The question here is of course, how to name them? If we have a member named `health`, we cannot
have a method with the same name as well. The best answer to that problem is to prefix all private
members with `m_` (‘m’ like in “member”) and call the methods as the member was called before.
Another reason to do that, is that it improves readability of a methods implementation, since
there can no longer be confusion about where some variable comes from: If it is prefixed, it is
part of the class, otherwise it is local to the function.


```cpp
struct character {
public:
	character(const std::string& name, unsigned health = 100u, max_health = 100u):
		name{name}, health{health}, max_health{max_health} {}

	void heal(unsigned strength);
	void injure(unsigned strength);

	// accessor-methods should not change the state, so make them const:
	unsigned health() const {return m_health;}
	unsigned max_health() const {return m_max_health;}
	// To avoid unneeded copies, it is acceptable to return constant references as well:
	const std::string& name() const {return m_name;}
private:
	std::string m_name;
	unsigned m_health = 100u;
	unsigned m_max_health = 100u;
	// invariant: health <= max_health
};
```


At this point out struct has gotten relatively complex, when compared to the simple collection
of values that they can also be used as. In fact we have long reached a point where common
convention among C++-programmers is to use a `class` instead. The good news is that this is
almost exclusivly convention and the change in our example only involves replacing the `struct`-keyword
with `class`. The only technical difference between those two are that members are by default
`public` in a struct and `private` in a class. Once we add `public:` to the first line
of our class they are basically identical.

Why would we use classes at all then? The answer to that is that it allows
to state the intent that some datatype is either just a simple collection of values
(→`struct`) or a little bit more complex (→`class`). The summary really is that if your type
consists of anything aside a couple of public data-members (and possibly a few very
simple constructors), make it a `class`.

So let's change that part of our character, and while we are at it, we might also add another method: `attack`


```cpp
class character {
public:
	character(const std::string& name, unsigned health = 100u, max_health = 100u):
		name{name}, health{health}, max_health{max_health} {}

	void heal(unsigned strength);
	void injure(unsigned strength);

	void attack(character& other);

	unsigned health() const {return m_health;}
	unsigned max_health() const {return m_max_health;}
	const std::string& name() const {return m_name;}
private:
	std::string m_name;
	unsigned m_health = 100u;
	unsigned m_max_health = 100u;
	// invariant: health <= max_health
};

void character::heal(unsigned strength) {
	// solution to the question how heal can be implemented better:
	m_health = std::min(m_health + strength, m_max_health);
}

void character::injure(unsigned strength) {
	m_health -= std::min(m_health, strength);
}

void attack(character& other) {
	// We will make the damage-calculation
	// much more sophisticated over time,
	// but for now this is enough:
	other.injure(5);
	// Note that we could also have accessed other.m_health
	// directly, because we are in a method of character.
	// private refers to classes, not instances of classes!
}
```

