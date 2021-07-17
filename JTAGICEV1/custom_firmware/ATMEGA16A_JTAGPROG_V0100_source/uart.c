//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, ������ 2014
//uart.c  - ������ �����������  ������-����������� UART
//��� ����������������: atmega16a
//�����: Mick (������� ������)
//������ ������: 1.00 - 13 ����� 2014
//----------------------------------------------------------------------------------------------------------------------------
#include "main.h"

#define UART_LEN_INBUFFER	0x3F                    //������ �������� ������ 64 �����
#define UART_LEN_OUTBUFFER	0x3F                    //������ ��������� ������ 64 �����

//------------------------------------------------------------------
//��������: ���������� UART 
//------------------------------------------------------------------
 unsigned char ucUART_receive_rdmarker;			//������ ������
 unsigned char ucUART_receive_wrmarker;			//������ ������
 unsigned char ucUART_inbuf[UART_LEN_INBUFFER +1];		//����� ����������� ������� 

 unsigned char ucUART_transmit_rdmarker;		//������ ������
 unsigned char ucUART_transmit_wrmarker;		//������ ������
 unsigned char ucUART_outbuf[UART_LEN_OUTBUFFER +1];	//����� ����������� ������� 
//----------------------------------------------------------------------
// ��������:   ������������� ���������� ������ UART
// ���������:  ���
// ������������  ��������:   ���
//----------------------------------------------------------------------
void UART_init(void)
{
 UCSRB  = 0x98;
 UCSRC  = 0x86;						// 1 �������� ���, ��� ��������
 UBRRH  = 0;	                                  	
 UBRRL  = 0x07;                                  	// UART 19200 (0x17 = 23)
 ucUART_transmit_wrmarker =0;
 ucUART_transmit_rdmarker =0;				//����� ������
 ucUART_receive_wrmarker =0;
 ucUART_receive_rdmarker =0;
}
//-------------------------------------------------------------------
// ��������: �������� ��������� ��������� ������
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
unsigned char UART_read_check(void)
{
 if(ucUART_receive_rdmarker == ucUART_receive_wrmarker) return 0;//�������� ����� ����
 return 1;
}
//-------------------------------------------------------------------
// ��������: ������ ����� �� ��������� ������
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
unsigned char UART_read_byte(void)
{
 unsigned char ucByte;
 while(ucUART_receive_rdmarker == ucUART_receive_wrmarker);//���� ���� ����� ��� ����
 ucByte = ucUART_inbuf[ucUART_receive_rdmarker];          
 ucUART_receive_rdmarker = ucUART_receive_rdmarker +1; 
 ucUART_receive_rdmarker = ucUART_receive_rdmarker & UART_LEN_INBUFFER;
 return ucByte;
}
//-------------------------------------------------------------------
// ��������: �������� ������ ����� � UART
// ���������:    ucByte - ���� ������
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
void UART_send_byte(unsigned char ucByte)
{
 unsigned char ucMarker;
 ucMarker = ucUART_transmit_wrmarker + 1;
 ucMarker = ucMarker & UART_LEN_OUTBUFFER;

 while(ucMarker == ucUART_transmit_rdmarker);		//���� ���� ����� ��� �� �����������

 ucUART_outbuf[ucUART_transmit_wrmarker] = ucByte;
 ucUART_transmit_wrmarker = ucMarker;			//����� �������� ���������
 UCSRB = UCSRB | 0x20;					//�������� �������� �������
}
//-------------------------------------------------------------------
// ��������: ��������� ���������� �� ��������� UART 
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
interrupt [USART_RXC] void Uart_rxc(void)
{
 ucUART_inbuf[ucUART_receive_wrmarker] = UDR;          //�������� �������� ���� � �������� ������ 
 ucUART_receive_wrmarker = ucUART_receive_wrmarker +1; 
 ucUART_receive_wrmarker = ucUART_receive_wrmarker & UART_LEN_INBUFFER;
}
//-------------------------------------------------------------------
// ��������: ��������� ���������� �� ����������� UART 
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
interrupt [USART_DRE] void Uart_dre(void)
{
 if(ucUART_transmit_wrmarker != ucUART_transmit_rdmarker)//����� ��� �� ����
  {
   PORTB = PORTB ^ 0x08;
   UDR = ucUART_outbuf[ucUART_transmit_rdmarker];
   ucUART_transmit_rdmarker = ucUART_transmit_rdmarker + 1;
   ucUART_transmit_rdmarker = ucUART_transmit_rdmarker & UART_LEN_OUTBUFFER;
  }
 else UCSRB = UCSRB & 0xDF;
}