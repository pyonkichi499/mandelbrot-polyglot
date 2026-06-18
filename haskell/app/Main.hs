module Main where

import Mandelbrot
    ( defaultScale
    , dimensionsFromScale
    , mandelbrot
    , color
    , pixelToComplex
    )
import Data.ByteString.Builder (Builder, intDec, char7, string7, hPutBuilder)
import System.Environment (getArgs)
import System.Exit (exitFailure)
import System.IO (withFile, IOMode(WriteMode))
import Text.Read (readMaybe)

main :: IO ()
main = do
    args <- getArgs
    case parseArgs args of
        Left err -> do
            putStrLn err
            printUsage
            exitFailure
        Right (scale, path) -> do
            let (w, h) = dimensionsFromScale scale
            withFile path WriteMode $ \hnd -> hPutBuilder hnd (image w h)
            putStrLn ("Written " ++ path)

printUsage :: IO ()
printUsage = do
    putStrLn $
        "Usage: mandelbrot [--scale N] [--output PATH]\n\
        \\n\
        \--scale N, -s N   Integer scale relative to base 800x600 (default: "
        ++ show defaultScale
        ++ "). 1->800x600, 2->1600x1200, ...\n\
        \--output PATH, -o PATH   Output PPM (default: mandelbrot.ppm for scale "
        ++ show defaultScale
        ++ ", else mandelbrot-Nx.ppm)\n"

defaultOutputPath :: Int -> FilePath
defaultOutputPath s
    | s == defaultScale = "mandelbrot.ppm"
    | otherwise         = "mandelbrot-" ++ show s ++ "x.ppm"

parseArgs :: [String] -> Either String (Int, FilePath)
parseArgs [] = Right (defaultScale, defaultOutputPath defaultScale)
parseArgs ("--help" : _) = Left ""
parseArgs ("-h" : _) = Left ""
parseArgs xs = go (Just defaultScale) Nothing xs
  where
    go _ _ ("--help" : _) = Left ""
    go _ _ ("-h" : _) = Left ""
    go _ out ("--scale" : s : rest) =
        case readMaybe s of
            Nothing -> Left ("invalid scale: " ++ s)
            Just n | n < 1     -> Left "scale must be >= 1"
                   | otherwise -> go (Just n) out rest
    go _ out ("-s" : s : rest) =
        case readMaybe s of
            Nothing -> Left ("invalid scale: " ++ s)
            Just n | n < 1     -> Left "scale must be >= 1"
                   | otherwise -> go (Just n) out rest
    go sc _ ("--output" : p : rest) = go sc (Just p) rest
    go sc _ ("-o" : p : rest) = go sc (Just p) rest
    go _ _ (a : _) = Left ("unknown argument: " ++ a)
    go sc out [] =
        let s = case sc of
                Nothing -> defaultScale
                Just n  -> n
        in Right (s, maybe (defaultOutputPath s) id out)

image :: Int -> Int -> Builder
image w h = header w h <> pixels w h

header :: Int -> Int -> Builder
header w h =
    string7 "P3\n"
        <> intDec w <> char7 ' ' <> intDec h <> char7 '\n'
        <> string7 "255\n"

pixels :: Int -> Int -> Builder
pixels w h =
    mconcat [ pixel w h row col | row <- [0 .. h - 1], col <- [0 .. w - 1] ]

pixel :: Int -> Int -> Int -> Int -> Builder
pixel w h row col =
    let (cx, cy) = pixelToComplex row col w h
        n        = mandelbrot cx cy
        (r, g, b) = color n
    in  intDec r <> char7 ' ' <> intDec g <> char7 ' ' <> intDec b <> char7 '\n'
