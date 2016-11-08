;---------------------------------------------------------------------------
; Description
; main message loop
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
; init the timer.
;---------------------------------------------------------------------------
main_loop:

    ldi     Temp1,255
    out     DDRA,Temp1
    out     DDRC,Temp1

    clr     Delay1
    clr     Delay2

;    ldi     Temp1,6
;    mov     sequenceTimer,Temp1

    sei                             ; kick start interupts

;----------------------------------------[ PWM port output code CODE ]-------------
main_entry:
;    ldi     Parameter1,0            ; sequence number
;    rcall   Sequence_select         ; load the sequence offset in Z pointer
;    rcall   Sequence_play           ; play the sequence
;    rjmp    main_entry
;enix_jam:
	;rjmp	enix_jam

;    offCode __sequenceTable3
;    rcall   Sequence_play           ; play the sequence
;    rjmp    main_entry
    
    clr     Parameter1
main_play_loop:
    cpi     Parameter1,SEQUENCE_COUNT ; total sequences
    breq    main_entry

    push    Parameter1

    rcall   Sequence_select         ; load the sequence offset in Z pointer
    rcall   Sequence_play           ; play the sequence

    pop     Parameter1
    inc     Parameter1                ; next sequence
    rjmp    main_play_loop
