module Main where

import Data.List
import Data.Maybe
import OpenSSL.PEM
import OpenSSL.RSA
import OpenSSL.EVP.PKey
-- import System.IO
import System.Environment

toRSA :: SomePublicKey -> RSAPubKey
toRSA = fromJust . toPublicKey


factors :: Integer -> [Integer]
factors n = unfoldr (\(d,n) -> listToMaybe [(x, (x, div n x)) | x <- [d..n], mod n x==0]) (2,n)

isPrime n = n > 1 && head (factors n) == n

-- listOfFactors :: Integer -> [Integers]
-- listOfFactors a = [ x | x <- [2..a], isPrime x, mod x ]

main :: IO ()
main = do
  args <- getArgs
  if (length args) < 1
    then print "Pass key.pub as first arg" >> return ()
    else do
      let pubFilePath = (args !! 0)
      pubFile <- readFile pubFilePath -- Reads the content of the key.pub file.
      somePubKey <- readPublicKey pubFile -- The read public key can read different formats.
      let rsaPubKey = toRSA somePubKey -- Since I know it's a a rsa I can just convert it.
      print $ "Public key's modulus  (n): " ++ (show $ rsaN rsaPubKey)
      print $ "Public key's exponent (e): " ++ (show $ rsaE rsaPubKey)
      return ()
