module Midterm1Tests (
  allTests
) where

import TestingFramework
import Midterm1
import qualified Data.Char as Char

test_fmap_TaggedList :: TestSuite
test_fmap_TaggedList =
  [ ("test_fmap_TaggedList0",testEqual (Cons (Nothing,"1",Nil) :: TaggedList Int String) (fmap show (Cons (Nothing,1,Nil))))
   ,("test_fmap_TaggedList1",testEqual (Cons (Just 1,"1",Nil)) (fmap show (Cons (Just 1,1,Nil))))
   ,("test_fmap_TaggedList2",testEqual (Cons (Just "0",1,Cons(Nothing,2,Nil))) (fmap (+1) (Cons (Just "0",0,Cons (Nothing,1,Nil)))))
   ,("test_fmap_TaggedList3",testEqual (Cons (Just 0,"HE",Cons(Just 1,"LLOW ",Cons (Just 2, "WORLD", Nil)))) (fmap (map Char.toUpper) (Cons (Just 0,"he",Cons(Just 1,"llow ",Cons (Just 2, "world", Nil))))))
   ,("test_fmap_TaggedList4",testEqual (Nil :: TaggedList Int String) (fmap (map Char.toUpper) Nil))
  ]

test_sumWithTag :: TestSuite
test_sumWithTag =
  [ ("test_sumWithTag0",testEqual 3 (sumWithTag 2 (Cons(Just 2, 3, Cons(Just 1, 3, Nil)))))
   ,("test_sumWithTag1",testEqual 6 (sumWithTag "key" (Cons(Just "key", 2, Cons(Just "key", 4, Cons (Nothing, 3, Nil))))))
   ,("test_sumWithTag2",testEqual 0 (sumWithTag "key" (Cons(Just "key1", 2, Cons(Just "key2", 4, Cons (Nothing, 3, Nil))))))
   ,("test_sumWithTag3",testEqual 10 (sumWithTag "key" (Cons(Just "key", 1, Cons(Just "key", 2, Cons (Just "key", 3, Cons (Just "key", 4, Nil)))))))
   ,("test_sumWithTag4",testEqual 0 (sumWithTag "key" Nil))
  ]

test_WarnOnce_bind :: TestSuite
test_WarnOnce_bind =
  [ ("test_WarnOnce_bind0",testEqual (WarnOnceOk 10) (WarnOnceOk 1 >>= (\x -> WarnOnceOk (x*10))))
   ,("test_WarnOnce_bind1",testEqual (WarnOnceWarn "1") (WarnOnceWarn 1 >>= (\x -> WarnOnceOk (show x))))
   ,("test_WarnOnce_bind2",testEqual (WarnOnceWarn "2") (WarnOnceOk 2 >>= (\x -> WarnOnceWarn (show x))))
   ,("test_WarnOnce_bind3",testEqual WarnOnceError (WarnOnceWarn 2 >>= (\x -> WarnOnceWarn (show x))))
   ,("test_WarnOnce_bind4",testEqual (WarnOnceError :: WarnOnce String) (WarnOnceError >>= (\x -> WarnOnceOk x)))
   ,("test_WarnOnce_bind5",testEqual (WarnOnceError :: WarnOnce String) (WarnOnceWarn 1 >>= (\x -> WarnOnceError)))
  ]

allTests :: TestSuite
allTests = test_fmap_TaggedList ++ test_sumWithTag ++ test_WarnOnce_bind