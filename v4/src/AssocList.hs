{-# OPTIONS_GHC -Wno-overlapping-patterns #-}
{-# LANGUAGE InstanceSigs #-}
module AssocList(AssocList(..),doubleMap) where

data AssocList k a = 
     Nil
   | Cons(k,a,AssocList k a)
   deriving (Eq,Show)

instance Functor (AssocList k) where
   --fmap = error "Unimplemented"
   fmap :: (a -> b) -> AssocList k a -> AssocList k b
   fmap _ Nil = Nil
   fmap f (Cons(x,y,tail)) = Cons (x,f y,fmap f tail)

doubleMap :: (k -> a -> (k',a')) -> AssocList k a -> AssocList k' a'
--doubleMap = error "Unimplemented"
doubleMap _ Nil = Nil
doubleMap f (Cons(x,y,tail)) = Cons (fst(f x y), snd (f x y),doubleMap f tail) 