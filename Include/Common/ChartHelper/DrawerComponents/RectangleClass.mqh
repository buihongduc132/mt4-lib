//+------------------------------------------------------------------+
//|                                               RectangleClass.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include "_CommonObjectClass.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RectangleClass : public CommonObjectClass
  {
protected:
   void ChangeRectangleEmptyPoints(datetime &time1,double &price1,
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
      //--- if the second point's price is not set, move it 300 points lower than the first one
      if(!price2)
         price2=price1-300*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
     }
   //+------------------------------------------------------------------+

public:
                    ~RectangleClass() {};
   RectangleClass *NewObject()
     {
      RectangleClass *newObject=new RectangleClass(ModuleName,chartId);
      newObject.isIndividual=true;

      return newObject;
     }
                     RectangleClass(string _parentName,long _chartId): CommonObjectClass(_parentName,_chartId)
     {

     };

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

   RectangleClass *Create(datetime              time1=0,// first point time
                          double                price1=0,          // first point price
                          datetime              time2=0,           // second point time
                          double                price2=0,          // second point price
                          const int             sub_window=0,      // subwindow index 
                          const color           clr=clrRed,        // rectangle color
                          const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines
                          const int             width=1,           // width of rectangle lines
                          const bool            fill=true,// filling rectangle with color
                          const bool            back=true,// in the background
                          const bool            selection=false,// highlight to move
                          const bool            hidden=true,       // hidden in the object list
                          const long            z_order=0)         // priority for mouse click
     {
      //--- set anchor points' coordinates if they are not set
      ChangeRectangleEmptyPoints(time1,price1,time2,price2);
      //--- reset the error value
      ResetLastError();
      string name=GenerateName(time1*time2,price1*price2,"RECTANGLE");
      long chart_ID=chartId;
      //--- create a rectangle by the given coordinates
      if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
        {
         Print(__FUNCTION__,
               ": failed to create a rectangle! Error code = ",GetLastError());
         return(NULL);
        }
      RemoveOldObject();

      objectName=name;
      //--- set rectangle color
      ObjectSetInteger(chart_ID,objectName,OBJPROP_COLOR,clr);
      //--- set the style of rectangle lines
      ObjectSetInteger(chart_ID,objectName,OBJPROP_STYLE,style);
      //--- set width of the rectangle lines
      ObjectSetInteger(chart_ID,objectName,OBJPROP_WIDTH,width);
      //--- enable (true) or disable (false) the mode of filling the rectangle
      ObjectSetInteger(chart_ID,objectName,OBJPROP_FILL,fill);
      //--- display in the foreground (false) or background (true)
      ObjectSetInteger(chart_ID,objectName,OBJPROP_BACK,back);
      //--- enable (true) or disable (false) the mode of highlighting the rectangle for moving
      //--- when creating a graphical object using ObjectCreate function, the object cannot be
      //--- highlighted and moved by default. Inside this method, selection parameter
      //--- is true by default making it possible to highlight and move the object
      ObjectSetInteger(chart_ID,objectName,OBJPROP_SELECTABLE,selection);
      ObjectSetInteger(chart_ID,objectName,OBJPROP_SELECTED,selection);
      //--- hide (true) or display (false) graphical object name in the object list
      ObjectSetInteger(chart_ID,objectName,OBJPROP_HIDDEN,hidden);
      //--- set the priority for receiving the event of a mouse click in the chart
      ObjectSetInteger(chart_ID,objectName,OBJPROP_ZORDER,z_order);
      //--- successful execution
      return GetPointer(this);
     }
   //+------------------------------------------------------------------+

  };
//+------------------------------------------------------------------+
