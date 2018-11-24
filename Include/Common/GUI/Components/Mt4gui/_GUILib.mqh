//+------------------------------------------------------------------+
//|                                                  _Mt4Library.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
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

#import "mt4gui2.dll"
//~~~~~~ Diverse
string guiVersion();
int guiCleanup(int hwnd);
int guiGetLastError(int hwnd);

//~~~~~ New : Vendor tagging
int guiVendor(string apikey);

//~~~~~~ Main GUI Function
// Type:  "button","checkbox","list","label","text","link","radio","image"
int guiAdd(int hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label); // Done

                                                                                //~~~~~~ MENU FUNCTIONS
int  guiAddMenu(int hwnd,string label,int parentID,int flags); // Flags=1 -> Checkbox // Done
int  guiSetMenuText(int hwnd,int menuHandle,string NewLabel);// Done
int  guiSetMenuTextColor(int hwnd,int menuHandle,int Color);// Done
int  guiSetMenuBgColor(int hwnd,int menuHandle,int Color);// Done
bool guiIsMenuClicked(int hwnd,int menuHandle);// Done
bool guiIsMenuChecked(int hwnd,int menuHandle);// Done
int  guiCheckMenu(int hwnd,int menuHandle,int Status);// Done
int  guiEnableMenu(int hwnd,int menuHandle,int Status);// Done
                                                       //int  guiRemoveMenu(int hwnd,int menuHandle);

//~~~~~~ shortcut --- 
int guiSetShortcut(int hwnd,int ObjectHandle,string Shortcut); // ihwnd,obj,definition "ctrl+a"

                                                               //~~~~~~~ Ticker Functions
int guiTickerStart(int hwnd,int TickPeriod);  // minimum Period: 500
int guiTickerStop(int hwnd,int TickerHandle);   // 

                                                //~~~~~~~ colors for Objects
int guiSetBgColor(int hwnd,int ObjectHandle,int Color);
int guiSetTextColor(int hwnd,int ObjectHandle,int Color);

// New functions for buttons only
int guiSetBorderRadius(int hwnd,int ObjectHandle,int Radius);
int guiSetBorderColor(int hwnd,int ObjectHandle,int BorderColor);
//int guiSetTexts			(int chart, int wnd, int n, string& texts[], int& fontSizes[], string& fontNames[], int& positions[] );   

int guiSetLink(int hwnd,int LinkObjectHandle,string Link);

// removing objects from chart
int guiRemove(int hwnd,int objHandle);
int guiRemoveAll(int hwnd);

// events
bool guiIsClicked(int hwnd,int ObjectHandle);
bool guiIsChecked(int hwnd,int ObjectHandle);

// properties   
int    guiSetText(int hwnd,int ObjectHandle,string NewText,int FontSize,string Fontname);
string guiGetText(int hwnd,int ObjectHandle);
int    guiSetChecked(int hwnd,int ObjectHandle,int State);
int    guiGetWidth(int hwnd,int ObjectHandle);
int    guiGetHeight(int hwnd,int ObjectHandle);
int    guiSetPos(int hwnd,int ObjectHandle,int X,int Y);
int    guiSetSize(int hwnd,int ObjectHandle,int Width,int Height);
int    guiEnable(int hwnd,int ObjectHandle,int State);
bool   guiIsEnabled(int hwnd,int ObjectHandle);
int    guiAppendTextPart(int hwnd,int ObjectHandle,string Text,int FontSize,string FontName,int Position);

// listbox 
int guiAddListItem(int hwnd,int ListObjectHandle,string ItemToAdd);
int guiGetListSel(int hwnd,int ListObjectHandle);
int guiSetListSel(int hwnd,int ListObjectHandle,int ItemIndex);
int guiRemoveListItem(int hwnd,int ListObjectHandle,int ItemIndex);
int guiRemoveListAll(int hwnd,int ListObjectHandle);

// obj management
int guiSetName(int hwnd,int ObjectHandle,string NameOfObject); // ihwnd,object,name
string guiGetName(int hwnd,int ObjectHandle); // ihwnd,object
int guiGroupRadio(int hwnd);

// Enumeration Functions - Advanced Levels
int guiObjectsCount(int hwnd);
int guiGetByNum(int hwnd,int Index);
int guiGetByName(int hwnd,string Alias);
int guiGetType(int hwnd,int ObjectHandle);
int guiSetName(int hwnd,int ObjectHandle,string Alias);
string guiGetName(int hwnd,int ObjectHandle);

// Link Functions
int guiLinkAdd(int hwnd,int ParentLinkHandle,string Label,string Link);
int guiLinkRemove(int hwnd);

// Other Helper Functions
int guiFocusChart(int hwnd);
int guiCloseTerminal();
int guiMinimizeTerminal();
int guiMaximizeTerminal();
int guiCloseChart(int hwnd);
int guiChangeSymbol(int hwnd,string SymbolAndTimeFrame);
string guiMD5(string Content);
int guiOpenBrowser(string url);
int guiTimeGMT();
string guiCID();
int guiCRC32(string Content);
int guiTimeHTTPGMT(string url);
int guiGetChartWidth(int hwnd);
int guiGetChartHeight(int hwnd);
int guiGetFocusedChart();
#import
//+------------------------------------------------------------------+
