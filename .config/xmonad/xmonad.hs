import XMonad
import System.IO (hPutStrLn)

import XMonad.Actions.UpdatePointer

import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce
import XMonad.Operations (unGrab)

-- Layouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Spacing
import XMonad.Layout.SideBorderDecoration

-- Hooks
import XMonad.Hooks.EwmhDesktops    -- Better handling of windows/panels
import XMonad.Hooks.ManageHelpers
---- Xmobar Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP (dynamicLogWithPP)

-- Variables
myFocusedColor    = "#dbdad2"
myUnfocusedColor  = "#817E77"
myTerm            = "kitty"

-- Main Configuration
myConfig = def
  {
    modMask       = mod4Mask, -- Setting Super as mod key
    layoutHook    = myLayout,
    manageHook    = myManageHook,
    startupHook   = myStartupHook,
    workspaces    = myWorkspaces, 

    -- Pointer follows focus
    logHook       = updatePointer (0.5, 0.5) (0, 0),

    -- Border colors   
    normalBorderColor   = myUnfocusedColor,
    focusedBorderColor  = myFocusedColor
  }
  `additionalKeysP` myKeys

-- Dynamic Xmobar
barSpawner :: ScreenId -> X StatusBarConfig
barSpawner 0 = pure xmobarTop   -- dos barras en el monitor principal
barSpawner 1 = pure xmobarSec                     -- una barra en el segundo monitor
barSpawner _ = mempty                             -- nada en otros monitores

xmobarTop :: StatusBarConfig
xmobarTop    = statusBarPropTo "_XMONAD_LOG_1"
                "xmobar -x 0 $HOME/.config/xmonad/xmobarrc"
                (pure myXmobarPP)

xmobarSec :: StatusBarConfig
xmobarSec    = statusBarPropTo "_XMONAD_LOG_3"
                "xmobar -x 1 $HOME/.config/xmonad/xmobarrc"
                (pure myXmobarPP)

-- Workspaces 
myWorkspaces :: [String]
myWorkspaces = ["1:www", "2:dev", "3:term", "4:ref", "5:git" , "6:note", "7:mpd", "8:chat", "9:misc"]

myKeys :: [(String, X ())]
myKeys =
  [
  ("M-<Return>",    spawn myTerm),
  ("M-d",           spawn "$HOME/.config/rofi/launchers/type-1/launcher.sh"),
  ("M-S-f",         spawn "zen-browser"),

  -- Screenshot bindings
  ("<Print>",       unGrab *> spawn   "flameshot screen -p $HOME/Pictures/Screenshots/"),
  ("M-<Print>",     unGrab *> spawn   "flameshot gui -p $HOME/Pictures/Screenshots/"),
  ("M-S-<Print>",   unGrab *> spawn   "flameshot gui -c")
  ]

-- Manage Hook
myManageHook :: ManageHook
myManageHook = composeAll
  [
  className =? "Blueman-manager"      --> doFloat,
  className =? "xmessage"             --> doFloat,
  isDialog                            --> doFloat 
  ]

-- Layout Hook 
myLayout = spacing 8 $ tiled ||| Mirror tiled ||| Full ||| threeCol
  where 
    tiled       = Tall nmaster delta ratio                         -- Tall Layout
    threeCol    = ThreeColMid nmaster delta ratio                  -- Three columns layout
    nmaster     = 1                                                -- Default number of windows in the master pane
    ratio       = 1/2                                              -- Default proportion of screen occupied by master pane
    delta       = 3/100                                            -- Percent of screen to increment by when resizing panes


-- Startup Hook
myStartupHook = do
 spawnOnce "picom" 
 spawnOnce "feh --bg-fill $HOME/Pictures/wallpapers/gustavedore.png" 
 spawn "dunst -config $HOME/.config/dunst/dunstrc" 
 spawn "xset r rate 230 50"
 spawn "xrandr --output HDMI-1-0 --mode 1920x1080 --primary --rate 75 --left-of eDP-1 --auto"

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
    formatFocused   = wrap (white    "[") (white    "]") . white . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 20

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#dbdad2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#817E77" ""



-- Main Function
main :: IO ()
main = xmonad 
     . ewmhFullscreen 
     . ewmh 
     . withEasySB(statusBarProp "xmobar $HOME/dotfiles/.config/xmonad/xmobarrc" (pure myXmobarPP)) defToggleStrutsKey
     . dynamicEasySBs          barSpawner
     $ myConfig
