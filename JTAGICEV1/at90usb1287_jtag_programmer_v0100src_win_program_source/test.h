//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//test.h - модуль функций обработки команд.
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
#pragma hdrstop
#include <stdio.h>
#include <stdlib.h>
#include <commctrl.h>
#include <windows.h>
#include <malloc.h>

#define IDM_PROGRESS       110


#define MESSAGE_SIGNATURE	"Сигнатура: "
#define LEN_MESSIGNATURE	sizeof(MESSAGE_SIGNATURE)
#define MESSAGE_FUSE		"Фьюзе байты: "
#define LEN_FUSE			sizeof(MESSAGE_FUSE)
#define MESSAGE_VERSION		"Версия ПО программатора: "
#define LEN_VERSION			sizeof(MESSAGE_VERSION)
#define MESSAGE_CMDERROR	"Ошибка выполнения команды!"
#define MESSAGE_SYNCERROR	"Ошибка синхронизации с программатором!"
#define MESSAGE_SIGNERROR	"Неверная сигнатура устройства!"

#define SYNCHRO_TIMER 					1000		//время ожидания прихода команды из UART  1сек
#define ERASE_TIMER 					5000		//время ожидания прихода команды из UART  1сек

#define COM_LEN_INBUFFER				512
#define COM_LEN_OUTBUFFER				512
#define COM_LEN_RECBUFFER				512

#define TEST_MODE						0

#define SYNC_CRC						0x20	//' '
#define SYNC_EOP						0x20	//' '

#define PROG_OK							0x41	//'A'
#define PROG_ERROR						0x45	//'E'


#define PROG_PHASE_NULL					0			//фаза бездействия
#define PROG_PHASE_SYNCHRO				1			//фаза синхронизации
#define PROG_PHASE_ENTER_PROGMODE		2			//вход в программный режим
#define PROG_PHASE_LEAVE_PROGMODE		3			//выход из программного режима
#define PROG_PHASE_READ_SIGNATURE		4			//чтение сигнатуры
#define PROG_PHASE_ERASE_CHIP			5			//стирание микросхемы
#define PROG_PHASE_READ_FUSE_LOW		6			//чтение фьюзов
#define PROG_PHASE_READ_FUSE_HIGH		7			//чтение фьюзов
#define PROG_PHASE_READ_FUSE_EXT		8			//чтение фьюзов
#define PROG_PHASE_WRITE_FUSE_LOW		9			//запись фьюзов
#define PROG_PHASE_WRITE_FUSE_HIGH		10			//запись фьюзов
#define PROG_PHASE_WRITE_FUSE_EXT		11			//запись фьюзов
#define PROG_PHASE_READ_LOCK			12			//чтение битов защиты
#define PROG_PHASE_WRITE_LOCK			13			//запись битов защиты
#define PROG_PHASE_READ_CALIBRATION		14			//чтение калибрационного байта
#define PROG_PHASE_PAGE_FLASH_SIZE		15			//установка размера страницы
#define PROG_PHASE_INIT_READ_FLASH		16			//подготовка к чтению FLASH памяти
#define PROG_PHASE_READ_FLASH			17			//чтение FLASH памяти
#define PROG_PHASE_INIT_VERIFY_FLASH	18			//сравнение FLASH памяти с буфером
#define PROG_PHASE_VERIFY_FLASH			19			//сравнение FLASH памяти с буфером
#define PROG_PHASE_INIT_WRITE_FLASH		20			//запись FLASH памяти
#define PROG_PHASE_WRITE_FLASH			21			//запись FLASH памяти
#define PROG_PHASE_PAGE_EEPROM_SIZE		22			//установка размера страницы
#define PROG_PHASE_READ_EEPROM			23			//чтение EEPROM памяти
#define PROG_PHASE_VERIFY_EEPROM		24			//сравнение EEPROM памяти с буфером
#define PROG_PHASE_WRITE_EEPROM			25			//запись EEPROM памяти
#define PROG_PHASE_VERSION				26			//фаза чтения версии


#define PROG_PING                       0x20  		// OUT: [PROG_OK]

#define PROG_VERSION_FIRMWARE           0x21   		// IN:  [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [minor version] [major version][PROG_OK]
#define PROG_JTAG_ENTER_PROG_MODE       0x22   		// IN:  [SYNC_CRC][SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [PROG_OK]
#define PROG_JTAG_LEAVE_PROG_MODE       0x23   		// IN:  [SYNC_CRC][SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK]
#define PROG_JTAG_FLASH_PAGE_SIZE      	0x88   		// IN:  [pageSizeL] [pageSizeH] [SYNC_CRC] [SYNC_EOP]  
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK] 
#define PROG_JTAG_EEPROM_PAGE_SIZE     	0x89   		// IN:  [pageSizeL] [pageSizeH] [SYNC_CRC] [SYNC_EOP]  
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK] 
#define PROG_JTAG_WRITE_FLASH           0xA0   		// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC][SYNC_EOP] 
					       							// OUT: [PROG_OK] / [PROG_ERROR]
					       							// IN   [dataL][dataH] [...] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK]
#define PROG_JTAG_WRITE_EEPROM          0xA1   		// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC][SYNC_EOP]
													// OUT: [PROG_OK] / [PROG_ERROR]
													// IN   [one byte per data] [...]
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK]
#define PROG_JTAG_WRITE_FUSE_LOW        0xA2   		// IN:  [fuse_low] [SYNC_CRC] [SYNC_EOP]  
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_WRITE_FUSE_HIGH       0xA3   		// IN:  [fuse_high] [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_WRITE_FUSE_EXT        0xA4   		// IN:  [fuse_ext] [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_WRITE_LOCK            0xA5   		// IN:  [lock] [SYNC_CRC] [SYNC_EOP]       
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [PROG_OK] / [PROG_ERROR]
#define PROG_JTAG_CHIP_ERASE            0xA6   		// IN:  [SYNC_CRC][SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [PROG_OK]
#define PROG_JTAG_READ_FLASH            0xB0   		// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [dataL][dataH] [...] [PROG_OK]
#define PROG_JTAG_READ_EEPROM           0xB1   		// IN:  [addrBeginL] [addrBeginH] [countL] [countH] [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [one byte per data] [...] [PROG_OK]
#define PROG_JTAG_READ_FUSE_LOW         0xB2   		// IN:  [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [fuse_low] [PROG_OK]
#define PROG_JTAG_READ_FUSE_HIGH        0xB3   		// IN:  [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [fuse_high] [PROG_OK]
#define PROG_JTAG_READ_FUSE_EXT         0xB4   		// IN:  [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [fuse_ext] [PROG_OK]
#define PROG_JTAG_READ_LOCK             0xB5   		// IN:  [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [lock] [PROG_OK]
#define PROG_JTAG_READ_SIGNATURE        0xB6   		// IN:  [SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR]
													// OUT: [signa1] [signa2] [signa3][0x00] [PROG_OK]
