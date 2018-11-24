//+------------------------------------------------------------------+
//|                                   _SimpleCandlePatternsClass.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include <Common\EnumClass.mqh>
#include <Common\CandlePatternHelper\CandleProcessClass.mqh>
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class SimpleCandlePatternClass : public CandleProcessClass
  {
protected:
   virtual void _PreProcess(CandleProcessClass &candle)
     {
      CandleProcessClass::_PreProcess(candle);

      _isRangeInside=candle.High()<_high && candle.Low()>_low;
      _isRangeOutside=candle.High()>_high && candle.Low()<_low;

      _isRangeInside=candle.High()<_high && candle.Low()>_low;
      _isRangeOutside=candle.High()>_high && candle.Low()<_low;

      _isBearish = candle.High() < _high && candle.Low() < _low;
      _isBullish = candle.High() > _high && candle.Low() > _low;

      _isOpenGap=candle.Open()>_high || candle.Open()<_low;
      _isCandleGap=candle.Low()>_high || candle.High()<_low;
     }

public:
                    ~SimpleCandlePatternClass(){};

                     SimpleCandlePatternClass(SimpleCandlePatternClass &old) : CandleProcessClass(old)
     {
      _dojiBodySetting=old._dojiBodySetting;
      _pinbarBodySetting=old._pinbarBodySetting;
      _pinbarShadowSetting=old._pinbarShadowSetting;
      _isOpenGap=old._isOpenGap;
      _isCandleGap=old._isCandleGap;
      _isRangeInside=old._isRangeInside;
      _isRangeOutside=old._isRangeOutside;
      _isBearish = old._isBearish;
      _isBullish = old._isBullish;
     }
                     SimpleCandlePatternClass() : CandleProcessClass()
     {
      _dojiBodySetting=0.1;

      _pinbarBodySetting=0.3;
      _pinbarShadowSetting=0.5;

      _isRangeOutside=false;
      _isRangeOutside=false;

      _isBearish = false;
      _isBullish = false;

      _isOpenGap=false;
      _isCandleGap=false;
     }

   double            _dojiBodySetting;

   double            _pinbarBodySetting;
   double            _pinbarShadowSetting;

   bool              _isOpenGap;
   bool              _isCandleGap;

   bool              _isRangeInside;
   bool              _isRangeOutside;

   bool              _isBodyInside;
   bool              _isBodyOutside;

   bool              _isBearish;
   bool              _isBullish;

   void SetDojiSetting(double bodyPercentage) { _dojiBodySetting=bodyPercentage; };
   void SetPinbarSetting(double bodyPercentage,double shadowPercentage)
     {
      _pinbarBodySetting=bodyPercentage;
      _pinbarShadowSetting=shadowPercentage;
     };

   bool IsDoji() { return BodyPercentage()<_dojiBodySetting && IsValid(); };

   bool IsPinbarTop() { return BodyPercentage()<_pinbarBodySetting && TopShadowPercentage()>_pinbarShadowSetting && IsValid(); };
   bool IsPinbarBottom() { return BodyPercentage()<_pinbarBodySetting && BottomShadowPercentage()>_pinbarShadowSetting && IsValid(); };

   bool IsRangeInsideBar() { return _isRangeInside && IsValid(); };
   bool IsRangeOutsideBar() { return _isRangeOutside && IsValid(); };
   bool IsBearish() { return _isBearish && IsValid(); };
   bool IsBullish() { return _isBullish && IsValid(); };

   bool IsOpenGap() { return _isOpenGap && IsValid(); };
   bool IsCandleGap() { return _isCandleGap && IsValid(); };

   bool IsLowerLow() { return _lowDiff<0 && IsValid(); };
   bool IsHigherLow() { return _lowDiff>0 && IsValid(); };
   bool IsHigherHigh() { return _highDiff>0 && IsValid(); };
   bool IsLowerHigh() { return _highDiff<0 && IsValid(); };

   bool IsUpBar() { return Side()==ENUM.TREND.BULL && IsValid(); };
   bool IsDownBar() { return Side()==ENUM.TREND.BEAR && IsValid(); };
   // Engulfing
  };
//+------------------------------------------------------------------+
