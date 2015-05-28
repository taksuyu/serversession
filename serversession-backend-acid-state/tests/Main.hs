module Main (main) where

import Data.Acid.Local (openLocalState, createCheckpointAndClose)
import Data.Acid.Memory (openMemoryState)
import Test.Hspec
import Web.ServerSession.Backend.Acid
import Web.ServerSession.Core.StorageTests

import qualified Control.Exception as E

main :: IO ()
main =
  E.bracket
    (AcidStorage <$> openLocalState emptyState)
    (createCheckpointAndClose . acidState) $
    \acidLocal -> hspec $ do
      acidMem <- runIO $ AcidStorage <$> openMemoryState emptyState
      describe "AcidStorage on memory only" $
        allStorageTests acidMem it runIO parallel shouldBe shouldReturn shouldThrow
      describe "AcidStorage on local storage" $
        allStorageTests acidLocal it runIO parallel shouldBe shouldReturn shouldThrow