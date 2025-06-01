{-# LANGUAGE Safe #-}

-- |
-- Module      : Data.Hashable.Color
-- Description : A module to work convert a 'Hashable' object to a 'Colour'
-- Maintainer  : hapytexeu+gh@gmail.com
-- Stability   : experimental
-- Portability : POSIX
--
-- Hashes are an easy way to distinguish between two objects since it is not impossible that two random objects have the same hash, but it is very unlikely.
-- But for humans, a hash is often still not very convenient. Colors are an easier way to distinguish. For example one can make a list of items, and give
-- each of the items a different color based on the hash.
--
-- This module provides a function 'rgbHash' that can convert any 'Hashable' object to a 'Colour'.
module Data.Hashable.Color (
  -- * Determine color
    rgbHash
  -- * Show items with color
  , rgbHashBgShow, rgbHashFgShow
  ) where

import Data.Bits (shiftR, xor, (.&.))
import Data.Colour (Colour)
import Data.Colour.SRGB (sRGB24)
import Data.Hashable (Hashable (hash))
import Data.Word (Word8)

type Col8 = (Word8, Word8, Word8)

_word8 :: Int -> Word8
_word8 = toEnum . (255 .&.)

_scramble :: Int -> Int
_scramble x = ((shiftR x 16) `xor` x) * 0x45d9f3b;

_rgbHash :: Hashable a => a -> Col8
_rgbHash x = (r, g, b)
  where
    h = _scramble (_scramble (hash x))
    b = _word8 h
    g = _word8 (shiftR h 8)
    r = _word8 (shiftR h 16)

_ansiSeq :: Int -> Col8 -> String -> String
_ansiSeq md ~(r, g, b) = (("\027[" ++ show md ++ ";2;" ++ show r ++ ";" ++ show g ++ ";" ++ show b ++ "m") ++)

_ansiSeqBg :: Col8 -> String -> String
_ansiSeqBg = _ansiSeq 48

_ansiSeqFg :: Col8 -> String -> String
_ansiSeqFg = _ansiSeq 38

_altColor :: Col8 -> Col8
_altColor ~(r, g, b)
  | 1063 * fromEnum r + 3576 * fromEnum g + 361 * fromEnum b <= 200000 = (255, 255, 255)
  | otherwise = (0, 0, 0)

-- | Convert a given 'Hashable' object to a 'Colour' by determining the hash, and using the last 24 bits as source for the red, green, and blue channels of the 'Colour' to construct.
rgbHash ::
  (Hashable a, Floating b, Ord b) =>
  -- | The 'Hashable' object to convert to a color.
  a ->
  -- | The corresponding color to use.
  Colour b
rgbHash x = sRGB24 r g b
  where
    ~(r, g, b) = _rgbHash x

-- | Show the given 'Hashable' object with ANSI terminal codes such that the background is colorized by the hash of that object. This will only work if the terminal supports [24-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit). The foreground is either black or white depending on whether the color is more light or dark.
rgbHashBgShow :: (Hashable a, Show a) =>
  -- | The 'Hashable' object to print in a colorized way.
  a ->
  -- | A String with ANSI terminal codes to colorize the object
  String
rgbHashBgShow x = _ansiSeqBg c (_ansiSeqFg ca (showsPrec 0 x "\027[0m"))
  where
    c = _rgbHash x
    ca = _altColor c

-- | Show the given 'Hashable' object with ANSI terminal codes such that the foreground is colorized by the hash of that object. This will only work if the terminal supports [24-bit colors](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit). The background is either black or white depending on whether the color is more light or dark.
rgbHashFgShow :: (Hashable a, Show a) =>
  -- | The 'Hashable' object to print in a colorized way.
  a ->
  -- | A String with ANSI terminal codes to colorize the object
  String
rgbHashFgShow x = _ansiSeqFg c (_ansiSeqBg ca (showsPrec 0 x "\027[0m"))
  where
    c = _rgbHash x
    ca = _altColor c
