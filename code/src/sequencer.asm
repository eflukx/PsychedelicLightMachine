;---------------------------------------------------------------------------
; Description
; light show sequencer
;
; idea:
;
; sequence are stored in the eeporm memo.
; each sequence frame is made out of 16 bytes 
; the first byte give the number of frames in the sequence
;
; the second timer of the avr is used to fecth the next frame, this way
; the speed of a sequence can be easaly adjusted
;---------------------------------------------------------------------------
Sequence_Init:
    clr     Temp1
    out     TCCR1A,Temp1            ; no external ck divide or PWM mode

	in      Temp1,TCCR1B			; set sequence timing properrties
    andi    Temp1,0b11111000
; prescale  
;  1   = ck 
;  10  = ck/8 
;  11  = ck/64
;  100 = ck/256
;  101 = ck/1024
    ori     Temp1,0b1
    out     TCCR1B,Temp1

	in      Temp1,TIMSK				; Enable PWM timer
    andi    Temp1,0b01111111
	ori	    Temp1,0b10000000        ; overflow interrupt on timer 1
	out	    TIMSK,Temp1

    clr     sequencePreScale        ; used for internal speed testing
    clr     sequenceLength
    
    ldi     Temp1,16 + 32           ; clear all storage buffers
    clr     r0
    offY    sequenceStep
sequence_buffer_clear:
    st      Y,r0
    adiw    YLow,1
    dec     Temp1
    brne    sequence_buffer_clear

    ret

;---------------------------------------------------------------------------
; sequence Select
;
; select a sequence for sequences list
;
; input : Parameter1 = sequence number
;---------------------------------------------------------------------------
Sequence_select:
    offCode __sequencePointers

    cpi     Parameter1,SEQUENCE_COUNT
    brlo    correct_sequence
    
    ret

correct_sequence:
    tst     Parameter1
    breq    found_offset
    adiw    Zlow,2                  ; calculate the sequence pointer location
    dec     Parameter1
    rjmp    correct_sequence

found_offset:
    lpm                             ; r1 = the high fraction of the offset
    mov     r1,r0
    adiw    Zlow,1
    lpm                             ; r0 = the low fraction of the offset

    mov     ZHigh,r1
    mov     ZLow,r0

    ret

;---------------------------------------------------------------------------
; sequence play
;
; plays one sequence
; 
; sequence offset to play in Z!
;---------------------------------------------------------------------------
Sequence_play:
;
; read header 
;
    lpm                             ; load seq. length
    mov     sequenceLength,r0 
    adiw    Zlow,1

    lpm                             ; load seq. speed
    mov     sequenceSpeed,r0 
    adiw    Zlow,1

    lpm                             ; load seq. interpolation steps
    mov     sequenceInterpolation,r0 
    mov     sequenceDeltaStep,sequenceInterpolation
    adiw    Zlow,1

    lpm                             ; load seq. repeat counter
    mov     sequenceRepeat,r0
    adiw    Zlow,5                  ; skip the reserved bytes

;
; test the play mode, raw or delta
;
    tst     sequenceInterpolation
    breq    dont_copy_initial_values

;
; in delta mode we must first copy the start values of the sequence
; to the double buffer fixed (convert integer -> 8.8)
;
    offY    sequenceStepsDoubleBufferFixed
    ldi     Temp1,16                ; 16 bytes
fill_double_buffer:
    lpm                             ; load inital value from code memory (r0 = [Z])
    adiw    Zlow,1                  ; next initial value

    st      Y,r0                    ; MSB = r0
    adiw    Ylow,1
    clr     r0
    st      Y,r0                    ; LSB = 0
    adiw    Ylow,1
                  
    dec     Temp1
    brne    fill_double_buffer

dont_copy_initial_values:
;
; patch the X pointer
;
    mov     XLow,ZLow               ; copy the sequence offset
    mov     XHigh,ZHigh             ; to prevent the offset beeing overwritten

;
; start of the play loop
;
sequence_repeat:
;    push    sequenceDeltaStep
;    push    sequenceLength
;    push    XLow                    ; save the data offset
;    push    XHigh
;
; figure out the play mode
;
    tst     sequenceInterpolation
    brne    Sequence_play_delta     ; > 0 then delta mode
  
; -------------------------------------------
; raw mode, no delta's
; -------------------------------------------
Sequence_play_raw:
    mov     ZLow,XLow               ; location of the data in code memory
    mov     ZHigh,XHigh

    offY    sequenceStep            ; location of the temp. sequence step
    ldi     Temp1,16                ; 16 bytes
raw_copy_loop:
    lpm                             ; load from code memory
    adiw    Zlow,1
    st      Y,r0                    ; store in SRAM
    adiw    Ylow,1
    dec     Temp1
    brne    raw_copy_loop

    rjmp    Sequence_play_show_ouput

; -------------------------------------------
; interpolated mode, using deltas
; -------------------------------------------
Sequence_play_delta:
    offY    sequenceStepsDoubleBufferFixed   ; location of the 8.8 fixed sequence steps
    offZ    sequenceStep                     ; location of the sequence steps integer

    ldi     Temp1,16                ; 16 bytes
delta_copy_loop:
    ld      r0,Y                    ; load the MSB from the double buffer
    st      Z,r0                    ; store in the sequence step buffer

    adiw    Ylow,2                  ; skip the LSB
    adiw    Zlow,1                  ; next
    dec     Temp1
    brne    delta_copy_loop

