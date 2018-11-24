//+------------------------------------------------------------------+
//|                                                   _OmegaBase.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Common\EnumClass.mqh>
#include "_BaseIndicatorEnum.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct BaseIndicatorInput
  {
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class IndicatorSignalClass
  {
public:
   ENTRY_SS          entry;
   EXIT_SS           exit;
                     IndicatorSignalClass() { ResetAll(); };
                    ~IndicatorSignalClass() {};
   void ResetEntry() { entry=SIGNAL.ENTRY.NONE; };
   void ResetExit() { exit=SIGNAL.EXIT.NONE; };
   void ResetAll() { ResetEntry(); ResetExit(); };

   ENTRY_SS FetchEntry() { ENTRY_SS value=entry; ResetEntry(); return value; };
   EXIT_SS FetchExit() { EXIT_SS value=exit; ResetExit(); return value; };

   static ENTRY_SS GetEntry(ENUM__TRENDING trend)
     {
      if(trend==ENUM.TREND.BULL)
         return SIGNAL.ENTRY.BUY;
      else if(trend==ENUM.TREND.BEAR)
         return SIGNAL.ENTRY.SELL;
      else
         return SIGNAL.ENTRY.NONE;
     }

   static EXIT_SS GetExit(ENTRY_SS entry)
     {
      if(entry==SIGNAL.ENTRY.BUY)
         return SIGNAL.EXIT.CLOSE_BUY;
      else if(entry==SIGNAL.ENTRY.SELL)
         return SIGNAL.EXIT.CLOSE_SELL;
      else
         return SIGNAL.EXIT.NONE;
     }

   static EXIT_SS GetExit(ENUM__TRENDING trend)
     {
      if(trend==ENUM.TREND.BULL)
         return SIGNAL.EXIT.CLOSE_SELL;
      else if(trend==ENUM.TREND.BEAR)
         return SIGNAL.EXIT.CLOSE_BUY;
      else
         return SIGNAL.EXIT.NONE;
     }

   void SetExit(ENTRY_SS entry) { exit=GetExit(entry); };

   void SetEntry(ENUM__TRENDING trend) {entry=IndicatorSignalClass::GetEntry(trend);}

   void SetExit(ENUM__TRENDING trend) {exit=IndicatorSignalClass::GetExit(trend);}
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class BaseIndicatorClass
  {
public:
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   string            _symbol;
   int               _timeframe;
   string            _namespace;
   BaseIndicatorInput _indicatorInput;
   IndicatorSignalClass *signal;

   int _GetBarByTime(datetime time)
     {
      int shift=iBarShift(_symbol,_timeframe,time);
      return shift;
     }
   virtual double    GetIndicatorValue(int mode,datetime time);
   virtual double    GetIndicatorValue(int mode,int shift=1);
   //+------------------------------------------------------------------+
   //|                                                                  |
   //+------------------------------------------------------------------+
   virtual void ChangeConfig(string symbol,int timeframe,BaseIndicatorInput &indicatorInput)
     {
      _symbol=symbol;
      _timeframe=timeframe;
      _indicatorInput=indicatorInput;
     }
   //+------------------------------------------------------------------+

   virtual ENUM__TRENDING GetTrend(int shift=1);
   //+------------------------------------------------------------------+

   virtual bool      IsChangeTrend(int shiftA,int shiftB);
   virtual bool      IsChangeTrend(datetime time);
   virtual bool      IsChangeTrend(int shift=1);

                     BaseIndicatorClass(string symbol,int timeframe,BaseIndicatorInput &indicatorInput);
                    ~BaseIndicatorClass();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseIndicatorClass::BaseIndicatorClass(string symbol,int timeframe,BaseIndicatorInput &indicatorInput)
  {
   ChangeConfig(symbol,timeframe,indicatorInput);
   signal=new IndicatorSignalClass();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
BaseIndicatorClass::~BaseIndicatorClass()
  {
   delete signal;
  }
//+------------------------------------------------------------------+
