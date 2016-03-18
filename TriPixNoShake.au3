#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Petit programme permettant de sélectionner trois pixels proche afin d'effectuer une action si un de ces pixels change de couleur
#AutoIt3Wrapper_Res_Description=TriPixNoShake
#AutoIt3Wrapper_Res_Fileversion=0.0.0.2
#AutoIt3Wrapper_Res_Language=1036
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <WinAPI.au3>
#include <Array.au3>
#include <Misc.au3>
#include <WinAPIMisc.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <WindowsConstants.au3>
global $DEBUG = 0
#include "AutoInfor(mini).au3"

Opt("MustDeclareVars", 1)
Opt('MouseCoordMode', 1)
Opt('PixelCoordMode', 1)
Opt('GuiOnEventMode', 1)


Global $GUI, $PlayStopButton, $ActionCombo, $GetPixelScreenButton, $GetPixelWindowButton, $WinHandle
Global $ColorP1, $ColorP2, $ColorP3
global $XP1, $XP2, $XP3, $YP1, $YP2, $YP3
Global $pix1, $pix2, $pix3
Global $flag = 0, $FocusFlag = 0, $Focus, $FocusHwnd, $newflag = 0
Global $AppTitle = 'TriPixNoShake'

$GUI = GUICreate($AppTitle, 400, 80,-1,-1,$WS_CAPTION+$WS_SYSMENU,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST)

$PlayStopButton = GUICtrlCreateButton(">", 2, 2, 20, 20, $BS_ICON)
GUICtrlSetState($PlayStopButton, $GUI_DISABLE)

$ActionCombo = GUICtrlCreateCombo("", 24, 2, 190, 20, $CBS_DROPDOWNLIST)
GUICtrlSetData($ActionCombo, "Choisissez une action à effectuer…|Nouvelle action…|Boîte de message", "Choisissez une action à effectuer…")
GUICtrlSetOnEvent($ActionCombo, "_NewAction")

$GetPixelScreenButton = GUICtrlCreateIcon("shell32.dll", 22, 2, 24, 20, 20)
GUICtrlSetTip($GetPixelScreenButton, "Valeur absolue de l'écran")
GUICtrlSetState($GetPixelScreenButton, $GUI_hide)

$GetPixelWindowButton = GUICtrlCreateIcon("shell32.dll", 3, 24, 24, 20, 20)
GUICtrlSetTip($GetPixelWindowButton, "Valeur relative de la fenêtre active")
GUICtrlSetState($GetPixelWindowButton, $GUI_hide)

$WinHandle = GUICtrlCreateLabel("", 5, 28, 340, 30)
GUICtrlSetState($WinHandle, $GUI_HIDE)

GUISetState()
GUIRegisterMsg($WM_COMMAND, "_WM_COMMAND")
GUISetOnEvent(-3, "_EXIT")

While 1
	Sleep(0x7FFFFFF)
WEnd

Func _CheckPix()
	local $PixKeeper1, $PixKeeper2, $PixKeeper3

	If Not $flag = 0 Then
		If Not $FocusFlag = 1 Then
			$PixKeeper1 = PixelGetColor($XP1, $YP1)
			$PixKeeper2 = PixelGetColor($XP2, $YP2)
			$PixKeeper3 = PixelGetColor($XP3, $YP3)
		Else

			$PixKeeper1 = PixelGetColor($XP1, $YP1, $FocusHwnd)
			$PixKeeper2 = PixelGetColor($XP2, $YP2, $FocusHwnd)
			$PixKeeper3 = PixelGetColor($XP3, $YP3, $FocusHwnd)
		EndIf
		If $pix1 <> $PixKeeper1 Or $pix2 <> $PixKeeper2 Or $pix3 <> $PixKeeper3 Then
			_ACTION()
		EndIf
	EndIf
EndFunc   ;==>_CheckPix

