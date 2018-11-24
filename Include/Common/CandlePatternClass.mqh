//+------------------------------------------------------------------+
//|                                                      BHD Library |
//|                                      Copyright 2016, BHD         |
//|                                       skype: buihongduc132       |
//+------------------------------------------------------------------+
#include "EnumClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CandleProcessClass
  {
protected:
   double            _high;
   double            _low;
   double            _open;
   double            _close;

   double            _highDiff;
   double            _lowDiff;
   double            _openDiff;
   double            _openCloseDiff;
   double            _closeDiff;

public:
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
      _highDiff= 0;
      _lowDiff = 0;
      _openCloseDiff=0;
      _openDiff=0;
      _closeDiff=0;
     };
                    ~CandleProcessClass(){};
   void Process(double high,double low,double open,double close)
     {
      _highDiff= high-_high;
      _lowDiff = low-_low;
      _openCloseDiff=open-_close;
      _closeDiff= close-_close;
      _openDiff = open-_open;

      _high= high;
      _low = low;
      _open= open;
      _close=close;
     };

   ENUM__TRENDING Side() { return _close>_open ? ENUM.TREND.BULL : ENUM.TREND.BEAR; };
   double High() { return _high; };
   double Close() { return _close; };
   double Open() { return _open; };
   double Low() { return _low; };

   double TopBody() { return MathMax(_open,_close); };
   double BottomBody() { return MathMin(_open,_close); };

   double TopShadow() { return _high-TopBody(); };
   double BottomShadow() { return BottomBody()-_low; };
   double Body() { return MathAbs(_open-_close); };
   double CandleSize() { return _high-_low; };

   double TopShadowPercentage() { return TopShadow()/CandleSize(); };
   double BottomShadowPercentage() { return BottomShadow()/CandleSize(); };
   double BodyPercentage() { return CandleSize()==0 ? 0 : Body()/CandleSize(); };
  };
//+------------------------------------------------------------------+

class CandlePatternClass : public CandleProcessClass
  {
private:
   double            _dojiBodySetting;

   double            _pinbarBodySetting;
   double            _pinbarShadowSetting;

   bool              _isOpenGap;
   bool              _isCandleGap;

   bool              _isInside;
   bool              _isOutside;

   bool              _isBearish;
   bool              _isBullish;

public:
                    ~CandlePatternClass(){};

                     CandlePatternClass(CandlePatternClass &old) : CandleProcessClass(old)
     {
      _dojiBodySetting=old._dojiBodySetting;
      _pinbarBodySetting=old._pinbarBodySetting;
      _pinbarShadowSetting=old._pinbarShadowSetting;
      _isOpenGap=old._isOpenGap;
      _isCandleGap=old._isCandleGap;
      _isInside=old._isInside;
      _isOutside = old._isOutside;
      _isBearish = old._isBearish;
      _isBullish = old._isBullish;
     }
                     CandlePatternClass() : CandleProcessClass()
     {
      _dojiBodySetting=0.1;

      _pinbarBodySetting=0.3;
      _pinbarShadowSetting=0.5;

      _isInside=false;
      _isOutside=false;

      _isBearish = false;
      _isBullish = false;

      _isOpenGap=false;
      _isCandleGap=false;
     }

   void Process(double high,double low,double open,double close)
     {
      _isInside=high<_high && low>_low;
      _isOutside = high > _high && low < _low;
      _isBearish = high < _high && low < _low;
      _isBullish = high > _high && low > _low;

      _highDiff= high-_high;
      _lowDiff = low-_low;
      _openCloseDiff=open-_close;
      _closeDiff= close-_close;
      _openDiff = open-_open;

      _isOpenGap=open>_high || open<_low;
      _isCandleGap=low>_high || high<_low;

      _high= high;
      _low = low;
      _open= open;
      _close=close;
     };

   void SetDojiSetting(double bodyPercentage) { _dojiBodySetting=bodyPercentage; };
   void SetPinbarSetting(double bodyPercentage,double shadowPercentage)
     {
      _pinbarBodySetting=bodyPercentage;
      _pinbarShadowSetting=shadowPercentage;
     };

   bool IsDoji() { return BodyPercentage()<_dojiBodySetting; };

   bool IsPinbarTop() { return BodyPercentage()<_pinbarBodySetting && TopShadow()>_pinbarShadowSetting; };
   bool IsPinbarBottom() { return BodyPercentage()<_pinbarBodySetting && BottomShadow()>_pinbarShadowSetting; };

   bool IsInsideBar() { return _isInside; };
   bool IsOutsideBar() { return _isOutside; };
   bool IsBearish() { return _isBearish; };
   bool IsBullish() { return _isBullish; };

   bool IsOpenGap() { return _isOpenGap; };
   bool IsCandleGap() { return _isCandleGap; };

   double IsLowerLow() { return _lowDiff<0; };
   double IsHigherLow() { return _lowDiff>0; };
   double IsHigherHigh() { return _highDiff>0; };
   double IsLowerHigh() { return _highDiff<0; };
   // Engulfing
  };
//+------------------------------------------------------------------+
