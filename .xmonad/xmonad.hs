import XMonad
import XMonad.Config.Desktop

-- Core
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import System.Exit
import Graphics.X11.Xlib
import Graphics.X11.ExtraTypes.XF86
--import IO (Handle, hPutStrLn)
import qualified System.IO
import XMonad.Actions.CycleWS (nextScreen,prevScreen)
import Data.List

  -- Prompts
import XMonad.Prompt
import XMonad.Prompt.Shell

  -- Actions
import XMonad.Actions.MouseGestures
import XMonad.Actions.UpdatePointer
import XMonad.Actions.GridSelect

  -- Utils
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.Scratchpad
-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.Place
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.DragPane
import XMonad.Layout.LayoutCombinators hiding ((|||))
import XMonad.Layout.DecorationMadness
import XMonad.Layout.TabBarDecoration
import XMonad.Layout.IM
import XMonad.Layout.Grid
import XMonad.Layout.Spiral
import XMonad.Layout.Mosaic
import XMonad.Layout.LayoutHints

import Data.Ratio ((%))
import XMonad.Layout.ToggleLayouts
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Gaps
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.SetWMName

xmobarTitleColor = "#FFB6B0"

xmobarCurrentWorkspaceColor = "green"

myWorkspaces :: [String]
myWorkspaces = ["1:term", "2:web", "3:kubernetes"] ++ map show [4..9]

myLayoutHook = gaps [(U,18)] $ Tall 1 (3/100) (1/2) ||| Full

baseConfig = defaultConfig
       { workspaces         = myWorkspaces
       , terminal           = "xterm -rv"
       , modMask            = mod4Mask
       , handleEventHook    = fullscreenEventHook
       , layoutHook         = myLayoutHook
       , manageHook         = manageDocks <+> manageHook defaultConfig
       , startupHook        = setWMName "LG3D"
       }

main = do
  xmproc <- spawnPipe "/usr/bin/env xmobar ~/.xmonad/xmobar.hs"
  xmonad $ baseConfig {
    logHook =  dynamicLogWithPP $ defaultPP {
        ppOutput = System.IO.hPutStrLn xmproc
        , ppTitle = xmobarColor xmobarTitleColor "" . shorten 100
        , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "" . wrap "[" "]"
        , ppSep = "   "
        , ppWsSep = " "
        , ppLayout  = (\ x -> case x of
                          "Spacing 6 Mosaic"                      -> "[:]"
                          "Spacing 6 Mirror Tall"                 -> "[M]"
                          "Spacing 6 Hinted Tabbed Simplest"      -> "[T]"
                          "Spacing 6 Full"                        -> "[ ]"
                          _                                       -> x )
        , ppHiddenNoWindows = showNamedWorkspaces
        }
    } where showNamedWorkspaces wsId = if any (`elem` wsId) ['a'..'z']
                                       then pad wsId
                                       else ""
