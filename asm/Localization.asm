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
	LOAD   Zero        ; previous thing 
	
	OUT    LVELCMD     ; Stop motors
	OUT    RVELCMD
	;Init:
	;JUMP Init  ; infintely loop to init 
	
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
	OUT    RESETPOS    ; reset odometry in case wheels moved after programming	
;---------  PRELAB -------------------------------------
; DERP: 
; 	LOAD   FMid
; 	OUT    LVELCMD     ; Stop motors
; 	OUT    RVELCMD
; 	
; 	IN XPOS
; 	SUB FourFeet
; 	
; 	
; 	JNEG DERP  ; keep going if hasnt gone to 4ft
; 	
; 	
; ; 	; MAKE IT STOP
; ; 	LOAD   Zero
; ; 	OUT    LVELCMD     ; Stop motors
; ; 	OUT    RVELCMD
; 	
; 	
; 	Rotate:
; 	LOAD FSlow ;check current angle, turn  it 90 degrees
; 	OUT   RVELCMD
; 	LOAD  RSlow 
; 	OUT   LVELCMD
; 	
; 	;LOAD Deg90   ; load the theta we want to test
; 	IN THETA
; 	SUB  Deg90
; 	
; 	JNEG Rotate
; 	--------------------------------------
; ------------------- BEGINNING OF LOCALIZATION CODE --------------------------------------------------------------------------------------------
	;----------------------------------------------------
	LOADI &B100001
    OUT SONAREN ; turn on sonars 0 and 5
    ; -------------get N1 from SENSOR 0
    
    CALL Wait1  
    
	IN DIST0  ; take in distance from 0th
	OUT SSEG1  ; 
    STORE TEMPDIST0
 
    IN DIST5  ; take in distance from 5th
	OUT SSEG2  ; 
    STORE TEMPDIST5
    
    
    CALL Wait1
    
;     
;     
    ; SIGNATURE
    LOADI 0
    STORE RESULT
  ;-----------------------------------  
    LOAD TEMPDIST0
    DivLoop:
       SUB DIVBY
       STORE TEMPDIST0
       
       JNEG StoreSig
       
       
       LOAD RESULT
       ADDI 1
       STORE RESULT
       
       LOAD TEMPDIST0
       JUMP DivLoop

    StoreSig:
        LOAD RESULT
        STORE N3
    ;------------------------------
   	LOADI 0
   	STORE RESULT
    LOAD TEMPDIST5
    DivLoop1:
       SUB DIVBY
       STORE TEMPDIST5
       
       JNEG StoreSig1

       LOAD RESULT
       ADDI 1
       STORE RESULT
       
       LOAD TEMPDIST5
       JUMP DivLoop1

    StoreSig1:
        LOAD RESULT
        STORE N1
        ;----------------
        
    LOAD N3
    OUT SSEG1
    LOAD N1
    OUT SSEG2
    
    
    CALL Wait1
    
    CALL Wait1
    
 

;------------------ ROTATE ---------------------------------------- 
   LOADI 0
    OUT RESETPOS   
    Rotate:
		LOAD  FSlow 
		OUT   RVELCMD 
		LOAD  RSlow 
		OUT   LVELCMD
		IN THETA
		SUB  DegCust
		JNEG Rotate

		
	LOAD  0 
	OUT   RVELCMD 
	LOAD  0 
	OUT   LVELCMD

;----GET SECOND PAIR OF VALS--------------------------------------------

   CALL Wait1
  
 	IN DIST0  ; take in distance from 0th
	OUT SSEG1  ; 
    STORE TEMPDIST0
 
    IN DIST5  ; take in distance from 5th
	OUT SSEG2  ; 
    STORE TEMPDIST5

    CALL Wait1
    
    LOADI 0
    STORE RESULT
  ;-----------------------------------  
    LOAD TEMPDIST0
    DivLoop2:
       SUB DIVBY
       STORE TEMPDIST0
       
       JNEG StoreSig2
       
       
       LOAD RESULT
       ADDI 1
       STORE RESULT
       
       LOAD TEMPDIST0
       JUMP DivLoop2

    StoreSig2:
        LOAD RESULT
        STORE N2
   ;---------------
   	LOADI 0
   	STORE RESULT
    LOAD TEMPDIST5
    DivLoop3:
       SUB DIVBY
       STORE TEMPDIST5
       
       JNEG StoreSig3

       LOAD RESULT
       ADDI 1
       STORE RESULT
       
       LOAD TEMPDIST5
       JUMP DivLoop3

    StoreSig3:
        LOAD RESULT
        STORE N4
        ;----------------
   
    LOAD N2
    OUT SSEG1
    LOAD N4
    OUT SSEG2

    CALL Wait1
    
    CALL Wait1
   
    
    
    LOADI 0
    OUT SSEG1
    LOADI 0
    OUT SSEG2

    CALL Wait1
    CALL Wait1

    
    ; LOAD N1
