;Must set Project_Theme_Folder beforehand
Project_Theme_Folder := "C:\Users\alex\Jimmy\Gliders\app\public\wp-content\themes\gliders"

Flexible_Folder:= Project_Theme_Folder . "\partials\flexible\"
Instruction_Folder:= Project_Theme_Folder . "\images\instruction\"
FlexContent_File:= Project_Theme_Folder . "\acf-fields\flex-content.acf.yaml"

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
SplashImage, jimmyweblogo.png, b1 fs12 cwFFFFFF, Please check Project_Theme_Folder beforehand
; Sleep, 3000
SplashImage, Off

;Step1 Take a screenshot
Process, Exist, snippingtool.exe
status = %ErrorLevel% 
if status = 0
{
    RunWait snippingtool.exe /clip
}

pBitmap1 := Gdip_CreateBitmapFromClipboard()

;Step2 Name your module
InputBox, UserInput, Flexible Module Helper, Just input 'tab' if your module's name is going to be 'tab_section.php', ,450,130

if ErrorLevel
    ExitApp

;Step3 Generate php
Module_Name = %Flexible_Folder%%UserInput%_section.php
FileAppend, <!-- Generate by Flexible Module Helper -->`n, %Module_Name%

;Step4 Take a screenshot then save as png

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

;Step5 write to flex-content.acf.yaml
RepeaterLevel := 0
SpaceRepeater :=""
StringUpper, UserInputCap, UserInput, T

AutoTrim, Off
Space6 = %A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%
Space8 = %Space6%%A_Space%%A_Space%
Space10 = %Space8%%A_Space%%A_Space%
Space12 = %Space10%%A_Space%%A_Space%
Space14 = %Space12%%A_Space%%A_Space%
FileAppend, %Space6%%UserInput%_section:`n, %FlexContent_File%
FileAppend, %Space8%display: "block"`n, %FlexContent_File%
FileAppend, %Space8%label: "%UserInputCap% Section"`n, %FlexContent_File%
FileAppend, %Space8%sub_fields:`n, %FlexContent_File%
FileAppend, %Space10%screenshot:`n, %FlexContent_File%
FileAppend, %Space12%type: message`n, %FlexContent_File%
FileAppend, %Space12%label: Module Screenshot`n, %FlexContent_File%
FileAppend, %Space12%message: <a href="`%`%THEME_INSTRUCTION_FOLDER`%`%%UserInput%_section.png" data-lity>Demo Preview</a>`n, %FlexContent_File%

Gui, Add, Edit, R40 vFlexContentEdit w900 ReadOnly
FileRead, FileContents, %FlexContent_File%
GuiControl,, FlexContentEdit, %FileContents%
Gui, Add, Text, section, Field Name:
Gui, Add, Edit, vFieldName
Gui, Add, Button, w80 default ys, Repeater
Gui, Add, Button, w80 default, Repeater-1
Gui, Add, Button, w80 default ys, Text
Gui, Add, Button, w80 default, Image
Gui, Add, Button, w80 default ys, Link
Gui, Add, Button, w80 default, Wysiwyg
Gui, Add, Button, w80 default ys, Select(SVG)
Gui, Add, Button, w80 default, TextArea
Gui, Add, Button, w80 default ys, TrueFalse
Gui, Add, Button, w80 default, ButtonGroup
Gui, Show,, %FlexContent_File%
global _GUI := A_DefaultGUI

; Auto scroll to the bottom
ControlGetFocus, control, A
SendMessage, 0x115, 7, 0, %control%, A

UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2) { 
    FileRead, FileContents, %FlexContent_File%
    GuiControl,, FlexContentEdit, %FileContents%
    ; Auto scroll to the bottom
    SendMessage, 0x115, 7, 0, Edit1
    ; Clear field name edit
    GuiControl,,Edit2, 
}

return ; End of auto-execute section. The script is idle until the user does something.

ButtonText:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%text:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Text`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: text`n, %FlexContent_File%
    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: text`n, %FlexContent_File%
    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return
