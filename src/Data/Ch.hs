module Data.Ch(c) where

import Data.Char
import Language.Haskell.TH
import Language.Haskell.TH.Quote
import Language.Haskell.TH.Syntax

c :: QuasiQuoter
c = QuasiQuoter { quotePat = qp, quoteExp = qe, quoteType = unsupported, quoteDec = unsupported }
  where
  qp [char] = pure $ LitP $ IntegerL $ fromIntegral $ ord char
  qp _ = fail "single char expected"
  qe [char] = lift $ ord char
  qe _ = fail "single char expected"
  unsupported = const $ error "unsupported context"
