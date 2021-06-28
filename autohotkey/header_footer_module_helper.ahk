;Must set Constant_Project_Theme_Folder beforehand
Constant_Project_Theme_Folder := "C:\Users\alex\Jimmy\oddculture\app\public\wp-content\themes\oddculture"

Constant_Options_File:= Constant_Project_Theme_Folder . "\acf-fields\options.acf.yaml"
Constant_Header_PHP:= Constant_Project_Theme_Folder . "\header.php"
Constant_Footer_PHP:= Constant_Project_Theme_Folder . "\footer.php"

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
gRepeaterLevel := 0
gSpaceRepeater :=""

gOptionFileSnapshot:=""
gHeaderFileSnapshot:=""
gFooterFileSnapshot:=""

gStep:=0
gWhichFile :=1 ; 1 header.php 2 footer.php

AutoTrim, Off
Space2 = %A_Space%%A_Space%
Space4 = %Space2%%A_Space%%A_Space%
Space6 = %Space4%%A_Space%%A_Space%
Space8 = %Space6%%A_Space%%A_Space%
Space10 = %Space8%%A_Space%%A_Space%
Space12 = %Space10%%A_Space%%A_Space%
Space14 = %Space12%%A_Space%%A_Space%

;Step2 Global function
UpdateGUI(FlexContentEdit,Edit1) {
    global Constant_Options_File
    FileRead, FileContents, %Constant_Options_File%
    GuiControl,, FlexContentEdit, %FileContents%
    ; Auto scroll to the bottom
    SendMessage, 0x115, 7, 0, Edit1, ahk_class AutoHotkeyGUI

}

Sanitize(Str){
    Str := StrReplace(Str, A_Space, "_")
    Str := StrReplace(Str, "+", "_")
    StringLower, NewStr, Str
    return NewStr
}

;Step3 Create GUI
Gui, Add, Text, section, Step1. Select File:
Gui, Add, Radio, gCheck vRadioGroup1 Checked , header.php
Gui, Add, Radio, gCheck vRadioGroup2, footer.php
Gui, Add, Text, section, Step2. Prepare options.acf.yaml:
Gui, Add, Edit, R40 vFlexContentEdit w900 ReadOnly

Gui, Add, Button, x810 y25 w100 default, UndoLastStep

Gui, Add, Button, section x10 y620 w80  default , Repeater
Gui, Add, Button, w80 default, Repeater-1
Gui, Add, Button, w80 default ys, Text
Gui, Add, Button, w80 default, Image
Gui, Add, Button, w80 default ys, Link
Gui, Add, Button, w80 default, Wysiwyg
Gui, Add, Button, w80 default ys, Select(SVG)
Gui, Add, Button, w80 default, TextArea
Gui, Add, Button, w80 default ys, TrueFalse
Gui, Add, Button, w80 default, ButtonGroup
Gui, Add, Button, w80 default ys, Tab


GuiControl,Disable, Button3

Gui, Show,, Current file: %Constant_Options_File%
global _GUI := A_DefaultGUI

UpdateGUI(FlexContentEdit,Edit1)
return ; End of auto-execute section. The script is idle until the user does something.

Check:
    Gui, Submit, NoHide
    if (RadioGroup1){
        gWhichFile := 1
    }
    if (RadioGroup2){
        gWhichFile := 2
    }

Return

ButtonUndoLastStep:
    if (gStep=2){
        FileDelete, %Constant_Options_File%
        FileDelete, %Constant_Header_PHP%
        FileDelete, %Constant_Footer_PHP%

        FileAppend, %gOptionFileSnapshot%, %Constant_Options_File%
        FileAppend, %gHeaderFileSnapshot%, %Constant_Header_PHP%
        FileAppend, %gFooterFileSnapshot%, %Constant_Footer_PHP%
        GuiControl,Disable, Button3
        gStep=0
    }
    else{
        ;do nothing
    }

    UpdateGUI(FlexContentEdit,Edit1)
