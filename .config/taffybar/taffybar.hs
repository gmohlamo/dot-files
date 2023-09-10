{-# LANGUAGE OverloadedStrings #-}
-- -*- mode:haskell -*-
module Main where

import Data.Default (def)
import System.FilePath
import System.Taffybar
import System.Taffybar.Hooks
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget
import System.Taffybar.Widget.FreedesktopNotifications
import System.Taffybar.Widget.Generic.PollingLabel
import System.Taffybar.Widget.Generic.Graph
import System.Taffybar.Widget.Generic.PollingGraph
import System.Taffybar.Widget.Util
import System.Taffybar.Widget.Workspaces
import System.Taffybar.Widget.Layout
import System.Log.Logger
import System.Taffybar.Information.EWMHDesktopInfo
import System.Taffybar.Widget.SNITray
import System.Taffybar.Information.CPU


main = do
  --cssPath <- (</> "taffybar.css") <$> getDataDir
  let cssPath = "/home/gladwin/.config/taffybar/taffybar.css"
  print cssPath
  -- remove this if it does not work
  let myWorkspacesConfig =
        defaultWorkspacesConfig
        { minIcons = 0
        , maxIcons = Just 0
        , widgetGap = 0
        , showWorkspaceFn = hideEmpty
        , getWindowIconPixbuf = \_ _ -> return Nothing
        , updateEvents =
          [ "_NET_CURRENT_DESKTOP"
          , "_NET_NUMBER_OF_DESKTOPS"
          , "_NET_DESKTOP_NAMES"
          , "_NET_NUMBER_OF_DESKTOPS"
          ]
        , updateRateLimitMicroseconds = 200000
        }
      workspaces = workspacesNew myWorkspacesConfig
      clock = textClockNewWith
                defaultClockConfig { clockUpdateStrategy = RoundedTargetInterval 60 0.0
                                   , clockFormatString = "%a %b %_d ⏰%R"
                                   }
      layout = layoutNew defaultLayoutConfig
      windows = windowsNew defaultWindowsConfig
      myMpris = mpris2New
          -- See https://github.com/taffybar/gtk-sni-tray#statusnotifierwatcher
          -- for a better way to set up the sni tray
      tray = sniTrayNew
      --tray = sniTrayThatStartsWatcherEvenThoughThisIsABadWayToDoIt
      myConfig = defaultSimpleTaffyConfig
        { startWidgets =
            workspaces :
            map (>>= buildContentsBox) [ windows, layout ]
        , endWidgets = map (>>= buildContentsBox)
          [ clock
          , tray
          , myMpris
          ]
        , barPosition = Top
        , barPadding = 0
        , barHeight = ExactSize 25
        , widgetSpacing = 5
        , cssPaths = [cssPath]
        }
  --dyreTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $
  --             toTaffyConfig myConfig

  logger <- getLogger "System.Taffybar"
  saveGlobalLogger $ setLevel INFO logger

  startTaffybar $ withBatteryRefresh $ withLogServer $ withToggleServer $ toTaffyConfig myConfig

-- https://hackage.haskell.org/package/taffybar-4.0.0/docs/System-Taffybar.html
-- https://hackage.haskell.org/package/taffybar-4.0.0/docs/
--
-- https://github.com/bgamari/xmonad-config/blob/master/taffybar-ben/taffybar.hs
-- https://github.com/colonelpanic8/dotfiles/blob/master/dotfiles/config/taffybar/taffybar.hs
-- https://github.com/colonelpanic8/taffybar-sni-example/blob/master/taffybar.hs