Func _PixelColorChoice($var)
	local $CtrlPos

	Opt('MouseCoordMode', $var)
	Opt('PixelCoordMode', $var)
	Opt('WinTitleMatchMode', 4)
	Sleep(100)
	While 2
		$CtrlPos = MouseGetPos()

		If _IsPressed(01) And $flag = 0 Then

			If WinGetTitle("[ACTIVE]", "") <> $AppTitle Then
				Sleep(100)
				;$FocusHwnd = GetHoveredHwnd()
				$FocusHwnd = GetHoveredHwnd($CtrlPos[0], $CtrlPos[1])
				$Focus = WinGetTitle("[ACTIVE]", "")
				If $var = 1 Then
					$pix1 = PixelGetColor($CtrlPos[0], $CtrlPos[1])
					$pix2 = PixelGetColor($CtrlPos[0] + 2, $CtrlPos[1])
					$pix3 = PixelGetColor($CtrlPos[0] + 1, $CtrlPos[1] + 2)
					GUICtrlSetState($GetPixelScreenButton, $GUI_hide)
				GUICtrlSetState($GetPixelWindowButton, $GUI_hide)
					GUICtrlSetState($WinHandle, $Gui_show)
					GUICtrlSetData($WinHandle,$CtrlPos[0] & " x " & $CtrlPos[1] & " - " & "écran entier")
				Else
					$pix1 = PixelGetColor($CtrlPos[0], $CtrlPos[1], $FocusHwnd)
					$pix2 = PixelGetColor($CtrlPos[0] + 2, $CtrlPos[1], $FocusHwnd)
					$pix3 = PixelGetColor($CtrlPos[0] + 1, $CtrlPos[1] + 2, $FocusHwnd)
					GUICtrlSetState($GetPixelScreenButton, $GUI_hide)
				GUICtrlSetState($GetPixelWindowButton, $GUI_hide)
					GUICtrlSetState($WinHandle, $Gui_show)
					GUICtrlSetData($WinHandle, $CtrlPos[0] & " x " & $CtrlPos[1] & " - " & $Focus)
					$FocusFlag = 1
				EndIf
				MsgBox(0, '', $FocusHwnd & @CRLF & $Focus & @CRLF & $CtrlPos[0] & ' : ' & $CtrlPos[1])
				$XP1 = $CtrlPos[0]
				$YP1 = $CtrlPos[1]
				$XP2 = $CtrlPos[0] + 2
				$YP2 = $CtrlPos[1]
				$XP3 = $CtrlPos[0] + 1
				$YP3 = $CtrlPos[1] + 2

				WinActivate($AppTitle)
				Sleep(1000)
				$flag = 1
				Sleep(1000)
				AdlibRegister("_CheckPix", 10)
				ExitLoop
			EndIf

		EndIf
	WEnd
EndFunc   ;==>_PixelColorChoice

Func _ACTION()
	Switch GUICtrlRead($ActionCombo)
		Case "Boîte de message"
			MsgBox(0, '', 'ACTION')
	EndSwitch
		GUICtrlSetState($GetPixelScreenButton, $Gui_show)
				GUICtrlSetState($GetPixelWindowButton, $Gui_show)
				GUICtrlSetState($WinHandle, $GUI_HIDE)
	$flag = 0
EndFunc   ;==>_ACTION

Func _NewAction()
	Switch GUICtrlRead($ActionCombo)
		Case "Nouvelle action…"
			MsgBox(0, "", "Interface de nouvelle action")
	EndSwitch
EndFunc   ;==>_NewAction

Func _WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	Switch BitAND($wParam, 0x0000FFFF)
		Case $GetPixelScreenButton
			_PixelColorChoice(1)
		Case $GetPixelWindowButton
			_PixelColorChoice(0)
		Case $ActionCombo
			If GUICtrlRead($ActionCombo) <> "Choisissez une action à effectuer…" And GUICtrlRead($ActionCombo) <> "Nouvelle action…" Then
				GUICtrlSetState($GetPixelScreenButton, $Gui_show)
				GUICtrlSetState($GetPixelWindowButton, $Gui_show)
			Else
				GUICtrlSetState($GetPixelScreenButton, $GUI_hide)
				GUICtrlSetState($GetPixelWindowButton, $GUI_hide)
				GUICtrlSetData($WinHandle, "")
			EndIf
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>_WM_COMMAND

Func _EXIT()
	AdlibUnRegister()
	Exit
EndFunc   ;==>_EXIT

Func ToggleFlag($flag)
	$flag = Not $flag
	While $flag
		Sleep(10)
		$flag = 1
	WEnd
	$flag = 0
EndFunc   ;==>ToggleFlag
