#SingleInstance ; Only one instance
#Persistent	; Keep this script running after the auto-execute completes.
; SetTitleMatchMode RegEx ; change to regex since the ahk_class can seemingly change
; SetKeyDelay 200 ; try to prevent skips from sending keys too fast

; period := 1000 * 5  ; every 5 seconds
period := 1200
; hold_down_time := 5000
toggle := false

F6::
{
	simpleADStrafe()
	return
}

F7::
{
	randomADStrafeV2()
	return
}

F8::
{
	randomADStrafeWithCrouch()
	return
}

F9::
{
	Reload
	Sleep 1000 ; If successful, the reload will close this instance during the Sleep, so the line below will never be reached.
	MsgBox, 4,, The script could not be reloaded. Would you like to open it for editing?
	IfMsgBox, Yes, Edit
	return
}

simpleADStrafe()
{
	ShowTrayTip("Starting AD Strafe script.")
	strafe_length := 50
	Loop
	{
		holdKey("a", strafe_length)
		holdKey("d", strafe_length)
	}
}

randomADStrafe()
{
	ShowTrayTip("Starting random AD Strafe script.")
	Loop
	{
		Random, strafe_length, 1, 10
		holdKey("a", strafe_length)
		holdKey("d", strafe_length)
	}
}

randomADStrafeV2()
{
	ShowTrayTip("Starting random AD Strafe script v2.")
	Loop
	{
		Random, strafe_length, 1, 5
		Random, direction, 1, 2
	
		if direction = 1
		{
			myKey := "a"
		}
		else if direction = 2
		{
			myKey := "d"
		}
		holdKey(myKey, strafe_length)
	}
}

randomADStrafeWithCrouch()
{
	ShowTrayTip("Starting random AD Strafe With Crouch script.")
	Loop
	{
		Random, strafe_length, 1, 10
		Random, direction, 1, 2
	
		if direction = 1
		{
			myKey := "a"
		}
		else if direction = 2
		{
			myKey := "d"
		}
		
		; holdKey(myKey, strafe_length)
	
		Random, bCrouch, 0, 2
		if bCrouch <= 0 
		{
			holdKeyWithCrouch(myKey, strafe_length)
		} else {
			holdKey(myKey, strafe_length)
		}
	}
}

holdKey(myKey, iterations)
{
	Loop %iterations%
	{
		Send {%myKey% down}  ; Auto-repeat consists of consecutive down-events (with no up-events).
		Sleep 30  ; The number of milliseconds between keystrokes (or use SetKeyDelay).
	}
	Send {%myKey% up}  ; Release the key.
}

holdKeyWithCrouch(key, iterations)
{
	Loop %iterations%
	{
		Send ^{%key% down}  ; Auto-repeat consists of consecutive down-events (with no up-events).
		Sleep 30  ; The number of milliseconds between keystrokes (or use SetKeyDelay).
	}
	Send {%key% up}  ; Release the key.
}


ShowTrayTip(aMessage)
{
	scriptName := regexreplace(A_scriptname,"\..*","")
	TrayTip, %scriptName%, %aMessage%, 1, 1
	return
}
