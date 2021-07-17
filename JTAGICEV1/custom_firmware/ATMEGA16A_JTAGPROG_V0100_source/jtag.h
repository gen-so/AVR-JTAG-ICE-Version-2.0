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
#define JTAG_EXTEST         0x0
#define JTAG_IDCODE         0x1
#define JTAG_BYPASS         0xF
#define JTAG_SAMPLE_PRELOAD 0x2
#define JTAG_AVR_RESET      0xC
#define JTAG_PROG_ENABLE    0x4
#define JTAG_PROG_COMMANDS  0x5
#define JTAG_PROG_PAGELOAD  0x6
#define JTAG_PROG_PAGEREAD  0x7



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

