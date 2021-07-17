//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//terminal.c  - модуль функций обработки команд.
//Тип микроконтроллера: atmega16a
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
extern void Terminal_init(void);
extern char Terminal_cmd_correct(void);
extern char Terminal_data_load(unsigned int uiCountByte, unsigned char *ucBuffer);
extern void Terminal_cmd_analyze(void);

