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
class LineClass : public CommonObjectClass
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
                    ~LineClass(){};
   datetime Time1()
     {
      return (datetime)ObjectGet(objectName, OBJPROP_TIME1);
     }
   datetime Time2()
     {
      return (datetime)ObjectGet(objectName, OBJPROP_TIME2);
     }

   datetime StartTime()
     {
      return MathMin(Time1(), Time2());
     }

   datetime EndTime()
     {
      return MathMax(Time1(), Time2());
     }

   double Price1()
     {
      return ObjectGet(objectName, OBJPROP_PRICE1);
     }

   double Price2()
     {
      return ObjectGet(objectName, OBJPROP_PRICE2);
     }

   double LowPrice()
     {
      return MathMin(Price1(), Price2());
     }

   double HighPrice()
     {
      return MathMax(Price1(), Price2());
     }

   datetime Duration()
     {
      return MathAbs(Time1() - Time2());
     }

   double PriceRange()
     {
      return MathAbs(Price1() - Price2());
     }

   LineClass *NewObject()
     {
      LineClass *newObject=new LineClass(ModuleName,chartId);
      newObject.isIndividual=true;

      return newObject;
     }
                     LineClass(string _parentName,long _chartId): CommonObjectClass(_parentName,_chartId) {};
   LineClass *Create(datetime              time1=0,// first point time
                     double                price1=0,// first point price
                     datetime              time2=EMPTY_VALUE,           // second point time
                     double                price2=EMPTY_VALUE,          // second point price
                     const int             sub_window=0,// subwindow index
                     const color           clr=clrRed,        // line color
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                     const int             width=1,           // line width
                     const bool            back=false,        // in the background
                     const bool            selection=true,    // highlight to move
                     const bool            ray_right=false,   // line's continuation to the right
                     const bool            hidden=true,       // hidden in the object list
                     const long            z_order=0)         // priority for mouse click
     {
      if(time2==EMPTY_VALUE && price2==EMPTY_VALUE)
        {
         return NULL;
        }
      if(time2 == EMPTY_VALUE)
         time2 = time1;
      if(price2 == EMPTY_VALUE)
         price2 = price1;

      //--- set anchor points' coordinates if they are not set
      ChangeTrendEmptyPoints(time1,price1,time2,price2);
      string name=GenerateName(time1,price1,time2,price2,"LINE");
      long chart_ID=chartId;
      //--- reset the error value
      ResetLastError();
      //--- create a trend line by the given coordinates
      if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
        {
         Print(__FUNCTION__,
               ": failed to create a trend line! Error code = ",GetLastError());
         return NULL;
        }

      RemoveOldObject();

      objectName=name;
      //--- set line color
      ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
      //--- set line display style
      ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
      //--- set line width
      ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
      //--- enable (true) or disable (false) the mode of moving the line by mouse
      //--- when creating a graphical object using ObjectCreate function, the object cannot be
      //--- highlighted and moved by default. Inside this method, selection parameter
      //--- is true by default making it possible to highlight and move the object
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
      //--- enable (true) or disable (false) the mode of continuation of the line's display to the right
      ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
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
