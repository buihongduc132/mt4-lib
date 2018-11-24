//+------------------------------------------------------------------+
//|                                             OrderHelperClass.mqh |
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
#include <Common/MessageHelper/MessageHelperClass.mqh>;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ORDER_STATUS_CODE
  {
   _ORDER_STATUS_CODE_INVALID_COMMAND=-9993,
   _ORDER_STATUS_CODE_INVALID_TRAILING_MODE=-9996,
   _ORDER_STATUS_CODE_NOT_OPENED=-9997,
   _ORDER_STATUS_CODE_NOT_FOUND=-9994,

   _ORDER_STATUS_CODE_PREPARING=0,
   _ORDER_STATUS_CODE_SUCCESS=1,
   _ORDER_STATUS_CODE_OPEN_FAILED=-9992,

   _ORDER_STATUS_CODE_SL_NOT_CHANGED=-9991,

   _ORDER_STATUS_CODE_OPENED=2,

   _ORDER_STATUS_CODE_OTHERS=-9996,
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderClass
  {
protected:

   int               _slippage;
   string            _moduleName;
   color             _arrowColor;

   double            _trailingSlTrigger;
   double            _trailingSlRange;

   datetime          _expiration;

   double            GetCurrentPrice();
   void              InitInfo();

   string            _ProcessCommentAnnotations(double entry,double sl,double tp);

public:
   int               _side;
   int               _magicNumber;
   int               _orderId;
   string            _symbol;
   string            _comment;
   double            _sl;
   double            _tp;
   double            _price;
   double            _entry;
   ENUM_ORDER_TYPE   _orderCommand;
   double            _volume;
   int               _status;

   void              OrderClass(string symbol,int magic,string comment,int slippage);
   void              OrderClass(int index,int select,int pool);
   void              OrderClass() {};
   void ~OrderClass(){};

   OrderClass       *OpenOrder(ENUM_ORDER_TYPE cmd,double volume,double sl,double tp,datetime expiration);
   OrderClass       *OpenOrder(ENUM_ORDER_TYPE cmd,double volume,double price,double sl,double tp,datetime expiration);

   void              SetTrailingStop(double trailingSlRange,double trailingSlTrigger);

   void              ModifyComment(string comment);
   int               ModifyTrailingSl();
   int               ModifyTrailingSl(double newSl);

   int               CheckOrderStatus();
   int               GetOrderType();

   static double     GetCurrentPrice(ENUM_ORDER_TYPE orderCommand);
   static double     GetExitPrice(ENUM_ORDER_TYPE orderCommand);
   static ENUM_ORDER_TYPE GetPendingOrderType(double targetPrice,int side);
   int               CloseOrder();
   int               CloseOpeningOrder();
   int               ClosePendingOrder();
   int               GetOrderSide(ENUM_ORDER_TYPE cmd);

   void              BuildComment(string inputStr) {_comment=inputStr;};

   string GetComment(string property) { return ""; };

   double GetSlRange(double currentPrice=EMPTY) { return (currentPrice == EMPTY ? _entry : currentPrice)-_sl*_side; };
   double GetTpRange(double currentPrice=EMPTY) { return _tp-(currentPrice == EMPTY ? _entry : currentPrice)*_side; };
   double GetRR(double currentPrice=EMPTY) { return GetTpRange(currentPrice)/GetSlRange(currentPrice); };

   void              operator=(OrderClass &that);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::GetOrderSide(ENUM_ORDER_TYPE cmd)
  {
   if(cmd==OP_SELL || cmd==OP_SELLLIMIT || cmd==OP_SELLSTOP)
      return -1;
   else
      return 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderClass::operator=(OrderClass &that)
  {
   this._side=that._side;
   this._magicNumber=that._magicNumber;
   this._orderId= that._orderId;
   this._symbol = that._symbol;
   this._slippage=that._slippage;
   this._moduleName=that._moduleName;
   this._comment=that._comment;
   this._arrowColor=that._arrowColor;
   this._sl = that._sl;
   this._tp = that._tp;

   this._trailingSlTrigger=that._trailingSlTrigger;
   this._trailingSlRange=that._trailingSlRange;

   this._expiration=that._expiration;

   this._orderCommand=that._orderCommand;
   this._volume= that._volume;
   this._price = that._price;
   this._status= that._status;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static ENUM_ORDER_TYPE OrderClass::GetPendingOrderType(double targetPrice,int side)
  {
   ENUM_ORDER_TYPE orderCommand;
   if(side==1)
     {
      if(targetPrice>OrderClass::GetCurrentPrice(OP_BUY))
        {
         orderCommand=OP_BUYSTOP;
        }
      else
        {
         orderCommand=OP_BUYLIMIT;
        }
     }
   else
     {
      if(targetPrice>OrderClass::GetCurrentPrice(OP_SELL))
        {
         orderCommand=OP_SELLLIMIT;
        }
      else
        {
         orderCommand=OP_SELLSTOP;
        }
     }

   return orderCommand;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::GetOrderType()
  {
   if(!OrderSelect(_orderId,SELECT_BY_TICKET))
     {
      _status=_ORDER_STATUS_CODE_NOT_FOUND;
      delete &this;
      return -GetLastError();
     }
   return OrderType();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::CloseOrder()
  {
   int orderType=GetOrderType();
   if(orderType<0)
     {
      return orderType;
     }
   if(orderType==OP_BUY || orderType==OP_SELL)
     {
      return this.CloseOpeningOrder();
     }
   else
     {
      return this.ClosePendingOrder();
     }

   return _ORDER_STATUS_CODE_OTHERS;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::CloseOpeningOrder()
  {
   if(OrderClose(_orderId,_volume,GetExitPrice(_orderCommand),_slippage))
     {
      Print("Order Closed: ",_orderId);
      return 1;
     }
   else
     {
      Print(GetExitPrice(_orderCommand),"--",Bid,"--",Ask,"--",EnumToString((ENUM_ORDER_TYPE)_orderCommand));
      Print("Close order error: ",-GetLastError());
     }
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::ClosePendingOrder(void)
  {
   return OrderDelete(_orderId);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::CheckOrderStatus()
  {
   if(!OrderSelect(_orderId,SELECT_BY_TICKET))
     {
      delete &this;
      return -GetLastError();
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

static double OrderClass::GetCurrentPrice(ENUM_ORDER_TYPE orderCommand)
  {

   if(orderCommand==OP_BUY || 
      orderCommand == OP_BUYLIMIT ||
      orderCommand == OP_BUYSTOP)
      return Ask;
   else
      return Bid;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
static double OrderClass::GetExitPrice(ENUM_ORDER_TYPE orderCommand)
  {
   if(orderCommand==OP_BUY || 
      orderCommand == OP_BUYLIMIT ||
      orderCommand == OP_BUYSTOP)
      return Bid;
   else
      return Ask;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderClass::GetCurrentPrice()
  {
   return OrderClass::GetCurrentPrice(_orderCommand);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::ModifyTrailingSl(double newSl)
  {
   newSl=NormalizeDouble(newSl,Digits);
   if(newSl==_sl)
     {
      return _ORDER_STATUS_CODE_SL_NOT_CHANGED;
     }

   int orderType=GetOrderType();

   if(orderType<0)
      return orderType;

   if(orderType!=OP_BUY && orderType!=OP_SELL)
      return _ORDER_STATUS_CODE_NOT_OPENED;

   if(!OrderSelect(_orderId,SELECT_BY_TICKET,MODE_TRADES))
     {
      _status=_ORDER_STATUS_CODE_OPEN_FAILED;
      Print("Order Select Fail. Code: ",-GetLastError());
      return -GetLastError();
     }
   else if(OrderCloseTime()!=0)
     {
      return _ORDER_STATUS_CODE_NOT_OPENED;
     }
   if(!OrderModify(_orderId,OrderOpenPrice(),newSl,OrderTakeProfit(),0,_arrowColor))
     {
      _sl=newSl;
      Print("Order Modify Fail. Code: ",-GetLastError());
      return -GetLastError();
     }

   return _ORDER_STATUS_CODE_OTHERS;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderClass::ModifyTrailingSl()
  {
   double currentPrice=GetCurrentPrice();
   double currentPriceDistant=_side *(currentPrice-_trailingSlTrigger);
   double modifiedSl=NormalizeDouble(currentPrice-_trailingSlRange*_Point*10*_side,Digits);

   return ModifyTrailingSl(modifiedSl);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderClass::SetTrailingStop(double trailingSlRange,double trailingSlTrigger=EMPTY)
  {
   _trailingSlTrigger=trailingSlTrigger==EMPTY ? _price : trailingSlTrigger;
   _trailingSlRange=trailingSlRange;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

OrderClass *OrderClass::OpenOrder(ENUM_ORDER_TYPE cmd,double volume,double sl,double tp,datetime expiration=0)
  {
   double price=EMPTY;
   if(cmd==OP_BUY || cmd==OP_SELL)
      price=GetCurrentPrice(cmd);
   else
     {
      _status=_ORDER_STATUS_CODE_INVALID_COMMAND;
      return NULL;
     }

   return OpenOrder(cmd, volume, price, sl, tp, expiration);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string OrderClass::_ProcessCommentAnnotations(double entry=0,double sl=0,double tp=0)
  {
   string comment=_comment;
   MessageHelper::Decode(comment,"ENTRY",entry);
   MessageHelper::Decode(comment,"SL",sl);
   MessageHelper::Decode(comment,"TP",tp);

   return comment;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderClass *OrderClass::OpenOrder(ENUM_ORDER_TYPE orderCommand,double volume,double price,double sl,double tp,datetime expiration=0)
  {
   price=NormalizeDouble(price,Digits);
   sl = NormalizeDouble(sl, Digits);
   tp = NormalizeDouble(tp, Digits);
   _orderId=OrderSend(_symbol,orderCommand,volume,price,_slippage,sl,tp,_ProcessCommentAnnotations(price,sl,tp),_magicNumber,expiration,_arrowColor);
   if(_orderId!=-1)
     {
      _side=GetOrderSide(orderCommand);
      _price = price;
      _entry = price;
      _volume= volume;
      _sl = sl;
      _tp = tp;
      _status=_ORDER_STATUS_CODE_OPENED;
      _orderCommand=orderCommand;
     }
   else
     {
      _orderId= EMPTY;
      _status = _ORDER_STATUS_CODE_OTHERS;
      Print("Order not opened: ",-GetLastError());
      Print(EnumToString(orderCommand),"-Price:",price,"-SL:",sl,"-TP:",tp,"-VOL:",volume,"-EXP: ",expiration);
      return NULL;
     }

   return GetPointer(this);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderClass::OrderClass(int index,int select=SELECT_BY_TICKET,int pool=MODE_TRADES)
  {
   bool isValidOrder=OrderSelect(index,select,pool);
   if(!isValidOrder)
     {
      _status=_ORDER_STATUS_CODE_NOT_FOUND;
     }
   else
     {
      InitInfo();

      _entry=OrderOpenPrice();
      _volume= OrderLots();
      _symbol=OrderSymbol();
      _magicNumber=OrderMagicNumber();
      _comment=OrderComment();
      _orderId=OrderTicket();
      _status=_ORDER_STATUS_CODE_OPENED;
      _sl=OrderStopLoss();
      _tp=OrderTakeProfit();
      _orderCommand=OrderType();
      _side=GetOrderSide((ENUM_ORDER_TYPE)_orderCommand);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderClass::OrderClass(string symbol,int magicNumber=EMPTY,string comment="",int slippage=5)
  {
   InitInfo();
   _symbol=symbol;
   _comment=comment;
   _magicNumber=magicNumber;
   _slippage=slippage;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

void OrderClass::InitInfo()
  {
   _moduleName="OrderClass";
   _orderId=EMPTY;

   _arrowColor=clrNONE;
   _status=_ORDER_STATUS_CODE_PREPARING;

   _trailingSlRange=EMPTY;
   _trailingSlTrigger=EMPTY;

   _slippage=5;
  }
//+------------------------------------------------------------------+
