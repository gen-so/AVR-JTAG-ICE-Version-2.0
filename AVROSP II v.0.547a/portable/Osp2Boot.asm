;******************************************************
; OSP II Bootloader protocol
; Version 3.3
; (c)2007 Mike Henning
;******************************************************

;******************************************************
;          OSPII Protocol specification
;******************************************************
; The protocol consists of six commands.
; Each command consists of a 6 byte command packet + 1 byte checksum.
;
; Accepted commands are acknowedged with a 'CR' (13)
; Rejected commands respond with a '?'
;
; Boot Init:       Byte 1       = index 0
;                  Byte 2 - 6   = Don't care
;
; EEprom command:  Byte 1       = index 1
;                  Byte 2,3 & 4 = 24 Bit byte address
;                  Byte 5       = 'w' write or 'r' read
;                  Byte 6       = Byte to write
;
; Chip Erase:      Byte 1       = index 2
;                  Byte 2 - 6   = Don't care
;
; Flash command:   Byte 1       = index 3
;                  Byte 2,3 & 4 = 24 Bit byte address
;                  Byte 5 & 6   = Block Size to transfer
;                  Byte 7       = checksum
;                  Byte 8       = 'w' write or 'r' read
;
; ReadFuseLock:    Byte 1       = index 4
;                  Byte 2 & 3   = operation command
;                  Byte 4,5 & 6 = Don't care
;
; Exit Bootloader: Byte 1       = index 5
;                  Byte 2 - 6   = Don't care


;******************************************************
;     User Device Configuration
;******************************************************
.include "m16def.inc"

.equ  FREQ           = 3686400      ; CPU clock in Hz
.equ  BAUD           = 115200       ; Baud rate

.equ  BOOTSIZE       = 512          ; ( Bytes )
.equ  BOOTBLOCKS     = ((FLASHEND + 1) - (BOOTSIZE >> 1)) / PAGESIZE  ; Align bootstart on even Page boundary
.equ  MYBOOTSTART    = BOOTBLOCKS * PAGESIZE
.equ  USERCODE_RESET = 0 ;MYBOOTSTART - 1

.equ  UseFuseLock = 1
.equ  UseBootExit = 1

;******************************************************


;------------------------------------------------
; System definitions
;------------------------------------------------
.include "IOMacros.inc"

.equ  UBR         = INT( FREQ / (16 * BAUD) - 0.5 )
.equ  PAGEBYTES   = PAGESIZE * 2

.equ  SW_MAJ_VER  = '3'
.equ  SW_MIN_VER  = '3'


;------------------------------------------------
; redefine SPM & LPM registers and constants
;------------------------------------------------
.ifndef SPMCSR
  .set SPMCSR = SPMCR
.endif

.ifndef SPMEN
  .set SPMEN = SELFPRGEN
.endif

.ifndef RFLB
  .set RFLB = BLBSET
.endif

.macro Ldpm
  .ifdef RAMPZ
    elpm @0, @1
  .else
    lpm @0, @1
  .endif
.endmacro

;------------------------------------------------
; redefine UART registers and constants
;------------------------------------------------
.ifndef UBRR
  .ifndef UBRR0L
    .set UBRR = UBRRL
  .else
    .set UBRR = UBRR0L
  .endif
.endif

.ifndef UCSRB
  .set UCSRB = UCSR0B
.endif

.ifndef UCSRA
  .set UCSRA = UCSR0A
.endif

.ifndef UDR
  .set UDR = UDR0
.endif

.ifndef UDRE
  .set UDRE = UDRE0
.endif

.ifndef RXEN
  .set RXEN = RXEN0
.endif

.ifndef TXEN
  .set TXEN = TXEN0
.endif

.ifndef RXC
  .set RXC = RXC0
.endif

;------------------------------------------------
; redefine EEPROM registers and constants
;------------------------------------------------
.ifndef EEMPE
  .set EEMPE = EEMWE
.endif

.ifndef EEPE
  .set EEPE = EEWE
.endif


;**************** Registers****************
.def  scratch   = r2

.def  temp1     = R16   ; Temporary registers

