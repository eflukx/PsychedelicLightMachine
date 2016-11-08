;---------------------------------------------------------------------------
; Description
; init the 7 segment driver
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; Display_init
;---------------------------------------------------------------------------
Display_init:
        offCode __CodeDisplayLookuptable; copy the display lookup tabel from code mem
    	offX	displayNumberLookup		; to SRAM for speed and register effecy
									    ; optimize
    	ldi		MacroTemp,NUMBERS       ; 24 entries (24*4 = 96 bytes)
displayLookup_copy:
    	lpm	        					; load one byte into r0
    	adiw	ZLow,1
    	st		X+,r0					; and store plz
                                                 
    	dec		MacroTemp
    	brne	displayLookup_copy
    
        ldi     Temp1,0b11111011        ; p2 = zercross interupt (input)
        out     LEDCONTROL,Temp1        ; display config

        ret

;---------------------------------------------------------------------------
; parameter 1 = value between 0..16
;---------------------------------------------------------------------------
Display_setValue:
        push    Parameter1
        andi    Parameter1,15

		offZ	displayNumberLookup

		add		ZLow,Parameter1
		clr		Parameter1
		adc		ZHigh,Parameter1

		ld		Parameter1,Z+

        andi    Parameter1,0b11111011
        com     Parameter1
        out     LEDPORT,Parameter1

        pop     Parameter1
        ret
