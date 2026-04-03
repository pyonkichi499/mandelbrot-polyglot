module Main (main) where

import Test.Hspec
import Mandelbrot (width, height, maxIterations, mandelbrot, color, pixelToComplex)

main :: IO ()
main = hspec spec

nearlyEqual :: Double -> Double -> Double -> Bool
nearlyEqual epsilon expected actual = abs (actual - expected) < epsilon

spec :: Spec
spec = do
    describe "定数" $ do
        it "画像幅は800" $
            width `shouldBe` 800

        it "画像高さは600" $
            height `shouldBe` 600

        it "最大反復回数は100" $
            maxIterations `shouldBe` 100

    describe "mandelbrot" $ do
        it "原点は集合の内部" $
            mandelbrot 0.0 0.0 `shouldBe` 100

        it "マイナス1は集合の内部" $
            mandelbrot (-1.0) 0.0 `shouldBe` 100

        it "遠方の点はすぐ発散" $
            mandelbrot 2.0 0.0 `shouldBe` 2

        it "境界付近の点" $
            mandelbrot 1.0 0.0 `shouldBe` 3

        it "左端外の点" $
            mandelbrot (-2.1) 0.0 `shouldBe` 1

        it "複素平面上の点" $
            mandelbrot 0.5 0.5 `shouldBe` 5

    describe "color" $ do
        it "集合内の点は黒" $
            color 100 `shouldBe` (0, 0, 0)

        it "パレットの循環" $
            color 0 `shouldBe` color 16

    describe "pixelToComplex" $ do
        it "ピクセル座標の左上" $ do
            let (cx, cy) = pixelToComplex 0 0
            cx `shouldSatisfy` nearlyEqual 1e-9 (-2.5)
            cy `shouldSatisfy` nearlyEqual 1e-9 1.3125

        it "ピクセル座標の原点付近" $ do
            let (cx, cy) = pixelToComplex 300 571
            cx `shouldSatisfy` nearlyEqual 0.01 0.0
            cy `shouldSatisfy` nearlyEqual 0.01 0.0
