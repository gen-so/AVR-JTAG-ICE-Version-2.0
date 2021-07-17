//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory,  алуга 2014
//terminal.c  - модуль функций обработки команд.
//“ип микроконтроллера: atmega16a
//јвтор: Mick (“арасов ћихаил)
//¬ерси€ модул€: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
#include "main.h"

#define TERMINAL_SIZE_BUFF		256 


#define SYNC_CRC			0x20	//' '
#define SYNC_EOP			0x20	//' '

#define PROG_OK				0x41	//'A'
#define PROG_ERROR			0x45	//'E'


#define PROG_PING                       0x20  	// OUT: [PROG_OK]

#define PROG_VERSION_FIRMWARE           0x21   	// IN:  [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [minor version] [major version][PROG_OK]
#define PROG_JTAG_ENTER_PROG_MODE       0x22   	// IN:  [SYNC_CRC][SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [PROG_OK]
#define PROG_JTAG_LEAVE_PROG_MODE       0x23   	// IN:  [SYNC_CRC][SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK]
#define PROG_JTAG_FLASH_PAGE_SIZE      	0x88   	// IN:  [pageSizeL] [pageSizeH] [SYNC_CRC] [SYNC_EOP]  
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] 
#define PROG_JTAG_EEPROM_PAGE_SIZE     	0x89   	// IN:  [pageSizeL] [pageSizeH] [SYNC_CRC] [SYNC_EOP]  
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] 
#define PROG_JTAG_WRITE_FLASH           0xA0   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC][SYNC_EOP] 
					       	// OUT: [PROG_OK] / [PROG_ERROR]
					       	// IN   [dataL][dataH] [...] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK]
#define PROG_JTAG_WRITE_EEPROM          0xA1   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC][SYNC_EOP]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// IN   [one byte per data] [...]
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK]
#define PROG_JTAG_WRITE_FUSE_LOW        0xA2   	// IN:  [fuse_low] [SYNC_CRC] [SYNC_EOP]  
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_WRITE_FUSE_HIGH       0xA3   	// IN:  [fuse_high] [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_WRITE_FUSE_EXT        0xA4   	// IN:  [fuse_ext] [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_WRITE_LOCK            0xA5   	// IN:  [lock] [SYNC_CRC] [SYNC_EOP]       
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_CHIP_ERASE            0xA6   	// IN:  [SYNC_CRC][SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [PROG_OK]
#define PROG_JTAG_READ_FLASH            0xB0   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [dataL][dataH] [...] [PROG_OK]
#define PROG_JTAG_READ_EEPROM           0xB1   	// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [one byte per data] [...] [PROG_OK]
#define PROG_JTAG_READ_FUSE_LOW         0xB2   	// IN:  [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [fuse_low] [PROG_OK]
#define PROG_JTAG_READ_FUSE_HIGH        0xB3   	// IN:  [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [fuse_high] [PROG_OK]
#define PROG_JTAG_READ_FUSE_EXT         0xB4   	// IN:  [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [fuse_ext] [PROG_OK]
#define PROG_JTAG_READ_LOCK             0xB5   	// IN:  [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [lock] [PROG_OK]
#define PROG_JTAG_READ_SIGNATURE        0xB6   	// IN:  [SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR]
						// OUT: [signa1] [signa2] [signa3][0x00] [PROG_OK]
#define PROG_JTAG_READ_CALIBRATION      0xB7   	// IN: 	[SYNC_CRC] [SYNC_EOP] 
						// OUT: [PROG_OK] / [PROG_ERROR] 
						// OUT: [calibration] [PROG_OK]

#define TERMINAL_CMD_TIMER		250	//1 секунда

#define MAJOR_VERSION		        1
#define MINOR_VERSION		        0

//----------------------------------------------------------------------------------------------------------------------
//описание:описание переменных контроллера
//-----------------------------------------------------------------------------------------------------------------------
 unsigned char ucTerminal_memory_buff[TERMINAL_SIZE_BUFF];	//буфер пам€ти
 unsigned int  uiTerminal_size_flpage;				//размер страницы FLASH пам€ти 			
 unsigned int  uiTerminal_size_eepage;				//размер страницы EEPROM пам€ти 			
