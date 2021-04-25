{-# LANGUAGE TemplateHaskell #-}
module Web.Component.Counter where

import IHP.ViewPrelude
import IHP.ServerSideComponent.Types
import IHP.ServerSideComponent.ControllerFunctions

data Counter = Counter { value :: !Int }

data CounterController
    = IncrementCounterAction
    | SetCounterValue { newValue :: !Int }
    deriving (Eq, Show, Data)

$(deriveSSC ''CounterController)

instance Component Counter CounterController where
    initialState = Counter { value = 0 }
    
    render Counter { value } = [hsx|
        Current: {value} <br />
        <button onclick="callServerAction('IncrementCounterAction')">Plus One</button>
        <hr />
        <input type="number" value={inputValue value} onchange="callServerAction('SetCounterValue', { newValue: parseInt(this.value, 10) })"/>
    |]
    
    action state IncrementCounterAction = do
        state
            |> incrementField #value
            |> pure

    action state SetCounterValue { newValue } = do
        state
            |> set #value newValue
            |> pure

instance SetField "value" Counter Int where setField value' counter = counter { value = value' }