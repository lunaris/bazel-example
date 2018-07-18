module CustomPrelude
  ( module Protolude
  , module Control.Lens
  , module Control.Lens.At
  , module Control.Lens.Indexed
  , module Control.Lens.Operators
  , module Control.Lens.Prism
  , module Control.Lens.Reified
  , module Control.Lens.Tuple
  , module Control.Lens.Type
  , module Data.Text.Lens
  , module Data.Biapplicative
  , module Data.Bifoldable
  , module Data.Bitraversable
  , module Data.Bifunctor.TH
  , module Data.Constraint
  , module Data.Coerce
  , module Data.Functor.Compose
  , module Data.DList
  , module Data.List.NonEmpty
  , module Data.Hashable
  , module Data.NonNull
  , module Data.Semigroup
  , module Data.String
  , module Tagged

  , LazyByteString
  , LazyText

  , MFunctor (..)
  , Monad(fail)
  ) where

import Protolude
  ( LByteString
  , LText
  )

import Protolude hiding
  ( LByteString
  , LText
  , Leniency (..)

  , (<<*>>)

  , MonadError

  , (&)
  , uncons

  , from
  , to

  , Semiring (..)

  , (<&>)
  , (<<$>>)
  )

import Control.Monad.Morph (MFunctor(..))

import Control.Lens.At
import Control.Lens.Indexed hiding
  ( index
  )

import Control.Lens.Operators
import Control.Lens
  ( ALens
  , ALens'
  , APrism
  , APrism'
  , ASetter
  , ASetter'
  , ATraversal
  , ATraversal'
  , ATraversal1
  , ATraversal1'
  , AnIndexedLens
  , AnIndexedLens'
  , AnIndexedSetter
  , AnIndexedSetter'
  , AnIndexedTraversal
  , AnIndexedTraversal'
  , AnIndexedTraversal1
  , AnIndexedTraversal1'
  , AnIso
  , AnIso'

  , makeLenses
  , makePrisms
  )

import Control.Lens.Prism
  ( _Left
  , _Right
  , _Nothing
  , _Just
  , _Void
  )

import Control.Lens.Reified
import Control.Lens.Tuple
import Control.Lens.Type
  ( Fold
  , Fold1
  , Getter
  , Iso
  , Iso'
  , Lens
  , Lens'
  , Prism
  , Prism'
  , Setter
  , Setter'
  , Traversal
  , Traversal'
  , Traversal1
  , Traversal1'

  , IndexedFold
  , IndexedFold1
  , IndexedGetter
  , IndexedLens
  , IndexedLens'
  , IndexedSetter
  , IndexedSetter'
  , IndexedTraversal
  , IndexedTraversal'
  , IndexedTraversal1
  , IndexedTraversal1'
  )

import Data.Text.Lens
  ( IsText (..)
  , unpacked
  , _Text
  )

import Control.Monad
  ( Monad (fail)
  )

import Data.Biapplicative
import Data.Bifoldable
import Data.Bitraversable
import Data.Bifunctor.TH
  ( deriveBifoldable
  , deriveBifunctor
  , deriveBitraversable
  )

import Data.Constraint
  ( Dict (..)
  )

import Data.Coerce
  ( coerce
  )

import Data.Functor.Compose
  ( Compose (..)
  )

import Data.DList
  ( DList
  )

import Data.Hashable
  ( Hashable
  )

import Data.List.NonEmpty
  ( NonEmpty (..)
  )

import Data.NonNull hiding
  ( maximumBy
  , minimumBy
  , head
  , maximum
  , minimum
  , (<|)
  )

import Data.Semigroup
  ( Semigroup (sconcat, stimes)
  , WrappedMonoid
  , Option (..)
  , option
  , cycle1
  , stimesMonoid
  , stimesIdempotent
  , stimesIdempotentMonoid
  , mtimesDefault
  )

import Data.String
  ( String
  , IsString (..)
  , lines
  , words
  , unlines
  , unwords
  )

import Tagged

type LazyByteString
  = LByteString

type LazyText
  = LText
