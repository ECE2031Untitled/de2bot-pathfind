#include "Devices.asm"
#include "LCD.asm"
#include "Util.asm"

;;--- (int,int) AlignRobot(int angle) ------------------------------------------
;; Align the robot to the minimum distance within an arc of the given angle.
;;
;; Returns the theta angle which was minimum for two opposite sensors (0 and 5).
;;------------------------------------------------------------------------------
AlignRobot:
    ;; Store the number of degrees to rotate
    STORE   Degrees

    ;; Reset theta, x, y to 0
    OUT     RESETPOS

    ;; Enable sonars 0 and 5, disable all others
    LOAD    AlignRobot2SonarMask
    ;; Output a few times to make sure the sonars definately do turn on
    OUT     SONAREN
    OUT     SONAREN
    OUT     SONAREN

    ;; Initialize min distance to be the maximum possible value
    LOAD    MaxValue
    STORE   AlignRobot2MinDist1
    STORE   AlignRobot2MinDist2

    ;; Write AlignmentStringz to LCD
    LOADI   AlignmentStringz
    CALL    LCDWriteStringz

    ;; Reset timer. (This will be used to append '.' to the LCD)
    OUT     TIMER

AlignRobot2Loop:
    CALL    RotateCW    ;; While in this loop, rotate continuously

    ;; Append a dot every 1/2 second
    IN      TIMER
    ADDI    -5
    JNEG    AlignRobotDontAppendDot
    LOADI   46          ; '.'
    CALL    LCDWriteChar
    OUT     TIMER
AlignRobotDontAppendDot:

    ;; Save theta, dist0, and dist5
    IN      THETA
    STORE   AlignRobot2TempTheta
    IN      DIST0
    STORE   AlignRobot2Temp1
    IN      DIST5
    STORE   AlignRobot2Temp2

    ;; If we've rotated the given number of degrees, goto AlignRobot2Done
    LOAD    AlignRobot2TempTheta
    SUB     Degrees
    JZERO   AlignRobot2Done
    JPOS    AlignRobot2Done

    ;; Update min dist 1 if dist0 is a new minimum
    LOAD    AlignRobot2Temp1
    SUB     AlignRobot2MinDist1
    JPOS    AlignRobot2NotMin1

    LOAD    AlignRobot2Temp1
    STORE   AlignRobot2MinDist1
    LOAD    AlignRobot2TempTheta
    STORE   AlignRobot2MinTheta1

AlignRobot2NotMin1:

    ;; Update min dist 2 is dist5 is a new minimum
    LOAD    AlignRobot2Temp2
    SUB     AlignRobot2MinDist2
    JPOS    AlignRobot2NotMin2

    LOAD    AlignRobot2Temp2
    STORE   AlignRobot2MinDist2
    LOAD    AlignRobot2TempTheta
    STORE   AlignRobot2MinTheta2

AlignRobot2NotMin2:
    JUMP AlignRobot2Loop

AlignRobot2Done:
    ;; Stop the motors and sonars
    CALL    StopMotors
    LOADI   0
    OUT     SONAREN

    ;; Print the minimum theta to seven segement 1
    LOAD    AlignRobot2MinTheta1
    OUT     SSEG1

    LOAD    AlignRobot2MinTheta2
    OUT     SSEG2

    RETURN

AlignRobot2SonarMask: ;; Sonars 0, 5
    DW      &B0000000000100001
MaxValue:
    DW &H07FF
Degrees:
    DW      0

AlignRobot2MinDist1:
    DW      0
AlignRobot2MinTheta1:
    DW      0

AlignRobot2MinDist2:
    DW      0
AlignRobot2MinTheta2:
    DW      0

AlignRobot2TempTheta:
    DW      0
AlignRobot2Temp1:
    DW      0
AlignRobot2Temp2:
    DW      0


;;--- void FillSonarArray() ----------------------------------------------------
;; Fill a 180 value array with sonar measurements at those angles.
;;------------------------------------------------------------------------------
FillSonarArray:
    ;; Reset theta
    OUT     RESETPOS

    ;; Enable sonar0
    LOADI   1
    OUT     SONAREN

