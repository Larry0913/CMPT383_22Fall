{-# OPTIONS_GHC -F -pgmF htfpp #-}

module AssocListTest (
  htf_thisModulesTests
) where

import Test.Framework
import AssocList

test_fmap :: IO ()
test_fmap = do
  assertEqual (Nil :: AssocList String String) (fmap show (Nil :: AssocList String Int))
  assertEqual (Cons("key","1",Nil)) (fmap show (Cons("key",1,Nil)))
  assertEqual (Cons("key",2,Nil)) (fmap (+1) (Cons("key",1,Nil)))
  assertEqual (Cons("key1",2,Cons("key2",3,Nil))) (fmap (+1) (Cons("key1",1,Cons("key2",2,Nil))))

test_doubleMap :: IO ()
test_doubleMap = do
  assertEqual (Nil :: AssocList String String) (doubleMap (\_ _ -> error "Not Called") (Nil :: AssocList String Int))
  assertEqual (Cons(2,"1",Nil)) (doubleMap (\x y -> (y,x)) (Cons("1",2,Nil)))
  assertEqual (Cons(1,"12",Nil)) (doubleMap (\x y -> (x,show x ++ y)) (Cons(1,"2",Nil)))
  assertEqual (Cons(1,3,Cons(3,7,Nil))) (doubleMap (\x y -> (x,x+y)) (Cons(1,2,Cons(3,4,Nil))))
