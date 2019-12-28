module Main where

import Prelude
import Data.Either (either)
import Effect (Effect)
import Effect.Aff (Aff, runAff_)
import Effect.Console (log)
import Node.ReadLine.Aff (Interface, close, createConsoleInterface, noCompletion, prompt)
import Command (handleCommand)
import Persistence (readLedger)
import Types (Ledger)

main :: Effect Unit
main = do
  interface <- createConsoleInterface noCompletion
  runAff_
    ( either
        (\err -> log (show err) *> close interface)
        (const $ close interface)
    )
    ( do
        initialState <- readLedger
        loop interface initialState
    )
  where
  loop :: Interface -> Ledger -> Aff Unit
  loop interface currentState = do
    input <- prompt interface
    newState <- handleCommand currentState input
    loop interface newState
