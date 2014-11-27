;;--- void Nav(int stepX, int stepY) -------------------------------------------
;; Make the robot travel by a specified x and y value, which may be negative.
;;
;; stepX - The distance to travel in the X direction.
;; stepY - The distance to travel in the Y direction.
;;------------------------------------------------------------------------------
STEPX: DW -4
STEPY: DW -3
;ORIENT: DW 0
X: DW 5         ;;starting points
Y: DW 4
XINIT: DW 0
YINIT: DW 0
XORYFIRST: DW 0
XFD: DW 0       ;;x for findD equation. final point of path
YFD: DW 0       ;;y for findD equation. Final Point of path

NAV:
    ;; Reset x, y, theta to 0
    OUT     RESETPOS

;;UPDATE X AND Y POSITIONS
    LOAD    X
    STORE   XINIT
    ADD     STEPX
    STORE   X

    LOAD    Y
    STORE   YINIT
    ADD     STEPY
    STORE   Y

;;sort out order and variables to use
    LOAD    XORYFIRST
    JZERO   CallXFirst

;; we go y first then x first so these are the variables we need for findD
CallYFirst:
    LOAD    XINIT  ;; x initial is the final x
    STORE   XFD

    LOAD    Y      ;; y final is the final y
    STORE   YFD

    CALL    NAVY

    LOAD    X          ;; now x final is the final x
    STORE   XFD

    CALL    NAVX

    JUMP    NavDone

CallXFirst:
    LOAD    X          ;; now x final is the final x
    STORE   XFD

    LOAD    YINIT
    STORE   YFD

    CALL    NAVX

    LOAD    Y
    STORE   YFD

    CALL    NAVY

    ;JUMP    NavDone

NavDone:
    RETURN

    ;Travel X
    ;WHICH WAY TO ORIENT TO TRAVEL X?

NAVX:
    LOAD    STEPX

    JNEG    PTOTWO
    JPOS    PTOZERO



ContNavX:
    CALL    SETORIENTTOP

    LOAD    STEPX
    STORE   TILESTOCOUNTS

    CALL    TTC
    STORE   STEPX


    LOAD    STEPX;
    STORE   Q;
    CALL    wait1
    CALL    wait1
    CALL    TRAVELDISTANCEQ ;go in x direction

    ;;hehehe: jump hehehe
    ;Travel y
    ;WHICH WAY TO ORIENT TO TRAVEL Y?

    RETURN

NAVY:
    LOAD    STEPY        ;;loading in STEPY in TILES TO TRAVEL

    JNEG    PTOTHREE     ;;set desired orientation
    JPOS    PTOONE

ContNavY:
    CALL    SETORIENTTOP       ;; set orientation to the desired orientation via rotating cw

    LOADI   9

    LOAD    STEPY
    STORE   TILESTOCOUNTS
    CALL    TTC

    STORE   STEPY

    LOAD    STEPY
    STORE   Q

    CALL    Wait1
    CALL    Wait1
    CALL    TRAVELDISTANCEQ

    RETURN

;; Set the desired orientation to 2, and negate the x distance.
PTOTWO:
    LOAD    TWO
    STORE   P
    LOAD    ZERO
    SUB     STEPX
    STORE   STEPX
    JUMP    ContNavX

;; Set the desired orientation to 0.
PTOZERO:
    LOAD    ZERO
    STORE   P
    JUMP    ContNavX

;; Set the desired orientation to 3, and negate the y distance.
PTOTHREE:
    LOAD    THREE
    STORE   P
    LOAD    ZERO
    SUB     STEPY
    STORE   STEPY
    JUMP    ContNavY

;; Set the desired orientation to 1.
PTOONE:
    LOAD    ONE
    STORE   P
    JUMP    ContNavY

; The following subroutines will rotate the robot so that it is oriented in the
; right way according to specifications from NAV commented out.

;;--- void SetOrientToP() ------------------------------------------------------
;; Rotate clockwise until the orientation matches the desired orientation (P).
;;------------------------------------------------------------------------------
SETORIENTTOP:
    LOAD    ORIENT       ;;keep rotating until orientation is correct/

    SUB     P

    JZERO   DONE
    CALL    WAIT1
    CALL    WAIT1
    CALL    WAIT1
    CALL    ROTATE90CCW               ;should prolly optimize to rotate the faster way.
    JUMP    SETORIENTTOP
