//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, ?????? 2014
//uart.c  - ?????? ???????????  ??????-??????????? UART
//??? ????????????????: atmega16a
//?????: Mick (??????? ??????)  
//?????? ??????: 1.00 - 13 ????? 2014
//----------------------------------------------------------------------------------------------------------------------------
extern void UART_init(void);
extern unsigned char UART_read_check(void);
extern unsigned char UART_read_byte(void);
extern void UART_send_byte(unsigned char ucByte);

