Config {
      -- font = "xft:monofur-11"
         font = "xft:WenQuanYi Micro Hei Mono Light:size=13, xft:UbuntuMonoDerivativePowerline Nerd Font:size=14"
       , bgColor = "#343434"
       , fgColor = "#C9A34E"
       , border = NoBorder
       , borderColor = "#000000"
       , pickBroadest = True
       , position = Top
       , lowerOnStart = True
       -- , hideOnStart = False
       -- , persistent = True
       , commands = [ Run Network "wlp3s0" ["-L", "8", "-H", "32", "-l", "#C9A34E", "-n", "#429942" ,"-h", "#A36666", "-t", "net: <rx> : <tx>"] 10
                    , Run MultiCpu ["-L","3","-H","50","--normal","#429942","--high","#A36666", "-t U: <autototal>%"] 16
                    , Run Memory ["-t","M: <usedratio>%"] 18
                    , Run Date "%a %j %m-%d %H:%M:%S" "date" 10
                    , Run CoreTemp ["-t", "T: <core0>~<core1>C"] 10
                    , Run BatteryP ["BAT0"] ["-t", "<acstatus><watts> (<left>%)",
                                             "-L", "10", "-H", "80", "-p", "3",
                                             "--", "-O", "<fc=green>On</fc> - ",
                                             "-L", "-15", "-H", "-5",
                                             "-l", "red", "-m", "blue", "-h", "green"] 600
                    , Run StdinReader
                    ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = " %StdinReader% }{%multicpu%<fc=#429942>|</fc>%memory%<fc=#429942>|</fc>%wlp3s0%<fc=#429942>|</fc>%battery%<fc=#429942>|</fc>%date%<fc=#429942>|</fc>%coretemp%                       "
       }