DONE:
    RETURN

;;--- void Rotate90CW() --------------------------------------------------------
;; Rotate the robot 90 degrees clock-wise, adjusting the orientation variable.
;;------------------------------------------------------------------------------

sf: DW 11           ;; variable for when to shut motors off

ROTATE90CCW:                    ;;REALLY CCW
    OUT     RESETPOS        ;;need theta to be 0 before we start rotating

controtatingccw:

    LOADI   150
    OUT     RVELCMD
    LOADI   -150
    OUT     LVELCMD

    IN      THETA

    SUB     deg90
    ADD     sf

    JNEG    ContRotatingCCW

;; new code to slowly desencd to stop


;;were done rotating stop the motors

    LOAD    ZERO
    OUT     LVELCMD
    OUT     RVELCMD

    ;UPDATE CHANGED ORIENT VALUE

    LOAD    ORIENT      ;;current orient value gets subtracted by one
    ADD     ONE
    STORE   ORIENT

    SUB     FOUR
    JZERO   SETORIENTTOONE ;; IF ITS 4 MAKE IT ZERO

    RETURN

SETORIENTTOONE:
    LOAD    ONE
    STORE   ORIENT
    RETURN

TTC:
    LOAD    TILESTOCOUNTS

    JZERO   END

    SUB     ONE

    JZERO   SET1

    SUB     ONE
    JZERO   SET2

    SUB     ONE
    JZERO   SET3

    SUB     ONE
    JZERO   SET4

    SUB     ONE
    JZERO   SET5

SET1:
    LOAD    ONET
    STORE   TILESTOCOUNTS
    JUMP    END

SET2:
    LOAD    TWOT
    STORE   TILESTOCOUNTS
    JUMP    end

SET3:
    LOAD THREET
    STORE TILESTOCOUNTS
    JUMP end

SET4:
    LOAD FOURT
    STORE TILESTOCOUNTS
    JUMP end

SET5:
    LOAD FIVET
    STORE TILESTOCOUNTS

END:
    RETURN

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

    CALL    FindD

TDQ:
    LOAD    MASKSEL
    OUT     SONAREN
    SUB     ONE

    JZERO   MEASURE0Sensor        ;if mask is 00000001
    JUMP    MEASURE5SENSOR     ;else


R:
    SUB     DISTSIDE

    JPOS    GETCLOSER
    JUMP    GETFURTHER

RE:
    IN      XPOS

    SUB     Q
    ADD     sv

    JNEG    TDQ  ; keep going if hasnt gone to q-sv units

    ; Stop the motors after it has gone the distance
    LOAD    Zero
    OUT     LVELCMD     ; Stop motors
    OUT     RVELCMD

    RETURN

    ;; functions to make on wheel turn slightly faster than the other\

GETCLOSER:
    LOAD    RorLSENSOR
    JZERO   cRFASTER
    JUMP    cLFASTER

GETFURTHER:
    LOAD    RorLSensor
    JZERO   cLFASTER
    JUMP    CRFASTER

cRFASTER:
    CALL    RFASTER
    JUMP    RE

cLFASTER:
    CALL    LFASTER
    JUMP    RE

RFASTER:
    LOAD    FMID
    ADDI    -10
    OUT     LVELCMD
    ADDI    20
    OUT     RVELCMD

    RETURN

LFASTER:
    LOAD    FMID
    ADDI    -10
    OUT     RVELCMD
    ADDI    20
    OUT     LVELCMD

    RETURN

MEASURE0SENSOR:
    LOAD    ZERO
    STORE   RorLSENSOR
    IN      DIST0

    JUMP    R

MEASURE5SENSOR:
    LOAD    ONE
    STORE   RorLSENSOR
    IN      DIST5
    JUMP    R


;;FindD-- find the distances for traveling
; FIND DIST

; in: x, y dir
;   X Y   DWANTED

