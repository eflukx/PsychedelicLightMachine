;---------------------------------------------------------------------------
; Description
; Contains macro's for interrupt support. Uses the stack.
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; Save status
; Trasht	  : n.v.t.
; Clockcycles : 13
;---------------------------------------------------------------------------
.Macro	SaveStatus
	push	Parameter1
	push	MacroTemp
	push	Temp1
	push	Temp2

    in	    MacroTemp,SREG
	push	MacroTemp

;	PushX
;   PushY
;   PushZ
.endmacro

;---------------------------------------------------------------------------
; Restore status
; Trasht	    : n.v.t.
; Clockcycles	: 13
;---------------------------------------------------------------------------
.Macro	RestoreStatus
;	PopZ
;	PopY
;	PopX

	pop	    MacroTemp
	out	    SREG,MacroTemp

	pop	    Temp2
	pop	    Temp1
	pop	    MacroTemp
	pop	    Parameter1
.endmacro

;---------------------------------------------------------------------------
; Save global interrupt status
; Trasht	    : n.v.t.
; Clockcycles   : 5
;---------------------------------------------------------------------------
.Macro SaveInt
	in	    MacroTemp,SREG
	push	MacroTemp
;	cli
.endmacro

;---------------------------------------------------------------------------
; Restore global interrupt status
; Trasht	        : n.v.t.
; Clockcycles    : 4
;---------------------------------------------------------------------------
.Macro RestoreInt
	pop     MacroTemp
	out	    SREG,MacroTemp
.endmacro
