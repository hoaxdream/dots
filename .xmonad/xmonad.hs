-- IMPORTS

-- Base
import XMonad
import XMonad.Config.Desktop
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.WithAll (sinkAll, killAll)

-- Utils
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeysP)

-- Data
import qualified Data.Map as M
import Data.Monoid
import Data.Ratio ((%)) -- for video

-- Hooks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, manageDocks, docksEventHook)
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat, doRectFloat)

-- Layout
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition

-- System
import System.Exit (exitSuccess)
import System.IO (hPutStrLn)

-- Variables
myTerminal = "st"                   -- default terminal
myBrowser = "firefox"               -- default browser
myBorderWidth = 3                   -- width of window border
myModMask = mod4Mask                -- default mod key
myNormColor = "#22262e"             -- unfocus window border
myFocusColor = "#84a0c6"            -- focus window border
myppCurrent = "#84a0c6"             -- current workspace in xmobar
myppVisible = "#cb4b16"             -- visible but not current workspace
myppHidden = "#a3be8c"              -- hidden workspace in xmobar
myppHiddenNoWindows = "#d8dee9"     -- hidden workspace(no windows)
myppTitle = "#84a0c6"               -- active window title in xmobar
myppUrgent = "#dc322f"              -- urgen workspace

-- Workspace
xmobarEscape = concatMap doubleLts
  where doubleLts '<' = "<<"
        doubleLts x   = [x]

myWorkspaces = clickable . (map xmobarEscape) $ ["home","web","chat","games","dev"]
  where
        clickable l = [ "<action=xdotool key super+" ++ show (n) ++ ">" ++ ws ++ "</action>" |
                      (i,ws) <- zip [1..5] l,
                      let n = i ]

windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

-- Window rules
myManageHook = composeAll
    [ className =? "Gimp"   --> doFloat
    , className =? "mpv"    --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , className =? "firefox" <&&> resource =? "Dialog" --> doFloat
    , className =? "firefox" <&&> resource =? "Toolkit" --> doFloat
    , className =? "Steam" --> doFloat
    , className =? "Steam" --> doShift (myWorkspaces !! 2)
    , className =? "Zenity" --> doFloat
    , className =? "Zenity" --> doShift (myWorkspaces !! 2)
    , className =? "firefox" --> doShift (myWorkspaces !! 1)
    , className =? "dota2" --> doShift (myWorkspaces !! 3)
    , className =? "RimWorldLinux" --> doShift(myWorkspaces !! 3)
    , className =? "steam_proton" --> doShift (myWorkspaces !! 3)
    , title =? "Wine System Tray" --> doShift (myWorkspaces !! 4)
    , title =? "Rockstar Games Launcher" --> doShift (myWorkspaces !! 3)
    , title =? "Grand Theft Auto V" --> doShift (myWorkspaces !! 3)
    , title =? "Steam" --> doShift (myWorkspaces !! 2)
    , title =? "tremc" --> doShift (myWorkspaces !! 4)
    , title =? "pulsemixer" --> doRectFloat (W.RationalRect (1 % 4) (1 % 4) (1 % 2) (1 % 2))
    , isFullscreen --> doFullFloat
    ]

