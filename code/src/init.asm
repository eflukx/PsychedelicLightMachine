;---------------------------------------------------------------------------
; Description
; init the controller and call the init routines of the modules
;---------------------------------------------------------------------------
Hardware_Reset:
    cli                             ; disable all the interupts

	ldi     MacroTemp,LOW (RAMEND)	; Initialise stack
	out	    SPL,MacroTemp
	ldi	    MacroTemp,HIGH(RAMEND)
	out	    SPH,MacroTemp

	rcall	Hardware_DisableSystemHardware
    rcall   ZeroCross_Init
    rcall   PWM_init
    rcall   Sequence_init

    rcall   Display_init            ; init the 7 segment driver

                                    ; configure Port D input and output settings
                                    ; pin 7..4 = debug leds         (out)
                                    ; pin 3    = n/a
                                    ; pin 2    = zero cross ext int.(in)
;    ldi     Temp1,0b11110001        ; pin 1    = txd uart           (out)
; 	 out     DDRA,Temp1              ; pin 0    = rxd uart           (in)
;    rcall   Uart_Init
;    rcall   Uart_EnableReceiver

    rjmp	main_loop

;-------------------------------------------------------------------
; Hardware_DisableSystemHardware
;
; disable all the system hardware and init all to zero
;-------------------------------------------------------------------
Hardware_DisableSystemHardware:
	cli				            ; disable interrupts

	ldi     Temp1,0x80		    ; disable analog comperator
	out     ACSR,Temp1		    ; for power saving purposes

	clr     Temp1
	out     GIMSK,Temp1         ; disable (general) ext. interrupts
	out     TIMSK,Temp1		    ; disable all timer interrupts
	out     UCR,Temp1		    ; disable UART
	out     SPCR,Temp1		    ; disable Serial Peripheral Interface
    out     MCUCR,Temp1         ; disable external RAM

	out     DDRA,Temp1          ; port A no output port
	out	    DDRB,Temp1          ; port B no output port
	out     DDRC,Temp1          ; port C no output port
	out	    DDRD,Temp1          ; port D no output port

	out	    PORTA,Temp1		    ; clear portA value
	out	    PORTB,Temp1		    ; clear portB value
	out	    PORTC,Temp1	        ; clear portC value
	out		PORTD,Temp1		    ; clear portD value

	ret
