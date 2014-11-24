#include "Devices.asm"
#include "Constant.asm"
#include "Util.asm"

;;--- void ShortestPathFindRegion(int *x, int *y, int *r) ----------------------
;;
;;------------------------------------------------------------------------------
ShortestPathFindRegionX: DW 0
ShortestPathFindRegionY: DW 0
ShortestPathFindRegionR: DW 0

ShortestPathFindRegion:
        ILOAD   ShortestPathFindRegionX ; AC = *X
        SUB     TWO     ; AC = X0 - 2
        JPOS    ROnth0  ; This point is on the right side. So region1 or region3 (RTwth:
                        ; Otherwise: region 2
        LOADI   2       ; In Reg 2, AC = 2
        JUMP    DR0

ROnth0: ILOAD   ShortestPathFindRegionY ; AC = Y0
        SUB     TWO     ; AC = Y0 - 2
        JPOS    ROne0   ; if Y0 - 2 > 0, then in region one
        LOADI   3       ; Otherwise , region 3
        JUMP    DR0

ROne0:  LOADI   1
        JUMP    DR0

DR0:    ISTORE   ShortestPathFindRegionR ; Store what's in the AC into addr R0
    RETURN

;;--- void ShortestPathCalcDist(int *x1, int *x2, int *y1, int *y2, int *r1, int *r2, int *dist)
;;
;;------------------------------------------------------------------------------
ShortestPathCalcDistX1: DW 0
ShortestPathCalcDistX2: DW 0
ShortestPathCalcDistY1: DW 0
ShortestPathCalcDistY2: DW 0
ShortestPathCalcDistR1: DW 0
ShortestPathCalcDistR2: DW 0
ShortestPathCalcDistDist: DW 0

ShortestPathCalcDistTemp: DW 0

ShortestPathCalcDist:
    ILOAD   ShortestPathCalcDistR1      ; AC = RO
    SUB     ONE
    JPOS    D1NOTR1 ; START POINT NOT IN R1
    ; STARTING POINT IN R1
    ILOAD   ShortestPathCalcDistR2      ; AC = R1
    SUB     THREE
    JZERO   CALD12  ; R0 = 1, R1 = 3
    JUMP    CALD11

D1NOTR1:        ; DISTANCE1  STARTING PT NOT R1
    ILOAD   ShortestPathCalcDistR1      ; AC = R0
    SUB     THREE
    JZERO   D1THREE     ;STARTING POINT IN R3
    JUMP    CALD11

D1THREE:
    ILOAD   ShortestPathCalcDistR2
    SUB     ONE
    JZERO   CALD12      ; ENDING POINT IN R1

CALD11:     ; DISTANCE 1 METHOD1
    ILOAD   ShortestPathCalcDistX2
    STORE   ShortestPathCalcDistTemp
    ILOAD   ShortestPathCalcDistX1
    SUB     ShortestPathCalcDistTemp
    JPOS    D1NEXT1
    JZERO   D1NEXT1
    CALL    Negate

D1NEXT1:
    STORE   DIFFX
    ILOAD   ShortestPathCalcDistY2
    STORE   ShortestPathCalcDistTemp
    ILOAD   ShortestPathCalcDistY1
    SUB     ShortestPathCalcDistTemp
    JPOS    D1STORE
    JZERO   D1STORE
    CALL    Negate
    JUMP    D1STORE

CALD12:     ; DISTANCE 1 METHOD2
    ILOAD   ShortestPathCalcDistX1
    STORE   ShortestPathCalcDistTemp
    ILOAD   ShortestPathCalcDistX2
    ADD     ShortestPathCalcDistTemp
    SUB     FOUR
    STORE   DIFFX
    ILOAD   ShortestPathCalcDistY2
    STORE   ShortestPathCalcDistTemp
    ILOAD   ShortestPathCalcDistY1
    SUB     ShortestPathCalcDistTemp
    JPOS    D1STORE
    JZERO   D1STORE
    CALL    Negate
    JUMP    D1STORE

D1STORE:
    ADD     DIFFX
    ISTORE  ShortestPathCalcDistDist
    RETURN

;;--- void ShortestPath() ------------------------------------------------------
;; ???
;;------------------------------------------------------------------------------
ShortestPath:

#define CALL_ShortestPathFindRegion(x, y, r)                                \
    __nl__ LOADI   x                                                        \
    __nl__ STORE   ShortestPathFindRegionX                                  \
    __nl__ LOADI   y                                                        \
    __nl__ STORE   ShortestPathFindRegionY                                  \
    __nl__ LOADI   r                                                        \
    __nl__ STORE   ShortestPathFindRegionR                                  \
    __nl__ CALL    ShortestPathFindRegion                                   \

    CALL_ShortestPathFindRegion(X0, Y0, R0)
    CALL_ShortestPathFindRegion(X1, Y1, R1)
    CALL_ShortestPathFindRegion(X2, Y2, R2)
    CALL_ShortestPathFindRegion(X3, Y3, R3)

#undef CALL_ShortestPathFindRegion

#define CALL_ShortestPathCalcDist(x1, x2, y1, y2, r1, r2, dist)             \
    __nl__ LOADI    x1                                                      \
    __nl__ STORE    ShortestPathCalcDistX1                                  \
    __nl__ LOADI    x2                                                      \
    __nl__ STORE    ShortestPathCalcDistX2                                  \
    __nl__ LOADI    y1                                                      \
    __nl__ STORE    ShortestPathCalcDistY1                                  \
    __nl__ LOADI    y2                                                      \
    __nl__ STORE    ShortestPathCalcDistY2                                  \
    __nl__ LOADI    r1                                                      \
    __nl__ STORE    ShortestPathCalcDistR1                                  \
    __nl__ LOADI    r2                                                      \
    __nl__ STORE    ShortestPathCalcDistR2                                  \
    __nl__ LOADI    dist                                                    \
    __nl__ STORE    ShortestPathCalcDistDist                                \
    __nl__ CALL     ShortestPathCalcDist                                    \

    CALL_ShortestPathCalcDist(X0, X1, Y0, Y1, R0, R1, DIST01)
    CALL_ShortestPathCalcDist(X0, X2, Y0, Y2, R0, R2, DIST02)
    CALL_ShortestPathCalcDist(X0, X3, Y0, Y3, R0, R3, DIST03)
    CALL_ShortestPathCalcDist(X1, X2, Y1, Y2, R1, R2, DIST12)
    CALL_ShortestPathCalcDist(X1, X3, Y1, Y3, R1, R3, DIST13)
    CALL_ShortestPathCalcDist(X2, X3, Y2, Y3, R2, R3, DIST23)

#undef CALL_ShortestPathCalcDist

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
    JUMP    NAV ;; Tail-call

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
; X, Y - Coordinates
; D - Direction (0, 1, 2, 3)
;; Starting position
X0:     DW      &H0001  ; addr H010, VALUE 0
Y0:     DW      &H0001
D0:     DW      &H0000
R0:     DW      &H0001

;; First coordinate
X1:     DW      &H0003
Y1:     DW      &H0002
R1:     DW      &H0002

GOX1:   DW      &H0000
GOY1:   DW      &H0000
GOR1:   DW      &H0000

;; Second coordinate
X2:     DW      &H0003
Y2:     DW      &H0003
R2:     DW      &H0000

GOX2:   DW      &H0000
GOY2:   DW      &H0000
GOR2:   DW      &H0000

;; Third coordinate
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

;; Outputs - Difference in x and y and whether to go X first then Y (DIR = 0),
;;           or Y first then X (DIR = 1).
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
