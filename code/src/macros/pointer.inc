;---------------------------------------------------------------------------
; Macro's for pointer support. They can assagin and work with pointers.
; note: macro's for EEPROM support (e.g. Eoff) are in settings.inc
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; Laat 16 bits pointer naar geheugenadres in het data segment wijzen
;
; Parameters    : Pointer
; Trasht        : -
; Clockcycles   : 2
;---------------------------------------------------------------------------
.Macro offX			    ; X = Operand1
	ldi	    XLow, Low (@0)
	ldi	    XHigh,High(@0)
.endmacro

.Macro offY			    ; Y = Operand1
	ldi	    YLow, Low (@0)
	ldi	    YHigh,High(@0)
.endmacro

.Macro offZ			    ; Z = Operand1
	ldi	    ZLow,Low (@0)
	ldi	    ZHigh,High(@0)
.endmacro

;---------------------------------------------------------------------------
; Laat 16 bits pointer naar geheugenadres in het code segment wijzen
;
; Parameters    : Pointer (to code)
; Clockcycles   : 2
;---------------------------------------------------------------------------
.Macro offCode			; Z = Operand1
	ldi	    ZLow, Low (@0 * 2)
	ldi	    ZHigh,High(@0 * 2)
.endmacro


;---------------------------------------------------------------------------
;  Telt een 16 bits immediate op bij de pointer
; 
;  Parameters    : Immediate (0..63)
;  Trasht        : -
;  Clockcycles   : 2
;---------------------------------------------------------------------------
.Macro	_addXi			; X = X + Operand1
	adiw	XLow,@0
.endmacro

.Macro	_addYi	 		; Y = Y + Operand1
	adiw	YLow,@0
.endmacro

.Macro	_addZi			; Z = Z + Operand1
	adiw	ZLow,@0
.endmacro


;---------------------------------------------------------------------------
;  Telt een 16 bits target op bij de pointer
; 
;  Parameters    : Pointer (to 16 bits value)
;  Trasht        : MacroTemp
;  Clockcycles   : 6
;----------------------------------------------------------------------------
.Macro	_addXt			; X = X + [Operand1]
	lds	    MacroTemp,( @0 + 0 )
	add	    XLow,MacroTemp
	lds	    MacroTemp,( @0 + 1 )
	adc	    XHigh,MacroTemp
.endmacro

.Macro	_addYt			; Y = Y + [Operand1_16]
	lds	    MacroTemp,( @0 + 0 )
	add	    YLow,MacroTemp
	lds 	MacroTemp,( @0 + 1 )
	adc	    YHigh,MacroTemp
.endmacro

.Macro	_addZt			; Z = Z + [Operand1_16]
	ld	    MacroTemp,( @0 + 0 )
	add	    ZLow,MacroTemp
	ld	    MacroTemp,( @0 + 1 )
	adc	    ZHigh,MacroTemp
.endmacro

;---------------------------------------------------------------------------
;  Move X, Y, Z pointers to / from SRAM
; 
;  Parameters    : Pointer (to memloc where to store pointer)
;  Trasht        : -
;  Clockcycles   : 4
;---------------------------------------------------------------------------

.Macro _movtX				; [Operand1] = X
	sts	( @0 + 0 ),XLow
	sts	( @0 + 1 ),XHigh
.endmacro
.Macro _movXt				; X = [Operand1]
	lds	XLow, ( @0 + 0 )
	lds	XHigh,( @0 + 1 )
.endmacro

.Macro _movtY				; [Operand1] = Y
	sts	( @0 + 0 ),YLow
	sts	( @0 + 1 ),YHigh
.endmacro
.Macro _movYt				; Y = [Operand1]
	lds	YLow, ( @0 + 0 )
	lds	YHigh,( @0 + 1 )
.endmacro

.Macro _movtZ				; [Operand1] = Z
	sts	( @0 + 0 ),ZLow
	sts	( @0 + 1 ),ZHigh
.endmacro
.Macro _movZt				; Z = [Operand1]
	lds	ZLow, ( @0 + 0 )
	lds	ZHigh,( @0 + 1 )
.endmacro


;---------------------------------------------------------------------------
;  Move 16bits immediate to SRAM
; 
;  Parameters    : memloc, value
;  Trasht        : MacroTemp
;  Clockcycles   : 6
;---------------------------------------------------------------------------
.Macro _movti				; [Operand1+] = Operand2
	ldi	MacroTemp,Low (@1)
	sts	( @0 + 0 ),MacroTemp
	ldi	MacroTemp,High(@1)
	sts	( @0 + 1 ),MacroTemp
.endmacro


;---------------------------------------------------------------------------
; Compare the pointer with an immediate
;
; Parameters    : 16bits immediate to compare with
; Trasht        : MacroTemp
; Clockcycles   : 3
;---------------------------------------------------------------------------
.Macro _cpiX				; X == Operand1
	cpi	XLow,Low(@0)
	ldi	MacroTemp,High(@0)
	cpc	XHigh,MacroTemp
.endmacro

.Macro _cpiY				; Y == Operand1
	cp	YLow,Low(@0)                      	
    ldi	MacroTemp,High(@0)
	cpc	YHigh,MacroTemp
.endmacro

.Macro _cpiZ				; Z == Operand1
	cp	ZLow,Low(@0)
	ldi	MacroTemp,High(@0)
	cpc	ZHigh,MacroTemp
.endmacro
