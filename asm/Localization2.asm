Localization:
	OUT    RESETPOS    ; reset odometry in case wheels moved after programming

; ------------------- BEGINNING OF LOCALIZATION CODE --------------------------------------------------------------------------------------------
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
;-----------------------------------------------------------------------------------------------------------
; ; ; NOW COMPARE TO THE SIGNATURES WE HAVE, USING XOR:

	LOAD N1234
	XOR SIG11W
	JZERO FoundSig11W
	
	LOAD N1234
	XOR SIG11S
	JZERO FoundSig11S
	
	LOAD N1234
	XOR SIG11E
	JZERO FoundSig11E
	
	LOAD N1234
	XOR SIG11N
	JZERO FoundSig11N
	;---------------------
	LOAD N1234
	XOR SIG12W
	JZERO FoundSig12W
	
	LOAD N1234
	XOR SIG12S
	JZERO FoundSig12S
	
	LOAD N1234
	XOR SIG12E
	JZERO FoundSig12E
	
    LOAD N1234
	XOR SIG12N
	JZERO FoundSig12N
	;-----------------------
	LOAD N1234
	XOR SIG13W
	JZERO FoundSig13W
	
	LOAD N1234
	XOR SIG13S
	JZERO FoundSig13S
	
	LOAD N1234
	XOR SIG13E
	JZERO FoundSig13E
	
	LOAD N1234
	XOR SIG13N
	JZERO FoundSig13N
	;-----------------------
	LOAD N1234
	XOR SIG14W
	JZERO FoundSig14W
	
	LOAD N1234
	XOR SIG14S
	JZERO FoundSig14S
	
	LOAD N1234
	XOR SIG14E
	JZERO FoundSig14E
	
	LOAD N1234
	XOR SIG14N
	JZERO FoundSig14N
	;-----------------------
	LOAD N1234
	XOR SIG21W
	JZERO FoundSig21W
	
	LOAD N1234
	XOR SIG21S
	JZERO FoundSig21S
	
	LOAD N1234
	XOR SIG21E
	JZERO FoundSig21E
	
	LOAD N1234
	XOR SIG21N
	JZERO FoundSig21N
	;-----------------------
	LOAD N1234
	XOR SIG22W
	JZERO FoundSig22W
	
	LOAD N1234
	XOR SIG22S
	JZERO FoundSig22S
	
	LOAD N1234
	XOR SIG22E
	JZERO FoundSig22E
	
	LOAD N1234
	XOR SIG22N
	JZERO FoundSig22N
	;-----------------------
	LOAD N1234
	XOR SIG23W
	JZERO FoundSig23W
	
	LOAD N1234
	XOR SIG23S
	JZERO FoundSig23S
	
	LOAD N1234
	XOR SIG23E
	JZERO FoundSig23E
	
	LOAD N1234
	XOR SIG23N
	JZERO FoundSig23N
	;-----------------------
	LOAD N1234
	XOR SIG24W
	JZERO FoundSig24W
	
	LOAD N1234
	XOR SIG24S
	JZERO FoundSig24S
	
	LOAD N1234
	XOR SIG24E
	JZERO FoundSig24E
	
	LOAD N1234
	XOR SIG24N
	JZERO FoundSig24N
	;-----------------------
	LOAD N1234
	XOR SIG31W
	JZERO FoundSig31W
	
	LOAD N1234
	XOR SIG31S
	JZERO FoundSig31S
	
	LOAD N1234
	XOR SIG31E
	JZERO FoundSig31E
	
    LOAD N1234
	XOR SIG31N
	JZERO FoundSig31N
	;-----------------------
	LOAD N1234
	XOR SIG32W
	JZERO FoundSig32W
	
	LOAD N1234
	XOR SIG32S
	JZERO FoundSig32S
	
	LOAD N1234
	XOR SIG32E
	JZERO FoundSig32E
	
	LOAD N1234
	XOR SIG32N
	JZERO FoundSig32N
	;-----------------------
	LOAD N1234
	XOR SIG33W
	JZERO FoundSig33W
	
	LOAD N1234
	XOR SIG33S
	JZERO FoundSig33S
	
	LOAD N1234
	XOR SIG33E
	JZERO FoundSig33E
	
	LOAD N1234
	XOR SIG33N
	JZERO FoundSig33N
	;-----------------------
	LOAD N1234
	XOR SIG34W
	JZERO FoundSig34W
	
	LOAD N1234
	XOR SIG34S
	JZERO FoundSig34S
	
	LOAD N1234
	XOR SIG34E
	JZERO FoundSig34E
	
	LOAD N1234
	XOR SIG34N
	JZERO FoundSig34N
	;-----------------------
	LOAD N1234
	XOR SIG41W
	JZERO FoundSig41W
	
	LOAD N1234
	XOR SIG41S
	JZERO FoundSig41S
	
	LOAD N1234
	XOR SIG41E
	JZERO FoundSig41E
	
	LOAD N1234
	XOR SIG41N
	JZERO FoundSig41N
	
	;-----------------------
	LOAD N1234
	XOR SIG42W
	JZERO FoundSig42W
	
	LOAD N1234
	XOR SIG42S
	JZERO FoundSig42S
	
	LOAD N1234
	XOR SIG42E
	JZERO FoundSig42E
	
	LOAD N1234
	XOR SIG42N
	JZERO FoundSig42N
	;-----------------------
	LOAD N1234
	XOR SIG43W
	JZERO FoundSig43W
	
	LOAD N1234
	XOR SIG43S
	JZERO FoundSig43S
	
	LOAD N1234
	XOR SIG43E
	JZERO FoundSig43E
	
	LOAD N1234
	XOR SIG43N
	JZERO FoundSig43N	
	;-----------------------
	LOAD N1234
	XOR SIG44W
	JZERO FoundSig44W
	
	LOAD N1234
	XOR SIG44S
	JZERO FoundSig44S
	
	LOAD N1234
	XOR SIG44E
	JZERO FoundSig44E
	
	LOAD N1234
	XOR SIG44N 
	JZERO FoundSig44N
	
	;-----------------------
	LOAD N1234
	XOR SIG53W
	JZERO FoundSig53W
	
	LOAD N1234
	XOR SIG53S
	JZERO FoundSig53S
	
	LOAD N1234
	XOR SIG53E
	JZERO FoundSig53E
	
	LOAD N1234
	XOR SIG53N
	JZERO FoundSig53N
	;-----------------------
	LOAD N1234
	XOR SIG54W
	JZERO FoundSig54W
	
	LOAD N1234
	XOR SIG54S
	JZERO FoundSig54S
	
	LOAD N1234
	XOR SIG54E
	JZERO FoundSig54E
	
	LOAD N1234
	XOR SIG54N
	JZERO FoundSig54N
	;-----------------------
	LOAD N1234
	XOR SIG64W
	JZERO FoundSig64W
	
	LOAD N1234
	XOR SIG64S
	JZERO FoundSig64S
	
	LOAD N1234
	XOR SIG64E
	JZERO FoundSig64E
	
	LOAD N1234
	XOR SIG64N
	JZERO FoundSig64N
	
    

	
	
	
	



