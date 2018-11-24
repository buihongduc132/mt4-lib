//+------------------------------------------------------------------+
//|                                                TerminalClass.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+

#include "_GUILib.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GuiTerminalClass
{
protected:
  int hwnd;

public:
  GuiTerminalClass(int _hwnd) { hwnd = _hwnd; };

  int GuiFocusChart() { return guiFocusChart(hwnd); };
  int GuiCloseChart() { return guiCloseChart(hwnd); };
  int GuiGetChartWidth() { return guiGetChartWidth(hwnd); };
  int GuiGetChartHeight() { return guiGetChartHeight(hwnd); };
  int GuiChangeSymbol(string SymbolAndTimeFrame) { return guiChangeSymbol(hwnd, SymbolAndTimeFrame); };

  static int GuiFocusChart(int _hwnd) { return guiFocusChart(_hwnd); };
  static int GuiCloseChart(int _hwnd) { return guiCloseChart(_hwnd); };
  static int GuiGetChartWidth(int _hwnd) { return guiGetChartWidth(_hwnd); };
  static int GuiGetChartHeight(int _hwnd) { return guiGetChartHeight(_hwnd); };
  static int GuiChangeSymbol(int _hwnd, string SymbolAndTimeFrame) { return guiChangeSymbol(_hwnd, SymbolAndTimeFrame); };

  static int GuiCloseTerminal() { return guiCloseTerminal(); };
  static int GuiMinimizeTerminal() { return guiMinimizeTerminal(); };
  static int GuiMaximizeTerminal() { return guiMaximizeTerminal(); };
  static int GuiOpenBrowser(string url) { return guiOpenBrowser(url); };
  static int GuiTimeGMT() { return guiTimeGMT(); };
  static string GuiCID() { return guiCID(); };
  static int GuiGetFocusedChart() { return guiGetFocusedChart(); };
};
//+------------------------------------------------------------------+