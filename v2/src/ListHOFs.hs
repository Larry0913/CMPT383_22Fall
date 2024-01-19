{-# LANGUAGE NoImplicitPrelude #-}

module ListHOFs
    ( zip,
      alternatingMap,
      sumEvens,
      flatten
    ) where

import Prelude(Int(..),Maybe(..),filter,mod,(+),(.),(==),(++))
import GHC.Base

{-
  One useful thing to do with lists is zip them together. Let's build the zip
  function, that does exactly this. However, lists don't always have the same
  length, so when they have differing lengths, we should return Nothing. If
  they have the same length, we should return Just l, where l is the zipped
  list.
-}

getLen :: [a] -> Int
getLen [] = 0
getLen (h:t) = 1 + getLen t

zip_help :: [a] -> [b] -> [(a,b)]
zip_help x [] = []
zip_help [] x = []
zip_help (h1:t1)(h2:t2) = (h1,h2) : zip_help t1 t2

zip :: [a] -> [b] -> Maybe [(a,b)]
--zip = error "Unimplemented"
zip (h1:t1) (h2:t2) =  if getLen (h1:t1) /= getLen (h2:t2) then Nothing else Just(zip_help (h1:t1) (h2:t2))


{-
  You've seen map before, so it's time to try building an "alternating map". An
  alternating map does the same thing that a map does, but it alternates which
  function is used at a time. The first function used should be the first
  function, then the second element should have the second function applied,
  and so on.
-}
alternatingMap :: (a -> b) -> (a -> b) -> [a] -> [b]
--alternatingMap = error "Unimplemented"
alternatingMap _ _ []     = []
alternatingMap f g (x:xs) = f x : alternatingMap g f xs
{-
  Now you should sum the even elements of a list up. Can you do this by 
  combining two other functions together. Notice what you've been provided in
  your imports.
-}
sumEvens :: [Int] -> Int
--sumEvens = error "Unimplemented"
sumEvens [] = 0
sumEvens [x] = x
sumEvens (h:t) = 0 + if mod h 2 == 0 
                then h + sumEvens t 
                else sumEvens t
{-
  The last function is the flatten a list of lists into a single list. This
  can be done by just finding the correct applications for the right higher-
  order function.
-}
flatten :: [[a]] -> [a]
--flatten = error "Unimplemented"
flatten [[]] = []
flatten [[a]] = [a]
flatten (h:t) = h ++ flatten t
