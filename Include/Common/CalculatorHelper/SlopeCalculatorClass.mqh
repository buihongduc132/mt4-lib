//+------------------------------------------------------------------+
//|                                                  ZigzagValid.mqh |
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
class SlopeCalculatorClass
  {
public:
   int               _candleRange;
   double            _slopeRatioTarget;

   double            _GetPriceRange(string symbol,ENUM_TIMEFRAMES timeframe,int shift);
   double            _GetTimeRange() { return _candleRange; };

   double            _GetPricePropotion(double priceMoved,string symbol,ENUM_TIMEFRAMES timeframe,int shift);
   double            _GetTimePropotion(int candleElapsed) { return candleElapsed/_GetTimeRange(); };

   double            GetSlopeRatio(double priceMoved,int candlElapsed,string symbol,ENUM_TIMEFRAMES timeframe,int shift);
   bool              IsValidSlope(double priceMoved,int candlElapsed,string symbol,ENUM_TIMEFRAMES timeframe,int shift);
   double            GetTargetPrice(int candlElapsed,string symbol,ENUM_TIMEFRAMES timeframe,int shift);

   double            _GetCurrentTargetSlope(int candleElapsed);

                     SlopeCalculatorClass(int candleRange=360,double slopeRatioTarget=2.5);
                    ~SlopeCalculatorClass();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SlopeCalculatorClass::SlopeCalculatorClass(int candleRange,double slopeRatioTarget)
  {
   _candleRange=candleRange;
   _slopeRatioTarget=slopeRatioTarget;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
SlopeCalculatorClass::~SlopeCalculatorClass()
  {
  }
//+------------------------------------------------------------------+

double SlopeCalculatorClass::_GetPricePropotion(double priceMoved,string symbol,ENUM_TIMEFRAMES timeframe,int shift)
  {
   return priceMoved/_GetPriceRange(symbol, timeframe, shift);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double SlopeCalculatorClass::_GetPriceRange(string symbol,ENUM_TIMEFRAMES timeframe,int shift)
  {
   double highestIndex= iHighest(symbol,timeframe,MODE_HIGH,_candleRange,shift);
   double lowestIndex = iLowest(symbol,timeframe,MODE_LOW,_candleRange,shift);

   return iHigh(symbol, timeframe, highestIndex) - iLow(symbol, timeframe, lowestIndex);
  }
//+------------------------------------------------------------------+

double SlopeCalculatorClass::GetSlopeRatio(double priceMoved,int candlElapsed,string symbol,ENUM_TIMEFRAMES timeframe,int shift)
  {
   return _GetPricePropotion(priceMoved, symbol, timeframe, shift)/_GetTimePropotion(candlElapsed);
  }
//+------------------------------------------------------------------+

bool SlopeCalculatorClass::IsValidSlope(double priceMoved,int candlElapsed,string symbol,ENUM_TIMEFRAMES timeframe,int shift)
  {
   return GetSlopeRatio(priceMoved,candlElapsed, symbol, timeframe, shift) > _slopeRatioTarget;
  }
//+------------------------------------------------------------------+

double SlopeCalculatorClass::GetTargetPrice(int candlElapsed,string symbol,ENUM_TIMEFRAMES timeframe,int shift)
  {
   return _slopeRatioTarget*_GetPriceRange(symbol, timeframe,shift)*candlElapsed/_GetTimeRange();
  }
//+------------------------------------------------------------------+
