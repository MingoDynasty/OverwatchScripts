;=====================================================
; ADAD Spam Script
;
; F4: Pharah hover (still in beta).
; F5: Predictable AD strafing.
; F6: Predictable AD strafing with jump spam.
; F7: ADAD spam.
; F8: ADAD spam with crouch spam.
; F9: Reloads the script.
;=====================================================
#SingleInstance ; Only one instance
#Persistent	; Keep this script running after the auto-execute completes.

main:
{
	resetKeys()
}

;=====================================================
; Hotkeys
;=====================================================

F4::
{
	pharah()
	return
}

F5::
{
	simpleADStrafe()
	return
}

F6::
{
	simpleADStrafeWithJump()
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

;=====================================================
; Functions
;=====================================================

; When reloading the script in the middle of a strafe, the key is still registered as a key down.
; Use this to reset all key states.
resetKeys()
{
	Send {a up}
	Send {d up}
	Send {Space up}
}

pharah()
{
	ShowTrayTip("Starting Pharah script.")
	Loop
	{
		Send {Shift down}{Shift up}
		Sleep 1000
		hover(12)
	}
}

hover(iterations)
{
	Loop %iterations%
	{
		Send {Space down}
		Sleep 333  ; The number of milliseconds between keystrokes (or use SetKeyDelay).
		Send {Space up}
		Sleep 450
	}
}

tooHighHover(iterations)
{
	Loop %iterations%
	{
		Send {Space down}
		Sleep 300  ; The number of milliseconds between keystrokes (or use SetKeyDelay).
		Send {Space up}
		Sleep 400
	}
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

simpleADStrafeWithJump()
{
	ShowTrayTip("Starting AD Strafe jump script.")
	strafe_length := 50
	Loop
	{
		holdKeyWithSpace("a", strafe_length)
		holdKeyWithSpace("d", strafe_length)
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
			key := "a"
		}
		else if direction = 2
		{
			key := "d"
		}
		holdKey(key, strafe_length)
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
			key := "a"
		}
		else if direction = 2
		{
			key := "d"
		}
			
		Random, bCrouch, 0, 2
		if bCrouch <= 0 
		{
			holdKeyWithCrouch(key, strafe_length)
		} else {
			holdKey(key, strafe_length)
		}
	}
}

holdKey(key, iterations)
{
	Loop %iterations%
	{
		Send {%key% down}  ; Auto-repeat consists of consecutive down-events (with no up-events).
		Sleep 30  ; The number of milliseconds between keystrokes (or use SetKeyDelay).
	}
	Send {%key% up}  ; Release the key.
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

holdKeyWithSpace(key, iterations)
{
	Loop %iterations%
	{
		Send {%key% down}  ; Auto-repeat consists of consecutive down-events (with no up-events).
		Send {Space}
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
