{-# LANGUAGE NoImplicitPrelude #-}

module Main
  ( main
  ) where

import CustomPrelude
import qualified Data.Map.Strict as M

main :: IO ()
main = do
  putStrLn "Hello, world!"
  print (M.empty :: M.Map String String)
