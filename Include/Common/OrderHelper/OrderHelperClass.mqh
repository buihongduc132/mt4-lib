//+------------------------------------------------------------------+
//|                                            OrderClassClass.mqh |
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

#include "Component\OrderClass.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderListHandler
  {
protected:
   int               _magicNumber;
   string            _comment;

   string            _symbol;
   int               _slippage;
   string            _moduleName;
   color             _arrowColor;
   bool              ClosedOrder();
   void              RemoveAt(int &orderIndex);
   void              RemoveLast();
public:
   OrderClass       *_orders[];
   void              OrderListHandler(string symbol,string comment,int magicNumber,int slippage);
   void             ~OrderListHandler();

   OrderClass       *AddOrder(OrderClass *order);

   OrderClass       *GetLast();

   OrderClass       *NewOrder();
   OrderClass       *NewOrder(OrderClass *newOrder);
   OrderClass       *NewOrder(string symbol,string comment,int magicNumber,int slippage);

   void              ModifyTrailingStopAll();
   void              ModifyTrailingStopAll(double price);

   int               GetNumberOfOpenTrade();
   static int        GetNumberOfAllOpenTrade();

   int               FetchAllOrders(int mode);
   OrderListHandler *FilterByType(ENUM_ORDER_TYPE orderType,bool rejectMode);
   OrderListHandler *FilterBySymbol(string symbol,bool rejectMode);
   OrderListHandler *FilterByMagic(int magic,bool rejectMode);

   int               AddOrdersToList(OrderClass &orders[]);

   void              CloseAll();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderListHandler *OrderListHandler::FilterByType(ENUM_ORDER_TYPE orderType,bool rejectMode=false)
  {
   for(int i=0; i<ArraySize(_orders); i++)
     {
      if((_orders[i]._orderCommand!=orderType)!=rejectMode)
         RemoveAt(i);
     }

   return GetPointer(this);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderListHandler *OrderListHandler::FilterBySymbol(string symbol,bool rejectMode=false)
  {
   for(int i=0; i<ArraySize(_orders); i++)
     {
      if((_orders[i]._symbol!=symbol)!=rejectMode)
         RemoveAt(i);
     }

   return GetPointer(this);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderListHandler *OrderListHandler::FilterByMagic(int magic,bool rejectMode=false)
  {

   for(int i=0; i<ArraySize(_orders); i++)
     {
      if((_orders[i]._magicNumber!=magic)!=rejectMode)
         RemoveAt(i);
     }

   return GetPointer(this);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OrderListHandler::FetchAllOrders(int mode=MODE_TRADES)
  {
   int ordersTotal=OrdersTotal();
   int addedOrders= 0;
   for(int i=0; i<ArraySize(_orders); i++)
     {
      delete _orders[i];
     }

   ArrayResize(_orders,0);

   for(int i=0; i<OrdersTotal(); i++)
     {
      if(OrderSelect(i,SELECT_BY_POS,mode))
        {
         addedOrders++;
         AddOrder(new OrderClass(OrderTicket()));
        }
     }

   return addedOrders;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::~OrderListHandler()
  {
   for(int i=0; i<ArraySize(_orders); i++)
     {
      delete _orders[i];
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderClass *OrderListHandler::GetLast(void)
  {
   return _orders[ArraySize(_orders)-1];
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

OrderClass *OrderListHandler::NewOrder(OrderClass *newOrder)
  {
   if(CheckPointer(newOrder))
     {
      if(CheckPointer(AddOrder(newOrder)))
        {
         return GetPointer(newOrder);
        }
     }

   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderClass *OrderListHandler::NewOrder()
  {
   return this.NewOrder(new OrderClass(_symbol,_magicNumber,_comment,_slippage));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderClass *OrderListHandler::NewOrder(string symbol,string comment,int magicNumber,int slippage)
  {
   return this.NewOrder(new OrderClass(symbol,magicNumber,comment,slippage));
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void OrderListHandler::ModifyTrailingStopAll(double price=EMPTY)
  {
   int invalidIds[];
   for(int i=0; i<ArraySize(_orders);i++)
     {
      int modifyResult;
      if(price==EMPTY)
         modifyResult=_orders[i].ModifyTrailingSl();
      else
         modifyResult=_orders[i].ModifyTrailingSl(price);

      switch(modifyResult)
        {
         case -4108:
           {
            //Print(i," - Modify Trailing Stop Failed: ",modifyResult,EnumToString(orders[i].GetOrderType()));
            RemoveAt(i);
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
void OrderListHandler::CloseAll()
  {
   for(int i=0; i<ArraySize(_orders); i++)
     {
      _orders[i].CloseOrder();
      RemoveAt(i);
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::OrderListHandler(string symbol,string comment="",int magicNumber=EMPTY,int slippage=5)
  {
   if(magicNumber==EMPTY)
      magicNumber=rand();
   _magicNumber=magicNumber;

   if(comment=="")
      comment=(string)rand();
   _comment=comment;

   _symbol=symbol;
   _slippage=slippage;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
OrderClass*OrderListHandler::AddOrder(OrderClass *order)
  {
   int arraySize=ArraySize(_orders);
   ArrayResize(_orders,arraySize+1);
   _orders[arraySize]=GetPointer(order);

   return GetPointer(order);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::RemoveAt(int &orderIndex)
  {
   delete _orders[orderIndex];
   _orders[orderIndex]=_orders[ArraySize(_orders)-1];
   ArrayResize(_orders,ArraySize(_orders)-1);
   orderIndex--;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void OrderListHandler::RemoveLast()
  {
   int lastIndex=ArraySize(_orders)-1;
   RemoveAt(lastIndex);
  }
//+------------------------------------------------------------------+

static int OrderListHandler::GetNumberOfAllOpenTrade()
  {
   return OrdersTotal();
  }
//+------------------------------------------------------------------+
