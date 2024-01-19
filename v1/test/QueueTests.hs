{-# OPTIONS_GHC -F -pgmF htfpp #-}

module QueueTests (
  htf_thisModulesTests
) where

import Test.Framework
import Queue

test_empty :: IO ()
test_empty = do
    assertEqual empty ([],[])

test_dequeueEmpty :: IO ()
test_dequeueEmpty =
    assertEqual (dequeue empty) (0,([],[]))

test_enqueueDequeue :: IO ()
test_enqueueDequeue = do
    assertEqual (nthQueueElement 0 (enqueueList [1,2,3,4] empty)) 1
    assertEqual (nthQueueElement 2 (enqueueList [1,2,3,4] empty)) 3
    assertEqual (nthQueueElement 4 (enqueueList [1,2,3,4] empty)) 0
  where
    enqueueList []  q = q 
    enqueueList (h:t) q = enqueueList t (enqueue q h)

    nthQueueElement 0 q = fst (dequeue q)
    nthQueueElement n q = nthQueueElement (n-1) (snd (dequeue q))