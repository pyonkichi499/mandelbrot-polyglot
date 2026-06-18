{-# LANGUAGE BangPatterns #-}

module Mandelbrot
    ( baseWidth
    , baseHeight
    , defaultScale
    , dimensionsFromScale
    , width
    , height
    , xMin
    , xMax
    , yMin
    , yMax
    , maxIterations
    , escapeRadiusSq
    , palette
    , mandelbrot
    , color
    , pixelToComplex
    ) where

baseWidth :: Int
baseWidth = 800

baseHeight :: Int
baseHeight = 600

defaultScale :: Int
defaultScale = 2

dimensionsFromScale :: Int -> (Int, Int)
dimensionsFromScale s = (baseWidth * s, baseHeight * s)

width :: Int
width = fst (dimensionsFromScale defaultScale)

height :: Int
height = snd (dimensionsFromScale defaultScale)

xMin :: Double
xMin = -2.5

xMax :: Double
xMax = 1.0

yMin :: Double
yMin = -1.3125

yMax :: Double
yMax = 1.3125

maxIterations :: Int
maxIterations = 100

escapeRadiusSq :: Double
escapeRadiusSq = 4.0

palette :: [(Int, Int, Int)]
palette =
    [ ( 66,  30,  15)
    , ( 25,   7,  26)
    , (  9,   1,  47)
    , (  4,   4,  73)
    , (  0,   7, 100)
    , ( 12,  44, 138)
    , ( 24,  82, 177)
    , ( 57, 125, 209)
    , (134, 181, 229)
    , (211, 236, 248)
    , (241, 233, 191)
    , (248, 201,  95)
    , (255, 170,   0)
    , (204, 128,   0)
    , (153,  87,   0)
    , (106,  52,   3)
    ]

mandelbrot :: Double -> Double -> Int
mandelbrot !cx !cy = go 0 0.0 0.0
  where
    go :: Int -> Double -> Double -> Int
    go !n !zr !zi
        | n >= maxIterations       = maxIterations
        | zrSq + ziSq > escapeRadiusSq = n
        | otherwise                = go (n + 1) (zrSq - ziSq + cx) (2.0 * zr * zi + cy)
      where
        !zrSq = zr * zr
        !ziSq = zi * zi

color :: Int -> (Int, Int, Int)
color n
    | n == maxIterations = (0, 0, 0)
    | otherwise          = palette !! (n `mod` 16)

pixelToComplex :: Int -> Int -> Int -> Int -> (Double, Double)
pixelToComplex row col w h = (cx, cy)
  where
    cx = xMin + fromIntegral col * (xMax - xMin) / fromIntegral w
    cy = yMax - fromIntegral row * (yMax - yMin) / fromIntegral h
