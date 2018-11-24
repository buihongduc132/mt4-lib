//+------------------------------------------------------------------+
//|                                                         aaaa.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        https://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link "https://www.metaquotes.net"

const string ModuleName = "_Drawer";
int objectId = 0;

bool Drawer_TextCreate(const long chart_ID = 0,                            // chart's ID
                const int sub_window = 0,                           // subwindow index
                datetime time = 0,                                  // anchor point time
                double price = 0,                                   // anchor point price
                const string text = "Text",                         // font
                const int font_size = 10,                           // font size
                const color clr = clrCyan,                           // color
                const double angle = 0.0,                           // text slope
                const ENUM_ANCHOR_POINT anchor = ANCHOR_LEFT_UPPER, // anchor type
                const bool back = false,                            // in the background
                const bool selection = false,                       // highlight to move
                const bool hidden = true,                           // hidden in the object list
                const long z_order = 0)                             // priority for mouse click
{
    string name = _GetName(time, price);

    //--- reset the error value
    ResetLastError();
    //--- create Text object
    if (!ObjectCreate(chart_ID, name, OBJ_TEXT, sub_window, time, price))
    {
        Print(__FUNCTION__,
              ": failed to create \"Text\" object! Error code = ", GetLastError());
        return (false);
    }
    objectId++;
    //--- set the text
    ObjectSetString(chart_ID, name, OBJPROP_TEXT, text);
    //--- set text font
    //ObjectSetString(chart_ID,name,OBJPROP_FONT,font);
    //--- set font size
    ObjectSetInteger(chart_ID, name, OBJPROP_FONTSIZE, font_size);
    //--- set the slope angle of the text
    ObjectSetDouble(chart_ID, name, OBJPROP_ANGLE, 90);
    //--- set anchor type
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchor);
    //--- set color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, clr);
    //--- display in the foreground (false) or background (true)
    ObjectSetInteger(chart_ID, name, OBJPROP_BACK, back);
    //--- enable (true) or disable (false) the mode of moving the object by mouse
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTABLE, selection);
    ObjectSetInteger(chart_ID, name, OBJPROP_SELECTED, selection);
    //--- hide (true) or display (false) graphical object name in the object list
    ObjectSetInteger(chart_ID, name, OBJPROP_HIDDEN, hidden);
    //--- set the priority for receiving the event of a mouse click in the chart
    ObjectSetInteger(chart_ID, name, OBJPROP_ZORDER, z_order);
    //--- successful execution
    return (true);
}

string _GetName(datetime time, double price)
{
    //--- set anchor point coordinates if they are not set
    ChangeTextEmptyPoint(time, price);
    return StringFormat("%s-%d-%f-%f",ModuleName,objectId,time,price);
}

void ChangeTextEmptyPoint(datetime &time, double &price)
{
    //--- if the point's time is not set, it will be on the current bar
    if (!time)
        time = TimeCurrent();
    //--- if the point's price is not set, it will have Bid value
    if (!price)
        price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
}
//+------------------------------------------------------------------+

bool Drawer_ArrowCreate(const long chart_ID = 0,  // chart's ID
                 const int sub_window = 0, // subwindow index
                 datetime time = 0,        // anchor point time
                 double price = 0,
                 ENUM_ORDER_TYPE signalDirection = EMPTY,
                 int width = 5)
{
    //--- set anchor point coordinates if they are not set
    string name = _GetName(time, price);

    //--- reset the error value
    ResetLastError();

    int finalIcon = EMPTY;
    color finalColor = EMPTY;
    ENUM_ARROW_ANCHOR anchorPosition = ANCHOR_TOP; // anchor type

    if (signalDirection == OP_BUY)
    {
        finalIcon = 217;
        finalColor = clrRed;
        anchorPosition = ANCHOR_TOP;
    }
    else if (signalDirection == OP_SELL)
    {
        finalIcon = 218;
        finalColor = clrLimeGreen;
        anchorPosition = ANCHOR_BOTTOM;
    }

    //--- create Text object
    if (!ObjectCreate(chart_ID, name, OBJ_ARROW, sub_window, time, price))
    {
        Print(__FUNCTION__,
              ": failed to create an arrow! Error code = ", GetLastError());
        return (false);
    }
    //--- set the arrow's size
    ObjectSetInteger(chart_ID, name, OBJPROP_WIDTH, width);
    //--- set the arrow color
    ObjectSetInteger(chart_ID, name, OBJPROP_COLOR, finalColor);
    //--- set the arrow code
    ObjectSetInteger(chart_ID, name, OBJPROP_ARROWCODE, finalIcon);
    //--- set anchor type
    ObjectSetInteger(chart_ID, name, OBJPROP_ANCHOR, anchorPosition);
    objectId++;
    //--- successful execution
    return (true);
}