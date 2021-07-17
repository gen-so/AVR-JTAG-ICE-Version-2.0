
;CodeVisionAVR C Compiler V1.25.9 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8,000000 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM
	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM
	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM
	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

	.CSEG
	.ORG 0

	.INCLUDE "main.vec"
	.INCLUDE "main.inc"

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0
	.DB  0 ; FIRST EEPROM LOCATION NOT USED, SEE ATMEL ERRATA SHEETS

	.DSEG
	.ORG 0x160
;       1 //----------------------------------------------------------------------------------------------------------------------------
;       2 //Mick Laboratory, Калуга 2014
;       3 //main.c  - модуль основных функций
;       4 //Тип микроконтроллера: atmega16a
;       5 //Автор: Mick (Тарасов Михаил)
;       6 //Версия модуля: v1.00 - 13 марта 2014
;       7 //----------------------------------------------------------------------------------------------------------------------------
;       8 #include "main.h"
;       9 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;      10 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;      11 	.EQU __se_bit=0x40
	.EQU __se_bit=0x40
;      12 	.EQU __sm_mask=0xB0
	.EQU __sm_mask=0xB0
;      13 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;      14 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;      15 	.EQU __sm_standby=0xA0
	.EQU __sm_standby=0xA0
;      16 	.EQU __sm_ext_standby=0xB0
	.EQU __sm_ext_standby=0xB0
;      17 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;      18 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;      19 	#endif
	#endif
;      20 
;      21 #define TIMER_CLK			140		//7372800 / 256 = 28800 => 256 - 116 = 140
;      22 
;      23 //-------------------------------------------------------------
;      24 //описание:описание переменных контроллера
;      25 //-------------------------------------------------------------
;      26  unsigned char ucCPU_led_timer;
;      27  unsigned int  uiCPU_ms_timer;
;      28 //-------------------------------------------------------------------------------------------------------------------------
;      29 // описание:  инициализация оборудования .
;      30 // параметры:    нет
;      31 // возвращаемое  значение:  нет
;      32 //-------------------------------------------------------------------------------------------------------------------------
;      33 void CPU_init(void)
;      34 {

	.CSEG
_CPU_init:
;      35   PORTA = 0xFF;                                         //порт A на вход
	LDI  R30,LOW(255)
	OUT  0x1B,R30
;      36   DDRA  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
;      37 
;      38   PORTB = 0xFF;                                         //порт B кофигурируем как:
	LDI  R30,LOW(255)
	OUT  0x18,R30
;      39   DDRB  = 0xAA;						//TMS,STATUS,TDI,TCK - выходы
	LDI  R30,LOW(170)
	OUT  0x17,R30
;      40 
;      41   PORTC = 0xFF;                                         //порт C на вход
	LDI  R30,LOW(255)
	OUT  0x15,R30
;      42   DDRC  = 0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;      43 
;      44   PORTD = 0xF7;                         		//порт D на вход: RXD, CSAVR, DATKK, DATKM,CLKK,CLKM
	LDI  R30,LOW(247)
	OUT  0x12,R30
;      45   DDRD  = 0x09;				                //выход: TXD =1, RES =0
	LDI  R30,LOW(9)
	OUT  0x11,R30
;      46 
;      47   ACSR  = 0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;      48 
;      49   MCUCR = 0x00;						//запретим внешние прерывания
	LDI  R30,LOW(0)
	OUT  0x35,R30
;      50   GICR  = 0x00;
	OUT  0x3B,R30
;      51 
;      52   TCCR0 = 0x04;						// 8-битный таймер используем CLK/256
	LDI  R30,LOW(4)
	OUT  0x33,R30
;      53   TCNT0 = TIMER_CLK;					//прерывание по таймеру
	LDI  R30,LOW(140)
	OUT  0x32,R30
;      54 
;      55   TIMSK = 0x01;						//внутреннее прерывание от 8 - битного таймера
	LDI  R30,LOW(1)
	OUT  0x39,R30
;      56   TIFR  = 0x01;						//очистим флаг прерывания от 16 - ти битного таймера
	OUT  0x38,R30
;      57 
;      58  }
	RET
;      59 //----------------------------------------------------------
;      60 //описание:     включить/выключить светодиод
;      61 //параметры:    cState  -   состояние светодиода
;      62 //возвращаемое  значение:  нет
;      63 //---------------------------------------------------------
;      64 void CPU_led_state(char cState)
;      65 {
_CPU_led_state:
;      66  if(cState ==0) PORTB = PORTB | 0x08;
;	cState -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x3
	SBI  0x18,3
;      67  else PORTB = PORTB & 0xF7;
	RJMP _0x4
_0x3:
	CBI  0x18,3
;      68  ucCPU_led_timer = 0;
_0x4:
	CLR  R5
;      69 }
	ADIW R28,1
	RET
;      70 //-------------------------------------------------------------------
;      71 // описание: прочитать состояние системных тиков
;      72 // параметры:       нет
;      73 // возвращаемое  значение:    количество системных тиков
;      74 //-------------------------------------------------------------------
;      75 unsigned int CPU_get_timer_ms(void)
;      76 {
_CPU_get_timer_ms:
;      77  return uiCPU_ms_timer;
	MOVW R30,R6
	RET
;      78 }
;      79 //-----------------------------------------------------------------------------------------------------------------------
;      80 // описание:  управление основным процессом.
;      81 // параметры:    нет
;      82 // возвращаемое  значение:  нет
;      83 //-------------------------------------------------------------------------------------------------------------------------
;      84 void main(void)
;      85 {
_main:
;      86  DisableInterrupts;					//#asm("CLI")
	CLI
;      87  CPU_init();						// инициализация микроконтроллера
	CALL _CPU_init
;      88  uiCPU_ms_timer  = 0;
	CLR  R6
	CLR  R7
;      89  ucCPU_led_timer = 0;
	CLR  R5
;      90  JTAG_Init();
	CALL _JTAG_Init
;      91  UART_init();
	CALL _UART_init
;      92  Terminal_init();
	CALL _Terminal_init
;      93  EnableInterrupts;                               	//#asm("SEI")
	SEI
;      94  for(;;)
_0x6:
;      95   {
;      96    Terminal_cmd_analyze();
	CALL _Terminal_cmd_analyze
;      97    if(ucCPU_led_timer >= 250)
	LDI  R30,LOW(250)
	CP   R5,R30
	BRLO _0x8
;      98      {
;      99       ucCPU_led_timer = 0;
	CLR  R5
;     100       PORTB = PORTB ^ 0x08;
	IN   R30,0x18
	LDI  R26,LOW(8)
	EOR  R30,R26
	OUT  0x18,R30
;     101      }
;     102   }
_0x8:
	RJMP _0x6
;     103 }
_0x9:
	RJMP _0x9
