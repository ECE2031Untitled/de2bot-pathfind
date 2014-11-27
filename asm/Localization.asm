Localization:
	OUT    RESETPOS    ; reset odometry in case wheels moved after programming

; ------------------- BEGINNING  OF LOCALIZATION CODE --------------------------------------------------------------------------------------------
	;----------------------------------------------------
	LOADI &B100001
    OUT SONAREN ; turn on sonars 0 and 5
    ; -------------get N1 from SENSOR 0

    CALL Wait1

	IN DIST0  ; take in distance from 0th
	OUT SSEG1  ;
    STORE TEMPDIST0

    IN DIST5  ; take in distance from 5th
	OUT SSEG2  ;
    STORE TEMPDIST5


    CALL Wait1

;
;
    ; SIGNATURE
    LOADI 0
    STORE RESULT
  ;-----------------------------------
    LOAD TEMPDIST0
    DivLoop:
       SUB DIVBY
       STORE TEMPDIST0

       JNEG StoreSig


       LOAD RESULT
       ADDI 1
       STORE RESULT

       LOAD TEMPDIST0
       JUMP DivLoop

    StoreSig:
        LOAD RESULT
        STORE N3
    ;------------------------------
   	LOADI 0
   	STORE RESULT
    LOAD TEMPDIST5
    DivLoop1:
       SUB DIVBY
       STORE TEMPDIST5

       JNEG StoreSig1

       LOAD RESULT
       ADDI 1
       STORE RESULT

       LOAD TEMPDIST5
       JUMP DivLoop1

    StoreSig1:
        LOAD RESULT
        STORE N1
        ;----------------

    LOAD N3
    OUT SSEG1
    LOAD N1
    OUT SSEG2


    CALL Wait1

    CALL Wait1



;------------------ ROTATE ----------------------------------------
   LOADI 0
    OUT RESETPOS
    Rotate:
		LOAD  FSpeed
		OUT   RVELCMD
		LOAD  RSpeed
		OUT   LVELCMD
		IN THETA
		SUB  DegCust
		JNEG Rotate


	LOAD  0
	OUT   RVELCMD
	LOAD  0
	OUT   LVELCMD

;----GET SECOND PAIR OF VALS--------------------------------------------

   CALL Wait1

 	IN DIST0  ; take in distance from 0th
	OUT SSEG1  ;
    STORE TEMPDIST0

    IN DIST5  ; take in distance from 5th
	OUT SSEG2  ;
    STORE TEMPDIST5

    CALL Wait1

    LOADI 0
    STORE RESULT
  ;-----------------------------------
    LOAD TEMPDIST0
    DivLoop2:
       SUB DIVBY
       STORE TEMPDIST0

       JNEG StoreSig2


       LOAD RESULT
       ADDI 1
       STORE RESULT

       LOAD TEMPDIST0
       JUMP DivLoop2

    StoreSig2:
        LOAD RESULT
        STORE N2
   ;---------------
   	LOADI 0
   	STORE RESULT
    LOAD TEMPDIST5
    DivLoop3:
       SUB DIVBY
       STORE TEMPDIST5

       JNEG StoreSig3

       LOAD RESULT
       ADDI 1
       STORE RESULT

       LOAD TEMPDIST5
       JUMP DivLoop3

    StoreSig3:
        LOAD RESULT
        STORE N4
        ;----------------

    LOAD N2
    OUT SSEG1
    LOAD N4
    OUT SSEG2

    CALL Wait1

    CALL Wait1



    LOADI 0
    OUT SSEG1
    LOADI 0
    OUT SSEG2

    CALL Wait1
    CALL Wait1



LOAD N1
SHIFT 4
OR N2
SHIFT 4
OR N3
SHIFT 4
OR N4


STORE N1234

;     LOAD N1234
;     OUT SSEG1
;






;---------------------------------------------------------------------------------
;
; MAKE THE ALIASES FOR THE VALUES

;MAKE M VALS (VALUES IF WE ROTATED BY 90 DEG TO THE RIGHT)
LOAD N4
STORE M1

