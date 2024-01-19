module Queue
    ( empty,
      enqueue,
      dequeue
    ) where
import qualified Data.List as List

type Queue = ([Int],[Int])

{-
  We've defined our "Queue" type to be a pair of two lists of integers. One
  of these lists is the "popping" list, and the other is the "pushing" list.
  For now we just want to create an empty queue.

  To create a pair of lists, where the first element of the pair is l1, and the
  second is l2, one writes (l1,l2).

  To extract the first list in a queue q, one calls (fst q). To extract the
  second, one calls (snd q). So, fst (l1,l2) = l1, and snd (l1,l2) = l2.
  
  You can also pattern match pairs! f (l1,l2) = ... would pattern match the
  first list of the pair into the variable l1, and pattern match the second
  list of the pair into l2.
-}
empty :: Queue
--empty = error "Unimplemented"
empty = ([], [])


{-
  Now you must choose one of the lists to be the "pushing" list. When you
  enqueue an element, you simply prepend it to the front of that list!
-}
enqueue :: Queue -> Int -> Queue
--enqueue (l1,l2) i = error "Unimplemented"
enqueue ([],[]) a = ([a],[])
enqueue (l1,l2) i = (i:l1, l2)

{-
  Dequeing is sometimes easy, and sometimes hard.

  The easiest case is when the queue is empty. When the queue is empty, you
  should return the pair (0,empty). In other words, popping empty returns the
  popped element 0, and another empty queue.

  The next easiest case is when the "popping" list is nonempty. All you have to
  do is remove that element! So, You should return the head of the popping
  list, and create a new queue with the same pushing list, where the popping
  list has the head removed. You then want to return a pair consisting of the
  new queue, and the popped element. If e is the popped element, and q is the
  new queue, the pair that returns both is (e,q).

  The hard case is where the "popping" list is empty, but the "pushing" list is
  nonempty. At this phase, we take the following steps:
  1) Convert the pushing list into the new popping list.
     However, remember that the head of the pushing list is the most recently
     added element. That means we want it to be the last element of the popping
     list (which is processed front-to-back). So, the new queue should have two
     lists: the pushing list -- which should be empty, and the popping list,
     which should be the reverse of the old pushing list.
  2) Call dequeue on this updated queue.
-}
dequeue :: Queue -> (Int,Queue)
--dequeue = error "Unimplemented"
dequeue ([],[]) = (0,([],[]))
dequeue (l1,(h:t)) = (h,(l1,t))
dequeue (l,[]) = dequeue([],reverse(l))

