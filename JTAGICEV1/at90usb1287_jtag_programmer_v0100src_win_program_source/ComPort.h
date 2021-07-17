#include <windows.h>

class ComPort
{
 private:  HANDLE hCom;
           int    iMaxLen;				//�������� ���������� ����������� ����
 public:   DWORD  ComPort_open(LPCTSTR  lpNamePort,int iMaxLen);
           int    ComPort_write(unsigned char *ucBufWrite, int iLenStr);
		   int    ComPort_read(unsigned char *ucBufRead);
           void   ComPort_close(void);
};
//---------------------------------------------------------------------------
//��������: �������� COM �����
//������� ���������: lpNamePort - ��� �����
//�������� ���������: ���
//---------------------------------------------------------------------------
DWORD ComPort :: ComPort_open(LPCTSTR  lpNamePort,int iMaxLen)
{
 DWORD dwError;
 DCB dcb;
 COMMTIMEOUTS timeouts;

 this->iMaxLen = iMaxLen;
 hCom = CreateFile( lpNamePort,GENERIC_READ | GENERIC_WRITE,0,NULL,OPEN_EXISTING,0,NULL);
 if(hCom == INVALID_HANDLE_VALUE) return GetLastError();
 if(GetCommState(hCom, &dcb) == NULL)
  {
   dwError = GetLastError();
   CloseHandle(hCom);
   return dwError;
  }
  dcb.BaudRate = CBR_57600;//CBR_19200;     			// set the baud rate
  dcb.ByteSize = 8;             			// data size, xmit, and rcv
  dcb.Parity = NOPARITY;        			// no parity bit
  dcb.StopBits = ONESTOPBIT;    			// one stop bit
  dcb.fDtrControl = DTR_CONTROL_DISABLE;
  dcb.fRtsControl = RTS_CONTROL_DISABLE;

  if(SetCommState(hCom, &dcb) ==NULL)
  {
   dwError = GetLastError();
   CloseHandle(hCom);
   return dwError;
  }
  GetCommTimeouts(hCom,&timeouts);
  timeouts.ReadIntervalTimeout     	= 0;
  timeouts.ReadTotalTimeoutMultiplier   = 0;
  timeouts.ReadTotalTimeoutConstant 	= 1; 
  if(SetCommTimeouts(hCom, &timeouts) ==NULL)
   {
    dwError = GetLastError();
    CloseHandle(hCom);
    return dwError;
   }
 return NULL;
}
//---------------------------------------------------------------------------
//��������: ������ � COM ����
//������� ���������: ucBufWrite - �������� �����
//	             iLenStr - ����� ������
//�������� ���������: �������� ���������� ���������� ���� 
//---------------------------------------------------------------------------
int ComPort :: ComPort_write(unsigned char *ucBufWrite, int iLenStr)
{
 DWORD dRealWriteByte;
 WriteFile(hCom,ucBufWrite,iLenStr,&dRealWriteByte,NULL);
 return (int)dRealWriteByte;  
}
//---------------------------------------------------------------------------
//��������: ������ �� COM �����
//������� ���������: ucBufRead - ������� �����
//�������� ���������: iRealReadByte - �������� ���������� ����������� ��������
//---------------------------------------------------------------------------
int ComPort :: ComPort_read(unsigned char *ucBufRead)
{
 DWORD dRealReadByte;
 if(ReadFile(hCom,ucBufRead,iMaxLen,&dRealReadByte, NULL) == NULL) return 0;
 return (int) dRealReadByte;  
}
//---------------------------------------------------------------------------
//��������: �������� COM �����
//������� ���������: ���
//�������� ���������: ���
//---------------------------------------------------------------------------
void ComPort :: ComPort_close(void)
{
 CloseHandle(hCom);
}
