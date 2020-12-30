;Must set Project_Theme_Folder beforehand
Project_Theme_Folder := "C:\Users\fudan\Jimmy\gliders\app\public\wp-content\themes\gliders"
Flexible_Folder:= Project_Theme_Folder . "\partials\flexible\"
Instruction_Folder:= Project_Theme_Folder . "\images\instruction\"


#SingleInstance Force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.



#Include ./Gdip_All.ahk
; Start gdi+
If !pToken := Gdip_Startup()
{
	MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
	ExitApp
}


;Step0 Show logo
SplashImage, jimmyweblogo.png, b1 fs12 cwFFFFFF, Flexible Module Helper
Sleep, 1000
SplashImage, Off


;Step1 Name your module
InputBox, UserInput, Flexible Module Helper, Just input 'tab' if your module's name is going to be 'tab_section.php', ,450,130

if ErrorLevel
    ExitApp

;Step2 Generate php
Module_Name = %Flexible_Folder%%UserInput%_section.php
FileAppend, <!-- Generate by Flexible Module Helper -->`n, %Module_Name%


;Step3 Take a screenshot
Process, Exist, snippingtool.exe
status = %ErrorLevel% 
if status = 0
{
    RunWait snippingtool.exe /clip
}

pBitmap1 := Gdip_CreateBitmapFromClipboard()

Gdip_GetDimensions(pBitmap1, vImgW1, vImgH1)
vImgW2 := 800
vImgH2 := Round(800 * vImgH1 / vImgW1)
pBitmap2 := Gdip_CreateBitmap(vImgW2, vImgH2)
pGraphics2 := Gdip_GraphicsFromImage(pBitmap2)

;2 options from:
;[functions] More GDI+ functions - AutoHotkey Community
;https://autohotkey.com/boards/viewtopic.php?f=6&t=12312
Gdip_SetSmoothingMode(pGraphics2, 4)
Gdip_SetInterpolationMode(pGraphics2, 7)


Gdip_DrawImage(pGraphics2, pBitmap1, 0, 0, vImgW2, vImgH2, 0, 0, vImgW1, vImgH1)

Image_Name = %Instruction_Folder%%UserInput%_section.png

Gdip_SaveBitmapToFile(pBitmap2, Image_Name)
Gdip_DeleteGraphics(pGraphics2)
Gdip_DisposeImage(pBitmap1)
Gdip_DisposeImage(pBitmap2)


; ...and gdi+ may now be shutdown
Gdip_Shutdown(pToken)