FillSonarArrayLoop:
    ;; Rotate continuously while in the loop
    CALL    RotateCW

    ;; temp = theta
    IN      THETA
    STORE   FillSonarArrayTemp

    ;; if (temp == 180) goto done
    ADDI    -180
    JZERO    FillSonarArrayDone

    ;; Get the address to store at ( &SonarArray[Theta] )
    LOADI   SonarArray
    ADD     FillSonarArrayTemp
    STORE   FillSonarArrayTemp

    ;; Store the distance in the sonar array ( SonarArray[Theta] = Dist0 )
    IN      DIST0
    ISTORE  FillSonarArrayTemp

    JUMP FillSonarArrayLoop

FillSonarArrayDone:
    LOADI   0
    OUT     SONAREN
    CALL    StopMotors

    RETURN

FillSonarArrayTemp:
    DW 0

;;--- void BestSonarArrayAngle() -----------------------------------------------
;; Find the angle in SonarArray which has the minimum value and which has a
;; valid angle (not 0x7ff) ninety degrees above it.
;;------------------------------------------------------------------------------
BestSonarArrayAngle:
    ;; int min = 0x7ff
    LOAD    MaxValue
    STORE   BestSonarArrayAngleMin
    ;; in minAngle = 0
    LOADI   0
    STORE   BestSonarArrayAngleMinAngle
    ;; int i = 0
    LOADI   0
    STORE   BestSonarArrayAngleI
    ;; int j = 90
    LOADI   90
    STORE   BestSonarArrayAngleJ

BestSonarArrayAngleLoop:
    CALL    WaitTenth

    ;; while (i != 180)
    LOAD    BestSonarArrayAngleI
    ADDI    -180
    JZERO   BestSonarArrayAngleDone

    ;; Acc = SonarArray[j]
    LOADI   SonarArray
    ADD     BestSonarArrayAngleJ
    STORE   BestSonarArrayAngleTemp
    ILOAD   BestSonarArrayAngleTemp

    ;; If SonarArray[j] != 0x7ff
    ; SUB     MaxValue
    ; JZERO   BestSonarArrayAngleDontCount
    ;; If SonarArray[j] <= 6 feet
    SUB     BestSonarArrayAngle6Feet
    JPOS    BestSonarArrayAngleDontCount

    ;; temp = SonarArray[i]
    LOADI   SonarArray
    ADD     BestSonarArrayAngleI
    STORE   BestSonarArrayAngleTemp
    ILOAD   BestSonarArrayAngleTemp
    STORE   BestSonarArrayAngleTemp

    OUT     SSEG1

    ;; If (temp < min)
    SUB     BestSonarArrayAngleMin
    JPOS    BestSonarArrayAngleDontCount

    ;; min = temp
    LOAD    BestSonarArrayAngleTemp
    STORE   BestSonarArrayAngleMin
    ;; minAngle = i
    LOAD    BestSonarArrayAngleI
    STORE   BestSonarArrayAngleMinAngle

BestSonarArrayAngleDontCount:
    ;; i++
    LOAD    BestSonarArrayAngleI
    ADDI    1
    STORE   BestSonarArrayAngleI

    ;; j = j++ == 180 ? 0 : j
    LOAD    BestSonarArrayAngleJ
    ADDI    1
    STORE   BestSonarArrayAngleJ

    ADDI    -180
    JNEG    BestSonarArrayAngleDontResetJ

    LOADI   0
    STORE   BestSonarArrayAngleJ

BestSonarArrayAngleDontResetJ:
    JUMP    BestSonarArrayAngleLoop

BestSonarArrayAngleDone:
    LOAD    BestSonarArrayAngleMin
    RETURN


BestSonarArrayAngleI:
    DW 0
BestSonarArrayAngleJ:
    DW 0
BestSonarArrayAngleMin:
    DW 0
BestSonarArrayAngleMinAngle:
    DW 0
BestSonarArrayAngleTemp:
    DW 0
BestSonarArrayAngle6Feet:
    DW 879 ;; Note, decreased to 3 feet


;;--- int SonarArray[180] ------------------------------------------------------
;; A 180 value array of sonar measurements at those angles.
;;------------------------------------------------------------------------------
SonarArray:
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
    DW      0