#define PROG_JTAG_READ_CALIBRATION      0xB7   		// IN: 	[SYNC_CRC] [SYNC_EOP] 
													// OUT: [PROG_OK] / [PROG_ERROR] 
													// OUT: [calibration] [PROG_OK]

unsigned char ucAT90USB1287_FUSE[] = {0,1,2,3,4,5, 6, 7,8,9,10,11,12,13,14, 15, 16, 17, 18, 19,255,255,255,255};
unsigned char ucAVR_LOCK[] = {0,1,2,3,4,5, 255, 255};

unsigned char ucScriptAutoProgramm[] = {PROG_PHASE_SYNCHRO, PROG_PHASE_VERSION,
										PROG_PHASE_ENTER_PROGMODE, 
										PROG_PHASE_READ_SIGNATURE, 
										PROG_PHASE_ERASE_CHIP,
										PROG_PHASE_PAGE_FLASH_SIZE,
										PROG_PHASE_INIT_WRITE_FLASH, PROG_PHASE_WRITE_FLASH,
										PROG_PHASE_INIT_VERIFY_FLASH,PROG_PHASE_VERIFY_FLASH,
										PROG_PHASE_READ_FUSE_EXT, PROG_PHASE_READ_FUSE_HIGH,PROG_PHASE_READ_FUSE_LOW,
										PROG_PHASE_WRITE_FUSE_EXT, PROG_PHASE_WRITE_FUSE_HIGH,PROG_PHASE_WRITE_FUSE_LOW,
										PROG_PHASE_LEAVE_PROGMODE};

struct DeviceAVRParameters
{
 unsigned long  ulSignature;						//сигнатура
 unsigned short usFlashSizePage;					//размер страницы FLASH
 unsigned short usFlashVolPage;						//число страниц FLASH
 unsigned short usEEpromSizePage;					//размер страницы EEPROM
 unsigned short usEEpromVolPage;					//число страниц EEPROM
 unsigned char* ucFuseMessage;						//адрес массива текстовых констант	 
 unsigned long  ulFuseDefault;						//значение Fuse по умолчанию
 unsigned char* ucLockMessage;						//адрес массива текстовых констант	 
 unsigned char  ucLockDefault;						//значение Lock по умолчанию
};


unsigned char ucProg_phase;
unsigned char ucProg_phase_index;
unsigned char ucProg_phase_max;
unsigned char ucProg_buf[COM_LEN_RECBUFFER];	//буфер принимаемой команды 

unsigned char* ucProg_scripr_addr; 

unsigned char* ucProg_buff_flash; 
unsigned int uiProg_progress_old;

unsigned int uiFlashRealSize;
unsigned long ulFuseReal;
unsigned char ucFuseFlg;

unsigned int  uiSynchro_count; 
unsigned int  uiSynchro_step; 
unsigned int  uiSynchro_timer;					//время за которое должна прийти команда
unsigned int  uiSynchro_wrmarker;
unsigned int  uiSynchro_rdmarker;	
unsigned int  uiSynchro_addr;					//текущий адрес чтения/записи в устройства 
unsigned int  uiSynchro_page_count;				//счетчик страниц для операций чтения и записи

char cNumCOM;									//номер активного COM порта

unsigned char ucCOM_inbuf[COM_LEN_INBUFFER];  //буфер принимаемой команды 
unsigned char ucCOM_outbuf[COM_LEN_OUTBUFFER];//буфер принимаемой команды 
unsigned char ucCOM_recbuf[COM_LEN_RECBUFFER];//буфер принимаемой команды 


unsigned char ucMsgBuf[100];

struct ihexrec 
{
  unsigned char    reclen;
  unsigned int     loadofs;
  unsigned char    rectyp;
  unsigned char    data[256];
  unsigned char    cksum;
};



char cCom_open;


struct DeviceAVRParameters ProgAVRParam;

#include "TimeSys.h"
TimeSys TimeS;


#include  "comport.h"
ComPort ComPortU;

