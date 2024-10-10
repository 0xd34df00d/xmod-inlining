{-# LANGUAGE NumericUnderscores #-}
{-# LANGUAGE QuasiQuotes #-}
{-# OPTIONS_GHC -ddump-simpl -ddump-to-file #-}

module Main (main) where

import Control.Monad.ST.Strict
import Data.ByteString qualified as BS
import Data.ByteString.Unsafe qualified as BS
import Data.Vector.Unboxed.Mutable qualified as VM
import Data.Word

import Data.Ch

data Stack s a = Stack
  { theVec :: VM.MVector s a
  , size :: Int
  }

mkStack :: VM.Unbox a => Int -> ST s (Stack s a)
mkStack initSize = (`Stack` 0) <$> VM.unsafeNew initSize

isEmpty :: Stack s a -> Bool
isEmpty Stack{..} = size == 0

push :: VM.Unbox a => a -> Stack s a -> ST s (Stack s a)
push a Stack{..} = do
  vec' <- if size /= VM.length theVec
             then pure theVec
             else theVec `VM.unsafeGrow` size
  VM.unsafeWrite vec' size a
  pure $ Stack vec' (size + 1)

pop :: VM.Unbox a => Stack s a -> ST s (a, Stack s a)
pop Stack{..} = do
  a <- VM.unsafeRead theVec (size - 1)
  pure (a, Stack theVec (size - 1))

isOpen :: Word8 -> Bool
isOpen [c|(|] = True
isOpen [c|[|] = True
isOpen _ = False

matches :: Word8 -> Word8 -> Bool
matches [c|(|] [c|)|] = True
matches [c|[|] [c|]|] = True
matches _ _ = False

checkBrackets :: BS.ByteString -> Bool
checkBrackets bs = runST $ mkStack len >>= go 0
  where
  len = BS.length bs
  go i stack
    | i == len = pure $ isEmpty stack
    | otherwise = case bs `BS.unsafeIndex` i of
                    ch
                      | isOpen ch -> push ch stack >>= go (i + 1)
                      | isEmpty stack -> pure False
                      | otherwise -> do
                        (inStack, stack') <- pop stack
                        if inStack `matches` ch
                         then go (i + 1) stack'
                         else pure False

main :: IO ()
main = print $ checkBrackets $ BS.replicate cnt 40 <> BS.replicate cnt 41
  where
  cnt = 100_000_000