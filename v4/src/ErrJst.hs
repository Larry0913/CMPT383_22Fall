{-# LANGUAGE InstanceSigs #-}
module ErrJst(ErrJst(..)) where

data ErrJst e a = 
     Err e
   | Jst a
   deriving (Eq,Show)

instance Functor (ErrJst e) where
   fmap :: (a -> b) -> ErrJst f a -> ErrJst f b
   fmap _ (Err e) = Err e
   fmap f (Jst x) = Jst (f x)

instance Applicative (ErrJst e) where
  pure :: a -> ErrJst f a
  pure = Jst
  (<*>) :: ErrJst f (a -> b) -> ErrJst f a -> ErrJst f b  
  Err e <*> _ = Err e
  (Jst f) <*> x = fmap f x