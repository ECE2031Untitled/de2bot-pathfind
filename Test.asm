; SimpleRobotProgram.asm
; Created by Kevin Johnson
; (no copyright applied; edit freely, no attribution necessary)
; This program does basic initialization of the DE2Bot
; and provides an example of some peripherals.

; Section labels are for clarity only.


ORG        &H000       ;Begin program at x000
;***************************************************************
;* Initialization
;***************************************************************
Init:
	; Always a good idea to make sure the robot
	; stops in the event of a reset.
	LOAD   Zero
	OUT    LVELCMD     ; Stop motors
	OUT    RVELCMD
	OUT    SONAREN     ; Disable sonar (optional)
	
	CALL   SetupI2C    ; Configure the I2C to read the battery voltage
	CALL   BattCheck   ; Get battery voltage (and end if too low).
	OUT    LCD         ; Display batt voltage on LCD

WaitForSafety:
	; Wait for safety switch to be toggled
	IN     XIO         ; XIO contains SAFETY signal
	AND    Mask4       ; SAFETY signal is bit 4
	JPOS   WaitForUser ; If ready, jump to wait for PB3
	IN     TIMER       ; We'll use the timer value to
	AND    Mask1       ;  blink LED17 as a reminder to toggle SW17
	SHIFT  8           ; Shift over to LED17
	OUT    XLEDS       ; LED17 blinks at 2.5Hz (10Hz/4)
	JUMP   WaitForSafety
	
