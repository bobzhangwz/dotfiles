module Main where

import Control.Monad
import XMonad
import XMonad.Config.Xfce
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Actions.SpawnOn
import Data.Monoid
import Data.List
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import qualified XMonad.Actions.Navigation2D as N
import qualified XMonad.Layout.Magnifier as Mag
import XMonad.Actions.SinkAll
import XMonad.Layout.Maximize
import XMonad.Util.EZConfig
import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.Reflect
import XMonad.Layout.MultiToggle
import XMonad.Actions.FloatKeys
import XMonad.Actions.CycleRecentWS
import XMonad.Layout.ResizableTile
import XMonad.Layout.WindowNavigation
import XMonad.Layout.IM
import XMonad.Layout.Mosaic
import XMonad.Layout.SimpleFloat
import XMonad.Layout.AutoMaster
import XMonad.Layout.DragPane
import XMonad.Layout.NoBorders
import XMonad.Layout.Grid
import XMonad.Hooks.UrgencyHook
import qualified XMonad.Actions.Search as S
import qualified XMonad.Layout.PerWorkspace as PerW
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Util.NamedScratchpad
import XMonad.Actions.GridSelect
import XMonad.Prompt.RunOrRaise
import XMonad.Prompt.Man
import XMonad.Layout.WorkspaceDir
import XMonad.Prompt.XMonad
import XMonad.Util.Run
import XMonad.Hooks.FadeWindows
import XMonad.Hooks.DynamicLog
import XMonad.Prompt.Shell

--- Refer from:
-- https://gist.github.com/jsjolund/94f6821b248ff79586ba
-- https://gist.github.com/yeban/311016
-- https://github.com/simplonco/xmonad-config/blob/master/xmonad.hs

-- Theme {{{
-- Color names are easier to remember:
colorOrange         = "#FD971F"
colorDarkGray       = "#1B1D1E"
colorPink           = "#F92672"
colorGreen          = "#A6E22E"
colorBlue           = "#66D9EF"
colorYellow         = "#E6DB74"
colorWhite          = "#CCCCC6"
colorNormalBorder   = "#CCCCCp6"
colorFocusedBorder  = "#FF0000"
xftFont = "xft:monofur for Powerline:size=14"
--}}}

(~=?) :: Eq a => Query [a] -> [a] -> Query Bool
q ~=? x = fmap (isPrefixOf x) q

--myTerminal = "xfce4-terminal"
myTerminal = "urxvtc"

withProxy command = "http_proxy=\"http://127.0.0.1:8888\" https_proxy=\"http://127.0.0.1:8888\" " ++ command

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth = 3
myWorkspaces = ["web", "editor", "info", "chat", "mail","vbox", "media", "gimp", "swap", "shell"]
myNormalBorderColor  = "#dddddd"
myFocusedBorderColor = "#ff0000"

myXPConfig :: XPConfig
myXPConfig = defaultXPConfig {
    font                  = xftFont
    , bgColor               = colorDarkGray
    , fgColor               = colorGreen
    , bgHLight              = colorGreen
    , fgHLight              = colorDarkGray
    , promptBorderWidth     = 0
    , height                = 22
    , historyFilter         = deleteConsecutive
    , promptKeymap          = emacsLikeXPKeymap
  }

myGSConfig :: HasColorizer a => GSConfig a
myGSConfig = def {
  gs_font = "xft:WenQuanYi Micro Hei Mono Light:size=9"
}
myGSCmd :: [String]
myGSCmd = [
    "emacsclient -c"
    , "google-chrome-stable --incognito"
    , "urxvtd -q -f -o"
    , "emacs -daemon"
  ]

