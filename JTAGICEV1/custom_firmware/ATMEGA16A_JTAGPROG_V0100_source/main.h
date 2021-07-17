//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//main.c  - модуль основных функций
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: v1.00 - 13 марта 2014 
//----------------------------------------------------------------------------------------------------------------------------
#include <mega16.h>
#include <delay.h>

#define DisableInterrupts	{ #asm("CLI") }
#define EnableInterrupts	{ #asm("SEI") }
#define Nop			{ #asm("NOP") }

extern void CPU_init(void);
extern unsigned int CPU_get_timer_ms(void);
extern void CPU_led_state(char cState);



#include "uart.h"
#include "terminal.h"
#include "jtag.h"

