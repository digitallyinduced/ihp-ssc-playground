module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Static

import Web.Component.Counter as Counter
import Web.Component.BooksTable as BooksTable
import IHP.ServerSideComponent.RouterFunctions

instance FrontController WebApplication where
    controllers = 
        [ startPage WelcomeAction
        , routeComponent @Counter
        , routeComponent @BooksTable
        -- Generator Marker
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
