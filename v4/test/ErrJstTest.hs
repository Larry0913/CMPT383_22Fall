{-# OPTIONS_GHC -F -pgmF htfpp #-}

module ErrJstTest (
  htf_thisModulesTests
) where

import Test.Framework
import ErrJst

test_fmap :: IO ()
test_fmap = do
  assertEqual ((Err "Error") :: ErrJst String String) (fmap show ((Err "Error") :: ErrJst String Int))
  assertEqual ((Jst "1") :: ErrJst String String) (fmap show ((Jst 1) :: ErrJst String Int))
  assertEqual ((Jst 2) :: ErrJst String Int) (fmap (+1) ((Jst 1) :: ErrJst String Int))

test_pure :: IO ()
test_pure = do
  assertEqual ((Jst 1) :: ErrJst String Int) (pure 1)
  assertEqual ((Jst "Hello, World!") :: ErrJst String String) (pure "Hello, World!")

test_apply :: IO ()
test_apply = do
  assertEqual (Err ("No value") :: ErrJst String Int) ((Jst (+1)) <*> Err ("No value"))
  assertEqual (Err ("No function") :: ErrJst String Int) ((Err "No function") <*> Jst 1)
  assertEqual (Err ("No function") :: ErrJst String Int) ((Err "No function") <*> Err ("No value"))
  assertEqual (Jst 2 :: ErrJst String Int) ((Jst (+1)) <*> Jst 1)
  assertEqual (Jst "1" :: ErrJst String String) ((Jst show) <*> Jst 1)
  assertEqual (Jst "Hello, World!" :: ErrJst Int String) ((Jst (++)) <*> Jst "Hello, " <*> Jst "World!")