myCommands :: [(String, X ())]
myCommands = [
  ("mail_tw", spawn . chrome $ "https://mail.google.com/mail/u/1/#inbox")
  , ("calendar_tw", spawn . chrome $ "https://calendar.google.com/calendar/b/1/r")
  , ("mail_self", spawn . chrome $ "https://mail.google.com/mail/u/0/#inbox")
  , ("trello", spawn . chrome $ "https://trello.com/b/5k7cKgLN/works")
  , ("notion", spawn . chrome $ "https://www.notion.so/zhpooer/e0414f48794f4709b8ef86a21c9437a8?v=d087bd7e392a4cc48b85f3c5d8696400")
  , ("todoist", spawn . chrome $ "https://todoist.com/app#project%2F377591330")
  , ("jira", spawn . chrome $ "https://reagroup.atlassian.net/secure/RapidBoard.jspa?rapidView=745")
  , ("slack", spawn . chrome $ "https://app.slack.com/client/T027TU47K/GQHU1Q8QZ")
  , ("outlook_rea", spawn . chrome $ "https://outlook.office.com/calendar/view/week")
  , ("zeplin", spawn . chrome $ "https://app.zeplin.io/project/5d3e294dd20d6b0dd909d8ed/")
  , ("music163", spawn . chrome $ "https://music.163.com/#/my/m/music/playlist")
  , ("dingding", spawn . chrome $ "https://im.dingtalk.com/")
  , ("evernote", spawn "google-chrome-stable --app=https://app.yinxiang.com/Home.action --enable-extensions")
  , ("terminal_cfw", spawn . withProxy $ myTerminal)
  ] where
     chrome url = "google-chrome-stable --app=" ++ url

