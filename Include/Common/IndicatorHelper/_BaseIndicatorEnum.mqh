//+------------------------------------------------------------------+
//|                                           _BaseIndicatorEnum.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

enum ENTRY_SS
  {
   _ENTRY_SS_BUY,
   _ENTRY_SS_SELL,
   _ENTRY_SS_NONE=EMPTY_VALUE
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum EXIT_SS
  {
   _EXIT_SS_BUY,
   _EXIT_SS_SELL,
   _EXIT_SS_NONE=EMPTY_VALUE
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class EntrySignalClass
  {
public:
   ENTRY_SS          BUY,SELL,NONE;
                    ~EntrySignalClass(){};
                     EntrySignalClass()
     {
      BUY=_ENTRY_SS_BUY;
      SELL=_ENTRY_SS_SELL;
      NONE=_ENTRY_SS_NONE;
     }
  };
//+------------------------------------------------------------------+

class ExitSignalClass
  {
public:
   EXIT_SS           CLOSE_BUY,CLOSE_SELL,NONE;
                    ~ExitSignalClass(){};
                     ExitSignalClass()
     {
      CLOSE_BUY=_EXIT_SS_BUY;
      CLOSE_SELL=_EXIT_SS_SELL;
      NONE=_EXIT_SS_NONE;
     }
  };
//+------------------------------------------------------------------+

class SignalClass
  {
public:
   EntrySignalClass *ENTRY;
   ExitSignalClass *EXIT;
                     SignalClass()
     {
      ENTRY= new EntrySignalClass();
      EXIT = new ExitSignalClass();
     };
                    ~SignalClass()
     {
      delete ENTRY;
      delete EXIT;
     };
  };
//+------------------------------------------------------------------+

SignalClass SIGNAL();
//+------------------------------------------------------------------+
