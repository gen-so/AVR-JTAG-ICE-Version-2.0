//----------------------------------------------------------------------------------------------------------------------------
//Mick Laboratory, Калуга 2014
//AT90USB1287_JTAG_PROGRAMMER.cpp - модуль основных функций
//Автор: Mick (Тарасов Михаил)
//Версия модуля: 1.00 - 13 марта 2014
//----------------------------------------------------------------------------------------------------------------------------
#include "stdafx.h"
#include <windows.h>
#include <commdlg.h>
#include "resource.h"
#include "test.h"

char const szClassName[] ="AT90USB1287_JTAG_PROGRAMMER";
// Global Variables:


HINSTANCE hInst;								// current instance
HWND hWnd;
HANDLE hThreadC;
DWORD IDThread;
		
OPENFILENAME ofn;       // common dialog box structure
char szFile[256];

//-----------------------------------------------------------------------------------------------------------------------
// описание:  Обработчик событий приложения
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
LRESULT CALLBACK DlgProc(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
 int wmId, wmEvent;
 unsigned int uiMemorySize;
 
 switch (message)
 {
	case WM_COMMAND:
                  wmId    = LOWORD(wParam); 
                  wmEvent = HIWORD(wParam); 
	       switch(wmId)
		   {
  		    case IDC_COM_NUMBER:
                                  if(HIWORD (wParam) == CBN_SELCHANGE) Prog_com_select(hDlg); 
				                  return TRUE;
 		    case IDC_BUTTON_LOAD:
								  ZeroMemory(&ofn, sizeof(ofn));
								  ofn.lStructSize = sizeof(ofn);
								  ofn.hwndOwner = hDlg;
								  ofn.lpstrFile = szFile;
								  ofn.lpstrFile[0] = '\0';
								  ofn.nMaxFile = sizeof(szFile);
							      ofn.lpstrFilter = "HEX files\0*.hex\0";
								  ofn.nFilterIndex = 1;
								  ofn.lpstrFileTitle = NULL;
							      ofn.nMaxFileTitle = 0;
								  ofn.lpstrInitialDir = NULL;
								  ofn.Flags = OFN_PATHMUSTEXIST | OFN_FILEMUSTEXIST | OFN_HIDEREADONLY;

								  if (GetOpenFileName(&ofn)==TRUE) 
								  {
								   uiMemorySize = ProgAVRParam.usFlashSizePage * 2;
								   uiMemorySize = uiMemorySize * ProgAVRParam.usFlashVolPage;
                                   uiMemorySize = Prog_ihex_load(szFile,ucProg_buff_flash,uiMemorySize);
								   if(uiMemorySize != 0)
								   {  
									uiFlashRealSize = uiMemorySize;
									SetDlgItemText(hWnd,IDC_STATIC_FILEIN,(LPTSTR) szFile);
									Prog_status_message(hDlg, (LPTSTR) "Файл загружен!");
								    EnableWindow(GetDlgItem(hDlg,IDC_BUTTON_WRITE),TRUE);
								   }
								  }
				
								  break;
   	        case IDC_BUTTON_WRITE:
								  Progress_init_progressdlg(hDlg);
				                  Prog_auto_programm(hDlg);
								  break;
			case IDC_BUTTON_EXIT:
								  DestroyWindow(hDlg);
								  break;

	          }
                 break;
  case WM_CLOSE: DestroyWindow(hDlg);
                 return 0;
  case WM_DESTROY:
                 Prog_destroy(hDlg);
                 TerminateThread(hThreadC,0);
                 PostQuitMessage(0);
                 return 0;
 } 
 return DefDlgProc(hDlg,message,wParam,lParam);
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  Создание приложения
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
 hInst = hInstance; 
 hWnd = CreateDialog(hInst,MAKEINTRESOURCE(ID_AT90USB1287_JTAG_PROGRAMMER),NULL,NULL); 
 if (!hWnd) return FALSE;
 Prog_ini_variable(hWnd, hInst);
 hThreadC = CreateThread(NULL,NULL,(LPTHREAD_START_ROUTINE)Prog_processing,hWnd,NULL,&IDThread);
 ShowWindow(hWnd, nCmdShow);
 UpdateWindow(hWnd);
 
 return TRUE;
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  Регистрация приложения
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASS wcex;

	memset(&wcex,0,sizeof(WNDCLASS)); 

	wcex.style			= NULL;
	wcex.lpfnWndProc	= (WNDPROC)DlgProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= DLGWINDOWEXTRA;
	wcex.hInstance		= hInstance;
	wcex.hIcon		    = LoadIcon(hInstance, (LPCTSTR)IDI_ICON1);
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= NULL;
	wcex.lpszMenuName	= (LPCSTR)NULL;
	wcex.lpszClassName	= (LPCSTR)szClassName;

	return RegisterClass(&wcex);
}
//-----------------------------------------------------------------------------------------------------------------------
// описание:  Входная точка в приложение
// параметры:    нет
// возвращаемое  значение:  нет
//-------------------------------------------------------------------------------------------------------------------------
int WINAPI WinMain(HINSTANCE hInstance,HINSTANCE hPrevInstance,LPSTR lpCmdLine,int nCmdShow)
{
  MSG msg;

  MyRegisterClass(hInstance);
  if (!InitInstance (hInstance, nCmdShow)) return FALSE;
  while (GetMessage(&msg, NULL, 0, 0)) 
  {
   if((hWnd ==0)||(!IsDialogMessage(hWnd,&msg))) DispatchMessage(&msg);
  }
 return msg.wParam;
}