myStartupHook = do
    spawnOn "web" "firefox"
    -- spawnOn "vbox" "virtualbox"
    spawn "urxvtd -q -f -o"
    spawn "emacs -daemon"
    -- spawn "udiskie --tray"
    -- spawn "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1"
    -- spawn "fcitx"
    -- spawn "/usr/bin/nm-applet --sm-disable"
    -- spawn "xfce4-power-manager"
    -- spawn "pasystray"
    -- spawn "pcmanfm -d"
    -- spawn "/usr/bin/xscreensaver -no-splash"
    -- spawn "trayer --edge top --align right --SetDockType true --SetPartialStrut false --expand true --widthtype request --transparent true --tint 0x191234 --height 19"
    -- spawn "sleep 1; bash /home/poe/.xmonad/wallpaper.sh"
    spawn "qv2ray"
    spawn "synapse -s"
    spawn "xset -b"
    -- spawn "sleep 0.5; xrandr --output eDP1 --mode 1920x1080"
    -- spawn $ chromeApp "https://app.slack.com/client/T027TU47K/GQHU1Q8QZ"
    -- spawn $ chromeApp "https://calendar.google.com/calendar/b/1/r"
    -- spawn $ chromeApp "https://mail.google.com/mail/u/1/#inbox"
    -- spawn "sleep 6; mailspring"
    -- spawnOn "shell" "sleep 2 && urxvtc -T urxvt_shell -e tmux new-session -A -s workspace"
    spawn "sleep 2; xfce4-panel -r"
    spawn "picom -CGb --config ~/.picom.conf"
  where
      chromeApp url = "sleep 2; google-chrome-stable --app=" ++ url

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@XConfig {XMonad.modMask = modMask} =
  M.fromList $
    -- launch a terminal
  [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    -- launch xfce4-launcher
  , ((modMask, xK_p), spawn "synapse -s")
    -- launch gmrun
 , ((modMask .|. shiftMask, xK_o), spawn "xfce4-appfinder")
    -- Quit xmonad
    -- , ((modMask .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))
     , ((modMask .|. shiftMask, xK_q), spawn "xfce4-session-logout")

    -- close focused window
  , ((modMask .|. shiftMask, xK_c), kill)
  , ((mod1Mask, xK_F3), kill)
  , ((modMask, xK_w), kill)
     -- Rotate through the available layout algorithms
  , ((modMask, xK_space), sendMessage NextLayout)
    --  Reset the layouts on the current workspace to default
  , ((modMask .|. shiftMask, xK_space), setLayout $ XMonad.layoutHook conf)
    -- Resize viewed windows to the correct size
  , ((modMask, xK_n), refresh)
    -- Move focus to the next window
  , ((mod1Mask, xK_Tab), windows W.focusDown)
   , ((modMask, xK_Tab), cycleRecentWS [xK_Super_L] xK_Tab xK_Tab)
    -- Move focus to the window bellow
  , ((modMask, xK_j), N.windowGo D True)
    -- Move focus to the  window up
  , ((modMask, xK_k), N.windowGo U True)
    -- Move focus to the window left
  , ((modMask, xK_h), N.windowGo L True)
    -- Move focus to the window right
  , ((modMask, xK_l), N.windowGo R True)
    -- Move focus to the master window
  , ((modMask .|. shiftMask, xK_m), windows W.focusMaster)
    -- Maximize the focused window temporarily
  , ((modMask, xK_m), withFocused $ sendMessage . maximizeRestore)
    -- Swap the focused window and the master window
  , ((modMask, xK_Return), windows W.swapMaster)
    -- Swap the focused window with the next window
  , ((modMask .|. shiftMask, xK_j), windows W.swapDown)
    -- Swap the focused window with the previous window
  , ((modMask .|. shiftMask, xK_k), windows W.swapUp)
    -- Shrink the master area
  , ((modMask, xK_i), sendMessage Shrink)
    -- Expand the master area
  , ((modMask, xK_o), sendMessage Expand)
  , ((modMask .|. shiftMask, xK_a), sendMessage Taller)
  , ((modMask .|. shiftMask, xK_z), sendMessage Wider)
    -- Push window back into tiling
  , ((modMask, xK_s), withFocused $ windows . W.sink)
    -- Increment the number of windows in the master area
  , ((modMask, xK_comma), sendMessage (IncMasterN 1))
    -- Deincrement the number of windows in the master area
  , ((modMask, xK_period), sendMessage (IncMasterN (-1)))
    -- Restart xmonad
  -- , ((modMask, xK_q), restart "xmonad" True)
    -- to hide/unhide the panel
  , ((modMask, xK_b), sendMessage ToggleStruts)
  ] ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
  [ ((m .|. modMask, k), windows $ f i)
  | (i, k) <- zip (XMonad.workspaces conf) $ [xK_1 .. xK_9] ++ [xK_0]
  , (f, m) <- [(W.greedyView, 0), (liftM2 (.) W.view W.shift, shiftMask)]
  ] ++
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
  [ ((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
  | (key, sc) <- zip [xK_w, xK_e, xK_r] [0 ..]
  , (f, m) <- [(W.view, 0), (liftM2 (.) W.view W.shift, shiftMask)]
  ]

-- refer https://hackage.haskell.org/package/xmonad-contrib-0.16/docs/XMonad-Util-EZConfig.html
comboKeymap :: [(String, X ())]
comboKeymap = [
    ("M-; o s", sinkAll)
    , ("C-; <Space>", sendMessage $ Toggle NBFULL)
    , ("C-; l f", sendMessage $ Toggle NBFULL)
    , ("C-; l x", sendMessage $ Toggle REFLECTX)
    , ("C-; l y", sendMessage $ Toggle REFLECTY)
    , ("C-; l m", sendMessage $ Toggle MIRROR)
    , ("C-; l b", sendMessage $ Toggle NOBORDERS)
    -- , ("C-; o d", spawn "pcmanfm")
    , ("C-; o d", spawn "thunar")
    , ("C-; o i", spawn "xcalib -i -a")
    --- GridSelect
    , ("C-; o o", spawnSelected def{gs_font = "xft:monofur for Powerline:size=14"} myGSCmd)
    , ("C-; o p", goToSelected myGSConfig)
    , ("C-; o q",  restart "xmonad" True)
    , ("C-; o k", kill)
    , ("C-; o c", spawn "deepin-screenshot")
    , ("C-; o l", spawn "xfce4-screensaver-command -l")
    -- , ("C-; o l", spawn "lxdm -c USER_SWITCH")
    -- , ("C-; o l", spawn "dm-tool lock")
    , ("<XF86AudioRaiseVolume>", spawn "amixer sset Master 5%+")
    , ("<XF86AudioLowerVolume>", spawn "amixer sset Master 5%-")
    , ("M--", spawn "amixer sset Master 8%-")
    , ("M-=", spawn "amixer sset Master 6%+")

    , ("XF86KbdBrightnessUp", spawn "xbacklight -dec 8")
    , ("XF86KbdBrightnessDown", spawn "xbacklight -inc 6")
    , ("M-S--", spawn "xbacklight -dec 8")
    , ("M-S-=", spawn "xbacklight -inc 6")

    , ("M-y", focusUrgent)

    -- Windows resize
    , ("M-S-<L>", withFocused (keysResizeWindow (-30,0) (0,0))) --shrink float at right
    , ("M-S-<R>", withFocused (keysResizeWindow (30,0) (0,0))) --expand float at right
    , ("M-S-<D>", withFocused (keysResizeWindow (0,30) (0,0))) --expand float at bottom
    , ("M-S-<U>", withFocused (keysResizeWindow (0,-30) (0,0))) --shrink float at bottom
    , ("M-C-<L>", withFocused (keysResizeWindow (30,0) (1,0))) --expand float at left
    , ("M-C-<R>", withFocused (keysResizeWindow (-30,0) (1,0))) --shrink float at left
    , ("M-C-<U>", withFocused (keysResizeWindow (0,30) (0,1))) --expand float at top
    , ("M-C-<D>", withFocused (keysResizeWindow (0,-30) (0,1))) --shrink float at top
    , ("M-<L>", withFocused (keysMoveWindow (-30,0)))
    , ("M-<R>", withFocused (keysMoveWindow (30,0)))
    , ("M-<U>", withFocused (keysMoveWindow (0,-30)))
    , ("M-<D>", withFocused (keysMoveWindow (0,30)))
  ]

---- Search key Binding
searchBindings :: [(String, X ())]
searchBindings =
  [("C-; o s " ++ name, S.promptSearch myXPConfig e) | e@(S.SearchEngine name _) <- engines, length name == 1]
  where
    promptSearch (S.SearchEngine _ site) =
      inputPrompt myXPConfig "Search" ?+ \s -> S.search "firefox" site s >> viewWeb
    viewWeb = windows $ W.view "web"
    mk name site = S.intelligent $ S.searchEngine name site
    engines =
      [ mk "h" "http://hackage.haskell.org/package/"
      , mk "d" "http://dict.cn/"
      , mk "b" "http://www.baidu.com/s?wd="
      , mk "y" "http://www.youtube.com/results?search_type=search_videos&search_query="
      , mk "i" "https://ixquick.com/do/search?q="
      , mk "p" "http://images.google.com/images?q="
      , mk "h" "https://github.com/search?q="
      , mk "u" "http://duckduckgo.com/?q="
      , mk "g" "http://www.google.com/search?num=100&q="
      ]

-------- Prompt keymap
myPromptKeymap :: [(String, X ())]
myPromptKeymap = [
    ("C-; p o", runOrRaisePrompt myXPConfig)
    , ("C-; p m", manPrompt myXPConfig)
    , ("C-; p d", changeDir myXPConfig)
    , ("C-; p w", xmonadPrompt myXPConfig)
    , ("C-; p c", xmonadPromptC myCommands myXPConfig)
    , ("M-S-p", xmonadPromptC myCommands myXPConfig)
    , ("C-; p p", proxyPrompt myXPConfig)
  ] where
    proxySpawn = spawn . withProxy
    proxyPrompt :: XPConfig -> X ()
    proxyPrompt c = do
      cmds <- io getCommands
      mkXPrompt Shell c (getShellCompl cmds $ searchPredicate c) proxySpawn

-------- scratchpads
scratchpadsKeymaps :: [(String, X ())]
scratchpadsKeymaps = [
    ("M-d", namedScratchpadAction scratchpads "dict"),
    ("C-' d", namedScratchpadAction scratchpads "dict"),
    ("C-' s", namedScratchpadAction scratchpads "scala"),
    ("C-' e", namedScratchpadAction scratchpads "emacs"),
    ("C-' w", namedScratchpadAction scratchpads "wechat"),
    ("C-' h", namedScratchpadAction scratchpads "htop"),
    ("C-' a", namedScratchpadAction scratchpads "alsamixer"),
    ("M-c", namedScratchpadAction scratchpads "calendar"),
    ("M-m", namedScratchpadAction scratchpads "mail"),
    ("C-' z", namedScratchpadAction scratchpads "zsh"),
    ("C-' r", namedScratchpadAction scratchpads "ranger"),
    ("M-\\", namedScratchpadAction scratchpads "fly_terminal"),
    ("M-/", namedScratchpadAction scratchpads "firefox")
  ]

scratchpads =
  map f ["ghci", "node", "alsamixer", "htop", "scala", "zsh", "ranger"] ++
  [
  NS "dict" (chrome "http://dict.youdao.com/") (name ~=? "dict.youdao.com") doTopRightFloat
  , NS "emacs" "urxvtc -T emacsnw -e emacsclient '-nw'" (title =? "emacsnw") doRightFloat
  , NS "wechat" (chrome "https://wx.qq.com/?lang=zh_CN") (title =? "g-wechat") doTopRightFloat
  , NS "calendar" (chrome "https://calendar.google.com/calendar/b/1/r") (name ~=? "calendar.google.com__calendar") doRightFloat
  , NS "mail" (chrome "https://mail.google.com/mail/u/1/#inbox") (name ~=? "mail.google.com__mail") doRightFloat
  , NS "fly_terminal" "urxvtc -T fly_terminal -e tmux new-session -A -s main"  (title =? "fly_terminal") doTopFloat
  , NS "firefox" "firefox"  (name ~=? "Navigator") doRightFloat
  ]
  where
    urxvt prog = ("urxvtc -T "++) . ((++) . head $ words prog) . (" -e "++) . (prog++) $ ""
    f s = NS s (urxvt s) (title =? s) doTopRightFloat

    name :: Query String
    name = stringProperty "WM_CLASS"

    chrome url = "google-chrome-stable --app=" ++ url

    doSPFloat = customFloating $ W.RationalRect (1/6) (1/6) (4/6) (4/6)
    doTopFloat = customFloating $ W.RationalRect 0 (1/40) 1 (5/6)
    doTopLeftFloat = customFloating $ W.RationalRect 0 0 (1/3) (1/3)
    doTopRightFloat = customFloating $ W.RationalRect (2/3) 0 (1/3) (1/3)
    doBottomLeftFloat = customFloating $ W.RationalRect 0 (2/3) (1/3) (1/3)
    doBottomRightFloat = customFloating $ W.RationalRect (2/3) (2/3) (1/3) (1/3)
    doLeftFloat = customFloating $ W.RationalRect 0 (1/40) (1/3) 1
    doRightFloat = customFloating $ W.RationalRect (1/3) (1/20) (2/3) (9/20)
    orgFloat = customFloating $ W.RationalRect (1/2) (1/2) (1/2) (1/2)

---------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings XConfig {XMonad.modMask = modm} =
  M.fromList
    [
    -- mod-button1, Set the window to floating mode and move by dragging
    ((modm, button1), \w -> focus w >> mouseMoveWindow w >> windows W.shiftMaster)
    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), \w -> focus w >> windows W.shiftMaster)
    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), \w -> focus w >> mouseResizeWindow w >> windows W.shiftMaster)
    ]

