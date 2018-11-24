//+------------------------------------------------------------------+
//|                                               DashboardClass.mqh |
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

#include "DrawerClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class DashboardTextType
  {
public:
                     DashboardTextType()
     {
     };
                     DashboardTextType(string _text,color _textColor)
     {
      text=_text;
      textColor=_textColor;
     };
   string            text;
   color             textColor;
   DashboardTextType *operator=(const DashboardTextType &copy)
     {
      this.text=copy.text;
      this.textColor=copy.textColor;
      return GetPointer(this);
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Dashboard
  {
protected:
   string            moduleName;
   long              chartId;
   int               tablePaddingTop;
   int               tablePaddingLeft;

   int               textPaddingTop;
   int               textPaddingLeft;

   Drawer           *drawer;

   int               columnPos[];
   string            headers[];

public:
   void Dashboard(long _chartId,string parentModuleName,string &_headers[])
     {
      moduleName="Dashboard_"+parentModuleName;
      this.drawer=new Drawer(_chartId,moduleName);

      tablePaddingTop=20;
      tablePaddingLeft=100;

      textPaddingTop=33;
      textPaddingLeft=33;

      SetHeader(_headers);

      this.drawer.ClearAll();
     }

   void ~Dashboard()
     {
      delete drawer;
     }

   void SetHeader(string &_headers[])
     {
      ArrayResize(headers,ArraySize(_headers));
      ArrayCopy(headers,_headers);
     }

   void Clear()
     {
      drawer.ClearAll();
      DrawHeader();
     }

   void DrawHeader()
     {
      ArrayResize(columnPos,ArraySize(headers));

      int y = tablePaddingTop;
      int x = tablePaddingLeft;
      uint w= 0,h = 0;

      for(int i=0; i<ArraySize(headers); i++)
        {
         string header=headers[i];

         drawer.LabelCreate(x,y,header);
         columnPos[i]=x;

         TextGetSize(header,w,h);
         x+=(int)(w+tablePaddingLeft);
        }
     }

   void SetText(const DashboardTextType &textType[],int row)
     {
      for(int i=0; i<ArraySize(textType); i++)
        {
         DrawTextAt(textType[i].text,row,i,textType[i].textColor);
        }
     }

   void SetText(string &text[],int row)
     {
      for(int i=0; i<ArraySize(text); i++)
        {
         DrawTextAt(text[i],row,i);
        }
     }

   void DrawTextAt(string text,int row,int column,color inputColor=clrCyan)
     {
      drawer.LabelCreate(columnPos[column],row*textPaddingTop+tablePaddingTop,text,inputColor);
     }

  };
//+------------------------------------------------------------------+
