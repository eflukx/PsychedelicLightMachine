;--------------------------------------------------------------------------
; Description
; Contains macro's for stack support
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
; Stack Functions Push and Pop for the X, Y and Z pointers
; Trasht	    : -
; Clockcycles	: 4 voor iedere macro
;--------------------------------------------------------------------------
.Macro	pushX
	push	XLow
	push	XHigh
.endmacro

.Macro	popX
	pop	    XHigh
	pop	    XLow
.endmacro

.Macro	pushY
	push	YLow
	push	YHigh
.endmacro

.Macro	popY
	pop	    YHigh
	pop	    YLow
.endmacro

.Macro	pushZ
	push	ZLow
	push	ZHigh
.endmacro

.Macro	popZ
	pop	    ZHigh
	pop	    ZLow
.endmacro

