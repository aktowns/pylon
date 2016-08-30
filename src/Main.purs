module Main where

import Prelude
import Control.Monad
import Control.Monad.Eff (Eff, whileE)
import Control.Monad.Eff.Console (CONSOLE, log)
import Node.Stream
import Control.Monad.Eff.Exception  
import Data.Maybe 
import Data.Either
import Node.Encoding
import Data.Show(show)

data Packet a = Packet { type :: String
                       , payload :: a }

-- { type: "Message", data: "Server Started" }
-- { type: "ReceiveInput", data: "...."}
-- { type: "SendOutput", data: "..."}

foreign import stdin :: forall eff. Readable () (console :: CONSOLE | eff)
foreign import stdout :: forall eff. Writable () eff

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  onReadable stdin do 
    result <- try $ readString stdin Nothing UTF8
    case result of 
      Right (Just x) -> void $ writeString stdout UTF8 x (pure unit) 
      Right Nothing -> pure unit
      Left err -> log $ show err