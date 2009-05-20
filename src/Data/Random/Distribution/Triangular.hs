{-
 -      ``Data/Random/Distribution/Triangular''
 -}
{-# LANGUAGE
    MultiParamTypeClasses,
    FlexibleInstances, FlexibleContexts,
    UndecidableInstances
  #-}

module Data.Random.Distribution.Triangular where

import Data.Random.RVar
import Data.Random.Distribution
import Data.Random.Distribution.Uniform

data Triangular a = Triangular
    { triLower  :: a
    , triMid    :: a
    , triUpper  :: a
    } deriving (Eq, Show)

realFloatTriangular :: (Floating a, Ord a, Distribution Uniform a) => a -> a -> a -> RVar a
realFloatTriangular a b c
    | a <= b && b <= c
    = do
        let p = (c-b)/(c-a)
        u <- uniform 0 1
        let d   | u >= p    = a
                | otherwise = c
            x   | u >= p    = (u - p) / (1 - p)
                | otherwise = u / p
-- may prefer this: reusing u costs resolution, especially if p or 1-p is small and c-a is large.
--        x <- uniform 0 1
        return (b - ((1 - sqrt x) * (b-d)))

instance (Floating a, Ord a, Distribution Uniform a) => Distribution Triangular a where
    rvar (Triangular a b c) = realFloatTriangular a b c