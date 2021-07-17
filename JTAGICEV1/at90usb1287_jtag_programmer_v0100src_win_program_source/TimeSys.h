//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, ������ 2014
//TimeSys.h - ������ ������� ��������� ���������� �������.
//�����: Mick (������� ������)
//������ ������: 1.00 - 13 ����� 2014
//----------------------------------------------------------------------------------------------------------------------------
#include <stdlib.h> 
#include <windows.h>

#define MESSAGE_TIME	"  ����� �������: "
#define LEN_MESTIME	sizeof(MESSAGE_TIME)

class TimeSys
{
 private:
	 unsigned char ucTimeFlg;
	 HWND hWndOut;
	 int iIdWndOut;
 public: void TimeSys_ini_variable(HWND hWndOut, int iIdWndOut);
         void TimeSys_processing(void);
};
//---------------------------------------------------------------------------
//��������: ������������� ���������� 
//������� ���������: hWndOut  - ���������� ����
//		     iIdWndOut
//�������� ���������: ���
//---------------------------------------------------------------------------
void TimeSys :: TimeSys_ini_variable(HWND hWndOut, int iIdWndOut)
{  
 ucTimeFlg =0;
 this->hWndOut  = hWndOut;
 this->iIdWndOut = iIdWndOut;
}
//---------------------------------------------------------------------------
//��������: ������� ������������ ��������� ���������� �������
//������� ���������: ���
//�������� ���������: ���
//---------------------------------------------------------------------------
void TimeSys :: TimeSys_processing(void)
{
 unsigned char ucWorkByte;
 unsigned char ucTimeBuf[30];

 SYSTEMTIME Systime;
 GetLocalTime(&Systime);
 ucWorkByte= (unsigned char)Systime.wSecond;
 if(ucWorkByte != ucTimeFlg) 
  { 
   ucTimeFlg = ucWorkByte;
   ucWorkByte = (unsigned char)Systime.wHour;
   sprintf((char *)&ucTimeBuf,MESSAGE_TIME);
   sprintf((char *)&ucTimeBuf[LEN_MESTIME-1],"%.2d",ucWorkByte);
   ucWorkByte = (unsigned char)Systime.wMinute;
   sprintf((char *)&ucTimeBuf[LEN_MESTIME+1],":%.2d",ucWorkByte);
   ucWorkByte =(unsigned char)Systime.wSecond;
   sprintf((char *)&ucTimeBuf[LEN_MESTIME+4],":%.2d",ucWorkByte);
   SetDlgItemText(hWndOut, iIdWndOut, (LPCTSTR)&ucTimeBuf);
  }
}
