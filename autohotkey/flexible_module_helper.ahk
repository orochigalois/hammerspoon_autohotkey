;Must set Constant_Project_Theme_Folder beforehand
Constant_Project_Theme_Folder := "C:\Users\alex\Jimmy\paintingexperiencenew\app\public\wp-content\themes\paintingexperience"

Constant_Flexible_Folder:= Constant_Project_Theme_Folder . "\partials\flexible\"
Constant_Instruction_Folder:= Constant_Project_Theme_Folder . "\images\instruction\"
Constant_FlexContent_File:= Constant_Project_Theme_Folder . "\acf-fields\flex-content.acf.yaml"
Constant_Header:= Constant_Project_Theme_Folder . "\header.php"
Constant_Footer:= Constant_Project_Theme_Folder . "\footer.php"

#SingleInstance Force
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory.

#Include ./Gdip_All.ahk

;Step0 Show logo
SplashImage, jimmyweblogo.png, w500 b1 fs12 cwFFFFFF, Make sure setup Constant_Project_Theme_Folder beforehand
Sleep, 200
SplashImage, Off

;Step1 Global variables

gWhichFile :=1 ;1 stands for flex-content.acf.yaml / 2 stands for options.acf.yaml
gRepeaterLevel := 0
gSpaceRepeater :=""

gImage_Name:=""
gModule_File:=""

gFlexibleFileSnapshot:=""
gModuleFileSnapshot:=""

gStep:=0

AutoTrim, Off
Space2 = %A_Space%%A_Space%
Space4 = %Space2%%A_Space%%A_Space%
Space6 = %Space4%%A_Space%%A_Space%
Space8 = %Space6%%A_Space%%A_Space%
Space10 = %Space8%%A_Space%%A_Space%
Space12 = %Space10%%A_Space%%A_Space%
Space14 = %Space12%%A_Space%%A_Space%

;Step2 Global function
UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1) { 
    FileRead, FileContents, %Constant_FlexContent_File%
    GuiControl,, FlexContentEdit, %FileContents%
    ; Auto scroll to the bottom
    SendMessage, 0x115, 7, 0, Edit1, ahk_class AutoHotkeyGUI

}

Sanitize(Str){
    Str := StrReplace(Str, A_Space, "_")
    Str := StrReplace(Str, A_Space, "+")
    StringLower, NewStr, Str
    return NewStr
}

;Step3 Create GUI

Gui, Add, Text, section, Step1. Select File:

Gui, Add, Radio, gCheck vRadioGroup1 Checked , flex-content.acf.yaml
Gui, Add, Radio, gCheck vRadioGroup2, options.acf.yaml

Gui, Add, Text, section, Step2. Take a screenshot of the flexible module:
Gui, Add, Button, w80 default, Screenshot
Gui, Add, Text, section, Step3. Prepare flex-content.acf.yaml:
Gui, Add, Edit, R40 vFlexContentEdit w900 ReadOnly
; FileRead, FileContents, %Constant_FlexContent_File%
; GuiControl,, FlexContentEdit, %FileContents%
Gui, Add, Button, section w80 default , Repeater
GuiControl,Disable, Button4
Gui, Add, Button, w80 default, Repeater-1
GuiControl,Disable, Button5
Gui, Add, Button, w80 default ys, Text
GuiControl,Disable, Button6
Gui, Add, Button, w80 default, Image
GuiControl,Disable, Button7
Gui, Add, Button, w80 default ys, Link
GuiControl,Disable, Button8
Gui, Add, Button, w80 default, Wysiwyg
GuiControl,Disable, Button9
Gui, Add, Button, w80 default ys, Select(SVG)
GuiControl,Disable, Button10
Gui, Add, Button, w80 default, TextArea
GuiControl,Disable, Button11
Gui, Add, Button, w80 default ys, TrueFalse
GuiControl,Disable, Button12
Gui, Add, Button, w80 default, ButtonGroup
GuiControl,Disable, Button13

Gui, Add, Button, x810 y25 w100 default, UndoLastStep
GuiControl,Disable, Button14

Gui, Show,, %Constant_FlexContent_File%
global _GUI := A_DefaultGUI

UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
return ; End of auto-execute section. The script is idle until the user does something.

Check:
    Gui, Submit, NoHide
    if (RadioGroup1){
        gWhichFile := 1
        GuiControl,Enable, Button3
    }
    if (RadioGroup2){
        gWhichFile := 2
        GuiControl,Disable, Button3
    }

