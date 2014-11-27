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
	OUT    RESETPOS    ; reset odometry in case wheels moved after programming	

;;--- void Nav(int stepX, int stepY) -------------------------------------------
;; Make the robot travel by a specified x and y value, which may be negative.
;;
;; stepX - The distance to travel in the X direction.
;; stepY - The distance to travel in the Y direction.
;;------------------------------------------------------------------------------
STEPX: DW -4
STEPY: DW -3
ORIENT: DW 0
X: DW 5			;;starting points
Y: DW 4				
XINIT: DW 0
YINIT: DW 0
XORYFIRST: DW 0
XFD: DW 0		;;x for findD equation. final point of path
YFD: DW 0		;;y for findD equation. Final Point of path










NAV:
    OUT    RESETPOS

	
	
;;UPDATE X AND Y POSITIONS
	LOAD X
	STORE XINIT
	ADD STEPX
	STORE X
	
	LOAD Y
	STORE YINIT
	ADD STEPY
	STORE Y


;;sort out order and variables to use

	LOAD XORYFIRST
	JZERO callxfirst
;; we go y first then x first so these are the variables we need for findD

	LOAD XINIT  ;;x initialis the final x
	STORE XFD
	
	
	LOAD Y		;; y final is the final y
	STORE YFD
	
	
	CALL NAVY
	
	LOAD X			;; now x final is the final x
	STORE XFD
	
	CALL NAVX

	jump DIE
	
callxfirst: 

	LOAD X			;; now x final is the final x
	STORE XFD
	
	LOAD YINIT
	STORE YFD
	CALL NAVX
	
	LOAD Y
	STORE YFD
	
	CALL NAVY
	
	JUMP DIE
	RETURN
    
	;Travel X
    ;WHICH WAY TO ORIENT TO TRAVEL X?

NAVX:   LOAD   STEPX
	
    JNEG   PTOTWO
    JPOS   PTOZERO



ContNavX:

    CALL   SETORIENTTOP
    
	LOAD STEPX
    STORE TILESTOCOUNTS
    
	CALL TTC
    STORE STEPX

    
    LOAD   STEPX;
    STORE  Q;
    call wait1
    call wait1
    CALL   TRAVELDISTANCEQ ;go in x direction

	
	;;hehehe: jump hehehe
    ;Travel y
    ;WHICH WAY TO ORIENT TO TRAVEL Y?

	RETURN


	
NAVY:   LOAD   STEPY		;;loading in STEPY in TILES TO TRAVEL
;	LOADI  4	

;h:	jump h

    JNEG   PTOTHREE		;;set desired orientation
    JPOS   PTOONE
    

	

ContNavY:

	
	
    CALL SETORIENTTOP		;; set orientation to the desired orientation via rotating cw

        
    LOADI 9
    
    
;    ILOAD	&B00111


	LOAD STEPY
	STORE TILESTOCOUNTS
    CALL TTC

	STORE STEPY
    
    LOAD   STEPY
	;OUT SSEG2
    STORE  Q
	;OUT SSEG2

	Call wait1
	Call wait1
    CALL   TRAVELDISTANCEQ
	


    RETURN

;; Set the desired orientation to 2, and negate the x distance.
PTOTWO:
    LOAD   TWO
    STORE  P
    LOAD   ZERO
    SUB    STEPX
    STORE  STEPX
    JUMP   ContNavX

;; Set the desired orientation to 0.
PTOZERO:
    LOAD   ZERO
    STORE  P
    JUMP   ContNavX

;; Set the desired orientation to 3, and negate the y distance.
PTOTHREE:
    LOAD   THREE
    STORE  P
    LOAD   ZERO
    SUB    STEPY
    STORE  STEPY
    JUMP   ContNavY

;; Set the desired orientation to 1.
PTOONE:
    LOAD   ONE
    STORE  P
    JUMP   ContNavY

; The following subroutines will rotate the robot so that it is oriented in the
; right way according to specifications from NAV commented out.

;;--- void SetOrientToP() ------------------------------------------------------
;; Rotate clockwise until the orientation matches the desired orientation (P).
;;------------------------------------------------------------------------------
SETORIENTTOP:
    LOAD   ORIENT		;;keep rotating until orientation is correct/
	
    SUB    P
  
    
    JZERO  DONE
    CALL WAIT1
    CALL WAIT1
    CALL WAIT1
    CALL   ROTATE90CCW               ;should prolly optimize to rotate the faster way.
    JUMP   SETORIENTTOP
DONE:
    RETURN

