//+------------------------------------------------------------------+
//|                                           DashboardListClass.mqh |
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

struct ColNames
  {
   string            rowNames[];
  };

#include "DrawerClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class DashboardList
  {
protected:
   string            moduleName;
   long              chartId;

   Drawer           *drawer;

   int               columnPos[];
   int               rowPos[];

   int               rows;
   int               cols;
   ColNames          listNames[];

   int               tablePaddingTop;
   int               tablePaddingLeft;

   int               textPaddingTop;
   int               textPaddingLeft;

   int               offsetLeft;
   int               offsetTop;
public:
   void              DashboardList(long chartId,string parentModuleName,int cols,int rows,
                                   int tablePaddingLeft,int tablePaddingTop,
                                   int textPaddingLeft,int textPaddingTop);
   string            CreateLabel(int col,int row,string text,int offset,color clr,int sub_window,
                                 ENUM_BASE_CORNER corner,string font,int size,double angle,ENUM_ANCHOR_POINT anchor);

   void              SetText(int col,int row,string text);
   void              SetColor(int col,int row,color clr);
   void              MoveLabel(int col,int row,int x,int y);

   void              SetTextPadding(int left,int top);
   void              SetTablePadding(int left,int top);
   void              SetOffset(int left,int top);
   void              SetTableSize(int cols,int rows);
   void              SetTableMargins();

   string            GetLabelName(int col,int row);
   string            GetLabelText(int col,int row);

   void              Clear();
   void              ~DashboardList()
     {
      delete drawer;

      //listNames[0].rowNames[0]=NULL;
     }
  };
//+------------------------------------------------------------------+

void DashboardList::SetTableSize(int _cols,int _rows)
  {
   rows=_rows;
   cols= _cols;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DashboardList::SetOffset(int left,int top)
  {
   offsetLeft= left;
   offsetTop = top;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DashboardList::SetTextPadding(int left,int top)
  {
   tablePaddingLeft= left;
   tablePaddingTop = top;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DashboardList::SetTablePadding(int left,int top)
  {
   textPaddingLeft= left;
   textPaddingTop = top;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DashboardList::SetTableMargins()
  {

   for(int j=0; j<this.rows; j++)
     {
      this.MoveLabel(0,j,tablePaddingLeft);
     }

   for(int i=0; i<this.cols-1; i++)
     {
      double maxTextLength=0;

      int textLength= 0;
      int textSizeH = 0;
      for(int j=0; j<this.rows; j++)
        {
         TextGetSize(GetLabelText(i,j),textLength,textSizeH);
         maxTextLength=MathMax(maxTextLength,textLength);
        }

      columnPos[i+1]=(int)(columnPos[i]+maxTextLength+textPaddingLeft+offsetLeft);

      for(int j=0; j<this.rows; j++)
        {
         this.MoveLabel(i+1,j,columnPos[i+1]);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DashboardList::DashboardList(long _chartId,string parentModuleName,int _cols,int _rows,int _tablePaddingLeft=0,int _tablePaddingTop=0,int _textPaddingLeft=0,int _textPaddingTop=0)
  {
   moduleName="DBL_"+parentModuleName;

   this.drawer=new Drawer(_chartId,moduleName);
   Clear();

   tablePaddingTop=_tablePaddingTop;
   tablePaddingLeft=_tablePaddingLeft;

   textPaddingTop=_textPaddingTop;
   textPaddingLeft=_textPaddingLeft;

   rows = _rows;
   cols = _cols;

   ArrayResize(this.columnPos,_cols);
   ArrayResize(this.rowPos, _rows);
   ArrayResize(listNames,cols);

   for(int i=0; i<_cols;i++)
     {
      ArrayResize(listNames[i].rowNames,rows);
      columnPos[i]=tablePaddingLeft+i*textPaddingLeft;
     }

   for(int j=0; j<_rows; j++)
     {
      rowPos[j]=tablePaddingTop+j*textPaddingTop;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void DashboardList::Clear()
  {
// Select item to clear;
//drawer.ClearAll();
   ObjectsDeleteAll(chartId);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

string DashboardList::CreateLabel(int col,int row,string text,int offset=0,color clr=clrCyan,int sub_window=0,
                                  ENUM_BASE_CORNER corner=CORNER_LEFT_UPPER,string font="Arial",int size=10,double angle=0.0,ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER)

  {
   string createdLabel=drawer.LabelCreate(columnPos[col],rowPos[row],text,clr,sub_window,corner,font,size,angle,anchor);

   listNames[col].rowNames[row]=createdLabel;

   return listNames[col].rowNames[row];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

string DashboardList::GetLabelName(int col,int row)
  {
   return this.listNames[col].rowNames[row];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

string DashboardList::GetLabelText(int col,int row)
  {
   return ObjectGetString(chartId,GetLabelName(col,row),OBJPROP_TEXT);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

void DashboardList::SetText(int col,int row,string text)
  {
   ObjectSetString(chartId,GetLabelName(col,row),OBJPROP_TEXT,text);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

void DashboardList::SetColor(int col,int row,color clr)
  {
   ObjectSetInteger(chartId,GetLabelName(col,row),OBJPROP_COLOR,clr);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

void DashboardList::MoveLabel(int col,int row,int x,int y=EMPTY_VALUE)
  {
   if(y!=EMPTY_VALUE)
      ObjectSetInteger(chartId,GetLabelName(col,row),OBJPROP_YDISTANCE,y);

   ObjectSetInteger(chartId,GetLabelName(col,row),OBJPROP_XDISTANCE,x);
  }
//+------------------------------------------------------------------+
