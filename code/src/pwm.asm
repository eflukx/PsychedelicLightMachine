;---------------------------------------------------------------------------
; Description
; init the timer settings for the PWM code
;---------------------------------------------------------------------------
PWM_init:

	in      Temp1,TCCR0				; set PWM timing properrties
    andi    Temp1,0b11111000

; prescale  
;  1  = ck 
;  10 = ck/8 
;  11 = ck/64
    ori     Temp1,0b1
    out     TCCR0,Temp1

	in      Temp1,TIMSK				; Enable PWM timer
    andi    Temp1,0b11111100
	ori	    Temp1,0b10		        ; overflow interrupt
	out	    TIMSK,Temp1

 ;   clr     cntLow                  ; PWM timing
 ;   clr     toggle                  ; port on/off toggle
    clr     width_counter           ; tick counter
;    clr     PWM_Width               ; pulse width

    ret

;---------------------------------------------------------------------------
; interupt routine
;
; De clock freq van de atmel met internal prescale van 256, maakt 28800 Hz
; De timer heeft een prescale van 64 Hz, 28800 / 64 = 450 Hz
; //Om 50 Hz te krijgen wordt deze door 9 gedeeld, 450 / 9 = 50 Hz
;---------------------------------------------------------------------------
PWM_TimerInteruptHandler:
    SaveInt

    inc     width_counter

    RestoreInt
    reti
