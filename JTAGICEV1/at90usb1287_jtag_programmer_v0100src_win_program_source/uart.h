#define UART_LEN_INBUFFER	256
#define UART_LEN_OUTBUFFER	256

#define UART_RECEIVE_TIMER 	5000			//����� �������� ������� ������� �� UART  100 * 4ms
#define UART_TRANSMIT_TIMER 500			//����� �������� �������� ������� � UART  100 * 4ms


#define UART_RECEIVE_START	1
#define UART_RECEIVE_END	2

#define UART_FRAME_START	0x80                    //��������� ������

#include <windows.h>

#include  "comport.h"
ComPort ComPortU;

class UartDriver
{
 private: 
          char cUartDriver_receive_flag;	  	//��������� ���������
          unsigned char ucUartDriver_receive_marker;	//������ ������
          unsigned char ucUartDriver_receive_len;	//����� ������
          unsigned int  uiUartDriver_receive_timer;	//����� �� ������� ������ ������ �������
          unsigned char ucUartDriver_inbuf[UART_LEN_INBUFFER];  //����� ����������� ������� 
          unsigned char ucUartDriver_outbuf[UART_LEN_OUTBUFFER];//����� ����������� ������� 

		  char UartDriver_check_crc(unsigned char *ucMas);
          void UartDriver_scan_inbuffer(void);
          void UartDriver_ini_receive_data(void);
          unsigned int  UartDriver_get_timer_ms(void);

 public:  DWORD UartDriver_ini_variable_data(LPCTSTR  lpNamePort);
          void UartDriver_stop(void);
          int UartDriver_transmit_data(unsigned char *ucMas, int iLen);
          char UartDriver_processing(unsigned char ucTypeTK , unsigned char ucAddrTK,unsigned char *ucMas);

};
//-------------------------------------------------------------------
// ��������: ������������� ���������� ���������
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
void UartDriver :: UartDriver_ini_receive_data(void)
{
 ucUartDriver_receive_marker =0;
 cUartDriver_receive_flag    =0; 
 ucUartDriver_receive_len    =0;			//����� ������
}
//----------------------------------------------------------------------
// ��������:   ������������� ���������� ������ UART
// ���������:  ���
// ������������  ��������:   ���
//----------------------------------------------------------------------
DWORD UartDriver :: UartDriver_ini_variable_data(LPCTSTR  lpNamePort)
{
 UartDriver_ini_receive_data();
 return ComPortU.ComPort_open(lpNamePort,UART_LEN_INBUFFER);
}
//----------------------------------------------------------------------
// ��������:   ������������� ���������� ������ UART
// ���������:  ���
// ������������  ��������:   ���
//----------------------------------------------------------------------
void UartDriver :: UartDriver_stop(void)
{
 ComPortU.ComPort_close();
}
//----------------------------------------------------------------------
// ��������:   �������� �������� � ��
// ���������:  ���
// ������������  ��������:   ���
//----------------------------------------------------------------------
unsigned int UartDriver :: UartDriver_get_timer_ms(void)
{
 return (unsigned int) GetTickCount();
}
//-------------------------------------------------------------------
// ��������: �������� ����������� �����
// ���������:    ucMas  - ������ ������� ������
// ������������  ��������:  ��������� 
//-------------------------------------------------------------------
char UartDriver :: UartDriver_check_crc(unsigned char *ucMas)
{
 unsigned char i;
 unsigned char ucLen;
 unsigned char ucCrc;
 ucCrc =0;
 ucLen = *(ucMas + 2);
 ucLen = ucLen + 2;

 for(i =0; i < ucLen; i++)
  {
   ucCrc = ucCrc - (*ucMas);
   ucMas = ucMas +1;
  }
 if(*ucMas == ucCrc) return 1;
 return 0;
}
//-------------------------------------------------------------------
// ��������: ������ ��������� ��������� ������
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
void UartDriver :: UartDriver_scan_inbuffer(void)
{    
 int iMarker;
 unsigned char ucLen;
 iMarker = ComPortU.ComPort_read(&ucUartDriver_inbuf[ucUartDriver_receive_marker]);
 ucUartDriver_receive_marker = ucUartDriver_receive_marker + (unsigned char) iMarker;

 if((ucUartDriver_receive_marker !=0) && (cUartDriver_receive_flag < UART_RECEIVE_END))
  {
   if(cUartDriver_receive_flag ==0)
    {
     if(ucUartDriver_inbuf[0] == UART_FRAME_START)
      {
       uiUartDriver_receive_timer = UartDriver_get_timer_ms();	//��������� ������ �� �������� ������ ������
       cUartDriver_receive_flag   = UART_RECEIVE_START;
      }
     else UartDriver_ini_receive_data();                //������ ������
    }
   else 
    {
     if(ucUartDriver_receive_marker >=4)		//����� ������ �������
      {
       ucLen = ucUartDriver_inbuf[3] + 4;
       if(ucUartDriver_receive_marker >= ucLen) cUartDriver_receive_flag = UART_RECEIVE_END;
      }
    }
  }  
}
//-------------------------------------------------------------------
// ��������: �������� ��������� ��������� ������ � ��� ������
// ���������:    ���
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
char UartDriver :: UartDriver_processing(unsigned char ucTypeTK , unsigned char ucAddrTK,unsigned char *ucMas)
{
 char cResult;
 unsigned char i;
 unsigned char ucLen;
 cResult =0;
 UartDriver_scan_inbuffer();                            //������������ ���������
 if(cUartDriver_receive_flag == UART_RECEIVE_START)	//�������� ������ �� ����� ������
  {
   if((UartDriver_get_timer_ms() - uiUartDriver_receive_timer) >= UART_RECEIVE_TIMER) UartDriver_ini_receive_data();
 }
 if(cUartDriver_receive_flag == UART_RECEIVE_END)       //����� ������� 
  {
   if((ucUartDriver_inbuf[1] == ucAddrTK) && (ucUartDriver_inbuf[2] == ucTypeTK))
    {
     if(UartDriver_check_crc(&ucUartDriver_inbuf[1]) !=0) cResult =1;
    }
   UartDriver_ini_receive_data();
  }
 if(cResult !=0)
 {
  ucLen = ucUartDriver_inbuf[3] +4;
  for(i=0; i<ucLen ;i++) ucMas[i] = ucUartDriver_inbuf[i];
  return ucLen;
 }
 else return 0;
}
//-------------------------------------------------------------------
// ��������: �������� ��������� � UART
// ���������:    ucMas - ������ ��� ��������
//		 ucLen - ������ �������
// ������������  ��������:  ��� 
//-------------------------------------------------------------------
int UartDriver :: UartDriver_transmit_data(unsigned char ucB, int iLen)
{
 int i;
 
 for(i =0; i<iLen;i++) ucUartDriver_outbuf[i] = ucMas[i];
 
 return ComPortU.ComPort_write(&ucUartDriver_outbuf[0],iLen);//��������� ���������
}
