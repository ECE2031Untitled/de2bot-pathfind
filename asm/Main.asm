JUMP    Main

#include "LCD.asm"

#include "Align.asm"
#include "ShortestPath.asm"

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

    ;; Clear the screen
    LOADI   LCDInitStringz
    CALL    LCDWriteStringz

    ;; Align the robot and halt
    LOADI   270
    CALL    AlignRobot
    LOAD    AlignRobot2MinDist1
    CALL    RotateTo

    ;; TODO, find initial coodinates
    CALL    ShortestPath
    ;; TODO, goto coordinates along shortest path

    ;; Done
    CALL    Shutdown
    CALL    Halt