SHIFT 4
OR N2
SHIFT 4
OR N3 
SHIFT 4
OR N4


STORE N1234  
    
    LOAD N1234
    OUT SSEG1
    
    
    
    
    
    
    
; ;---------------------------------------------------------------------------------
; ;
; ; MAKE THE ALIASES FOR THE VALUES
; 
; ;MAKE M VALS (VALUES IF WE ROTATED BY 90 DEG TO THE RIGHT)
; LOAD N4
; STORE M1
; LOAD N1
; STORE M2
; LOAD N2
; STORE M3
; LOAD N3
; STORE M4
; 
; ;MAKE P VALS (VALUES IF WE ROTATED BY 180 DEG TO THE RIGHT)
; LOAD N3
; STORE P1
; LOAD N4
; STORE P2
; LOAD N1
; STORE P3
; LOAD N2
; STORE P4
; 
; ;MAKE Q VALS (VALUES IF WE ROTATED BY ANOTHER 270 DEG TO THE RIGHT)
; LOAD N2
; STORE Q1
; LOAD N3
; STORE Q2
; LOAD N4
; STORE Q3
; LOAD N1
; STORE Q4
; 
; ; 
; ; STORE THESE INDIVIDUAL INTO WORDS, THIS WAY THEY CAN BE XOR WITH OUR SIGNATURES (ESSENTIALLY, COMPARED)
; ; STORE N1, N2, N3, N4 INTO A WORD
; LOAD N1
; SHIFT 4
; OR N2
; SHIFT 4
; OR N3 
; SHIFT 4
; OR N4
; SHIFT 4
; 
; STORE N1234  
; 
; ; STORE M1, M2, M3, M4 INTO A WORD
; LOAD M1
; SHIFT 4
; OR M2
; SHIFT 4
; OR M3 
; SHIFT 4
; OR M4
; SHIFT 4
; 
; STORE M1234  
; 
; ; STORE P1, P2, P3, P4 INTO A WORD
; LOAD P1
; SHIFT 4
; OR P2
; SHIFT 4
; OR P3 
; SHIFT 4
; OR P4
; SHIFT 4
; 
; STORE P1234  
; 
; ; STORE Q1, Q2, Q3, Q4
; LOAD Q1
; SHIFT 4
; OR Q2
; SHIFT 4
; OR Q3 
; SHIFT 4
; OR Q4
; SHIFT 4
; 
; STORE Q1234  
; 
; ; 
; 
; ;-------------------------------
; LOAD N1234
; OUT SSEG1
; 
; 
; 
;           LOADI 0
;           OUT SSEG2
; ; 
; ; LOAD M1234
; ; OUT SSEG2
; ; 
; ; CALL Wait1
; ; CALL Wait1
; ; CALL Wait1
; ; 
; ; LOAD P1234
; ; OUT SSEG1
; ; 
; ; LOAD Q1234
; ; OUT SSEG2
; 
; CALL Wait1
; CALL Wait1
; CALL Wait1
; CALL Wait1
; CALL Wait1
; CALL Wait1
; 
 ;;-------------------------------

