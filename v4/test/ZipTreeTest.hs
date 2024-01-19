{-# OPTIONS_GHC -F -pgmF htfpp #-}

module ZipTreeTest (
  htf_thisModulesTests
) where

import Test.Framework
import ZipTree

test_apply :: IO ()
test_apply = do
  assertEqual (Leaf :: Tree String) (Leaf <*> Leaf)
  assertEqual Leaf (Node(Leaf,(+1),Leaf) <*> Leaf)
  assertEqual (Leaf :: Tree String) (Leaf <*> Node(Leaf,1,Leaf))
  assertEqual (Node(Leaf,3,Leaf)) (Node(Leaf,(+),Leaf) <*> (Node(Leaf,1,Leaf)) <*> (Node(Leaf,2,Leaf)))
  assertEqual (Node(Leaf,3,Leaf)) (Node(Leaf,(+),Leaf) <*> (Node(Node(Leaf,2,Leaf),1,Leaf)) <*> (Node(Leaf,2,Leaf)))
  assertEqual (Node(Node(Leaf,2,Leaf),3,Leaf)) (pure (+) <*> (Node(Node(Leaf,1,Leaf),1,Leaf)) <*> (Node(Node(Leaf,1,Leaf),2,Node(Leaf,3,Leaf))))