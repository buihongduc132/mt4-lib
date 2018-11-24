//+------------------------------------------------------------------+
//|                                                         aaaa.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        https://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link "https://www.metaquotes.net"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Drawer

  {
protected:
   string            ModuleName;
   long              chartId;

   int               objectId;
   void              ChangeTextEmptyPoint(datetime &time,double &price);
   void              ChangeRectangleEmptyPoints(datetime &time1,double &price1,
                                                datetime &time2,double &price2);
   string            GetName(datetime time,double price,string type);
public:
   void              Drawer();
   void ~Drawer()
     {
     };
   void              Drawer(long chartId,string parentModuleName);
   void              ClearAll();
   void              ClearAll(string parentModuleName);
   bool              TextCreate(datetime time,                                  // anchor point time
                                double price,                                   // anchor point price
                                const string text,// font
                                const long chart_ID,// chart's ID
                                const int sub_window,// subwindow index
                                const color clr,// color
                                const double angle,// text slope
                                const int font_size,// font size
                                const ENUM_ANCHOR_POINT anchor,// anchor type
                                const bool back,                            // in the background
                                const bool selection,                       // highlight to move
                                const bool hidden,// hidden in the object list
                                const long z_order);
   bool              ArrowCreate(datetime time,
                                 double price,
                                 ENUM_ORDER_TYPE signalDirection,
                                 const long chart_ID,// chart's ID
                                 const int sub_window,// subwindow index
                                 // anchor point time
                                 int width);
   bool              SignalCreate(datetime time,
                                  double price,
                                  const long chart_ID,// chart's ID
                                  const int sub_window,// subwindow index
                                  int width,
                                  color signalColor);
   bool              SignalCreate(datetime time,
                                  double price,
                                  ENUM_ARROW_ANCHOR anchor,
                                  const long chart_ID,// chart's ID
                                  const int sub_window,// subwindow index
                                  int width,
                                  color signalColor);
   bool              ArrowCreate(int index,ENUM_ORDER_TYPE signalDirection);

   bool              TrendCreate(
                                 datetime              time1,           // first point time
                                 double                price1,          // first point price
                                 datetime              time2,           // second point time
                                 double                price2,          // second point price
                                 const int             sub_window,      // subwindow index
                                 const color           clr,// line color
                                 const ENUM_LINE_STYLE style,// line style
                                 const int             width,// line width
                                 const bool            back,// in the background
                                 const bool            selection,// highlight to move
                                 const bool            ray_right,// line's continuation to the right
                                 const bool            hidden,// hidden in the object list
                                 const long            z_order); // priority for mouse click

   string            LabelCreate(const int               x,// X coordinate
                                 const int               y,// Y coordinate
                                 const string            text,// text
                                 const color             clr,// color
                                 const int               sub_window,// subwindow index
                                 const ENUM_BASE_CORNER  corner,// chart corner for anchoring
                                 const string            font,// font
                                 const int               font_size,// font size
                                 const double            angle,// text slope
                                 const ENUM_ANCHOR_POINT anchor,// anchor type
                                 const bool              back,               // in the background
                                 const bool              selection,          // highlight to move
                                 const bool              hidden,// hidden in the object list
                                 const long              z_order);               // priority for mouse click

   string            RectangleCreate(datetime              time1,// first point time
                                     double                price1,          // first point price
                                     datetime              time2,           // second point time
                                     double                price2,          // second point price
                                     const int             sub_window,      // subwindow index 
                                     const color           clr,// rectangle color
                                     const ENUM_LINE_STYLE style,// style of rectangle lines
                                     const int             width,// width of rectangle lines
                                     const bool            fill,        // filling rectangle with color
                                     const bool            back,        // in the background
                                     const bool            selection,    // highlight to move
                                     const bool            hidden,       // hidden in the object list
                                     const long            z_order);

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Drawer::Drawer()
  {
   ModuleName="DrawerClass";
   objectId=0;
   chartId = 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Drawer::Drawer(long _chartId,string parentModuleName)
  {
   ModuleName="DC"+parentModuleName;
   objectId=0;
   chartId = _chartId;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Drawer::ClearAll(string parentModuleName)
  {
   int obj_total=ObjectsTotal();
   for(int i=obj_total-1; i>=0; i--)
     {
      string label=ObjectName(i);

      int labelIndex=StringFind(label,parentModuleName);

      if(labelIndex==0)
        {
         ObjectDelete(label);
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Drawer::ClearAll()
  {
   this.ClearAll(ModuleName);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Drawer::GetName(datetime time,double price,string type="NONE")
  {
//--- set anchor point coordinates if they are not set
   ChangeTextEmptyPoint(time,price);
   string name=StringSubstr(StringFormat("%s%s (X%s)(Y%.3f) %d%d%d",ModuleName,type,TimeToStr(time),price,rand(),rand(),rand()),0,63);

   return name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Drawer::TextCreate(datetime time = 0,                                  // anchor point time
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
   string name=this.GetName(time,price,"Text");

//--- reset the error value
   ResetLastError();
//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_TEXT,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create \"Text\" object! Error code = ",GetLastError());
      return (false);
     }
   objectId++;
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
   return (true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

bool Drawer::ArrowCreate(int index,ENUM_ORDER_TYPE signalDirection)
  {
   double price;

   if(signalDirection==OP_BUY)
      price=Low[index];
   else
      price=High[index];

   return this.ArrowCreate(Time[index], price, signalDirection);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Drawer::ArrowCreate(datetime time,// anchor point time
                         double price,
                         ENUM_ORDER_TYPE signalDirection=EMPTY,
                         const long chart_ID=0,// chart's ID
                         const int sub_window=0,// subwindow index
                         int width=2)
  {
//--- set anchor point coordinates if they are not set
   string name=this.GetName(time,price,"Arrow-"+EnumToString(signalDirection));

//--- reset the error value
   ResetLastError();

   int finalIcon=EMPTY;
   color finalColor=EMPTY;
   ENUM_ARROW_ANCHOR anchorPosition=ANCHOR_TOP; // anchor type

   if(signalDirection==OP_BUY)
     {
      finalIcon=233;
      finalColor=clrCyan;
      anchorPosition=ANCHOR_TOP;
     }
   else if(signalDirection==OP_SELL)
     {
      finalIcon=234;
      finalColor=clrLimeGreen;
      anchorPosition=ANCHOR_BOTTOM;
     }

//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return (false);
     }
//--- set the arrow's size
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- set the arrow color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,finalColor);
//--- set the arrow code
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,finalIcon);
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchorPosition);
   objectId++;
//--- successful execution
   return (true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Drawer::SignalCreate(datetime time,// anchor point time
                          double price,
                          const long chart_ID=0,// chart's ID
                          const int sub_window=0,// subwindow index
                          int width=5,
                          color signalColor=clrCyan)
  {
//--- set anchor point coordinates if they are not set
   string name=this.GetName(time,price,"Signal");

//--- reset the error value
   ResetLastError();

   int finalIcon=158;
   color finalColor=signalColor;
//ENUM_ARROW_ANCHOR anchorPosition=ANCHOR_TOP; // anchor type

//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return (false);
     }
//--- set the arrow's size
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- set the arrow color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,finalColor);
//--- set the arrow code
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,finalIcon);
//--- set anchor type
//ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchorPosition);
   objectId++;
//--- successful execution
   return (true);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool Drawer::SignalCreate(datetime time,// anchor point time
                          double price,
                          ENUM_ARROW_ANCHOR anchor,
                          const long chart_ID=0,// chart's ID
                          const int sub_window=0,// subwindow index
                          int width=5,
                          color signalColor=clrCyan)
  {
//--- set anchor point coordinates if they are not set
   string name=this.GetName(time,price,"Signal");

//--- reset the error value
   ResetLastError();

   int finalIcon=158;
   color finalColor=signalColor;
//ENUM_ARROW_ANCHOR anchorPosition=ANCHOR_TOP; // anchor type

//--- create Text object
   if(!ObjectCreate(chart_ID,name,OBJ_ARROW,sub_window,time,price))
     {
      Print(__FUNCTION__,
            ": failed to create an arrow! Error code = ",GetLastError());
      return (false);
     }
//--- set anchor type
   ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchor);
//--- set the arrow's size
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- set the arrow color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,finalColor);
//--- set the arrow code
   ObjectSetInteger(chart_ID,name,OBJPROP_ARROWCODE,finalIcon);
//--- set anchor type
//ObjectSetInteger(chart_ID,name,OBJPROP_ANCHOR,anchorPosition);
   objectId++;
//--- successful execution
   return (true);
  }
//+------------------------------------------------------------------+

void Drawer::ChangeTextEmptyPoint(datetime &time,double &price)
  {
//--- if the point's time is not set, it will be on the current bar
   if(!time)
      time=TimeCurrent();
//--- if the point's price is not set, it will have Bid value
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
  }
//+------------------------------------------------------------------+

bool Drawer::TrendCreate(
                         datetime              time1=0,           // first point time
                         double                price1=0,          // first point price
                         datetime              time2=0,           // second point time
                         double                price2=0,          // second point price
                         const int             sub_window=0,// subwindow index
                         const color           clr=clrCyan,// line color
                         const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                         const int             width=2,           // line width
                         const bool            back=true,// in the background
                         const bool            selection=false,// highlight to move
                         const bool            ray_right=false,   // line's continuation to the right
                         const bool            hidden=true,       // hidden in the object list
                         const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeTrendEmptyPoints(time1,price1,time2,price2);
   string name=this.GetName(time1*time2,price1*price2,"TRENDLINE");
//--- reset the error value
   ResetLastError();
//--- create a trend line by the given coordinates
   long chart_ID=chartId;
   if(!ObjectCreate(chart_ID,name,OBJ_TREND,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a trend line! Error code = ",GetLastError());
      return(false);
     }
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
   return(true);
  }
//+------------------------------------------------------------------+
//| Move trend line anchor point                                     |
//+------------------------------------------------------------------+
bool TrendPointChange(const long   chart_ID=0,       // chart's ID
                      const string name="TrendLine", // line name
                      const int    point_index=0,    // anchor point index
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
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| The function deletes the trend line from the chart.              |
//+------------------------------------------------------------------+
bool TrendDelete(const long   chart_ID=0,       // chart's ID
                 const string name="TrendLine") // line name
  {
//--- reset the error value
   ResetLastError();
//--- delete a trend line
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a trend line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check the values of trend line's anchor points and set default   |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
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

string Drawer::LabelCreate(
                           const int               x=0,                      // X coordinate
                           const int               y=0,                      // Y coordinate
                           const string            text="Testing Label",// text
                           const color             clr=clrCyan,// color
                           const int               sub_window=0,             // subwindow index
                           const ENUM_BASE_CORNER  corner=CORNER_LEFT_UPPER, // chart corner for anchoring
                           const string            font="Arial",             // font
                           const int               font_size=10,             // font size
                           const double            angle=0.0,                // text slope
                           const ENUM_ANCHOR_POINT anchor=ANCHOR_LEFT_UPPER, // anchor type
                           const bool              back=false,               // in the background
                           const bool              selection=false,          // highlight to move
                           const bool              hidden=true,              // hidden in the object list
                           const long              z_order=0)                // priority for mouse click
  {
//--- reset the error value
   ResetLastError();
   string name=this.GetName(x,y,"Label");
//--- create a text label
   long chart_ID=chartId;
   if(!ObjectCreate(chart_ID,name,OBJ_LABEL,sub_window,0,0))
     {
      int lastError=GetLastError();
      switch(lastError)
        {
         case 4200:
           {
            Print(__FUNCTION__,": failed to create label name: ",name);
            break;
           }
         default:
           {
            Print(__FUNCTION__,
                  ": failed to create text label! Error code = ",lastError);
            break;
           }
        }

      return "";
     }
//--- set label coordinates
   ObjectSetInteger(chart_ID,name,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(chart_ID,name,OBJPROP_YDISTANCE,y);
//--- set the chart's corner, relative to which point coordinates are defined
   ObjectSetInteger(chart_ID,name,OBJPROP_CORNER,corner);
//--- set the text
   ObjectSetString(chart_ID,name,OBJPROP_TEXT,text);
//--- set text font
   ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
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
//--- enable (true) or disable (false) the mode of moving the label by mouse
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return name;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Drawer::RectangleCreate(datetime              time1=0,// first point time
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
   string name=this.GetName(time1*time2,price1*price2,"RECTANGLE");
   long chart_ID=chartId;
//--- create a rectangle by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(NULL);
     }
//--- set rectangle color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the style of rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set width of the rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- enable (true) or disable (false) the mode of filling the rectangle
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the rectangle for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return name;
  }
//+------------------------------------------------------------------+
void Drawer::ChangeRectangleEmptyPoints(datetime &time1,double &price1,
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
