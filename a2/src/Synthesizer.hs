{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module Synthesizer 
    (numberSplit
    ,baseExpressionsAtSize
    ,varExpressionsAtSize
    ,notExpressionsAtSize
    ,andExpressionsAtSize
    ,orExpressionsAtSize
    ,expressionsAtSize
    ,expressionSatisfiesExamples
    ,generator
    )
     where

import Language
import Data.List
import Data.Maybe

numberSplit :: Int -> [(Int,Int)]
--numberSplit = error "Unimplemented"
numberSplit n = if n >1 then [(x,n-x) | x <- [1..(n-1)]]
                else []

{-  This should only return a nonempty list at size 1.
    At size 1, it should return a list consisting of the two base expressions
-}
baseExpressionsAtSize :: Int -> [Expression]
--baseExpressionsAtSize = error "Unimplemented"
baseExpressionsAtSize n = if n/=1  then [] 
                            else  [EBase False,EBase True]



{-  This should only return a nonempty list at size 1.
    At size 1, it should return a list consisting of the variable expressions

    HINT: fmap will be useful here.
-}
varExpressionsAtSize :: Context -> Int -> [Expression]
--varExpressionsAtSize = error "Unimplemented"
varExpressionsAtSize  (Context strs) n = if n/=1 then []
                                        else fmap EVariable strs
                                   

{-  At size 0, it should return an empty list.
    At other sizes, it should call the provided function to get expressions of
    a given size. The resulting expression size should be n and should be a
    "not" expression.

    HINT: fmap will be useful here.
-}
notExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
--notExpressionsAtSize = error "Unimplemented"
notExpressionsAtSize f n = if n /= 0 then fmap ENot (f (n-1))
                            else []

{-  At size 0, it should return an empty list.
    At other sizes, it should call the provided function to get expressions of
    given sizes. The resulting expression size should be n and should be a
    "and" expression.

    TO GET FULL CREDIT, YOU MUST USE DO SYNTAX WITH THE LIST MONAD.

    HINT: numbersplit will be useful here.
-}
andExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
--andExpressionsAtSize f 0 = []
andExpressionsAtSize f n = if n < 3 then [] 
                            else do
                                (i, j) <- numberSplit $ n - 1
                                e1 <- f i
                                e2 <- f j
                                pure $ EAnd (e1, e2)
    --error "Unimplemented"


{-  At size 0, it should return an empty list.
    At other sizes, it should call the provided function to get expressions of
    given sizes. The resulting expression size should be n and should be an
    "or" expression.

    TO GET FULL CREDIT, YOU MUST USE DO SYNTAX WITH THE LIST MONAD.

    HINT: numbersplit will be useful here.
-}
orExpressionsAtSize :: (Int -> [Expression]) -> Int -> [Expression]
--orExpressionsAtSize f 0 = []
orExpressionsAtSize f n = if n == 0 then []
                            else do
                                (i, j) <- numberSplit $ n - 1
                                e1 <- f i
                                e2 <- f j
                                pure $ EOr (e1, e2)

{-  This should simply call andExpressionsAtSize, orExpressionsAtSize,
    notExpressionsAtSize, varExpressionsAtSize, and baseExpressionsAtSize,
    with the appropriate arguments, and concatenate the results.
-}
expressionsAtSize :: Context -> Int -> [Expression]
--expressionsAtSize = error "Unimplemented"
expressionsAtSize env n = 
    concat 
      [ complexExprGen >>= \f -> f (expressionsAtSize env) n
      , varExpressionsAtSize env n
      , baseExpressionsAtSize n
      ]
  where complexExprGen = [andExpressionsAtSize, orExpressionsAtSize, notExpressionsAtSize]

{-  Check whether a given expression satisfies the provided examples.

    HINT: the "all" function will be useful here.
-}
expressionSatisfiesExamples :: Examples -> Expression -> Bool
--expressionSatisfiesExamples = error "Unimplemented"
expressionSatisfiesExamples (Examples examples) expr = all (`expressionSatisfiesExample` expr) examples where
    expressionSatisfiesExample (assig, result) = (== result) . evaluate assig 

{-  Generate an expression that satisfies the examples. Check if there are 
    examples at size 1, then at size 2, ... until either there are no 
    expressions at size max or until an expression is found that satisfies the
    examples.

    HINT: Use a helper function
    HINT: The "find" function will be useful here
    HINT: The "evaluate" function will be useful here
-}
generator :: Context -> Examples -> Int -> Maybe Expression
--generator = error "Unimplemented"
generator env examples n = tryHead
                         . filter (examples `expressionSatisfiesExamples`)
                         . concat
                         . fmap (expressionsAtSize env)
                         $ [1..n]
  where
    tryHead (x : _) = Just x
    tryHead _       = Nothing