------------------------------------------------------------------------
-- Layouts:

myLayout = PerW.onWorkspaces ["gimp"] gimpLayout customLayout
  where
    tiled = ResizableTall 1 (3/100) (1/2) []
    customLayout = avoidStruts $
                   mkToggle1 NBFULL $
                   mkToggle1 REFLECTX $
                   mkToggle1 REFLECTY $
                   mkToggle1 MIRROR $
                   mkToggle1 NOBORDERS $
                   -- smartBorders $
                   -- Full
                   tiled
                   ||| mosaic 1.5 [7,5,2]
                   ||| autoMaster 1 (1/20) (Mag.magnifier Grid)

    gimpLayout = avoidStruts $ withIM 0.11 (Role "gimp-toolbox") $
                 reflectHoriz $
                 withIM 0.15 (Role "gimp-dock") customLayout

------------------------------------------------------------------------
-- Window rules:

pbManageHook :: ManageHook
pbManageHook = composeAll $ concat
    [ [ manageDocks ]
    , [ manageHook def ]
    , [ isDialog --> doCenterFloat ]
    , [ isFullscreen --> doFullFloat ]
    , [ fmap not isDialog --> doF avoidMaster ]
    ] where
      -- avoidMaster:  Avoid the master window, but otherwise manage new windows normally
      avoidMaster :: W.StackSet i l a s sd -> W.StackSet i l a s sd
      avoidMaster = W.modify' $ \c -> case c of
        W.Stack t [] (r:rs) -> W.Stack t [r] rs
        _ -> c

