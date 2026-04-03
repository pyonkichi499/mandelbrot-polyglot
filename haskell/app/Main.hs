module Main where

import Mandelbrot (width, height, mandelbrot, color, pixelToComplex)
import Data.ByteString.Builder (Builder, intDec, char7, string7, hPutBuilder)
import System.IO (withFile, IOMode(WriteMode))

main :: IO ()
main = do
    withFile "mandelbrot.ppm" WriteMode $ \h -> hPutBuilder h image
    putStrLn "Written mandelbrot.ppm"

image :: Builder
image = header <> pixels
  where
    header = string7 "P3\n"
          <> intDec width <> char7 ' ' <> intDec height <> char7 '\n'
          <> string7 "255\n"
    pixels = mconcat [ pixel row col | row <- [0 .. height - 1], col <- [0 .. width - 1] ]

pixel :: Int -> Int -> Builder
pixel row col =
    let (cx, cy) = pixelToComplex row col
        n        = mandelbrot cx cy
        (r, g, b) = color n
    in  intDec r <> char7 ' ' <> intDec g <> char7 ' ' <> intDec b <> char7 '\n'