//---------------------------------------------------------------------------
//Описание: Инициализация прогрессбара на экране
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Progress_init_progressdlg(HWND hWnd)
{
 SendDlgItemMessage(hWnd,IDC_PROGRESS1,PBM_SETRANGE,0,MAKELPARAM(0,100));
 SendDlgItemMessage(hWnd,IDC_PROGRESS1,PBM_SETSTEP,1,0);
 SetDlgItemText(hWnd,IDC_STATIC_PROGRESS2,(LPTSTR) "  0%");
 SendDlgItemMessage(hWnd,IDC_PROGRESS1,PBM_SETPOS,0,0);
 uiProg_progress_old   =0;
}
//---------------------------------------------------------------------------
//Описание: Состояние прогрессбара на экране
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_update_progressdlg(HWND hWnd, unsigned int uiState)
{
 unsigned char ucTemp[10];
  
 if(uiState == uiProg_progress_old) return;

 uiProg_progress_old = uiState; 

 if(uiState > 100) return;
 
 SendDlgItemMessage(hWnd,IDC_PROGRESS1,PBM_SETPOS,uiState,0);

 if(uiState < 100) 
 {	 
  if(uiState < 10) sprintf((char *)&ucTemp[0],"  %.1d%%",uiState);
  else  sprintf((char *)&ucTemp[0]," %.2d%%",uiState);
 }
 else sprintf((char *)&ucTemp[0],"%.3d%%",100); 
 SetDlgItemText(hWnd,IDC_STATIC_PROGRESS2,(LPTSTR) &ucTemp[0]);
}
//----------------------------------------------------------------------
// описание:   Проверка сигнатуры поддерживаемого устройства
// параметры:  строка
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
void Prog_update_deviceparam(void)
{ 
 unsigned int uiMemorySize;
 
 ProgAVRParam.ulSignature     = 0x001E9782;	//AT90USB1287
 ProgAVRParam.usFlashSizePage = 0x0080;		//AT90USB1287 -> 128 kByte / 512 pages;					
 ProgAVRParam.usFlashVolPage  = 512;		//AT90USB1287
 ProgAVRParam.usEEpromSizePage = 0x0008;	//AT90USB1287 -> 4 kByte / 512 pages;
 ProgAVRParam.usEEpromVolPage = 512;		//AT90USB1287
 ProgAVRParam.ucFuseMessage   = &ucAT90USB1287_FUSE[0];//AT90USB1287
 ProgAVRParam.ulFuseDefault	  = 0x00FB99D0; //для ZXM-Zephyr  0x00F3995E - default; //AT90USB1287
 ProgAVRParam.ucLockMessage   = &ucAVR_LOCK[0];
 ProgAVRParam.ucLockDefault   = 0xEC;		//AT90USB1287;

 uiMemorySize = ProgAVRParam.usFlashSizePage * 2;
 uiMemorySize = uiMemorySize * ProgAVRParam.usFlashVolPage;

 if(ucProg_buff_flash !=0) free(ucProg_buff_flash);
 ucProg_buff_flash = (unsigned char* ) malloc(uiMemorySize);	 
}
//----------------------------------------------------------------------
// описание:   Вывод сообщения в строку статуса
// параметры:  строка
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
void Prog_status_message(HWND hDlg, LPTSTR lpMessage)
{
 unsigned char i;
 unsigned char ucMsgClearBuf[100];
 for(i =0; i < 80; i++) ucMsgClearBuf[i] = 0x20;
 SetDlgItemText(hDlg, IDC_STATIC_STATUS, (LPCTSTR)&ucMsgClearBuf);
 SetDlgItemText(hDlg, IDC_STATIC_STATUS, lpMessage);
}
//----------------------------------------------------------------------
// описание:   Получить значение в мс
// параметры:  нет
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
unsigned int Prog_get_timer_ms(void)
{
 return (unsigned int) GetTickCount();
}
//---------------------------------------------------------------------------
//Описание: Открытие COM порта
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
int Prog_open_com(HWND hDlg)
{
 unsigned char ucNameBuf[10];
 sprintf((char *) &ucMsgBuf[0],"Открытие порта COM%.d: ",(cNumCOM +1));
 sprintf((char *) &ucNameBuf[0],"COM%.d",(cNumCOM +1));
 if(ComPortU.ComPort_open((LPCTSTR) &ucNameBuf[0],COM_LEN_INBUFFER) != 0)
  {
   sprintf((char *) &ucMsgBuf[0],"Ошибка открытия порта COM%.d!",(cNumCOM +1));
   
   MessageBox(hDlg,(LPTSTR) &ucMsgBuf,NULL,MB_OK | MB_ICONINFORMATION);
   return 1;
  }
 ComPortU.ComPort_read(&ucCOM_inbuf[0]);	//прочитаем мусор из порта
 cCom_open =1;
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Закрытие COM порта
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_close_com(void)
{
 if(cCom_open !=0)  ComPortU.ComPort_close();
 cCom_open =0;
}
//----------------------------------------------------------------------
// описание:   Вывод сообщения об ошибки
// параметры:  нет
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
void Prog_error_message(HWND hDlg,char cNumMsg)
{
 switch(cNumMsg)
 {	 
  case 0:
         MessageBox(hDlg,(LPTSTR) MESSAGE_CMDERROR,NULL,MB_OK | MB_ICONINFORMATION);
         ucProg_phase = PROG_PHASE_LEAVE_PROGMODE;
         break;
  case 1:
         MessageBox(hDlg,(LPTSTR) MESSAGE_SYNCERROR,NULL,MB_OK | MB_ICONINFORMATION);
		 ucProg_phase = PROG_PHASE_NULL;
		 Prog_close_com();
		 break;
  case 2:
         MessageBox(hDlg,(LPTSTR) MESSAGE_SIGNERROR,NULL,MB_OK | MB_ICONINFORMATION);
         ucProg_phase = PROG_PHASE_LEAVE_PROGMODE;
         break;
 }
}	
//---------------------------------------------------------------------------
//Описание: Переход к следующей фазе
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
void Prog_phase_next(void)
{
 uiSynchro_step =0;
 ucProg_phase_index = ucProg_phase_index + 1;
 if(ucProg_phase_index >= ucProg_phase_max) 
 {	 
  ucProg_phase = PROG_PHASE_NULL;
  Prog_close_com();
 }
 else ucProg_phase = ucProg_scripr_addr[ucProg_phase_index];
}
//---------------------------------------------------------------------------
//Описание: Прием байт из COM порта
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_transmit_processing(unsigned char* ucOutBuf, unsigned int uiLen, char cFlgSync)
{
 unsigned int i;

 for(i=0 ; i < uiLen; i++) ucCOM_outbuf[i] = ucOutBuf[i];

 if(ComPortU.ComPort_write(&ucCOM_outbuf[0],uiLen) != uiLen) return 1;//отправить сообщение
 if(cFlgSync !=0)
 {
  uiSynchro_timer = Prog_get_timer_ms();		//установим таймер на ожидание приема пакета
  uiSynchro_step =1;							//ожидаем ответа
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Прием байт из COM порта
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
void Prog_receive_processing(void)
{
 unsigned int i;
 unsigned int uiRecLen;
  
 uiRecLen = ComPortU.ComPort_read(&ucCOM_inbuf[0]);
 if(uiRecLen ==0) return;
 for(i =0; i < uiRecLen; i++)
 {
  ucCOM_recbuf[uiSynchro_wrmarker] = ucCOM_inbuf[i];
  uiSynchro_wrmarker = uiSynchro_wrmarker + 1;
  if(uiSynchro_wrmarker >= COM_LEN_RECBUFFER) uiSynchro_wrmarker =0;
 }
}
//---------------------------------------------------------------------------
//Описание: Проверка состояния приемного буфера
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_read_check(void)
{
 if(uiSynchro_wrmarker == uiSynchro_rdmarker) return 0;
 return 1;
}
//---------------------------------------------------------------------------
//Описание: Проверка количества принятых байт
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
unsigned char Prog_read_byte(void)
{
 unsigned char ucByte;
 while (uiSynchro_wrmarker == uiSynchro_rdmarker);
 ucByte = ucCOM_recbuf[uiSynchro_rdmarker];
 uiSynchro_rdmarker = uiSynchro_rdmarker + 1;
 if(uiSynchro_rdmarker >= COM_LEN_RECBUFFER) uiSynchro_rdmarker =0;
 return ucByte;
}
//---------------------------------------------------------------------------
//Описание: Проверка исполнении команды
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_command_answer(unsigned int uiTimeConst)
{
 unsigned char ucByte;
 if(uiSynchro_step > 0)
 {
  if(Prog_read_check() !=0)
  {  
   ucByte = Prog_read_byte();
   if(ucByte == PROG_OK)
   {
    if(uiSynchro_step ==1)
    { 
	 uiSynchro_step =2;
     uiSynchro_timer = Prog_get_timer_ms();	//установим таймер на ожидание выполнения команды
     return 0;
    }
    else  return 2;
   }
   else return 1;
  }
  if((Prog_get_timer_ms() - uiSynchro_timer) >= uiTimeConst) return 1;//время вышло - ответа не было
 }
 else return 1;
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Проверка исполнении команды
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_read_parameter(void)
{
 unsigned char ucByte;
 if(uiSynchro_step > 0)
 {
  if(Prog_read_check() !=0)
  {  
   ucByte = Prog_read_byte();
   if(uiSynchro_step ==1)
   {
    if(ucByte == PROG_OK)
	{
	 uiSynchro_step = 2;
     uiSynchro_timer = Prog_get_timer_ms();	//установим таймер на ожидание выполнения команды
     return 0;
    }
   } 
   else
   {   
    if(uiSynchro_step == uiSynchro_count)
	{	
     if(ucByte == PROG_OK) uiSynchro_step = uiSynchro_step + 1;
	 else return 1;
    }
    else
    { 
     ucProg_buf[uiSynchro_step - 2] = ucByte; 
	 uiSynchro_step = uiSynchro_step + 1;
     uiSynchro_timer = Prog_get_timer_ms();	//установим таймер на ожидание выполнения команды
	}
   }
  }
  if((Prog_get_timer_ms() - uiSynchro_timer) >= SYNCHRO_TIMER) return 1;//время вышло - ответа не было
 }
 else return 1;
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Вход в режим программирования
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_enter_processing(void)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_ENTER_PROG_MODE; 
  ucBuf[1] = SYNC_CRC; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
 }
 else
 { 
  ucResult = Prog_command_answer(SYNCHRO_TIMER);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    Prog_phase_next();
   }
  }	  
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Выход из режима программирования
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_leave_processing(void)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_LEAVE_PROG_MODE; 
  ucBuf[1] = SYNC_CRC; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
 }
 else
 {
  ucResult = Prog_command_answer(SYNCHRO_TIMER);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    ucProg_phase = PROG_PHASE_NULL;
    Prog_close_com();
   }
  }	  
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Чтение сигнатуры
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
void Prog_read_signature(HWND hDlg)
{
 unsigned char ucBuf[5];
 unsigned long ulSignature;
 if(uiSynchro_step ==0)
 {
  Prog_status_message(hDlg, (LPTSTR) "Чтение сигнатуры");
  ucBuf[0] = PROG_JTAG_READ_SIGNATURE; 
  ucBuf[1] = SYNC_CRC; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) 
  {	  
   Prog_error_message(hDlg,0);				//процесс завершился ошибкой
   return;									//отправить сообщение
  }
  uiSynchro_count = 6;						//ожидаем ответа 4 байта + 2 контрольных
 }
 else
 {
  if(Prog_read_parameter() !=0)
  {  
   Prog_error_message(hDlg,0);				//процесс завершился ошибкой
   return;
  }
  if(uiSynchro_step > uiSynchro_count)
  {
   ulSignature = ucProg_buf[0]; 
   ulSignature = (ulSignature << 8) | ucProg_buf[1]; 
   ulSignature = (ulSignature << 8) | ucProg_buf[2]; 
   ulSignature = (ulSignature << 8) | ucProg_buf[3]; 
   Prog_phase_next();

   sprintf((char *)&ucMsgBuf,MESSAGE_SIGNATURE);
   sprintf((char *)&ucMsgBuf[LEN_MESSIGNATURE - 1],"0x%.2X",ucProg_buf[1]);
   sprintf((char *)&ucMsgBuf[LEN_MESSIGNATURE + 3]," 0x%.2X",ucProg_buf[2]);
   sprintf((char *)&ucMsgBuf[LEN_MESSIGNATURE + 8]," 0x%.2X - ",ucProg_buf[3]);

   if(ulSignature != ProgAVRParam.ulSignature) 
   {  
	sprintf((char *)&ucMsgBuf[LEN_MESSIGNATURE + 14],"Неизвестное устройство");
    Prog_error_message(hDlg,2);
	return;
   }
   else sprintf((char *)&ucMsgBuf[LEN_MESSIGNATURE + 16], " AT90USB1287 "); 
   Prog_status_message(hDlg, (LPTSTR) &ucMsgBuf);
  }
 }
 return;
}
//---------------------------------------------------------------------------
//Описание: Запись фьзов
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_write_fuselow(HWND hDlg)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 if(ucFuseFlg ==0)
 {	 
  Prog_phase_next();
  Prog_status_message(hDlg, (LPTSTR)"Программирование завершено");
  return 0;
 }
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_WRITE_FUSE_LOW; 
  ucBuf[1] = (unsigned char) ProgAVRParam.ulFuseDefault;
  ucBuf[2] = SYNC_EOP; 
  ucBuf[3] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],4,1) !=0) return 1;//отправить сообщение
 }
 else
 {
  ucResult = Prog_command_answer(SYNCHRO_TIMER);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    Prog_status_message(hDlg, (LPTSTR) "Программирование завершено");//"Фьюзе биты запрограммированы");
    Prog_phase_next();
   }
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Запись фьзов
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_write_fusehigh(HWND hDlg)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 if(ucFuseFlg ==0)
 {	 
  Prog_phase_next();
  return 0;
 }