LOAD N1
STORE M2

LOAD N2
STORE M3

LOAD N3
STORE M4



;MAKE P VALS (VALUES IF WE ROTATED BY 180 DEG TO THE RIGHT)
LOAD N3
STORE P1

LOAD N4
STORE P2

LOAD N1
STORE P3

LOAD N2
STORE P4


;MAKE Q VALS (VALUES IF WE ROTATED BY ANOTHER 270 DEG TO THE RIGHT)
LOAD N2
STORE Q1

LOAD N3
STORE Q2

LOAD N4
STORE Q3

LOAD N1
STORE Q4
;

; ; STORE THESE INDIVIDUAL INTO WORDS, THIS WAY THEY CAN BE XOR WITH OUR SIGNATURES (ESSENTIALLY, COMPARED)

; STORE M1, M2, M3, M4 INTO A WORD
LOAD M1
SHIFT 4
OR M2
SHIFT 4
OR M3
SHIFT 4
OR M4

STORE M1234
;
; ; STORE P1, P2, P3, P4 INTO A WORD
LOAD P1
SHIFT 4
OR P2
SHIFT 4
OR P3
SHIFT 4
OR P4

STORE P1234
;
; STORE Q1, Q2, Q3, Q4
LOAD Q1
SHIFT 4
OR Q2
SHIFT 4
OR Q3
SHIFT 4
OR Q4

STORE Q1234


; ; ; NOW COMPARE TO THE SIGNATURES WE HAVE, USING XOR
; ;
;----compare to 1,1-------------------------
CompareTo11:
    LOAD N1234
	STORE TEMPSIG
	XOR SIG11
	JZERO FoundSig11

	LOAD M1234
	STORE TEMPSIG
	XOR SIG11
	JZERO FoundSig11

	LOAD P1234
	STORE TEMPSIG
	XOR SIG11
	JZERO FoundSig11

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG11
	JZERO FoundSig11

    JUMP CompareTo12

    FoundSig11:
   	 	LOADI 1
    	STORE X0
    	LOADI 1
    	STORE Y0

;------------------------------------------
;----compare to 1,2-------------------------
CompareTo12:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG12
	JZERO FoundSig12

	LOAD M1234
	STORE TEMPSIG
	XOR SIG12
	JZERO FoundSig12

	LOAD P1234
	STORE TEMPSIG
	XOR SIG12
	JZERO FoundSig12

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG12
	JZERO FoundSig12

	JUMP CompareTo13

	 FoundSig12:
   	 	LOADI 1
    	STORE X0
    	LOADI 2
    	STORE Y0

;------------------------------------------
  ;----compare to 1,3-------------------------
 CompareTo13:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG13
	JZERO FoundSig13

	LOAD M1234
	STORE TEMPSIG
	XOR SIG13
	JZERO FoundSig13

	LOAD P1234
	STORE TEMPSIG
	XOR SIG13
	JZERO FoundSig13

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG13
	JZERO FoundSig13

	JUMP CompareTo14

	 FoundSig13:
   	 	LOADI 1
    	STORE X0
    	LOADI 3
    	STORE Y0

;------------------------------------------
;----compare to 1,4-------------------------    --
CompareTo14:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG14
	JZERO FoundSig14

	LOAD M1234
	STORE TEMPSIG
	XOR SIG14
	JZERO FoundSig14

	LOAD P1234
	STORE TEMPSIG
	XOR SIG14
	JZERO FoundSig14

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG14
	JZERO FoundSig14

	JUMP CompareTo21

	 FoundSig14:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0

;------------------------------------------
;----compare to 2,1-------------------------
CompareTo21:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG21
	JZERO FoundSig21

	LOAD M1234
	STORE TEMPSIG
	XOR SIG21
	JZERO FoundSig21

	LOAD P1234
	STORE TEMPSIG
	XOR SIG21
	JZERO FoundSig21

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG21
	JZERO FoundSig21

	JUMP CompareTo22

	 FoundSig21:
   	 	LOADI 2
    	STORE X0
    	LOADI 1
    	STORE Y0

