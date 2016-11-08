;---------------------------------------------------------------------------
; Description
; vector offest definition
;---------------------------------------------------------------------------

.org 0x00				            ; Reset
	rjmp	Hardware_Reset
.org 0x01
    rjmp    ZeroCross_interupt      ; external interupt 0
.org 0x02
    reti
.org 0x03
    reti
.org 0x04
    reti
.org 0x05
    reti
.org 0x06
    rjmp    Sequence_TimerInteruptHandler
.org 0x07
    rjmp    PWM_TimerInteruptHandler    ; timer interupt 0 over flow
