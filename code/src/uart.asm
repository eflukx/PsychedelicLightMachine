;--------------------------------------------------------------------------
; Reference: ATmega103 I/O registers concerning the UART
;
; UDR    = uart data register (R/W)
; 7..0   = data                
;
; USR    = uart status register
;	7    = receive complete
;	6    = transmit complete
;	5    = empty
;	4    = framing error
;	3    = over run error
;	2..0 = reserved
;
; UCR    = uart control register
;	7    = receive ready interupt enable
;	6    = transmit ready interupt enable
;	5    = empty interupt enable
;	4    = receive enable
;	3    = transmit enable
;   2    = 9 bit characters enable (transmit and receive)
;   1    = 9e bit (receive)
;	0    = 9e bit (transmit)
;
; UBRR = uart baud rate register
;	7..0 = uart speed (table 25 (ATMega103/603 datasheet page 64)
;
;	ubrr = MHz / ( ( bps * 16 ) - 1 )
;
; 9k6  uart speed @ 4MHz = 25 (0,2% differing rate)
; 19k2 uart speed @ 4MHz = 12 (0,2% differing rate)
;--------------------------------------------------------------------------

;--------------------------------------------------------------------------
; Init UART
;--------------------------------------------------------------------------
Uart_Init:
	clr	    Temp1
	out	    UCR,Temp1		; disable all

	ldi	    Temp1,23  		; 19k2 @ 7.3728MHz
	out	    UBRR,Temp1

	ret				        ; done with the init

;--------------------------------------------------------------------------
; Incomming data	 (interrupt routine)
;
; Trasht: none
;
; NOTE: this routine only responses to an interupt, there is no actual
;       data processing routine called, in other words; 
;       everything you carefully planned to send to the devices gets
;       killed here ;]
;--------------------------------------------------------------------------
Uart_Receive:
	SaveStatus			    ; push SREG, temp vars e.d.

	in	    Parameter1, UDR ; receive data from UART and clear

;	out	    PORTB,Parameter1

	RestoreStatus			; pop SREG, temp vars e.d.
	reti

;--------------------------------------------------------------------------
; Send data in parameter 1
;
; Trasht: none
;--------------------------------------------------------------------------
Uart_Send:

Uart_Send_Wait:				; Wait until data register is empty
	sbis	USR,UDRE
	rjmp	Uart_Send_Wait

	out	    UDR,Parameter1
	ret

;--------------------------------------------------------------------------
; Enable / Disable UART Receiver
;
; Trasht:
;--------------------------------------------------------------------------
Uart_EnableReceiver:
	SaveInt
	in	        MacroTemp,UCR
	ori	        MacroTemp,( 1<<RXCIE | 1<<RXEN )
	out	        UCR,MacroTemp
    RestoreInt
	ret

Uart_DisableReceiver:
	SaveInt
	in	        MacroTemp,UCR
	andi	    MacroTemp,0xff - ( 1<<RXCIE | 1<<RXEN )
	out	        UCR,MacroTemp
	RestoreInt
	ret

;--------------------------------------------------------------------------
; Enable / Disable UART Transmitter
;
; Trasht:
;--------------------------------------------------------------------------
Uart_EnableTransmitter:
	SaveInt
	in	        MacroTemp,UCR
	ori	        MacroTemp,1<<TXEN
	out	        UCR,MacroTemp
	RestoreInt
	ret

Uart_DisableTransmitter:
	SaveInt
	in	        MacroTemp,UCR
	andi	    MacroTemp,0xff - ( 1<<TXEN )
	out	        UCR,MacroTemp
	RestoreInt
	ret
