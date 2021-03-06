#ifndef UTIL_ASM
#define UTIL_ASM

;;=== Global Variables =========================================================
;;==============================================================================
X0: DW 0
Y0: DW 0

;;--- int Orient ---------------------------------------------------------------
;; Current direction. One of (0,1,2,3).
;;------------------------------------------------------------------------------
Orient: DW 0

;;=== Program Startup/Shutdown =================================================
;;==============================================================================

;;--- void Shutdown() ----------------------------------------------------------
;; Stop the motors and sonar devices.
;;------------------------------------------------------------------------------
Shutdown:
    LOADI   0
    OUT     RVELCMD
    OUT     LVELCMD
    OUT     SONAREN
    JUMP    LCDResetScreen ;; Tail-call

;;--- void Halt() --------------------------------------------------------------
;; Effectively stop the CPU.
;;------------------------------------------------------------------------------
Halt:
    LOADI   LCDInitStringz
    CALL    LCDWriteStringz
    LOADI   HaltStringz
    CALL    LCDWriteStringz
HaltLoop:
    JUMP    HaltLoop

;;=== Motor Control ============================================================
;;==============================================================================

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

;;--- void RotateTo(int angle) -------------------------------------------------
;; Rotate until theta matches the given angle.
;;------------------------------------------------------------------------------
RotateTo:
    STORE   RotateToTemp
RotateToLoop:
    CALL    RotateCW
    IN      THETA
    SUB     RotateToTemp
    JZERO   RotateToDone
    JUMP    RotateToLoop
RotateToDone:
    JUMP    StopMotors ;; Tail-call

RotateToTemp:
    DW 0

;;--- int FSpeed, RSpeed -------------------------------------------------------
;; Moderate speeds for the robot's motors.
;;------------------------------------------------------------------------------
FSpeed:   DW 150
RSpeed:   DW -150

;;=== Wait Functions ===========================================================
;;==============================================================================

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

;;=== Miscellaneous ============================================================
;;==============================================================================

;;--- int Negate(int x) --------------------------------------------------------
;; Returns -x.
;;------------------------------------------------------------------------------
Negate:
    STORE   NegateTemp
    LOADI   0
    SUB     NegateTemp
    RETURN

NegateTemp: DW 0

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

;;--- int Abs(int x) -----------------------------------------------------------
;; Return the absolute value of x.
;;------------------------------------------------------------------------------
Abs:
    JNEG    Negate
    RETURN

#endif /* UTIL_ASM */