;-----------------------------------------------------
    FoundSig11W:
   	 	LOADI 1
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
     FoundSig11S:
   	 	LOADI 1
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
        
      FoundSig11E:
   	 	LOADI 1
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
      
       FoundSig11N:
   	 	LOADI 1
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	
	 FoundSig12W:
   	 	LOADI 1
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig12S:
   	 	LOADI 1
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
   
     FoundSig12E:
   	 	LOADI 1
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
     FoundSig12N:
   	 	LOADI 1
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    
   
	 FoundSig13W:
   	 	LOADI 1
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig13S:
   	 	LOADI 1
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig13E:
   	 	LOADI 1
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig13N:
   	 	LOADI 1
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	 FoundSig14W:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig14S:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig14E:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig14N:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
 
	 FoundSig21W:
   	 	LOADI 2
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig21S:
   	 	LOADI 2
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig21E:
   	 	LOADI 2
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig21N:
   	 	LOADI 2
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	 FoundSig22W:
   	 	LOADI 2
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
   	 FoundSig22S:
   	 	LOADI 2
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
   
   	 FoundSig22E:
   	 	LOADI 2
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
   	 FoundSig22N:
   	 	LOADI 2
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
 

	 FoundSig23W:
   	 	LOADI 2
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
     FoundSig23S:
   	 	LOADI 2
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
 
     FoundSig23E:
   	 	LOADI 2
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
     FoundSig23N:
   	 	LOADI 2
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig24W:
   	 	LOADI 2
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig24S:
   	 	LOADI 2
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig24E:
   	 	LOADI 2
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig24N:
   	 	LOADI 2
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig31W:
   	 	LOADI 3
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig31S:
   	 	LOADI 3
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig31E:
   	 	LOADI 3
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig31N:
   	 	LOADI 3
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	
	FoundSig32W:
   	 	LOADI 3
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig32S:
   	 	LOADI 3
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig32E:
   	 	LOADI 3
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig32N:
   	 	LOADI 3
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig33W:
   	 	LOADI 3
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig33S:
   	 	LOADI 3
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig33E:
   	 	LOADI 3
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig33N:
   	 	LOADI 3
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig34W:
   	 	LOADI 3
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig34S:
   	 	LOADI 3
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig34E:
   	 	LOADI 3
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig34N:
   	 	LOADI 3
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig41W:
   	 	LOADI 4
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig41S:
   	 	LOADI 4
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig41E:
   	 	LOADI 4
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig41N:
   	 	LOADI 4
    	STORE X0
    	LOADI 1
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig42W:
   	 	LOADI 4
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig42S:
   	 	LOADI 4
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig42E:
   	 	LOADI 4
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig42N:
   	 	LOADI 4
    	STORE X0
    	LOADI 2
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	

	FoundSig43W:
   	 	LOADI 4
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig43S:
   	 	LOADI 4
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig43E:
   	 	LOADI 4
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig43N:
   	 	LOADI 4
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	

	FoundSig44W:
   	 	LOADI 4
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig44S:
   	 	LOADI 4
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig44E:
   	 	LOADI 4
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig44N:
   	 	LOADI 4
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	
    	

	FoundSig53W:
   	 	LOADI 5
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig53S:
   	 	LOADI 5
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig53E:
   	 	LOADI 5
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig53N:
   	 	LOADI 5
    	STORE X0
    	LOADI 3
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig54W:
   	 	LOADI 5
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig54S:
   	 	LOADI 5
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig54E:
   	 	LOADI 5
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig54N:
   	 	LOADI 5
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	

	FoundSig64W:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig64S:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig64E:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig64N:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	
    	
  
	FoundSig641W:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0  
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig641S:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0  
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig641E:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0  
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig641N:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0  
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	
    	
	FoundSig642W:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig642S:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig642E:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
        JUMP OutofCheck    	
    
    FoundSig642N:
   	 	LOADI 6
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
        JUMP OutofCheck    	
    	
    	
	FoundSig141W:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0	
    	LOADI 2
    	STORE Orient
        JUMP OutofCheck    	
    	
    FoundSig141S:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0	
    	LOADI 3
    	STORE Orient
        JUMP OutofCheck    	
    FoundSig141E:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0	
    	LOADI 0
    	STORE Orient
    	JUMP OutofCheck
    	
    FoundSig141N:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0	
    	LOADI 1
    	STORE Orient
    	JUMP OutofCheck
    	
    
 
	FoundSig142W:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 2
    	STORE Orient
    	JUMP OutofCheck		
    	
    FoundSig142S:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 3
    	STORE Orient
    	JUMP OutofCheck	
    	
    FoundSig142E:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 0
    	STORE Orient
    	JUMP OutofCheck
    	
    FoundSig142N:
   	 	LOADI 1
    	STORE X0
    	LOADI 4
    	STORE Y0
    	LOADI 1
    	STORE Orient
    	JUMP OutofCheck		
    	
   