;;--- void Rotate90CW() --------------------------------------------------------
;; Rotate the robot 90 degrees clock-wise, adjusting the orientation variable.
;;------------------------------------------------------------------------------

sf: DW 11			;; variable for when to shut motors off

ROTATE90CCW:					;;REALLY CCW
	OUT		RESETPOS		;;need theta to be 0 before we start rotating
 	
controtatingccw:    

	LOADI   150
    OUT     RVELCMD
    LOADI    -150
    OUT     LVELCMD

    
    IN      THETA
	
    sub deg90
    add     sf


    
    JNEG    ContRotatingCCW
	
;; new code to slowly desencd to stop	

	


    
;;were done rotating stop the motors
    

    LOAD 	ZERO
	OUT LVELCMD
	OUT RVELCMD


    ;UPDATE CHANGED ORIENT VALUE

    LOAD    ORIENT		;;current orient value gets subtracted by one
    ADD     ONE    
    STORE ORIENT

    SUB FOUR
    JZERO    SETORIENTTOONE ;; IF ITS 4 MAKE IT ZERO
    
    RETURN

SETORIENTTOONE:
    LOAD   ONE
    STORE  ORIENT
    RETURN
    
    
TTC:
    LOAD TILESTOCOUNTS

	JZERO END
    
    SUB ONE

    JZERO SET1
    
    SUB ONE
    JZERO SET2
    
    SUB ONE
    JZERO SET3
    
    SUB ONE
    JZERO SET4
    
    SUB ONE
    JZERO SET5
    
SET1:  
    LOAD ONET

    STORE TILESTOCOUNTS
	jump END
	
SET2:  
    LOAD TWOT
    STORE TILESTOCOUNTS
	jump end
	
SET3:  
    LOAD THREET
    STORE TILESTOCOUNTS
	jump end
	
SET4:  
    LOAD FOURT
    STORE TILESTOCOUNTS
	jump end
	
SET5:
    LOAD FIVET
    STORE TILESTOCOUNTS

END: RETURN    
    


;Code to travel a given distance. Only input required is Q which should be the robot count units of the distance you want to travel.

;;--- void TravelDistanceQ() ---------------------------------------------------
;; Move forward Q Count Units. 
;; takes in side sensor readings and navigates one way or another when
;;------------------------------------------------------------------------------
sv: DW 112 ; variable for when to stop/slow down the motors when travelling straight
RorLSensor: DW 0;;  0 if left sensor, 1 if right sensor

TRAVELDISTANCEQ:
    OUT     RESETPOS
    LOAD    FMid
    OUT     LVELCMD     ; Start motors
    OUT     RVELCMD

	Call FindD
    
TDQ:
	LOAD MASKSEL
	OUT SONAREN
	SUB ONE
	
	JZERO MEASURE0Sensor		;if mask is 00000001
	JUMP MEASURE5SENSOR		;else

	
R:    
	SUB DISTSIDE
	
	JPOS GETCLOSER
	JUMP GETFURTHER
	
RE:	IN      XPOS
	
    SUB     Q
	add 	sv


    JNEG    TDQ  ; keep going if hasnt gone to q-sv units
	



    ; Stop the motors after it has gone the distance
    LOAD    Zero
    OUT     LVELCMD     ; Stop motors
    OUT     RVELCMD

    RETURN

	
	
	;; functions to make on wheel turn slightly faster than the other\
	
GETCLOSER:
	LOAD RorLSENSOR
	JZERO cRFASTER
	JUMP cLFASTER

GETFURTHER:
	LOAD RorLSensor
	JZERO cLFASTER
	JUMP CRFASTER

cRFASTER:
	call RFASTER
	JUMP RE
	
cLFASTER:	
	call LFASTER
	JUMP RE
	
RFASTER:
	LOAD FMID
	ADDI -10
	OUT LVELCMD
	ADDI 20
	OUT RVELCMD
	
	RETURN

LFASTER:	
	LOAD FMID
	ADDI -10
	OUT RVELCMD
	ADDI 20
	OUT LVELCMD
	
	RETURN
	
MEASURE0SENSOR:	
	LOAD ZERO
	STORE RorLSENSOR
	IN DIST0
	
	JUMP R

MEASURE5SENSOR:
	LOAD ONE
	STORE RorLSENSOR
	IN DIST5
	JUMP R
	
	
;;FindD-- find the distances for traveling
; FIND DIST

; in: x, y dir
;	X Y   DWANTED

