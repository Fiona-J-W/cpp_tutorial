Function Templates
==================


Sometimes we have several almost identical functions, the only difference being that they operate on
different types. Function templates are a feature of the C++ language that allows to have a single
implementation that works for multiple types instead of duplicating the code. During compilation the
compiler will duplicate the code for us as many times as needed.

Basic principles
----------------

Function templates are defined by adding `template<`*type list*`>` before the declaration of the
function. For example, <!--TODO-->

```cpp
template<class Type>
void foo(int x)
{
    /* put code here */
}
```

Now we can use `Type` within the function body as any other type such as `char` or `double`. The
template parameter list may contain multiple parameters. Each of them must be prepended with either of
`class` or `typename` keywords.

The above function can be called as e.g. `foo<char>(2)`. Each time the function is called, the compiler
“pastes“ `char` into each location where `Type` is used and checks whether the resulting code is
valid. If it's not valid, an error is raised. Otherwise, the function behaves in the same way as if
`Type` was `char` or any other given type. See the example below:

```cpp
#include <iostream>
#include <iomanip>
 
// Converts integer to different types and prints it
template<class Type>
void foo(int x)
{
    std::cout << Type(x) << "\n";
}
 
int main()
{
    std::cout << std::fixed << std::setprecision(3); // setup formatting
    foo<int>(67);    // print 67 as an int
    foo<double>(67); // print 67 as double
    foo<char>(67);   // print 67 as a character
}
```
```
>> 67
>> 67.000
>> C
```

Deduction
---------

Template parameters can be used anywhere in the function, including the parameter list. For example,
`template<class T> void bar(T a, T b) { ... } `. If all template parameters appear in the function
parameter list, then the compiler can deduce the actual type of the parameter automatically, so the
function template can be called in the same way as any other function, e.g. `bar(2, 3)`. See the
example below:

```cpp
#include <iostream>
#include <iomanip>
 
// Prints the given type
template<class T>
void print(T x)
{
    std::cout << x << "\n";
}
 
int main()
{
    std::cout << std::fixed << std::setprecision(3); // setup formatting
    print(64);         // prints 64 as an int
    print(64.2);       // prints 64.2 as a double
    print(double(64)); // prints 64 as a double
    print<char>(64);   // override the automatic deduction -- force T to be char
    print('c');        // print 'c' as a char
    print("bar");      // prints "bar" as const char*
}
```
```
>> 64
>> 64.200
>> 64.000
>> D
>> c
>> bar
```

In general one should never pass template-arguments that can be inferred, since the compiler knows
better anyways and the function-template may do unexpected things.

Non-type parameters
-------------------

<!---TODO-->
