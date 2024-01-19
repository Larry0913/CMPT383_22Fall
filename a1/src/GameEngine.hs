{-# LANGUAGE NoImplicitPrelude #-}
{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

module GameEngine
    (   Score (..),
        toCandidateBasis,
        extractBases,
        basisToPuzzle,
        isWordCorrect,
        allAnswers,
        finalScore
    ) where

import Helpers
import Prelude hiding (foldl, foldr, init, map, length, filter)
import Test.Framework (assertNotEqualVerbose, assertNotEmptyVerbose)

data Score = Zero | Bad | OK | Good | Great | Perfect
    deriving (Eq, Show)

type Dictionary = [String]
type Basis = [Char]
type Puzzle = (Char,[Char])

groupSort :: Ord a => [a] -> [[a]]
groupSort = group.sort
toCandidateBasis :: String -> Maybe Basis
--toCandidateBasis = error "Unimplemented"
toCandidateBasis (x:xs) | length (x:xs) /= 7 || not (allUnique (x:xs)) = Nothing
                        | otherwise = Just (dedupAndSort (x:xs))
                            where allUnique = all ((==)1.length).groupSort

deDuplicate::[String] -> [String]
deDuplicate [] = []
deDuplicate [a] = [a]
deDuplicate (x:y:xs) | x == y = deDuplicate(filter (/= x) xs) | otherwise = x:y:deDuplicate xs
extractBases :: [String] -> [String]
--extractBases = error "Unimplemented"
extractBases str = deDuplicate (sort strTemp)
    where strTemp = filterMap toCandidateBasis str

basisToPuzzle :: Basis -> Int -> Puzzle
--basisToPuzzle = error "Unimplemented"
basisToPuzzle str index = (i, filter(/= i) str)
    where i = str !! index

isWordCorrect :: Dictionary -> Puzzle -> String -> Bool
--isWordCorrect = error "Unimplemented"
isWordCorrect dic (i,l) str | exists (== str)
    dic && checkCondition = True 
        |otherwise = False  
            where checkCondition = exists (==i) str && forAll (\x -> exists (==x) (i:l)) str

allAnswers :: Dictionary -> Puzzle -> [String]
--allAnswers = error "Unimplemented"
allAnswers dic (i,l) = filter (isWordCorrect dic (i,l)) dic

finalScore :: Dictionary -> Puzzle -> [String] -> Score
--finalScore = error "Unimplemented"
finalScore dic puz ans
    |score == 0 = Zero
    |0 < score && score < 0.25 = Bad
    |0.25 <= score && score < 0.5 = OK
    |0.5 <= score && score < 0.75 = Good
    |0.75 <= score && score <1 = Great
    |otherwise = Perfect
    where 
        b = length (allAnswers dic puz)
        a = length (filter (isWordCorrect dic puz) ans)
        score = divide a b 