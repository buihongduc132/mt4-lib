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
class GuiLinkClass
  {
protected:
   int               hwnd;

public:
                     GuiLinkClass(int _hwnd) { hwnd=_hwnd; };

   int GuiLinkAdd(int ParentLinkHandle,string Label,string Link)
     {
      return guiLinkAdd(hwnd, ParentLinkHandle, Label, Link);
     }
   int GuiLinkRemove()
     {
      return guiLinkRemove(hwnd);
     }

   static int GuiLinkAdd(int _hwnd,int ParentLinkHandle,string Label,string Link)
     {
      return guiLinkAdd(_hwnd,  ParentLinkHandle,  Label,  Link);
     }
   static int GuiLinkRemove(int _hwnd)
     {
      return guiLinkRemove(_hwnd);
     }
  };
//+------------------------------------------------------------------+
