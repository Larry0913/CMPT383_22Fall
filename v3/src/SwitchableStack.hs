module SwitchableStack
    ( State,
      empty,
      push,
      pop,
      setInactive,
      setActive,
      mapState,
      popWhere
    ) where

import Data.List (elem,nub)

newtype State a = State([a], Int)
{- This should create an empty state of your stack. 
   By default, your stack should be active. -}
data Stack = Active [Maybe Int] | Inactive [Maybe Int]
empty :: State a
--empty = error "Not Implemented"
empty = State ([],0)

{- This should push a new element onto your stack.
   In this stack, you cannot have two of the element on the stack.
   If the element already exists on the stack, do not edit the state. -}
push :: (Eq a) => State a -> a -> State a
push (State a) element = if element `elem` fst a
   then State a 
   else State(element : fst a, snd a)



{- This should pop the most recently added element off the stack.
   If there are no elements on the stack, return Nothing and an
   unedited version of the stack.
   If the stack is not active, return Nothing and an unedited version
   of the stack. -}
pop :: State a -> (Maybe a,State a)
--pop = error "Not Implemented"
pop (State ([],i)) = (Nothing, State([],i))
pop (State ((h:t),i)) = if i == 1 then (Nothing, State (h:t,i))
                           else (Just h, State (t, i))

{- This should switch the stack to the "inactive" state.
When a stack is inactive, elements can be pushed on it, but they
cannot be popped off it. -}
setInactive :: State a -> State a
--setInactive = error "Not Implemented"
setInactive (State (l,i)) = State (l,1)

{- This should switch the stack to the "active" state.
When a stack is active, elements can be pushed on it, and they
can be popped off it. -}
setActive :: State a -> State a
--setActive = error "Not Implemented"
setActive (State (l,i)) = State (l,0)

{- This edits elements on the stack according to the provided function.
   However, this edit may cause duplicates to be added. After mapping the state,
   be sure to remove duplicate elements. -}
mapState :: (Eq b) => (a -> b) -> State a -> State b
--mapState = error "Not Implemented"
mapState f(State (l,i)) = State (nub (map f l), i)

{- This pops all elements that satisfy a given predicate off the stack.
   The remaining elements on the stack are those that do not satisfy
   the provided predicate, in the original order.
   Do not pop any elements from the stack if the stack is inactive. -}
popWhere :: (a -> Bool) -> State a -> ([a],State a)
--popWhere = error "Not Implemented"
popWhere f (State(l,i)) = if i == 1 then ([],State(l,i))
                        else ([x|f x in l], State ([y|f y in l == False],i) )