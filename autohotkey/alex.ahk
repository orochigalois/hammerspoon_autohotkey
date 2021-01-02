#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 20 mins Timer

3s=0003
10s=0010
20min=2030

total:=20min

;_____prepare full screen black window
CustomColor = AABBCC ; Can be any RGB color (it will be made transparent below).
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
Gui, Color, %CustomColor%
WinSet, TransColor, %CustomColor% ; Make all pixels of this color transparent
Gui, Show, xCenter yCenter NoActivate ; NoActivate avoids deactivating the currently active window.
Gui, Color, black

;_____start
#!^c::
    {
        ;_____count down position
        position_x := A_ScreenWidth - 200, position_y := A_ScreenHeight - 150
        Progress, m b fs40 fm12 zh10 CTgreen CWFFFFFF X%position_x% Y%position_y% w160, % SubStr(total,1,2) ":" SubStr(total,3,2), , Countdowner, Digital-7 Mono
        WinSet, TransColor, FFFFFF, Countdowner
        tick := 0, total_tick := SubStr(total,1,2)*60 + SubStr(total,3,2)
        settimer,quartz,1000
        return
    }

quartz:
    ++tick
    if (tick < total_tick)
        Progress, % 100*(total_tick-tick)/total_tick, % SubStr("00" floor((total_tick-tick)/60),-1) ":" SubStr("00" mod(total_tick-tick,60),-1), , Countdowner,Digital-7 Mono
    else if (tick = total_tick)
    {
        Progress, Off
        SoundPlay, *48
        Gui, Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight%
    }
    ; else if (tick > total_tick)
    ; Progress, b2 fs70 fm12 zh10 CTred CWFFFFFF  X%wdth% Y%hght%  w250, 0 , % SubStr("0" floor((t-w)/60), -1) ":" SubStr("0" mod(t-w,60), -1), count up, Countdowner
return

;_____stop
#!^d::
    {
        settimer,quartz,Off
        Progress, Off
        Gui, Hide
        return
    }
   

;;;;;;;;;;;;;;;;;;;;;For MacOS, there are issues for those keymap, so we have to install SharpKeys instead
; LAlt::LCtrl
; LWin::LAlt
; LCtrl::LWin

;;;;;;;;;;;;;;;;;;;;;for vscode
#!^Numpad1::
{
   SendRaw, <?php  ?>
   Loop 3{
      Send {Left}
   }
   
   return
}
#!^Numpad2::
{
   SendRaw, <?=  ?>
   Loop 3{
      Send {Left}
   }
   return
}
#!^Numpad3::
{
   SendRaw, <?php if(false): ?>
   return
}
#!^Numpad4::
{
   SendRaw, <?php endif; ?>
   return
}
#!^Numpad8::
{
   SendRaw, <p>
   return
}
#!^Numpad9::
{
   SendRaw, </p>
   return
}
;;;;;;;;;;;;;;;;;;;;;for English dict
#!^5::
{
   Send, ^c
   StringReplace, clipboard, clipboard, %A_SPACE%, `%20, All
   Run chrome.exe https://www.vocabulary.com/dictionary/%clipboard%
   return
}
#!^6::
{
   Send, ^c
   StringReplace, clipboard, clipboard, %A_SPACE%, `%20, All
   Run chrome.exe https://translate.google.com/#en/zh-CN/%clipboard%
   return
}


;;;;;;;;;;;;;;;;;;;;;delete
^Backspace::
   {
      Send, {Delete};
      return
   }
;;;;;;;;;;;;;;;;;;;;;minimize/hide window
^H::
   {
      WinMinimize, A
      return
   }

;;;;;;;;;;;;;;;;;;;;;close window
^Q::
   {
      WinClose A
      return
   }