return
ButtonText:
    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP
    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%text:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Text`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: text`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('text','options'); ?> `n, %vvFile%
    }
    else{
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: text`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('%vSanitized%','options'); ?> `n, %vvFile%
    }

    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonTab:
    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP
    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%tab:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Tab`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: tab`n, %Constant_Options_File%
    }
    else{
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: tab`n, %Constant_Options_File%
    }

    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonTrueFalse:

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%true_false:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: True/False`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: true_false`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%ui: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%default_value: false`n, %Constant_Options_File%

        FileAppend, `n<?php if( get_field('true_false','options') ): ?> `n, %vvFile%
        FileAppend, <?php // do something ?> `n, %vvFile%
        FileAppend, <?php endif; ?> `n, %vvFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: true_false`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%ui: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%default_value: false`n, %Constant_Options_File%

        FileAppend, `n<?php if( get_field('%vSanitized%','options') ): ?> `n, %vvFile%
        FileAppend, <?php // do something ?> `n, %vvFile%
        FileAppend, <?php endif; ?> `n, %vvFile%
    }
    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonButtonGroup:

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%button_group:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Button Group`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: horizontal`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%layout: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%return_format: value`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%choices:`n, %Constant_Options_File%
    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: true_false`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%ui: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%default_value: false`n, %Constant_Options_File%
    }

    Gui, ChoicesGui:Add, Text, x20 y20, Choice name:
    Gui, ChoicesGui:Add, Edit, x100 y15 vChoiceName
    Gui, ChoicesGui:Add, Button, x19 y45 w80 default, Next_Choice
    Gui, ChoicesGui:Add, Button, x156 y45 w80 default, No_More
    Gui, ChoicesGui:Show,, Add Choice

    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return

ChoicesGuiButtonNext_Choice:
    Gui, Submit, NoHide
    StringUpper, ChoiceNameCap, ChoiceName, T
    FileAppend, %gSpaceRepeater%%Space14%%ChoiceName%:%ChoiceNameCap%`n, %Constant_Options_File%
    GuiControl,,Edit1, 
    GUI, %_GUI%:Default
    UpdateGUI(FlexContentEdit,Edit1)
return