-- Keybinds
myKeys =
    [ ("M-S-c", spawn "xmonad --recompile")                                  -- recompile xmonad
    , ("M-S-r", spawn "xmonad --restart")                                    -- restart xmonad
    , ("M-S-<Escape>", io exitSuccess)                                       -- quit xmonad
    , ("M-<Return>", spawn myTerminal)                                       -- spawn terminal
    , ("M-d", spawn "dmenu_run")                                             -- spawn dmenu
    , ("M-q", kill)                                                          -- close focus window
    , ("M-S-q", killAll)                                                     -- kill all window in current workspace
    , ("M-h", sendMessage Shrink)                                            -- shrink master
    , ("M-l", sendMessage Expand)                                            -- expand master
    , ("M-S-.", sendMessage (IncMasterN (-1)))                               -- deincrement window in master
    , ("M-S-,", sendMessage (IncMasterN 1))                                  -- increment window in master
    , ("M-m", windows W.focusMaster)                                         -- focus master window
    , ("M-j", windows W.focusDown)                                           -- focus next window
    , ("M-k", windows W.focusUp)                                             -- focus prev window
    , ("M-<Space>", sendMessage NextLayout)                                  -- select layout
    , ("M-t", withFocused $ windows . W.sink)                                -- push floating window to tile
    , ("M-S-t", sinkAll)                                                     -- push all floating to tile
    , ("M-<F8>", spawn (myTerminal ++ " -e pulsemixer"))                     -- pulsemixer
    , ("M-=", spawn ("pamixer --allow-boost -i 3"))                          -- +vol
    , ("M--", spawn ("pamixer --allow-boost -d 3"))                          -- -vol
    , ("M-S-p", spawn (myTerminal ++ " -e ncmpcpp"))                         -- ncmpcpp
    , ("M-p", spawn ("mpc toggle"))                                          -- play/pause music
    , ("M-,", spawn ("mpc prev"))                                            -- prev music
    , ("M-.", spawn ("mpc next"))                                            -- next music
    , ("M-[", spawn ("mpc seek -10"))                                        -- seek muisc backward
    , ("M-]", spawn ("mpc seek +10"))                                        -- seek music forward
    , ("<XF86AudioRaiseVolume>", spawn "pamixer --allow-boost -i 3")         -- media-key vol-up
    , ("<XF86AudioLowerVolume>", spawn "pamixer --allow-boost -d 3")         -- media-key vol-down
    , ("M-b", spawn "firefox")                                               -- firefox
    , ("M-x", spawn "dprompt \"Shutdown?\" \"sudo -A systemctl poweroff\"")  -- shutdown prompt dmenu
    , ("M-r", spawn "dprompt \"Reboot?\" \"sudo -A systemctl reboot\"")      -- reboot prompt dmenu
    , ("M-<Escape>", spawn "dprompt \"kill Xorg?\" \"killall Xorg\"")        -- killxorg prompt dmenu
    , ("M-<F9>", spawn "dmount")                                             -- mount drive
    , ("M-<F10>", spawn "dumount")                                           -- umount drive
    , ("M-S-m", spawn "dmanterm")                                            -- man-page in terminal
    , ("M-z", spawn "dmanzathura")                                           -- man-page in zathura
    , ("M-<Insert>", spawn "showclip")                                       -- toggle clipboard
    , ("M-`", spawn "dunicode")                                              -- emoji in dmenu
    , ("M-S-n", spawn "dnote")                                               -- dmenu notes
    , ("M-s", spawn "dmpd")                                                  -- mpd playlist search in dmenu
    , ("M-w", spawn "dweb")                                                  -- shortcut links in dmenu
    , ("M-<Print>", spawn "maimpick")                                        -- screenshot modes
    , ("<Print>", spawn "pixshot")                                           -- full screen shot
    , ("M-g", spawn "sudo -A gparted")                                       -- gparted with dmenu pass prompt
    , ("M-<F12>", spawn (myTerminal ++ " -e tremc"))                         -- torrent
    , ("M-e", spawn (myTerminal ++ " -e vifmrun"))                           -- vifm
    , ("M-n", spawn (myTerminal ++ " -e newsboat"))                          -- newsboat
    , ("M-c", spawn (myTerminal ++ " -e calcurse"))                          -- calurse
    ]

-- Layout
myLayout = avoidStruts (tiled ||| full ||| grid ||| bsp)
    where
        -- Full
        full = renamed [Replace "F"]
                $ noBorders (Full)
        -- Tiled
        tiled = renamed [Replace "||"]
                $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True
                $ ResizableTall 1 (3/100) (1/2) []
        -- Grid
        grid = renamed [Replace "#"] 
                $ spacingRaw True (Border 10 0 10 0) True (Border 0 10 0 10) True 
                $ Grid (16/10)
        -- Bsp
        bsp = renamed [Replace "BSP"]
                $ emptyBSP
        -- Default number of windows in master pane
        nmaster = 1
        -- Default proportion of screen occupied by master pane
        ratio = 1/2
        -- Percent of screen to increment by when resizing panes
        delta = 3/100

-- Main
main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh desktopConfig
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageHook desktopConfig <+> manageDocks
        , terminal = myTerminal
        , workspaces = myWorkspaces
        , borderWidth = myBorderWidth
        , normalBorderColor = myNormColor
        , focusedBorderColor = myFocusColor
        , handleEventHook = handleEventHook defaultConfig <+> docksEventHook
        , layoutHook = smartBorders $ myLayout
        , logHook = dynamicLogWithPP xmobarPP
                        { ppOutput = hPutStrLn xmproc
                        , ppCurrent = xmobarColor myppCurrent "" . wrap "[" "]"
                        , ppVisible = xmobarColor myppVisible ""
                        , ppHidden = xmobarColor myppHidden "" . wrap "+" ""
                        , ppHiddenNoWindows = xmobarColor  myppHiddenNoWindows ""
                        , ppTitle = xmobarColor myppTitle "" . shorten 30
                        , ppUrgent = xmobarColor myppUrgent "" . wrap "!" "!"
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        , modMask = myModMask
        }
        `additionalKeysP` myKeys
