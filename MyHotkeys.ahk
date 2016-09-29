#NoEnv
#SingleInstance, force
#Persistent

SendMode Input
SetWorkingDir %A_ScriptDir%

SetBatchLines -1

cycleNumber := 1

current:="v2.0"

intro:="
	(
	
	Version : MyHotkeys v2.0

	Author  : Rami Alhaddad

	Function: Hotkeys for Windows OS.

	You can press WIN+H to display the Help Menu.

	)"
	
menu,tray,NoStandard
menu,tray,add,Suspend,Suspend
menu,tray,add,About...,about
menu,tray,add,Exit,exit

Volume_Delay:=1000
BG_color=1A1A1A
Text_color=FFFFFF
Bar_color=666666
Volume_OSD_BottomRight:=1
over_tray:=0
MsgBox, 0, MyHotkeys v2.0, Press WIN+H for help anytime!,5
return

#Numpad6::
Send {Volume_Up}
gosub, Volume_Show_OSD
return

#Numpad4::
Send {Volume_Down}
gosub, Volume_Show_OSD
return

#Numpad0::
Send {Volume_Mute}
gosub, Volume_Show_OSD
Volume_Show_OSD:
if (Volume_OSD_Center)
{
mY := (A_ScreenHeight/2)-26, mX := (A_ScreenWidth/2)-165
}
else
{
SysGet m, MonitorWorkArea, 1
mY := mBottom-52-2, mX := mRight-330-2
}
SoundGet, Volume
if (!Volume_OSD_c)
{
Volume_ProgressbarOpts=CW%BG_color% CT%Text_color% CB%Bar_color% x%mX% y%mY% w330 h52 B1 FS8 WM700 WS700 FM8 ZH12 ZY3 C11
Progress Hide %Volume_ProgressbarOpts%,,Volume,, Tahoma
Volume_OSD_c:=!Volume_OSD_c
}
Progress Show
Progress % Volume := Round(Volume), %Volume% `%
SetTimer, Remove_Show_OSD, %Volume_Delay%
return
Remove_Show_OSD:
SetTimer, Remove_Show_OSD, Off
Progress Hide %Volume_ProgressbarOpts%,,Volume,,Tahoma
return
MouseIsOver(WinTitle) {
MouseGetPos,,, Win
return WinExist(WinTitle . " ahk_id " . Win)
}
return

#Numpad5::
br := 128

#Numpad8::

#Numpad2::
br += (InStr(A_ThisHotkey, "#Numpad2") ? -8 : 8 )
If ( br > 256 )
br := 256
If ( br < 0 )
br := 0
VarSetCapacity(gr, 512*3)
Loop,   256
{
If  (nValue:=(br+128)*(A_Index-1))>65535
nValue:=65535
NumPut(nValue, gr,      2*(A_Index-1), "Ushort")
NumPut(nValue, gr,  512+2*(A_Index-1), "Ushort")
NumPut(nValue, gr, 1024+2*(A_Index-1), "Ushort")
}
hDC := DllCall("GetDC", "Uint", 0)
DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gr)
DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
MaxClipboards = 5
usedClipboards = 0
ClipIndex = 0
guiActive = false
return

#h::
MsgBox, 262144, Help Menu, Pressing WIN with:`n`nH       Opens this menu`nS        Opens new sticky note`nX        Opens Snipping Tool`nN       Opens new Notepad`nG        Google Search`nK        Locks/Unlocks keystrokes and mouse clicks`n`nNumpad 8        Increase Brightness`nNumpad 2        Decrease Brightness`nNumpad 5        Set Brightness back to 50`%`n`nNumpad 6        Increase Volume`nNumpad 4        Decrease Volume`nNumpad 0        Volume Mute.
return

#s::
if WinExist("ahk_exe StikyNot.exe")
{
WinActivate, ahk_exe StikyNot.exe
Send, ^n
}
Run, StikyNot.exe
return

Notepad:
#n::
Run, notepad.exe
return

#g::
InputBox, Search, Google Search, What do you want to search Google?, , 250,150
If ErrorLevel = 0
runwait, www.google.com/#q=%Search%,,max
return

#x::
if WinExist("ahk_exe SnippingTool.exe")
{
WinActivate, ahk_exe SnippingTool.exe
Send, ^n
}
Run, c:\Windows\system32\SnippingTool.exe
return

#k::
ToggleLock(1)
KeyWait, LWin, D
KeyWait, k, D
ToggleLock(0)
return

Suspend:
Suspend, Toggle
return

exit:
exitapp

about:
gui,2:Destroy
gui,2:add,link,,%intro%
gui,2:show,,About MyHotkeys
return

;*************************************** Functions *************************************
; Locks/Unlocks keystrokes and mouse clicks.
ToggleLock(cmd)
{
  SetFormat, IntegerFast, Hex
Count := 0
  If (cmd)
  {
    Loop 0x1FF  ; Blocks keystrokes
    Hotkey, sc%A_Index%, DUMMY, On
    Loop 0x7    ; Blocks mouse clicks
    Hotkey, *vk%A_Index%, DUMMY, On
  }
Else
  {
    Loop 0x1FF  ; Unblocks keystrokes
    Hotkey, sc%A_Index%, DUMMY, Off
    Loop 0x7    ; Unblocks mouse clicks
    Hotkey, *vk%A_Index%, DUMMY, Off
  }
}

DUMMY:
Return
