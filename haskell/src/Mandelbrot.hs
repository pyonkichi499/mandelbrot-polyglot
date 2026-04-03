{-# LANGUAGE BangPatterns #-}

module Mandelbrot
    ( width
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

width :: Int
width = 800

height :: Int
height = 600

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

pixelToComplex :: Int -> Int -> (Double, Double)
pixelToComplex row col = (cx, cy)
  where
    cx = xMin + fromIntegral col * (xMax - xMin) / fromIntegral width
    cy = yMax - fromIntegral row * (yMax - yMin) / fromIntegral height
