;--------------------------------------------------------------------------
; Alpha 106
;
; A-Tembo lichten control systeem
;
; (c) 2002 Ernst Naezer & Rogier Lodewijks
;
; email : ernst@ch10.dyndns.org   (software)
;         rogier@ch10.dyndns.org  (hardware)
;--------------------------------------------------------------------------

;==========================================================================
;
; File extension conventions:
;
; .inc  = include file which contains only macro's
; .h    = include file which contains only register name defenitions
; .sh   = include file which contains only sram variables defenitions
; .eh   = include file which contains only eeprom variable defenitions
; .ch   = include file which contains only contants in the code segment
; .asm  = source code file, contains implementation code
;
; NOTE:
;         - .org directives are only allowed in vectors.asm and this file!
;         - the actual code starts at adres 0x00 (defined int vectors.asm)
;           and jumps to the Hardware_init function
;=========================================================================

;-------------------------------------------------------------------------
; Device specific rules
;-------------------------------------------------------------------------
.include "./include/8515dev.h"

;-------------------------------------------------------------------------
; includes and defines
;-------------------------------------------------------------------------
.include "./include/register.h"         ; register definition

;-------------------------------------------------------------------------
; macros
;-------------------------------------------------------------------------
.include "./src/macros/intsupport.inc"   ; save interupt macro's
.include "./src/macros/stack.inc"        ; push and pop
.include "./src/macros/misc.inc"         ; movi,outi and jam macro's 
.include "./src/macros/pointer.inc"      ; offset macro's

;-------------------------------------------------------------------------
; SRAM variable Defenitions
;-------------------------------------------------------------------------
.dseg					                ; data segment (SRAM)
.org 0x0060				                ; after last I/O register (=0x005F)
.include "./src/display.sh"             ; display lookup table
.include "./src/sequencer.sh"           ; temp. sequence step

;-------------------------------------------------------------------------
; code modules
;-------------------------------------------------------------------------
.cseg
.include "./src/vectors.asm"            ; vector handeling

.org 0x0030				                ; last vector = 0x002E / 0x002F
.include "./src/main.asm"               ; main message loop
.include "./src/uart.asm"	            ; uart driver
.include "./src/init.asm"               ; hardware inits
.include "./src/zerocross.asm"          ; zerocross sync
.include "./src/display.asm"            ; 7 segment driver
.include "./src/pwm.asm"                ; PWM timer
.include "./src/sequencer.asm"          ; sequence timing


.include "./src/display.ch"             ; display number lookup table
.include "./src/sequences.ch"           ; patterns

 