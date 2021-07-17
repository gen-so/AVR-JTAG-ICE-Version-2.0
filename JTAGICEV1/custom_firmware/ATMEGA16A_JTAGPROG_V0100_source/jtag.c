//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, ������ 2014
//jtag.c  - ������ ������� ��������� JTAG ������.
//��� ����������������: atmega16a
//�����: Mick (������� ������)
//������ ������: 1.00 - 13 ����� 2014
//----------------------------------------------------------------------------------------------------------------------------
//����������: �� ������ ������� ������ ����� ��������� �������� Lavor -> Laurent Saint-Marcel (lstmarcel@yahoo.fr) �
//JTAGFlasher ����������� �������������� ������������ (������� � ��������� ���������)
//----------------------------------------------------------------------------------------------------------------------------

#include "main.h"

#define TMS_0 			0
#define TMS_1                   1

#define TDI_0 			0
#define TDI_1 			1

#define TMS_PIN      	 	1
#define TMS_MASK      	 	0x02
#define TDI_PIN      	 	5
#define TDI_MASK      	 	0x20
#define TDO_PIN      	 	6
#define TDO_MASK      	 	0x40
#define TCLK_PIN     		7
#define TCLK_MASK     		0x80

//----------------------------------------------------------------------------------------------------------------------
//��������:�������� ���������� �����������
//-----------------------------------------------------------------------------------------------------------------------
 char cJTAG_prog_mode;					//���� ������ ���������������� 
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ������������� JTAG 
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_Init(void)
{
  PORTB = 0xFF;
  DDRB = DDRB & ~TDO_MASK;
  DDRB = DDRB | (TMS_MASK | TDI_MASK | TCLK_MASK) ;
  cJTAG_prog_mode = 0;
}
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ������������ TAP ������������������ JTAG
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_Tap(unsigned long ulState, unsigned char ucCount)
 {
  unsigned char i;
  PORTB = PORTB & ~TCLK_MASK;
  PORTB = PORTB & ~TMS_MASK;
  for(i =0; i < ucCount; i++)
   {
    if((ulState & 0x01)!= 0) PORTB = PORTB | TMS_MASK; 
    else PORTB = PORTB & ~TMS_MASK;
    ulState = ulState >> 1;
    PORTB = PORTB | TCLK_MASK;
    PORTB = PORTB & ~TCLK_MASK;
   }
 }
//-------------------------------------------------------------------------------------------------------------------------
// ��������: �������� ������ � JTAG
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
unsigned long JTAG_ShiftInstruction(unsigned long ulInstruction, unsigned char ucCount)
 {
  unsigned char i;
  unsigned long ulResult;
  ulResult =0; 
  PORTB = PORTB & ~TMS_MASK;
  PORTB = PORTB & ~TCLK_MASK;
  for( i =0; i < ucCount; i++)
   {
    if((ulInstruction & 0x01) != 0) PORTB = PORTB | TDI_MASK; 
    else PORTB = PORTB & ~TDI_MASK;
    ulInstruction = ulInstruction >>1;
    if(i == (ucCount-1)) PORTB = PORTB | TMS_MASK; // ��������� ��� JTAG ����������: ���������� ���� �� Shift-IR
    PORTB = PORTB | TCLK_MASK;
    if ((PINB & TDO_MASK) != 0) ulResult = ulResult | 0x80000000;
    ulResult = ulResult >>1;
    PORTB = PORTB & ~TCLK_MASK;
   }
  return ulResult;
 }
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ����� ������� � JTAG ���������
// ���������:    ���
// ������������  ��������:  uiResult - ����� ����������
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
// ��������: ���� � ����� ����������������
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ����� �� ������ ����������������
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ���� � ����� ����������������
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_EnterProgMode(void)
{
 JTAG_EnteringProgramming();
 cJTAG_prog_mode = 1;
}
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ����� �� ������ ����������������
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_LeaveProgMode(void)
{
 JTAG_LeavingProgramming();
 cJTAG_prog_mode = 0;
}
//-------------------------------------------------------------------------------------------------------------------------
// ��������: �������� ������ ����������������
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
char JTAG_CheckProgMode(void)
{
 return cJTAG_prog_mode;
}
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ������ ���������
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ ��������������� ����� 
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ ����� Ext Fuse �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ ����� Ext Fuse �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ �������� ����� Fuse �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ �������� ����� Fuse �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ �������� ����� Fuse �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ �������� ����� Fuse �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ Lock �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ Lock �����
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: �������� ������������ ����������
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void JTAG_ChipErase(void)
{
 // 1a : start chip erase
 JTAG_WriteProgCmd(0x23, 0x80); 
 JTAG_WriteProgCmd(0x31, 0x80);
 JTAG_WriteProgCmd(0x33, 0x80);
 JTAG_WriteProgCmd(0x33, 0x80);
 // 1b : poll for chip erase complete 
 while ((JTAG_WriteProgCmd(0x33, 0x80) & 0x200) == 0) Nop;

}
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ������ �������� �� EEPROM ������
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ �������� � EEPROM ������
// ���������:    ���
// ������������  ��������:  ���
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
  while ((JTAG_WriteProgCmd(0x33, 0x00) & 0x200) == 0) Nop;
}
//-------------------------------------------------------------------------------------------------------------------------
// ��������: ������ ����� �� FLASH ������
// ���������:    ���
// ������������  ��������:  ���
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
// ��������: ������ �������� �� FLASH ������
// ���������:    ���
// ������������  ��������:  ���
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
  while((JTAG_WriteProgCmd(0x37, 0x00) & 0x200) == 0) Nop;
}