if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_WRITE_FUSE_HIGH; 
  ucBuf[1] = (unsigned char) (ProgAVRParam.ulFuseDefault >> 8);
  ucBuf[2] = SYNC_EOP; 
  ucBuf[3] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],4,1) !=0) return 1;//отправить сообщение
 }
 else
 {
  ucResult = Prog_command_answer(SYNCHRO_TIMER);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    Prog_phase_next();
   }
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Запись фьзов
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_write_fuseext(HWND hDlg)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 if(ucFuseFlg ==0)
 {	 
  Prog_phase_next();
  return 0;
 }
 if(uiSynchro_step ==0)
 {
  Prog_status_message(hDlg, (LPTSTR) "Программирование фьюзе битов");

  ucBuf[0] = PROG_JTAG_WRITE_FUSE_EXT; 
  ucBuf[1] = (unsigned char) (ProgAVRParam.ulFuseDefault >> 16);
  ucBuf[2] = SYNC_EOP; 
  ucBuf[3] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],4,1) !=0) return 1;//отправить сообщение
 }
 else
 {
  ucResult = Prog_command_answer(SYNCHRO_TIMER);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    Prog_phase_next();
   }
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Чтение фьзов
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_read_fuselow(HWND hDlg)
{
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_READ_FUSE_LOW; 
  ucBuf[1] = SYNC_EOP; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
  uiSynchro_count = 3;						//ожидаем ответа 4 байта + 2 контрольных
 }
 else
 {
  if(Prog_read_parameter() !=0) return 1;
  if(uiSynchro_step > uiSynchro_count)
  {
   ulFuseReal = (ulFuseReal << 8) | ucProg_buf[0];

   sprintf((char *)&ucMsgBuf,MESSAGE_FUSE);
   sprintf((char *)&ucMsgBuf[LEN_FUSE - 1],"0x%.2X",(unsigned char)(ulFuseReal >>16));
   sprintf((char *)&ucMsgBuf[LEN_FUSE + 3]," 0x%.2X",(unsigned char)(ulFuseReal >>8));
   sprintf((char *)&ucMsgBuf[LEN_FUSE + 8]," 0x%.2X",(unsigned char) ulFuseReal);
   Prog_status_message(hDlg, (LPTSTR) &ucMsgBuf);

   if(ulFuseReal != ProgAVRParam.ulFuseDefault) ucFuseFlg  =1;
   Prog_phase_next();
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Чтение фьзов
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_read_fusehigh(void)
{
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_READ_FUSE_HIGH; 
  ucBuf[1] = SYNC_CRC; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
  uiSynchro_count = 3;						//ожидаем ответа 4 байта + 2 контрольных
 }
 else
 {
  if(Prog_read_parameter() !=0) return 1;
  if(uiSynchro_step > uiSynchro_count)
  {
   ulFuseReal = (ulFuseReal << 8) | ucProg_buf[0];
   Prog_phase_next();
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Чтение фьзов
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_read_fuseext(HWND hDlg)
{
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  Prog_status_message(hDlg, (LPTSTR) "Чтение фьюзе-битов");
  ulFuseReal =0;
  ucFuseFlg  =0;

  ucBuf[0] = PROG_JTAG_READ_FUSE_EXT; 
  ucBuf[1] = SYNC_CRC; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
  uiSynchro_count = 3;						//ожидаем ответа 4 байта + 2 контрольных
 }
 else
 {
  if(Prog_read_parameter() !=0) return 1;
  if(uiSynchro_step > uiSynchro_count)
  {
   ulFuseReal = ucProg_buf[0];
   Prog_phase_next();
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Чтение версии
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_read_version(HWND hDlg)
{
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  Prog_status_message(hDlg, (LPTSTR) "Запрос версии программатора");
  ucBuf[0] = PROG_VERSION_FIRMWARE; 
  ucBuf[1] = SYNC_EOP; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
  uiSynchro_count = 4;						//ожидаем ответа 4 байта + 2 контрольных
 }
 else
 {
  if(Prog_read_parameter() !=0) return 1;
  if(uiSynchro_step > uiSynchro_count)
  {
   sprintf((char *)&ucMsgBuf,MESSAGE_VERSION);
   sprintf((char *)&ucMsgBuf[LEN_VERSION - 1],"%.2d",ucProg_buf[1]);
   sprintf((char *)&ucMsgBuf[LEN_VERSION + 1],".%.2d",ucProg_buf[0]);
   Prog_status_message(hDlg, (LPTSTR) &ucMsgBuf);
   Prog_phase_next();
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Установка размера FLASH страницы
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_page_flash_size(void)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_FLASH_PAGE_SIZE; 
  ucBuf[1] = (unsigned char) ProgAVRParam.usFlashSizePage; 
  ucBuf[2] = (unsigned char) (ProgAVRParam.usFlashSizePage >>8); 
  ucBuf[3] = SYNC_CRC; 
  ucBuf[4] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],5,1) !=0) return 1;//отправить сообщение
 }
 else
 { 
  ucResult = Prog_command_answer(SYNCHRO_TIMER);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    Prog_phase_next();
   }
  }	  
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Запись во FLASH
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_write_flash(HWND hDlg)
{
 unsigned char ucResult;
 unsigned char ucBuf[270];
 unsigned int uiPageSize;
 unsigned int i;

 uiPageSize = uiFlashRealSize >> 1;	//число слов
 uiPageSize = uiPageSize - uiSynchro_addr; 
 if(uiPageSize >= ProgAVRParam.usFlashSizePage) uiPageSize = ProgAVRParam.usFlashSizePage;
 
 switch(uiSynchro_step)
 {
  case 0:
        ucBuf[0] = PROG_JTAG_WRITE_FLASH; 
        ucBuf[1] = (unsigned char) uiSynchro_addr; 
        ucBuf[2] = (unsigned char) (uiSynchro_addr >> 8);
        ucBuf[3] = (unsigned char) uiPageSize; 
        ucBuf[4] = (unsigned char) (uiPageSize >>8);
		ucBuf[5] = SYNC_CRC; 
		ucBuf[6] = SYNC_EOP; 
        if(Prog_transmit_processing(&ucBuf[0],7,1) !=0) return 1;//отправить сообщение
        uiSynchro_step =3;
		break;
  case 1:
  case 2:
         ucResult = Prog_command_answer(SYNCHRO_TIMER);
         if(ucResult == 1) return 1;
         if(ucResult ==2)
		 {  
          uiSynchro_addr = uiSynchro_addr + uiPageSize;
          uiSynchro_page_count = uiSynchro_page_count + 1;

		  uiPageSize = (uiFlashRealSize >> 1) / 100;
          uiPageSize = uiSynchro_addr / uiPageSize;
          Prog_update_progressdlg(hDlg, uiPageSize); 
    
          if((uiSynchro_addr *2) >= uiFlashRealSize)
		  {
		   Prog_update_progressdlg(hDlg, 100); 
 	       Prog_status_message(hDlg, (LPTSTR) "Запись завершена!"); 
	       Prog_phase_next();
		  }
         else uiSynchro_step =0;
		 }
        break;
  case 3:
        if(Prog_read_check() !=0)
		{  
         ucResult = Prog_read_byte();
         if(ucResult == PROG_OK)
		 {
		  for(i =0; i < (uiPageSize * 2);i++) ucBuf[i] = ucProg_buff_flash[(uiSynchro_addr *2) + i];
          if(Prog_transmit_processing(&ucBuf[0],i,1) !=0) return 1;//отправить сообщение
          uiSynchro_step =1;
		 }
        else if((Prog_get_timer_ms() - uiSynchro_timer) >= SYNCHRO_TIMER) return 1;//время вышло - ответа не было
		}
		break; 

 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Сравнение FLASH
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_verify_flash(HWND hDlg)
{
 unsigned char ucBuf[10];
 unsigned int uiPageSize;
 unsigned int i;

 uiPageSize = uiFlashRealSize >> 1;								//число слов
 uiPageSize = uiPageSize - uiSynchro_addr; 
 if(uiPageSize >= ProgAVRParam.usFlashSizePage) uiPageSize = ProgAVRParam.usFlashSizePage;
 
 if(uiSynchro_step ==0)
 {
  ucBuf[0] = PROG_JTAG_READ_FLASH; 
  ucBuf[1] = (unsigned char) uiSynchro_addr; 
  ucBuf[2] = (unsigned char) (uiSynchro_addr >> 8);
  ucBuf[3] = (unsigned char) uiPageSize; 
  ucBuf[4] = (unsigned char) (uiPageSize >>8);
  ucBuf[5] = SYNC_CRC; 
  ucBuf[6] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],7,1) !=0) return 1;//отправить сообщение
  uiSynchro_count = (uiPageSize * 2) + 2;//ожидаем ответа (размер страницы * 2) байта + 2 контрольных
 }
 else
 {
  if(Prog_read_parameter() !=0) return 1;
  if(uiSynchro_step > uiSynchro_count)
  {
   for(i =0; i < (uiPageSize *2); i++) 
   {    
    if(ucProg_buff_flash[(uiSynchro_addr *2) + i] != ucProg_buf[i])
	{
  	 Prog_status_message(hDlg, (LPTSTR) "Ошибка сравнения:");
     return 1;
    }
   }
   uiSynchro_addr = uiSynchro_addr + uiPageSize;
   uiSynchro_page_count = uiSynchro_page_count + 1;

   uiPageSize = (uiFlashRealSize >> 1) / 100;
   uiPageSize = uiSynchro_addr / uiPageSize;
   Prog_update_progressdlg(hDlg, uiPageSize); 

   if((uiSynchro_addr *2) >= uiFlashRealSize)
   {
    Prog_update_progressdlg(hDlg, 100); 
	Prog_status_message(hDlg, (LPTSTR) "Верификация успешно завершена!");
	Prog_phase_next();
   }
   else uiSynchro_step =0;
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: стирание микросхемы
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_erase_chip(HWND hDlg)
{
 unsigned char ucResult;
 unsigned char ucBuf[5];
 unsigned int uiTimeCnst;
 if(uiSynchro_step ==0)
 {
  Prog_status_message(hDlg, (LPTSTR) "Стирание микросхемы");
  ucBuf[0] = PROG_JTAG_CHIP_ERASE; 
  ucBuf[1] = SYNC_CRC; 
  ucBuf[2] = SYNC_EOP; 
  if(Prog_transmit_processing(&ucBuf[0],3,1) !=0) return 1;//отправить сообщение
 }
 else
 {
  if(uiSynchro_step == 2) uiTimeCnst = ERASE_TIMER; 
  else uiTimeCnst = SYNCHRO_TIMER;
  ucResult = Prog_command_answer(uiTimeCnst);
  if(ucResult == 1) return 1;
  else
  {
   if(ucResult ==2)
   {
    Prog_phase_next();
    Prog_status_message(hDlg, (LPTSTR) "Микросхема стерта");
   }
  }
 }
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Инициализация
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
void Prog_synchro_init(void)
{
  ucProg_phase_index = 0xFF;
  Prog_phase_next();
  uiSynchro_count =0; 
  uiSynchro_step  =0; 
  uiSynchro_wrmarker = uiSynchro_rdmarker;
}
//---------------------------------------------------------------------------
//Описание: Синхронизация
//Входные параметры: нет
//Выходные параметры: нет
//--------------------------------------------------------------------------
char Prog_synchro_processing(HWND hDlg)
{
 unsigned char ucByte;

 if(uiSynchro_step ==0)						//отправим команду в COM порт
 {
  ucByte = SYNC_CRC; 
  if(Prog_transmit_processing(&ucByte,1,1) !=0) return 1;//отправить сообщение
 }
 else										//принимаем команду
 {
  if(Prog_read_check() !=0)
  {  
   ucByte = Prog_read_byte();
   if(ucByte == PROG_OK)
   {
	uiSynchro_step =0;
    uiSynchro_count = uiSynchro_count + 1;
    if(uiSynchro_count >=5)					//синхронизация установлена
    {
     Prog_phase_next();						//переходим к новой фазе
     Prog_status_message(hDlg, (LPTSTR) "Соединение подтверждено");
    }
    return 0;
   }
  } 
  if((Prog_get_timer_ms() - uiSynchro_timer) >= SYNCHRO_TIMER) return 1;//время вышло - ответа не было
 }	 
 return 0;
}
//---------------------------------------------------------------------------
//Описание: Автопрограммирование
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_auto_programm(HWND hDlg)
{
  if(ucProg_phase != PROG_PHASE_NULL) return;	//предыдущая операция не закончена
  if(Prog_open_com(hDlg) !=0) return;			//открываем COM порт
  ucProg_scripr_addr = ucScriptAutoProgramm; 
  ucProg_phase_max = sizeof(ucScriptAutoProgramm);
  Prog_synchro_init();
  Prog_status_message(hDlg, (LPTSTR) "Установка соединения");
} 
//---------------------------------------------------------------------------
//Описание: Чтение Flash
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_verify_flashEx(HWND hDlg)
{
  uiSynchro_addr =0;							//начальный адрес чтения
  uiSynchro_page_count =0;						//счетчик страниц
  Prog_status_message(hDlg, (LPTSTR) "Верификация FLASH");
  Prog_update_progressdlg(hDlg, 0); 
  Prog_phase_next();
} 
//---------------------------------------------------------------------------
//Описание: Чтение Flash
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_write_flashEx(HWND hDlg)
{
 if(uiFlashRealSize == 0) return;
 uiSynchro_addr =0;							//начальный адрес чтения
 uiSynchro_page_count =0;						//счетчик страниц
 Prog_status_message(hDlg, (LPTSTR) "Запись FLASH");
 Prog_update_progressdlg(hDlg, 0); 
 Prog_phase_next();
} 
//---------------------------------------------------------------------------
//Описание: Основньй процесс
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_processing(HWND hDlg)
{
 
 ucProg_phase = PROG_PHASE_NULL;

 for(;;)
 {
  if(!IsIconic(hDlg)) TimeS.TimeSys_processing(); 
  if(cCom_open !=0) Prog_receive_processing();

  switch(ucProg_phase)
   {
    case PROG_PHASE_NULL:
						Sleep(10);
						break;
    case PROG_PHASE_SYNCHRO: 
						if(Prog_synchro_processing(hDlg) !=0) Prog_error_message(hDlg,1);//процесс завершился ошибкой				
						break;  
	case PROG_PHASE_ENTER_PROGMODE:			//вход в программный режим
						if(Prog_enter_processing() !=0)	Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;
	case PROG_PHASE_LEAVE_PROGMODE:			//выход из программного режима
						if(Prog_leave_processing() !=0) Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;
	case PROG_PHASE_READ_SIGNATURE:			//чтение сигнатуры
						Prog_read_signature(hDlg); 
						break;
	case PROG_PHASE_ERASE_CHIP:				//стирание микросхемы
						if(Prog_erase_chip(hDlg) !=0) Prog_error_message(hDlg,0);	//процесс завершился ошибкой				
						break;
	case PROG_PHASE_READ_FUSE_LOW:			//чтение фьюзов
						if(Prog_read_fuselow(hDlg) !=0) Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;
	case PROG_PHASE_READ_FUSE_HIGH:			//чтение фьюзов
						if(Prog_read_fusehigh() !=0) Prog_error_message(hDlg,0);	//процесс завершился ошибкой				
						break;
	case PROG_PHASE_READ_FUSE_EXT:			//чтение фьюзов
						if(Prog_read_fuseext(hDlg) !=0)	Prog_error_message(hDlg,0); //процесс завершился ошибкой				
						break;
	case PROG_PHASE_WRITE_FUSE_LOW:			//запись фьюзов
						if(Prog_write_fuselow(hDlg) !=0) Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;
	case PROG_PHASE_WRITE_FUSE_HIGH:		//запись фьюзов
						if(Prog_write_fusehigh(hDlg) !=0) Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;
	case PROG_PHASE_WRITE_FUSE_EXT:			//запись фьюзов
						if(Prog_write_fuseext(hDlg) !=0) Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;
	case PROG_PHASE_PAGE_FLASH_SIZE:		//чтение FLASH памяти
						if(Prog_page_flash_size() !=0) Prog_error_message(hDlg,0);	//процесс завершился ошибкой				
						break;
	case PROG_PHASE_INIT_VERIFY_FLASH:
					    Prog_verify_flashEx(hDlg);
						break;
	case PROG_PHASE_VERIFY_FLASH:				//сравнение FLASH памяти
						if(Prog_verify_flash(hDlg) !=0) Prog_error_message(hDlg,0);	//процесс завершился ошибкой				
						break;
	case PROG_PHASE_INIT_WRITE_FLASH:
					    Prog_write_flashEx(hDlg);
						break;
	case PROG_PHASE_WRITE_FLASH:			//запись FLASH памяти
						if(Prog_write_flash(hDlg) !=0) Prog_error_message(hDlg,0);	//процесс завершился ошибкой				
						break;
    case PROG_PHASE_VERSION: 
						if(Prog_read_version(hDlg) !=0) Prog_error_message(hDlg,0);//процесс завершился ошибкой				
						break;  
   }
 }
}
//---------------------------------------------------------------------------
//Описание: Инициализация переменных
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_ini_variable(HWND hDlg,HINSTANCE hInst)
{
 char i;
 unsigned char ucNameBuf[10];

 cNumCOM  = 0;
 
 TimeS.TimeSys_ini_variable(hDlg,IDC_STATIC_TIME);
 
 cCom_open =0;

 uiSynchro_wrmarker =0;
 uiSynchro_rdmarker =0;
 ucProg_buff_flash  =0;
 uiProg_progress_old   =0;
 uiFlashRealSize = 0;
 ulFuseReal =0;
 ucFuseFlg  =0;
 
 Progress_init_progressdlg(hDlg);
 Prog_update_deviceparam();

 for(i =0; i < 16;i++)
 {
  sprintf((char *) &ucNameBuf[0],"COM%.d",(i + 1));
  SendMessage(GetDlgItem(hDlg,IDC_COM_NUMBER),CB_ADDSTRING,0,(LPARAM)(LPCTSTR) &ucNameBuf[0]); 
 }
 SendMessage(GetDlgItem(hDlg,IDC_COM_NUMBER),CB_SETCURSEL, cNumCOM,0); 
}
//---------------------------------------------------------------------------
//Описание: Закрытие всех устройств
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_destroy(HWND hDlg)
{
 if(ucProg_buff_flash !=0) free(ucProg_buff_flash);
 Prog_close_com();
}
//---------------------------------------------------------------------------
//Описание: Изменилось состояние выбора COM порта
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
void Prog_com_select(HWND hDlg)
{
 cNumCOM  = (char) SendMessage(GetDlgItem(hDlg,IDC_COM_NUMBER),CB_GETCURSEL,0,0);
}
//---------------------------------------------------------------------------
//Описание: Загрузка Hex файла
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
int Prog_ihex_readrec(struct ihexrec* ihex, char* rec)
{
  int i, j;
  char buf[8];
  int offset, len;
  char * e;
  unsigned char cksum;
  int rc;

  len    = strlen(rec);
  offset = 1;
  cksum  = 0;

  /* reclen */
  if (offset + 2 > len)
    return -1;
  for (i=0; i<2; i++)
    buf[i] = rec[offset++];
  buf[i] = 0;
  ihex->reclen = strtoul(buf, &e, 16);
  if (e == buf || *e != 0)
    return -1;

  /* load offset */
  if (offset + 4 > len)
    return -1;
  for (i=0; i<4; i++)
    buf[i] = rec[offset++];
  buf[i] = 0;
  ihex->loadofs = strtoul(buf, &e, 16);
  if (e == buf || *e != 0)
    return -1;

  /* record type */
  if (offset + 2 > len)
    return -1;
  for (i=0; i<2; i++)
    buf[i] = rec[offset++];
  buf[i] = 0;
  ihex->rectyp = strtoul(buf, &e, 16);
  if (e == buf || *e != 0)
    return -1;

  cksum = ihex->reclen + ((ihex->loadofs >> 8) & 0x0ff) + 
    (ihex->loadofs & 0x0ff) + ihex->rectyp;

  /* data */
  for (j=0; j<ihex->reclen; j++) {
    if (offset + 2 > len)
      return -1;
    for (i=0; i<2; i++)
      buf[i] = rec[offset++];
    buf[i] = 0;
    ihex->data[j] = strtoul(buf, &e, 16);
    if (e == buf || *e != 0)
      return -1;
    cksum += ihex->data[j];
  }

  /* cksum */
  if (offset + 2 > len)
    return -1;
  for (i=0; i<2; i++)
    buf[i] = rec[offset++];
  buf[i] = 0;
  ihex->cksum = strtoul(buf, &e, 16);
  if (e == buf || *e != 0)
    return -1;

  rc = -cksum & 0x000000ff;

  return rc;
}
//---------------------------------------------------------------------------
//Описание: Загрузка Hex файла
//Входные параметры: нет
//Выходные параметры: нет
//---------------------------------------------------------------------------
int Prog_ihex_load(char* filename, unsigned char* outbuf, int bufsize)
{
  FILE *fin;
  char buffer [256];
  unsigned char* buf;
  unsigned int nextaddr, baseaddr, maxaddr;
  int i;
  int lineno;
  int len;
  struct ihexrec ihex;
  int rc;

  lineno   = 0;
  buf      = outbuf;
  baseaddr = 0;
  maxaddr  = 0;

  fin = fopen(filename, "r");
  if (fin == NULL)  return 0;

  while (fgets((char *)buffer,256,fin)!=NULL) 
   {
    lineno++;
    len = strlen(buffer);
    if (buffer[len-1] == '\n') 
      buffer[--len] = 0;
    if (buffer[0] != ':')
      continue;
    rc = Prog_ihex_readrec(&ihex, buffer);
    if(rc < 0)
	{
     fclose(fin);
     return 0;
    }
    else if (rc != ihex.cksum) 
	{
      fclose(fin);
      return 0;
    }

    switch (ihex.rectyp)
	{
      case 0: /* data record */
        nextaddr = ihex.loadofs + baseaddr;
        if(nextaddr + ihex.reclen > bufsize)
		{
         fclose(fin);
         return 0;
        }
        for (i=0; i<ihex.reclen; i++) 
		{
          buf[nextaddr+i] = ihex.data[i];
        }
        if (nextaddr+ihex.reclen > maxaddr)
          maxaddr = nextaddr+ihex.reclen;
        break;

      case 1: /* end of file record */
        fclose(fin);
        return maxaddr;

      case 2: /* extended segment address record */
        baseaddr = (ihex.data[0] << 8 | ihex.data[1]) << 4;
        break;

      case 4: /* extended linear address record */
        baseaddr = (ihex.data[0] << 8 | ihex.data[1]) << 16;
        break;

      default:
        fclose(fin);
        return 0;
    }

  }
  fclose(fin);
  return maxaddr;
}