Return

ButtonScreenshot:

    ;Save all in case 'Undo' in the future
    FileRead, gFlexibleFileSnapshot, %Constant_FlexContent_File%

    ; Start gdi+
    If !pToken := Gdip_Startup()
    {
        MsgBox "Gdiplus failed to start. Please ensure you have gdiplus on your system"
        ExitApp
    }
    ;Step0 reset repeater Button
    gRepeaterLevel := 0
    gSpaceRepeater :=""
    GuiControl, Text, Button4 , Repeater

    ;Step1 Take a screenshot
    Process, Exist, snippingtool.exe
    status = %ErrorLevel% 
    if status = 0
    {
        RunWait snippingtool.exe /clip

    }

    pBitmap1 := Gdip_CreateBitmapFromClipboard()

    ;Step2 Name your module
    InputBox, vModuleName, Flexible Module Helper, Please input the label(e.g. "Parallax Banner"), ,450,130
    vSanitized := Sanitize(vModuleName)

    if ErrorLevel
        Exit

    ;Step3 Generate php
    gModule_File = %Constant_Flexible_Folder%%vSanitized%_section.php
    FileAppend, <!-- Generate by Flexible Module Helper -->`n, %gModule_File%

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

    gImage_Name = %Constant_Instruction_Folder%%vSanitized%_section.png

    Gdip_SaveBitmapToFile(pBitmap2, gImage_Name)
    Gdip_DeleteGraphics(pGraphics2)
    Gdip_DisposeImage(pBitmap1)
    Gdip_DisposeImage(pBitmap2)

    ; ...and gdi+ may now be shutdown
    Gdip_Shutdown(pToken)
    ;Step5 write to flex-content.acf.yaml
    FileAppend, %Space6%%vSanitized%_section:`n, %Constant_FlexContent_File%
    FileAppend, %Space8%display: "block"`n, %Constant_FlexContent_File%
    FileAppend, %Space8%label: "%vModuleName% Section"`n, %Constant_FlexContent_File%
    FileAppend, %Space8%sub_fields:`n, %Constant_FlexContent_File%
    FileAppend, %Space10%screenshot:`n, %Constant_FlexContent_File%
    FileAppend, %Space12%type: message`n, %Constant_FlexContent_File%
    FileAppend, %Space12%label: Module Screenshot`n, %Constant_FlexContent_File%
    FileAppend, %Space12%message: <a href="`%`%THEME_INSTRUCTION_FOLDER`%`%%vSanitized%_section.png" data-lity>Demo Preview</a>`n, %Constant_FlexContent_File%
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)

    ;Step6 enable buttons
    GuiControl,Enable, Button4
    GuiControl,Enable, Button5
    GuiControl,Enable, Button6
    GuiControl,Enable, Button7
    GuiControl,Enable, Button8
    GuiControl,Enable, Button9
    GuiControl,Enable, Button10
    GuiControl,Enable, Button11
    GuiControl,Enable, Button12
    GuiControl,Enable, Button13
    GuiControl,Enable, Button14

    gStep=1

return
ButtonUndoLastStep:
    if (gStep=2){
        FileDelete, %Constant_FlexContent_File%
        FileDelete, %gModule_File%

        FileAppend, %gFlexibleFileSnapshot%, %Constant_FlexContent_File%
        FileAppend, %gModuleFileSnapshot%, %gModule_File%
        GuiControl,Disable, Button14
        gStep=0
    }
    else if (gStep=1){

        FileDelete, %gModule_File%
        FileDelete, %gImage_Name%

        FileDelete, %Constant_FlexContent_File%
        FileAppend, %gFlexibleFileSnapshot%, %Constant_FlexContent_File%
        GuiControl,Disable, Button14
        gStep=0
    }else{
        ;do nothing
    }

    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
return
ButtonText:

    if(gWhichFile=2){
        InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
        if (ErrorLevel or (vFieldName = ""))
        {
            FileAppend, %gSpaceRepeater%%Space2%text:`n, %Constant_Options_File%
            FileAppend, %gSpaceRepeater%%Space4%label: Text`n, %Constant_Options_File%
            FileAppend, %gSpaceRepeater%%Space4%type: text`n, %Constant_Options_File%

            FileAppend, `n<?= get_sub_field('text'); ?> `n, %Constant_Header%
            FileAppend, `n<?= get_sub_field('text'); ?> `n, %Constant_Footer%

        }
        else{
            vSanitized := Sanitize(vFieldName)
            FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
            FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
            FileAppend, %gSpaceRepeater%%Space12%type: text`n, %Constant_FlexContent_File%

            FileAppend, `n<?= get_sub_field('%vSanitized%'); ?> `n, %Constant_Header%
            FileAppend, `n<?= get_sub_field('%vSanitized%'); ?> `n, %Constant_Footer%
        }

        UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    }

    ;Save all in case 'Undo' in the future
    FileRead, gFlexibleFileSnapshot, %Constant_FlexContent_File%
    FileRead, gModuleFileSnapshot, %gModule_File%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%text:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Text`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: text`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('text'); ?> `n, %gModule_File%

    }
    else{
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: text`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('%vSanitized%'); ?> `n, %gModule_File%
    }

    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return
