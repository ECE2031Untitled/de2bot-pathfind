;;--- void Nav(int stepX, int stepY) -------------------------------------------
;; Make the robot travel by a specified x and y value, which may be negative.
;;
;; stepX - The distance to travel in the X direction.
;; stepY - The distance to travel in the Y direction.
;;------------------------------------------------------------------------------
NAV:
    OUT    RESETPOS
    ;Travel X
    ;WHICH WAY TO ORIENT TO TRAVEL X?

    LOAD   STEPX
    JNEG   PTOTWO
    JPOS   PTOZERO



ContNavX:
    CALL   SETORIENTTOP
    
    STORE TILESTOCOUNTS
    CALL TTC
    STORE STEPX
    
    LOAD   STEPX;
    STORE  Q;
    CALL   TRAVELDISTANCEQ ;go in x direction

    ;Travel y
    ;WHICH WAY TO ORIENT TO TRAVEL Y?

    LOAD   STEPY
    JNEG   PTOTHREE
    JPOS   PTOONE
    


ContNavY:
    CALL SETORIENTTOP
    
    STORE TILESTOCOUNTS
    CALL TTC
    STORE STEPY
    
    LOAD   STEPY
    STORE  Q
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
    LOAD   ORIENT
    SUB    P
    JZERO  DONE
    CALL   ROTATE90CW               ;should prolly optimize to rotate the faster way.
    JUMP   SETORIENTTOP
DONE:
    RETURN

;;--- void Rotate90CW() --------------------------------------------------------
;; Rotate the robot 90 degrees clock-wise, adjusting the orientation variable.
;;------------------------------------------------------------------------------
ROTATE90CW:
    LOAD    FSlow
    OUT     LVELCMD
    LOAD    RSlow
    OUT     RVELCMD

    IN      THETA
    SUB     Deg270

    JPOS    Rotate90CW

    CALL    StopMotors

    ;UPDATE CHANGED ORIENT VALUE

    LOAD    ORIENT
    SUB     1
    JNEG    SETORIENTTOTHREE ;; Wrap negative numbers back around to 3.
    STORE   ORIENT
    RETURN

SETORIENTTOTHREE:
    LOAD   THREE
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
SET2:  
    LOAD TWOT
    STORE TILESTOCOUNTS
SET3:  
    LOAD THREET
    STORE TILESTOCOUNTS
SET4:  
    LOAD FOURT
    STORE TILESTOCOUNTS
SET5:
    LOAD FIVET
    STORE TILESTOCOUNTS

END: RETURN    
    


;Code to travel a given distance. Only input required is Q which should be the robot count units of the distance you want to travel.

;;--- void TravelDistanceQ() ---------------------------------------------------
;; Move forward Q Count Units.
;;------------------------------------------------------------------------------
TRAVELDISTANCEQ:
    OUT     RESETPOS
TDQ:
    LOAD    FMid
    OUT     LVELCMD     ; Start motors
    OUT     RVELCMD

    IN      XPOS
    SUB     Q

    JNEG    TDQ  ; keep going if hasnt gone to 4ft

    ; Stop the motors after it has gone the distace
    LOAD    Zero
    OUT     LVELCMD     ; Stop motors
    OUT     RVELCMD

    RETURN

;;--- int Q --------------------------------------------------------------------
;; Distance to go. Never negative.
;;------------------------------------------------------------------------------
Q: DW 0

;;--- int Orient ---------------------------------------------------------------
;; Current direction. One of (0,1,2,3).
;;------------------------------------------------------------------------------
ORIENT: DW 0

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
THREET:DW 1758
FOURT: DW 2344
FIVET: DW 2390
