//+------------------------------------------------------------------+
//|                                          _CandleProcessClass.mqh |
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
#include <Common\EnumClass.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleProcessClass
  {
protected:
   void _InitPreviousData()
     {
      _highDiff= 0;
      _lowDiff = 0;
      _openCloseDiff=0;
      _openDiff=0;
      _closeDiff=0;
     }

   // START PROCESSED BY MODEL
   virtual void _PreProcess(CandleProcessClass  &candle)
     {
      //Print("1 Pre Process of CandleProcess by Model");
      _highDiff= candle.High()-_high;
      _lowDiff = candle.Low()-_low;
      _openCloseDiff=candle.Open()-_close;
      _closeDiff= candle.Close()-_close;
      _openDiff = candle.Open()-_open;

      _prevHigh= _high;
      _prevLow = _low;
      _prevClose= _close;
      _prevOpen = _open;

     }

   virtual void _Process(CandleProcessClass  &candle)
     {
      //Print("2 Process of CandleProcess by Model");
      _high= candle.High();
      _low = candle.Low();
      _open= candle.Open();
      _close=candle.Close();
     }

   virtual void _PostProcess(CandleProcessClass  &candle)
     {
      //Print("3 Post Process of CandleProcess by Model");
     }
   // END PROCESSED BY MODEL

   // START PROCESSED BY SYMBOL, TF
   virtual void _PreProcess(string symbol,ENUM_TIMEFRAMES timeframe,int i=0)
     {
      //Print("Prev Process of CandleProcess");
      CandleProcessClass candle(symbol,timeframe,i);
      _PreProcess(candle);
     }

   virtual void _Process(string symbol,ENUM_TIMEFRAMES timeframe,int i=0)
     {
      //Print("Current Process of CandleProcess");
      CandleProcessClass candle(symbol,timeframe,i);
      _Process(candle);
     }

   virtual void _PostProcess(string symbol,ENUM_TIMEFRAMES timeframe,int i=0)
     {
      //Print("Current Process of CandleProcess");
      CandleProcessClass candle(symbol,timeframe,i);
      _PostProcess(candle);
     }

   // END PROCESSED BY SYMBOL, TF

public:
   double            _prevHigh;
   double            _prevLow;
   double            _prevClose;
   double            _prevOpen;

   double            _high;
   double            _low;
   double            _open;
   double            _close;

   double            _highDiff;
   double            _lowDiff;
   double            _openDiff;
   double            _openCloseDiff;
   double            _closeDiff;

                     CandleProcessClass(CandleProcessClass &old)
     {
      _high= old._high;
      _low = old._low;
      _open= old._open;
      _close=old._close;

      _highDiff= old._highDiff;
      _lowDiff = old._lowDiff;
      _openDiff= old._openDiff;
      _openCloseDiff=old._openCloseDiff;
      _closeDiff=old._closeDiff;
     }
                     CandleProcessClass()
     {
      _InitPreviousData();
     };

                     CandleProcessClass(string symbol,ENUM_TIMEFRAMES timeframe,int i)
     {
      _InitPreviousData();

      _high= iHigh(symbol,timeframe,i);
      _low = iLow(symbol,timeframe,i);
      _open= iOpen(symbol,timeframe,i);
      _close=iClose(symbol,timeframe,i);

      Process(this);
     }

                    ~CandleProcessClass(){};

   virtual void Process(CandleProcessClass  &candle)
     {
      _PreProcess(candle);
      _Process(candle);
      _PostProcess(candle);
     };

   virtual void Process(string symbol,ENUM_TIMEFRAMES timeframe,int i)
     {
      CandleProcessClass candle(symbol,timeframe,i);
      Process(candle);
     }

   ENUM__TRENDING Side() { return _close>_open ? ENUM.TREND.BULL : ENUM.TREND.BEAR; };

   double High() { return _high; };
   double Close() { return _close; };
   double Open() { return _open; };
   double Low() { return _low; };

   bool IsValid() { return !(_high==_low==_open==_close); };

   double TopBody() { return MathMax(_open,_close); };
   double BottomBody() { return MathMin(_open,_close); };

   double TopShadow() { return _high-TopBody(); };
   double BottomShadow() { return BottomBody()-_low; };
   double Body() { return MathAbs(_open-_close); };
   double CandleSize() { return _high-_low; };

   double TopShadowPercentage() { return CandleSize()==0 ? 1 : TopShadow()/CandleSize(); };
   double BottomShadowPercentage() { return CandleSize()==0 ? 1 : BottomShadow()/CandleSize(); };
   double BodyPercentage() { return CandleSize()==0 ? 1 : Body()/CandleSize(); };
  };
//+------------------------------------------------------------------+
