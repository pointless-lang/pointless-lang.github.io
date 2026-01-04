---
title: Standard Library
layout: collection
subtitle: Modules containing built-in functionality
---

The Pointless standard library contains useful built-in functions and constants.
This functionality is split into _modules_: globally defined objects with
definitions based around a common theme. For instance, the `Str` module contains
functions for working with string values.

You can access a module's definitions the `.` operator. For example, you would
access the `toLower` function from the `Str` module using `Str.toLower`.

```ptls
Str.toLower("Pointless") -- Call the `toLower` function from the `Str` module
```

Some commonly used standard library functions, like `Str.chars`, are available
as [globals](#global-functions), and can be called without specifying a module
name.

```ptls
chars("Pointless") -- Call the global `char` function from the `Str` module
```

See the language reference for [tips on reading](/language#reading-example-code)
code examples.

Along with the [language reference](/language), the standard library
documentation is an essential resource for understaning and using the Pointless
language. Use the links below to view documentation for each module.

## Global Functions

<div class="contents">

- [assert](/stdlib/Test#assert)
- [bottom](/stdlib/Table#bottom)
- [chars](/stdlib/Str#chars)
- [clear](/stdlib/Console#clear)
- [join](/stdlib/Str#join)
- [parse](/stdlib/Str#parse)
- [print](/stdlib/Console#print)
- [prompt](/stdlib/Console#prompt)
- [range](/stdlib/List#range)
- [sleep](/stdlib/Async#sleep)
- [sort](/stdlib/List#sort)
- [sortDesc](/stdlib/List#sortDesc)
- [span](/stdlib/List#span)
- [split](/stdlib/Str#split)
- [top](/stdlib/Table#top)
- [drop](/stdlib/Overloads#drop)
- [isEmpty](/stdlib/Overloads#isEmpty)
- [len](/stdlib/Overloads#len)
- [max](/stdlib/Overloads#max)
- [min](/stdlib/Overloads#min)
- [push](/stdlib/Overloads#push)
- [remove](/stdlib/Overloads#remove)
- [reverse](/stdlib/Overloads#reverse)
- [round](/stdlib/Overloads#round)
- [roundTo](/stdlib/Overloads#roundTo)
- [select](/stdlib/Overloads#select)
- [sortBy](/stdlib/Overloads#sortBy)
- [sortDescBy](/stdlib/Overloads#sortDescBy)
- [sum](/stdlib/Overloads#sum)
- [take](/stdlib/Overloads#take)

</div>