myManageHook = composeAll $ concat [
    [matchAny v --> doIgnore | v <- myIgnores]
    , [matchAny v --> doSink | v <- ["gimp"]]
    , [matchAny v --> doShiftAndGo w | (w, v) <- myDoShiftAndGo]
    , [matchAny v --> doShift "web" | v <- myWeb]
    , [matchAny v --> doShift "editor" | v <- myEditor]
    , [matchAny v --> doShift "info" | v <- myInfo]
    , [matchAny v --> doShift "mail" | v <- myMail]
    , [matchAny v --> doShift "chat" | v <- myChat]
    , [matchAny v --> doShift "media" | v <- myMedia]
    , [matchAny v --> doShift "gimp" | v <- myGimp]
    , [matchAny v --> doShift "vbox" | v <- myVBox]
    , [matchAny v --> doShift "shell" | v <- myShell]
    -- IntelliJ idea Tweaks
    -- Manage idea completion window
    , [ appName =? "sun-awt-X11-XWindowPeer" <&&> className =? "jetbrains-idea" --> doIgnore ]
    , [ (className ~=? "jetbrains-") <&&> (title ~=? "Changes in") -->  unfloat ]
    , [ (className ~=? "jetbrains-") <&&> (title ~=? "Paths Affected in") --> unfloat ]
    , [matchAny v --> doCenterFloat | v <- myCenterFloats]
  ] where
    myDoShiftAndGo = [
        ("info", "app.slack.com"),
        ("info", "calendar.google.com"),
        ("info", "reagroup.atlassian.net"),
        ("info", "outlook.office.com"),
        ("mail", "mail.google.com")
      ]
    myCenterFloats = ["Sysinfo", "XMessage", "Smplayer"
                      ,"MPlayer", "nemo", "Thunar"
                      , "Toplevel", "Pcmanfm", "goldendict"
                      , "Xmessage","XFontSel","Downloads"
                      ,"Nm-connection-editor", "Pidgin"
                      , "Downloads"
                      , "Save As...", "Dialog", "bashrun","Google Chrome Options"
                      , "Chromium Options", "Hangouts", "System Settings", "Library"
                      , "Firefox Preference", "ss-qt5", "pop-up", "Xfce4-appfinder", "Xfrun4"]
    myIgnores = ["Unity-2d-panel", "Unity-2d-launcher", "desktop_window", "kdesktop", "Whisker Menu",
                "desktop","desktop_window","notify-osd","stalonetray","trayer", "Xfce4-notifyd"]

    -- myWorkspaces = ["web", "editor", "ide", "info", "mail", "vbox", "media", "gimp", "swap", "shell"]
    myWeb = ["Firefox-bin", "Firefox",  "Firefox Web Browser"
              , "opera", "Opera", "Chromium"]
    myInfo = ["Pidgin Internet Messenger", "Buddy List"
               , "skype", "skype-wrapper", "Skype",
               "Conky", "Station"]
    myEditor = ["geany", "Gvim", "emacs",
              "eclipse", "Eclipse", "jetbrains-idea-ce",
             "jetbrains-idea", "Aptana Studio 3"]
    myChat = ["zoom"]
    myGimp = ["Gimp", "GIMP Image Editor"]
    myMail = ["Mailspring"]
    myMedia = ["Rhythmbox","Spotify","Boxee","Trine"]
    myVBox = ["Oracle VM VirtualBox Manager", "VirtualBox", "VirtualBox Manager"]
    myShell = ["urxvt_shell"]

    doShiftAndGo = doF . liftM2 (.) W.greedyView W.shift

    -- Hook used to push floating windows back into the layout
    -- This is used for gimp windows to force them into a layout.
    doSink = ask >>= \w -> liftX (reveal w) >> doF (W.sink w)
    unfloat = ask >>= doF . W.sink
    -- Match a string against any one of a window's class, title, name or
    -- role.
    matchAny :: String -> Query Bool
    matchAny x = foldr ((<||>) . (~=? x)) (return False) [className, title, name, role]
    -- Match against @WM_NAME@.
    name :: Query String
    name = stringProperty "WM_CLASS"
    -- Match against @WM_WINDOW_ROLE@.
    role :: Query String
    role = stringProperty "WM_WINDOW_ROLE"