;     104 //------------------------------------------------------------------------------------------------------------------------
;     105 // описание: обработка прерывания от  8 - битного таймера (через каждые 4,096mc)
;     106 // параметры:    нет
;     107 // возвращаемое  значение:  нет
;     108 //-------------------------------------------------------------------------------------------------------------------------
;     109 interrupt [TIM0_OVF] void Timer0_overlow(void)
;     110 {
_Timer0_overlow:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;     111  TIFR = TIFR | 0x01;					//очистим флаг прерывания от 8 - ти битного таймера
	IN   R30,0x38
	ORI  R30,1
	OUT  0x38,R30
;     112  TCNT0 = TIMER_CLK;					//прерывание по таймеру происходит через 4мс
	LDI  R30,LOW(140)
	OUT  0x32,R30
;     113  uiCPU_ms_timer = uiCPU_ms_timer + 1;			//увеличиваем счетчик системных тиков
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
;     114  ucCPU_led_timer = ucCPU_led_timer +1;
	INC  R5
;     115 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;     116 //----------------------------------------------------------------------------------------------------------------------------
;     117 //Mick Laboratory, Калуга 2014
;     118 //jtag.c  - модуль функций обработки JTAG команд.
;     119 //Тип микроконтроллера: atmega16a
;     120 //Автор: Mick (Тарасов Михаил)
;     121 //Версия модуля: 1.00 - 13 марта 2014
;     122 //----------------------------------------------------------------------------------------------------------------------------
;     123 //Примечание: За основу данного модуля взяты исходники проектов Lavor -> Laurent Saint-Marcel (lstmarcel@yahoo.fr) и
;     124 //JTAGFlasher безымянного русскоязычного программиста (найдено в просторах интернета)
;     125 //----------------------------------------------------------------------------------------------------------------------------
;     126 
;     127 #include "main.h"
;     128 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     129 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     130 	.EQU __se_bit=0x40
	.EQU __se_bit=0x40
;     131 	.EQU __sm_mask=0xB0
	.EQU __sm_mask=0xB0
;     132 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;     133 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;     134 	.EQU __sm_standby=0xA0
	.EQU __sm_standby=0xA0
;     135 	.EQU __sm_ext_standby=0xB0
	.EQU __sm_ext_standby=0xB0
;     136 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;     137 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     138 	#endif
	#endif
;     139 
;     140 #define TMS_0 			0
;     141 #define TMS_1                   1
;     142 
;     143 #define TDI_0 			0
;     144 #define TDI_1 			1
;     145 
;     146 #define TMS_PIN      	 	1
;     147 #define TMS_MASK      	 	0x02
;     148 #define TDI_PIN      	 	5
;     149 #define TDI_MASK      	 	0x20
;     150 #define TDO_PIN      	 	6
;     151 #define TDO_MASK      	 	0x40
;     152 #define TCLK_PIN     		7
;     153 #define TCLK_MASK     		0x80
;     154 
;     155 //----------------------------------------------------------------------------------------------------------------------
;     156 //описание:описание переменных контроллера
;     157 //-----------------------------------------------------------------------------------------------------------------------
;     158  char cJTAG_prog_mode;					//флаг режима программирования
;     159 //-------------------------------------------------------------------------------------------------------------------------
;     160 // описание: Инициализация JTAG
;     161 // параметры:    нет
;     162 // возвращаемое  значение:  нет
;     163 //-------------------------------------------------------------------------------------------------------------------------
;     164 void JTAG_Init(void)
;     165 {
_JTAG_Init:
;     166   PORTB = 0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
;     167   DDRB = DDRB & ~TDO_MASK;
	CBI  0x17,6
;     168   DDRB = DDRB | (TMS_MASK | TDI_MASK | TCLK_MASK) ;
	IN   R30,0x17
	ORI  R30,LOW(0xA2)
	OUT  0x17,R30
;     169   cJTAG_prog_mode = 0;
	CLR  R4
;     170 }
	RET
;     171 //-------------------------------------------------------------------------------------------------------------------------
;     172 // описание: Формирование TAP последовательности JTAG
;     173 // параметры:    нет
;     174 // возвращаемое  значение:  нет
;     175 //-------------------------------------------------------------------------------------------------------------------------
;     176 void JTAG_Tap(unsigned long ulState, unsigned char ucCount)
;     177  {
_JTAG_Tap:
;     178   unsigned char i;
;     179   PORTB = PORTB & ~TCLK_MASK;
	ST   -Y,R17
;	ulState -> Y+2
;	ucCount -> Y+1
;	i -> R17
	CBI  0x18,7
;     180   PORTB = PORTB & ~TMS_MASK;
	CBI  0x18,1
;     181   for(i =0; i < ucCount; i++)
	LDI  R17,LOW(0)
_0xB:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0xC
;     182    {
;     183     if((ulState & 0x01)!= 0) PORTB = PORTB | TMS_MASK;
	LDD  R30,Y+2
	ANDI R30,LOW(0x1)
	BREQ _0xD
	SBI  0x18,1
;     184     else PORTB = PORTB & ~TMS_MASK;
	RJMP _0xE
_0xD:
	CBI  0x18,1
;     185     ulState = ulState >> 1;
_0xE:
	__GETD1S 2
	CALL __LSRD1
	__PUTD1S 2
;     186     PORTB = PORTB | TCLK_MASK;
	SBI  0x18,7
;     187     PORTB = PORTB & ~TCLK_MASK;
	CBI  0x18,7
;     188    }
	SUBI R17,-1
	RJMP _0xB
_0xC:
;     189  }
	LDD  R17,Y+0
	ADIW R28,6
	RET
;     190 //-------------------------------------------------------------------------------------------------------------------------
;     191 // описание: Отправка данных в JTAG
;     192 // параметры:    нет
;     193 // возвращаемое  значение:  нет
;     194 //-------------------------------------------------------------------------------------------------------------------------
;     195 unsigned long JTAG_ShiftInstruction(unsigned long ulInstruction, unsigned char ucCount)
;     196  {
_JTAG_ShiftInstruction:
;     197   unsigned char i;
;     198   unsigned long ulResult;
;     199   ulResult =0;
	SBIW R28,4
	ST   -Y,R17
;	ulInstruction -> Y+6
;	ucCount -> Y+5
;	i -> R17
;	ulResult -> Y+1
	__CLRD1S 1
;     200   PORTB = PORTB & ~TMS_MASK;
	CBI  0x18,1
;     201   PORTB = PORTB & ~TCLK_MASK;
	CBI  0x18,7
;     202   for( i =0; i < ucCount; i++)
	LDI  R17,LOW(0)
_0x10:
	LDD  R30,Y+5
	CP   R17,R30
	BRSH _0x11
;     203    {
;     204     if((ulInstruction & 0x01) != 0) PORTB = PORTB | TDI_MASK;
	LDD  R30,Y+6
	ANDI R30,LOW(0x1)
	BREQ _0x12
	SBI  0x18,5
;     205     else PORTB = PORTB & ~TDI_MASK;
	RJMP _0x13
_0x12:
	CBI  0x18,5
;     206     ulInstruction = ulInstruction >>1;
_0x13:
	__GETD1S 6
	CALL __LSRD1
	__PUTD1S 6
;     207     if(i == (ucCount-1)) PORTB = PORTB | TMS_MASK; // последний бит JTAG инструкции: подготовим уход из Shift-IR
	LDD  R30,Y+5
	SUBI R30,LOW(1)
	CP   R30,R17
	BRNE _0x14
	SBI  0x18,1
;     208     PORTB = PORTB | TCLK_MASK;
_0x14:
	SBI  0x18,7
;     209     if ((PINB & TDO_MASK) != 0) ulResult = ulResult | 0x80000000;
	SBIS 0x16,6
	RJMP _0x15
	LDD  R30,Y+4
	ORI  R30,0x80
	STD  Y+4,R30
;     210     ulResult = ulResult >>1;
_0x15:
	__GETD1S 1
	CALL __LSRD1
	__PUTD1S 1
;     211     PORTB = PORTB & ~TCLK_MASK;
	CBI  0x18,7
;     212    }
	SUBI R17,-1
	RJMP _0x10
_0x11:
;     213   return ulResult;
	__GETD1S 1
	LDD  R17,Y+0
	ADIW R28,10
	RET
;     214  }
;     215 //-------------------------------------------------------------------------------------------------------------------------
;     216 // описание: Вывод команды в JTAG интерфейс
;     217 // параметры:    нет
;     218 // возвращаемое  значение:  uiResult - ответ устройства
;     219 //-------------------------------------------------------------------------------------------------------------------------
;     220 unsigned int JTAG_WriteProgCmd(unsigned char ucCmdH, unsigned char ucCmdL)
;     221 {
_JTAG_WriteProgCmd:
;     222  unsigned int uiResult;
;     223  unsigned int uiCommand;
;     224  unsigned long ulData;
;     225 
;     226  uiCommand = ucCmdH;
	SBIW R28,4
	CALL __SAVELOCR4
;	ucCmdH -> Y+9
;	ucCmdL -> Y+8
;	uiResult -> R16,R17
;	uiCommand -> R18,R19
;	ulData -> Y+4
	LDD  R18,Y+9
	CLR  R19
;     227  uiCommand = (uiCommand << 8) | ucCmdL;
	MOV  R31,R18
	LDI  R30,LOW(0)
	MOVW R26,R30
	LDD  R30,Y+8
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R18,R30
;     228 
;     229  JTAG_Tap(0x0D,6);
	__GETD1N 0xD
	CALL __PUTPARD1
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _JTAG_Tap
;     230  JTAG_ShiftInstruction(0x05,4);
	__GETD1N 0x5
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     231 
;     232  JTAG_Tap(0x3,4);
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_Tap
;     233  ulData = JTAG_ShiftInstruction(uiCommand, 15);
	MOVW R30,R18
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R30,LOW(15)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
	__PUTD1S 4
;     234  uiResult = ulData >>16;
	CALL __LSRD16
	MOVW R16,R30
;     235  return uiResult;
	MOVW R30,R16
	CALL __LOADLOCR4
	ADIW R28,10
	RET
;     236 }
;     237 //-------------------------------------------------------------------------------------------------------------------------
;     238 // описание: Вход в режим программирования
;     239 // параметры:    нет
;     240 // возвращаемое  значение:  нет
;     241 //-------------------------------------------------------------------------------------------------------------------------
;     242 void JTAG_EnteringProgramming(void)
;     243 {
_JTAG_EnteringProgramming:
;     244   JTAG_Tap(0xFFFF,16);
	__GETD1N 0xFFFF
	CALL __PUTPARD1
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _JTAG_Tap
;     245   JTAG_Tap(0x0000,16);
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _JTAG_Tap
;     246 
;     247   JTAG_Tap(0x3,4);
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_Tap
;     248   JTAG_ShiftInstruction(0xC,4);
	__GETD1N 0xC
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     249   JTAG_Tap(0x3,4);
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_Tap
;     250   JTAG_ShiftInstruction(0x01,1);
	__GETD1N 0x1
	CALL __PUTPARD1
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     251 
;     252   JTAG_Tap(0x0D,6);
	__GETD1N 0xD
	CALL __PUTPARD1
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _JTAG_Tap
;     253   JTAG_ShiftInstruction(0x4,4);
	__GETD1N 0x4
	CALL __PUTPARD1
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     254   JTAG_Tap(0x3,4);
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_Tap
;     255   JTAG_ShiftInstruction(0xA370,16);
	__GETD1N 0xA370
	CALL __PUTPARD1
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     256 }
	RET
;     257 //-------------------------------------------------------------------------------------------------------------------------
;     258 // описание: Выход из режима программирования
;     259 // параметры:    нет
;     260 // возвращаемое  значение:  нет
;     261 //-------------------------------------------------------------------------------------------------------------------------
;     262 void JTAG_LeavingProgramming(void)
;     263 {
_JTAG_LeavingProgramming:
;     264  JTAG_WriteProgCmd(0x23, 0x00);
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     265  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     266 
;     267  JTAG_Tap(0x0D,6);
	__GETD1N 0xD
	CALL __PUTPARD1
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _JTAG_Tap
;     268  JTAG_ShiftInstruction(0x04,4);
	__GETD1N 0x4
	CALL __PUTPARD1
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     269  JTAG_Tap(0x3,4);
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_Tap
;     270  JTAG_ShiftInstruction(0x0000,15);
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R30,LOW(15)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     271 
;     272  JTAG_Tap(0x0D,6);
	__GETD1N 0xD
	CALL __PUTPARD1
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL _JTAG_Tap
;     273  JTAG_ShiftInstruction(0xC,4);
	__GETD1N 0xC
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     274  JTAG_Tap(0x3,4);
	__GETD1N 0x3
	CALL __PUTPARD1
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_Tap
;     275  JTAG_ShiftInstruction(0x00,1);
	__GETD1N 0x0
	CALL __PUTPARD1
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _JTAG_ShiftInstruction
;     276 }
	RET
;     277 //-------------------------------------------------------------------------------------------------------------------------
;     278 // описание: Вход в режим программирования
;     279 // параметры:    нет
;     280 // возвращаемое  значение:  нет
;     281 //-------------------------------------------------------------------------------------------------------------------------
;     282 void JTAG_EnterProgMode(void)
;     283 {
_JTAG_EnterProgMode:
;     284  JTAG_EnteringProgramming();
	CALL _JTAG_EnteringProgramming
;     285  cJTAG_prog_mode = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
;     286 }
	RET
;     287 //-------------------------------------------------------------------------------------------------------------------------
;     288 // описание: Выход из режима программирования
;     289 // параметры:    нет
;     290 // возвращаемое  значение:  нет
;     291 //-------------------------------------------------------------------------------------------------------------------------
;     292 void JTAG_LeaveProgMode(void)
;     293 {
_JTAG_LeaveProgMode:
;     294  JTAG_LeavingProgramming();
	CALL _JTAG_LeavingProgramming
;     295  cJTAG_prog_mode = 0;
	CLR  R4
;     296 }
	RET
;     297 //-------------------------------------------------------------------------------------------------------------------------
;     298 // описание: Проверка режима программирования
;     299 // параметры:    нет
;     300 // возвращаемое  значение:  нет
;     301 //-------------------------------------------------------------------------------------------------------------------------
;     302 char JTAG_CheckProgMode(void)
;     303 {
_JTAG_CheckProgMode:
;     304  return cJTAG_prog_mode;
	MOV  R30,R4
	RET
;     305 }
;     306 //-------------------------------------------------------------------------------------------------------------------------
;     307 // описание: Чтение сигнатуры
;     308 // параметры:    нет
;     309 // возвращаемое  значение:  нет
;     310 //-------------------------------------------------------------------------------------------------------------------------
;     311 unsigned long JTAG_ReadSignature(void)
;     312 {
_JTAG_ReadSignature:
;     313  unsigned char ucByte;
;     314  unsigned long ulResult;
;     315 
;     316  ulResult =0;
	SBIW R28,4
	ST   -Y,R17
;	ucByte -> R17
;	ulResult -> Y+1
	__CLRD1S 1
;     317  // 9a : Enter Signature Byte Read
;     318  JTAG_WriteProgCmd(0x23, 0x08);
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     319 
;     320  // 9b Load Addres 0x00
;     321  JTAG_WriteProgCmd(0x03, 0x00);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     322  // 9c Read Signature Byte
;     323  JTAG_WriteProgCmd(0x32, 0x00);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     324  ucByte = JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     325  ulResult = ucByte;
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	__PUTD1S 1
;     326 
;     327  // 9b Load Addres 0x01
;     328  JTAG_WriteProgCmd(0x03, 0x01);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     329  // 9c Read Signature Byte
;     330  JTAG_WriteProgCmd(0x32, 0x00);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     331  ucByte = JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     332  ulResult = (ulResult << 8) | ucByte;
	__GETD2S 1
	LDI  R30,LOW(8)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 1
;     333 
;     334  // 9b Load Addres 0x02
;     335  JTAG_WriteProgCmd(0x03, 0x02);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     336  // 9c Read Signature Byte
;     337  JTAG_WriteProgCmd(0x32, 0x00);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     338  ucByte   = JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     339  ulResult = (ulResult << 8) | ucByte;
	__GETD2S 1
	LDI  R30,LOW(8)
	CALL __LSLD12
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R17
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __ORD12
	__PUTD1S 1
;     340 
;     341  return ulResult;
	LDD  R17,Y+0
	ADIW R28,5
	RET
;     342 }
;     343 //-------------------------------------------------------------------------------------------------------------------------
;     344 // описание: Чтение калибрационного байта
;     345 // параметры:    нет
;     346 // возвращаемое  значение:  нет
;     347 //-------------------------------------------------------------------------------------------------------------------------
;     348 unsigned char JTAG_ReadCalibration(void)
;     349 {
_JTAG_ReadCalibration:
;     350  unsigned char ucByte;
;     351 
;     352  // 10a : Enter Calibration Byte Read
;     353  JTAG_WriteProgCmd(0x23, 0x08);
	ST   -Y,R17
;	ucByte -> R17
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     354  // 10b : Load Address
;     355  JTAG_WriteProgCmd(0x03, 0x00);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     356  // 10c : Read Calibration
;     357  JTAG_WriteProgCmd(0x36, 0x00);
	LDI  R30,LOW(54)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     358  ucByte = JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     359  return ucByte;
	MOV  R30,R17
	RJMP _0xAA
;     360 }
;     361 //-------------------------------------------------------------------------------------------------------------------------
;     362 // описание: Чтение байта Ext Fuse битов
;     363 // параметры:    нет
;     364 // возвращаемое  значение:  нет
;     365 //-------------------------------------------------------------------------------------------------------------------------
;     366 unsigned char JTAG_ReadFuseExt(void)
;     367 {
_JTAG_ReadFuseExt:
;     368  unsigned char ucByte;
;     369  // 8a : Enter Fuse/Lock Bit Read
;     370  JTAG_WriteProgCmd(0x23, 0x04);
	ST   -Y,R17
;	ucByte -> R17
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     371  // 8b : Read Fuse High
;     372  JTAG_WriteProgCmd(0x3A, 0x00);
	LDI  R30,LOW(58)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     373  ucByte = JTAG_WriteProgCmd(0x3B, 0x00);
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     374  return ucByte;
	MOV  R30,R17
	RJMP _0xAA
;     375 }
;     376 //-------------------------------------------------------------------------------------------------------------------------
;     377 // описание: Запись байта Ext Fuse битов
;     378 // параметры:    нет
;     379 // возвращаемое  значение:  нет
;     380 //-------------------------------------------------------------------------------------------------------------------------
;     381 void JTAG_WriteFuseExt(unsigned char ucData)
;     382 {
_JTAG_WriteFuseExt:
;     383  // 6a : Enter Write Fuse Write
;     384  JTAG_WriteProgCmd(0x23, 0x40);
;	ucData -> Y+0
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     385  // 6b : load data
;     386  JTAG_WriteProgCmd(0x13, ucData) ;
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     387  // 6c : write fuse high
;     388  JTAG_WriteProgCmd(0x3B, 0x00);
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     389  JTAG_WriteProgCmd(0x39, 0x00);
	LDI  R30,LOW(57)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     390  JTAG_WriteProgCmd(0x3B, 0x00);
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     391  JTAG_WriteProgCmd(0x3B, 0x00);
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     392 
;     393  // 6d : poll for write complete
;     394  while ((JTAG_WriteProgCmd(0x3B, 0x00)& 0x200) == 0); // 0x37 in thedoc. Is it a typo?
_0x16:
	LDI  R30,LOW(59)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BREQ _0x16
;     395 
;     396 }
	RJMP _0xA9
;     397 //-------------------------------------------------------------------------------------------------------------------------
;     398 // описание: Чтение старшего байта Fuse битов
;     399 // параметры:    нет
;     400 // возвращаемое  значение:  нет
;     401 //-------------------------------------------------------------------------------------------------------------------------
;     402 unsigned char JTAG_ReadFuseHigh(void)
;     403 {
_JTAG_ReadFuseHigh:
;     404  unsigned char ucByte;
;     405  // 8a : Enter Fuse/Lock Bit Read
;     406  JTAG_WriteProgCmd(0x23, 0x04);
	ST   -Y,R17
;	ucByte -> R17
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     407  // 8b : Read Fuse High
;     408  JTAG_WriteProgCmd(0x3E, 0x00);
	LDI  R30,LOW(62)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     409  ucByte = JTAG_WriteProgCmd(0x3F, 0x00);
	LDI  R30,LOW(63)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     410  return ucByte;
	MOV  R30,R17
	RJMP _0xAA
;     411 }
;     412 //-------------------------------------------------------------------------------------------------------------------------
;     413 // описание: Запись старшего байта Fuse битов
;     414 // параметры:    нет
;     415 // возвращаемое  значение:  нет
;     416 //-------------------------------------------------------------------------------------------------------------------------
;     417 void JTAG_WriteFuseHigh(unsigned char ucData)
;     418 {
_JTAG_WriteFuseHigh:
;     419 
;     420  // 6a : Enter Write Fuse Write
;     421  JTAG_WriteProgCmd(0x23, 0x40);
;	ucData -> Y+0
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     422  // 6b : load data
;     423  JTAG_WriteProgCmd(0x13, ucData);
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     424  // 6c : write fuse high
;     425  JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     426  JTAG_WriteProgCmd(0x35, 0x00);
	LDI  R30,LOW(53)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     427  JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     428  JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     429 
;     430  // 6d : poll for write complete
;     431  while ((JTAG_WriteProgCmd(0x37, 0x00)& 0x200) == 0);
_0x19:
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BREQ _0x19
;     432 
;     433 }
	RJMP _0xA9
;     434 //-------------------------------------------------------------------------------------------------------------------------
;     435 // описание: Чтение младшего байта Fuse битов
;     436 // параметры:    нет
;     437 // возвращаемое  значение:  нет
;     438 //-------------------------------------------------------------------------------------------------------------------------
;     439 unsigned char JTAG_ReadFuseLow(void)
;     440 {
_JTAG_ReadFuseLow:
;     441  unsigned char ucByte;
;     442  // 8a : Enter Fuse/Lock Bit Read
;     443  JTAG_WriteProgCmd(0x23, 0x04);
	ST   -Y,R17
;	ucByte -> R17
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     444  // 8c : Read Fuse Low
;     445  JTAG_WriteProgCmd(0x32, 0x00);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     446  ucByte = JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     447  return ucByte;
	MOV  R30,R17
	RJMP _0xAA
;     448 }
;     449 //-------------------------------------------------------------------------------------------------------------------------
;     450 // описание: Запись младшего байта Fuse битов
;     451 // параметры:    нет
;     452 // возвращаемое  значение:  нет
;     453 //-------------------------------------------------------------------------------------------------------------------------
;     454 void JTAG_WriteFuseLow(unsigned char ucData)
;     455 {
_JTAG_WriteFuseLow:
;     456 
;     457  // 6a : Enter Write Fuse Write
;     458  JTAG_WriteProgCmd(0x23, 0x40);
;	ucData -> Y+0
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     459  // 6e : load data
;     460  JTAG_WriteProgCmd(0x13, ucData);
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     461  // 6f : write fuse low
;     462  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     463  JTAG_WriteProgCmd(0x31, 0x00);
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     464  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     465  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     466 
;     467  // 6g : poll for write complete
;     468  while ((JTAG_WriteProgCmd(0x33, 0x00) & 0x200) == 0);
_0x1C:
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BREQ _0x1C
;     469 
;     470 }
	RJMP _0xA9
;     471 //-------------------------------------------------------------------------------------------------------------------------
;     472 // описание: Чтение Lock битов
;     473 // параметры:    нет
;     474 // возвращаемое  значение:  нет
;     475 //-------------------------------------------------------------------------------------------------------------------------
;     476 unsigned char JTAG_ReadLock(void)
;     477 {
_JTAG_ReadLock:
;     478  unsigned char ucByte;
;     479  // 8a : Enter Fuse/Lock Bit Read
;     480  JTAG_WriteProgCmd(0x23, 0x04);
	ST   -Y,R17
;	ucByte -> R17
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     481  // 8d : Read Lock
;     482  JTAG_WriteProgCmd(0x36, 0x00);
	LDI  R30,LOW(54)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     483  ucByte = JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     484  return ucByte;
	MOV  R30,R17
_0xAA:
	LD   R17,Y+
	RET
;     485 }
;     486 //-------------------------------------------------------------------------------------------------------------------------
;     487 // описание: Запись Lock битов
;     488 // параметры:    нет
;     489 // возвращаемое  значение:  нет
;     490 //-------------------------------------------------------------------------------------------------------------------------
;     491 void JTAG_WriteLock(unsigned char ucData)
;     492 {
_JTAG_WriteLock:
;     493 
;     494  // 7a : Enter Write Lock Write
;     495  JTAG_WriteProgCmd(0x23, 0x20);
;	ucData -> Y+0
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     496  // 7b : load data
;     497  JTAG_WriteProgCmd(0x13, 0xC0 + (ucData & 0x3F));
	LDI  R30,LOW(19)
	ST   -Y,R30
	LDD  R30,Y+1
	ANDI R30,LOW(0x3F)
	SUBI R30,-LOW(192)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     498  // 7c : write lock
;     499  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     500  JTAG_WriteProgCmd(0x31, 0x00);
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     501  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     502  JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     503 
;     504  // 7d : poll for write complete
;     505  while ((JTAG_WriteProgCmd(0x33, 0x00)& 0x200) == 0);
_0x1F:
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BREQ _0x1F
;     506 
;     507 }
_0xA9:
	ADIW R28,1
	RET
;     508 //-------------------------------------------------------------------------------------------------------------------------
;     509 // описание: Стирание сродержимого микросхемы
;     510 // параметры:    нет
;     511 // возвращаемое  значение:  нет
;     512 //-------------------------------------------------------------------------------------------------------------------------
;     513 void JTAG_ChipErase(void)
;     514 {
_JTAG_ChipErase:
;     515  // 1a : start chip erase
;     516  JTAG_WriteProgCmd(0x23, 0x80);
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     517  JTAG_WriteProgCmd(0x31, 0x80);
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     518  JTAG_WriteProgCmd(0x33, 0x80);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     519  JTAG_WriteProgCmd(0x33, 0x80);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     520  // 1b : poll for chip erase complete
;     521  while ((JTAG_WriteProgCmd(0x33, 0x80) & 0x200) == 0) Nop;
_0x22:
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(128)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BRNE _0x24
	NOP
	JMP  _0x22
_0x24:
;     522 
;     523 }
	RET
;     524 //-------------------------------------------------------------------------------------------------------------------------
;     525 // описание: Чтение страницы из EEPROM памяти
;     526 // параметры:    нет
;     527 // возвращаемое  значение:  нет
;     528 //-------------------------------------------------------------------------------------------------------------------------
;     529 void JTAG_ReadEEpromPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer)
;     530 {
_JTAG_ReadEEpromPage:
;     531  unsigned char ucByte;
;     532  unsigned char ucAddrL;
;     533  unsigned char ucAddrH;
;     534  unsigned int  uiAddrEEProm;
;     535  unsigned int  i;
;     536 
;     537 
;     538  // 5a : Enter EEprom read
;     539  JTAG_WriteProgCmd(0x23, 0x03);
	SBIW R28,2
	CALL __SAVELOCR6
;	uiAddr -> Y+12
;	uiCount -> Y+10
;	*ucBuffer -> Y+8
;	ucByte -> R17
;	ucAddrL -> R16
;	ucAddrH -> R19
;	uiAddrEEProm -> R20,R21
;	i -> Y+6
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     540 
;     541  for(i =0; i < uiCount; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x26:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x27
;     542   {
;     543    uiAddrEEProm = uiAddr + i;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     544    ucAddrL = (unsigned char) uiAddrEEProm;
	MOV  R16,R20
;     545    ucAddrH = (unsigned char) (uiAddrEEProm >> 8);
	MOV  R19,R21
;     546    // 5b : Load Address High
;     547    JTAG_WriteProgCmd(0x07, ucAddrH);
	LDI  R30,LOW(7)
	ST   -Y,R30
	ST   -Y,R19
	CALL _JTAG_WriteProgCmd
;     548    // 5c : Load Address Low
;     549    JTAG_WriteProgCmd(0x03, ucAddrL);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R16
	CALL _JTAG_WriteProgCmd
;     550 
;     551    // 5d : Read Data Byte
;     552    JTAG_WriteProgCmd(0x33, 0x00); //JTAG_WriteProgCmd(0x33, addrL); // TODO: is it a typo in the doc?
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     553    JTAG_WriteProgCmd(0x32, 0x00);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     554    // read data
;     555    ucByte = JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R17,R30
;     556    ucBuffer[i] = ucByte;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
;     557   }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x26
_0x27:
;     558 }
	CALL __LOADLOCR6
	ADIW R28,14
	RET
;     559 //-------------------------------------------------------------------------------------------------------------------------
;     560 // описание: Запись страницы в EEPROM память
;     561 // параметры:    нет
;     562 // возвращаемое  значение:  нет
;     563 //-------------------------------------------------------------------------------------------------------------------------
;     564 void JTAG_WriteEEpromPage(unsigned int uiAddr, unsigned int  uiCount, unsigned char* ucBuffer)
;     565 {
_JTAG_WriteEEpromPage:
;     566  unsigned char ucAddrH;
;     567  unsigned char ucAddrL;
;     568  unsigned char ucByte;
;     569  unsigned int  uiAddrEEProm;
;     570  unsigned int i;
;     571 
;     572  // 4a : Enter EEprom Write
;     573  JTAG_WriteProgCmd(0x23, 0x11);
	SBIW R28,2
	CALL __SAVELOCR6
;	uiAddr -> Y+12
;	uiCount -> Y+10
;	*ucBuffer -> Y+8
;	ucAddrH -> R17
;	ucAddrL -> R16
;	ucByte -> R19
;	uiAddrEEProm -> R20,R21
;	i -> Y+6
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(17)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     574 
;     575  // save data on the JTAG_ port
;     576  for(i =0; i < uiCount; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x29:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2A
;     577   {
;     578    uiAddrEEProm = uiAddr + i;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     579    ucAddrL = (unsigned char) uiAddrEEProm;
	MOV  R16,R20
;     580    ucAddrH = (unsigned char) (uiAddrEEProm >> 8);
	MOV  R17,R21
;     581    // 4b : Load Address High
;     582    JTAG_WriteProgCmd(0x07, ucAddrH);
	LDI  R30,LOW(7)
	ST   -Y,R30
	ST   -Y,R17
	CALL _JTAG_WriteProgCmd
;     583    // 4c : Load Address Low
;     584    JTAG_WriteProgCmd(0x03, ucAddrL);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R16
	CALL _JTAG_WriteProgCmd
;     585 
;     586    // 4d : Load Data low;
;     587    ucByte = ucBuffer[i];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R19,X
;     588    JTAG_WriteProgCmd(0x13,ucByte);
	LDI  R30,LOW(19)
	ST   -Y,R30
	ST   -Y,R19
	CALL _JTAG_WriteProgCmd
;     589 
;     590    // 4f : Latch Data
;     591    JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     592    JTAG_WriteProgCmd(0x77, 0x00);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     593    JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     594   }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x29
_0x2A:
;     595   // 4f : Write EEProm Page
;     596   JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     597   JTAG_WriteProgCmd(0x31, 0x00);
	LDI  R30,LOW(49)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     598   JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     599   JTAG_WriteProgCmd(0x33, 0x00);
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     600 
;     601   // 4g : poll for page write complete
;     602   while ((JTAG_WriteProgCmd(0x33, 0x00) & 0x200) == 0) Nop;
_0x2B:
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BRNE _0x2D
	NOP
	JMP  _0x2B
_0x2D:
;     603 }
	RJMP _0xA8
;     604 //-------------------------------------------------------------------------------------------------------------------------
;     605 // описание: Чтение блока из FLASH памяти
;     606 // параметры:    нет
;     607 // возвращаемое  значение:  нет
;     608 //-------------------------------------------------------------------------------------------------------------------------
;     609 void JTAG_ReadFlashPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer)
;     610 {
_JTAG_ReadFlashPage:
;     611  unsigned char ucAddrH;
;     612  unsigned char ucAddrL;
;     613  unsigned char ucByteL;
;     614  unsigned char ucByteH;
;     615  unsigned int  uiAddrFlash;
;     616  unsigned int  i;
;     617 
;     618  // 3a : Enter Flash read
;     619  JTAG_WriteProgCmd(0x23, 0x02);
	SBIW R28,2
	CALL __SAVELOCR6
;	uiAddr -> Y+12
;	uiCount -> Y+10
;	*ucBuffer -> Y+8
;	ucAddrH -> R17
;	ucAddrL -> R16
;	ucByteL -> R19
;	ucByteH -> R18
;	uiAddrFlash -> R20,R21
;	i -> Y+6
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     620 
;     621  for(i =0; i < uiCount; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x2F:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x30
;     622   {
;     623    uiAddrFlash = uiAddr + i;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     624    ucAddrL = (unsigned char) uiAddrFlash;
	MOV  R16,R20
;     625    ucAddrH = (unsigned char) (uiAddrFlash >> 8);
	MOV  R17,R21
;     626    // 3b : Load Address High
;     627    JTAG_WriteProgCmd(0x07, ucAddrH);
	LDI  R30,LOW(7)
	ST   -Y,R30
	ST   -Y,R17
	CALL _JTAG_WriteProgCmd
;     628    // 3c : Load Address Low
;     629    JTAG_WriteProgCmd(0x03, ucAddrL);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R16
	CALL _JTAG_WriteProgCmd
;     630    // 3d : Read Data Bytes
;     631    JTAG_WriteProgCmd(0x32, 0x00);
	LDI  R30,LOW(50)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     632    ucByteL = JTAG_WriteProgCmd(0x36, 0x00);
	LDI  R30,LOW(54)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R19,R30
;     633    ucByteH = JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	MOV  R18,R30
;     634    ucBuffer[i * 2] = ucByteL;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R19
;     635    ucBuffer[(i * 2) + 1] = ucByteH;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	ADIW R30,1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R18
;     636   }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2F
_0x30:
;     637 }
_0xA8:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
;     638 //-------------------------------------------------------------------------------------------------------------------------
;     639 // описание: Запись страницы во FLASH память
;     640 // параметры:    нет
;     641 // возвращаемое  значение:  нет
;     642 //-------------------------------------------------------------------------------------------------------------------------
;     643 void JTAG_WriteFlashPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer)
;     644 {
_JTAG_WriteFlashPage:
;     645  unsigned char ucAddrE;
;     646  unsigned char ucAddrH;
;     647  unsigned char ucAddrL;
;     648  unsigned int  uiAddrFlash;
;     649  unsigned char ucByteL;
;     650  unsigned char ucByteH;
;     651  unsigned int i;
;     652 
;     653 
;     654  // 2a : Enter Flash Write
;     655  JTAG_WriteProgCmd(0x23, 0x10);
	SBIW R28,3
	CALL __SAVELOCR6
;	uiAddr -> Y+13
;	uiCount -> Y+11
;	*ucBuffer -> Y+9
;	ucAddrE -> R17
;	ucAddrH -> R16
;	ucAddrL -> R19
;	uiAddrFlash -> R20,R21
;	ucByteL -> R18
;	ucByteH -> Y+8
;	i -> Y+6
	LDI  R30,LOW(35)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     656 
;     657  ucAddrE = 0;
	LDI  R17,LOW(0)
;     658  // 2b : Load Address Extended
;     659  JTAG_WriteProgCmd(0x0B, ucAddrE);
	LDI  R30,LOW(11)
	ST   -Y,R30
	ST   -Y,R17
	CALL _JTAG_WriteProgCmd
;     660 
;     661  // save data on the JTAG_ port
;     662  for(i =0; i < uiCount; i++)
	LDI  R30,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x32:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CP   R26,R30
	CPC  R27,R31
	BRLO PC+3
	JMP _0x33
;     663   {
;     664    uiAddrFlash = uiAddr + i;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
;     665    ucAddrL = (unsigned char) uiAddrFlash;
	MOV  R19,R20
;     666    ucAddrH = (unsigned char) (uiAddrFlash >> 8);
	MOV  R16,R21
;     667    // 2c : Load Address High
;     668    JTAG_WriteProgCmd(0x07, ucAddrH);
	LDI  R30,LOW(7)
	ST   -Y,R30
	ST   -Y,R16
	CALL _JTAG_WriteProgCmd
;     669    // 2d : Load Address Low
;     670    JTAG_WriteProgCmd(0x03, ucAddrL);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R19
	CALL _JTAG_WriteProgCmd
;     671 
;     672    ucByteL = ucBuffer[i * 2];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R18,X
;     673    ucByteH = ucBuffer[(i * 2) + 1];
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LSL  R30
	ROL  R31
	ADIW R30,1
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STD  Y+8,R30
;     674 
;     675    // 2e : Load Data low;
;     676    JTAG_WriteProgCmd(0x13, ucByteL);
	LDI  R30,LOW(19)
	ST   -Y,R30
	ST   -Y,R18
	CALL _JTAG_WriteProgCmd
;     677    // 2f : Load Data high
;     678    JTAG_WriteProgCmd(0x17, ucByteH);
	LDI  R30,LOW(23)
	ST   -Y,R30
	LDD  R30,Y+9
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     679 
;     680    // 2e : Latch Data
;     681    JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     682    JTAG_WriteProgCmd(0x77, 0x00);
	LDI  R30,LOW(119)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     683    JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     684   }
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x32
_0x33:
;     685   // 2f : Write Flash Page
;     686   JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     687   JTAG_WriteProgCmd(0x35, 0x00);
	LDI  R30,LOW(53)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     688   JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     689   JTAG_WriteProgCmd(0x37, 0x00);
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
;     690 
;     691   // 2g : poll for page write complete
;     692   while((JTAG_WriteProgCmd(0x37, 0x00) & 0x200) == 0) Nop;
_0x34:
	LDI  R30,LOW(55)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _JTAG_WriteProgCmd
	ANDI R31,HIGH(0x200)
	BRNE _0x36
	NOP
	JMP  _0x34
_0x36:
;     693 }
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;     694 
;     695 
;     696 //----------------------------------------------------------------------------------------------------------------------------
;     697 //Mick Laboratory, Калуга 2014
;     698 //terminal.c  - модуль функций обработки команд.
;     699 //Тип микроконтроллера: atmega16a
;     700 //Автор: Mick (Тарасов Михаил)
;     701 //Версия модуля: 1.00 - 13 марта 2014
;     702 //----------------------------------------------------------------------------------------------------------------------------
;     703 #include "main.h"
;     704 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;     705 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;     706 	.EQU __se_bit=0x40
	.EQU __se_bit=0x40
;     707 	.EQU __sm_mask=0xB0
	.EQU __sm_mask=0xB0
;     708 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;     709 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;     710 	.EQU __sm_standby=0xA0
	.EQU __sm_standby=0xA0
;     711 	.EQU __sm_ext_standby=0xB0
	.EQU __sm_ext_standby=0xB0
;     712 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;     713 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;     714 	#endif
	#endif
;     715 
;     716 #define TERMINAL_SIZE_BUFF		256
;     717 
;     718 
;     719 #define SYNC_CRC			0x20	//' '
;     720 #define SYNC_EOP			0x20	//' '
;     721 
;     722 #define PROG_OK				0x41	//'A'
;     723 #define PROG_ERROR			0x45	//'E'
;     724 
;     725 
;     726 #define PROG_PING                       0x20  	// OUT: [PROG_OK]
;     727 
;     728 #define PROG_VERSION_FIRMWARE           0x21   	// IN:  [SYNC_CRC] [SYNC_EOP]
;     729 						// OUT: [PROG_OK] / [PROG_ERROR]
;     730 						// OUT: [minor version] [major version][PROG_OK]
;     731 #define PROG_JTAG_ENTER_PROG_MODE       0x22   	// IN:  [SYNC_CRC][SYNC_EOP]
;     732 						// OUT: [PROG_OK] / [PROG_ERROR]
;     733 						// OUT: [PROG_OK]
;     734 #define PROG_JTAG_LEAVE_PROG_MODE       0x23   	// IN:  [SYNC_CRC][SYNC_EOP]
;     735 						// OUT: [PROG_OK] / [PROG_ERROR]
;     736 						// OUT: [PROG_OK]
;     737 #define PROG_JTAG_FLASH_PAGE_SIZE      	0x88   	// IN:  [pageSizeL] [pageSizeH] [SYNC_CRC] [SYNC_EOP]
;     738 						// OUT: [PROG_OK] / [PROG_ERROR]
;     739 						// OUT: [PROG_OK]
;     740 #define PROG_JTAG_EEPROM_PAGE_SIZE     	0x89   	// IN:  [pageSizeL] [pageSizeH] [SYNC_CRC] [SYNC_EOP]
;     741 						// OUT: [PROG_OK] / [PROG_ERROR]
;     742 						// OUT: [PROG_OK]
;     743 #define PROG_JTAG_WRITE_FLASH           0xA0   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC][SYNC_EOP]
;     744 					       	// OUT: [PROG_OK] / [PROG_ERROR]
;     745 					       	// IN   [dataL][dataH] [...]
;     746 						// OUT: [PROG_OK] / [PROG_ERROR]
;     747 						// OUT: [PROG_OK]
;     748 #define PROG_JTAG_WRITE_EEPROM          0xA1   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC][SYNC_EOP]
;     749 						// OUT: [PROG_OK] / [PROG_ERROR]
;     750 						// IN   [one byte per data] [...]
;     751 						// OUT: [PROG_OK] / [PROG_ERROR]
;     752 						// OUT: [PROG_OK]
;     753 #define PROG_JTAG_WRITE_FUSE_LOW        0xA2   	// IN:  [fuse_low] [SYNC_CRC] [SYNC_EOP]
;     754 						// OUT: [PROG_OK] / [PROG_ERROR]
;     755 						// OUT: [PROG_OK] / [PROG_ERROR]
;     756 #define PROG_JTAG_WRITE_FUSE_HIGH       0xA3   	// IN:  [fuse_high] [SYNC_CRC] [SYNC_EOP]
;     757 						// OUT: [PROG_OK] / [PROG_ERROR]
;     758 						// OUT: [PROG_OK] / [PROG_ERROR]
;     759 #define PROG_JTAG_WRITE_FUSE_EXT        0xA4   	// IN:  [fuse_ext] [SYNC_CRC] [SYNC_EOP]
;     760 						// OUT: [PROG_OK] / [PROG_ERROR]
;     761 						// OUT: [PROG_OK] / [PROG_ERROR]
;     762 #define PROG_JTAG_WRITE_LOCK            0xA5   	// IN:  [lock] [SYNC_CRC] [SYNC_EOP]
;     763 						// OUT: [PROG_OK] / [PROG_ERROR]
;     764 						// OUT: [PROG_OK] / [PROG_ERROR]
;     765 #define PROG_JTAG_CHIP_ERASE            0xA6   	// IN:  [SYNC_CRC][SYNC_EOP]
;     766 						// OUT: [PROG_OK] / [PROG_ERROR]
;     767 						// OUT: [PROG_OK]
;     768 #define PROG_JTAG_READ_FLASH            0xB0   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC] [SYNC_EOP]
;     769 						// OUT: [PROG_OK] / [PROG_ERROR]
;     770 						// OUT: [dataL][dataH] [...] [PROG_OK]
;     771 #define PROG_JTAG_READ_EEPROM           0xB1   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC] [SYNC_EOP]
;     772 						// OUT: [PROG_OK] / [PROG_ERROR]
;     773 						// OUT: [one byte per data] [...] [PROG_OK]
;     774 #define PROG_JTAG_READ_FUSE_LOW         0xB2   	// IN:  [SYNC_CRC] [SYNC_EOP]
;     775 						// OUT: [PROG_OK] / [PROG_ERROR]
;     776 						// OUT: [fuse_low] [PROG_OK]
;     777 #define PROG_JTAG_READ_FUSE_HIGH        0xB3   	// IN:  [SYNC_CRC] [SYNC_EOP]
;     778 						// OUT: [PROG_OK] / [PROG_ERROR]
;     779 						// OUT: [fuse_high] [PROG_OK]
;     780 #define PROG_JTAG_READ_FUSE_EXT         0xB4   	// IN:  [SYNC_CRC] [SYNC_EOP]
;     781 						// OUT: [PROG_OK] / [PROG_ERROR]
;     782 						// OUT: [fuse_ext] [PROG_OK]
;     783 #define PROG_JTAG_READ_LOCK             0xB5   	// IN:  [SYNC_CRC] [SYNC_EOP]
;     784 						// OUT: [PROG_OK] / [PROG_ERROR]
;     785 						// OUT: [lock] [PROG_OK]
;     786 #define PROG_JTAG_READ_SIGNATURE        0xB6   	// IN:  [SYNC_CRC] [SYNC_EOP]
;     787 						// OUT: [PROG_OK] / [PROG_ERROR]
;     788 						// OUT: [signa1] [signa2] [signa3][0x00] [PROG_OK]
;     789 #define PROG_JTAG_READ_CALIBRATION      0xB7   	// IN: 	[SYNC_CRC] [SYNC_EOP]
;     790 						// OUT: [PROG_OK] / [PROG_ERROR]
;     791 						// OUT: [calibration] [PROG_OK]
;     792 
;     793 #define TERMINAL_CMD_TIMER		250	//1 секунда
;     794 
;     795 #define MAJOR_VERSION		        1
;     796 #define MINOR_VERSION		        0
;     797 
;     798 //----------------------------------------------------------------------------------------------------------------------
;     799 //описание:описание переменных контроллера
;     800 //-----------------------------------------------------------------------------------------------------------------------
;     801  unsigned char ucTerminal_memory_buff[TERMINAL_SIZE_BUFF];	//буфер памяти

	.DSEG
_ucTerminal_memory_buff:
	.BYTE 0x100
;     802  unsigned int  uiTerminal_size_flpage;				//размер страницы FLASH памяти
;     803  unsigned int  uiTerminal_size_eepage;				//размер страницы EEPROM памяти
;     804 //----------------------------------------------------------------------
;     805 // описание:   Инициализация переменных
;     806 // параметры:  нет
;     807 // возвращаемое  значение:   нет
;     808 //----------------------------------------------------------------------
;     809 void Terminal_init(void)
;     810 {

	.CSEG
_Terminal_init:
;     811  uiTerminal_size_flpage =0;				//размер страницы памяти
	CLR  R8
	CLR  R9
;     812  uiTerminal_size_eepage =0;				//размер страницы памяти
	CLR  R10
	CLR  R11
;     813 }
	RET
;     814 //-----------------------------------------------------------------------------------------------------------------------
;     815 // описание:  Анализ управляющих команд
;     816 // параметры:    нет
;     817 // возвращаемое  значение:  нет
;     818 //-------------------------------------------------------------------------------------------------------------------------
;     819 char Terminal_cmd_correct(void)
;     820 {
_Terminal_cmd_correct:
;     821  char i;
;     822  unsigned char ucCmd;
;     823  unsigned int uiTimer;
;     824 
;     825  i =0;
	CALL __SAVELOCR4
;	i -> R17
;	ucCmd -> R16
;	uiTimer -> R18,R19
	LDI  R17,LOW(0)
;     826  uiTimer = CPU_get_timer_ms();				//установим таймер на ожидание команды
	CALL _CPU_get_timer_ms
	MOVW R18,R30
;     827 
;     828  for(;;)
_0x38:
;     829   {
;     830    if((CPU_get_timer_ms() - uiTimer) >= TERMINAL_CMD_TIMER) return 0; //сработал таймер
	CALL _CPU_get_timer_ms
	SUB  R30,R18
	SBC  R31,R19
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRLO _0x3A
	LDI  R30,LOW(0)
	RJMP _0xA7
;     831 
;     832    if(UART_read_check() ==0) continue;			//команд не приходило
_0x3A:
	CALL _UART_read_check
	CPI  R30,0
	BREQ _0x37
;     833    if(i == 0)
	CPI  R17,0
	BRNE _0x3C
;     834     {
;     835      ucCmd = UART_read_byte();
	CALL _UART_read_byte
	MOV  R16,R30
;     836      if(ucCmd != SYNC_CRC) return 0;
	CPI  R16,32
	BREQ _0x3D
	LDI  R30,LOW(0)
	RJMP _0xA7
;     837     }
_0x3D:
;     838    else
	RJMP _0x3E
_0x3C:
;     839     {
;     840      ucCmd = UART_read_byte();
	CALL _UART_read_byte
	MOV  R16,R30
;     841      if(ucCmd != SYNC_EOP) return 0;
	CPI  R16,32
	BREQ _0x3F
	LDI  R30,LOW(0)
	RJMP _0xA7
;     842      break;
_0x3F:
	RJMP _0x39
;     843     }
_0x3E:
;     844    i = i + 1;
	SUBI R17,-LOW(1)
;     845   }
_0x37:
	RJMP _0x38
_0x39:
;     846  return 1;
	LDI  R30,LOW(1)
_0xA7:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;     847 }
;     848 //-----------------------------------------------------------------------------------------------------------------------
;     849 // описание:  Прием данных от Хоста
;     850 // параметры:    нет
;     851 // возвращаемое  значение:  нет
;     852 //-------------------------------------------------------------------------------------------------------------------------
;     853 char Terminal_data_load(unsigned int uiCountByte, unsigned char *ucBuffer)
;     854 {
_Terminal_data_load:
;     855  unsigned char ucByte;
;     856  unsigned int i;
;     857  unsigned int uiTimer;
;     858 
;     859  i =0;
	CALL __SAVELOCR6
;	uiCountByte -> Y+8
;	*ucBuffer -> Y+6
;	ucByte -> R17
;	i -> R18,R19
;	uiTimer -> R20,R21
	__GETWRN 18,19,0
;     860  uiTimer = CPU_get_timer_ms();				//установим таймер на ожидание команды
	CALL _CPU_get_timer_ms
	MOVW R20,R30
;     861 
;     862  for(;;)
_0x41:
;     863   {
;     864    if((CPU_get_timer_ms() - uiTimer) >= TERMINAL_CMD_TIMER) return 0; //сработал таймер
	CALL _CPU_get_timer_ms
	SUB  R30,R20
	SBC  R31,R21
	CPI  R30,LOW(0xFA)
	LDI  R26,HIGH(0xFA)
	CPC  R31,R26
	BRLO _0x43
	LDI  R30,LOW(0)
	RJMP _0xA6
;     865 
;     866    if(UART_read_check() ==0) continue;			//данных пока нет
_0x43:
	CALL _UART_read_check
	CPI  R30,0
	BREQ _0x40
;     867    ucByte = UART_read_byte();
	CALL _UART_read_byte
	MOV  R17,R30
;     868    uiTimer = CPU_get_timer_ms();			//установим таймер на ожидание команды
	CALL _CPU_get_timer_ms
	MOVW R20,R30
;     869    ucBuffer[i] = ucByte;
	MOVW R30,R18
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	ST   Z,R17
;     870    i = i +1;
	__ADDWRN 18,19,1
;     871    if(i >= uiCountByte) break;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R18,R30
	CPC  R19,R31
	BRSH _0x42
;     872   }
_0x40:
	RJMP _0x41
_0x42:
;     873  return 1;
	LDI  R30,LOW(1)
_0xA6:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;     874 }
;     875 //-----------------------------------------------------------------------------------------------------------------------
;     876 // описание:  Анализ управляющих команд
;     877 // параметры:    нет
;     878 // возвращаемое  значение:  нет
;     879 //-------------------------------------------------------------------------------------------------------------------------
;     880 void Terminal_cmd_analyze(void)
;     881 {
_Terminal_cmd_analyze:
;     882   char cResult;
;     883   unsigned char ucCmd;
;     884   unsigned char ucDataByte;
;     885   unsigned int  i;
;     886   unsigned int  uiAddr;
;     887   unsigned int  uiCount;
;     888   unsigned long ulDataLong;
;     889 
;     890   cResult =0;
	SBIW R28,8
	CALL __SAVELOCR6
;	cResult -> R17
;	ucCmd -> R16
;	ucDataByte -> R19
;	i -> R20,R21
;	uiAddr -> Y+12
;	uiCount -> Y+10
;	ulDataLong -> Y+6
	LDI  R17,LOW(0)
;     891 
;     892   if(UART_read_check() ==0) return;			//команд не приходило
	CALL _UART_read_check
	CPI  R30,0
	BRNE _0x46
	RJMP _0xA5
;     893   ucCmd = UART_read_byte();
_0x46:
	CALL _UART_read_byte
	MOV  R16,R30
;     894   CPU_led_state(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _CPU_led_state
;     895 
;     896   switch(ucCmd)
	MOV  R30,R16
;     897    {
;     898     case PROG_PING:
	CPI  R30,LOW(0x20)
	BRNE _0x4A
;     899 		  	cResult =1;
	RJMP _0xAB
;     900         	   	break;
;     901     case PROG_VERSION_FIRMWARE:
_0x4A:
	CPI  R30,LOW(0x21)
	BRNE _0x4B
;     902 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x4C
	RJMP _0x49
;     903  			UART_send_byte(PROG_OK);
_0x4C:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     904 			UART_send_byte(MINOR_VERSION);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _UART_send_byte
;     905 			UART_send_byte(MAJOR_VERSION);
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _UART_send_byte
;     906  		  	cResult =1;
	RJMP _0xAB
;     907         		break;
;     908     case PROG_JTAG_ENTER_PROG_MODE:
_0x4B:
	CPI  R30,LOW(0x22)
	BRNE _0x4D
;     909 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x4E
	RJMP _0x49
;     910 			UART_send_byte(PROG_OK);
_0x4E:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     911 			if(JTAG_CheckProgMode() ==0) JTAG_EnterProgMode();
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x4F
	CALL _JTAG_EnterProgMode
;     912   			cResult =1;
_0x4F:
	RJMP _0xAB
;     913 			break;
;     914     case PROG_JTAG_LEAVE_PROG_MODE:
_0x4D:
	CPI  R30,LOW(0x23)
	BRNE _0x50
;     915 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x51
	RJMP _0x49
;     916 			UART_send_byte(PROG_OK);
_0x51:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     917 			if(JTAG_CheckProgMode() !=0) JTAG_LeaveProgMode();
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BREQ _0x52
	CALL _JTAG_LeaveProgMode
;     918   			cResult =1;
_0x52:
	RJMP _0xAB
;     919 			break;
;     920     case PROG_JTAG_FLASH_PAGE_SIZE:
_0x50:
	CPI  R30,LOW(0x88)
	BRNE _0x53
;     921 			if(Terminal_data_load(2,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x54
	RJMP _0x49
;     922 			if(Terminal_cmd_correct() ==0) break;
_0x54:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x55
	RJMP _0x49
;     923  			UART_send_byte(PROG_OK);
_0x55:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     924 			uiTerminal_size_flpage = ucTerminal_memory_buff[0];
	LDS  R8,_ucTerminal_memory_buff
	CLR  R9
;     925 			uiTerminal_size_flpage = (uiTerminal_size_flpage << 8) | ucTerminal_memory_buff[1];
	MOV  R31,R8
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _ucTerminal_memory_buff,1
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R8,R30
;     926 			cResult = 1;
	RJMP _0xAB
;     927 			break;
;     928     case PROG_JTAG_EEPROM_PAGE_SIZE:
_0x53:
	CPI  R30,LOW(0x89)
	BRNE _0x56
;     929 			if(Terminal_data_load(2,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x57
	RJMP _0x49
;     930 			if(Terminal_cmd_correct() ==0) break;
_0x57:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x58
	RJMP _0x49
;     931  		        UART_send_byte(PROG_OK);
_0x58:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     932 			uiTerminal_size_eepage = ucTerminal_memory_buff[0];
	LDS  R10,_ucTerminal_memory_buff
	CLR  R11
;     933 			uiTerminal_size_eepage = (uiTerminal_size_eepage << 8) | ucTerminal_memory_buff[1];
	MOV  R31,R10
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _ucTerminal_memory_buff,1
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	MOVW R10,R30
;     934 			cResult = 1;
	RJMP _0xAB
;     935   			break;
;     936     case PROG_JTAG_READ_SIGNATURE:
_0x56:
	CPI  R30,LOW(0xB6)
	BRNE _0x59
;     937 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x5A
	RJMP _0x49
;     938 			if(JTAG_CheckProgMode() ==0) break;
_0x5A:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x5B
	RJMP _0x49
;     939 			UART_send_byte(PROG_OK);
_0x5B:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     940   			ulDataLong = JTAG_ReadSignature();
	CALL _JTAG_ReadSignature
	__PUTD1S 6
;     941 			UART_send_byte(ulDataLong >>24);
	__GETD2S 6
	LDI  R30,LOW(24)
	CALL __LSRD12
	ST   -Y,R30
	CALL _UART_send_byte
;     942 			UART_send_byte(ulDataLong >>16);
	__GETD1S 6
	CALL __LSRD16
	ST   -Y,R30
	CALL _UART_send_byte
;     943 			UART_send_byte(ulDataLong >>8);
	__GETD2S 6
	LDI  R30,LOW(8)
	CALL __LSRD12
	ST   -Y,R30
	CALL _UART_send_byte
;     944 			UART_send_byte(ulDataLong);
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _UART_send_byte
;     945  		  	cResult =1;
	RJMP _0xAB
;     946 			break;
;     947     case PROG_JTAG_READ_CALIBRATION:
_0x59:
	CPI  R30,LOW(0xB7)
	BRNE _0x5C
;     948 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x5D
	RJMP _0x49
;     949 			if(JTAG_CheckProgMode() ==0) break;
_0x5D:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x5E
	RJMP _0x49
;     950  			UART_send_byte(PROG_OK);
_0x5E:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     951         		ucDataByte = JTAG_ReadCalibration();
	CALL _JTAG_ReadCalibration
	MOV  R19,R30
;     952 			UART_send_byte(ucDataByte);
	ST   -Y,R19
	CALL _UART_send_byte
;     953  		  	cResult =1;
	RJMP _0xAB
;     954         		break;
;     955     case PROG_JTAG_READ_FUSE_EXT:
_0x5C:
	CPI  R30,LOW(0xB4)
	BRNE _0x5F
;     956 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x60
	RJMP _0x49
;     957 			if(JTAG_CheckProgMode() ==0) break;
_0x60:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x61
	RJMP _0x49
;     958 			UART_send_byte(PROG_OK);
_0x61:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     959         		ucDataByte = JTAG_ReadFuseExt();
	CALL _JTAG_ReadFuseExt
	MOV  R19,R30
;     960 			UART_send_byte(ucDataByte);
	ST   -Y,R19
	CALL _UART_send_byte
;     961  		  	cResult =1;
	RJMP _0xAB
;     962         		break;
;     963     case PROG_JTAG_WRITE_FUSE_EXT:
_0x5F:
	CPI  R30,LOW(0xA4)
	BRNE _0x62
;     964 			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x63
	RJMP _0x49
;     965 			if(Terminal_cmd_correct() ==0) break;
_0x63:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x64
	RJMP _0x49
;     966 			if(JTAG_CheckProgMode() ==0) break;
_0x64:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x65
	RJMP _0x49
;     967 			UART_send_byte(PROG_OK);
_0x65:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     968             		JTAG_WriteFuseExt(ucTerminal_memory_buff[0]);
	LDS  R30,_ucTerminal_memory_buff
	ST   -Y,R30
	CALL _JTAG_WriteFuseExt
;     969 			cResult =1;
	RJMP _0xAB
;     970 		        break;
;     971     case PROG_JTAG_READ_FUSE_HIGH:
_0x62:
	CPI  R30,LOW(0xB3)
	BRNE _0x66
;     972 			if(Terminal_cmd_correct() !=0)
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BREQ _0x67
;     973                          {
;     974 			  if(JTAG_CheckProgMode() ==0) break;
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x68
	RJMP _0x49
;     975 			  UART_send_byte(PROG_OK);
_0x68:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     976         		  ucDataByte = JTAG_ReadFuseHigh();
	CALL _JTAG_ReadFuseHigh
	MOV  R19,R30
;     977 			  UART_send_byte(ucDataByte);
	ST   -Y,R19
	CALL _UART_send_byte
;     978  		  	  cResult =1;
	LDI  R17,LOW(1)
;     979 			 }
;     980         		break;
_0x67:
	RJMP _0x49
;     981     case PROG_JTAG_WRITE_FUSE_HIGH:
_0x66:
	CPI  R30,LOW(0xA3)
	BRNE _0x69
;     982 			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x6A
	RJMP _0x49
;     983 			if(Terminal_cmd_correct() ==0) break;
_0x6A:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x6B
	RJMP _0x49
;     984 			if(JTAG_CheckProgMode() ==0) break;
_0x6B:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x6C
	RJMP _0x49
;     985 			UART_send_byte(PROG_OK);
_0x6C:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     986             		JTAG_WriteFuseHigh(ucTerminal_memory_buff[0]);
	LDS  R30,_ucTerminal_memory_buff
	ST   -Y,R30
	CALL _JTAG_WriteFuseHigh
;     987 			cResult =1;
	RJMP _0xAB
;     988 		        break;
;     989     case PROG_JTAG_READ_FUSE_LOW:
_0x69:
	CPI  R30,LOW(0xB2)
	BRNE _0x6D
;     990 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x6E
	RJMP _0x49
;     991 		        if(JTAG_CheckProgMode() ==0) break;
_0x6E:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x6F
	RJMP _0x49
;     992 			UART_send_byte(PROG_OK);
_0x6F:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;     993         		ucDataByte = JTAG_ReadFuseLow();
	CALL _JTAG_ReadFuseLow
	MOV  R19,R30
;     994 			UART_send_byte(ucDataByte);
	ST   -Y,R19
	CALL _UART_send_byte
;     995  		  	cResult =1;
	RJMP _0xAB
;     996         		break;
;     997     case PROG_JTAG_WRITE_FUSE_LOW:
_0x6D:
	CPI  R30,LOW(0xA2)
	BRNE _0x70
;     998 			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x71
	RJMP _0x49
;     999 			if(Terminal_cmd_correct() ==0) break;
_0x71:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x72
	RJMP _0x49
;    1000 			if(JTAG_CheckProgMode() ==0) break;
_0x72:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x73
	RJMP _0x49
;    1001 			UART_send_byte(PROG_OK);
_0x73:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1002             		JTAG_WriteFuseLow(ucTerminal_memory_buff[0]);
	LDS  R30,_ucTerminal_memory_buff
	ST   -Y,R30
	CALL _JTAG_WriteFuseLow
;    1003 			cResult =1;
	RJMP _0xAB
;    1004 		        break;
;    1005     case PROG_JTAG_READ_LOCK:
_0x70:
	CPI  R30,LOW(0xB5)
	BRNE _0x74
;    1006 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x75
	RJMP _0x49
;    1007 			if(JTAG_CheckProgMode() ==0) break;
_0x75:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x76
	RJMP _0x49
;    1008 			UART_send_byte(PROG_OK);
_0x76:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1009           		ucDataByte = JTAG_ReadLock();
	CALL _JTAG_ReadLock
	MOV  R19,R30
;    1010 			UART_send_byte(ucDataByte);
	ST   -Y,R19
	CALL _UART_send_byte
;    1011  		  	cResult =1;
	RJMP _0xAB
;    1012         		break;
;    1013     case PROG_JTAG_WRITE_LOCK:
_0x74:
	CPI  R30,LOW(0xA5)
	BRNE _0x77
;    1014 			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x78
;    1015 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x79
	RJMP _0x49
;    1016 			if(JTAG_CheckProgMode() ==0) break;
_0x79:
_0x78:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x7A
	RJMP _0x49
;    1017 			UART_send_byte(PROG_OK);
_0x7A:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1018             		JTAG_WriteLock(ucTerminal_memory_buff[0]);
	LDS  R30,_ucTerminal_memory_buff
	ST   -Y,R30
	CALL _JTAG_WriteLock
;    1019 			cResult =1;
	RJMP _0xAB
;    1020 		        break;
;    1021     case PROG_JTAG_CHIP_ERASE:
_0x77:
	CPI  R30,LOW(0xA6)
	BRNE _0x7B
;    1022 			if(Terminal_cmd_correct() ==0) break;
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x7C
	RJMP _0x49
;    1023 			if(JTAG_CheckProgMode() ==0) break;
_0x7C:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x7D
	RJMP _0x49
;    1024 			UART_send_byte(PROG_OK);
_0x7D:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1025           		JTAG_ChipErase();
	CALL _JTAG_ChipErase
;    1026 			cResult =1;
	RJMP _0xAB
;    1027         		break;
;    1028     case PROG_JTAG_READ_EEPROM:
_0x7B:
	CPI  R30,LOW(0xB1)
	BREQ PC+3
	JMP _0x7E
;    1029 			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x7F
	RJMP _0x49
;    1030 			if(Terminal_cmd_correct() ==0) break;
_0x7F:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x80
	RJMP _0x49
;    1031 			if(JTAG_CheckProgMode() ==0) break;
_0x80:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x81
	RJMP _0x49
;    1032 			uiAddr = ucTerminal_memory_buff[1];
_0x81:
	__GETB1MN _ucTerminal_memory_buff,1
	LDI  R31,0
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1033 			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
	LDD  R31,Y+12
	LDI  R30,LOW(0)
	MOVW R26,R30
	LDS  R30,_ucTerminal_memory_buff
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1034 			uiCount = ucTerminal_memory_buff[3];
	__GETB1MN _ucTerminal_memory_buff,3
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1035 			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
	LDD  R31,Y+10
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _ucTerminal_memory_buff,2
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1036 			if(uiCount > uiTerminal_size_eepage) break;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R10,R26
	CPC  R11,R27
	BRSH _0x82
	RJMP _0x49
;    1037 			UART_send_byte(PROG_OK);
_0x82:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1038 			JTAG_ReadEEpromPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _JTAG_ReadEEpromPage
;    1039 			for(i =0; i < uiCount; i++) UART_send_byte(ucTerminal_memory_buff[i]);
	__GETWRN 20,21,0
_0x84:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x85
	LDI  R26,LOW(_ucTerminal_memory_buff)
	LDI  R27,HIGH(_ucTerminal_memory_buff)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	ST   -Y,R30
	CALL _UART_send_byte
;    1040 			cResult =1;
	__ADDWRN 20,21,1
	RJMP _0x84
_0x85:
	RJMP _0xAB
;    1041         		break;
;    1042     case PROG_JTAG_WRITE_EEPROM:
_0x7E:
	CPI  R30,LOW(0xA1)
	BREQ PC+3
	JMP _0x86
;    1043 			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x87
	RJMP _0x49
;    1044 			if(Terminal_cmd_correct() ==0) break;
_0x87:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x88
	RJMP _0x49
;    1045 			if(JTAG_CheckProgMode() ==0) break;
_0x88:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x89
	RJMP _0x49
;    1046 			uiAddr = ucTerminal_memory_buff[1];
_0x89:
	__GETB1MN _ucTerminal_memory_buff,1
	LDI  R31,0
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1047 			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
	LDD  R31,Y+12
	LDI  R30,LOW(0)
	MOVW R26,R30
	LDS  R30,_ucTerminal_memory_buff
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1048 			uiCount = ucTerminal_memory_buff[3];
	__GETB1MN _ucTerminal_memory_buff,3
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1049 			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
	LDD  R31,Y+10
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _ucTerminal_memory_buff,2
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1050 			if(uiCount > uiTerminal_size_eepage) break;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R10,R26
	CPC  R11,R27
	BRSH _0x8A
	RJMP _0x49
;    1051 			UART_send_byte(PROG_OK);
_0x8A:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1052 			if(Terminal_data_load(uiCount,&ucTerminal_memory_buff[0]) ==0) break;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x8B
	RJMP _0x49
;    1053 			UART_send_byte(PROG_OK);
_0x8B:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1054 			JTAG_WriteEEpromPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _JTAG_WriteEEpromPage
;    1055 			cResult =1;
	RJMP _0xAB
;    1056         		break;
;    1057     case PROG_JTAG_READ_FLASH:
_0x86:
	CPI  R30,LOW(0xB0)
	BREQ PC+3
	JMP _0x8C
;    1058 			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x8D
	RJMP _0x49
;    1059 			if(Terminal_cmd_correct() ==0) break;
_0x8D:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x8E
	RJMP _0x49
;    1060 			if(JTAG_CheckProgMode() ==0) break;
_0x8E:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x8F
	RJMP _0x49
;    1061 			uiAddr = ucTerminal_memory_buff[1];
_0x8F:
	__GETB1MN _ucTerminal_memory_buff,1
	LDI  R31,0
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1062 			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
	LDD  R31,Y+12
	LDI  R30,LOW(0)
	MOVW R26,R30
	LDS  R30,_ucTerminal_memory_buff
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1063 			uiCount = ucTerminal_memory_buff[3];
	__GETB1MN _ucTerminal_memory_buff,3
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1064 			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
	LDD  R31,Y+10
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _ucTerminal_memory_buff,2
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1065 			if(uiCount > uiTerminal_size_flpage) break;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R8,R26
	CPC  R9,R27
	BRSH _0x90
	RJMP _0x49
;    1066 			UART_send_byte(PROG_OK);
_0x90:
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1067 			JTAG_ReadFlashPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _JTAG_ReadFlashPage
;    1068 			for(i =0; i < (uiCount * 2); i++) UART_send_byte(ucTerminal_memory_buff[i]);
	__GETWRN 20,21,0
_0x92:
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LSL  R30
	ROL  R31
	CP   R20,R30
	CPC  R21,R31
	BRSH _0x93
	LDI  R26,LOW(_ucTerminal_memory_buff)
	LDI  R27,HIGH(_ucTerminal_memory_buff)
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	ST   -Y,R30
	CALL _UART_send_byte
;    1069 			cResult =1;
	__ADDWRN 20,21,1
	RJMP _0x92
_0x93:
	RJMP _0xAB
;    1070         		break;
;    1071     case PROG_JTAG_WRITE_FLASH:
_0x8C:
	CPI  R30,LOW(0xA0)
	BREQ PC+3
	JMP _0x49
;    1072 			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BRNE _0x95
	RJMP _0x49
;    1073 			if(Terminal_cmd_correct() ==0) break;
_0x95:
	CALL _Terminal_cmd_correct
	CPI  R30,0
	BRNE _0x96
	RJMP _0x49
;    1074 			if(JTAG_CheckProgMode() ==0) break;
_0x96:
	CALL _JTAG_CheckProgMode
	CPI  R30,0
	BRNE _0x97
	RJMP _0x49
;    1075 			uiAddr = ucTerminal_memory_buff[1];
_0x97:
	__GETB1MN _ucTerminal_memory_buff,1
	LDI  R31,0
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1076 			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
	LDD  R31,Y+12
	LDI  R30,LOW(0)
	MOVW R26,R30
	LDS  R30,_ucTerminal_memory_buff
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+12,R30
	STD  Y+12+1,R31
;    1077 			uiCount = ucTerminal_memory_buff[3];
	__GETB1MN _ucTerminal_memory_buff,3
	LDI  R31,0
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1078 			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
	LDD  R31,Y+10
	LDI  R30,LOW(0)
	MOVW R26,R30
	__GETB1MN _ucTerminal_memory_buff,2
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
;    1079 			if(uiCount > uiTerminal_size_flpage) break;
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R8,R26
	CPC  R9,R27
	BRLO _0x49
;    1080 			UART_send_byte(PROG_OK);
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1081 			if(Terminal_data_load(uiCount * 2,&ucTerminal_memory_buff[0]) ==0) break;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LSL  R30
	ROL  R31
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _Terminal_data_load
	CPI  R30,0
	BREQ _0x49
;    1082 			UART_send_byte(PROG_OK);
	LDI  R30,LOW(65)
	ST   -Y,R30
	CALL _UART_send_byte
;    1083 			JTAG_WriteFlashPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucTerminal_memory_buff)
	LDI  R31,HIGH(_ucTerminal_memory_buff)
	ST   -Y,R31
	ST   -Y,R30
	CALL _JTAG_WriteFlashPage
;    1084 			cResult =1;
_0xAB:
	LDI  R17,LOW(1)
;    1085 	       		break;
;    1086     }
_0x49:
;    1087   CPU_led_state(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _CPU_led_state
;    1088   if(cResult !=0) UART_send_byte(PROG_OK);
	CPI  R17,0
	BREQ _0x9A
	LDI  R30,LOW(65)
	RJMP _0xAC
;    1089   else UART_send_byte(PROG_ERROR);
_0x9A:
	LDI  R30,LOW(69)
_0xAC:
	ST   -Y,R30
	CALL _UART_send_byte
;    1090 }
_0xA5:
	CALL __LOADLOCR6
	ADIW R28,14
	RET
;    1091 //----------------------------------------------------------------------------------------------------------------------------
;    1092 //Mick Laboratory, Калуга 2014
;    1093 //uart.c  - модуль обсуживания  приемо-передатчика UART
;    1094 //Тип микроконтроллера: atmega16a
;    1095 //Автор: Mick (Тарасов Михаил)
;    1096 //Версия модуля: 1.00 - 13 марта 2014
;    1097 //----------------------------------------------------------------------------------------------------------------------------
;    1098 #include "main.h"
;    1099 	#ifndef __SLEEP_DEFINED__
	#ifndef __SLEEP_DEFINED__
;    1100 	#define __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
;    1101 	.EQU __se_bit=0x40
	.EQU __se_bit=0x40
;    1102 	.EQU __sm_mask=0xB0
	.EQU __sm_mask=0xB0
;    1103 	.EQU __sm_powerdown=0x20
	.EQU __sm_powerdown=0x20
;    1104 	.EQU __sm_powersave=0x30
	.EQU __sm_powersave=0x30
;    1105 	.EQU __sm_standby=0xA0
	.EQU __sm_standby=0xA0
;    1106 	.EQU __sm_ext_standby=0xB0
	.EQU __sm_ext_standby=0xB0
;    1107 	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_adc_noise_red=0x10
;    1108 	.SET power_ctrl_reg=mcucr
	.SET power_ctrl_reg=mcucr
;    1109 	#endif
	#endif
;    1110 
;    1111 #define UART_LEN_INBUFFER	0x3F                    //размер входного буфера 64 байта
;    1112 #define UART_LEN_OUTBUFFER	0x3F                    //размер выходного буфера 64 байта
;    1113 
;    1114 //------------------------------------------------------------------
;    1115 //Описание: переменные UART
;    1116 //------------------------------------------------------------------
;    1117  unsigned char ucUART_receive_rdmarker;			//маркер буфера
;    1118  unsigned char ucUART_receive_wrmarker;			//маркер буфера
;    1119  unsigned char ucUART_inbuf[UART_LEN_INBUFFER +1];		//буфер принимаемой команды

	.DSEG
_ucUART_inbuf:
	.BYTE 0x40
;    1120 
;    1121  unsigned char ucUART_transmit_rdmarker;		//маркер буфера
_ucUART_transmit_rdmarker:
	.BYTE 0x1
;    1122  unsigned char ucUART_transmit_wrmarker;		//маркер буфера
_ucUART_transmit_wrmarker:
	.BYTE 0x1
;    1123  unsigned char ucUART_outbuf[UART_LEN_OUTBUFFER +1];	//буфер принимаемой команды
_ucUART_outbuf:
	.BYTE 0x40
;    1124 //----------------------------------------------------------------------
;    1125 // описание:   Инициализация переменных канала UART
;    1126 // параметры:  нет
;    1127 // возвращаемое  значение:   нет
;    1128 //----------------------------------------------------------------------
;    1129 void UART_init(void)
;    1130 {

	.CSEG
_UART_init:
;    1131  UCSRB  = 0x98;
	LDI  R30,LOW(152)
	OUT  0xA,R30
;    1132  UCSRC  = 0x86;						// 1 стоповых бит, без четности
	LDI  R30,LOW(134)
	OUT  0x20,R30
;    1133  UBRRH  = 0;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;    1134  UBRRL  = 0x07;                                  	// UART 19200 (0x17 = 23)
	LDI  R30,LOW(7)
	OUT  0x9,R30
;    1135  ucUART_transmit_wrmarker =0;
	LDI  R30,LOW(0)
	STS  _ucUART_transmit_wrmarker,R30
;    1136  ucUART_transmit_rdmarker =0;				//длина пакета
	STS  _ucUART_transmit_rdmarker,R30
;    1137  ucUART_receive_wrmarker =0;
	CLR  R12
;    1138  ucUART_receive_rdmarker =0;
	CLR  R13
;    1139 }
	RET
;    1140 //-------------------------------------------------------------------
;    1141 // описание: Проверка состояния приемного буфера
;    1142 // параметры:    нет
;    1143 // возвращаемое  значение:  нет
;    1144 //-------------------------------------------------------------------
;    1145 unsigned char UART_read_check(void)
;    1146 {
_UART_read_check:
;    1147  if(ucUART_receive_rdmarker == ucUART_receive_wrmarker) return 0;//приемный буфер пуст
	CP   R12,R13
	BRNE _0x9C
	LDI  R30,LOW(0)
	RET
;    1148  return 1;
_0x9C:
	LDI  R30,LOW(1)
	RET
;    1149 }
;    1150 //-------------------------------------------------------------------
;    1151 // описание: Чтение байта из приемного буфера
;    1152 // параметры:    нет
;    1153 // возвращаемое  значение:  нет
;    1154 //-------------------------------------------------------------------
;    1155 unsigned char UART_read_byte(void)
;    1156 {
_UART_read_byte:
;    1157  unsigned char ucByte;
;    1158  while(ucUART_receive_rdmarker == ucUART_receive_wrmarker);//ждем если буфер еще пуст
	ST   -Y,R17
;	ucByte -> R17
_0x9D:
	CP   R12,R13
	BREQ _0x9D
;    1159  ucByte = ucUART_inbuf[ucUART_receive_rdmarker];
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_ucUART_inbuf)
	SBCI R31,HIGH(-_ucUART_inbuf)
	LD   R17,Z
;    1160  ucUART_receive_rdmarker = ucUART_receive_rdmarker +1;
	INC  R13
;    1161  ucUART_receive_rdmarker = ucUART_receive_rdmarker & UART_LEN_INBUFFER;
	LDI  R30,LOW(63)
	AND  R13,R30
;    1162  return ucByte;
	MOV  R30,R17
	LD   R17,Y+
	RET
;    1163 }
;    1164 //-------------------------------------------------------------------
;    1165 // описание: Отправка одного байта в UART
;    1166 // параметры:    ucByte - байт данных
;    1167 // возвращаемое  значение:  нет
;    1168 //-------------------------------------------------------------------
;    1169 void UART_send_byte(unsigned char ucByte)
;    1170 {
_UART_send_byte:
;    1171  unsigned char ucMarker;
;    1172  ucMarker = ucUART_transmit_wrmarker + 1;
	ST   -Y,R17
;	ucByte -> Y+1
;	ucMarker -> R17
	LDS  R30,_ucUART_transmit_wrmarker
	SUBI R30,-LOW(1)
	MOV  R17,R30
;    1173  ucMarker = ucMarker & UART_LEN_OUTBUFFER;
	ANDI R17,LOW(63)
;    1174 
;    1175  while(ucMarker == ucUART_transmit_rdmarker);		//ждем если буфер еще не освободился
_0xA0:
	LDS  R30,_ucUART_transmit_rdmarker
	CP   R30,R17
	BREQ _0xA0
;    1176 
;    1177  ucUART_outbuf[ucUART_transmit_wrmarker] = ucByte;
	LDS  R30,_ucUART_transmit_wrmarker
	LDI  R31,0
	SUBI R30,LOW(-_ucUART_outbuf)
	SBCI R31,HIGH(-_ucUART_outbuf)
	LDD  R26,Y+1
	STD  Z+0,R26
;    1178  ucUART_transmit_wrmarker = ucMarker;			//новое занчение указателя
	STS  _ucUART_transmit_wrmarker,R17
;    1179  UCSRB = UCSRB | 0x20;					//разрешим передачу символа
	SBI  0xA,5
;    1180 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;    1181 //-------------------------------------------------------------------
;    1182 // описание: Обработка прерывание от приемника UART
;    1183 // параметры:    нет
;    1184 // возвращаемое  значение:  нет
;    1185 //-------------------------------------------------------------------
;    1186 interrupt [USART_RXC] void Uart_rxc(void)
;    1187 {
_Uart_rxc:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
;    1188  ucUART_inbuf[ucUART_receive_wrmarker] = UDR;          //сохраним принятый байт в приемном буфере
	MOV  R26,R12
	LDI  R27,0
	SUBI R26,LOW(-_ucUART_inbuf)
	SBCI R27,HIGH(-_ucUART_inbuf)
	IN   R30,0xC
	ST   X,R30
;    1189  ucUART_receive_wrmarker = ucUART_receive_wrmarker +1;
	INC  R12
;    1190  ucUART_receive_wrmarker = ucUART_receive_wrmarker & UART_LEN_INBUFFER;
	LDI  R30,LOW(63)
	AND  R12,R30
;    1191 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    1192 //-------------------------------------------------------------------
;    1193 // описание: Обработка прерывание от передатчика UART
;    1194 // параметры:    нет
;    1195 // возвращаемое  значение:  нет
;    1196 //-------------------------------------------------------------------
;    1197 interrupt [USART_DRE] void Uart_dre(void)
;    1198 {
_Uart_dre:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    1199  if(ucUART_transmit_wrmarker != ucUART_transmit_rdmarker)//буфер еще не пуст
	LDS  R30,_ucUART_transmit_rdmarker
	LDS  R26,_ucUART_transmit_wrmarker
	CP   R30,R26
	BREQ _0xA3
;    1200   {
;    1201    PORTB = PORTB ^ 0x08;
	IN   R30,0x18
	LDI  R26,LOW(8)
	EOR  R30,R26
	OUT  0x18,R30
;    1202    UDR = ucUART_outbuf[ucUART_transmit_rdmarker];
	LDS  R30,_ucUART_transmit_rdmarker
	LDI  R31,0
	SUBI R30,LOW(-_ucUART_outbuf)
	SBCI R31,HIGH(-_ucUART_outbuf)
	LD   R30,Z
	OUT  0xC,R30
;    1203    ucUART_transmit_rdmarker = ucUART_transmit_rdmarker + 1;
	LDS  R30,_ucUART_transmit_rdmarker
	SUBI R30,-LOW(1)
	STS  _ucUART_transmit_rdmarker,R30
;    1204    ucUART_transmit_rdmarker = ucUART_transmit_rdmarker & UART_LEN_OUTBUFFER;
	ANDI R30,LOW(0x3F)
	STS  _ucUART_transmit_rdmarker,R30
;    1205   }
;    1206  else UCSRB = UCSRB & 0xDF;
	RJMP _0xA4
_0xA3:
	CBI  0xA,5
;    1207 }
_0xA4:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI


__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSRD1:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
