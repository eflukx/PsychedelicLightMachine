;---------------------------------------------------------------------------
; Description
; handles the interupt sync from the zerocross detector
;---------------------------------------------------------------------------

ZeroCross_Init:
    ldi     Temp1,0b01000000    ; enable the external interupt nr 0
    out     GIMSK,Temp1

    ldi     Temp1,0b00000010    ; enable the failing edge of external interupt zero
    out     MCUCR,Temp1         ; MCU Control register

    ret

;---------------------------------------------------------------------------
;ZeroCross interupt handler
;---------------------------------------------------------------------------
ZeroCross_interupt:
    SaveInt

    clr     width_counter

    RestoreInt
    reti
