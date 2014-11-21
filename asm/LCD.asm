#ifndef LCD_ASM
#define LCD_ASM

#include "Devices.asm"

;;--- void LCDWriteChar(int c) -------------------------------------------------
;; Write a single character to the LCD.
;;------------------------------------------------------------------------------
LCDWriteChar:
    OUT     LCD
    LOAD    LCDWrite
    OUT     LCD

    ;; Wait a tenth of a second, to allow the write to LCD to finalize.
    ;; We may not need to wait that long, and a certain number of NOPs may
    ;; be sufficient.
    OUT     TIMER
LCDWriteCharWait:
    IN      TIMER
    JZERO   LCDWriteCharWait

    RETURN

;;--- void LCDWriteStringz(int *str) -------------------------------------------
;; Write a null-terminated string to the LCD.
;;------------------------------------------------------------------------------
LCDWriteStringz:
    STORE   LCDWriteStringzTemp
LCDWriteStringzLoop:
    ILOAD   LCDWriteStringzTemp
    JZERO   LCDWriteStringzDone ; If '\0', we're done

    CALL    LCDWriteChar
    LOAD    LCDWriteStringzTemp ; Otherwise increment the address and loop
    ADDI    1
    STORE   LCDWriteStringzTemp
    JUMP    LCDWriteStringzLoop
LCDWriteStringzDone:
    RETURN

LCDWriteStringzTemp:
    DW      0

;;--- void LCDSetPos(int pos) --------------------------------------------------
;; Set the cursor position in the LCD. 0 <= pos < 80. If pos > 40, it will be
;; on the second row.
;;------------------------------------------------------------------------------
LCDSetPos:
    OR LCDSetPosCmd
    CALL LCDWriteChar
    RETURN

LCDSetPosCmd:
    DW      &H8080

;;--- int LCDInitStringz[] -----------------------------------------------------
;; A null-terminated string which will initialize the LCD if written to it.
;;------------------------------------------------------------------------------
LCDInitStringz:
    DW      &H8030 ;; Wakeup
    DW      &H8030 ;; Wakeup
    DW      &H8030 ;; Wakeup
    DW      &H8038 ;; 8 bit, 2 rows
    DW      &H8008 ;; Display off, cursor off, no blink
    DW      &H8001 ;; Clear display
    DW      &H800C ;; Display on, cursor off
    DW      &H8006 ;; Auto-increment, shift cursor
    DW      &H0000 ;; Null byte

;;--- int StartStringz1[], int StartStringz2[] ---------------------------------
;; Two stringz to display on startup.
;; "Flip switch 18."
;; "Then press KEY3."
;;------------------------------------------------------------------------------
StartStringz1:
    DW      70
    DW      108
    DW      105
    DW      112
    DW      32
    DW      115
    DW      119
    DW      105
    DW      116
    DW      99
    DW      104
    DW      32
    DW      49
    DW      56
    DW      46
    DW      0

StartStringz2:
    DW      84
    DW      104
    DW      101
    DW      110
    DW      32
    DW      112
    DW      114
    DW      101
    DW      115
    DW      115
    DW      32
    DW      75
    DW      69
    DW      89
    DW      51
    DW      46
    DW      0

;;--- int AlignmentStringz[] ---------------------------------------------------
;; A string to display while aligning.
;; "Aligning"
;;------------------------------------------------------------------------------
AlignmentStringz:
    DW      65
    DW      108
    DW      105
    DW      103
    DW      110
    DW      105
    DW      110
    DW      103
    DW      0

;;--- int LCDCmd ---------------------------------------------------------------
;; A flag which when outputted to the LCD indicates it is a command. (The
;; default is a character).
;;------------------------------------------------------------------------------
LCDCmd:
    DW      &B1000000000000000

;;--- int LCDWrite -------------------------------------------------------------
;; An instruction that when outputted to the LCD writes the previous
;; instruction.
;;------------------------------------------------------------------------------
LCDWrite:
    DW      &B0100000000000000

;;--- int LCDResetChar ---------------------------------------------------------
;; A character which if written to the LCD will reset it.
;;------------------------------------------------------------------------------
LCDResetChar:
    DW      &H8001

;;--- int LCDDisplayOn ---------------------------------------------------------
;; A character which if written to the LCD will turn the display on.
;;------------------------------------------------------------------------------
LCDDisplayOn:
    DW      &H800C

;;--- int LCDDisplayOff --------------------------------------------------------
;; A character which if written to the LCD will turn the display off.
;;------------------------------------------------------------------------------
LCDDisplayOff:
    DW      &H8008

#endif /* LCD_ASM */
