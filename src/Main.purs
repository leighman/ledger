module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Node.ReadLine (createConsoleInterface, noCompletion, prompt, setLineHandler)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  let
    lineHandler input = do
      log $ input <> "!"
      prompt interface
  setLineHandler interface $ lineHandler
  prompt interface
