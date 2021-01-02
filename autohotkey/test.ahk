

Gui, Add, Edit, R40 vMyEdit w900
FileRead, FileContents, C:\Users\fudan\Jimmy\gliders\app\public\wp-content\themes\gliders\acf-fields\flex-content.acf.yaml
GuiControl,, MyEdit, %FileContents%

Gui, Add, Button, default, text  ; The label ButtonOK (if it exists) will be run when the button is pressed.
Gui, Show,, C:\Users\fudan\Jimmy\gliders\app\public\wp-content\themes\gliders\acf-fields\flex-content.acf.yaml
return  ; End of auto-execute section. The script is idle until the user does something.

GuiClose:
Buttontext:
Gui, Submit  ; Save the input from the user to each control's associated variable.
MsgBox You entered "%FirstName% %LastName%".UpdateLayeredWindow()
ExitApp