; ; 
; ; ; NOW COMPARE TO THE SIGNATURES WE HAVE, USING XOR
; ; 
; ;----compare to 1,1-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG11
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG11
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG11
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG11
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 1,2-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG12
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG12
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG12
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG12
; 	JZERO FoundSig
; ;------------------------------------------
;   ;----compare to 1,3-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG13
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG13
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG13
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG13
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 1,4-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG14
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG14
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG14
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG14
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 2,1-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG21
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG21
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG21
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG21
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 2,2-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG22
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG22
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG22
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG22
; 	JZERO FoundSig
; ;------------------------------------------
; 	;----compare to 2,3-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG23
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG23
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG23
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG23
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 2,4-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG24
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG24
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG24
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG24
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 3,1-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG31
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG31
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG31
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG31
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 3,2-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG32
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG32
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG32
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG32
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 3,3-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG33
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG33
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG33
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG33
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 3,4-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG34
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG34
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG34
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG34
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 4,1-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG41
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG41
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG41
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG41
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 4,2-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG42
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG42
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG42
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG42
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 4,3-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG43
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG43
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG43
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG43
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 4,4-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG44
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG44
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG44
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG44
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 5,3-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG53
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG53
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG53
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG53
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 5,4-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG54
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG54
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG54
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG54
; 	JZERO FoundSig
; ;------------------------------------------
; ;----compare to 6,4-------------------------
; 	LOAD N1234
; 	STORE TEMPSIG
; 	XOR SIG64
; 	JZERO FoundSig
; 	
; 	LOAD M1234
; 	STORE TEMPSIG
; 	XOR SIG64
; 	JZERO FoundSig
; 	
; 	LOAD P1234
; 	STORE TEMPSIG
; 	XOR SIG64
; 	JZERO FoundSig
; 	
; 	LOAD Q1234
; 	STORE TEMPSIG
; 	XOR SIG64
; 	JZERO FoundSig
; ;------------------------------------------
; 
; 
; 	
;  	FoundSig:
;  	LOAD TEMPSIG
;  	OUT SSEG1  ;  output to seven seg display numer 1



	
    
    
    


    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
  



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
FourFeet:  DW 1172       ; ~4ft in 1.05mm units
Deg90:    DW 90       ; 90 degrees in odometry units
DegCust:    DW 77       ; 90 degrees in odometry units
Deg180:   DW 180       ; 180
Deg270:   DW 270       ; 270
Deg360:   DW 360       ; can never actually happen; for math only
FSlow:    DW 150      ; 100 is about the lowest velocity value that will move
RSlow:    DW -150
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









;-----------------------------------------------------------
	
	
	;declare signatures for all locations in HEX, these can be accessed later for comparison to the input 
	DERP:    DW 0
	DIVBY:    DW 552
	 ;this is the value we're "dividing" by. 610mm
	RESULT:   DW 0
	ONESEC:   DW 10
	TEMPSIG:  DW &H0000
	TEMPDIST0: DW 0
	TEMPDIST5: DW 0
; vals for word
	N1:       DW 0
	N2:       DW 0
	N3:       DW 0
	N4:       DW 0
	
	N1234:    DW &H0000 
	
;word rotate 90 to the right
	M1:       DW 0
	M2:       DW 0
	M3:       DW 0
	M4:       DW 0
	
	M1234:    DW &H0000 
	
	
;word rotate  180 to the right
	P1:       DW 0
	P2:       DW 0
	P3:       DW 0
	P4:       DW 0
	
	P1234:    DW &H0000 
	
;word rotate another 270 to the right
	Q1:       DW 0
	Q2:       DW 0
	Q3:       DW 0
	Q4:       DW 0
	
	Q1234:    DW &H0000 

	
    
	
	
    SIG11:    DW &H3300
    SIG12:    DW &H2310
    SIG13:    DW &H1420
    SIG14:    DW &H0530
    SIG21:    DW &H3201
    SIG22:    DW &H2211
    SIG23:    DW &H1321
    SIG24:    DW &H0431
    SIG31:    DW &H1102
    SIG32:    DW &H0112
    SIG33:    DW &H1202
    SIG34:    DW &H0312
    SIG41:    DW &H1003
    SIG42:    DW &H0013
    SIG43:    DW &H1103
    SIG44:    DW &H0213
    SIG53:    DW &H1004
    SIG54:    DW &H0114
    SIG64:    DW &H0005
    
	;--------------------------------------------------------------------------   