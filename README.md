# promise

An implementation of promises (delayed evaluation) in Common Lisp.

## Overview

This library provides a simple implementation of promises, which are used to delay the evaluation of expressions until their values are needed. Promises are particularly useful for optimizing computations by avoiding unnecessary evaluations and for implementing lazy evaluation.

## Features

- **Delay evaluation**: Use the `DELAY` macro to create a promise that defers computation.
- **Force evaluation**: Use the `FORCE` function to evaluate a promise and retrieve its value(s).
- **Check if forced**: Use the `FORCED?` function to check if a promise has already been evaluated.
- **Access promise values**: Use the `PROMISE-VALUES` function to handle forced and unforced promises differently.

## Installation

To use this library, load the `promise.asd` system definition file with your Common Lisp system manager (e.g., ASDF).

```lisp
(asdf:load-system :promise)
```