;;;;;;;;;;;;;;;;;;;;;for design
`::
{

   DetectHiddenWindows, Off	
	Process, Exist, picpick.exe
	status = %ErrorLevel% 
	if status = 0
	{
		Run picpick.exe
	}
	
   IfWinNotExist ahk_class TfrmMain
	{
		WinShow, ahk_class TfrmMain
		WinActivate, ahk_class TfrmMain
	}
	Else
	{
		WinMinimize, ahk_class TfrmMain
		WinHide, ahk_class TfrmMain
	}
	Return
}
;;;;;;;;;;;;;;cursor color copy to clipboard

^F1::
MouseGetPos, MouseX, MouseY
PixelGetColor, color, %MouseX%, %MouseY%
clipboard = %color%
return

;;;;;;;;;;;;;;;;;;;;;screen shot, known issues on multiple monitors
^Escape::	; <-- Open/Activate/Minimize Windows Snipping Tool
   {
      SetTitleMatchMode, % (Setting_A_TitleMatchMode := A_TitleMatchMode) ? "RegEx" :
         if WinExist("ahk_class Microsoft-Windows-.*SnipperToolbar")
         {
            WinGet, State, MinMax
            if (State = -1)
            {	
               WinRestore
               Send, ^n
            }
            else if WinActive()
               WinMinimize
            else
            {
               WinActivate
               Send, ^n
            }
         }
         else if WinExist("ahk_class Microsoft-Windows-.*SnipperEditor")
         {
            WinGet, State, MinMax
            if (State = -1)
               WinRestore
            else if WinActive()
               WinMinimize
            else
               WinActivate
         }
         else
         {
            Run, snippingtool.exe
            if (SubStr(A_OSVersion,1,2)=10)
            {
               WinWait, ahk_class Microsoft-Windows-.*SnipperToolbar,,3
               Send, ^n
            }
         }
         SetTitleMatchMode, %Setting_A_TitleMatchMode%
      return
   }

;;;;;;;;;;;;;;;;;;;;;For mouse middle, switch with multiple windows
ExtractAppTitle(FullTitle)
{	
      AppTitle := SubStr(FullTitle, InStr(FullTitle, " ", false, -1) + 1)
   Return AppTitle
}

MButton::
   WinGet, ActiveProcess, ProcessName, A
   WinGet, OpenWindowsAmount, Count, ahk_exe %ActiveProcess%

   If OpenWindowsAmount = 1 ; If only one Window exist, do nothing
      Return

   Else
   {
      WinGetTitle, FullTitle, A
      AppTitle := ExtractAppTitle(FullTitle)

      SetTitleMatchMode, 2		
      WinGet, WindowsWithSameTitleList, List, %AppTitle%

      If WindowsWithSameTitleList > 1 ; If several Window of same type (title checking) exist
      {
         WinActivate, % "ahk_id " WindowsWithSameTitleList%WindowsWithSameTitleList%	; Activate next Window	
      }
   }
Return

;-------------------- 
;HiRes Screen Splitter -- by JOnGliko 
;-------------------- 
; 
;Split the screen in areas 
;Really usefull for HiRes Monitor, make it look like dual monitor ! 
; 
; 
;Hotkey for the ACTIVE window--> WinKey + Arrow direction && WinKey + Numpad 1 2 3 4 5 6 7 8 9 
;Hotkey for the window under the ACTIVE window--> WinKey + Alt + Arrow direction && WinKey + Alt Numpad 1 2 3 4 5 6 7 8 9 
;Special Hotkey --> Two Time on the Up arrow maximize the active window (num 0 on the pad do the same) 
;Special Hotkey --> Two Time on the down arrow minimize the active window 
;_______________________________________________________________________ 

^!Left::
   ;put the Active window in the left part of the screen 
   ToLeft() 
Return 

^!Right::
   ;put the Active window in the right part of the screen 
   ToRight() 
Return 

#Up:: 
   if (A_PriorHotkey <> "#Up" or A_TimeSincePriorHotkey > 400) 
   { 
      KeyWait, Up 
      ToUp() ; One time key press put the Active window to top 
      return 
   } 
   ToMaxi() ; Two time key press maximize the active window 
Return 

#!Up:: 
   Send, !{esc} 
   ToUp() 
   Send, !+{esc} 
Return 

#Down:: 

   if (A_PriorHotkey <> "#Down" or A_TimeSincePriorHotkey > 400) 
   { 
      KeyWait, Down 
      ToBottom() ; One time key press put the window on the bottom 
      return 
   } 
   WinMinimize, A ; Two time key press minimize the active window 
Return 

#!Down::
   Send, !{esc} 
   ToBottom() 
   Send, !+{esc} 
Return 

^!f:: ;Maximize 
   ToMaxi() 
Return 

; #Numpad7:: ;put the Active window in the upper left corner 
;    ToUpperLeft() 
; Return 

; #!Numpad7:: ;put the window in the upper left corner 
;    Send, !{esc} 
;    ToUpperLeft() 
;    Send, !+{esc} 
; Return 

; #Numpad9:: ;put the Active window in the upper right corner 
;    ToUpperRight() 
; Return 

; #!Numpad9:: ;put the window in the upper right corner 
;    Send, !{esc} 
;    ToUpperRight() 
;    Send, !+{esc} 
; Return 

; #Numpad3:: ;put the Active window in the bottom right corner 
;    ToBottomRight() 
; Return 

; #!Numpad3:: ;put the window in the bottom right corner 
;    Send, !{esc} 
;    ToBottomRight() 
;    Send, !+{esc} 
; Return 

; #Numpad1:: ;put the Active window in the bottom left corner 
;    ToBottomLeft() 
; Return 

; #!Numpad1:: ;put the window in the bottom left corner 
;    Send, !{esc} 
;    ToBottomLeft() 
;    Send, !+{esc} 
; Return 

; #Numpad5:: ;Center the Active window 
;    ToMiddle() 
; Return 

; #!Numpad5:: ;Center the window 
;    Send, !{esc} 
;    ToMiddle() 
;    Send, !+{esc} 
; Return 

ToUp() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,0,0,A_ScreenWidth,A_ScreenHeight/2-TrayHeight/2 
   Return 
} 
ToBottom() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,0,A_ScreenHeight/2-TrayHeight/2,A_ScreenWidth,A_ScreenHeight/2-TrayHeight/2 
   Return 
} 
ToLeft() 
{
   WinRestore A
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,0,0,A_ScreenWidth/2,A_ScreenHeight-TrayHeight 
   Return 
} 
ToRight() 
{ 
   WinRestore A
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,A_ScreenWidth/2,0,A_ScreenWidth/2,A_ScreenHeight-TrayHeight 
   Return 
} 
ToMaxi() 
{
   WinRestore A
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,0,0,A_ScreenWidth,A_ScreenHeight-TrayHeight 
   Return 
} 
ToMiddle() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,A_ScreenWidth/4,0,A_ScreenWidth/2,A_ScreenHeight-TrayHeight 
   Return 
} 
ToUpperLeft() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,0,0,A_ScreenWidth/2,A_ScreenHeight/2-TrayHeight/2 
   Return 
} 
ToUpperRight() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,A_ScreenWidth/2,0,A_ScreenWidth/2,A_ScreenHeight/2-TrayHeight/2 
   Return 
} 
ToBottomLeft() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,0,A_ScreenHeight/2-TrayHeight/2,A_ScreenWidth/2,A_ScreenHeight/2-TrayHeight/2 
} 
ToBottomRight() 
{ 
   WinGetPos,,,,TrayHeight,ahk_class Shell_TrayWnd,,, 
   WinMove,A,,A_ScreenWidth/2,A_ScreenHeight/2-TrayHeight/2,A_ScreenWidth/2,A_ScreenHeight/2-TrayHeight/2 
}





;;;;;;;;;;;;;;;;;;;;;;;;;; Hot corner show desktop
CheckMousePosition(){
   CoordMode, Mouse, Screen
   MouseGetPos , MouseXFullScreenHotkey, MouseYFullScreenHotkey
   If (MouseXFullScreenHotkey < 5) AND (MouseYFullScreenHotkey < 5)
      return 2
   If (MouseXFullScreenHotkey > 2550) AND (MouseYFullScreenHotkey > 1430)
      return 1
}


#If CheckMousePosition() = 2
   WheelUp::Volume_Up
   WheelDown::Volume_Down
#If CheckMousePosition() = 1
   WheelUp::
   {
      ; Run nircmd.exe setbrightness 50 
      return
   }
   WheelDown::
   {
      ; Run nircmd.exe setbrightness 20
      return
   }
#If