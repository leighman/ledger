module Main where

import Prelude
import Effect (Effect)
import Node.ReadLine (LineHandler, createConsoleInterface, noCompletion, prompt, setLineHandler)
import Command (handleCommand)
import Ledger (Ledger, initialState)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  let
    lineHandler :: Ledger -> LineHandler Unit
    lineHandler currentState input = do
      newState <- handleCommand currentState input
      setLineHandler interface $ lineHandler newState
      prompt interface
  setLineHandler interface $ lineHandler initialState
  prompt interface