Sequence_play_show_ouput:
    rcall   Sequence_output

    tst     sequenceLength                  ; make the loop, this value is beeing decreased by the speed timer interupt
    breq    ready_with_the_loop

    tst     sequenceInterpolation           ; raw mode?
    breq    Sequence_play_raw
    rjmp    Sequence_play_delta

;
; ready, test for repeat
;
ready_with_the_loop:
;    pop     XHigh                           ; restore the data offset
;    pop     XLow
;    pop     sequenceLength
;    pop     sequenceDeltaStep

;    tst     sequenceRepeat                  ; check if repeat counter = 0
;    breq    sequence_play_end               ; end the loop
;    dec     sequenceRepeat                  ; repeat the sequence
;    rjmp    Sequence_repeat
                 
sequence_play_end:
    ret

;---------------------------------------------------------------------------
; Sequence_output
;
; convert to user space
;---------------------------------------------------------------------------
Sequence_output:
    offZ    sequenceStep                    ; data source
    rcall   Sequence_updateStatusRegister
    out     PORTC,statusRegister            ; upper light
    rcall   Sequence_updateStatusRegister 
    out     PORTA,statusRegister            ; lower light
    ret

;---------------------------------------------------------------------------
; Sequence_updateStatusRegister
;
; one sequence line is converted to a status register which is used to
; output to the port
;
; input : Z points to sequence data in SRAM
;---------------------------------------------------------------------------
Sequence_updateStatusRegister:
    clr     statusRegister

    ldi     Temp1,7                 ; 8 bytes per loop
sequence_loop:
    ld      r0,Z                    ; fetch a phase cut from the sequence table
    adiw    Zlow,1                  ; next byte
    cp      r0,width_counter        ; on or off?
    brlo    toggleOn
    rjmp    toggleOff

toggleOn:
    ori      statusRegister,1

toggleOff:
    tst     Temp1                   ; test for zero to see if we have finished the loop
    breq    _exit_loop
    lsl     statusRegister    

    dec     Temp1
    brpl    sequence_loop
_exit_loop:
    ret

;---------------------------------------------------------------------------
; interpolatie helden routine
;---------------------------------------------------------------------------
Sequence_TimerInteruptHandler:
    SaveInt                                 ; it does trash macrotemp :)
;
; dump init code
;
    push    Temp1
    push    Temp2
    push    r0
    push    r1
    push    YLow
    push    YHigh
    push    ZLow
    push    ZHigh

    tst     sequenceLength              ; sequence played?
    breq    sequence_interupt_exit

    inc     sequencePreScale
    cp      sequencePreScale,sequenceSpeed  ; sequence speed test
    brne    sequence_interupt_exit

    clr     sequencePreScale

    tst     sequenceInterpolation
    breq    Sequence_TimerInteruptHandler_raw_mode

;
; in delta mode
;
; we need to add the delta values to the start values
; for every interpolation step. The deltas are stored in 8.8 fixed point
;
Sequence_TimerInteruptHandler_delta_mode:

    mov     ZLow,XLow               ; Z = start offset for the deltas
    mov     ZHigh,XHigh
;
; delta add loop
;
    offY    sequenceStepsDoubleBufferFixed

    ldi     Delay1,16            ; 16 bytes in total
Sequence_TimerInteruptHandler_delta_add:
    lpm                             ; load the MSB delta value (r0)
    mov     Temp1,r0                ; temp1 = MSB

    adiw    ZLow,1                  ; next byte in buffer
    lpm                             ; load the LSB
    mov     Temp2,r0                ; temp2 = LSB
    adiw    ZLow,1                  ; next delta, delta is now stored in temp1:temp2

    push    YLow                    ; we need to store them also after the add
    push    YHigh                   ; so save the offset

    ld      r1,Y                    ; load the MSB from de double buffer (r1 = MSB)
    adiw    YLow,1                  ; this is why we push and pop Y
    ld      r0,Y                    ; load the LSB from de double buffer  (r0 = LSB)

    add     r0,temp1                ; temp1:temp2 + r1:r0
    adc     r1,temp2                ; this is the DELTA ADD

    pop     YHigh                   ; step back in memory
    pop     Ylow

    st      Y,r1                    ; store the MSB in SRAM
    adiw    YLow,1                  ; next byte
    st      Y,r0                    ; store in LSB SRAM
    adiw    YLow,1                  ; next value

    dec     Delay1
    brne    Sequence_TimerInteruptHandler_delta_add

;
; all interpolation steps done?
;
    dec     sequenceDeltaStep           ; how many times do we have to add this delta
    brne    sequence_interupt_exit

    tst     sequenceLength              ; sequence played?
    breq    sequence_interupt_exit

    mov     sequenceDeltaStep,sequenceInterpolation

    dec     sequenceLength              ; offset in the sequence table
    adiw    XLow,32                     ; point to the next delta row (words!)
    rjmp    sequence_interupt_exit
     
;
; in raw mode
;
Sequence_TimerInteruptHandler_raw_mode:
    tst     sequenceLength                  ; sequence played?
    breq    sequence_interupt_exit

    dec     sequenceLength                  ; offset in the sequence table
    adiw    XLow,16                         ; next in sequence offset

sequence_interupt_exit:

;
; dumb restore
;
    pop     ZHigh
    pop     ZLow
    pop     YHigh
    pop     YLow
    pop     r1
    pop     r0
    pop     Temp2
    pop     Temp1


    RestoreInt
    reti