.def  SPM_Cmd   = R18
.def  u_data    = R19   ; UART character

.def  chksum    = R22
.def  Addr3     = R23
.def  AddrL     = R24
.def  AddrH     = R25



.dseg   ; SRAM Segment
RAM_Block:  .byte   PAGEBYTES   ; Block buffer


.cseg
.org MYBOOTSTART

BOOTLOADER:   ldi    temp1, low(RAMEND)
              Store  SPL, temp1
            .ifdef SPH
              ldi    temp1, high(RAMEND)
              Store  SPH, temp1
            .endif

;******************************************************
;     Setup UART
;******************************************************
            .ifdef UBRR
              ldi    temp1, low(UBR)
              Store  UBRR, temp1
              ldi    temp1, (1<<RXEN)|(1<<TXEN)
              Store  UCSRB, temp1
            .endif
;******************************************************
;     Setup any I/O needed here
;******************************************************

; example:
            sbi  PORTD, 3             ; enable pullup
            nop
;******************************************************
;     Setup boot handler here
;     i.e. - wait for keypress
;          - char received w/timeout
;******************************************************

; example:
            Skbc  PIND, 3            ; If PIND.3 is low then enter bootloader
            jmp   USERCODE_RESET      ; else jump to application reset


MAINLOOP:   clr   chksum

            rcall RX_DATA
            cpi   u_data, 6          ; Number of valid commands
            brlo  SET_ADDRESS

Send_error: ldi    u_data, '?'       ; invalid command
            rjmp   SendData_WaitCmd


SET_ADDRESS:mov    zl, u_data       ; Byte 1 - Command index
            rcall  GetWord          ; Byte 2 & 3
            movw   AddrL, r0

            rcall  RX_DATA          ; [Byte 4]
.ifdef RAMPZ
            Store  RAMPZ, u_data
.endif

            rcall  GetWord          ; Byte 5 & 6
            movw   xl, r0

            rcall  RX_DATA          ; Byte 7 - Checksum
            tst    chksum
            brne   Send_error
            ldi    u_data, 13       ; Send Okay
            rcall  TX_DATA


Execute:    ldi   zh, high(Cmd_JmpTable)
            subi  zl, -(low(Cmd_JmpTable))
.ifndef EIND
            ijmp
.else
            ldi   temp1, BYTE3(Cmd_JmpTable)
		        out   EIND, temp1
            eijmp
.endif


Cmd_JmpTable:
            rjmp   BOOT_INIT
            rjmp   EE_CMD
            rjmp   CHIP_ERASE
            rjmp   FLASH_CMD
            .if UseFuseLock > 0
            rjmp   READ_FUSE_LOCKBITS
            .else
            rjmp   Send_error
            .endif
            .if UseBootExit > 0
            rjmp   BOOT_EXIT
            .else
            rjmp   Send_error
            .endif


CHIP_ERASE: ldi    zl, byte1(2*MYBOOTSTART)
            ldi    zh, byte2(2*MYBOOTSTART)

.ifdef RAMPZ
            ldi    Addr3, byte3(2*MYBOOTSTART)
            Store  RAMPZ, Addr3
.endif

Chip_Erase_loop:
            subi   zl, low (PAGEBYTES)
            sbci   zh, high(PAGEBYTES)
.ifdef RAMPZ
            sbci   Addr3, 0
            Store  RAMPZ, Addr3
.endif
            brmi   end_erase

            ldi    SPM_Cmd, 1<<PGERS | 1<<SPMEN
            rcall  DO_SPM
            rjmp   Chip_Erase_loop
end_erase:

.ifdef RWWSRE
            rcall  SPM_REENABLE_RWW
.endif
            rjmp   SendAck_WaitCmd

.if UseFuseLock > 0

READ_FUSE_LOCKBITS:
;           [3 = hi, 2 = ext, 1 = lock, 0 = low]
            ;rcall  RX_DATA
            ;clr    zh
            movw   zl, AddrL
            ldi    SPM_Cmd, (1<<RFLB | 1<<SPMEN)
            Store  SPMCSR, SPM_Cmd
            Ldpm   u_data, Z
            rjmp   SendData_WaitCmd
