//+------------------------------------------------------------------+
//|                                          _CandleModel.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property version "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleModel
  {
private:
   string            _symbol;
   ENUM_TIMEFRAMES   _timeframe;
   int               _i;

public:
                     CandleModel(string symbol,ENUM_TIMEFRAMES timeframe,int i);
                    ~CandleModel();

   double            high;
   double            low;
   double            open;
   double            close;
   int               index;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleModel::CandleModel(string symbol,ENUM_TIMEFRAMES timeframe,int i)
  {
   _symbol=symbol;
   _timeframe=timeframe;
   _i=i;

   index=_i;
   high= iHigh(_symbol,_timeframe,_i);
   low = iLow(_symbol,_timeframe,_i);
   open= iOpen(_symbol,_timeframe,_i);
   close=iClose(_symbol,_timeframe,_i);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
CandleModel::~CandleModel()
  {
  }
//+------------------------------------------------------------------+