;------------------------------------------
;----compare to 2,2-------------------------
CompareTo22:

	LOAD N1234
	STORE TEMPSIG
	XOR SIG22
	JZERO FoundSig22

	LOAD M1234
	STORE TEMPSIG
	XOR SIG22
	JZERO FoundSig22

	LOAD P1234
	STORE TEMPSIG
	XOR SIG22
	JZERO FoundSig22



	LOAD Q1234
	STORE TEMPSIG
	XOR SIG22
	JZERO FoundSig22

	JUMP CompareTo23

	 FoundSig22:
   	 	LOADI 2
    	STORE X0
    	LOADI 2
    	STORE Y0

;------------------------------------------
	;----compare to 2,3-------------------------
	CompareTo23:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG23
	JZERO FoundSig23

	LOAD M1234
	STORE TEMPSIG
	XOR SIG23
	JZERO FoundSig23

	LOAD P1234
	STORE TEMPSIG
	XOR SIG23
	JZERO FoundSig23

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG23
	JZERO FoundSig23

	JUMP CompareTo24

	 FoundSig23:
   	 	LOADI 2
    	STORE X0
    	LOADI 3
    	STORE Y0

;------------------------------------------
;----compare to 2,4-------------------------
CompareTo24:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG24
	JZERO FoundSig24

	LOAD M1234
	STORE TEMPSIG
	XOR SIG24
	JZERO FoundSig24

	LOAD P1234
	STORE TEMPSIG
	XOR SIG24
	JZERO FoundSig24

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG24
	JZERO FoundSig24

	JUMP CompareTo31
	FoundSig24:
   	 	LOADI 2
    	STORE X0
    	LOADI 4
    	STORE Y0

;------------------------------------------
;----compare to 3,1-------------------------
CompareTo31:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG31
	JZERO FoundSig31

	LOAD M1234
	STORE TEMPSIG
	XOR SIG31
	JZERO FoundSig31

	LOAD P1234
	STORE TEMPSIG
	XOR SIG31
	JZERO FoundSig31

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG31
	JZERO FoundSig31

	JUMP CompareTo32
	FoundSig31:
   	 	LOADI 3
    	STORE X0
    	LOADI 1
    	STORE Y0

;------------------------------------------
;----compare to 3,2-------------------------
CompareTo32:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG32
	JZERO FoundSig32

	LOAD M1234
	STORE TEMPSIG
	XOR SIG32
	JZERO FoundSig32

	LOAD P1234
	STORE TEMPSIG
	XOR SIG32
	JZERO FoundSig32

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG32
	JZERO FoundSig32

	JUMP CompareTo33
	FoundSig32:
   	 	LOADI 3
    	STORE X0
    	LOADI 2
    	STORE Y0

;------------------------------------------
;----compare to 3,3-------------------------
CompareTo33:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG33
	JZERO FoundSig33

	LOAD M1234
	STORE TEMPSIG
	XOR SIG33
	JZERO FoundSig33

	LOAD P1234
	STORE TEMPSIG
	XOR SIG33
	JZERO FoundSig33

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG33
	JZERO FoundSig33

	JUMP CompareTo34
	FoundSig33:
   	 	LOADI 3
    	STORE X0
    	LOADI 3
    	STORE Y0

;------------------------------------------
;----compare to 3,4-------------------------
CompareTo34:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG34
	JZERO FoundSig34

	LOAD M1234
	STORE TEMPSIG
	XOR SIG34
	JZERO FoundSig34

	LOAD P1234
	STORE TEMPSIG
	XOR SIG34
	JZERO FoundSig34

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG34
	JZERO FoundSig34

	JUMP CompareTo41
	FoundSig34:
   	 	LOADI 3
    	STORE X0
    	LOADI 4
    	STORE Y0

