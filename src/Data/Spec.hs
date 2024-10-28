module Data.Spec where

import Control.Monad.ST.Strict
import Data.Word
import Data.Stack

{-# SPECIALIZE push :: Word8 -> Stack s Word8 -> ST s (Stack s Word8) #-}