--- FadeHook
myFadeHook = composeAll [isUnfocused --> transparency 0.2, opaque]

myDefaultConfig = withUrgencyHook NoUrgencyHook $ myConfig {
     -- key bindings
     keys               = myKeys <+> keys myConfig,
     mouseBindings      = myMouseBindings,
     -- simple stuff
     terminal           = myTerminal,
     focusFollowsMouse  = myFocusFollowsMouse,
     clickJustFocuses   = myClickJustFocuses,
     borderWidth        = myBorderWidth,
     workspaces         = myWorkspaces,
     normalBorderColor  = myNormalBorderColor,
     focusedBorderColor = myFocusedBorderColor,
     modMask = mod4Mask,

     -- hooks, layouts
     layoutHook = myLayout,
     manageHook = pbManageHook <+> myManageHook <+> manageDocks <+> namedScratchpadManageHook scratchpads <+> manageHook myConfig,
     logHook = fadeWindowsLogHook myFadeHook <+> logHook myConfig,
     handleEventHook = fadeWindowsEventHook <+> handleEventHook myConfig,
     startupHook = myStartupHook <+> startupHook myConfig
   } `additionalKeysP` (comboKeymap ++ searchBindings ++ scratchpadsKeymaps ++ myPromptKeymap)
   where
     -- myConfig = def
     myConfig = xfceConfig

main :: IO ()

-- main = xmonad =<< statusBar cmd myXmobarPP toggleStrutsKey myDefaultConfig
main = xmonad myDefaultConfig
  where
    cmd = "xmobar ~/.xmonad/xmobar.hs -x0"
    toggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
    toggleStrutsKey XConfig {modMask = modm} = (modm, xK_b)
    myXmobarPP =
      def
        { ppCurrent = xmobarColor "#429942" "" . wrap "[" "]"
        , ppVisible = xmobarColor "#429942" ""
        , ppHidden = xmobarColor "#C98F0A" ""
        , ppHiddenNoWindows = const ""
        , ppUrgent = xmobarColor "#FFFFAF" "" . wrap "" ""
        , ppLayout = xmobarColor "#C9A34E" "" . shorten 10
        , ppTitle = xmobarColor "#C9A34E" "" . shorten 32
        , ppSep = xmobarColor "#429942" "" " | "
      -- , ppOrder  = \(ws:l:t:exs) -> []++exs
        , ppSort = fmap (namedScratchpadFilterOutWorkspace .) (ppSort byorgeyPP)
        }