;------------------------------------------

OutofCheck:

		LOAD X0
		OUT SSEG1
		LOAD Y0
		OUT SSEG2
		 ; displays the coordinates, waits 3 seconds....
		
		CALL Wait1
		CALL Wait1
		CALL Wait1
		
		; ..... then displays the orientation
		LOADI 0
		OUT SSEG2
		LOAD Orient
		OUT SSEG1



RETURN























;-----------------------------------------------------------

	
	
	;declare signatures for all locations in HEX, these can be accessed later for comparison to the input 
	DERP:    DW 0
	DIVBY:    DW 552
	 ;this is the value we're "dividing" by. 610mm
	DegCust:    DW 73
	RESULT:   DW 0
	ONESEC:   DW 10
	TEMPSIG:  DW &H0000
	TEMPDIST0: DW 0
	TEMPDIST5: DW 0
	FSpeed:   DW 175
	RSpeed:   DW -175
	X0:       DW 0
	Y0:       DW 0
	Orient:   DW 0  ; can be 0 for EAST, 1 for NORTH , 2 for WEST, or 3 for SOUTH
; vals for word
	N1:       DW 0
	N2:       DW 0
	N3:       DW 0
	N4:       DW 0
	
	N1234:    DW &H0000 
	
	
    	
    SIG11W:    DW &H3300
    SIG11S:    DW &H0330
    SIG11E:    DW &H0033
    SIG11N:    DW &H3003
    
    SIG12W:    DW &H2310
    SIG12S:    DW &H0231
    SIG12E:    DW &H1023
    SIG12N:    DW &H3102
    
    SIG13W:    DW &H1420
    SIG13S:    DW &H0142
    SIG13E:    DW &H2014
    SIG13N:    DW &H4201
    
    SIG14W:    DW &H0530
    SIG14S:    DW &H0053
    SIG14E:    DW &H3005
    SIG14N:    DW &H5300
    
    SIG14_1:    DW &H0430  ; these are just in case of errors, where 5 blocks is read as 4 or 6
    SIG14_2:    DW &H0630
    
    SIG21W:    DW &H3201
    SIG21S:    DW &H1320
    SIG21E:    DW &H0132
    SIG21N:    DW &H2013
    
    SIG22W:    DW &H2211
    SIG22S:    DW &H1221
    SIG22E:    DW &H1122
    SIG22N:    DW &H2112
    
    SIG23W:    DW &H1321
    SIG23S:    DW &H1132
    SIG23E:    DW &H2113
    SIG23N:    DW &H3211
    
    SIG24W:    DW &H0431
    SIG24S:    DW &H1043
    SIG24E:    DW &H3104
    SIG24N:    DW &H4310
    
    SIG31W:    DW &H1102
    SIG31S:    DW &H2110
    SIG31E:    DW &H0211
    SIG31N:    DW &H1021
    
    SIG32W:    DW &H0112
    SIG32S:    DW &H2011
    SIG32E:    DW &H1201
    SIG32N:    DW &H1120
    
    SIG33W:    DW &H1202
    SIG33S:    DW &H2120
    SIG33E:    DW &H0212
    SIG33N:    DW &H2021
    
    SIG34W:    DW &H0312
    SIG34S:    DW &H2031
    SIG34E:    DW &H1203
    SIG34N:    DW &H3120
    
    SIG41W:    DW &H1003
    SIG41S:    DW &H3100
    SIG41E:    DW &H0310
    SIG41N:    DW &H0031
    
    SIG42W:    DW &H0013
    SIG42S:    DW &H3001
    SIG42E:    DW &H0310
    SIG42N:    DW &H0031
    
    SIG43W:    DW &H1103
    SIG43S:    DW &H3110
    SIG43E:    DW &H0311
    SIG43N:    DW &H1031
    
    SIG44W:    DW &H0213
    SIG44S:    DW &H3021
    SIG44E:    DW &H1302
    SIG44N:    DW &H2130
    
    SIG53W:    DW &H1004
    SIG53S:    DW &H4100
    SIG53E:    DW &H0410
    SIG53N:    DW &H0041
    
    SIG54W:    DW &H0114
    SIG54S:    DW &H4011
    SIG54E:    DW &H1401
    SIG54N:    DW &H1140
    
    SIG64W:    DW &H0005
    SIG64S:    DW &H5000
    SIG64E:    DW &H0500
    SIG64N:    DW &H0050
    
    SIG64_1:    DW &H0004 ; these are just in case of errors, where 5 blocks is read as 4 or 6
    SIG64_2:    DW &H0006