;------------------------------------------
;----compare to 4,1-------------------------
CompareTo41:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG41
	JZERO FoundSig41

	LOAD M1234
	STORE TEMPSIG
	XOR SIG41
	JZERO FoundSig41

	LOAD P1234
	STORE TEMPSIG
	XOR SIG41
	JZERO FoundSig41

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG41
	JZERO FoundSig41

	JUMP CompareTo42
	FoundSig41:
   	 	LOADI 4
    	STORE X0
    	LOADI 1
    	STORE Y0

;------------------------------------------
;----compare to 4,2-------------------------
CompareTo42:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG42
	JZERO FoundSig42

	LOAD M1234
	STORE TEMPSIG
	XOR SIG42
	JZERO FoundSig42

	LOAD P1234
	STORE TEMPSIG
	XOR SIG42
	JZERO FoundSig42

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG42
	JZERO FoundSig42

	JUMP CompareTo43
	FoundSig42:
   	 	LOADI 4
    	STORE X0
    	LOADI 2
    	STORE Y0

;------------------------------------------
;----compare to 4,3-------------------------
CompareTo43:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG43
	JZERO FoundSig43

	LOAD M1234
	STORE TEMPSIG
	XOR SIG43
	JZERO FoundSig43

	LOAD P1234
	STORE TEMPSIG
	XOR SIG43
	JZERO FoundSig43

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG43
	JZERO FoundSig43

	JUMP CompareTo44
	FoundSig43:
   	 	LOADI 4
    	STORE X0
    	LOADI 3
    	STORE Y0

;------------------------------------------
;----compare to 4,4-------------------------
CompareTo44:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG44
	JZERO FoundSig44

	LOAD M1234
	STORE TEMPSIG
	XOR SIG44
	JZERO FoundSig44

	LOAD P1234
	STORE TEMPSIG
	XOR SIG44
	JZERO FoundSig44

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG44
	JZERO FoundSig44

	JUMP CompareTo53
	FoundSig44:
   	 	LOADI 4
    	STORE X0
    	LOADI 4
    	STORE Y0

;------------------------------------------
;----compare to 5,3-------------------------
CompareTo53:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG53
	JZERO FoundSig53

	LOAD M1234
	STORE TEMPSIG
	XOR SIG53
	JZERO FoundSig53

	LOAD P1234
	STORE TEMPSIG
	XOR SIG53
	JZERO FoundSig53

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG53
	JZERO FoundSig53

	JUMP CompareTo54
	FoundSig53:
   	 	LOADI 5
    	STORE X0
    	LOADI 3
    	STORE Y0

;------------------------------------------
;----compare to 5,4-------------------------
CompareTo54:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG54
	JZERO FoundSig54

	LOAD M1234
	STORE TEMPSIG
	XOR SIG54
	JZERO FoundSig54

	LOAD P1234
	STORE TEMPSIG
	XOR SIG54
	JZERO FoundSig54

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG54
	JZERO FoundSig54

	JUMP CompareTo64
	FoundSig54:
   	 	LOADI 5
    	STORE X0
    	LOADI 4
    	STORE Y0

;------------------------------------------
;----compare to 6,4-------------------------
CompareTo64:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG64
	JZERO FoundSig64

	LOAD M1234
	STORE TEMPSIG
	XOR SIG64
	JZERO FoundSig64

	LOAD P1234
	STORE TEMPSIG
	XOR SIG64
	JZERO FoundSig64

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG64
	JZERO FoundSig64

	JUMP CompareTo641
	FoundSig64:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0



  ;----compare to 6,4 1-------------------------
CompareTo641:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG64_1
	JZERO FoundSig641

	LOAD M1234
	STORE TEMPSIG
	XOR SIG64_1
	JZERO FoundSig641

	LOAD P1234
	STORE TEMPSIG
	XOR SIG64_1
	JZERO FoundSig641

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG64_1
	JZERO FoundSig641

	JUMP CompareTo642
	FoundSig641:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0



    	;----compare to 6,4 2-------------------------
