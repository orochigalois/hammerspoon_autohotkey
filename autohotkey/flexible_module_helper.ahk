Project_Theme_Folder := "C:\Users\alex\Jimmy\Gliders\app\public\wp-content\themes\gliders"
Flexible_Folder:= Project_Theme_Folder . "\partials\flexible\"
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


SplashImage, C:\Users\alex\Desktop\jimmyweblogo.png, b1 fs12 cwFFFFFF, Flexible Module Helper
Sleep, 1000
SplashImage, Off

;Step1 Name your module
InputBox, UserInput, Flexible Module Helper, Just input 'tab' if your module's name is going to be 'tab_section', ,430,130

if ErrorLevel
    ExitApp

;Step2 Take a screenshot

; "%UserInput%"

; MsgBox %Flexible_Folder%

Module_Name = %Flexible_Folder%%UserInput%_section.php
FileAppend, <!-- Generate by Flexible Module Helper -->`n, %Module_Name%