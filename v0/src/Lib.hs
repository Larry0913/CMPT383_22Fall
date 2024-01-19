module Lib
    ( helloWorldString
    ) where

helloWorldString :: String
helloWorldString = "Hello, World!"

-- >>> helloWorldString ++ "!!"
-- "Hello, World!!!"

-- >>> :t helloWorldString
-- helloWorldString :: String

-- >>> :t helloWorldString ++ "!!"
-- helloWorldString ++ "!!" :: [Char]

{- >>> helloWorldString ++ "!!"
"Hello, World!!!"
-}
