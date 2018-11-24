//+------------------------------------------------------------------+
//|                                          NtnTrendingPullback.mqh |
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

#include "..\EnumClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM__SIGNAL_TYPE
  {
   _ENUM__SIGNAL_TYPE_START_SIGNAL,
   _ENUM__SIGNAL_TYPE_END_SIGNAL,
   _ENUM__SIGNAL_TYPE_INVALID_SIGNAL,
   _ENUM__SIGNAL_TYPE_NONE_SIGNAL=EMPTY_VALUE
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NtnTrendingPullbackSignalTypeEnum
  {
public:
   ENUM__SIGNAL_TYPE START;
   ENUM__SIGNAL_TYPE END;
   ENUM__SIGNAL_TYPE NONE;
   ENUM__SIGNAL_TYPE INVALID;
                    ~NtnTrendingPullbackSignalTypeEnum() {};
                     NtnTrendingPullbackSignalTypeEnum()
     {
      this.START=_ENUM__SIGNAL_TYPE_START_SIGNAL;
      this.END=_ENUM__SIGNAL_TYPE_END_SIGNAL;
      this.NONE=_ENUM__SIGNAL_TYPE_NONE_SIGNAL;
      this.INVALID=_ENUM__SIGNAL_TYPE_INVALID_SIGNAL;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct NTN_TrendingAndZigzagFiboMode
  {
   int               _FIBO_HIGH;
   int               _FIBO_LOW;
   int               _TREND_BULL;
   int               _TREND_BEAR;
   int               _RETRACED;
   int               _FIBO_MID;
   int               _EXTRENUM_HIGH;
   int               _EXTRENUM_LOW;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct NTN_ZigzagFiboMode
  {
   int               _ALL;
   int               _HIGH;
   int               _LOW;
   int               _TREND;

   int               _FIBO_HIGH;
   int               _FIBO_LOW;

   int               _EXTRENUM_HIGH;
   int               _EXTRENUM_LOW;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
struct NTN_TrendingMode
  {
   int               _BULL_TREND;
   int               _BULL_OUTSIDE;
   int               _BEAR_TREND;
   int               _BEAR_OUTSIDE;
   int               _ANCHOR;
   int               _BULL_SIGNAL;
   int               _BEAR_SIGNAL;
  };
//+------------------------------------------------------------------+

struct RonenBen_Impulse_Indicator
  {
   int               _PIVOT_LOW;
   int               _PIVOT_HIGH;

   int               _IMPULSE_START_PRICE;
   int               _IMPULSE_END_PRICE;

   int               _IMPULSE_START_TIME;
   int               _IMPULSE_END_TIME;
  };

NTN_ZigzagFiboMode ntn_ZigzagFiboMode={0,1,2,3,4,5,6,7};
NTN_TrendingMode ntn_TrendingMode={0,1,2,4,5,6,7};
NTN_TrendingAndZigzagFiboMode ntn_TrendingAndZigzagFiboMode={0,1,2,3,4,5,6,7};
RonenBen_Impulse_Indicator ronenben_Impulse_IndicatorMode={0,1,2,3,4,5};
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NtnTrendingPullbackModeEnum
  {
public:
   int               FIBO_HIGH;
   int               FIBO_LOW;
   int               PIVOT_HIGH;
   int               PIVOT_LOW;
   int               BULL;
   int               BEAR;

   int               BULL_SLOW;
   int               BEAR_SLOW;

                    ~NtnTrendingPullbackModeEnum() { };
                     NtnTrendingPullbackModeEnum()
     {
      FIBO_HIGH=0;
      FIBO_LOW=1;

      BULL=2;
      BEAR=3;

      PIVOT_HIGH=4;
      PIVOT_LOW=5;

      BULL_SLOW=6;
      BEAR_SLOW=7;
     }
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NtnTrendingPullbackStatusModeEnum
  {
public:

   int               ALERT_SIGNAL;
   int               DASHBOARD_ON;
   int               TREND;

   int               ALERT_SIGNAL_VALUE;
   int               DASHBOARD_ON_VALUE;

   int               PIVOT_HIGH;
   int               PIVOT_LOW;

  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class NtnTrendingPullbackEnum : public CustomEnum
  {
public:
   NtnTrendingPullbackModeEnum *MODE;
   NtnTrendingPullbackSignalTypeEnum*SIGNAL;
                    ~NtnTrendingPullbackEnum()

     {
      delete MODE;
      delete SIGNAL;
     };
                     NtnTrendingPullbackEnum()
     {
      SIGNAL=new NtnTrendingPullbackSignalTypeEnum();
      MODE=new NtnTrendingPullbackModeEnum();
     }
  };
//+------------------------------------------------------------------+

NtnTrendingPullbackEnum INDICATOR_ENUM();
//+------------------------------------------------------------------+
