;---------------------------------------------------------------------------
; Description
; jam and other misc macros
;---------------------------------------------------------------------------

.equ LEDPORT     = PORTD
.equ LEDCONTROL  = DDRD

;---------------------------------------------------------------------------
; Output a byte to an I/O Register
;
; Trasht	  : MacroTemp
; Clockcycles : 2
;---------------------------------------------------------------------------
.Macro outi
	ldi	    MacroTemp,@1
	out	    @0,MacroTemp
.endmacro

;---------------------------------------------------------------------------
; Output a byte to a general purpose register (r0..r15)
; 
; Trasht	   : MacroTemp
; Clockcycles : 2
;---------------------------------------------------------------------------
.Macro movi
	ldi	    MacroTemp,@1
	mov	    @0,MacroTemp
.endmacro

;---------------------------------------------------------------------------
; Jam Atmel (laat Atmel vastlopen)
; Note	      : Disabled global interrupts
; Trasht	  : n.v.t.
; Clockcycles : n.v.t.
;---------------------------------------------------------------------------
.Macro	jam
	cli
jam_label:
	rjmp	jam_label
.endmacro

;---------------------------------------------------------------------------
; Jam Atmel fancy
; Jam Atmel and show some activity on the Leds
; Note	        : Disabled global interrupts
; Trasht	    : n.v.t.
; Clockcycles   : n.v.t.
;---------------------------------------------------------------------------
.Macro	jamf
	cli
	clr	    Temp1

	ldi	    MacroTemp,0xff
	out	    LEDCONTROL,MacroTemp
	clc
jam_label:
	out	    LEDPORT,MacroTemp

	ror	    MacroTemp

	JamDelay

	rjmp	jam_label
.endmacro

;---------------------------------------------------------------------------
; Small delay for the jam macro's
; Trasht	    : n.v.t.
; Clockcycles   : n.v.t.
;---------------------------------------------------------------------------
.Macro JamDelay
	clr	    Delay1
	clr	    Delay2
JamDelay_loop:
	dec	    Delay1
	brne	JamDelay_loop
	dec	    Delay2
	brne	JamDelay_loop
.endmacro

.Macro	kled	; knipper led(s)
	cli
	ser	    MacroTemp
	com	    Parameter1
jam_loop:
	out	    LEDPORT,Parameter1
	JamDelay
	JamDelay
	JamDelay
	out	    LEDPORT,MacroTemp
	JamDelay
	JamDelay
	JamDelay
	rjmp	jam_loop
.endmacro

.Macro	jam0
	ldi	    Parameter1,0b00000001
	kled
.endmacro

.Macro	jam1
	ldi	    Parameter1,0b00000010
	kled
.endmacro

.Macro	jam2
	ldi	    Parameter1,0b00000100
	kled
.endmacro

.Macro	jam3
	ldi	Parameter1,0b00001000
	kled
.endmacro

.Macro	jam4
	ldi     Parameter1,0b00010000
	kled
.endmacro

.Macro	jam5
	ldi	Parameter1,0b00100000
	kled
.endmacro

.Macro	jam6
	ldi	Parameter1,0b01000000
	kled
.endmacro

.Macro	jam7
	ldi	Parameter1,0b10000000
	kled
.endmacro