ButtonTrueFalse:

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%true_false:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: True/False`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: true_false`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%ui: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%default_value: false`n, %Constant_FlexContent_File%

        FileAppend, `n<?php if( get_sub_field('true_false') ): ?> `n, %gModule_File%
            FileAppend, <?php // do something ?> `n, %gModule_File%
        FileAppend, <?php endif; ?> `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: true_false`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%ui: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%default_value: false`n, %Constant_FlexContent_File%

        FileAppend, `n<?php if( get_sub_field('%vSanitized%') ): ?> `n, %gModule_File%
            FileAppend, <?php // do something ?> `n, %gModule_File%
        FileAppend, <?php endif; ?> `n, %gModule_File%
    }
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return
ButtonButtonGroup:

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%button_group:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Button Group`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: horizontal`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%layout: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%return_format: value`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%choices:`n, %Constant_FlexContent_File%
    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: true_false`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%ui: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%default_value: false`n, %Constant_FlexContent_File%
    }

    Gui, ChoicesGui:Add, Text, x20 y20, Choice name:
    Gui, ChoicesGui:Add, Edit, x100 y15 vChoiceName
    Gui, ChoicesGui:Add, Button, x19 y45 w80 default, Next_Choice
    Gui, ChoicesGui:Add, Button, x156 y45 w80 default, No_More
    Gui, ChoicesGui:Show,, Add Choice

    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return

ChoicesGuiButtonNext_Choice:
    Gui, Submit, NoHide
    StringUpper, ChoiceNameCap, ChoiceName, T
    FileAppend, %gSpaceRepeater%%Space14%%ChoiceName%:%ChoiceNameCap%`n, %Constant_FlexContent_File%
    GuiControl,,Edit1, 
    GUI, %_GUI%:Default
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
return

