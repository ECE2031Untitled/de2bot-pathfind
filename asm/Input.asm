;;--- void GetCoordinates() ----------------------------------------------------
;; Gets the three desired coordinates from the switches.
;;
;; Sets the following global values:
;;     X1, Y1 - The first coordinate
;;     X2, Y2 - The second coordinate
;;     X3, Y3 - The third coordinate
;;------------------------------------------------------------------------------
GetCoordinates:
    IN      XIO
    AND     GetCoordinatesKey3Mask
    JPOS    GetCoordinatesDontExit
    RETURN

GetCoordinatesDontExit:
    IN      SWITCHES
    AND     Three
    STORE   Y1

    IN      SWITCHES
    AND     TwentyEight
    SHIFT   -2
    STORE   X1

    IN      SWITCHES
    SHIFT   -5
    AND     Three
    STORE   Y2

    IN      SWITCHES
    SHIFT   -5
    AND     TwentyEight
    SHIFT   -2
    STORE   X2

    IN      SWITCHES
    SHIFT   -10
    AND     Three
    STORE   Y3

    IN      SWITCHES
    SHIFT   -10
    AND     TwentyEight
    SHIFT   -2
    STORE   X3

    ; CREATE DISPLAY ON SEVENSEG LEDS: This will go x1y1, x2y2, x3,y3,

    LOAD    X1
    SHIFT   12
    STORE   InputsTemp1
    LOAD    Y1
    SHIFT   8
    OR      InputsTemp1
    STORE   InputsTemp1
    LOAD    X2
    shift   4
    STORE   InputsTemp2
    LOAD    Y2
    OR      InputsTemp2
    OR      InputsTemp1
    OUT     SSEG1

    LOAD    X3
    SHIFT   12
    STORE   InputsTemp1
    LOAD    Y3
    SHIFT   8
    OR      InputsTemp1
    OUT     SSEG2

    ;; TODO, break if a certain button is pressed

    JUMP   GetCoordinates

;;--- int InputsTemp1, InputsTemp2 ---------------------------------------------
;; Temporary variables for calculating the inputs.
;;------------------------------------------------------------------------------
InputsTemp1: DW 0
InputsTemp2: DW 0

GetCoordinatesKey3Mask:
    DW      &B0000000000000100