WaitForUser:
	; Wait for user to press PB3
	IN     TIMER       ; We'll blink the LEDs above PB3
	AND    Mask1
	SHIFT  5           ; Both LEDG6 and LEDG7
	STORE  Temp        ; (overkill, but looks nice)
	SHIFT  1
	OR     Temp
	OUT    XLEDS
	IN     XIO         ; XIO contains KEYs
	AND    Mask2       ; KEY3 mask (KEY0 is reset and can't be read)
	JPOS   WaitForUser ; not ready (KEYs are active-low, hence JPOS)
	LOAD   Zero
	OUT    XLEDS       ; clear LEDs once ready to continue

;***************************************************************
;* Main code
;***************************************************************
Main: ; "Real" program starts here.

		; first for X0
		LOAD 	X0		; AC = X0
		SUB 	TWO		; AC = X0 - 2
		JPOS	ROnth0	; This point is on the right side. So region1 or region3 (RTwth:
						; Otherwise: region 2
		LOADI	2		; In Reg 2, AC = 2
		JUMP	DR0		
		
ROnth0:	LOAD	Y0		; AC = Y0
		SUB		TWO		; AC = Y0 - 2
		JPOS	ROne0	; if Y0 - 2 > 0, then in region one
		LOADI	3		; Otherwise , region 3
		JUMP	DR0

ROne0: 	LOADI	1
		JUMP	DR0
		
DR0:	STORE 	R0		; Store what's in the AC into addr R0
		;JUMP	EoR	
		
;-------------------------------------------------------------------------

		LOAD 	X1		; AC = X0
		SUB 	TWO		; AC = X0 - 2
		JPOS	ROnth1	; This point is on the right side. So region1 or region3 (RTwth:
						; Otherwise: region 2
		LOADI	2		; In Reg 2, AC = 2
		JUMP	DR1		
		
ROnth1:	LOAD	Y1		; AC = Y0
		SUB		TWO		; AC = Y0 - 2
		JPOS	ROne1	; if Y0 - 2 > 0, then in region one
		LOADI	3		; Otherwise , region 3
		JUMP	DR1

ROne1: 	LOADI	1
		JUMP	DR1
		
DR1:	STORE 	R1		; Store what's in the AC into addr R0	
		
		
		
;-------------------------------------------------------------------------

		LOAD 	X2		; AC = X0
		SUB 	TWO		; AC = X0 - 2
		JPOS	ROnth2	; This point is on the right side. So region1 or region3 (RTwth:
						; Otherwise: region 2
		LOADI	2		; In Reg 2, AC = 2
		JUMP	DR2		
		
ROnth2:	LOAD	Y2		; AC = Y0
		SUB		TWO		; AC = Y0 - 2
		JPOS	ROne2	; if Y0 - 2 > 0, then in region one
		LOADI	3		; Otherwise , region 3
		JUMP	DR2

ROne2: 	LOADI	1
		JUMP	DR2
		
DR2:	STORE 	R2		; Store what's in the AC into addr R0
			
		
;-------------------------------------------------------------------------

		LOAD 	X3		; AC = X0
		SUB 	TWO		; AC = X0 - 2
		JPOS	ROnth3	; This point is on the right side. So region1 or region3 (RTwth:
						; Otherwise: region 2
		LOADI	2		; In Reg 2, AC = 2S
		JUMP	DR3		
		
ROnth3:	LOAD	Y3		; AC = Y0
		SUB		TWO		; AC = Y0 - 2
		JPOS	ROne3	; if Y0 - 2 > 0, then in region one
		LOADI	3		; Otherwise , region 3
		JUMP	DR3

ROne3: 	LOADI	1
		JUMP	DR3
		
DR3:	STORE 	R3		; Store what's in the AC into addr R0
		
;-------------------------------BY HERE, ALL REGIONS DETERMINED---------------

	


;-------------- Calculate Dist b/t pairs of pts
; dist 01
	LOAD	R0		; AC = RO
	SUB		ONE
	JPOS	D1NOTR1	; START POINT NOT IN R1
	; STARTING POINT IN R1
	LOAD 	R1		; AC = R1
	SUB		THREE
	JZERO	CALD12  ; R0 = 1, R1 = 3
	JUMP	CALD11
	
D1NOTR1:		; DISTANCE1  STARTING PT NOT R1
	LOAD 	R0		; AC = R0
	SUB		THREE
	JZERO	D1THREE		;STARTING POINT IN R3
	JUMP	CALD11
	
D1THREE:
	LOAD 	R1	
	SUB		ONE
	JZERO	CALD12		; ENDING POINT IN R1
	
CALD11:		; DISTANCE 1 METHOD1
	LOAD 	X0
	SUB		X1
	JPOS	D1NEXT1
	JZERO	D1NEXT1
	CALL 	NEGATE
	
D1NEXT1:
	STORE	DIFFX
	LOAD 	Y0
	SUB		Y1
	JPOS	D1STORE
	JZERO	D1STORE
	CALL	NEGATE
	JUMP	D1STORE
	
CALD12:		; DISTANCE 1 METHOD2
	LOAD	X0
	ADD		X1
	SUB		FOUR
	STORE 	DIFFX
	LOAD	Y0
	SUB		Y1
	JPOS	D1STORE
	JZERO	D1STORE
	CALL 	NEGATE
	JUMP	D1STORE

D1STORE:
	ADD	DIFFX
	STORE	DIST01

; dist 02 ----------------------------------------------
	LOAD	R0		; AC = RO
	SUB		ONE
	JPOS	D2NOTR1	; START POINT NOT IN R1
	; STARTING POINT IN R1
	LOAD 	R2		; AC = R1
	SUB		THREE
	JZERO	CALD22  ; R0 = 1, R1 = 3
	JUMP	CALD21
	
D2NOTR1:		; DISTANCE1  STARTING PT NOT R1
	LOAD 	R0		; AC = R0
	SUB		THREE
	JZERO	D2THREE		;STARTING POINT IN R3
	JUMP	CALD21
	
D2THREE:
	LOAD 	R2	
	SUB		ONE
	JZERO	CALD22		; ENDING POINT IN R1
	
CALD21:		; DISTANCE 1 METHOD1
	LOAD 	X0
	SUB		X2
	JPOS	D2NEXT1
	JZERO	D2NEXT1
	CALL 	NEGATE
	
D2NEXT1:
	STORE	DIFFX
	LOAD 	Y0
	SUB		Y2
	JPOS	D2STORE
	JZERO	D2STORE
	CALL	NEGATE
	JUMP	D2STORE
	
CALD22:		; DISTANCE 1 METHOD2
	LOAD	X0
	ADD		X2
	SUB		FOUR
	STORE 	DIFFX
	LOAD	Y0
	SUB		Y2
	JPOS	D2STORE
	JZERO	D2STORE
	CALL 	NEGATE
	JUMP	D2STORE

D2STORE:
	ADD	DIFFX
	STORE	DIST02
	
; dist 03 ----------------------------------------------------
	LOAD	R0		; AC = RO
	SUB		ONE
	JPOS	D3NOTR1	; START POINT NOT IN R1
	; STARTING POINT IN R1
	LOAD 	R3		; AC = R1
	SUB		THREE
	JZERO	CALD32  ; R0 = 1, R1 = 3
	JUMP	CALD31
	
D3NOTR1:		; DISTANCE1  STARTING PT NOT R1
	LOAD 	R0		; AC = R0
	SUB		THREE
	JZERO	D3THREE		;STARTING POINT IN R3
	JUMP	CALD31
	
D3THREE:
	LOAD 	R3	
	SUB		ONE
	JZERO	CALD32		; ENDING POINT IN R1
	
CALD31:		; DISTANCE 1 METHOD1
	LOAD 	X0
	SUB		X3
	JPOS	D3NEXT1
	JZERO	D3NEXT1
	CALL 	NEGATE
	
D3NEXT1:
	STORE	DIFFX
	LOAD 	Y0
	SUB		Y3
	JPOS	D3STORE
	JZERO	D3STORE
	CALL	NEGATE
	JUMP	D3STORE
	
CALD32:		; DISTANCE 1 METHOD2
	LOAD	X0
	ADD		X3
	SUB		FOUR
	STORE 	DIFFX
	LOAD	Y0
	SUB		Y3
	JPOS	D3STORE
	JZERO	D3STORE
	CALL 	NEGATE
	JUMP	D3STORE

D3STORE:
	ADD	DIFFX
	STORE	DIST03
	
; dist 12 ----------------------------------------------
	LOAD	R1		; AC = RO
	SUB		ONE
	JPOS	D4NOTR1	; START POINT NOT IN R1
	; STARTING POINT IN R1
	LOAD 	R2		; AC = R1
	SUB		THREE
	JZERO	CALD42  ; R0 = 1, R1 = 3
	JUMP	CALD41
	
D4NOTR1:		; DISTANCE1  STARTING PT NOT R1
	LOAD 	R1		; AC = R0
	SUB		THREE
	JZERO	D4THREE		;STARTING POINT IN R3
	JUMP	CALD41
	
D4THREE:
	LOAD 	R2	
	SUB		ONE
	JZERO	CALD42		; ENDING POINT IN R1
	
CALD41:		; DISTANCE 1 METHOD1
	LOAD 	X1
	SUB		X2
	JPOS	D4NEXT1
	JZERO	D4NEXT1
	CALL 	NEGATE
	
D4NEXT1:
	STORE	DIFFX
	LOAD 	Y1
	SUB		Y2
	JPOS	D4STORE
	JZERO	D4STORE
	CALL	NEGATE
	JUMP	D4STORE
	
CALD42:		; DISTANCE 1 METHOD2
	LOAD	X1
	ADD		X2
	SUB		FOUR
	STORE 	DIFFX
	LOAD	Y1
	SUB		Y2
	JPOS	D4STORE
	JZERO	D4STORE
	CALL 	NEGATE
	JUMP	D4STORE

D4STORE:
	ADD	DIFFX
	STORE	DIST12

; dist 13 ----------------------------------------------
	LOAD	R1		; AC = RO
	SUB		ONE
	JPOS	D5NOTR1	; START POINT NOT IN R1
	; STARTING POINT IN R1
	LOAD 	R3		; AC = R1
	SUB		THREE
	JZERO	CALD52  ; R0 = 1, R1 = 3
	JUMP	CALD51
	
D5NOTR1:		; DISTANCE1  STARTING PT NOT R1
	LOAD 	R1		; AC = R0
	SUB		THREE
	JZERO	D5THREE		;STARTING POINT IN R3
	JUMP	CALD51
	
D5THREE:
	LOAD 	R3	
	SUB		ONE
	JZERO	CALD52		; ENDING POINT IN R1
	
CALD51:		; DISTANCE 1 METHOD1
	LOAD 	X1
	SUB		X3
	JPOS	D5NEXT1
	JZERO	D5NEXT1
	CALL 	NEGATE
	
D5NEXT1:
	STORE	DIFFX
	LOAD 	Y1
	SUB		Y3
	JPOS	D5STORE
	JZERO	D5STORE
	CALL	NEGATE
	JUMP	D5STORE
	
CALD52:		; DISTANCE 1 METHOD2
	LOAD	X1
	ADD		X3
	SUB		FOUR
	STORE 	DIFFX
	LOAD	Y1
	SUB		Y3
	JPOS	D5STORE
	JZERO	D5STORE
	CALL 	NEGATE
	JUMP	D5STORE

D5STORE:
	ADD	DIFFX
	STORE	DIST13	
	
; dist 13 ----------------------------------------------
	LOAD	R2		; AC = RO
	SUB		ONE
	JPOS	D6NOTR1	; START POINT NOT IN R1
	; STARTING POINT IN R1
	LOAD 	R3		; AC = R1
	SUB		THREE
	JZERO	CALD62  ; R0 = 1, R1 = 3
	JUMP	CALD61
	
D6NOTR1:		; DISTANCE1  STARTING PT NOT R1
	LOAD 	R2		; AC = R0
	SUB		THREE
	JZERO	D6THREE		;STARTING POINT IN R3
	JUMP	CALD61
	
D6THREE:
	LOAD 	R3	
	SUB		ONE
	JZERO	CALD62		; ENDING POINT IN R1
	
CALD61:		; DISTANCE 1 METHOD1
	LOAD 	X2
	SUB		X3
	JPOS	D6NEXT1
	JZERO	D6NEXT1
	CALL 	NEGATE
	
D6NEXT1:
	STORE	DIFFX
	LOAD 	Y2
	SUB		Y3
	JPOS	D6STORE
	JZERO	D6STORE
	CALL	NEGATE
	JUMP	D6STORE
	
CALD62:		; DISTANCE 1 METHOD2
	LOAD	X2
	ADD		X3
	SUB		FOUR
	STORE 	DIFFX
	LOAD	Y2
	SUB		Y3
	JPOS	D6STORE
	JZERO	D6STORE
	CALL 	NEGATE
	JUMP	D6STORE

D6STORE:
	ADD	DIFFX
	STORE	DIST23	
	

;--------- Calculating the total distances
	LOAD 	DIST01
	ADD		DIST12
	ADD		DIST23
	STORE 	DP1		;DP1
	LOAD	DIST01	
	ADD		DIST13
	ADD		DIST23
	STORE	DP2		;DP2
	LOAD	DIST02	
	ADD		DIST12
	ADD		DIST13
	STORE	DP3		;DP3	
	LOAD	DIST02	
	ADD		DIST23
	ADD		DIST13
	STORE	DP4		; DP4
	LOAD	DIST03	
	ADD		DIST13
	ADD		DIST12
	STORE	DP5		; DP5
	LOAD	DIST03	
	ADD		DIST23
	ADD		DIST12
	STORE	DP6		; DP6
	
;; --------- DETERMINE SHORTEST PATH
	LOAD 	DP1
	SUB		DP2
	JPOS	SELDP2
	LOAD	DP1
	SUB		DP3
	JPOS	MINDP3
	LOADI	1
	STORE	DPX
	JUMP	SECCMP
	
SELDP2:
	LOAD 	DP2
	SUB		DP3
	JPOS	MINDP3
	LOADI	2
	STORE	DPX	
	JUMP	SECCMP
	
	
MINDP3:
	LOADI	3
	STORE	DPX

SECCMP:
	LOAD 	DP4
	SUB		DP5
	JPOS	SELDP5
	LOAD	DP4
	SUB		DP5
	JPOS	MINDP6
	LOADI	4
	STORE	DPY
	JUMP	TRDCMP
	
SELDP5:
	LOAD 	DP5
	SUB		DP6
	JPOS	MINDP6
	LOADI	5
	STORE	DPY	
	JUMP	TRDCMP
	
	
MINDP6:
	LOADI	6
	STORE	DPY

TRDCMP:
	LOAD	DPX
	CALL	GETDP
	STORE	DPXV
	LOAD	DPY
	CALL	GETDP
	STORE	DPYV
	SUB		DPXV	; LAST CMP
	JNEG	SELY
	LOAD	DPX
	STORE	PATH
	JUMP	ENDCMP
	
SELY:
	LOAD	DPY
	STORE 	PATH
	
ENDCMP:
;------------------------------ NOW THE PATH IS SELECTED, 

GETTO:			; GET TO THE THREE POINTS ACCORDING TO THE PATH SELECTED. 		
	LOAD 	PATH
	SUB		ONE
	JPOS	PATHNOT1
	; OTHERWOSE IS 1
	CALL	POINT11
	CALL 	POINT22
	CALL	POINT33
	JUMP	ENDPATH
	
PATHNOT1:
	SUB		ONE
	JPOS	PATHNOT2
	CALL	POINT11
	CALL	POINT23
	CALL	POINT32
	JUMP	ENDPATH
	
PATHNOT2:
	SUB		ONE
	JPOS	PATHNOT3
	CALL	POINT12
	CALL	POINT21
	CALL	POINT33
	JUMP	ENDPATH

PATHNOT3:
	SUB		ONE
	JPOS	PATHNOT4
	CALL	POINT12
	CALL	POINT13
	CALL	POINT31
	JUMP	ENDPATH

PATHNOT4:
	SUB		ONE
	JPOS	PATHNOT5
	CALL	POINT13
	CALL	POINT21
	CALL	POINT32
	JUMP	ENDPATH
	
PATHNOT5:
	CALL	POINT13
	CALL	POINT22
	CALL	POINT31
	JUMP	ENDPATH

ENDPATH:	
	LOAD	X0
	STORE	STARTX
	LOAD	Y0
	STORE	STARTY
	LOAD	R0
	STORE	STARTR
	
TOPOINT1:
	LOAD	GOX1
	STORE	TOX
	LOAD	GOY1
	STORE	TOY
	LOAD	GOR1
	STORE	TOR

	CALL	PTOP
	
	
TOPOINT2:
	LOAD	GOX1
	STORE	STARTX
	LOAD	GOY1
	STORE	STARTY
	LOAD	GOR1
	STORE	STARTR
	
	LOAD	GOX2
	STORE	TOX
	LOAD	GOY2
	STORE	TOY
	LOAD	GOR2
	STORE	TOR
	
	CALL	PTOP
	
	; TEST
	LOAD 	STEPX
	OUT 	SSEG1
	LOAD	STEPY
	OUT 	SSEG2
	LOAD 	DIR
	OUT 	LCD
	; test
	
TOPOINT3:
	LOAD	GOX2
	STORE	STARTX
	LOAD	GOY2
	STORE	STARTY
	LOAD	GOR2
	STORE	STARTR
	
	LOAD	GOX3
	STORE	TOX
	LOAD	GOY3
	STORE	TOY
	LOAD	GOR3
	STORE	TOR

	CALL	PTOP
	
	


	
	
; dist 02
; dist 03



JUMP	Main

Die:
; Sometimes it's useful to permanently stop execution.
; This will also catch the execution if it accidentally
; falls through from above.
	LOAD   Zero         ; Stop everything.
	OUT    LVELCMD
	OUT    RVELCMD
	OUT    SONAREN
	LOAD   DEAD         ; An indication that we are dead
	OUT    SSEG2
Forever:
	JUMP   Forever      ; Do this forever.
DEAD: DW &HDEAD

	
;***************************************************************
;* Subroutines
;***************************************************************

; pseudo subroutine holding place for Stephen's code
STEPHEN:
	RETURN

; PATH TO PATH. FROM START TO TO. 
; OUT: STEPX, STEPY, DIR: 0 first X then Y, 1 first Y then X
PTOP:
	LOAD	STARTR
	SUB		ONE
	JPOS	STARTNOTR1
	LOADI	0	; start in r1
	STORE	DIR
	LOAD 	TOR
	SUB 	THREE
	JZERO	ENDR3	
	; NOT ENDING IN R3
	CALL	CALDIFF
	CALL	STEPHEN
	JUMP	ENDPTOP
ENDR3:
	CALL 	SINTEMP
	CALL	CALDIFF
	CALL	STEPHEN
	LOADI	1
	STORE	DIR
	CALL	RETRIEVE
	CALL	CALDIFF
	CALL	STEPHEN
	JUMP	ENDPTOP
	
	
STARTNOTR1:		; start in r2
	SUB		ONE
	JPOS	STARTNOTR2
	LOADI 	1
	STORE	DIR
	CALL	CALDIFF
	CALL	STEPHEN
	JUMP	ENDPTOP
	
	
STARTNOTR2:		; start in r3
	LOADI	0
	STORE	DIR
	LOAD	TOR
	SUB		ONE
	JZERO	ENDR1
	CALL	CALDIFF
	CALL	STEPHEN
	JUMP	ENDPTOP
ENDR1:
	CALL 	SINTEMP
	CALL	CALDIFF
	CALL	STEPHEN
	LOADI	1
	STORE	DIR
	CALL	RETRIEVE
	CALL	CALDIFF
	CALL	STEPHEN
	JUMP	ENDPTOP

	
ENDPTOP:
	RETURN

CALDIFF:	; HELPER OF ABOVE, CALCULATE DIFFERENCES IN X AND Y
	LOAD	TOX
	SUB		STARTX
	STORE	STEPX
	LOAD	TOY
	SUB		STARTY
	STORE 	STEPY
	RETURN
	
SINTEMP:	; STORE THE TO POINTS IN TEMP
			; SET TO POINTS TO BE 2
	LOAD	TOX
	STORE	TEMPX
	LOAD	TOY
	STORE	TEMPY
	LOADI	2
	STORE	TOX
	STORE	TOY
	RETURN
	
RETRIEVE:	; BEGIN FROM MID GOTO TO 
	LOADI	2
	STORE	STARTX
	STORE	STARTY
	LOAD	TEMPX
	STORE	TOX
	LOAD	TEMPY
	STORE	TOY
	RETURN
	
; Subroutine to negate AC value
NEGATE:		; NEGATE AC
	STORE 	ACCUM
	LOADI	0
	SUB		ACCUM
	RETURN
	
;; GET THE VALUE OF DP BASED ON INDEX IN ACCUM.
GETDP:		
	STORE	ACCUM
	LOAD 	ACCUM
	SUB		ONE
	JPOS	DPNOT1
	; OTHERWOSE IS 1
	LOAD	DP1
	JUMP	ENDDP
	
DPNOT1:
	SUB		ONE
	JPOS	DPNOT2
	LOAD	DP2
	JUMP	ENDDP
	
DPNOT2:
	SUB		ONE
	JPOS	DPNOT3
	LOAD	DP3
	JUMP	ENDDP

DPNOT3:
	SUB		ONE
	JPOS	DPNOT4
	LOAD	DP4
	JUMP	ENDDP

DPNOT4:
	SUB		ONE
	JPOS	DPNOT5
	LOAD	DP5
	JUMP	ENDDP
	
DPNOT5:
	LOAD	DP6
	JUMP	ENDDP

ENDDP:	
	STORE 	DPSEL
	RETURN

POINT11:		; POINT ONE IS X1
	LOAD	X1
	STORE	GOX1
	LOAD	Y1
	STORE	GOY1
	LOAD	R1
	STORE	GOR1
	RETURN

POINT12:		; POINT ONE IS X2
	LOAD	X2
	STORE	GOX1
	LOAD	Y2
	STORE	GOY1
	LOAD	R2
	STORE	GOR1
	RETURN

POINT13:		; POINT ONE IS X3
	LOAD	X3
	STORE	GOX1
	LOAD	Y3
	STORE	GOY1
	LOAD	R3
	STORE	GOR1
	RETURN
	
POINT21:		; POINT TWO IS X1
	LOAD	X1
	STORE	GOX2
	LOAD	Y1
	STORE	GOY2
	LOAD	R1
	STORE	GOR2
	RETURN

POINT22:		; POINT TWO IS X2
	LOAD	X2
	STORE	GOX2
	LOAD	Y2
	STORE	GOY2
	LOAD	R2
	STORE	GOR2
	RETURN
	
POINT23:		; POINT TWO IS X3
	LOAD	X3
	STORE	GOX2
	LOAD	Y3
	STORE	GOY2
	LOAD	R3
	STORE	GOR2
	RETURN
	
POINT31:		; POINT THREE IS X1
	LOAD	X1
	STORE	GOX3
	LOAD	Y1
	STORE	GOY3
	LOAD	R1
	STORE	GOR3
	RETURN
	
POINT32:		; POINT THREE IS X2
	LOAD	X2
	STORE	GOX3
	LOAD	Y2
	STORE	GOY3
	LOAD	R2
	STORE	GOR3
	RETURN
	
POINT33:		; POINT THREE IS X2
	LOAD	X3
	STORE	GOX3
	LOAD	Y3
	STORE	GOY3
	LOAD	R3
	STORE	GOR3
	RETURN
	
; Subroutine to wait (block) for 1 second
Wait1:
	OUT    TIMER
Wloop:
	IN     TIMER
	OUT    XLEDS       ; User-feedback that a pause is occurring.
	ADDI   -10         ; 1 second in 10Hz.
	JNEG   Wloop
	RETURN

; Subroutine to wait the number of counts currently in AC
WaitAC:
	STORE  WaitTime
	OUT    Timer
WACLoop:
	IN     Timer
	OUT    XLEDS       ; User-feedback that a pause is occurring.
	SUB    WaitTime
	JNEG   WACLoop
	RETURN
	WaitTime: DW 0     ; "local" variable.
	
; This subroutine will get the battery voltage,
; and stop program execution if it is too low.
; SetupI2C must be executed prior to this.
BattCheck:
	CALL   GetBattLvl
	JZERO  BattCheck   ; A/D hasn't had time to initialize
	SUB    MinBatt
	JNEG   DeadBatt
	ADD    MinBatt     ; get original value back
	RETURN
; If the battery is too low, we want to make
; sure that the user realizes it...
DeadBatt:
	LOAD   Four
	OUT    BEEP        ; start beep sound
	CALL   GetBattLvl  ; get the battery level
	OUT    SSEG1       ; display it everywhere
	OUT    SSEG2
	OUT    LCD
	LOAD   Zero
	ADDI   -1          ; 0xFFFF
	OUT    LEDS        ; all LEDs on
	OUT    XLEDS
	CALL   Wait1       ; 1 second
	Load   Zero
	OUT    BEEP        ; stop beeping
	LOAD   Zero
	OUT    LEDS        ; LEDs off
	OUT    XLEDS
	CALL   Wait1       ; 1 second
	JUMP   DeadBatt    ; repeat forever
	
; Subroutine to read the A/D (battery voltage)
; Assumes that SetupI2C has been run
GetBattLvl:
	LOAD   I2CRCmd     ; 0x0190 (write 0B, read 1B, addr 0x90)
	OUT    I2C_CMD     ; to I2C_CMD
	OUT    I2C_RDY     ; start the communication
	CALL   BlockI2C    ; wait for it to finish
	IN     I2C_DATA    ; get the returned data
	RETURN

; Subroutine to configure the I2C for reading batt voltage
; Only needs to be done once after each reset.
SetupI2C:
	CALL   BlockI2C    ; wait for idle
	LOAD   I2CWCmd     ; 0x1190 (write 1B, read 1B, addr 0x90)
	OUT    I2C_CMD     ; to I2C_CMD register
	LOAD   Zero        ; 0x0000 (A/D port 0, no increment)
	OUT    I2C_DATA    ; to I2C_DATA register
	OUT    I2C_RDY     ; start the communication
	CALL   BlockI2C    ; wait for it to finish
	RETURN
	
; Subroutine to block until I2C device is idle
BlockI2C:
	LOAD   Zero
	STORE  Temp        ; Used to check for timeout
BI2CL:
	LOAD   Temp
	ADDI   1           ; this will result in ~0.1s timeout
	STORE  Temp
	JZERO  I2CError    ; Timeout occurred; error
	IN     I2C_RDY     ; Read busy signal
	JPOS   BI2CL       ; If not 0, try again
	RETURN             ; Else return
I2CError:
	LOAD   Zero
	ADDI   &H12C       ; "I2C"
	OUT    SSEG1
	OUT    SSEG2       ; display error message
	JUMP   I2CError

; Subroutine to send AC value through the UART,
; formatted for default base station code:
; [ AC(15..8) | AC(7..0) | \lf ]
; Note that special characters such as \lf are
; escaped with the value 0x1B, thus the literal
; value 0x1B must be sent as 0x1B1B, should it occur.
UARTSend:
	STORE  UARTTemp
	SHIFT  -8
	ADDI   -27   ; escape character
	JZERO  UEsc1
	ADDI   27
	OUT    UART_DAT
	JUMP   USend2
UEsc1:
	ADDI   27
	OUT    UART_DAT
	OUT    UART_DAT
USend2:
	LOAD   UARTTemp
	AND    LowByte
	ADDI   -27   ; escape character
	JZERO  UEsc2
	ADDI   27
	OUT    UART_DAT
	RETURN
UEsc2:
	ADDI   27
	OUT    UART_DAT
	OUT    UART_DAT
	RETURN
	UARTTemp: DW 0

UARTNL:
	LOAD   NL
	OUT    UART_DAT
	SHIFT  -8
	OUT    UART_DAT
	RETURN
	NL: DW &H0A1B

;***************************************************************
;* Variables
;***************************************************************
Temp:     DW 0 ; "Temp" is not a great name, but can be useful
; INPUTS
X0:     DW      &H0001	; addr H010, VALUE 0
Y0:     DW      &H0001
D0:     DW		&H0000
R0:		DW		&H0001

X1:     DW      &H0003
Y1:		DW 		&H0002	
R1:		DW		&H0002

GOX1:	DW		&H0000
GOY1:	DW		&H0000
GOR1:	DW		&H0000

X2:     DW      &H0003
Y2:     DW      &H0003
R2:		DW		&H0000

GOX2:	DW		&H0000
GOY2:	DW		&H0000
GOR2:	DW		&H0000

X3:     DW      &H0003
Y3:     DW      &H0004
R3:		DW		&H0000

GOX3:	DW		&H0000
GOY3:	DW		&H0000
GOR3:	DW		&H0000

STARTX: DW		&H0000
STARTY: DW		&H0000
STARTR: DW		&H0000

TOX: 	DW		&H0000
TOY: 	DW		&H0000
TOR: 	DW		&H0000

TEMPX:	DW		&H0000
TEMPY:	DW		&H0000
; TEMPR:	DW 		&H0000

STEPX: 	DW		&H0000
STEPY: 	DW		&H0000
DIR:	DW		&H0000

;****** the six distances between the possible pairs of points ***
ACCUM:	DW 	0
DIFFX:	DW	0

DIST01: DW	0
DIST02:	DW	0
DIST03:	DW	0
DIST12:	DW 	0
DIST13:	DW 	0
DIST23:	DW	0

DP1:	DW	0
DP2:	DW	0
DP3:	DW	0
DP4:	DW	0
DP5:	DW	0
DP6:	DW	0
DPSEL:	DW	0		; what GETDP returns at a given index in accum
DPX:	DW  0		; temp index of min among three
DPXV:	DW	0
DPY: 	DW  0		; temp index of min among three
DPYV:	DW	0
PATH:	DW	0		; an index; 1 through 6

GOX:	DW	0
GOY:	DW	0



;***************************************************************
;* Constants
;* (though there is nothing stopping you from writing to these)
;***************************************************************
NegOne:   DW -1
Zero:     DW 0
One:      DW 1
Two:      DW 2
Three:    DW 3
Four:     DW 4
Five:     DW 5
Six:      DW 6
Seven:    DW 7
Eight:    DW 8
Nine:     DW 9
Ten:      DW 10

; Some bit masks.
; Masks of multiple bits can be constructed by ORing these
; 1-bit masks together.
Mask0:    DW &B00000001
Mask1:    DW &B00000010
Mask2:    DW &B00000100
Mask3:    DW &B00001000
Mask4:    DW &B00010000
Mask5:    DW &B00100000
Mask6:    DW &B01000000
Mask7:    DW &B10000000
LowByte:  DW &HFF      ; binary 00000000 1111111
LowNibl:  DW &HF       ; 0000 0000 0000 1111

; some useful movement values
OneMeter: DW 961       ; ~1m in 1.05mm units
HalfMeter: DW 481      ; ~0.5m in 1.05mm units
TwoFeet:  DW 586       ; ~2ft in 1.05mm units
Deg90:    DW 90        ; 90 degrees in odometry units
Deg180:   DW 180       ; 180
Deg270:   DW 270       ; 270
Deg360:   DW 360       ; can never actually happen; for math only
FSlow:    DW 100       ; 100 is about the lowest velocity value that will move
RSlow:    DW -100
FMid:     DW 350       ; 350 is a medium speed
RMid:     DW -350
FFast:    DW 500       ; 500 is almost max speed (511 is max)
RFast:    DW -500

MinBatt:  DW 130       ; 13.0V - minimum safe battery voltage
I2CWCmd:  DW &H1190    ; write one i2c byte, read one byte, addr 0x90
I2CRCmd:  DW &H0190    ; write nothing, read one byte, addr 0x90

;***************************************************************
;* IO address space map
;***************************************************************
SWITCHES: EQU &H00  ; slide switches
LEDS:     EQU &H01  ; red LEDs
TIMER:    EQU &H02  ; timer, usually running at 10 Hz
XIO:      EQU &H03  ; pushbuttons and some misc. inputs
SSEG1:    EQU &H04  ; seven-segment display (4-digits only)
SSEG2:    EQU &H05  ; seven-segment display (4-digits only)
LCD:      EQU &H06  ; primitive 4-digit LCD display
XLEDS:    EQU &H07  ; Green LEDs (and Red LED16+17)
BEEP:     EQU &H0A  ; Control the beep
CTIMER:   EQU &H0C  ; Configurable timer for interrupts
LPOS:     EQU &H80  ; left wheel encoder position (read only)
LVEL:     EQU &H82  ; current left wheel velocity (read only)
LVELCMD:  EQU &H83  ; left wheel velocity command (write only)
RPOS:     EQU &H88  ; same values for right wheel...
RVEL:     EQU &H8A  ; ...
RVELCMD:  EQU &H8B  ; ...
I2C_CMD:  EQU &H90  ; I2C module's CMD register,
I2C_DATA: EQU &H91  ; ... DATA register,
I2C_RDY:  EQU &H92  ; ... and BUSY register
UART_DAT: EQU &H98  ; UART data
UART_RDY: EQU &H98  ; UART status
SONAR:    EQU &HA0  ; base address for more than 16 registers....
DIST0:    EQU &HA8  ; the eight sonar distance readings
DIST1:    EQU &HA9  ; ...
DIST2:    EQU &HAA  ; ...
DIST3:    EQU &HAB  ; ...
DIST4:    EQU &HAC  ; ...
DIST5:    EQU &HAD  ; ...
DIST6:    EQU &HAE  ; ...
DIST7:    EQU &HAF  ; ...
SONALARM: EQU &HB0  ; Write alarm distance; read alarm register
SONARINT: EQU &HB1  ; Write mask for sonar interrupts
SONAREN:  EQU &HB2  ; register to control which sonars are enabled
XPOS:     EQU &HC0  ; Current X-position (read only)
YPOS:     EQU &HC1  ; Y-position
THETA:    EQU &HC2  ; Current rotational position of robot (0-359)
RESETPOS: EQU &HC3  ; write anything here to reset odometry to 0