FindD:
    LOAD    XFD
    SHIFT   8
    ADD     YFD
    OUT     SSEG1

    LOAD    ORIENT
    JPOS    DWNOT0
    ; ------------ DW0 -----
    LOAD    YFD
    SUB     TWO
    JPOS    DW0X6   ; OTHERWISE X TOTAL IS 4, Y <= 2
    LOADI   4
    SUB     XFD
    STORE   DWANTED
    LOAD    MASK5
    STORE   MASKSEL
    LOAD    YFD
    SUB     ONE
    JZERO   DWIS0
    JUMP    DWIS1

DW0X6:
    LOADI   6
    SUB     XFD
    STORE   DWANTED
    LOAD    MASK0
    STORE   MASKSEL
    LOAD    YFD
    SUB     THREE
    JZERO   DWIS1
    JUMP    DWIS0

DWNOT0:     ; DW1
    SUB     ONE
    JPOS    DWNOT1
    LOAD    MASK0
    STORE   MASKSEL
    LOAD    XFD
    SUB     ONE
    STORE   DISTSIDE
    LOAD    YFD
    SUB     TWO
    JPOS    DW1Y13
    LOAD    YFD
    SUB     ONE
    JZERO   DWIS1F
    JUMP    DWIS0F
DW1Y13:
    LOAD    YFD
    SUB     THREE
    JZERO   DWIS1F
    JUMP    DWIS0F

DWNOT1:     ; DW2
    SUB     ONE
    JPOS    DWNOT2
    LOAD    XFD
    SUB     ONE
    STORE   DWANTED
    LOAD    YFD
    SUB     TWO
    JPOS    DW2X6   ; OTHERWISE X TOTAL IS 4, Y <= 2
    LOAD    MASK0
    STORE   MASKSEL
    LOAD    YFD
    SUB     ONE
    JZERO   DWIS0
    JUMP    DWIS1

DW2X6:
    LOAD    MASK5
    STORE   MASKSEL
    LOAD    YFD
    SUB     THREE
    JZERO   DWIS1
    JUMP    DWIS0


DWNOT2:     ; DW3
    LOAD    MASK5
    STORE   MASKSEL
    LOAD    XFD
    SUB     ONE
    STORE   DISTSIDE
    LOAD    YFD
    SUB     TWO
    JPOS    DW3Y13
    LOAD    YFD
    SUB     ONE
    JZERO   DWIS0F
    JUMP    DWIS1F
DW3Y13:
    LOAD    YFD
    SUB     THREE
    JZERO   DWIS0F
    JUMP    DWIS1F

DWIS0:
    LOADI   0
    JUMP    DWIS
DWIS1:
    LOADI   1
DWIS:
    STORE   DISTSIDE
    JUMP    DWEND

DWIS0F:
    LOADI   0
    JUMP    DWISF
DWIS1F:
    LOADI   1
DWISF:
    STORE   DWANTED

DWEND:
    ;; convert the tile values to count values
    LOAD    DWANTED
    STORE   TILESTOCOUNTS
    CALL    TTC
    ADDI    293
    STORE   DWANTED

    LOAD    DISTSIDE
    STORE   TILESTOCOUNTS
    CALL    TTC
    ADDI    293
    STORE   DISTSIDE
    OUT     SSEG2
    LOAD    MASKSEL
    OUT     SSEG1

    RETURN


MASKSEL:    DW      0
DISTSIDE:   DW      0

DWANTED:    DW      0
DWANTEDLOW: DW      0
DWANTEDHIGH: DW     0
DISTAWAY:   DW      0
AREWEGOOD:  DW      0

;;--- int Q --------------------------------------------------------------------
;; Distance to go. Never negative.
;;------------------------------------------------------------------------------
Q: DW 0

;;--- int P --------------------------------------------------------------------
;; Desired direction. One of (0,1,2,3).
;;------------------------------------------------------------------------------
P: DW 0

;;---int TilesToCounts----------------------------------------------------------
;;  Is set to tiles we desire to travel. Is converted to counts(1.04mm/count) and then assigned to StepX or StepY
;;-------------------------------------------------------------------------------
TILESTOCOUNTS: DW 0

;; Each of these represents X * 2ft, so OneT is 2ft, TwoT is 4ft, and so on
ONET:   DW 586
TWOT:   DW 1172
THREET: DW 1758
FOURT:  DW 2344
FIVET:  DW 2390
