{-# OPTIONS_GHC -F -pgmF htfpp #-}

module SwitchableStackTests (
  htf_thisModulesTests
) where

import Test.Framework
import SwitchableStack
import Data.Maybe
import Data.Char

test_emptypop :: IO ()
test_emptypop = do
  assertEqual nothing (fst (pop empty))
  where nothing :: Maybe Int 
        nothing = Nothing

pushList :: (Eq a) => State a -> [a] -> State a
pushList s es = foldr (flip push) s es

popN :: (Eq a) => State a -> Int -> [a]
popN s i = mapMaybe id (popN' s i)
  where
    popN' s 0 = []
    popN' s n = 
      let (vo,s') = pop s in
      vo:(popN' s' (n-1))

test_pushpop :: IO ()
test_pushpop = do
  let initial = empty
  assertEqual (Just 'a') (fst (pop (push initial 'a')))
  assertEqual (Just 2) (fst (pop (pushList initial [2,3,4])))
  assertEqual (Just 3) (fst (pop (pushList initial [5,3,5,4])))
  assertEqual [3,5]    (popN (pushList initial [5,3,5,4]) 2)

test_popInactive :: IO ()
test_popInactive = do
  let initial = setInactive empty
  assertEqual Nothing (fst (pop (push initial 'a')))
  assertEqual Nothing (fst (pop (pushList initial [2,3,4])))
  assertEqual Nothing (fst (pop (pushList initial [5,3,5,4])))
  assertEqual [] (popN (pushList initial [5,3,5,4]) 2)

test_reactivateInactive :: IO ()
test_reactivateInactive = do
  let initial = setInactive empty
  assertEqual (Just 'a') (fst (pop (setActive (push initial 'a'))))
  assertEqual (Just 2) (fst (pop (setActive (pushList initial [2,3,4]))))
  assertEqual (Just 3) (fst (pop (setActive (pushList initial [5,3,5,4]))))
  assertEqual [3,5]    (popN (setActive (pushList initial [5,3,5,4])) 2)

test_mapState :: IO ()
test_mapState = do
  let initial = empty
  assertEqual (Just 'A') (fst (pop (mapState toUpper (push initial 'a'))))
  assertEqual (Just 3) (fst (pop (mapState (+1) (pushList initial [2,3,4]))))
  assertEqual (Just 5) (fst (pop (mapState (+2) (pushList initial [5,3,5,4]))))
  assertEqual [0]    (popN (mapState (*0) (pushList initial [5,3,5,4])) 2)

test_popWhere :: IO ()
test_popWhere = do
  let initial = empty
  assertEqual [] (fst (popWhere (\ _ -> False) (push initial 'a')))
  assertEqual [2,4] (fst (popWhere (\x -> x `mod` 2 == 0) (pushList initial [2,3,4])))
  assertEqual [3,5] (fst (popWhere (\x -> x `mod` 2 == 1) (pushList initial [5,3,5,4])))
  assertEqual Nothing  (fst (pop (snd (popWhere (\ _ -> True) (pushList initial [5,3,5,4])))))