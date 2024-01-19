module Midterm1 where

data TaggedList t a = 
        Nil
    | Cons (Maybe t, a, TaggedList t a)
    deriving (Eq,Show)

instance Functor (TaggedList t) where
    fmap _ Nil                  = Nil
    fmap f (Cons (tag, x, xs))  = Cons (tag, f x, fmap f xs)

sumWithTag :: Eq t => t -> TaggedList t Int -> Int
sumWithTag _ Nil         = 0
sumWithTag tag (Cons (tag1, x, rest))
  | Just tag == tag1              = x + sumWithTag tag rest
  | otherwise                     = sumWithTag tag rest

data WarnOnce a =
        WarnOnceOk a
    | WarnOnceWarn a
    | WarnOnceError
    deriving (Eq,Show)

instance Functor WarnOnce where
    fmap f (WarnOnceOk x) = WarnOnceOk (f x)
    fmap f (WarnOnceWarn x) = WarnOnceWarn (f x)
    fmap f WarnOnceError = WarnOnceError

instance Applicative WarnOnce where
    pure = WarnOnceOk
    (<*>) (WarnOnceOk f) (WarnOnceOk x) = WarnOnceOk (f x)
    (<*>) (WarnOnceWarn f) (WarnOnceOk x) = WarnOnceWarn (f x)
    (<*>) (WarnOnceOk f) (WarnOnceWarn x) = WarnOnceWarn (f x)
    (<*>) (WarnOnceWarn f) (WarnOnceWarn x) = WarnOnceError
    (<*>) WarnOnceError _ = WarnOnceError
    (<*>) _ WarnOnceError = WarnOnceError

instance Monad WarnOnce where
    return x = WarnOnceOk x

    (WarnOnceOk x) >>= f       = f x
    WarnOnceError >>= _        = WarnOnceError
    (WarnOnceWarn x) >>= f     = case f x of
        WarnOnceOk y        -> WarnOnceWarn y
        _                   -> WarnOnceError


data DiscProbDist a = DiscProbDist [( Float , a )] deriving Show

instance Functor DiscProbDist where
    fmap f xs = xs >>= \x -> pure $ f x

instance Applicative DiscProbDist where
    pure = return
    mf <*> mx = mf >>= \f -> mx >>= \x -> pure $ f x

instance Monad DiscProbDist where
    return x = DiscProbDist . pure $ (1, x)
    (DiscProbDist mx) >>= f = DiscProbDist [(p * q, y) | (p, x) <- mx, let DiscProbDist my = f x, (q, y) <- my]