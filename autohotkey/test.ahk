#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


CustomColor = 99AA55 ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
; Gui, Font, s24 ; Set a large font size (32-point).
; Gui, Add, Text, vMyText cRed, 1200 ; 00 serve to auto-size the window.

WinSet, TransColor, %CustomColor% ; Make all pixels of this color transparent
Gui, Show, xCenter yCenter NoActivate ; NoActivate avoids deactivating the currently active window.

wdth := A_ScreenWidth - 350, hght := A_ScreenHeight - 250

Progress, b2 fs70 fm12 zh10 CTgreen CWFFFFFF  X%wdth% Y%hght% w250, % "00:00", Enter start time, Countdowner

WinSet, TransColor, FFFFFF 255, Countdowner
loop,4
    {
    Input x, L1,{esc}{enter},1,2,3,4,5,6,7,8,9,0
    w .= x , y := SubStr("000" w, -3)
    if (ErrorLevel = "Match")
        Progress, b2 fs70 fm12 zh10 CTgreen CWFFFFFF  X%wdth% Y%hght%  w250, % SubStr(y,1,2) ":" SubStr(y,3,2), Enter to accept and start, Countdowner
    else if (Errorlevel = "EndKey:enter")
        break
    else
        exitapp
    WinSet, TransColor, FFFFFF 255, Countdowner
    }

startover:
Progress, m1 b fs70 fm12 zh10 CTgreen CWFFFFFF X%wdth% Y%hght%  w250, % SubStr("00" floor((w-t)/60),-1) ":" SubStr("00" mod(w-t,60),-1), Done!, Countdowner
t := 0, w := SubStr(y,1,2)*60 + SubStr(y,3,2)
settimer,label,1000
return

label:
++t
if (t < w)

    Progress, % 100*(w-t)/w, % SubStr("00" floor((w-t)/60),-1) ":" SubStr("00" mod(w-t,60),-1), count down, Countdowner
else if (t = w)
    {
   Gui, Color, black
   Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
    Progress, m1 b fs70 fm12 zh10 CTgreen CWFFFFFF X%wdth% Y%hght%  w250, 0, Done!, Countdowner
    SoundPlay, *48
    }
else if (t > w)
    Progress, b2 fs70 fm12 zh10 CTred CWFFFFFF  X%wdth% Y%hght%  w250, 0 , % SubStr("0" floor((t-w)/60), -1) ":" SubStr("0" mod(t-w,60), -1), count up, Countdowner
WinSet, TransColor, FFFFFF 255, Countdowner
return

; p:: settimer,label,% (a:=!a) ? "off" : "on"
#!^c:: goto startover




#!^d::
Gui, Destroy
return