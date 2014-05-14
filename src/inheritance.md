Inheritance
===========

Let's say we want to write a simple game: We have different types of fighting units with different
strength and abilities. Among them are a knight and a guard, where the knight is an offensive unit
while the guard clearly has a focus on defense: 

```cpp
#include <iostream>

class knight {
public:
	knight(): health_level{100}, defense_level{15}, attack_level{35} {}
	
	bool alive() const {return health_level > 0;}
	
	unsigned defense() const {return defense_level;}
	unsigned attack() const {return attack_level;}
	void train() {++attack_level;}

	template<typename Defender>
	void attack(Defender& defender) const {
		defender.defend(attack());
	}
	
	void defend(unsigned attack_strength) {
		if (attack_strength <= defense_level) {
			return; // no damage done
		}
		const auto actual_attack_strength = attack_level - defense_level;
		if (actual_attack_strength >= health_level) {
			health_level = 0; // warrior is dead
		} else {
			health_level -= actual_attack_strength;
		}
	}
private:
	unsigned health_level;
	unsigned defense_level;
	unsigned attack_level;
};

class guard {
public:
	guard(): health_level{100}, defense_level{30}, attack_level{20} {}
	
	bool alive() const {return health_level > 0;}
	
	unsigned defense() const {return defense_level;}
	unsigned attack() const {return attack_level;}
	void train() {++defense_level;}
	
	template<typename Defender>
	void attack(Defender& defender) const {
		defender.defend(attack());
	}
	
	void defend(unsigned attack_strength) {
		if (attack_strength <= defense_level) {
			return; // no damage done
		}
		const auto actual_attack_strength = attack_level - defense_level;
		if (actual_attack_strength >= health_level) {
			health_level = 0; // warrior is dead
		} else {
			health_level -= actual_attack_strength;
		}
	}
private:
	unsigned health_level;
	unsigned defense_level;
	unsigned attack_level;
};



int main() {
	knight black_knight{};
	guard castle_guard{};
	while (true) {
		black_knight.attack(castle_guard);
		if (!castle_guard.alive()) {
			std::cout << "The castle has fallen!\n";
			return 0;
		}
		castle_guard.attack(black_knight);
		if (!black_knight.alive()) {
			std::cout << "The castle has been defended.\n";
			return 0;
		}
	}
}
```
```
>> The castle has fallen!
```

This is quite a lot of duplicate code to create two warrior-classes that are almost identical; we also
require a member-template to implement the attack-method, which isn't actually that bad but we'll see
that there is a better solution for this one too.

If we look into the code we see that most of the properties it has are actually things that are shared
among all kinds of warriors. This is where *inheritance* comes into play.

The Basics
----------

Inheritance is a (probably badly named) technique to describe a very general thing that has a certain
set of properties and use this to implement more specialized versions. Let's look at a simple first
version:

```cpp
#include <iostream>

class warrior {
public:
	warrior(unsigned health_level, unsigned defense_level, unsigned attack_level):
		health_level{health_level}, defense_level{defense_level}, attack_level{attack_level} {}
	
	bool alive() const {return health_level > 0;}
	
	unsigned defense() const {return defense_level;}
	unsigned attack() const {return attack_level;}

	template<typename Defender>
	void attack(Defender& defender) const {
		defender.defend(attack());
	}
	
	void defend(unsigned attack_strength) {
		if (attack_strength <= defense_level) {
			return; // no damage done
		}
		const auto actual_attack_strength = attack_level - defense_level;
		if (actual_attack_strength >= health_level) {
			health_level = 0; // warrior is dead
		} else {
			health_level -= actual_attack_strength;
		}
	}
	
protected:
	unsigned health_level;
	unsigned defense_level;
	unsigned attack_level;
};

class knight: public warrior {
public:
	knight(): warrior{100, 15, 35} {}
	void train() {++attack_level;}
};

class guard: public warrior {
public:
	guard(): warrior{100, 30, 20} {}
	void train() {++defense_level;}
};

int main() {
	knight black_knight{};
	guard castle_guard{};
	while (true) {
		black_knight.attack(castle_guard);
		if (!castle_guard.alive()) {
			std::cout << "The castle has fallen!\n";
			return 0;
		}
		castle_guard.attack(black_knight);
		if (!black_knight.alive()) {
			std::cout << "The castle has been defended.\n";
			return 0;
		}
	}
}
```
```
>> The castle has fallen!
```

No matter how we look at it, this is definitely an improvement.

Some things to note at this point:

* Instead of private, the attributes of our warrior-class are `protected`; this is a mixture of
  `public` and `private` that allows inheriting classes to access these members as if they were public
  but seals the access to everyone else (private members cannot be accessed in inheriting classes).
* To create a class knight that is a special form of a warrior we write
  `class knight: public warrior{};`. This will copy all the properties of a warrior into our knight. The
  `public` is very important here, since there is also a thing called private-inheritance (which is the
  default here), that has only a very limited number of applications and protected-inheritance that only
  exists for completeness (it is completely unheard of any situation in which it would solve a problem).
  Don't worry about these two here, they really should be considered experts-only features. 
* In the constructor of knight we call the constructor of the base-class before everything else; if we
  don't do this, the default constructor will be called.
