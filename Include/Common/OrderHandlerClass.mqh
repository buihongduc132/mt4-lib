//+------------------------------------------------------------------+
//|                                            OrderHandlerClass.mqh |
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

Drawer orderHandlerDrawer(ChartID(),"OrderHandler");
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderHandler
  {
protected:
   int               side;
   int               magicNumber;
   int               orderId;
   string            symbol;
   int               slippage;
   string            moduleName;
   string            comment;
   color             arrowColor;
   double            sl;
   double            tp;
   double            trailingTpTrigger;
   double            trailingTpRange;
   datetime          orderExpiration;
   datetime          expiration;
   ENUM_ORDER_TYPE   orderCommand;
   double            volume;
   double            price;
   int               status;

   double            GetCurrentPrice();

   void              OrderOpenSuccess();
   void              OrderOpenFailed();
   void              ModifyTrailingTpSuccess();
   void              ModifyTrailingTpFailed();
public:
   void              OrderHandler(string _symbol,ENUM_ORDER_TYPE _cmd,int _slippage,string _comment,int _magic);
   void ~OrderHandler(){};

   void              SetTrailingStop();
   void              SetTrailingStop(double trailingTpRange,double trailingTpTrigger);
   void              SetVolumeFix(double volume);
   void              SetTakeProfit(double _tp);
   void              SetStoploss(double _sl);
   void              SetPrice(double _price);

   int               ModifyTrailingTp();

   double            CalculatePrice(double _price,int _pips) {       return _price+_pips*MathPow(10,Digits-1);      };
   int               OrderOpen();
   int               CheckOrderStatus();
   int               GetOrderType();

   int               CloseOrder();
   int               CloseOpeningOrder();
   int               ClosePendingOrder();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::GetOrderType()
  {
   if(!OrderSelect(this.orderId,SELECT_BY_TICKET))
     {
      delete &this;
      return -GetLastError();
     }
   return OrderType();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::CloseOrder()
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

   return -9997;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::CloseOpeningOrder()
  {
   Print("CloseOrder Not Implemented Yet");
   return -1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::ClosePendingOrder(void)
  {
   return OrderDelete(orderId);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::CheckOrderStatus()
  {
   if(!OrderSelect(this.orderId,SELECT_BY_TICKET))
     {
      delete &this;
      return -GetLastError();
     }
   return 0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double OrderHandler::GetCurrentPrice()
  {
   if(this.side==1)
      return Bid;
   else
      return Ask;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::ModifyTrailingTp(void)
  {
   int orderType=GetOrderType();

   if(orderType<0)
      return orderType;

   if(orderType!=OP_BUY && orderType!=OP_SELL)
      return -9998;

   if(this.trailingTpRange==EMPTY_VALUE)
      trailingTpRange=this.price;

   double currentPrice=GetCurrentPrice();

   double currentPriceDistant=side*(currentPrice-trailingTpTrigger);

   if(currentPriceDistant>=0)
     {
      double modifiedSl=NormalizeDouble(currentPrice-trailingTpRange*_Point*10*side,Digits);

      trailingTpTrigger=currentPrice;

      if(!OrderSelect(orderId,SELECT_BY_TICKET,MODE_TRADES))
        {
         this.status=-1;
         return -GetLastError();
        }

      else if(!OrderModify(orderId,OrderOpenPrice(),modifiedSl,OrderTakeProfit(),0,arrowColor))
        {
         return -GetLastError();
        }

     }
   else
     {
      //Print("current price distant: ",currentPriceDistant,"Trigger: ",trailingTpTrigger);
     }

   return -9999;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::SetVolumeFix(double _volume)
  {
   this.volume=_volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::SetTrailingStop()
  {
   if(this.price!=0.0 && trailingTpTrigger==EMPTY_VALUE)
     {
      trailingTpTrigger=this.price;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::SetTrailingStop(double _trailingTpRange,double _trailingTpTrigger=EMPTY_VALUE)
  {
   if(_trailingTpTrigger==EMPTY_VALUE)
     {
      if(this.price!=0.0)
        {
         trailingTpTrigger=this.price;
        }
     }
   else
     {
      trailingTpTrigger=_trailingTpTrigger;
     }

   this.trailingTpRange=_trailingTpRange;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::SetStoploss(double _sl)
  {
   this.sl=_sl;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::SetTakeProfit(double _tp)
  {
   this.tp=_tp;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::SetPrice(double _price)
  {
   this.price=_price;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderHandler::OrderOpen()
  {
   double actualPrice=this.price;

   if(orderCommand==OP_BUY || orderCommand==OP_SELL)
      actualPrice=GetCurrentPrice();

   orderId=OrderSend(symbol,orderCommand,volume,actualPrice,slippage,sl,tp,comment,magicNumber,expiration,arrowColor);
   if(orderId!=-1)
     {
      this.price=actualPrice;
      this.SetTrailingStop();
      this.status=1;
     }
   else
     {
      this.status=-1;
      return -GetLastError();
     }

   return orderId;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderHandler::OrderHandler(string _symbol,ENUM_ORDER_TYPE _cmd,int _slippage=5,string _comment="",int _magic=EMPTY_VALUE)
  {
//int _orderId = OrderSend(symbol, cmd, volume,
   this.symbol=_symbol;
   this.comment=_comment;
   this.magicNumber=_magic;
   this.slippage=_slippage;
   this.orderCommand=_cmd;
   this.orderId=EMPTY_VALUE;
   this.arrowColor=clrCyan;
   this.status=1;

   this.trailingTpRange=EMPTY_VALUE;
   this.trailingTpTrigger=EMPTY_VALUE;

   this.side=1;
   if(_cmd==OP_SELL || _cmd==OP_SELLLIMIT || _cmd==OP_SELLSTOP)
      this.side=-1;
  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderListHandler
  {
protected:
   OrderHandler     *orders[];
   int               magicNumber;
   string            comment;

   string            symbol;
   int               slippage;
   string            moduleName;
   color             arrowColor;
   bool              ClosedOrder();

public:
   void              OrderListHandler(string _symbol,string _comment,int _magicNumber,int _slippage);
   void             ~OrderListHandler();

   int               NewOrder(ENUM_ORDER_TYPE _cmd);
   OrderHandler     *AddOrder(OrderHandler *order);
   void              RemoveOrderAt(int orderIndex);
   void              RemoveOrderLast();
   void              ModifyTrailingStopAll();
   int               GetNumberOfOpenTrade();
   OrderHandler     *LatestOrder();
   void              CloseAllOrders();
   void              CloseOrderByType(ENUM_ORDER_TYPE _orderType);
   int               OpenLastOrder();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderListHandler::OpenLastOrder(void)
  {
   if(LatestOrder().OrderOpen()<0)
     {
      RemoveOrderLast();
      return -1;
     }

   return 1;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::~OrderListHandler()
  {
   for(int i=0; i<ArraySize(orders); i++)
     {
      delete orders[i];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderHandler *OrderListHandler::LatestOrder(void)
  {
   return this.orders[ArraySize(this.orders)-1];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderListHandler::NewOrder(ENUM_ORDER_TYPE _cmd)
  {
   OrderHandler *orderHandler=new OrderHandler(this.symbol,_cmd,this.slippage,this.comment,this.magicNumber);
   if(CheckPointer(orderHandler))
     {
      if(CheckPointer(AddOrder(orderHandler)))
        {
         return 1;
        }
     }

   return -9996;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::ModifyTrailingStopAll()
  {
   int invalidIds[];
   for(int i=0; i<ArraySize(orders);i++)
     {
      int modifyResult;
      modifyResult=orders[i].ModifyTrailingTp();

      switch(modifyResult)
        {
         case -4108:
           {
            //Print(i," - Modify Trailing Stop Failed: ",modifyResult,EnumToString(orders[i].GetOrderType()));
            RemoveOrderAt(i);
            i--;
            break;
           }
         case -9998:
           {
            //Print("Modify Trailing Stop Failed: ",modifyResult);
            //RemoveOrderAt(i);
            break;
           }
         case -9996:
           {
            //Print("Modify Trailing Invalid Pointer: ",modifyResult);
            break;
           }
         default:
           {
            if(modifyResult>0)
              {
              }
            break;
           }
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::CloseAllOrders()
  {
   for(int i=0; i<ArraySize(orders); i++)
     {
      orders[i].CloseOrder();
      RemoveOrderAt(i);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::CloseOrderByType(ENUM_ORDER_TYPE _orderType)
  {
   for(int i=0; i<ArraySize(orders); i++)
     {
      int orderType=orders[i].GetOrderType();
      if(orderType==_orderType)
        {
         orders[i].CloseOrder();
         RemoveOrderAt(i);
         i--;
        }
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::OrderListHandler(string _symbol,string _comment="",int _magicNumber=EMPTY_VALUE,int _slippage=5)
  {
   if(_magicNumber==EMPTY_VALUE)
      _magicNumber=rand();
   magicNumber=_magicNumber;

   if(_comment=="")
      _comment=(string)rand();
   comment=_comment;

   symbol=_symbol;
   slippage=_slippage;

//this.orders
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
OrderHandler*OrderListHandler::AddOrder(OrderHandler *order)
  {
   int arraySize=ArraySize(orders);
   ArrayResize(orders,arraySize+1);
   orders[arraySize]=GetPointer(order);

   return GetPointer(order);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

void OrderListHandler::RemoveOrderAt(int orderIndex)
  {
   orders[orderIndex]=orders[ArraySize(orders)-1];
   ArrayResize(orders,ArraySize(orders)-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::RemoveOrderLast()
  {
   RemoveOrderAt(GetNumberOfOpenTrade()-1);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderListHandler::GetNumberOfOpenTrade()
  {
   return ArraySize(orders);
  }
//+------------------------------------------------------------------+
