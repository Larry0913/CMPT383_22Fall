{-# OPTIONS_GHC -F -pgmF htfpp #-}

module TreeHOFsTests (
  htf_thisModulesTests
) where

import Test.Framework
import TreeHOFs

test_treeMap :: IO ()
test_treeMap = do
  assertEqual Leaf (treeMap (+1) Leaf)
  assertEqual (Node(Leaf,1,Node(Leaf,2,Leaf))) (treeMap (+1) (Node(Leaf,0,Node(Leaf,1,Leaf))))

test_treeFold :: IO ()
test_treeFold = do
  assertEqual 1 (treeFold (\l v r -> l*v*r) 1 Leaf)
  assertEqual [0,1] (treeFold (\l v r -> l++[v]++r) [] (Node(Leaf,0,Node(Leaf,1,Leaf))))

test_treeHeight :: IO ()
test_treeHeight = do
  assertEqual 0 (treeHeight Leaf)
  assertEqual 2 (treeHeight (Node(Leaf,2,Node(Leaf,1,Leaf))))

test_treeSum :: IO ()
test_treeSum = do
  assertEqual 0 (treeSum Leaf)
  assertEqual 3 (treeSum (Node(Leaf,2,Node(Leaf,1,Leaf))))

test_treeSizer :: IO ()
test_treeSizer = do
  assertEqual (Node(Leaf,('a',1),Leaf)) (treeSizer (Node(Leaf,'a',Leaf)))
  assertEqual (Node(Node(Leaf,('l',1),Leaf),('v',3),Node(Leaf,('r',1),Leaf))) (treeSizer (Node(Node(Leaf,'l',Leaf),'v',Node(Leaf,'r',Leaf))))