{-# OPTIONS_GHC -F -pgmF htfpp #-}
module Main ( main ) where

import {-@ HTF_TESTS @-} SwitchableStackTests

import Test.Framework

main :: IO ()
main = htfMain htf_importedTests