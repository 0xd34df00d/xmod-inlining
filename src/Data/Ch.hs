module Data.Ch(c) where

import Data.Char
import Language.Haskell.TH
import Language.Haskell.TH.Quote

c :: QuasiQuoter
c = QuasiQuoter { quotePat = q, quoteExp = unsupported, quoteType = unsupported, quoteDec = unsupported }
  where
  q [char] = pure $ LitP $ IntegerL $ fromIntegral $ ord char
  q _ = fail "single char expected"
  unsupported = const $ error "unsupported context"
