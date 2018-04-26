;=====================================================
; ADAD Spam Script
;
; F2: Winston jump loop.
; F3: Fast Winston jump loop. (requires 300% movespeed)
; F4: Pharah hover (still in beta).
; F5: Predictable AD strafing.
; F6: Predictable AD strafing with jump spam.
; F7: ADAD spam.
; F8: ADAD spam with crouch spam.
; F9: Reloads the script.
;=====================================================
#SingleInstance ; Only one instance
#Persistent	; Keep this script running after the auto-execute completes.

minimum_x := -10	; imaginary left wall
maximum_x := 10		; imaginary right wall
current_x := 0		; keep track of our current position
max_length := Abs(minimum_x) + Abs(maximum_x)

main:
{
	resetKeys()
}

;=====================================================
; Hotkeys
;=====================================================

F2::
{
	winstonJumpLoop()
}

F3::
{
	fastWinstonJumpLoop()
}

F4::
{
	pharah()
	return
}

F5::
{
	simpleADStrafe(max_length)
	return
}

F6::
{
	simpleADStrafeWithJump(max_length)
	return
}

F7::
{
	randomADStrafe()
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
resetKeys() {
	Send {a up}
	Send {d up}
	Send {Space up}
	Send {CTRL up}
}

; TODO: good idea in theory, but not sure how to stop any other current 
;		running loops without simply reloading the entire script.
;~ resetPosition() {
	;~ global current_x
	;~ if (current_x > 0) {
		;~ While (current_x > 0) {
			;~ moveLeft()
		;~ }
	;~ } else if (current_x < 0) {
		;~ While (current_x < 0) {
			;~ moveRight()
		;~ }
	;~ } else {
		;~ ShowTrayTip("Already at 0, nothing to do.")
	;~ }
;~ }

fastWinstonJumpLoop() {
	ShowTrayTip("Starting Fast Winston Jump Loop script.")
	Loop {
		Send {SHIFT down}
		Send {SHIFT up}
		Sleep 3000
		
		moveBackward(50)
		moveRight(5)
	}
}

winstonJumpLoop() {
	ShowTrayTip("Starting Winston Jump Loop script.")
	Loop {
		Send {SHIFT down}
		Send {SHIFT up}
		Sleep 3000
		
		moveBackward(120)
		moveRight(15)
	}
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

simpleADStrafe(strafe_length) {
	ShowTrayTip("Starting AD Strafe script.")
	Loop {
		moveLeftWithChecks(strafe_length)
		moveRightWithChecks(strafe_length)
	}
}

simpleADStrafeWithJump(strafe_length) {
	ShowTrayTip("Starting AD Strafe jump script.")
	Loop {
		moveLeftWithChecks(strafe_length, 1)
		moveRightWithChecks(strafe_length, 1)
	}
}

randomADStrafe() {
	ShowTrayTip("Starting random AD Strafe script.")
	Loop {
		Random, strafe_length, 1, 5
		Random, direction, 1, 2
		
		if (direction = 1) {
			moveLeftWithChecks(strafe_length)
		} else if (direction = 2) {
			moveRightWithChecks(strafe_length)
		}
	}
}

randomADStrafeWithCrouch() {
	ShowTrayTip("Starting random AD Strafe With Crouch script.")
	Loop {
		Random, strafe_length, 1, 5
		Random, direction, 1, 2
		Random, bCrouch, 1, 5
		
		if (bCrouch = 1) {
			Send {CTRL DOWN}
		} else if (bCrouch >= 2 && bCrouch <= 4) {
			Send {CTRL UP}
		}
		
		if (direction = 1) {
			moveLeftWithChecks(strafe_length)
		} else if (direction = 2) {
			moveRightWithChecks(strafe_length)
		}
	}
}

moveLeftWithChecks(length, modifier:=0) {
	Loop %length% {
		if (!atMinimum()) {
			moveLeft(1, modifier)
		} else {
			return
		}
	}
}

moveRightWithChecks(length, modifier:=0) {
	Loop %length% {
		if (!atMaximum()) {
			moveRight(1, modifier)
		} else {
			return
		}
	}
}

moveLeft(length, modifier:=0) {
	global current_x
	holdKey("a", length, modifier)
	current_x--
	updateToolTip()
}

moveRight(length, modifier:=0) {
	global current_x
	holdKey("d", length, modifier)
	current_x++
	updateToolTip()
}

moveBackward(length:=1) {
	holdKey("s", length)
}

atMinimum() {
	global minimum_x
	global current_x
	return (if (current_x <= minimum_x ))
}

atMaximum() {
	global maximum_x
	global current_x
	return (if (current_x >= maximum_x ))
}

holdKey(key, iterations, modifier:=0) {
	Loop %iterations% {
		Send {%key% down}  ; Auto-repeat consists of consecutive down-events (with no up-events).
		
		if (modifier = 1) {
			Send {Space}
		}
		Sleep 33  ; The number of milliseconds between keystrokes (or use SetKeyDelay).
	}
	Send {%key% up}  ; Release the key.
}

updateToolTip() {
	global current_x
	ToolTip, Current position: %current_x%
}

MouseToolTip(aMessage) {
	ToolTip, %aMessage%
}

ShowTrayTip(aMessage) {
	scriptName := regexreplace(A_scriptname,"\..*","")
	TrayTip, %scriptName%, %aMessage%, 1, 1
	return
}
