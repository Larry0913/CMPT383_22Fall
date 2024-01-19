{-# OPTIONS_GHC -F -pgmF htfpp #-}

module SynthesizerTests (
  htf_thisModulesTests
) where

import Test.Framework
import Data.List
import Language
import Synthesizer

test_numberSplit = do
    assertEqual [] (numberSplit 0)
    assertEqual [] (numberSplit 1)
    assertEqual [(1,1)] (numberSplit 2)
    assertEqual [(1,2),(2,1)] (numberSplit 3)
    assertEqual [(1,3),(2,2),(3,1)] (numberSplit 4)

test_baseExpressionsAtSize = do
    assertEqual [] (baseExpressionsAtSize 0)
    assertEqual [EBase False,EBase True] (sort (baseExpressionsAtSize 1))
    assertEqual [] (baseExpressionsAtSize 2)

test_varExpressionsAtSize = do
    assertEqual [] (varExpressionsAtSize (Context ["a","b"]) 0)
    assertEqual [EVariable "a",EVariable "b"] (sort (varExpressionsAtSize (Context ["a","b"]) 1))
    assertEqual [EVariable "a1",EVariable "a2",EVariable "a3"] (sort (varExpressionsAtSize (Context ["a1","a2","a3"]) 1))
    assertEqual [] (sort (varExpressionsAtSize (Context ["a1","a2","a3"]) 2))

test_notExpressionsAtSize = do
    assertEqual [] (notExpressionsAtSize (\ _ -> [EBase True]) 0)
    assertEqual 
        [ENot (EBase False), ENot (EBase True)] 
        (sort 
            (notExpressionsAtSize 
                (\ i -> if i == 1 then [EBase True,EBase False] else []) 
                2))
    assertEqual
        [] 
        (sort 
            (notExpressionsAtSize 
                (\ i -> if i == 1 then [EBase True,EBase False] else [])
                3))

test_andExpressionsAtSize = do
    assertEqual [] (andExpressionsAtSize (\ _ -> [EBase True]) 0)
    assertEqual 
        [EAnd (EBase False,EBase False)
        ,EAnd (EBase False,EBase True)
        ,EAnd (EBase True,EBase False)
        ,EAnd (EBase True, EBase True)]
        (sort
            (andExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                3))
    assertEqual 
        [EAnd (ENot (EBase False),EBase False)
        ,EAnd (ENot (EBase False),EBase True)
        ,EAnd (ENot (EBase True),EBase False)
        ,EAnd (ENot (EBase True), EBase True)
        ,EAnd (EBase False,ENot (EBase False))
        ,EAnd (EBase False,ENot (EBase True))
        ,EAnd (EBase True,ENot (EBase False))
        ,EAnd (EBase True, ENot (EBase True))] 
        (sort
            (andExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                4))

test_orExpressionsAtSize = do
    assertEqual [] (orExpressionsAtSize (\ _ -> [EBase True]) 0)
    assertEqual 
        [EOr (EBase False,EBase False)
        ,EOr (EBase False,EBase True)
        ,EOr (EBase True,EBase False)
        ,EOr (EBase True, EBase True)]
        (sort
            (orExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                3))
    assertEqual 
        [EOr (ENot (EBase False),EBase False)
        ,EOr (ENot (EBase False),EBase True)
        ,EOr (ENot (EBase True),EBase False)
        ,EOr (ENot (EBase True), EBase True)
        ,EOr (EBase False,ENot (EBase False))
        ,EOr (EBase False,ENot (EBase True))
        ,EOr (EBase True,ENot (EBase False))
        ,EOr (EBase True, ENot (EBase True))]
        (sort
            (orExpressionsAtSize 
                (\ i -> if i == 1 then 
                        [EBase True,EBase False] 
                    else if i == 2 then 
                        [ENot (EBase True),ENot (EBase False)] 
                    else []) 
                4))

test_expressionsAtSize :: IO ()
test_expressionsAtSize = do
    assertEqual [] (expressionsAtSize (Context []) 0)
    assertEqual 
        [EBase False,EBase True]
        (sort (expressionsAtSize (Context []) 1))
    assertEqual 
        [EVariable "a", EVariable "b", EBase False,EBase True]
        (sort (expressionsAtSize (Context ["a","b"]) 1))
    assertEqual 
        [ENot (EVariable "a"), ENot (EVariable "b"), ENot (EBase False),ENot (EBase True)]
        (sort (expressionsAtSize (Context ["a","b"]) 2))
    assertEqual 
        [EAnd (EBase False,EBase False), EAnd (EBase False,EBase True), EAnd (EBase True,EBase False),EAnd (EBase True,EBase True)
        ,EOr (EBase False,EBase False), EOr (EBase False,EBase True), EOr (EBase True,EBase False),EOr (EBase True,EBase True)
        ,ENot (ENot (EBase False)),ENot (ENot (EBase True))]
        (sort (expressionsAtSize (Context []) 3))

test_expressionSatisfiesExamples :: IO ()
test_expressionSatisfiesExamples = do
    assertEqual True (expressionSatisfiesExamples (Examples [(Assignment [],True)]) (EBase True))
    assertEqual False (expressionSatisfiesExamples (Examples [(Assignment [],True)]) (EBase False))
    assertEqual False (expressionSatisfiesExamples (Examples [(Assignment [],False)]) (EBase True))
    assertEqual True (expressionSatisfiesExamples (Examples [(Assignment [],False)]) (EBase False))
    assertEqual True (expressionSatisfiesExamples (Examples []) (EBase False))
    assertEqual True (expressionSatisfiesExamples (Examples []) (EBase True))
    assertEqual True (expressionSatisfiesExamples (Examples [(Assignment [("a",True)],True),(Assignment [("a",False)],False)]) (EVariable "a"))

test_generator :: IO ()
test_generator = do
    assertEqual (Just (EBase True)) (generator (Context []) (Examples [(Assignment [],True)]) 1)
    assertEqual (Just (EBase False)) (generator (Context []) (Examples [(Assignment [],False)]) 1)
    assertEqual Nothing (generator (Context []) (Examples [(Assignment [("a",True)],False),(Assignment [("a",False)],True)]) 1)
    assertEqual (Just (ENot (EVariable "a"))) (generator (Context ["a"]) (Examples [(Assignment [("a",True)],False),(Assignment [("a",False)],True)]) 3)
    assertEqual 
        (Just (EAnd ((EVariable "a"),(EVariable "b")))) 
        (generator 
            (Context ["a","b"]) 
            (Examples 
                [(Assignment [("a",True),("b",True)],True)
                ,(Assignment [("a",True),("b",False)],False)
                ,(Assignment [("a",False),("b",True)],False)
                ,(Assignment [("a",False),("b",False)],False)
                ]) 4)
    assertEqual 
        Nothing 
        (generator 
            (Context ["a","b"]) 
            (Examples 
                [(Assignment [("a",True),("b",True)],True)
                ,(Assignment [("a",True),("b",False)],False)
                ,(Assignment [("a",False),("b",True)],False)
                ,(Assignment [("a",False),("b",False)],False)
                ]) 2)