# colorhash

[![Build Status of the package by GitHub actions](https://github.com/hapytex/colorhash/actions/workflows/build-ci.yml/badge.svg)](https://github.com/hapytex/colorhash/actions/workflows/build-ci.yml)
[![Hackage version badge](https://img.shields.io/hackage/v/colorhash.svg)](https://hackage.haskell.org/package/colorhash)


Hashes are an easy way to distinguish between two objects since it is not impossible that two random objects have the same hash, but it is very unlikely. But for humans, a hash is often still not very convenient. Colors are an easier way to distinguish. For example one can make a list of items, and give each of the items a different color based on the hash.

This module provides a function `rgbHash :: (Hashable a, Floating b, Ord b) => a -> Colour b` that can convert any `Hashable` object to a `Colour`.

## `colorhash` is *safe* Haskell

The only module, `Data.Hashable.Color` is compiled with the `Safe` pragma.

## Contribute

You can contribute by making a pull request on the [*GitHub
repository*](https://github.com/hapytex/colorhash).

You can contact the package maintainer by sending a mail to
[`hapytexeu+gh@gmail.com`](mailto:yourfriends@hapytex.eu).