ButtonTextArea:

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%textarea:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Textarea`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: textarea`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%new_lines: br`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%rows: 4`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('textarea','options'); ?>  `n, %gWhichFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: textarea`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%new_lines: br`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%rows: 4`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('%vSanitized%','options'); ?>  `n, %gWhichFile%

    }
    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonImage:

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%image:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Image`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: image`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%preview_size: thumbnail`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%max_size: 5 # in MB`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('image','options')['url']; ?>  `n, %vvFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: image`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%preview_size: thumbnail`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%max_size: 5 # in MB`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('%vSanitized%','options')['url']; ?>  `n, %vvFile%

    }
    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonLink:
    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%


    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%link:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Link`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: link`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%return_format: array`n, %Constant_Options_File%

        FileAppend, `n<?php `n, %vvFile%
        FileAppend, $link = get_field('link','options');   `n, %vvFile%
        FileAppend, if( $link ): `n, %vvFile%
            FileAppend, $link_url = $link['url'];    `n, %vvFile%
        FileAppend, $link_title = $link['title'];    `n, %vvFile%
        FileAppend, $link_target = $link['target'] ? $link['target'] : '_self';    `n, %vvFile%
        FileAppend, ?> `n, %vvFile%
        FileAppend, <a class="button" href="<?php echo esc_url($link_url); ?>" target="<?php echo esc_attr($link_target); ?>"><?php echo esc_html($link_title); ?></a>    `n, %vvFile%
        FileAppend, <?php endif; ?>   `n, %vvFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: link`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%return_format: array`n, %Constant_Options_File%

        FileAppend, `n<?php `n, %vvFile%
        FileAppend, $link = get_field('%vSanitized%','options');   `n, %vvFile%
        FileAppend, if( $link ): `n, %vvFile%
            FileAppend, $link_url = $link['url'];    `n, %vvFile%
        FileAppend, $link_title = $link['title'];    `n, %vvFile%
        FileAppend, $link_target = $link['target'] ? $link['target'] : '_self';    `n, %vvFile%
        FileAppend, ?> `n, %vvFile%
        FileAppend, <a class="button" href="<?php echo esc_url($link_url); ?>" target="<?php echo esc_attr($link_target); ?>"><?php echo esc_html($link_title); ?></a>    `n, %vvFile%
        FileAppend, <?php endif; ?>   `n, %vvFile%
    }
    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonWysiwyg:

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%
    
    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%wysiwyg:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Wysiwyg`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: wysiwyg`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%tabs: all`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%toolbar: full`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%media_upload: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%delay: true`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('wysiwyg','options'); ?>    `n, %vvFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: wysiwyg`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%tabs: all`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%toolbar: full`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%media_upload: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%delay: true`n, %Constant_Options_File%

        FileAppend, `n<?= get_field('%vSanitized%','options'); ?>    `n, %vvFile%
    }
    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return
ButtonSelect(SVG):

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%svg_select:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Svg Select`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: select`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%wrapper_width: 50`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%ui: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%wrapper_class: js-icon-selector`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%choices: []`n, %Constant_Options_File%

        FileAppend, `n<img src="<?php echo get_stylesheet_directory_uri(); ?>/images/svg/<?= get_field('svg_select','options') ?>.svg" alt="" />    `n, %vvFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: select`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%wrapper_width: 50`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%ui: true`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%wrapper_class: js-icon-selector`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%choices: []`n, %Constant_Options_File%

        FileAppend, `n<img src="<?php echo get_stylesheet_directory_uri(); ?>/images/svg/<?= get_field('%vSanitized%','options') ?>.svg" alt="" />    `n, %vvFile%
    }
    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
return

ButtonRepeater:

    if(gWhichFile=1)
        vvFile:=Constant_Header_PHP
    else
        vvFile:=Constant_Footer_PHP

    ;Save all in case 'Undo' in the future
    FileRead, gOptionFileSnapshot, %Constant_Options_File%
    FileRead, gHeaderFileSnapshot, %Constant_Header_PHP%
    FileRead, gFooterFileSnapshot, %Constant_Footer_PHP%

    InputBox, vFieldName, Field Name, Please enter field's name(leave it blank as default name), , ,130
    if (ErrorLevel or (vFieldName = ""))
    {
        FileAppend, %gSpaceRepeater%%Space2%repeater:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: Repeater`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: repeater`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%layout: block`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%sub_fields:`n, %Constant_Options_File%

        FileAppend, `n<?php `n, %vvFile%
        FileAppend, if( have_rows('repeater','options') ): `n, %vvFile%
            FileAppend, while ( have_rows('repeater','options') ) : the_row(); ?>    `n, %vvFile%
            FileAppend, xxxxxxxxxx `n, %vvFile%
        FileAppend, <?php endwhile;    `n, %vvFile%
        FileAppend, endif;    `n, %vvFile%
        FileAppend, ?> `n, %vvFile%

    }
    else
    {
        vSanitized := Sanitize(vFieldName)
        FileAppend, %gSpaceRepeater%%Space2%%vSanitized%:`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%label: %vFieldName%`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%type: repeater`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%layout: block`n, %Constant_Options_File%
        FileAppend, %gSpaceRepeater%%Space4%sub_fields:`n, %Constant_Options_File%

        FileAppend, `n<?php `n, %vvFile%
        FileAppend, if( have_rows('%vSanitized%','options') ): `n, %vvFile%
            FileAppend, while ( have_rows('%vSanitized%','options') ) : the_row(); ?>    `n, %vvFile%
            FileAppend, xxxxxxxxxx `n, %vvFile%
        FileAppend, <?php endwhile;    `n, %vvFile%
        FileAppend, endif;    `n, %vvFile%
        FileAppend, ?> `n, %vvFile%

    }

    gRepeaterLevel+= 1
    gSpaceRepeater = %gSpaceRepeater%%A_Space%%A_Space%%A_Space%%A_Space%

    GuiControl, Text, Button4 , Repeater%gRepeaterLevel%

    UpdateGUI(FlexContentEdit,Edit1)
    gStep=2
    GuiControl,Enable, Button3
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