{-# OPTIONS_GHC -F -pgmF htfpp #-}

module ListHOFsTests (
  htf_thisModulesTests
) where

import Test.Framework
import ListHOFs

test_zip :: IO ()
test_zip = do
  assertEqual Nothing (ListHOFs.zip [0,1] ['a'])
  assertEqual (Just [(0,'a'),(1,'b')]) (ListHOFs.zip [0,1] ['a','b'])

test_alternatingMap :: IO ()
test_alternatingMap = do
  assertEqual [10] (alternatingMap (+10) (+100) [0])
  assertEqual [10,101,12] (alternatingMap (+10) (+100) [0,1,2])

test_sumEvens :: IO ()
test_sumEvens = do
  assertEqual 0 (sumEvens [])
  assertEqual 20 (sumEvens [2,3,4,5,6,7,8])

test_flatten :: IO ()
test_flatten = do
  assertEqual [0] (flatten [[0]])
  assertEqual [0,1,2,3] (flatten [[0],[1,2],[3]])