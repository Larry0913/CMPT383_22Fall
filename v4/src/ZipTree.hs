{-# LANGUAGE InstanceSigs #-}
module ZipTree(Tree(..)) where

data Tree a =
      Leaf
    | Node(Tree a,a,Tree a)
   deriving (Eq,Show)

instance Functor Tree where
   fmap f Leaf          = Leaf
   fmap f (Node(l,v,r)) = Node(fmap f l,f v,fmap f r)

instance Applicative Tree where
   pure :: a -> Tree a
   pure x = Node(pure x,x,pure x)
   (<*>) :: Tree (a -> b) -> Tree a -> Tree b
   Leaf <*> _ = Leaf
   _ <*> Leaf = Leaf
   Node (fl,f,fr) <*> Node(l,x,r) = Node (fl <*> l,f x,fr <*> r)