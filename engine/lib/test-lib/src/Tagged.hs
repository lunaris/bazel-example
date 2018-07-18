{-# LANGUAGE NoImplicitPrelude #-}

module Tagged
  ( module CustomPrelude

  , unTaggedWith
  ) where

import Data.Tagged as CustomPrelude
  ( Tagged (..)
  , tagSelf
  , tagWith
  )

import Data.Tagged as Raw
  ( Tagged (..)
  )

unTaggedWith :: proxy s -> Raw.Tagged s a -> a
unTaggedWith _ (Tagged x)
  = x

{-# INLINE unTaggedWith #-}
