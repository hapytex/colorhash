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
module Data.Hashable.Color (rgbHash) where

import Data.Bits (shiftR, (.&.))
import Data.Colour (Colour)
import Data.Colour.SRGB (sRGB24)
import Data.Hashable (Hashable (hash))
import Data.Word (Word8)

_word8 :: Int -> Word8
_word8 = toEnum . (255 .&.)

-- | Convert a given 'Hashable' object to a 'Colour' by determining the hash, and using the last 24 bits as source for the red, green, and blue channels of the 'Colour' to construct.
rgbHash ::
  (Hashable a, Floating b, Ord b) =>
  -- | The 'Hashable' object to convert to a color.
  a ->
  -- | The corresponding color to use.
  Colour b
rgbHash x = sRGB24 r g b
  where
    h = hash x
    b = _word8 h
    g = _word8 (shiftR h 8)
    r = _word8 (shiftR h 16)
