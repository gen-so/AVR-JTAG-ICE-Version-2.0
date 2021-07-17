//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//main.c  - модуль основных функций
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: v1.00 - 13 марта 2014 
//----------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//main.c  - модуль основных функций
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: v1.00 - 13 марта 2014 
//----------------------------------------------------------------------------------------------------------------------------
// CodeVisionAVR C Compiler
// (C) 1998-2001 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega16
#pragma used+
#pragma used+
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// Needed by the power management functions (sleep.h)
#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
extern void CPU_init(void);
extern unsigned int CPU_get_timer_ms(void);
extern void CPU_led_state(char cState);
//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//uart.c  - модуль обсуживания  приемо-передатчика UART
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)  
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
extern void UART_init(void);
extern void UART_init(void);
extern unsigned char UART_read_check(void);
extern unsigned char UART_read_byte(void);
extern void UART_send_byte(unsigned char ucByte);
//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//terminal.c  - модуль функций обработки команд.
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
extern void Terminal_init(void);
extern void Terminal_init(void);
extern char Terminal_cmd_correct(void);
extern char Terminal_data_load(unsigned int uiCountByte, unsigned char *ucBuffer);
extern void Terminal_cmd_analyze(void);
//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//jtag.c  - модуль функций обработки JTAG команд.
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
// ---------------------------------------------------------------------------
// JTAG IR codes 
// ---------------------------------------------------------------------------
extern void JTAG_Init(void);
extern void JTAG_Init(void);
extern void JTAG_Tap(unsigned long ulState, unsigned char ucCount);
extern unsigned long JTAG_ShiftInstruction(unsigned long ulInstruction, unsigned char ucCount);
extern unsigned int JTAG_WriteProgCmd(unsigned char ucCmdH, unsigned char ucCmdL);
extern void JTAG_EnteringProgramming(void);
extern void JTAG_LeavingProgramming(void);
extern unsigned long JTAG_ReadSignature(void);
extern unsigned char JTAG_ReadCalibration(void);
extern unsigned char JTAG_ReadFuseExt(void);
extern void JTAG_WriteFuseExt(unsigned char ucData);
extern unsigned char JTAG_ReadFuseHigh(void);
extern void JTAG_WriteFuseHigh(unsigned char ucData);
extern unsigned char JTAG_ReadFuseLow(void);
extern void JTAG_WriteFuseLow(unsigned char ucData);
extern unsigned char JTAG_ReadLock(void);
extern void JTAG_WriteLock(unsigned char ucData);
extern void JTAG_ChipErase(void);
extern void JTAG_ReadEEpromPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer);
extern void JTAG_WriteEEpromPage(unsigned int uiAddr, unsigned int  uiCount, unsigned char* ucBuffer);
extern void JTAG_ReadFlashPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer);
extern void JTAG_WriteFlashPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer);
extern void JTAG_EnterProgMode(void);
extern void JTAG_LeaveProgMode(void);
extern char JTAG_CheckProgMode(void);
//-------------------------------------------------------------
//описание:описание переменных контроллера
//-------------------------------------------------------------
 unsigned char ucCPU_led_timer;
 unsigned int  uiCPU_ms_timer;
//-------------------------------------------------------------------------------------------------------------------------
// описание:  инициализация оборудования .
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void CPU_init(void)
{
  PORTA = 0xFF;                                         //порт A на вход
  DDRA  = 0x00;						
  PORTB = 0xFF;                                         //порт B кофигурируем как:
  DDRB  = 0xAA;						//TMS,STATUS,TDI,TCK - выходы
  PORTC = 0xFF;                                         //порт C на вход
  DDRC  = 0x00;						
  PORTD = 0xF7;                         		//порт D на вход: RXD, CSAVR, DATKK, DATKM,CLKK,CLKM 
  DDRD  = 0x09;				                //выход: TXD =1, RES =0
  ACSR  = 0x80;  					
  MCUCR = 0x00;						//запретим внешние прерывания
  GICR  = 0x00; 
  TCCR0 = 0x04;						// 8-битный таймер используем CLK/256
  TCNT0 = 140		;					//прерывание по таймеру 
  TIMSK = 0x01;						//внутреннее прерывание от 8 - битного таймера   
  TIFR  = 0x01;						//очистим флаг прерывания от 16 - ти битного таймера
 }                                     
//----------------------------------------------------------
//описание:     включить/выключить светодиод
//параметры:    cState  -   состояние светодиода
//возвращаемое  значение:  нет
//---------------------------------------------------------
void CPU_led_state(char cState)
{
 if(cState ==0) PORTB = PORTB | 0x08;
 else PORTB = PORTB & 0xF7;
 ucCPU_led_timer = 0;
}
//-------------------------------------------------------------------
// описание: прочитать состояние системных тиков
// параметры:       нет
// возвращаемое  значение:    количество системных тиков
//-------------------------------------------------------------------
unsigned int CPU_get_timer_ms(void)
{
 return uiCPU_ms_timer;
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  управление основным процессом.
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void main(void)
{
 { #asm("CLI") };					//#asm("CLI")
 CPU_init();						// инициализация микроконтроллера
 uiCPU_ms_timer  = 0;
 ucCPU_led_timer = 0;
 JTAG_Init();
 UART_init();
 Terminal_init();
 { #asm("SEI") };                               	//#asm("SEI")
 for(;;)
  {
   Terminal_cmd_analyze();
   if(ucCPU_led_timer >= 250) 
     {
      ucCPU_led_timer = 0; 
      PORTB = PORTB ^ 0x08;
     } 
  }
}
//------------------------------------------------------------------------------------------------------------------------
// описание: обработка прерывания от  8 - битного таймера (через каждые 4,096mc)
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
interrupt [10] void Timer0_overlow(void)
{
 TIFR = TIFR | 0x01;					//очистим флаг прерывания от 8 - ти битного таймера
 TCNT0 = 140		;					//прерывание по таймеру происходит через 4мс 
 uiCPU_ms_timer = uiCPU_ms_timer + 1;			//увеличиваем счетчик системных тиков 
 ucCPU_led_timer = ucCPU_led_timer +1; 
}
