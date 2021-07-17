//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//uart.c  - модуль обсуживания  приемо-передатчика UART
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
#include "main.h"

#define UART_LEN_INBUFFER	0x3F                    //размер входного буфера 64 байта
#define UART_LEN_OUTBUFFER	0x3F                    //размер выходного буфера 64 байта

//------------------------------------------------------------------
//Описание: переменные UART 
//------------------------------------------------------------------
 unsigned char ucUART_receive_rdmarker;			//маркер буфера
 unsigned char ucUART_receive_wrmarker;			//маркер буфера
 unsigned char ucUART_inbuf[UART_LEN_INBUFFER +1];		//буфер принимаемой команды 

 unsigned char ucUART_transmit_rdmarker;		//маркер буфера
 unsigned char ucUART_transmit_wrmarker;		//маркер буфера
 unsigned char ucUART_outbuf[UART_LEN_OUTBUFFER +1];	//буфер принимаемой команды 
//----------------------------------------------------------------------
// описание:   Инициализация переменных канала UART
// параметры:  нет
// возвращаемое  значение:   нет
//----------------------------------------------------------------------
void UART_init(void)
{
 UCSRB  = 0x98;
 UCSRC  = 0x86;						// 1 стоповых бит, без четности
 UBRRH  = 0;	                                  	
 UBRRL  = 0x07;                                  	// UART 19200 (0x17 = 23)
 ucUART_transmit_wrmarker =0;
 ucUART_transmit_rdmarker =0;				//длина пакета
 ucUART_receive_wrmarker =0;
 ucUART_receive_rdmarker =0;
}
//-------------------------------------------------------------------
// описание: Проверка состояния приемного буфера
// параметры:    нет
// возвращаемое  значение:  нет 
//-------------------------------------------------------------------
unsigned char UART_read_check(void)
{
 if(ucUART_receive_rdmarker == ucUART_receive_wrmarker) return 0;//приемный буфер пуст
 return 1;
}
//-------------------------------------------------------------------
// описание: Чтение байта из приемного буфера
// параметры:    нет
// возвращаемое  значение:  нет 
//-------------------------------------------------------------------
unsigned char UART_read_byte(void)
{
 unsigned char ucByte;
 while(ucUART_receive_rdmarker == ucUART_receive_wrmarker);//ждем если буфер еще пуст
 ucByte = ucUART_inbuf[ucUART_receive_rdmarker];          
 ucUART_receive_rdmarker = ucUART_receive_rdmarker +1; 
 ucUART_receive_rdmarker = ucUART_receive_rdmarker & UART_LEN_INBUFFER;
 return ucByte;
}
//-------------------------------------------------------------------
// описание: Отправка одного байта в UART
// параметры:    ucByte - байт данных
// возвращаемое  значение:  нет 
//-------------------------------------------------------------------
void UART_send_byte(unsigned char ucByte)
{
 unsigned char ucMarker;
 ucMarker = ucUART_transmit_wrmarker + 1;
 ucMarker = ucMarker & UART_LEN_OUTBUFFER;

 while(ucMarker == ucUART_transmit_rdmarker);		//ждем если буфер еще не освободился

 ucUART_outbuf[ucUART_transmit_wrmarker] = ucByte;
 ucUART_transmit_wrmarker = ucMarker;			//новое занчение указателя
 UCSRB = UCSRB | 0x20;					//разрешим передачу символа
}
//-------------------------------------------------------------------
// описание: Обработка прерывание от приемника UART 
// параметры:    нет
// возвращаемое  значение:  нет 
//-------------------------------------------------------------------
interrupt [USART_RXC] void Uart_rxc(void)
{
 ucUART_inbuf[ucUART_receive_wrmarker] = UDR;          //сохраним принятый байт в приемном буфере 
 ucUART_receive_wrmarker = ucUART_receive_wrmarker +1; 
 ucUART_receive_wrmarker = ucUART_receive_wrmarker & UART_LEN_INBUFFER;
}
//-------------------------------------------------------------------
// описание: Обработка прерывание от передатчика UART 
// параметры:    нет
// возвращаемое  значение:  нет 
//-------------------------------------------------------------------
interrupt [USART_DRE] void Uart_dre(void)
{
 if(ucUART_transmit_wrmarker != ucUART_transmit_rdmarker)//буфер еще не пуст
  {
   PORTB = PORTB ^ 0x08;
   UDR = ucUART_outbuf[ucUART_transmit_rdmarker];
   ucUART_transmit_rdmarker = ucUART_transmit_rdmarker + 1;
   ucUART_transmit_rdmarker = ucUART_transmit_rdmarker & UART_LEN_OUTBUFFER;
  }
 else UCSRB = UCSRB & 0xDF;
}