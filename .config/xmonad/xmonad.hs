import XMonad
import System.IO (hPutStrLn)

import XMonad.Actions.UpdatePointer
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Operations (unGrab)

-- Layouts
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Layout.ThreeColumns
import XMonad.Layout.SideBorderDecoration

-- Hooks
import XMonad.Hooks.EwmhDesktops    -- Better handling of windows/panels
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP (dynamicLogWithPP)


-- ===============================================
-- Variables
-- ===============================================

-- Colorshcheme
myFocusedColor    = "#dbdad2"
myUnfocusedColor  = "#817E77"

-- Default applications
myTerm :: String
myBrowser :: String

myTerm = "kitty"
myBrowser = "zen-browser"

-- Workspaces 
myWorkspaces :: [String]
myWorkspaces = 
  ["1:www"
  , "2:dev"
  , "3:term"
  , "4:ref"
  , "5:git" 
  , "6:note"
  , "7:mpd"
  , "8:chat"
  , "9:misc"
  ]


-- ===============================================
-- Keybindings
-- ===============================================
myKeys :: [(String, X ())]
myKeys =
  [ ("M-<Return>",    spawn myTerm)
  , ("M-S-f",         spawn myBrowser)
    
    -- Screenshot bindings
  , ("<Print>",       unGrab *> spawn   "flameshot screen -p $HOME/Pictures/Screenshots/")
  , ("M-<Print>",     unGrab *> spawn   "flameshot gui -p $HOME/Pictures/Screenshots/")
  , ("M-S-<Print>",   unGrab *> spawn   "flameshot gui -c")
    
    -- Betterlockscreen
  , ("M-z",           spawn "betterlockscreen -l")
    
    -- Rofi
  , ("M-d",           spawn "$HOME/.config/rofi/launchers/type-1/launcher.sh")
  , ("M-x",           spawn "$HOME/.config/rofi/powermenu/type-1/powermenu.sh")
    
    -- Special Keys
  , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle" )
    
    -- Brightness
  , ("<XF86MonBrightnessUp>", spawn "brightnessctl set +10%")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 10%-")

    -- Apps
  , ("M-o",    spawn "obsidian")

    -- Scripts
  , ("M-<Tab>", spawn "$HOME/dotfiles/scripts/toggle_keyboard")
  ]


-- ===============================================
-- Manage Hook
-- ===============================================
myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "Blueman-manager"      --> doCenterFloat
  , className =? "xmessage"             --> doCenterFloat
  , className =? "pavucontrol"          --> doCenterFloat
  , isDialog                            --> doFloat 
  ]


-- ===============================================
-- Layout Hook 
-- ===============================================
myLayout = smartBorders . spacing 8 $ tiled ||| Mirror tiled ||| noBorders Full ||| threeCol
  where 
    tiled       = Tall nmaster delta ratio                         -- Tall Layout
    threeCol    = ThreeColMid nmaster delta ratio                  -- Three columns layout
    nmaster     = 1                                                -- Default number of windows in the master pane
    ratio       = 1/2                                              -- Default proportion of screen occupied by master pane
    delta       = 3/100                                            -- Percent of screen to increment by when resizing panes


-- ===============================================
-- Startup Hook
-- ===============================================
myStartupHook = do
 spawnOnce "picom" 
 spawnOnce "feh --bg-fill $HOME/Pictures/wallpapers/gustavedore.png" 
 spawnOnce "betterlockscreen -u $HOME/Pictures/wallpapers/gustavedore.png"
 spawn "dunst -config $HOME/.config/dunst/dunstrc" 
 spawn "xset r rate 230 50"
 spawn "xrandr --output HDMI-1-0 --mode 1920x1080 --primary --rate 75 --left-of eDP-1 --auto"


-- ===============================================
--              XMOBAR CONFIGURATION
-- ===============================================

-- Xmobar Hook
myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = lowWhite " --> "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Bottom" "#" 1
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . white        . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . lowWhite     . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 20

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#dbdad2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#817E77" ""


-- Dynamic Xmobar
barSpawner :: ScreenId -> X StatusBarConfig
barSpawner 0 = pure xmobarTop
barSpawner 1 = pure xmobarSec
barSpawner _ = mempty

xmobarTop :: StatusBarConfig
xmobarTop = statusBarPropTo "_XMONAD_LOG_1"
  "xmobar -x 0 $HOME/.config/xmonad/xmobarrc"
  (pure myXmobarPP)

xmobarSec :: StatusBarConfig
xmobarSec = statusBarPropTo "_XMONAD_LOG_3"
  "xmobar -x 1 $HOME/.config/xmonad/xmobarrc"
  (pure myXmobarPP)


-- ===============================================
--                Main Configuration
-- ===============================================
myConfig = def
  { modMask       = mod4Mask -- Setting Super as mod key
  , layoutHook    = myLayout
  , manageHook    = myManageHook
  , startupHook   = myStartupHook
  , workspaces    = myWorkspaces 
  , logHook       = updatePointer (0.5, 0.5) (0, 0)
  , normalBorderColor   = myUnfocusedColor
  , focusedBorderColor  = myFocusedColor
  }
  `additionalKeysP` myKeys


-- ===============================================
--                  Main Function
-- ===============================================
main :: IO ()
main = xmonad 
     . ewmhFullscreen 
     . ewmh 
     . withEasySB(statusBarProp "xmobar $HOME/dotfiles/.config/xmonad/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     . dynamicEasySBs barSpawner
     $ myConfig
