//+------------------------------------------------------------------+
//|                                                    LineClass.mqh |
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

#include "_CommonObjectClass.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class LabelClass : public CommonObjectClass
  {
protected:

   void ChangeTrendEmptyPoints(datetime &time1,double &price1,
                               datetime &time2,double &price2)
     {
      //--- if the first point's time is not set, it will be on the current bar
      if(!time1)
         time1=TimeCurrent();
      //--- if the first point's price is not set, it will have Bid value
      if(!price1)
         price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      //--- if the second point's time is not set, it is located 9 bars left from the second one
      if(!time2)
        {
         //--- array for receiving the open time of the last 10 bars
         datetime temp[10];
         CopyTime(Symbol(),Period(),time1,10,temp);
         //--- set the second point 9 bars left from the first one
         time2=temp[0];
        }
      //--- if the second point's price is not set, it is equal to the first point's one
      if(!price2)
         price2=price1;
     }
   //+------------------------------------------------------------------+

public:
                    ~LabelClass(){};
   LabelClass *NewObject()
     {
      LabelClass *newObject=new LabelClass(ModuleName,chartId);
      newObject.isIndividual=true;

      return newObject;
     }
                     LabelClass(string _parentName,long _chartId): CommonObjectClass(_parentName,_chartId)
     {

     };

   LabelClass *Create(datetime time=0,// anchor point time
                      double price = 0,                                   // anchor point price
                      const string text = "Text",                         // font
                      const long chart_ID=0,// chart's ID
                      const int sub_window = 0,                           // subwindow index
                      const color clr = clrRed,                           // color
                      const double angle=90,// text slope
                      const int font_size = 10,                           // font size
                      const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                      const bool back = false,                            // in the background
                      const bool selection = false,                       // highlight to move
                      const bool hidden = true,                           // hidden in the object list
                      const long z_order = 0)                             // priority for mouse click
     {
      string name=GenerateName(time,price,"Text");

      //--- reset the error value
      ResetLastError();
      //--- create Text object
      if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,time,price))
        {
         Print(__FUNCTION__,
               ": failed to create \"Label\" object! Error code = ",GetLastError());
         return NULL;
        }
      objectName=name;
      //--- set the text
      ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
      //--- set text font
      //ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
      //--- set font size
      ObjectSetInteger(chart_ID,name,OBJPROP_FONTSIZE,font_size);
      //--- set the slope angle of the text
      ObjectSetDouble(chart_ID,name,OBJPROP_ANGLE,angle);
      //--- set anchor type
      ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
      //--- set color
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      //--- enable (true) or disable (false) the mode of moving the object by mouse
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
      //--- successful execution
      return GetPointer(this);
     }

   bool PointChange(const int    point_index=0,// anchor point index
                    datetime     time=0,           // anchor point time coordinate
                    double       price=0)          // anchor point price coordinate
     {
      //--- if point position is not set, move it to the current bar having Bid price
      if(!time)
         time=TimeCurrent();
      if(!price)
         price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
      //--- reset the error value
      ResetLastError();
      //--- move trend line's anchor point
      if(!ObjectMove(chartId,objectName,point_index,time,price))
        {
         Print(__FUNCTION__,
               ": failed to move the anchor point! Error code = ",GetLastError());
         return(false);
        }
      //--- successful execution
      return(true);
     }
   //+------------------------------------------------------------------+

  };
//+------------------------------------------------------------------+
