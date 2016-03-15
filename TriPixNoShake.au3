#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Petit programme permettant de sélectionner trois pixels proche afin d'effectuer une action si un de ces pixels change de couleur
#AutoIt3Wrapper_Res_Description=TriPixNoShake
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_Language=1036
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Misc.au3>
#include <WinAPIMisc.au3>
Opt('MouseCoordMode', 1)
Opt('PixelCoordMode',1)

Global $ColorP1, $ColorP2, $ColorP3, $XP1, $XP2, $XP3, $YP1, $YP2, $YP3
Global $pix1, $pix2, $pix3, $flag = 0
GUICreate("anti-shake", 200, 200)

$GetPixelButton = GUICtrlCreateButton("x", 5, 5, 20, 20)

GUICtrlCreateLabel("Pixel 1 :", 5, 30, 50, 15)
$ColorP1 = GUICtrlCreateInput("", 55, 27, 20, 20)
$ColorCode1 = GUICtrlCreateLabel("", 80, 30, 50, 15)
$XP1 = GUICtrlCreateInput("", 130, 27, 30, 20)
$YP1 = GUICtrlCreateInput("", 165, 27, 30, 20)

GUICtrlCreateLabel("Pixel 2 :", 5, 52, 50, 15)
$ColorP2 = GUICtrlCreateInput("", 55, 52, 20, 20)
$ColorCode2 = GUICtrlCreateLabel("", 80, 55, 50, 15)
$XP2 = GUICtrlCreateInput("", 130, 52, 30, 20)
$YP2 = GUICtrlCreateInput("", 165, 52, 30, 20)

GUICtrlCreateLabel("Pixel 3 :", 5, 77, 50, 15)
$ColorP3 = GUICtrlCreateInput("", 55, 77, 20, 20)
$ColorCode3 = GUICtrlCreateLabel("", 80, 80, 50, 15)
$XP3 = GUICtrlCreateInput("", 130, 77, 30, 20)
$YP3 = GUICtrlCreateInput("", 165, 77, 30, 20)

GUISetState()
While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case -3
			Exit
		Case $GetPixelButton
			_PixelColorChoice()

	EndSwitch
	Sleep(100)
	If Not $flag = 0 Then
		$PixKeeper1 = PixelGetColor(GUICtrlRead($XP1), GUICtrlRead($YP1))
		If $pix1 <> $PixKeeper1 Then

		EndIf
		$PixKeeper2 = PixelGetColor(GUICtrlRead($XP2), GUICtrlRead($YP2))
		If $pix2 <> $PixKeeper2 Then

		EndIf
		$PixKeeper3 = PixelGetColor(GUICtrlRead($XP3), GUICtrlRead($YP3))
		If $pix3 <> $PixKeeper3 Then

		EndIf
	EndIf


WEnd

Func _PixelColorChoice()
	While 2
		$CtrlPos = MouseGetPos()

		If _IsPressed(01) Then

			$pix1 = PixelGetColor($CtrlPos[0], $CtrlPos[1])
			GUICtrlSetBkColor($ColorP1, "0x" & Hex($pix1, 6))
			GUICtrlSetData($ColorCode1, Hex($pix1, 6))
			GUICtrlSetData($XP1, $CtrlPos[0])
			GUICtrlSetData($YP1, $CtrlPos[1])

			$pix2 = PixelGetColor($CtrlPos[0] + 2, $CtrlPos[1])
			GUICtrlSetBkColor($ColorP2, "0x" & Hex($pix2, 6))
			GUICtrlSetData($ColorCode2, Hex($pix2, 6))
			GUICtrlSetData($XP2, $CtrlPos[0] + 2)
			GUICtrlSetData($YP2, $CtrlPos[1])

			$pix3 = PixelGetColor($CtrlPos[0]+1, $CtrlPos[1] + 2)
			GUICtrlSetBkColor($ColorP3, "0x" & Hex($pix3, 6))
			GUICtrlSetData($ColorCode3, Hex($pix3, 6))
			GUICtrlSetData($XP3, $CtrlPos[0]+1)
			GUICtrlSetData($YP3, $CtrlPos[1] + 2)
			$flag = 1
			ExitLoop
		EndIf
	WEnd
EndFunc   ;==>_PixelColorChoice