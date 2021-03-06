{-# LANGUAGE CPP #-}
module Data.Lens.Light.State
  ( access
  , (~=)
  , (!=)
  , (%=)
  , (!%=)
  )
  where

import Control.Monad.State
import Data.Lens.Light.Core

-- | Get the value of a lens into state
access :: MonadState a m => Lens a b -> m b
access l = gets (getL l)

-- | Set a value using a lens into state
(~=) :: MonadState a m => Lens a b -> b -> m ()
l ~= b = modify $ setL l b

-- | Set a value using a lens into state. Forces both the value and the
-- whole state.
(!=) :: MonadState a m => Lens a b -> b -> m ()
l != b = modify' $ setL l $! b

#if !MIN_VERSION_mtl(2,2,0)
-- Copied from mtl-2.2.0.1
modify' :: MonadState s m => (s -> s) -> m ()
modify' f = state (\s -> let s' = f s in s' `seq` ((), s'))
#endif

infixr 4 ~=, !=

-- | Infix modification of a value through a lens into state
(%=) :: MonadState a m => Lens a b -> (b -> b) -> m ()
l %= f = modify $ modL l f

-- | Infix modification of a value through a lens into state. Forces both
-- the function application and the whole state.
(!%=) :: MonadState a m => Lens a b -> (b -> b) -> m ()
l !%= f = modify' $ modL' l f

infixr 4 %=, !%=
