JUMP Main

#include "Devices.asm"
#include "LCD.asm"

;;--- void Main() --------------------------------------------------------------
;; Main - Entry point for the program.
;;------------------------------------------------------------------------------
Main:
    ;; Reset robot's devices
    LOADI   LCDInitStringz
    CALL    LCDWriteStringz
    CALL    Shutdown

    ;; Write the initial strings
    LOADI   StartStringz1
    CALL    LCDWriteStringz
    LOADI   40
    CALL    LCDSetPos
    LOADI   StartStringz2
    CALL    LCDWriteStringz

    ;; Wait for key3 to be pressed
    CALL    WaitForKey3

    ;; Clear the screen
    LOADI   LCDInitStringz
    CALL    LCDWriteStringz

    ;; Align the robot and halt
    LOADI   270
    CALL    AlignRobot
    LOAD    AlignRobot2MinDist1
    CALL    RotateTo

    ;; Done
    CALL    Shutdown
    CALL    Halt

;;--- void WaitForKey3() -------------------------------------------------------
;; Return once Key3 has been pressed.
;;------------------------------------------------------------------------------
WaitForKey3:
    IN      XIO
    AND     WaitForKey3Mask
    JPOS    WaitForKey3
    RETURN
WaitForKey3Mask:
    DW      &B0000000000000100

;;--- void Wait1 ---------------------------------------------------------------
;; Wait a second.
;;------------------------------------------------------------------------------
Wait1:
    OUT    TIMER
Wait1loop:
    IN      TIMER
    OUT     XLEDS       ; User-feedback that a pause is occurring.
    ADDI    -10         ; 1 second in 10Hz.
    JNEG    Wait1loop
    RETURN

;;--- void WaitTenth() ---------------------------------------------------------
;; Wait a tenth of second.
;;------------------------------------------------------------------------------
WaitTenth:
    OUT TIMER
WaitTenthLoop:
    IN TIMER
    JZERO WaitTenthLoop
    RETURN

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

    IN      THETA
    ;; If we've rotated 90 degrees, goto AlignRobot2Done
    SUB     Degrees
    JZERO   AlignRobot2Done
    JPOS    AlignRobot2Done

    ;; AlignRobot2MinDist = Min(DIST0, AlignRobot2MinDist)
    ;; and display on seven segement 2

    ;; Save theta, dist0, and dist5
    IN      THETA
    STORE   AlignRobot2TempTheta
    IN      DIST0
    STORE   AlignRobot2Temp1
    IN      DIST5
    STORE   AlignRobot2Temp2

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

AlignRobot2SonarMask: ;; Sonars 0 and 5
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

;;--- void RotateTo(int angle) -------------------------------------------------
;; Rotate until theta matches the given angle.
;;------------------------------------------------------------------------------
RotateTo:
    STORE   RotateToTemp
    IN      THETA
    SUB     RotateToTemp

    JZERO   RotateToDone
    JPOS    RotateToCCW
    JNEG    RotateToCW

RotateToCW:
    CALL    RotateCW

    IN      THETA
    SUB     RotateToTemp
    JNEG    RotateToCW
    JUMP    RotateToDone

RotateToCCW:
    CALL    RotateCCW

    IN      THETA
    SUB     RotateToTemp
    JPOS    RotateToCCW
;;  JUMP    RotateToDone

RotateToDone:
    CALL    StopMotors
    RETURN

RotateToTemp:
    DW 0

;;--- void Shutdown() ----------------------------------------------------------
;; Stop the motors and sonar devices.
;;------------------------------------------------------------------------------
Shutdown:
    LOADI   0
    OUT     RVELCMD
    OUT     LVELCMD
    OUT     SONAREN
    RETURN

;;--- void Halt() --------------------------------------------------------------
;; Effectively stop the CPU.
;;------------------------------------------------------------------------------
Halt:
    JUMP    Halt

;;--- void RotateCW() ----------------------------------------------------------
;; Make the robot rotate in place clock-wise.
;;------------------------------------------------------------------------------
RotateCW:
    LOAD    FSpeed
    OUT     RVELCMD
    LOAD    RSpeed
    OUT     LVELCMD
    RETURN

;;--- void RotateCCW() ---------------------------------------------------------
;; Make the robot rotate in place counter-clock-wise.
;;------------------------------------------------------------------------------
RotateCCW:
    LOAD    RSpeed
    OUT     RVELCMD
    LOAD    FSpeed
    OUT     LVELCMD
    RETURN

;;--- void StopMotors ----------------------------------------------------------
;; Stop the robot's motors.
;;------------------------------------------------------------------------------
StopMotors:
    LOADI   0
    OUT     RVELCMD
    OUT     LVELCMD
    RETURN

;;--- int Min(int a, int b) ----------------------------------------------------
;; Return the minimum of two values.
;;------------------------------------------------------------------------------
MinArg1: DW 0
MinArg2: DW 0

Min:
    LOAD    MinArg1
    SUB     MinArg2
    JPOS    MinReturn2
MinReturn1:
    LOAD    MinArg1
    RETURN
MinReturn2:
    LOAD    MinArg2
    RETURN

;;--- Macro Speed --------------------------------------------------------------
;; Moderate speeds for the robot's motors.
;;------------------------------------------------------------------------------
FSpeed:   DW 150
RSpeed:   DW -150