FindD:
	LOAD XFD
	SHIFT 8
	ADD YFD
	OUT SSEG1
	
	LOAD 	ORIENT
	JPOS	DWNOT0
	; ------------ DW0 -----
	LOAD	YFD
	SUB		TWO
	JPOS	DW0X6	; OTHERWISE X TOTAL IS 4, Y <= 2 
	LOADI	4
	SUB		XFD
	STORE	DWANTED
	LOAD 	MASK5
	STORE	MASKSEL
	LOAD 	YFD
	SUB		ONE
	JZERO	DWIS0
	JUMP	DWIS1
	
DW0X6:
	LOADI	6
	SUB	 	XFD
	STORE	DWANTED
	LOAD 	MASK0
	STORE	MASKSEL
	LOAD 	YFD
	SUB		THREE
	JZERO	DWIS1
	JUMP	DWIS0

DWNOT0:		; DW1
	SUB		ONE
	JPOS	DWNOT1
	LOAD 	MASK0
	STORE	MASKSEL
	LOAD 	XFD
	SUB		ONE
	STORE	DISTSIDE
	LOAD 	YFD
	SUB		TWO		
	JPOS	DW1Y13
	LOAD 	YFD
	SUB		ONE
	JZERO	DWIS1F
	JUMP	DWIS0F
DW1Y13:		
	LOAD 	YFD
	SUB		THREE
	JZERO	DWIS1F
	JUMP	DWIS0F

DWNOT1:		; DW2
	SUB		ONE
	JPOS	DWNOT2
	LOAD 	XFD
	SUB		ONE
	STORE	DWANTED
	LOAD	YFD
	SUB		TWO
	JPOS	DW2X6	; OTHERWISE X TOTAL IS 4, Y <= 2
	LOAD 	MASK0
	STORE	MASKSEL
	LOAD 	YFD
	SUB		ONE
	JZERO	DWIS0
	JUMP	DWIS1
	
DW2X6:
	LOAD 	MASK5
	STORE	MASKSEL
	LOAD 	YFD
	SUB		THREE
	JZERO	DWIS1
	JUMP	DWIS0


DWNOT2: 	; DW3
	LOAD 	MASK5
	STORE	MASKSEL
	LOAD 	XFD
	SUB		ONE
	STORE	DISTSIDE
	LOAD 	YFD
	SUB		TWO		
	JPOS	DW3Y13
	LOAD 	YFD
	SUB		ONE
	JZERO	DWIS0F
	JUMP	DWIS1F
DW3Y13:		
	LOAD 	YFD
	SUB		THREE
	JZERO	DWIS0F
	JUMP	DWIS1F

DWIS0:
	LOADI	0
	JUMP	DWIS 
DWIS1:
	LOADI	1
DWIS:
	STORE	DISTSIDE
	JUMP	DWEND

DWIS0F:
	LOADI	0
	JUMP	DWISF 
DWIS1F:
	LOADI	1
DWISF:
	STORE	DWANTED

DWEND:
	;; convert the tile values to count values
	LOAD DWANTED
	STORE TILESTOCOUNTS
	CALL TTC
	ADDI 293
	STORE DWANTED
	
	LOAD DISTSIDE
	STORE TILESTOCOUNTS
	CALL TTC
	ADDI 293
	STORE DISTSIDE
	OUT SSEG2
	LOAD MASKSEL
	OUT SSEG1
	
RETURN






MASKSEL:	DW 		0
DISTSIDE:	DW 		0


DWANTED: DW 0
DWANTEDLOW: DW 0
DWANTEDHIGH: DW 0
DISTAWAY: DW 0
AREWEGOOD: DW 0	


;;--- int Q --------------------------------------------------------------------
;; Distance to go. Never negative.
;;------------------------------------------------------------------------------
Q: DW 0


;;--- int Orient ---------------------------------------------------------------
;; Current direction. One of (0,1,2,3).
;;------------------------------------------------------------------------------
;ORIENT: DW 0

;;--- int P --------------------------------------------------------------------
;; Desired direction. One of (0,1,2,3).
;;------------------------------------------------------------------------------
P: DW 0

;;---int TilesToCounts----------------------------------------------------------
;;  Is set to tiles we desire to travel. Is converted to counts(1.04mm/count) and then assigned to StepX or StepY
;;-------------------------------------------------------------------------------

TILESTOCOUNTS: DW 0

;CONSTANTS: TILES CONVERTED TO UNITS WE NEEDTOGO
ONET: DW 586
TWOT: DW 1172
THREET: DW 1758
FOURT: DW 2344
FIVET: DW 2390






;old stuff
	
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
;;--- void Wait1 ---------------------------------------------------------------
;; Wait a second.
;;------------------------------------------------------------------------------



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
