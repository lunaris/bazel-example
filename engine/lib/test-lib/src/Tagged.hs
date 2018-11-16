{-# LANGUAGE CPP #-}
{-# LANGUAGE NoImplicitPrelude #-}

module Tagged
  ( module CustomPrelude

  , unTaggedWith
  ) where

#if MIN_VERSION_base(4,8,0)
-- Something special
#endif

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
