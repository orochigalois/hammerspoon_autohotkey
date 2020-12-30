#Include ./Gdip_All.ahk

;q:: ;resize image
vUrl := "https://www.autohotkey.com/static/ahk_logo.png"
vFactor := 2
vFactorW := vFactorH := vFactor

SplitPath, vUrl, vName, vDir, vExt, vNameNoExt, vDrive
vPath1 := A_Desktop "\" vName
vPath2 := A_Desktop "\" vNameNoExt " " A_Now "." vExt
if !FileExist(vPath1)
	UrlDownloadToFile, % vUrl, % vPath1

pToken := Gdip_Startup()
pBitmap1 := Gdip_CreateBitmapFromFile(vPath1)
Gdip_GetDimensions(pBitmap1, vImgW1, vImgH1)
vImgW2 := Round(vImgW1 * vFactorW)
vImgH2 := Round(vImgH1 * vFactorH)
pBitmap2 := Gdip_CreateBitmap(vImgW2, vImgH2)
pGraphics2 := Gdip_GraphicsFromImage(pBitmap2)

;2 options from:
;[functions] More GDI+ functions - AutoHotkey Community
;https://autohotkey.com/boards/viewtopic.php?f=6&t=12312
;Gdip_SetSmoothingMode(pGraphics2, 4)
;Gdip_SetInterpolationMode(pGraphics2, 7)


Gdip_DrawImage(pGraphics2, pBitmap1, 0, 0, vImgW2, vImgH2, 0, 0, vImgW1, vImgH1)
Gdip_SaveBitmapToFile(pBitmap2, vPath2)
Gdip_DeleteGraphics(pGraphics2)
Gdip_DisposeImage(pBitmap1)
Gdip_DisposeImage(pBitmap2)
Gdip_Shutdown(pToken)
MsgBox, % "done"
return