ButtonTextArea:

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%textarea:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Textarea`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: textarea`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%new_lines: br`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%rows: 4`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('textarea'); ?>  `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: textarea`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%new_lines: br`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%rows: 4`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('%vSanitized%'); ?>  `n, %gModule_File%

    }
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return
ButtonImage:

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%image:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Image`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: image`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%preview_size: thumbnail`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%max_size: 5 # in MB`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('image')['url']; ?>  `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: image`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%preview_size: thumbnail`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%max_size: 5 # in MB`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('%vSanitized%')['url']; ?>  `n, %gModule_File%

    }
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return
ButtonLink:

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%link:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Link`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: link`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%return_format: array`n, %Constant_FlexContent_File%

        FileAppend, `n<?php `n, %gModule_File%
        FileAppend, $link = get_sub_field('link');   `n, %gModule_File%
        FileAppend, if( $link ): `n, %gModule_File%
            FileAppend, $link_url = $link['url'];    `n, %gModule_File%
        FileAppend, $link_title = $link['title'];    `n, %gModule_File%
        FileAppend, $link_target = $link['target'] ? $link['target'] : '_self';    `n, %gModule_File%
        FileAppend, ?> `n, %gModule_File%
        FileAppend, <a class="button" href="<?php echo esc_url($link_url); ?>" target="<?php echo esc_attr($link_target); ?>"><?php echo esc_html($link_title); ?></a>    `n, %gModule_File%
        FileAppend, <?php endif; ?>   `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: link`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%return_format: array`n, %Constant_FlexContent_File%

        FileAppend, `n<?php `n, %gModule_File%
        FileAppend, $link = get_sub_field('%vSanitized%');   `n, %gModule_File%
        FileAppend, if( $link ): `n, %gModule_File%
            FileAppend, $link_url = $link['url'];    `n, %gModule_File%
        FileAppend, $link_title = $link['title'];    `n, %gModule_File%
        FileAppend, $link_target = $link['target'] ? $link['target'] : '_self';    `n, %gModule_File%
        FileAppend, ?> `n, %gModule_File%
        FileAppend, <a class="button" href="<?php echo esc_url($link_url); ?>" target="<?php echo esc_attr($link_target); ?>"><?php echo esc_html($link_title); ?></a>    `n, %gModule_File%
        FileAppend, <?php endif; ?>   `n, %gModule_File%
    }
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return
ButtonWysiwyg:

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%wysiwyg:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Wysiwyg`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: wysiwyg`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%tabs: all`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%toolbar: full`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%media_upload: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%delay: true`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('wysiwyg'); ?>    `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: wysiwyg`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%tabs: all`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%toolbar: full`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%media_upload: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%delay: true`n, %Constant_FlexContent_File%

        FileAppend, `n<?= get_sub_field('%vSanitized%'); ?>    `n, %gModule_File%
    }
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return
ButtonSelect(SVG):

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%svg_select:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Svg Select`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: select`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%wrapper_width: 50`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%ui: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%wrapper_class: js-icon-selector`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%choices: []`n, %Constant_FlexContent_File%

        FileAppend, `n<img src="<?php echo get_stylesheet_directory_uri(); ?>/images/svg/<?= get_sub_field('svg_select') ?>.svg" alt="" />    `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: select`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%wrapper_width: 50`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%ui: true`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%wrapper_class: js-icon-selector`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%choices: []`n, %Constant_FlexContent_File%

        FileAppend, `n<img src="<?php echo get_stylesheet_directory_uri(); ?>/images/svg/<?= get_sub_field('%vSanitized%') ?>.svg" alt="" />    `n, %gModule_File%
    }
    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return

ButtonRepeater:
    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space10%repeater:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: Repeater`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: repeater`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%layout: block`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%sub_fields:`n, %Constant_FlexContent_File%

        FileAppend, `n<?php `n, %gModule_File%
        FileAppend, if( have_rows('repeater') ): `n, %gModule_File%
            FileAppend, while ( have_rows('repeater') ) : the_row(); ?>    `n, %gModule_File%
            FileAppend, xxxxxxxxxx `n, %gModule_File%
        FileAppend, <?php endwhile;    `n, %gModule_File%
        FileAppend, endif;    `n, %gModule_File%
        FileAppend, ?> `n, %gModule_File%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space10%%vSanitized%:`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%label: %vFieldName%`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%type: repeater`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%layout: block`n, %Constant_FlexContent_File%
        FileAppend, %gSpaceRepeater%%Space12%sub_fields:`n, %Constant_FlexContent_File%

        FileAppend, `n<?php `n, %gModule_File%
        FileAppend, if( have_rows('%vSanitized%') ): `n, %gModule_File%
            FileAppend, while ( have_rows('%vSanitized%') ) : the_row(); ?>    `n, %gModule_File%
            FileAppend, xxxxxxxxxx `n, %gModule_File%
        FileAppend, <?php endwhile;    `n, %gModule_File%
        FileAppend, endif;    `n, %gModule_File%
        FileAppend, ?> `n, %gModule_File%

    }

    gRepeaterLevel+= 1
    gSpaceRepeater = %gSpaceRepeater%%A_Space%%A_Space%%A_Space%%A_Space%

    GuiControl, Text, Button4 , Repeater%gRepeaterLevel%

    UpdateGUI(Constant_FlexContent_File,FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button14
return

ButtonRepeater-1:
    ; Auto scroll to the bottom
    SendMessage, 0x115, 7, 0, Edit1

    if(gRepeaterLevel>0){
        gRepeaterLevel-= 1
        gSpaceRepeater :=""
        Loop %gRepeaterLevel%
        {
            gSpaceRepeater = %gSpaceRepeater%%A_Space%%A_Space%%A_Space%%A_Space%
        }
        if(gRepeaterLevel=0)
            GuiControl, Text, Button4 , Repeater
        else
            GuiControl, Text, Button4 , Repeater%gRepeaterLevel%
    }

return

GuiClose:
ExitApp