ButtonTrueFalse:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%true_false:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: True/False`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: true_false`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%ui: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%default_value: false`n, %FlexContent_File%
    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: true_false`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%ui: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%default_value: false`n, %FlexContent_File%
    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return
ButtonButtonGroup:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%button_group:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Button Group`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: horizontal`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%layout: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%return_format: value`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%choices:`n, %FlexContent_File%
    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: true_false`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%ui: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%default_value: false`n, %FlexContent_File%
    }

    Gui, ChoicesGui:Add, Text, x20 y20, Choice name:
    Gui, ChoicesGui:Add, Edit, x100 y15 vChoiceName
    Gui, ChoicesGui:Add, Button, x19 y45 w80 default, Next_Choice
    Gui, ChoicesGui:Add, Button, x156 y45 w80 default, No_More
    Gui, ChoicesGui:Show,, Add Choice

    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return

ChoicesGuiButtonNext_Choice:
    Gui, Submit, NoHide
    StringUpper, ChoiceNameCap, ChoiceName, T
    FileAppend, %SpaceRepeater%%Space14%%ChoiceName%:%ChoiceNameCap%`n, %FlexContent_File%
    GuiControl,,Edit1, 
    GUI, %_GUI%:Default
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return

ButtonTextArea:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%textarea:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Textarea`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: textarea`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%new_lines: br`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%rows: 4`n, %FlexContent_File%
    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: textarea`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%new_lines: br`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%rows: 4`n, %FlexContent_File%

    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return
ButtonImage:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%image:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Image`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: image`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%preview_size: thumbnail`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%max_size: 5 # in MB`n, %FlexContent_File%

    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: image`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%preview_size: thumbnail`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%max_size: 5 # in MB`n, %FlexContent_File%

    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return
ButtonLink:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%link:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Link`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: link`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%return_format: array`n, %FlexContent_File%

    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: link`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%return_format: array`n, %FlexContent_File%
    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return
ButtonWysiwyg:

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%wysiwyg:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Wysiwyg`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: wysiwyg`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%tabs: all`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%toolbar: full`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%media_upload: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%delay: true`n, %FlexContent_File%

    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: wysiwyg`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%tabs: all`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%toolbar: full`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%media_upload: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%delay: true`n, %FlexContent_File%
    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return
ButtonSelect(SVG):

    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%svg_select:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Svg Select`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: select`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%wrapper_width: 50`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%ui: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%wrapper_class: js-icon-selector`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%choices: []`n, %FlexContent_File%

    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: select`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%wrapper_width: 50`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%ui: true`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%wrapper_class: js-icon-selector`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%choices: []`n, %FlexContent_File%
    }
    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return

ButtonRepeater:
    Gui, Submit, NoHide
    if (FieldName = "")
    {
        FileAppend, %SpaceRepeater%%Space10%repeater:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: Repeater`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: repeater`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%layout: block`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%sub_fields:`n, %FlexContent_File%

    }
    else
    {
        StringUpper, FieldNameCap, FieldName, T
        FileAppend, %SpaceRepeater%%Space10%%FieldName%:`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%label: %FieldNameCap%`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%type: repeater`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%layout: block`n, %FlexContent_File%
        FileAppend, %SpaceRepeater%%Space12%sub_fields:`n, %FlexContent_File%

    }

    RepeaterLevel+= 1
    SpaceRepeater = %SpaceRepeater%%A_Space%%A_Space%%A_Space%%A_Space%

    GuiControl, Text, Button1 , Repeater%RepeaterLevel%

    UpdateGUI(FlexContent_File,FlexContentEdit,Edit1,Edit2)
return

ButtonRepeater-1:
    ; Auto scroll to the bottom
    SendMessage, 0x115, 7, 0, Edit1
    ; Clear field name edit
    GuiControl,,Edit2,

    if(RepeaterLevel>0){
        RepeaterLevel-= 1
        SpaceRepeater :=""
        Loop %RepeaterLevel%
        {
            SpaceRepeater = %SpaceRepeater%%A_Space%%A_Space%%A_Space%%A_Space%
        }
        if(RepeaterLevel=0)
            GuiControl, Text, Button1 , Repeater
        else
            GuiControl, Text, Button1 , Repeater%RepeaterLevel%
    }

return

