//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//jtag.c  - модуль функций обработки JTAG команд.
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
//Примечание: За основу данного модуля взяты исходники проектов Lavor -> Laurent Saint-Marcel (lstmarcel@yahoo.fr) и
//JTAGFlasher безымянного русскоязычного программиста (найдено в просторах интернета)
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
//----------------------------------------------------------------------------------------------------------------------
//описание:описание переменных контроллера
//-----------------------------------------------------------------------------------------------------------------------
 char cJTAG_prog_mode;					//флаг режима программирования 
//-------------------------------------------------------------------------------------------------------------------------
// описание: Инициализация JTAG 
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_Init(void)
{
  PORTB = 0xFF;
  DDRB = DDRB & ~0x40;
  DDRB = DDRB | (0x02 | 0x20 | 0x80) ;
  cJTAG_prog_mode = 0;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Формирование TAP последовательности JTAG
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_Tap(unsigned long ulState, unsigned char ucCount)
 {
  unsigned char i;
  PORTB = PORTB & ~0x80;
  PORTB = PORTB & ~0x02;
  for(i =0; i < ucCount; i++)
   {
    if((ulState & 0x01)!= 0) PORTB = PORTB | 0x02; 
    else PORTB = PORTB & ~0x02;
    ulState = ulState >> 1;
    PORTB = PORTB | 0x80;
    PORTB = PORTB & ~0x80;
   }
 }
//-------------------------------------------------------------------------------------------------------------------------
// описание: Отправка данных в JTAG
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned long JTAG_ShiftInstruction(unsigned long ulInstruction, unsigned char ucCount)
 {
  unsigned char i;
  unsigned long ulResult;
  ulResult =0; 
  PORTB = PORTB & ~0x02;
  PORTB = PORTB & ~0x80;
  for( i =0; i < ucCount; i++)
   {
    if((ulInstruction & 0x01) != 0) PORTB = PORTB | 0x20; 
    else PORTB = PORTB & ~0x20;
    ulInstruction = ulInstruction >>1;
    if(i == (ucCount-1)) PORTB = PORTB | 0x02; // последний бит JTAG инструкции: подготовим уход из Shift-IR
    PORTB = PORTB | 0x80;
    if ((PINB & 0x40) != 0) ulResult = ulResult | 0x80000000;
    ulResult = ulResult >>1;
    PORTB = PORTB & ~0x80;
   }
  return ulResult;
 }
//-------------------------------------------------------------------------------------------------------------------------
// описание: Вывод команды в JTAG интерфейс
// параметры:    нет
// возвращаемое  значение:  uiResult - ответ устройства
//-------------------------------------------------------------------------------------------------------------------------
unsigned int JTAG_WriteProgCmd(unsigned char ucCmdH, unsigned char ucCmdL)
{
 unsigned int uiResult;
 unsigned int uiCommand;
 unsigned long ulData;
 uiCommand = ucCmdH;
 uiCommand = (uiCommand << 8) | ucCmdL;
 JTAG_Tap(0x0D,6);
 JTAG_ShiftInstruction(0x05,4);
 JTAG_Tap(0x3,4);
 ulData = JTAG_ShiftInstruction(uiCommand, 15);
 uiResult = ulData >>16;
 return uiResult;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Вход в режим программирования
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_EnteringProgramming(void)
{
  JTAG_Tap(0xFFFF,16);
  JTAG_Tap(0x0000,16);
  JTAG_Tap(0x3,4);
  JTAG_ShiftInstruction(0xC,4);
  JTAG_Tap(0x3,4);
  JTAG_ShiftInstruction(0x01,1);
  JTAG_Tap(0x0D,6);
  JTAG_ShiftInstruction(0x4,4);
  JTAG_Tap(0x3,4);
  JTAG_ShiftInstruction(0xA370,16);
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Выход из режима программирования
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_LeavingProgramming(void)
{
 JTAG_WriteProgCmd(0x23, 0x00);
 JTAG_WriteProgCmd(0x33, 0x00);
 JTAG_Tap(0x0D,6);
 JTAG_ShiftInstruction(0x04,4);
 JTAG_Tap(0x3,4);
 JTAG_ShiftInstruction(0x0000,15);
 JTAG_Tap(0x0D,6);
 JTAG_ShiftInstruction(0xC,4);
 JTAG_Tap(0x3,4);
 JTAG_ShiftInstruction(0x00,1);
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Вход в режим программирования
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_EnterProgMode(void)
{
 JTAG_EnteringProgramming();
 cJTAG_prog_mode = 1;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Выход из режима программирования
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_LeaveProgMode(void)
{
 JTAG_LeavingProgramming();
 cJTAG_prog_mode = 0;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Проверка режима программирования
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
char JTAG_CheckProgMode(void)
{
 return cJTAG_prog_mode;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение сигнатуры
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned long JTAG_ReadSignature(void)
{
 unsigned char ucByte;
 unsigned long ulResult;
 ulResult =0; 
 // 9a : Enter Signature Byte Read
 JTAG_WriteProgCmd(0x23, 0x08); 
 // 9b Load Addres 0x00
 JTAG_WriteProgCmd(0x03, 0x00); 
 // 9c Read Signature Byte
 JTAG_WriteProgCmd(0x32, 0x00); 
 ucByte = JTAG_WriteProgCmd(0x33, 0x00);
 ulResult = ucByte;
  // 9b Load Addres 0x01
 JTAG_WriteProgCmd(0x03, 0x01); 
 // 9c Read Signature Byte
 JTAG_WriteProgCmd(0x32, 0x00);
 ucByte = JTAG_WriteProgCmd(0x33, 0x00);
 ulResult = (ulResult << 8) | ucByte;
 // 9b Load Addres 0x02
 JTAG_WriteProgCmd(0x03, 0x02);
 // 9c Read Signature Byte 
 JTAG_WriteProgCmd(0x32, 0x00); 
 ucByte   = JTAG_WriteProgCmd(0x33, 0x00);
 ulResult = (ulResult << 8) | ucByte;
 return ulResult;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение калибрационного байта 
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned char JTAG_ReadCalibration(void)
{
 unsigned char ucByte;
 // 10a : Enter Calibration Byte Read
 JTAG_WriteProgCmd(0x23, 0x08); 
 // 10b : Load Address
 JTAG_WriteProgCmd(0x03, 0x00); 
 // 10c : Read Calibration
 JTAG_WriteProgCmd(0x36, 0x00);
 ucByte = JTAG_WriteProgCmd(0x37, 0x00);
 return ucByte;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение байта Ext Fuse битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned char JTAG_ReadFuseExt(void)
{
 unsigned char ucByte;
 // 8a : Enter Fuse/Lock Bit Read
 JTAG_WriteProgCmd(0x23, 0x04); 
 // 8b : Read Fuse High
 JTAG_WriteProgCmd(0x3A, 0x00); 
 ucByte = JTAG_WriteProgCmd(0x3B, 0x00);
 return ucByte;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Запись байта Ext Fuse битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_WriteFuseExt(unsigned char ucData)
{
 // 6a : Enter Write Fuse Write
 JTAG_WriteProgCmd(0x23, 0x40); 
 // 6b : load data
 JTAG_WriteProgCmd(0x13, ucData) ; 
 // 6c : write fuse high
 JTAG_WriteProgCmd(0x3B, 0x00); 
 JTAG_WriteProgCmd(0x39, 0x00); 
 JTAG_WriteProgCmd(0x3B, 0x00); 
 JTAG_WriteProgCmd(0x3B, 0x00); 
 // 6d : poll for write complete 
 while ((JTAG_WriteProgCmd(0x3B, 0x00)& 0x200) == 0); // 0x37 in thedoc. Is it a typo?
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение старшего байта Fuse битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned char JTAG_ReadFuseHigh(void)
{
 unsigned char ucByte;
 // 8a : Enter Fuse/Lock Bit Read
 JTAG_WriteProgCmd(0x23, 0x04); 
 // 8b : Read Fuse High
 JTAG_WriteProgCmd(0x3E, 0x00); 
 ucByte = JTAG_WriteProgCmd(0x3F, 0x00);
 return ucByte;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Запись старшего байта Fuse битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_WriteFuseHigh(unsigned char ucData)
{
 // 6a : Enter Write Fuse Write
 JTAG_WriteProgCmd(0x23, 0x40); 
 // 6b : load data
 JTAG_WriteProgCmd(0x13, ucData); 
 // 6c : write fuse high
 JTAG_WriteProgCmd(0x37, 0x00); 
 JTAG_WriteProgCmd(0x35, 0x00); 
 JTAG_WriteProgCmd(0x37, 0x00); 
 JTAG_WriteProgCmd(0x37, 0x00); 
 // 6d : poll for write complete 
 while ((JTAG_WriteProgCmd(0x37, 0x00)& 0x200) == 0);
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение младшего байта Fuse битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned char JTAG_ReadFuseLow(void)
{
 unsigned char ucByte;
 // 8a : Enter Fuse/Lock Bit Read
 JTAG_WriteProgCmd(0x23, 0x04); 
 // 8c : Read Fuse Low
 JTAG_WriteProgCmd(0x32, 0x00); 
 ucByte = JTAG_WriteProgCmd(0x33, 0x00);
 return ucByte;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Запись младшего байта Fuse битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_WriteFuseLow(unsigned char ucData)
{
 // 6a : Enter Write Fuse Write
 JTAG_WriteProgCmd(0x23, 0x40); 
 // 6e : load data
 JTAG_WriteProgCmd(0x13, ucData); 
 // 6f : write fuse low
 JTAG_WriteProgCmd(0x33, 0x00); 
 JTAG_WriteProgCmd(0x31, 0x00); 
 JTAG_WriteProgCmd(0x33, 0x00); 
 JTAG_WriteProgCmd(0x33, 0x00); 
 // 6g : poll for write complete 
 while ((JTAG_WriteProgCmd(0x33, 0x00) & 0x200) == 0);
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение Lock битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
unsigned char JTAG_ReadLock(void)
{
 unsigned char ucByte;
 // 8a : Enter Fuse/Lock Bit Read
 JTAG_WriteProgCmd(0x23, 0x04); 
 // 8d : Read Lock
 JTAG_WriteProgCmd(0x36, 0x00); 
 ucByte = JTAG_WriteProgCmd(0x37, 0x00);
 return ucByte;
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Запись Lock битов
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_WriteLock(unsigned char ucData)
{
 // 7a : Enter Write Lock Write
 JTAG_WriteProgCmd(0x23, 0x20); 
 // 7b : load data
 JTAG_WriteProgCmd(0x13, 0xC0 + (ucData & 0x3F)); 
 // 7c : write lock
 JTAG_WriteProgCmd(0x33, 0x00); 
 JTAG_WriteProgCmd(0x31, 0x00); 
 JTAG_WriteProgCmd(0x33, 0x00); 
 JTAG_WriteProgCmd(0x33, 0x00); 
 // 7d : poll for write complete
 while ((JTAG_WriteProgCmd(0x33, 0x00)& 0x200) == 0);
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Стирание сродержимого микросхемы
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_ChipErase(void)
{
 // 1a : start chip erase
 JTAG_WriteProgCmd(0x23, 0x80); 
 JTAG_WriteProgCmd(0x31, 0x80);
 JTAG_WriteProgCmd(0x33, 0x80);
 JTAG_WriteProgCmd(0x33, 0x80);
 // 1b : poll for chip erase complete 
 while ((JTAG_WriteProgCmd(0x33, 0x80) & 0x200) == 0) { #asm("NOP") };
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение страницы из EEPROM памяти
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_ReadEEpromPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer)
{
 unsigned char ucByte;
 unsigned char ucAddrL;
 unsigned char ucAddrH;
 unsigned int  uiAddrEEProm;
 unsigned int  i;
 // 5a : Enter EEprom read
 JTAG_WriteProgCmd(0x23, 0x03);        
 for(i =0; i < uiCount; i++) 
  {
   uiAddrEEProm = uiAddr + i;
   ucAddrL = (unsigned char) uiAddrEEProm;
   ucAddrH = (unsigned char) (uiAddrEEProm >> 8);
   // 5b : Load Address High
   JTAG_WriteProgCmd(0x07, ucAddrH);
   // 5c : Load Address Low
   JTAG_WriteProgCmd(0x03, ucAddrL); 
   // 5d : Read Data Byte
   JTAG_WriteProgCmd(0x33, 0x00); //JTAG_WriteProgCmd(0x33, addrL); // TODO: is it a typo in the doc?
   JTAG_WriteProgCmd(0x32, 0x00);
   // read data
   ucByte = JTAG_WriteProgCmd(0x33, 0x00);
   ucBuffer[i] = ucByte;
  } 
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Запись страницы в EEPROM память
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_WriteEEpromPage(unsigned int uiAddr, unsigned int  uiCount, unsigned char* ucBuffer)
{
 unsigned char ucAddrH;
 unsigned char ucAddrL;
 unsigned char ucByte;
 unsigned int  uiAddrEEProm;
 unsigned int i;
 // 4a : Enter EEprom Write
 JTAG_WriteProgCmd(0x23, 0x11);  
 // save data on the JTAG_ port
 for(i =0; i < uiCount; i++) 
  {
   uiAddrEEProm = uiAddr + i;
   ucAddrL = (unsigned char) uiAddrEEProm;
   ucAddrH = (unsigned char) (uiAddrEEProm >> 8);
   // 4b : Load Address High
   JTAG_WriteProgCmd(0x07, ucAddrH);
   // 4c : Load Address Low
   JTAG_WriteProgCmd(0x03, ucAddrL);
   // 4d : Load Data low;
   ucByte = ucBuffer[i];
   JTAG_WriteProgCmd(0x13,ucByte);
   // 4f : Latch Data
   JTAG_WriteProgCmd(0x37, 0x00);
   JTAG_WriteProgCmd(0x77, 0x00);
   JTAG_WriteProgCmd(0x37, 0x00);
  }
  // 4f : Write EEProm Page
  JTAG_WriteProgCmd(0x33, 0x00);
  JTAG_WriteProgCmd(0x31, 0x00);
  JTAG_WriteProgCmd(0x33, 0x00);
  JTAG_WriteProgCmd(0x33, 0x00);
  // 4g : poll for page write complete
  while ((JTAG_WriteProgCmd(0x33, 0x00) & 0x200) == 0) { #asm("NOP") };
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Чтение блока из FLASH памяти
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_ReadFlashPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer)
{
 unsigned char ucAddrH;
 unsigned char ucAddrL;
 unsigned char ucByteL;
 unsigned char ucByteH;
 unsigned int  uiAddrFlash;
 unsigned int  i;
 // 3a : Enter Flash read
 JTAG_WriteProgCmd(0x23, 0x02); 
 for(i =0; i < uiCount; i++) 
  {
   uiAddrFlash = uiAddr + i;
   ucAddrL = (unsigned char) uiAddrFlash;
   ucAddrH = (unsigned char) (uiAddrFlash >> 8);
   // 3b : Load Address High
   JTAG_WriteProgCmd(0x07, ucAddrH);  
   // 3c : Load Address Low
   JTAG_WriteProgCmd(0x03, ucAddrL); 
   // 3d : Read Data Bytes
   JTAG_WriteProgCmd(0x32, 0x00);
   ucByteL = JTAG_WriteProgCmd(0x36, 0x00);
   ucByteH = JTAG_WriteProgCmd(0x37, 0x00);
   ucBuffer[i * 2] = ucByteL;  
   ucBuffer[(i * 2) + 1] = ucByteH;  
  }
}
//-------------------------------------------------------------------------------------------------------------------------
// описание: Запись страницы во FLASH память
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_WriteFlashPage(unsigned int uiAddr, unsigned int uiCount, unsigned char* ucBuffer)
{
 unsigned char ucAddrE;
 unsigned char ucAddrH;
 unsigned char ucAddrL;
 unsigned int  uiAddrFlash;
 unsigned char ucByteL;
 unsigned char ucByteH;
 unsigned int i;
 // 2a : Enter Flash Write
 JTAG_WriteProgCmd(0x23, 0x10);
 ucAddrE = 0; 
 // 2b : Load Address Extended
 JTAG_WriteProgCmd(0x0B, ucAddrE);
 // save data on the JTAG_ port
 for(i =0; i < uiCount; i++) 
  {
   uiAddrFlash = uiAddr + i;
   ucAddrL = (unsigned char) uiAddrFlash;
   ucAddrH = (unsigned char) (uiAddrFlash >> 8);
   // 2c : Load Address High
   JTAG_WriteProgCmd(0x07, ucAddrH);
   // 2d : Load Address Low
   JTAG_WriteProgCmd(0x03, ucAddrL);
   ucByteL = ucBuffer[i * 2];
   ucByteH = ucBuffer[(i * 2) + 1];
   // 2e : Load Data low;
   JTAG_WriteProgCmd(0x13, ucByteL);
   // 2f : Load Data high
   JTAG_WriteProgCmd(0x17, ucByteH);
   // 2e : Latch Data
   JTAG_WriteProgCmd(0x37, 0x00);
   JTAG_WriteProgCmd(0x77, 0x00);
   JTAG_WriteProgCmd(0x37, 0x00);
  }
  // 2f : Write Flash Page
  JTAG_WriteProgCmd(0x37, 0x00);
  JTAG_WriteProgCmd(0x35, 0x00);
  JTAG_WriteProgCmd(0x37, 0x00);
  JTAG_WriteProgCmd(0x37, 0x00);
  // 2g : poll for page write complete
  while((JTAG_WriteProgCmd(0x37, 0x00) & 0x200) == 0) { #asm("NOP") };
}
