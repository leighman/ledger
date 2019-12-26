module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)
import Node.ReadLine (LineHandler, createConsoleInterface, noCompletion, prompt, setLineHandler)
import Ledger (Ledger, initialState)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  let
    lineHandler :: Ledger -> LineHandler Unit
    lineHandler currentState input = do
      log $ input <> "!"
      prompt interface
  setLineHandler interface $ lineHandler initialState
  prompt interface
