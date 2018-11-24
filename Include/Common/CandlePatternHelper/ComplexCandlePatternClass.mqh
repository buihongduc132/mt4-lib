//+------------------------------------------------------------------+
//|                                    ComplexCandlePatternClass.mqh |
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

#include <Common\CandlePatternHelper\SimpleCandlePatternClass.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ComplexCandlePatternClass : public SimpleCandlePatternClass
  {
protected:
public:
   int               _storeCount;
   int               _calCount;

   ENUM_TIMEFRAMES   _prevTimeframe;
   string            _prevSymbol;
   datetime          _prevCalTime;
   datetime          _expectedCalTime;

   SimpleCandlePatternClass *_candles[];

   SimpleCandlePatternClass *GetCandle(int i);

   void              _ResetCalInfo();
   void _UpdateExpectedCalTime() { _expectedCalTime=_prevCalTime+PeriodSeconds(_prevTimeframe); };
   bool _IsSameInfo(string symbol,ENUM_TIMEFRAMES timeframe,int i)
     {
      return _prevCalTime == iTime(symbol, timeframe, i);
     };

   virtual void _PostProcess(string symbol,ENUM_TIMEFRAMES timeframe,int i=0)
     {
      if(!_IsSameInfo(symbol,timeframe,i))
         _UpdateNewCandle();

      _prevCalTime=iTime(symbol,timeframe,i);
     }

   void              _UpdateNewCandle();

                     ComplexCandlePatternClass(ComplexCandlePatternClass &old) : SimpleCandlePatternClass(old)
     {
     }
                     ComplexCandlePatternClass(int store=20) : SimpleCandlePatternClass()
     {
      _storeCount=store;
      ArrayResize(_candles,_storeCount);
     }
   virtual void Process(string symbol,ENUM_TIMEFRAMES timeframe,int i)
     {
      SimpleCandlePatternClass::Process(symbol,timeframe,i);
      _PostProcess(symbol,timeframe,i);
     }

   double            AvgHigh();
   double            AvgLow();
   double            AvgClose();
   double            AvgOpen();
   double            AvgBody();
   double            AvgCandleSize();

   double AvgBodyPercentage() { return AvgBody()==0 ? 1 : Body()/AvgBody(); };

                    ~ComplexCandlePatternClass();
  };
//+------------------------------------------------------------------+

SimpleCandlePatternClass *ComplexCandlePatternClass::GetCandle(int i=0)
  {
   if(i<_storeCount && CheckPointer(_candles[i]))
      return _candles[i];

   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ComplexCandlePatternClass::_UpdateNewCandle()
  {
   delete _candles[_storeCount-1];

   SimpleCandlePatternClass *currentCandle=GetCandle(0);

   for(int i=ArraySize(_candles)-1; i>0; i--)
     {
      _candles[i]=GetCandle(i-1);
     }

   SimpleCandlePatternClass *newCandle=new SimpleCandlePatternClass(this);

   _candles[0]=newCandle;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ComplexCandlePatternClass::_ResetCalInfo()
  {
   _prevTimeframe=EMPTY;
   _prevSymbol=EMPTY;
   _prevCalTime=EMPTY;
   _calCount=0;
  }
//+------------------------------------------------------------------+

void ComplexCandlePatternClass::~ComplexCandlePatternClass()
  {
   for(int i=ArraySize(_candles)-1; i>=0; i--)
     {
      delete _candles[i];
     }
  }
//+------------------------------------------------------------------+

double ComplexCandlePatternClass::AvgBody(void)
  {
   double sum=Body();
   if(sum==0)
      return 0.00001;
   int count= 1;
   for(int i=1; i<ArraySize(_candles); i++)
     {
      SimpleCandlePatternClass *candle=GetCandle(i);

      if(CheckPointer(candle))
        {
         sum+=candle.Body();
         count++;
        }
     }

   return sum / ArraySize(_candles);
  }
//+------------------------------------------------------------------+

double ComplexCandlePatternClass::AvgHigh(void)
  {
   double sum=High();
   if(sum==0)
      return 0.00001;
   int count= 1;
   for(int i=1; i<ArraySize(_candles); i++)
     {
      SimpleCandlePatternClass *candle=GetCandle(i);

      if(CheckPointer(candle))
        {
         sum+=candle.High();
         count++;
        }
     }

   return sum / ArraySize(_candles);
  }
//+------------------------------------------------------------------+

double ComplexCandlePatternClass::AvgLow(void)
  {
   double sum=Low();
   int count = 1;
   for(int i=1; i<ArraySize(_candles); i++)
     {
      SimpleCandlePatternClass *candle=GetCandle(i);

      if(CheckPointer(candle))
        {
         sum+=candle.Low();
         count++;
        }
     }

   return sum / ArraySize(_candles);
  }
//+------------------------------------------------------------------+

double ComplexCandlePatternClass::AvgOpen(void)
  {
   double sum=Open();
   if(sum==0)
      return 0.00001;
   int count= 1;
   for(int i=1; i<ArraySize(_candles); i++)
     {
      SimpleCandlePatternClass *candle=GetCandle(i);

      if(CheckPointer(candle))
        {
         sum+=candle.Open();
         count++;
        }
     }

   return sum / ArraySize(_candles);
  }
//+------------------------------------------------------------------+

double ComplexCandlePatternClass::AvgClose(void)
  {
   double sum=Close();
   if(sum==0)
      return 0.00001;
   int count= 1;
   for(int i=1; i<ArraySize(_candles); i++)
     {
      SimpleCandlePatternClass *candle=GetCandle(i);

      if(CheckPointer(candle))
        {
         sum+=candle.Close();
         count++;
        }
     }

   return sum / ArraySize(_candles);
  }
//+------------------------------------------------------------------+

double ComplexCandlePatternClass::AvgCandleSize(void)
  {
   double sum=CandleSize();
   if(sum==0)
      return 0.00001;

   int count= 1;
   for(int i=1; i<ArraySize(_candles); i++)
     {
      SimpleCandlePatternClass *candle=GetCandle(i);

      if(CheckPointer(candle))
        {
         sum+=candle.CandleSize();
         count++;
        }
     }

   return sum / ArraySize(_candles);
  }
//+------------------------------------------------------------------+
