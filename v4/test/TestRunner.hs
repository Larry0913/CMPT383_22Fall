{-# OPTIONS_GHC -F -pgmF htfpp #-}
module Main ( main ) where

import {-@ HTF_TESTS @-} ErrJstTest
import {-@ HTF_TESTS @-} AssocListTest
import {-@ HTF_TESTS @-} ZipTreeTest

import Test.Framework

main :: IO ()
main = htfMain htf_importedTests