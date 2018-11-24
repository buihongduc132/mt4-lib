//+------------------------------------------------------------------+
//|                                                   UtilsClass.mqh |
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

#include "EnumClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Utils
  {
public:
   static string FriendlyPeriodName(ENUM_TIMEFRAMES timeframe)
     {
      string friendlyTimeframe=EnumToString(timeframe);
      return StringSubstr(friendlyTimeframe,7,StringLen(friendlyTimeframe));
     }

   static string FriendlyTrendName(ENUM__TRENDING trend)
     {
      string friendlyName=EnumToString(trend);
      return StringSubstr(friendlyName,16,StringLen(friendlyName));
     }

   static int Limit(int rates_total,int prev_calculated,int _hardLimit=0)
     {
      int limit=0;
      if(prev_calculated==0)
        {
         limit=rates_total-1;
        }
      else
        {
         limit=rates_total-prev_calculated;
        }

      return _hardLimit == 0 ? limit : MathMin(_hardLimit, limit);
     }

   static double GetPips(double price)
     {
      return NormalizeDouble(MathPow(10,Digits)*price,Digits);
     }

   static double GetPipsValue(int pips)
     {
      return pips/MathPow(10,Digits-1);
     }

   static double GetPriceByPips(double price,int pips)
     {
      return price + GetPipsValue(pips);
     }

   static string FriendlyPositionName(ENUM_ORDER_TYPE orderCommand)
     {
      return StringSubstr(EnumToString(orderCommand), 11);
     }

   static int GetSpread(string symbol)
     {
      return (int)(GetSpreadValue(symbol)/SymbolInfoDouble(symbol,SYMBOL_POINT));
     }

   static double GetSpreadValue(string symbol)
     {
      double ask=SymbolInfoDouble(symbol,SYMBOL_ASK);
      double bid=SymbolInfoDouble(symbol,SYMBOL_BID);
      double spread=ask-bid;
      return spread;
     }

   static double GetPriceWithSpread(string symbol,ENUM_ORDER_TYPE mode,double price=0)
     {
      if(mode==OP_SELL)
         return price;

      double spread=GetSpreadValue(symbol);

      return price+spread;
     }

   static ENUM__TRENDING RevertTrend(ENUM__TRENDING trend)
     {
      if(trend == ENUM.TREND.BEAR) return ENUM.TREND.BULL;
      else if(trend == ENUM.TREND.BULL) return ENUM.TREND.BEAR;
      return ENUM.TREND.NONE;
     }

  };
//+------------------------------------------------------------------+
