; ===================================================================
; Project: ATmega328P Blink Driver
; ===================================================================
; Author: Kevin Thomas
; E-Mail: ket189@pitt.edu
; Version: 1.0
; Date: 12/26/24
; Target Device: ATmega328P (Arduino Nano)
; Clock Frequency: 16 MHz
; Toolchain: AVR-AS, AVRDUDE
; License: Apache License 2.0
; Description: This program toggles the onboard LED connected to PB5 
;              (Pin 13) on the Arduino Nano at 1-second intervals 
;              using pure AVR Assembly. The delay is implemented 
;              using nested loops calibrated for a 16 MHz 
;              clock frequency.
; ===================================================================

; ===================================================================
; SYMBOLIC DEFINITIONS
; ===================================================================
.equ     DDRB, 0x04               ; Data Direction Register for PORTB
.equ     PORTB, 0x05              ; PORTB Data Register
.equ     PB5, 5                   ; Pin 5 of PORTB (D13 on Nano)

; ===================================================================
; PROGRAM ENTRY POINT
; ===================================================================
.global  program                  ; global label; make avail external
.section .text                    ; start of the .text (code) section

; ===================================================================
; PROGRAM LOOP
; ===================================================================
; Description: Main program loop which executes all subroutines and 
;              then repeads indefinately.
; -------------------------------------------------------------------
; Instructions: AVR Instruction Set Manual
;               6.87 RCALL – Relative Call to Subroutine
;               6.90 RJMP – Relative Jump
; ===================================================================
program:
  RCALL  Config_Pins              ; config pins
program_loop:
  RCALL  LED_On                   ; turn LED on
  RCALL  Delay_1s                 ; wait 1 second
  RCALL  LED_Off                  ; turn LED off
  RCALL  Delay_1s                 ; wait 1 second
  RJMP   program_loop             ; infinite loop

; ===================================================================
; SUBROUTINE: Config_Pins
; ===================================================================
; Description: Main configuration of pins on the ATmega128P Arduino 
;              Nano.
; -------------------------------------------------------------------
; Instructions: AVR Instruction Set Manual
;               6.95 SBI – Set Bit in I/O Register
;               6.88 RET – Return from Subroutine
; ===================================================================
Config_Pins:
  SBI    DDRB, PB5                ; set PB5 as output
  RET                             ; return from subroutine

; ===================================================================
; SUBROUTINE: LED_On
; ===================================================================
; Description: Sets PB5 high to turn on the LED.
; -------------------------------------------------------------------
; Instructions: AVR Instruction Set Manual
;               6.95 SBI – Set Bit in I/O Register
;               6.88 RET – Return from Subroutine
; ===================================================================
Led_On:
  SBI    PORTB, PB5               ; set PB5 high
  RET                             ; return from subroutine

; ===================================================================
; SUBROUTINE: LED_Off
; ===================================================================
; Description: Clears PB5 to turn off the LED.
; -------------------------------------------------------------------
; Instructions: AVR Instruction Set Manual
;               6.33 CBI – Clear Bit in I/O Register
;               6.88 RET – Return from Subroutine
; ===================================================================
Led_Off:
  CBI    PORTB, PB5               ; set PB5 low
  RET                             ; return from subroutine

; ===================================================================
; SUBROUTINE: Delay_1s
; ===================================================================
; Description: A one-second delay.
;              - CPU Clock: 16 MHz
;              - 1 clock cycle = 62.5 ns
;              - total cycles for 1 second = 16,000,000
;              - nested loops create approximate 1-second delay
; -------------------------------------------------------------------
; Instructions: AVR Instruction Set Manual
;               6.69 LDI – Load Immediate
;               6.81 NOP – No Operation
;               6.49 DEC – Decrement
;               6.23 BRNE – Branch if Not Equal
;               6.88 RET – Return from Subroutine
; ===================================================================
Delay_1s:
  LDI    R16, 250                 ; outer loop counter
.Outer_Loop:
  LDI    R17, 250                 ; middle loop counter
.Middle_Loop:
  LDI    R18, 64                  ; inner loop counter
.Inner_Loop:
  NOP                             ; 1 cycle delay
  DEC    R18                      ; decrement inner loop counter
  BRNE   .Inner_Loop              ; repeat if not zero else 2 cycles
  DEC    R17                      ; decrement middle loop counter
  BRNE   .Middle_Loop             ; repeat if not zero
  DEC    R16                      ; decrement outer loop counter
  BRNE   .Outer_Loop              ; repeat if not zero
  RET                             ; return from subroutine
