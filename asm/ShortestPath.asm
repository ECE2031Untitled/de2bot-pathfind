JUMP    Main

#include "Devices.asm"
#include "Constant.asm"

Main: ; "Real" program starts here.

        ; first for X0
        LOAD    X0      ; AC = X0
        SUB     TWO     ; AC = X0 - 2
        JPOS    ROnth0  ; This point is on the right side. So region1 or region3 (RTwth:
                        ; Otherwise: region 2
        LOADI   2       ; In Reg 2, AC = 2
        JUMP    DR0

ROnth0: LOAD    Y0      ; AC = Y0
        SUB     TWO     ; AC = Y0 - 2
        JPOS    ROne0   ; if Y0 - 2 > 0, then in region one
        LOADI   3       ; Otherwise , region 3
        JUMP    DR0

ROne0:  LOADI   1
        JUMP    DR0

DR0:    STORE   R0      ; Store what's in the AC into addr R0
        ;JUMP   EoR

;-------------------------------------------------------------------------

        LOAD    X1      ; AC = X0
        SUB     TWO     ; AC = X0 - 2
        JPOS    ROnth1  ; This point is on the right side. So region1 or region3 (RTwth:
                        ; Otherwise: region 2
        LOADI   2       ; In Reg 2, AC = 2
        JUMP    DR1

ROnth1: LOAD    Y1      ; AC = Y0
        SUB     TWO     ; AC = Y0 - 2
        JPOS    ROne1   ; if Y0 - 2 > 0, then in region one
        LOADI   3       ; Otherwise , region 3
        JUMP    DR1

ROne1:  LOADI   1
        JUMP    DR1

DR1:    STORE   R1      ; Store what's in the AC into addr R0



;-------------------------------------------------------------------------

        LOAD    X2      ; AC = X0
        SUB     TWO     ; AC = X0 - 2
        JPOS    ROnth2  ; This point is on the right side. So region1 or region3 (RTwth:
                        ; Otherwise: region 2
        LOADI   2       ; In Reg 2, AC = 2
        JUMP    DR2

ROnth2: LOAD    Y2      ; AC = Y0
        SUB     TWO     ; AC = Y0 - 2
        JPOS    ROne2   ; if Y0 - 2 > 0, then in region one
        LOADI   3       ; Otherwise , region 3
        JUMP    DR2

ROne2:  LOADI   1
        JUMP    DR2

DR2:    STORE   R2      ; Store what's in the AC into addr R0


;-------------------------------------------------------------------------

        LOAD    X3      ; AC = X0
        SUB     TWO     ; AC = X0 - 2
        JPOS    ROnth3  ; This point is on the right side. So region1 or region3 (RTwth:
                        ; Otherwise: region 2
        LOADI   2       ; In Reg 2, AC = 2S
        JUMP    DR3

ROnth3: LOAD    Y3      ; AC = Y0
        SUB     TWO     ; AC = Y0 - 2
        JPOS    ROne3   ; if Y0 - 2 > 0, then in region one
        LOADI   3       ; Otherwise , region 3
        JUMP    DR3

ROne3:  LOADI   1
        JUMP    DR3

DR3:    STORE   R3      ; Store what's in the AC into addr R0

;-------------------------------BY HERE, ALL REGIONS DETERMINED---------------




;-------------- Calculate Dist b/t pairs of pts
; dist 01
    LOAD    R0      ; AC = RO
    SUB     ONE
    JPOS    D1NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    LOAD    R1      ; AC = R1
    SUB     THREE
    JZERO   CALD12  ; R0 = 1, R1 = 3
    JUMP    CALD11

D1NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    LOAD    R0      ; AC = R0
    SUB     THREE
    JZERO   D1THREE     ;STARTING POINT IN R3
    JUMP    CALD11

D1THREE:
    LOAD    R1
    SUB     ONE
    JZERO   CALD12      ; ENDING POINT IN R1

CALD11:     ; DISTANCE 1 METHOD1
    LOAD    X0
    SUB     X1
    JPOS    D1NEXT1
    JZERO   D1NEXT1
    CALL    NEGATE

D1NEXT1:
    STORE   DIFFX
    LOAD    Y0
    SUB     Y1
    JPOS    D1STORE
    JZERO   D1STORE
    CALL    NEGATE
    JUMP    D1STORE

CALD12:     ; DISTANCE 1 METHOD2
    LOAD    X0
    ADD     X1
    SUB     FOUR
    STORE   DIFFX
    LOAD    Y0
    SUB     Y1
    JPOS    D1STORE
    JZERO   D1STORE
    CALL    NEGATE
    JUMP    D1STORE

D1STORE:
    ADD DIFFX
    STORE   DIST01

; dist 02 ----------------------------------------------
    LOAD    R0      ; AC = RO
    SUB     ONE
    JPOS    D2NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    LOAD    R2      ; AC = R1
    SUB     THREE
    JZERO   CALD22  ; R0 = 1, R1 = 3
    JUMP    CALD21

D2NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    LOAD    R0      ; AC = R0
    SUB     THREE
    JZERO   D2THREE     ;STARTING POINT IN R3
    JUMP    CALD21

D2THREE:
    LOAD    R2
    SUB     ONE
    JZERO   CALD22      ; ENDING POINT IN R1

CALD21:     ; DISTANCE 1 METHOD1
    LOAD    X0
    SUB     X2
    JPOS    D2NEXT1
    JZERO   D2NEXT1
    CALL    NEGATE

D2NEXT1:
    STORE   DIFFX
    LOAD    Y0
    SUB     Y2
    JPOS    D2STORE
    JZERO   D2STORE
    CALL    NEGATE
    JUMP    D2STORE

CALD22:     ; DISTANCE 1 METHOD2
    LOAD    X0
    ADD     X2
    SUB     FOUR
    STORE   DIFFX
    LOAD    Y0
    SUB     Y2
    JPOS    D2STORE
    JZERO   D2STORE
    CALL    NEGATE
    JUMP    D2STORE

D2STORE:
    ADD DIFFX
    STORE   DIST02

; dist 03 ----------------------------------------------------
    LOAD    R0      ; AC = RO
    SUB     ONE
    JPOS    D3NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    LOAD    R3      ; AC = R1
    SUB     THREE
    JZERO   CALD32  ; R0 = 1, R1 = 3
    JUMP    CALD31

D3NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    LOAD    R0      ; AC = R0
    SUB     THREE
    JZERO   D3THREE     ;STARTING POINT IN R3
    JUMP    CALD31

D3THREE:
    LOAD    R3
    SUB     ONE
    JZERO   CALD32      ; ENDING POINT IN R1

CALD31:     ; DISTANCE 1 METHOD1
    LOAD    X0
    SUB     X3
    JPOS    D3NEXT1
    JZERO   D3NEXT1
    CALL    NEGATE

D3NEXT1:
    STORE   DIFFX
    LOAD    Y0
    SUB     Y3
    JPOS    D3STORE
    JZERO   D3STORE
    CALL    NEGATE
    JUMP    D3STORE

CALD32:     ; DISTANCE 1 METHOD2
    LOAD    X0
    ADD     X3
    SUB     FOUR
    STORE   DIFFX
    LOAD    Y0
    SUB     Y3
    JPOS    D3STORE
    JZERO   D3STORE
    CALL    NEGATE
    JUMP    D3STORE

D3STORE:
    ADD DIFFX
    STORE   DIST03

; dist 12 ----------------------------------------------
    LOAD    R1      ; AC = RO
    SUB     ONE
    JPOS    D4NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    LOAD    R2      ; AC = R1
    SUB     THREE
    JZERO   CALD42  ; R0 = 1, R1 = 3
    JUMP    CALD41

D4NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    LOAD    R1      ; AC = R0
    SUB     THREE
    JZERO   D4THREE     ;STARTING POINT IN R3
    JUMP    CALD41

D4THREE:
    LOAD    R2
    SUB     ONE
    JZERO   CALD42      ; ENDING POINT IN R1

CALD41:     ; DISTANCE 1 METHOD1
    LOAD    X1
    SUB     X2
    JPOS    D4NEXT1
    JZERO   D4NEXT1
    CALL    NEGATE

D4NEXT1:
    STORE   DIFFX
    LOAD    Y1
    SUB     Y2
    JPOS    D4STORE
    JZERO   D4STORE
    CALL    NEGATE
    JUMP    D4STORE

CALD42:     ; DISTANCE 1 METHOD2
    LOAD    X1
    ADD     X2
    SUB     FOUR
    STORE   DIFFX
    LOAD    Y1
    SUB     Y2
    JPOS    D4STORE
    JZERO   D4STORE
    CALL    NEGATE
    JUMP    D4STORE

D4STORE:
    ADD DIFFX
    STORE   DIST12

; dist 13 ----------------------------------------------
    LOAD    R1      ; AC = RO
    SUB     ONE
    JPOS    D5NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    LOAD    R3      ; AC = R1
    SUB     THREE
    JZERO   CALD52  ; R0 = 1, R1 = 3
    JUMP    CALD51

D5NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    LOAD    R1      ; AC = R0
    SUB     THREE
    JZERO   D5THREE     ;STARTING POINT IN R3
    JUMP    CALD51

D5THREE:
    LOAD    R3
    SUB     ONE
    JZERO   CALD52      ; ENDING POINT IN R1

CALD51:     ; DISTANCE 1 METHOD1
    LOAD    X1
    SUB     X3
    JPOS    D5NEXT1
    JZERO   D5NEXT1
    CALL    NEGATE

D5NEXT1:
    STORE   DIFFX
    LOAD    Y1
    SUB     Y3
    JPOS    D5STORE
    JZERO   D5STORE
    CALL    NEGATE
    JUMP    D5STORE

CALD52:     ; DISTANCE 1 METHOD2
    LOAD    X1
    ADD     X3
    SUB     FOUR
    STORE   DIFFX
    LOAD    Y1
    SUB     Y3
    JPOS    D5STORE
    JZERO   D5STORE
    CALL    NEGATE
    JUMP    D5STORE

D5STORE:
    ADD DIFFX
    STORE   DIST13

; dist 13 ----------------------------------------------
    LOAD    R2      ; AC = RO
    SUB     ONE
    JPOS    D6NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    LOAD    R3      ; AC = R1
    SUB     THREE
    JZERO   CALD62  ; R0 = 1, R1 = 3
    JUMP    CALD61

D6NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    LOAD    R2      ; AC = R0
    SUB     THREE
    JZERO   D6THREE     ;STARTING POINT IN R3
    JUMP    CALD61

D6THREE:
    LOAD    R3
    SUB     ONE
    JZERO   CALD62      ; ENDING POINT IN R1

CALD61:     ; DISTANCE 1 METHOD1
    LOAD    X2
    SUB     X3
    JPOS    D6NEXT1
    JZERO   D6NEXT1
    CALL    NEGATE

D6NEXT1:
    STORE   DIFFX
    LOAD    Y2
    SUB     Y3
    JPOS    D6STORE
    JZERO   D6STORE
    CALL    NEGATE
    JUMP    D6STORE

CALD62:     ; DISTANCE 1 METHOD2
    LOAD    X2
    ADD     X3
    SUB     FOUR
    STORE   DIFFX
    LOAD    Y2
    SUB     Y3
    JPOS    D6STORE
    JZERO   D6STORE
    CALL    NEGATE
    JUMP    D6STORE

D6STORE:
    ADD DIFFX
    STORE   DIST23


;--------- Calculating the total distances
    LOAD    DIST01
    ADD     DIST12
    ADD     DIST23
    STORE   DP1     ;DP1
    LOAD    DIST01
    ADD     DIST13
    ADD     DIST23
    STORE   DP2     ;DP2
    LOAD    DIST02
    ADD     DIST12
    ADD     DIST13
    STORE   DP3     ;DP3
    LOAD    DIST02
    ADD     DIST23
    ADD     DIST13
    STORE   DP4     ; DP4
    LOAD    DIST03
    ADD     DIST13
    ADD     DIST12
    STORE   DP5     ; DP5
    LOAD    DIST03
    ADD     DIST23
    ADD     DIST12
    STORE   DP6     ; DP6

;; --------- DETERMINE SHORTEST PATH
    LOAD    DP1
    SUB     DP2
    JPOS    SELDP2
    LOAD    DP1
    SUB     DP3
    JPOS    MINDP3
    LOADI   1
    STORE   DPX
    JUMP    SECCMP

SELDP2:
    LOAD    DP2
    SUB     DP3
    JPOS    MINDP3
    LOADI   2
    STORE   DPX
    JUMP    SECCMP


MINDP3:
    LOADI   3
    STORE   DPX

SECCMP:
    LOAD    DP4
    SUB     DP5
    JPOS    SELDP5
    LOAD    DP4
    SUB     DP5
    JPOS    MINDP6
    LOADI   4
    STORE   DPY
    JUMP    TRDCMP

SELDP5:
    LOAD    DP5
    SUB     DP6
    JPOS    MINDP6
    LOADI   5
    STORE   DPY
    JUMP    TRDCMP


MINDP6:
    LOADI   6
    STORE   DPY

TRDCMP:
    LOAD    DPX
    CALL    GETDP
    STORE   DPXV
    LOAD    DPY
    CALL    GETDP
    STORE   DPYV
    SUB     DPXV    ; LAST CMP
    JNEG    SELY
    LOAD    DPX
    STORE   PATH
    JUMP    ENDCMP

SELY:
    LOAD    DPY
    STORE   PATH

ENDCMP:
;------------------------------ NOW THE PATH IS SELECTED,

GETTO:          ; GET TO THE THREE POINTS ACCORDING TO THE PATH SELECTED.
    LOAD    PATH
    SUB     ONE
    JPOS    PATHNOT1
    ; OTHERWOSE IS 1
    CALL    POINT11
    CALL    POINT22
    CALL    POINT33
    JUMP    ENDPATH

PATHNOT1:
    SUB     ONE
    JPOS    PATHNOT2
    CALL    POINT11
    CALL    POINT23
    CALL    POINT32
    JUMP    ENDPATH

PATHNOT2:
    SUB     ONE
    JPOS    PATHNOT3
    CALL    POINT12
    CALL    POINT21
    CALL    POINT33
    JUMP    ENDPATH

PATHNOT3:
    SUB     ONE
    JPOS    PATHNOT4
    CALL    POINT12
    CALL    POINT13
    CALL    POINT31
    JUMP    ENDPATH

PATHNOT4:
    SUB     ONE
    JPOS    PATHNOT5
    CALL    POINT13
    CALL    POINT21
    CALL    POINT32
    JUMP    ENDPATH

PATHNOT5:
    CALL    POINT13
    CALL    POINT22
    CALL    POINT31
    JUMP    ENDPATH

ENDPATH:
    LOAD    X0
    STORE   STARTX
    LOAD    Y0
    STORE   STARTY
    LOAD    R0
    STORE   STARTR

TOPOINT1:
    LOAD    GOX1
    STORE   TOX
    LOAD    GOY1
    STORE   TOY
    LOAD    GOR1
    STORE   TOR

    CALL    PTOP


TOPOINT2:
    LOAD    GOX1
    STORE   STARTX
    LOAD    GOY1
    STORE   STARTY
    LOAD    GOR1
    STORE   STARTR

    LOAD    GOX2
    STORE   TOX
    LOAD    GOY2
    STORE   TOY
    LOAD    GOR2
    STORE   TOR

    CALL    PTOP

    ; TEST
    LOAD    STEPX
    OUT     SSEG1
    LOAD    STEPY
    OUT     SSEG2
    LOAD    DIR
    OUT     LCD
    ; test

TOPOINT3:
    LOAD    GOX2
    STORE   STARTX
    LOAD    GOY2
    STORE   STARTY
    LOAD    GOR2
    STORE   STARTR

    LOAD    GOX3
    STORE   TOX
    LOAD    GOY3
    STORE   TOY
    LOAD    GOR3
    STORE   TOR

    CALL    PTOP

; dist 02
; dist 03

JUMP    Main

;***************************************************************
;* Subroutines
;***************************************************************

; pseudo subroutine holding place for Stephen's code
STEPHEN:
    RETURN

; PATH TO PATH. FROM START TO TO.
; OUT: STEPX, STEPY, DIR: 0 first X then Y, 1 first Y then X
PTOP:
    LOAD    STARTR
    SUB     ONE
    JPOS    STARTNOTR1
    LOADI   0   ; start in r1
    STORE   DIR
    LOAD    TOR
    SUB     THREE
    JZERO   ENDR3
    ; NOT ENDING IN R3
    CALL    CALDIFF
    CALL    STEPHEN
    JUMP    ENDPTOP
ENDR3:
    CALL    SINTEMP
    CALL    CALDIFF
    CALL    STEPHEN
    LOADI   1
    STORE   DIR
    CALL    RETRIEVE
    CALL    CALDIFF
    CALL    STEPHEN
    JUMP    ENDPTOP

STARTNOTR1:     ; start in r2
    SUB     ONE
    JPOS    STARTNOTR2
    LOADI   1
    STORE   DIR
    CALL    CALDIFF
    CALL    STEPHEN
    JUMP    ENDPTOP


STARTNOTR2:     ; start in r3
    LOADI   0
    STORE   DIR
    LOAD    TOR
    SUB     ONE
    JZERO   ENDR1
    CALL    CALDIFF
    CALL    STEPHEN
    JUMP    ENDPTOP
ENDR1:
    CALL    SINTEMP
    CALL    CALDIFF
    CALL    STEPHEN
    LOADI   1
    STORE   DIR
    CALL    RETRIEVE
    CALL    CALDIFF
    CALL    STEPHEN
    JUMP    ENDPTOP

ENDPTOP:
    RETURN

CALDIFF:    ; HELPER OF ABOVE, CALCULATE DIFFERENCES IN X AND Y
    LOAD    TOX
    SUB     STARTX
    STORE   STEPX
    LOAD    TOY
    SUB     STARTY
    STORE   STEPY
    RETURN

SINTEMP:    ; STORE THE TO POINTS IN TEMP
            ; SET TO POINTS TO BE 2
    LOAD    TOX
    STORE   TEMPX
    LOAD    TOY
    STORE   TEMPY
    LOADI   2
    STORE   TOX
    STORE   TOY
    RETURN

RETRIEVE:   ; BEGIN FROM MID GOTO TO
    LOADI   2
    STORE   STARTX
    STORE   STARTY
    LOAD    TEMPX
    STORE   TOX
    LOAD    TEMPY
    STORE   TOY
    RETURN

; Subroutine to negate AC value
NEGATE:     ; NEGATE AC
    STORE   ACCUM
    LOADI   0
    SUB     ACCUM
    RETURN

;; GET THE VALUE OF DP BASED ON INDEX IN ACCUM.
GETDP:
    STORE   ACCUM
    LOAD    ACCUM
    SUB     ONE
    JPOS    DPNOT1
    ; OTHERWOSE IS 1
    LOAD    DP1
    JUMP    ENDDP

DPNOT1:
    SUB     ONE
    JPOS    DPNOT2
    LOAD    DP2
    JUMP    ENDDP

DPNOT2:
    SUB     ONE
    JPOS    DPNOT3
    LOAD    DP3
    JUMP    ENDDP

DPNOT3:
    SUB     ONE
    JPOS    DPNOT4
    LOAD    DP4
    JUMP    ENDDP

DPNOT4:
    SUB     ONE
    JPOS    DPNOT5
    LOAD    DP5
    JUMP    ENDDP

DPNOT5:
    LOAD    DP6
    JUMP    ENDDP

ENDDP:
    STORE   DPSEL
    RETURN

POINT11:        ; POINT ONE IS X1
    LOAD    X1
    STORE   GOX1
    LOAD    Y1
    STORE   GOY1
    LOAD    R1
    STORE   GOR1
    RETURN

POINT12:        ; POINT ONE IS X2
    LOAD    X2
    STORE   GOX1
    LOAD    Y2
    STORE   GOY1
    LOAD    R2
    STORE   GOR1
    RETURN

POINT13:        ; POINT ONE IS X3
    LOAD    X3
    STORE   GOX1
    LOAD    Y3
    STORE   GOY1
    LOAD    R3
    STORE   GOR1
    RETURN

POINT21:        ; POINT TWO IS X1
    LOAD    X1
    STORE   GOX2
    LOAD    Y1
    STORE   GOY2
    LOAD    R1
    STORE   GOR2
    RETURN

POINT22:        ; POINT TWO IS X2
    LOAD    X2
    STORE   GOX2
    LOAD    Y2
    STORE   GOY2
    LOAD    R2
    STORE   GOR2
    RETURN

POINT23:        ; POINT TWO IS X3
    LOAD    X3
    STORE   GOX2
    LOAD    Y3
    STORE   GOY2
    LOAD    R3
    STORE   GOR2
    RETURN

POINT31:        ; POINT THREE IS X1
    LOAD    X1
    STORE   GOX3
    LOAD    Y1
    STORE   GOY3
    LOAD    R1
    STORE   GOR3
    RETURN

POINT32:        ; POINT THREE IS X2
    LOAD    X2
    STORE   GOX3
    LOAD    Y2
    STORE   GOY3
    LOAD    R2
    STORE   GOR3
    RETURN

POINT33:        ; POINT THREE IS X2
    LOAD    X3
    STORE   GOX3
    LOAD    Y3
    STORE   GOY3
    LOAD    R3
    STORE   GOR3
    RETURN

; INPUTS
X0:     DW      &H0001  ; addr H010, VALUE 0
Y0:     DW      &H0001
D0:     DW      &H0000
R0:     DW      &H0001

X1:     DW      &H0003
Y1:     DW      &H0002
R1:     DW      &H0002

GOX1:   DW      &H0000
GOY1:   DW      &H0000
GOR1:   DW      &H0000

X2:     DW      &H0003
Y2:     DW      &H0003
R2:     DW      &H0000

GOX2:   DW      &H0000
GOY2:   DW      &H0000
GOR2:   DW      &H0000

X3:     DW      &H0003
Y3:     DW      &H0004
R3:     DW      &H0000

GOX3:   DW      &H0000
GOY3:   DW      &H0000
GOR3:   DW      &H0000

STARTX: DW      &H0000
STARTY: DW      &H0000
STARTR: DW      &H0000

TOX:    DW      &H0000
TOY:    DW      &H0000
TOR:    DW      &H0000

TEMPX:  DW      &H0000
TEMPY:  DW      &H0000
; TEMPR:    DW      &H0000

STEPX:  DW      &H0000
STEPY:  DW      &H0000
DIR:    DW      &H0000

;****** the six distances between the possible pairs of points ***
ACCUM:  DW  0
DIFFX:  DW  0

DIST01: DW  0
DIST02: DW  0
DIST03: DW  0
DIST12: DW  0
DIST13: DW  0
DIST23: DW  0

DP1:    DW  0
DP2:    DW  0
DP3:    DW  0
DP4:    DW  0
DP5:    DW  0
DP6:    DW  0
DPSEL:  DW  0       ; what GETDP returns at a given index in accum
DPX:    DW  0       ; temp index of min among three
DPXV:   DW  0
DPY:    DW  0       ; temp index of min among three
DPYV:   DW  0
PATH:   DW  0       ; an index; 1 through 6

GOX:    DW  0
GOY:    DW  0
