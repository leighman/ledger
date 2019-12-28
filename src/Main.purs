module Main where

import Prelude
import Data.Either (either)
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Class (liftEffect)
import Node.ReadLine.Aff (Interface, close, createConsoleInterface, noCompletion, prompt)
import Command (handleCommand)
import Ledger (initialState)
import Types (Ledger)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  runAff_
    ( either
        (const $ close interface)
        (const $ close interface)
    )
    (loop interface initialState)
  where
  loop :: Interface -> Ledger -> Aff Unit
  loop interface currentState = do
    input <- prompt interface
    newState <- handleCommand currentState input
    loop interface newState
