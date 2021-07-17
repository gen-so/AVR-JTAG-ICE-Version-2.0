//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//terminal.c  - модуль функций обработки команд.
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
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
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [minor version] [major version][PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] 
					       	// OUT: [PROG_OK] / [PROG_ERROR]
					       	// IN   [dataL][dataH] [...] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// IN   [one byte per data] [...]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [dataL][dataH] [...] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [one byte per data] [...] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [fuse_low] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [fuse_high] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [fuse_ext] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [lock] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [signa1] [signa2] [signa3][0x00] [PROG_OK]
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [calibration] [PROG_OK]
//----------------------------------------------------------------------------------------------------------------------
//описание:описание переменных контроллера
//-----------------------------------------------------------------------------------------------------------------------
 unsigned char ucTerminal_memory_buff[256 ];	//буфер памяти
 unsigned int  uiTerminal_size_flpage;				//размер страницы FLASH памяти 			
 unsigned int  uiTerminal_size_eepage;				//размер страницы EEPROM памяти 			
//----------------------------------------------------------------------
// описание:   Инициализация переменных
// параметры:  нет
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
void Terminal_init(void)
{
 uiTerminal_size_flpage =0;				//размер страницы памяти 			
 uiTerminal_size_eepage =0;				//размер страницы памяти 			
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  Анализ управляющих команд
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
char Terminal_cmd_correct(void)
{
 char i;
 unsigned char ucCmd;
 unsigned int uiTimer;
 i =0;
 uiTimer = CPU_get_timer_ms();				//установим таймер на ожидание команды
  for(;;)
  {
   if((CPU_get_timer_ms() - uiTimer) >= 250	) return 0; //сработал таймер	
   if(UART_read_check() ==0) continue;			//команд не приходило
   if(i == 0)
    {
     ucCmd = UART_read_byte();
     if(ucCmd != 0x20	) return 0;
    }
   else 
    {
     ucCmd = UART_read_byte();
     if(ucCmd != 0x20	) return 0;
     break; 
    }
   i = i + 1;
  } 
 return 1; 
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  Прием данных от Хоста
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
char Terminal_data_load(unsigned int uiCountByte, unsigned char *ucBuffer)
{
 unsigned char ucByte;
 unsigned int i;
 unsigned int uiTimer;
 i =0;
 uiTimer = CPU_get_timer_ms();				//установим таймер на ожидание команды
 for(;;)
  {
   if((CPU_get_timer_ms() - uiTimer) >= 250	) return 0; //сработал таймер	
   if(UART_read_check() ==0) continue;			//данных пока нет
   ucByte = UART_read_byte();
   uiTimer = CPU_get_timer_ms();			//установим таймер на ожидание команды
   ucBuffer[i] = ucByte;
   i = i +1;
   if(i >= uiCountByte) break;
  }
 return 1;
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  Анализ управляющих команд
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
void Terminal_cmd_analyze(void)
{
  char cResult;
  unsigned char ucCmd;
  unsigned char ucDataByte;
  unsigned int  i;
  unsigned int  uiAddr;
  unsigned int  uiCount;
  unsigned long ulDataLong;
  cResult =0;
  if(UART_read_check() ==0) return;			//команд не приходило
  ucCmd = UART_read_byte();
  CPU_led_state(1);
  switch(ucCmd) 
   {
    case 0x20  	:
		  	cResult =1;
        	   	break;
    case 0x21   	:
			if(Terminal_cmd_correct() ==0) break;
 			UART_send_byte(0x41	);
			UART_send_byte(0);
			UART_send_byte(1);
 		  	cResult =1;
        		break;
    case 0x22   	:
			if(Terminal_cmd_correct() ==0) break;
			UART_send_byte(0x41	);
			if(JTAG_CheckProgMode() ==0) JTAG_EnterProgMode();
  			cResult =1; 
			break;	
    case 0x23   	:
			if(Terminal_cmd_correct() ==0) break;
			UART_send_byte(0x41	);
			if(JTAG_CheckProgMode() !=0) JTAG_LeaveProgMode();
  			cResult =1; 
			break;	
    case 0x88   	:
			if(Terminal_data_load(2,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
 			UART_send_byte(0x41	);
			uiTerminal_size_flpage = ucTerminal_memory_buff[0];
			uiTerminal_size_flpage = (uiTerminal_size_flpage << 8) | ucTerminal_memory_buff[1];
			cResult = 1;
			break;
    case 0x89   	:
			if(Terminal_data_load(2,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
 		        UART_send_byte(0x41	);
			uiTerminal_size_eepage = ucTerminal_memory_buff[0];
			uiTerminal_size_eepage = (uiTerminal_size_eepage << 8) | ucTerminal_memory_buff[1];
			cResult = 1;
  			break;
    case 0xB6   	:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
  			ulDataLong = JTAG_ReadSignature();
			UART_send_byte(ulDataLong >>24);
			UART_send_byte(ulDataLong >>16);
			UART_send_byte(ulDataLong >>8);
			UART_send_byte(ulDataLong);
 		  	cResult =1;
			break;
    case 0xB7   	:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
 			UART_send_byte(0x41	);
        		ucDataByte = JTAG_ReadCalibration();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case 0xB4   	:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
        		ucDataByte = JTAG_ReadFuseExt();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case 0xA4   	:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
            		JTAG_WriteFuseExt(ucTerminal_memory_buff[0]);
			cResult =1;
		        break;
    case 0xB3   	:
			if(Terminal_cmd_correct() !=0)
                         {
			  if(JTAG_CheckProgMode() ==0) break;
			  UART_send_byte(0x41	);
        		  ucDataByte = JTAG_ReadFuseHigh();
			  UART_send_byte(ucDataByte);
 		  	  cResult =1;
			 }
        		break;
    case 0xA3   	:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
            		JTAG_WriteFuseHigh(ucTerminal_memory_buff[0]);
			cResult =1;
		        break;
    case 0xB2   	:
			if(Terminal_cmd_correct() ==0) break;
		        if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
        		ucDataByte = JTAG_ReadFuseLow();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case 0xA2   	:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
            		JTAG_WriteFuseLow(ucTerminal_memory_buff[0]);
			cResult =1;
		        break;
    case 0xB5   	:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
          		ucDataByte = JTAG_ReadLock();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case 0xA5   	:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0)
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
            		JTAG_WriteLock(ucTerminal_memory_buff[0]); 
			cResult =1;
		        break;
    case 0xA6   	:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(0x41	);
          		JTAG_ChipErase();
			cResult =1;
        		break;
    case 0xB1   	:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_eepage) break;
			UART_send_byte(0x41	);
			JTAG_ReadEEpromPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			for(i =0; i < uiCount; i++) UART_send_byte(ucTerminal_memory_buff[i]); 
			cResult =1;
        		break;
    case 0xA1   	:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_eepage) break;
			UART_send_byte(0x41	);
			if(Terminal_data_load(uiCount,&ucTerminal_memory_buff[0]) ==0) break;
			UART_send_byte(0x41	);
			JTAG_WriteEEpromPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			cResult =1;
        		break;
    case 0xB0   	:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_flpage) break;
			UART_send_byte(0x41	);
			JTAG_ReadFlashPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			for(i =0; i < (uiCount * 2); i++) UART_send_byte(ucTerminal_memory_buff[i]); 
			cResult =1;
        		break;
    case 0xA0   	:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_flpage) break;
			UART_send_byte(0x41	);
			if(Terminal_data_load(uiCount * 2,&ucTerminal_memory_buff[0]) ==0) break;
			UART_send_byte(0x41	);
			JTAG_WriteFlashPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			cResult =1;
	       		break;
    }
  CPU_led_state(0);
  if(cResult !=0) UART_send_byte(0x41	);
  else UART_send_byte(0x45	);
}
