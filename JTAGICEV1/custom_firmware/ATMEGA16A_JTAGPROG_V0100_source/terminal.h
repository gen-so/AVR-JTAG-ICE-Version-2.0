//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, ������ 2014
//terminal.c  - ������ ������� ��������� ������.
//��� ����������������: atmega16a
//�����: Mick (������� ������)
//������ ������: 1.00 - 13 ����� 2014
//----------------------------------------------------------------------------------------------------------------------------
extern void Terminal_init(void);
extern char Terminal_cmd_correct(void);
extern char Terminal_data_load(unsigned int uiCountByte, unsigned char *ucBuffer);
extern void Terminal_cmd_analyze(void);

