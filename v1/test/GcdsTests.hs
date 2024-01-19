{-# OPTIONS_GHC -F -pgmF htfpp #-}

module GcdsTests (
  htf_thisModulesTests
) where

import Test.Framework
import Gcds

test_isDivisor :: IO ()
test_isDivisor = do
  assertEqual (isDivisor 2 4) True
  assertEqual (isDivisor 4 2) False

test_allDivisors :: IO ()
test_allDivisors = do
  assertEqual (allDivisors 2) [2,1]
  assertEqual (allDivisors 6) [6,3,2,1]

test_listIntersection :: IO ()
test_listIntersection = do
  assertEqual (listIntersection [2,1] [1]) [1]
  assertEqual (listIntersection [2,1] [2]) [2]

test_listGcd :: IO ()
test_listGcd = do
  assertEqual (listGcd 3 6) 3
  assertEqual (listGcd 12 8) 4
  assertEqual (listGcd 1 9) 1