;---------------------------------------------------------------------------
; Overall general defenitions
;---------------------------------------------------------------------------
.equ	false		= 0		; defenition of the boolean values
.equ	true		= 1

;---------------------------------------------------------------------------
; randomize registers
;---------------------------------------------------------------------------
;.def    seedLow         = r1
;.def    seedHigh        = r2
;.def    newBit          = r18
;.def    statusLoopCnt    = r6

;---------------------------------------------------------------------------
; sequencer registers and defines
;---------------------------------------------------------------------------
; private
.def    sequencePreScale      = r5            ; internal speed counter
.def    statusRegister        = r18           ; port output
.def    sequenceDeltaStep     = r2

; public
.def    sequenceSpeed         = r6
.def    sequenceInterpolation = r7
.def    sequenceRepeat        = r8
.def    sequenceLength        = r19

    .equ    RAW_MODE   = 0
    .equ    DELTA_MODE = 1

;---------------------------------------------------------------------------
; Delay registers
;---------------------------------------------------------------------------
.def	Delay1		= r16
.def	Delay2		= r17

;---------------------------------------------------------------------------
; Temporary registers
;---------------------------------------------------------------------------
.def	Temp1		= r20		; 1st Temporary register
.def	Temp2		= r21		; 2nd temporary register
.def	MacroTemp	= r22		; Macro temporary register
.def	Parameter1	= r23		; Functie parameter / return value

;---------------------------------------------------------------------------
; Pointer registers
;---------------------------------------------------------------------------
.def    phase_offset    = r24
.def    width_counter   = r25

.def	XLow		= r26		; X Pointer LSB
.def	XHigh		= r27		; X Pointer MSB
.def    YLow		= r28		; Y Pointer LSB
.def    YHigh		= r29		; Y Pointer MSB
.def    ZLow		= r30		; Z Pointer LSB
.def    ZHigh		= r31		; Z Pointer MSB
