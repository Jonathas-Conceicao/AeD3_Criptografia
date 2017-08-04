module Main where

import Data.Char
import Data.List
import Data.Maybe
import System.Environment

import Data.ByteString as BS
import Data.ByteString.Char8 as BSChar

import OpenSSL.PEM
import OpenSSL.RSA
import OpenSSL.Cipher
import OpenSSL.EVP.PKey

type PublicModulus = Integer
type PublicExponent = Integer
type PrivateExponent = Integer
type Totient = Integer

toRSA :: SomePublicKey -> RSAPubKey
toRSA = fromJust . toPublicKey

getRSAPublicInfo :: String -> IO (PublicModulus, PublicExponent)
getRSAPublicInfo pubFile = do
  somePubKey <- readPublicKey pubFile -- The read public key can read different formats.
  let rsaPubKey = toRSA somePubKey -- Since I know it's a a rsa I can just convert it.
  return (rsaN rsaPubKey, rsaE rsaPubKey)

sndOfTriple :: (a, b, c) -> b
sndOfTriple (_, b, _) = b

genPrivateExponent :: PublicExponent -> Totient -> PrivateExponent
genPrivateExponent e ln = if (privExp < 0) then (privExp + ln) else privExp
  where
    privExp = sndOfTriple $ eGCD e ln

eGCD :: Integer -> Integer -> (Integer, Integer, Integer) -- Extended Euclidean Algorithm from wikibooks.org
eGCD 0 b = (b, 0, 1)
eGCD a b = let (g, s, t) = eGCD (b `mod` a) a
           in (g, t - (b `div` a) * s, s)

main :: IO ()
main = do
  args <- getArgs
  fileContent <- Prelude.readFile (args !! 0)
  (pMod, pExp) <- getRSAPublicInfo (fileContent)
  print $ "Public key's modulus  (n): " ++ (show $ pMod)
  print $ "Public key's exponent (e): " ++ (show $ pExp)
  print "Go to http://www.numberempire.com/numberfactorizer.php and find the factors (Since that's faster then anything that I can implement right now)"
  print "Enter p:"
  -- line <- getLine
  let line = "64624507535936447523680179787"
  let p = read line
  print "Enter q:"
  --line <- getLine
  let line = "68549458128220050192491632973"
  let q = read line
  let ln = lcm (p-1) (q-1)
  print $ "RSA's L (l):" ++ (show ln)
  let privExp = genPrivateExponent pExp ln
  print $ "Priave key's expoent (d):" ++ (show $ privExp)
  cipherKey <- BS.readFile (args !! 1)
  print "Cripted key"
  BSChar.putStrLn cipherKey
  print $ "Length of the cripted key:" ++ (show $ BS.length cipherKey)
  let key = BS.map (*(fromInteger privExp)) cipherKey
  print "Uncripted key"
  BSChar.putStrLn key
  BS.writeFile ((args !! 1) ++ ".dec") key
  print $ "Length of the uncripted key:" ++ (show $ BS.length key)
  cipherMenssage <- BS.readFile (args !! 2)
  -- print "Cripted Menssage"
  -- BSChar.putStrLn cipherMenssage
  context <- newAESCtx Decrypt key key
  return ()
