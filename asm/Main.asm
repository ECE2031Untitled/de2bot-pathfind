JUMP    Main

#include "LCD.asm"

#include "Align.asm"
#include "Localization.asm"
#include "ShortestPath.asm"
#include "Nav.asm"

;;--- void Main() --------------------------------------------------------------
;; Main - Entry point for the program.
;;------------------------------------------------------------------------------
Main:
    ;; Reset robot's devices
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

    CALL    LCDResetScreen

    ;; Align the robot and halt
    LOADI   270
    CALL    AlignRobot
    LOAD    AlignRobot2MinDist1
    CALL    RotateTo

    CALL Localization
    LOAD X0
    STORE LCDWriteCoordinateArgX
    LOAD Y0
    STORE LCDWriteCoordinateArgY
    CALL LCDWriteCoordinate

    ; JUMP    ShortestPath ; Tail-call
    ;; TODO, goto coordinates along shortest path

    ;; Done
    CALL    Shutdown
    JUMP    Halt        ;; Tail-call
