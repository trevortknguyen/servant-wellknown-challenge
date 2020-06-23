{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}
module Main where

import Data.Maybe (Maybe(..), fromMaybe)
import Control.Monad.IO.Class (liftIO)
import System.Environment (lookupEnv)


import Servant
import Network.Wai.Handler.Warp

type WellKnownAPI = ".well-known" :> "acme-challenge" :> Capture "filename" String :> Get '[PlainText] String

server :: Server WellKnownAPI
server filename = do
    mFilename <- liftIO $ lookupEnv "CHALLENGE_FILENAME"
    mData <- liftIO $ lookupEnv "CHALLENGE_DATA"

    let data_ = do
            challenge_filename <- maybeToRight "no CHALLENGE_FILENAME env var set" $ mFilename
            if challenge_filename == filename
                then do
                    maybeToRight "no CHALLENGE_DATA env var set" $ mData
                else return "wrong file requested"
    case data_ of
        Left err -> return err
        Right data' -> return data'
    where
        maybeToRight b (Just a) = Right a
        maybeToRight b Nothing = Left b


app :: Application
app = serve (Proxy :: Proxy WellKnownAPI) server

main :: IO ()
main = do
    port <- fromMaybe 3000 <$> (fmap read) <$> lookupEnv "PORT" :: IO Int
    putStrLn $ "listening on port " ++ (show port)
    run port app