.endif

.if UseBootExit > 0
BOOT_EXIT:  jmp    USERCODE_RESET
.endif


EE_CMD:     rcall  MEM_Wait             ; Wait for previous memory ops to complete

.ifdef EEARH
            Store  EEARH, AddrH         ; Set up address register - High/low
.endif
            Store  EEARL, AddrL

            cpi    xl, 'w'              ; 'w' = Write EEPROM  'r' = Read EEPROM
            breq   Save_EE_Byte

Get_EE_Byte:
            Setb   EECR,  EERE
            Load   u_data, EEDR
            rjmp   SendData_WaitCmd

Save_EE_Byte:
            ; Set Programming mode
            ;   ldi temp1, (0<<EEPM1)|(0<<EEPM0) ; This is the default
            ;   Store EECR, temp1

            Store  EEDR, xh             ; Write data to data register
            Setb   EECR, EEMPE          ; Write logical one to EEMPE
            Setb   EECR, EEPE           ; Start eeprom write by setting EEPE
            rjmp   SendAck_WaitCmd


;------------------------------------------------
BOOT_INIT:
;------------------------------------------------
            ldi    zl, byte1(2*INIT_INFO)
            ldi    zh, byte2(2*INIT_INFO)
.ifdef RAMPZ
            ldi    Addr3, byte3(2*INIT_INFO)
            Store  RAMPZ, Addr3
.endif
            ldi    xl, 10
Tx_String:
            Ldpm   u_data, Z+
            rcall  TX_DATA
            dec    xl
            brne   Tx_String
            rjmp   MainLoop


;------------------------------------------------
FLASH_CMD:
;------------------------------------------------

            movw   zl, AddrL

            rcall  RX_DATA              ; Get memory command
            cpi    u_data, 'w'
            breq   BlockWrite_Flash


;------------------------------------------------
BlockRead_Flash:
;------------------------------------------------

FlashRead_loop:
            Ldpm   u_data, Z+
            rcall  TX_DATA
            sbiw   xl,1
            brne   FlashRead_loop
            rjmp   MAINLOOP

;------------------------------------------------
BlockWrite_Flash:
;------------------------------------------------

BlockWrite_Loop:
            rcall  GetWord
            ldi    SPM_Cmd, 1<<SPMEN
            rcall  DO_SPM

            adiw   zl, 2
            sbiw   xl, 2
            brne   BlockWrite_Loop
            movw   zl, AddrL
            rcall  SPM_PAGE_WRITE


SendAck_WaitCmd:
            ldi    u_data, 13

SendData_WaitCmd:
            rcall  TX_DATA
            rjmp   MAINLOOP


GetWord:    rcall  RX_DATA
            mov    R0, u_data
            rcall  RX_DATA
            mov    R1, u_data
            ret



SPM_PAGE_WRITE:
            ldi    SPM_Cmd, 1<<PGWRT | 1<<SPMEN

.ifdef RWWSRE
            rcall  DO_SPM              ; Re-enable the RWW section
SPM_REENABLE_RWW:
            ldi    SPM_Cmd, 1<<RWWSRE | 1<<SPMEN
.endif


DO_SPM:     rcall  MEM_Wait
            Store  SPMCSR, SPM_Cmd
            spm
            ret

MEM_Wait:   Skbc   SPMCSR, SPMEN, r2   ; Wait for FLASH to be ready
            rjmp   MEM_Wait

EE_Wait:    Skbc   EECR, EEPE          ; Wait for completion of any
            rjmp   EE_Wait             ; previous EEPROM writes.
            ret


RX_DATA:    Skbs   UCSRA, RXC, r2
            rjmp   RX_DATA
            Load   u_data, UDR
            eor    chksum, u_data
            ret

TX_DATA:    Skbs   UCSRA, UDRE, r2
            rjmp   TX_DATA
            Store  UDR, u_data
            ret


INIT_INFO: .DB  "OSPII", SW_MAJ_VER, SW_MIN_VER, \
                SIGNATURE_002, SIGNATURE_001, SIGNATURE_000