CompareTo642:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG64_2
	JZERO FoundSig642

	LOAD M1234
	STORE TEMPSIG
	XOR SIG64_2
	JZERO FoundSig642

	LOAD P1234
	STORE TEMPSIG
	XOR SIG64_2
	JZERO FoundSig642

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG64_2
	JZERO FoundSig642

	JUMP CompareTo141
	FoundSig642:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0



    ;----compare to 1,4 1-------------------------
CompareTo141:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG14_1
	JZERO FoundSig141

	LOAD M1234
	STORE TEMPSIG
	XOR SIG14_1
	JZERO FoundSig141

	LOAD P1234
	STORE TEMPSIG
	XOR SIG14_1
	JZERO FoundSig141

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG14_1
	JZERO FoundSig141

	JUMP CompareTo142
	FoundSig141:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0


    ;----compare to 1,4 2-------------------------
    CompareTo142:
	LOAD N1234
	STORE TEMPSIG
	XOR SIG14_2
	JZERO FoundSig142

	LOAD M1234
	STORE TEMPSIG
	XOR SIG14_2
	JZERO FoundSig142

	LOAD P1234
	STORE TEMPSIG
	XOR SIG14_2
	JZERO FoundSig142

	LOAD Q1234
	STORE TEMPSIG
	XOR SIG14_2
	JZERO FoundSig142

	JUMP OutofCheck
	FoundSig142:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0


;------------------------------------------

OutofCheck:
    ;; Output 0X0Y to the SSEG
    LOAD    X0
    SHIFT   8
    OR      Y0
    OUT     SSEG1

    ;; Reset the timer and start the beeping
    OUT     TIMER
    LOADI   4
    OUT     BEEP

LocalizationBeepWait:
    IN      TIMER
    ADDI    -10
    JNEG    LocalizationBeepWait

    ;; Turn off the beeping after one second
    LOADI   0
    OUT     BEEP

LocalizationWait:
    IN      TIMER
    ADDI    -30
    JNEG    LocalizationWait

    ;; Finally done
    RETURN



;-----------------------------------------------------------


	;declare signatures for all locations in HEX, these can be accessed later for comparison to the input
	DERP:    DW 0
	DIVBY:    DW 552
	 ;this is the value we're "dividing" by. 610mm
	RESULT:   DW 0
	ONESEC:   DW 10
	TEMPSIG:  DW &H0000
	TEMPDIST0: DW 0
	TEMPDIST5: DW 0
	DegCust:   DW 77
; vals for word
	N1:       DW 0
	N2:       DW 0
	N3:       DW 0
	N4:       DW 0

	N1234:    DW &H0000

;word rotate 90 to the right
	M1:       DW 0
	M2:       DW 0
	M3:       DW 0
	M4:       DW 0

	M1234:    DW &H0000


;word rotate  180 to the right
	P1:       DW 0
	P2:       DW 0
	P3:       DW 0
	P4:       DW 0

	P1234:    DW &H0000

;word rotate another 270 to the right
	Q1:       DW 0
	Q2:       DW 0
	Q3:       DW 0
	Q4:       DW 0

	Q1234:    DW &H0000





    SIG11:    DW &H3300
    SIG12:    DW &H2310
    SIG13:    DW &H1420
    SIG14:    DW &H0530
    SIG21:    DW &H3201
    SIG22:    DW &H2211
    SIG23:    DW &H1321
    SIG24:    DW &H0431
    SIG31:    DW &H1102
    SIG32:    DW &H0112
    SIG33:    DW &H1202
    SIG34:    DW &H0312
    SIG41:    DW &H1003
    SIG42:    DW &H0013
    SIG43:    DW &H1103
    SIG44:    DW &H0213
    SIG53:    DW &H1004
    SIG54:    DW &H0114
    SIG64:    DW &H0005

    SIG64_1:    DW &H0004 ; these are just in case of errors, where 5 blocks is read as 4 or 6
    SIG64_2:    DW &H0006

    SIG14_1:    DW &H0430  ; these are just in case of errors, where 5 blocks is read as 4 or 6
    SIG14_2:    DW &H0630