//----------------------------------------------------------------------
// описание:   »нициализаци€ переменных
// параметры:  нет
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
void Terminal_init(void)
{
 uiTerminal_size_flpage =0;				//размер страницы пам€ти 			
 uiTerminal_size_eepage =0;				//размер страницы пам€ти 			
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  јнализ управл€ющих команд
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
   if((CPU_get_timer_ms() - uiTimer) >= TERMINAL_CMD_TIMER) return 0; //сработал таймер	

   if(UART_read_check() ==0) continue;			//команд не приходило
   if(i == 0)
    {
     ucCmd = UART_read_byte();
     if(ucCmd != SYNC_CRC) return 0;
    }
   else 
    {
     ucCmd = UART_read_byte();
     if(ucCmd != SYNC_EOP) return 0;
     break; 
    }
   i = i + 1;
  } 
 return 1; 
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  ѕрием данных от ’оста
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
   if((CPU_get_timer_ms() - uiTimer) >= TERMINAL_CMD_TIMER) return 0; //сработал таймер	

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
// описание:  јнализ управл€ющих команд
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
    case PROG_PING:
		  	cResult =1;
        	   	break;
    case PROG_VERSION_FIRMWARE:
			if(Terminal_cmd_correct() ==0) break;
 			UART_send_byte(PROG_OK);
			UART_send_byte(MINOR_VERSION);
			UART_send_byte(MAJOR_VERSION);
 		  	cResult =1;
        		break;
    case PROG_JTAG_ENTER_PROG_MODE:
			if(Terminal_cmd_correct() ==0) break;
			UART_send_byte(PROG_OK);
			if(JTAG_CheckProgMode() ==0) JTAG_EnterProgMode();
  			cResult =1; 
			break;	
    case PROG_JTAG_LEAVE_PROG_MODE:
			if(Terminal_cmd_correct() ==0) break;
			UART_send_byte(PROG_OK);
			if(JTAG_CheckProgMode() !=0) JTAG_LeaveProgMode();
  			cResult =1; 
			break;	
    case PROG_JTAG_FLASH_PAGE_SIZE:
			if(Terminal_data_load(2,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
 			UART_send_byte(PROG_OK);
			uiTerminal_size_flpage = ucTerminal_memory_buff[0];
			uiTerminal_size_flpage = (uiTerminal_size_flpage << 8) | ucTerminal_memory_buff[1];
			cResult = 1;
			break;
    case PROG_JTAG_EEPROM_PAGE_SIZE:
			if(Terminal_data_load(2,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
 		        UART_send_byte(PROG_OK);
			uiTerminal_size_eepage = ucTerminal_memory_buff[0];
			uiTerminal_size_eepage = (uiTerminal_size_eepage << 8) | ucTerminal_memory_buff[1];
			cResult = 1;
  			break;
    case PROG_JTAG_READ_SIGNATURE:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
  			ulDataLong = JTAG_ReadSignature();
			UART_send_byte(ulDataLong >>24);
			UART_send_byte(ulDataLong >>16);
			UART_send_byte(ulDataLong >>8);
			UART_send_byte(ulDataLong);
 		  	cResult =1;
			break;
    case PROG_JTAG_READ_CALIBRATION:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
 			UART_send_byte(PROG_OK);
        		ucDataByte = JTAG_ReadCalibration();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case PROG_JTAG_READ_FUSE_EXT:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
        		ucDataByte = JTAG_ReadFuseExt();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case PROG_JTAG_WRITE_FUSE_EXT:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
            		JTAG_WriteFuseExt(ucTerminal_memory_buff[0]);
			cResult =1;
		        break;
    case PROG_JTAG_READ_FUSE_HIGH:
			if(Terminal_cmd_correct() !=0)
                         {
			  if(JTAG_CheckProgMode() ==0) break;
			  UART_send_byte(PROG_OK);
        		  ucDataByte = JTAG_ReadFuseHigh();
			  UART_send_byte(ucDataByte);
 		  	  cResult =1;
			 }
        		break;
    case PROG_JTAG_WRITE_FUSE_HIGH:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
            		JTAG_WriteFuseHigh(ucTerminal_memory_buff[0]);
			cResult =1;
		        break;
    case PROG_JTAG_READ_FUSE_LOW:
			if(Terminal_cmd_correct() ==0) break;
		        if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
        		ucDataByte = JTAG_ReadFuseLow();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case PROG_JTAG_WRITE_FUSE_LOW:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
            		JTAG_WriteFuseLow(ucTerminal_memory_buff[0]);
			cResult =1;
		        break;
    case PROG_JTAG_READ_LOCK:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
          		ucDataByte = JTAG_ReadLock();
			UART_send_byte(ucDataByte);
 		  	cResult =1;
        		break;
    case PROG_JTAG_WRITE_LOCK:
			if(Terminal_data_load(1,&ucTerminal_memory_buff[0]) ==0)
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
            		JTAG_WriteLock(ucTerminal_memory_buff[0]); 
			cResult =1;
		        break;
    case PROG_JTAG_CHIP_ERASE:
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			UART_send_byte(PROG_OK);
          		JTAG_ChipErase();
			cResult =1;
        		break;
    case PROG_JTAG_READ_EEPROM:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_eepage) break;
			UART_send_byte(PROG_OK);
			JTAG_ReadEEpromPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			for(i =0; i < uiCount; i++) UART_send_byte(ucTerminal_memory_buff[i]); 
			cResult =1;
        		break;
    case PROG_JTAG_WRITE_EEPROM:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_eepage) break;
			UART_send_byte(PROG_OK);
			if(Terminal_data_load(uiCount,&ucTerminal_memory_buff[0]) ==0) break;
			UART_send_byte(PROG_OK);
			JTAG_WriteEEpromPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			cResult =1;
        		break;
    case PROG_JTAG_READ_FLASH:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_flpage) break;
			UART_send_byte(PROG_OK);
			JTAG_ReadFlashPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			for(i =0; i < (uiCount * 2); i++) UART_send_byte(ucTerminal_memory_buff[i]); 
			cResult =1;
        		break;
    case PROG_JTAG_WRITE_FLASH:
			if(Terminal_data_load(4,&ucTerminal_memory_buff[0]) ==0) break;
			if(Terminal_cmd_correct() ==0) break;
			if(JTAG_CheckProgMode() ==0) break;
			uiAddr = ucTerminal_memory_buff[1];
			uiAddr = (uiAddr << 8) | ucTerminal_memory_buff[0];
			uiCount = ucTerminal_memory_buff[3];
			uiCount = (uiCount << 8) | ucTerminal_memory_buff[2];
			if(uiCount > uiTerminal_size_flpage) break;
			UART_send_byte(PROG_OK);
			if(Terminal_data_load(uiCount * 2,&ucTerminal_memory_buff[0]) ==0) break;
			UART_send_byte(PROG_OK);
			JTAG_WriteFlashPage(uiAddr, uiCount, &ucTerminal_memory_buff[0]);
			cResult =1;
	       		break;
    }
  CPU_led_state(0);
  if(cResult !=0) UART_send_byte(PROG_OK);
  else UART_send_byte(PROG_ERROR);
}
