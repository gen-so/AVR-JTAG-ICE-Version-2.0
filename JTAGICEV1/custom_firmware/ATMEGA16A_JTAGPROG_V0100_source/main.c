//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, ������ 2014
//main.c  - ������ �������� �������
//��� ����������������: atmega16a
//�����: Mick (������� ������)
//������ ������: v1.00 - 13 ����� 2014 
//----------------------------------------------------------------------------------------------------------------------------
#include "main.h"

#define TIMER_CLK			140		//7372800 / 256 = 28800 => 256 - 116 = 140

//-------------------------------------------------------------
//��������:�������� ���������� �����������
//-------------------------------------------------------------
 unsigned char ucCPU_led_timer;
 unsigned int  uiCPU_ms_timer;
//-------------------------------------------------------------------------------------------------------------------------
// ��������:  ������������� ������������ .
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void CPU_init(void)
{
  PORTA = 0xFF;                                         //���� A �� ����
  DDRA  = 0x00;						

  PORTB = 0xFF;                                         //���� B ������������ ���:
  DDRB  = 0xAA;						//TMS,STATUS,TDI,TCK - ������

  PORTC = 0xFF;                                         //���� C �� ����
  DDRC  = 0x00;						

  PORTD = 0xF7;                         		//���� D �� ����: RXD, CSAVR, DATKK, DATKM,CLKK,CLKM 
  DDRD  = 0x09;				                //�����: TXD =1, RES =0

  ACSR  = 0x80;  					

  MCUCR = 0x00;						//�������� ������� ����������
  GICR  = 0x00; 

  TCCR0 = 0x04;						// 8-������ ������ ���������� CLK/256
  TCNT0 = TIMER_CLK;					//���������� �� ������� 

  TIMSK = 0x01;						//���������� ���������� �� 8 - ������� �������   
  TIFR  = 0x01;						//������� ���� ���������� �� 16 - �� ������� �������

 }                                     
//----------------------------------------------------------
//��������:     ��������/��������� ���������
//���������:    cState  -   ��������� ����������
//������������  ��������:  ���
//---------------------------------------------------------
void CPU_led_state(char cState)
{
 if(cState ==0) PORTB = PORTB | 0x08;
 else PORTB = PORTB & 0xF7;
 ucCPU_led_timer = 0;
}
//-------------------------------------------------------------------
// ��������: ��������� ��������� ��������� �����
// ���������:       ���
// ������������  ��������:    ���������� ��������� �����
//-------------------------------------------------------------------
unsigned int CPU_get_timer_ms(void)
{
 return uiCPU_ms_timer;
}
//-----------------------------------------------------------------------------------------------------------------------
// ��������:  ���������� �������� ���������.
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
void main(void)
{
 DisableInterrupts;					//#asm("CLI")
 CPU_init();						// ������������� ����������������
 uiCPU_ms_timer  = 0;
 ucCPU_led_timer = 0;
 JTAG_Init();
 UART_init();
 Terminal_init();
 EnableInterrupts;                               	//#asm("SEI")
 for(;;)
  {
   Terminal_cmd_analyze();
   if(ucCPU_led_timer >= 250) 
     {
      ucCPU_led_timer = 0; 
      PORTB = PORTB ^ 0x08;
     } 
  }
}
//------------------------------------------------------------------------------------------------------------------------
// ��������: ��������� ���������� ��  8 - ������� ������� (����� ������ 4,096mc)
// ���������:    ���
// ������������  ��������:  ���
//-------------------------------------------------------------------------------------------------------------------------
interrupt [TIM0_OVF] void Timer0_overlow(void)
{
 TIFR = TIFR | 0x01;					//������� ���� ���������� �� 8 - �� ������� �������
 TCNT0 = TIMER_CLK;					//���������� �� ������� ���������� ����� 4�� 
 uiCPU_ms_timer = uiCPU_ms_timer + 1;			//����������� ������� ��������� ����� 
 ucCPU_led_timer = ucCPU_led_timer +1; 
}