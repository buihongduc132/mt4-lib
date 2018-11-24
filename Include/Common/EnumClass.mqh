//+------------------------------------------------------------------+
//|                                                    EnumClass.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict

#include "IndicatorEnumClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

enum ENUM__ORDER_COMMAND
  {
   _ENUM__ORDER_TYPE_BUY=OP_BUY,
   _ENUM__ORDER_TYPE_SELL=OP_SELL
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM__TRENDING
  {
   _ENUM__TRENDING_BULL = 1,
   _ENUM__TRENDING_BEAR = -1,
   _ENUM__TRENDING_NONE=0
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class OrderEnum
  {
public:
   ENUM__ORDER_COMMAND BUY;
   ENUM__ORDER_COMMAND SELL;

   void OrderEnum()
     {
      BUY=_ENUM__ORDER_TYPE_BUY;
      SELL=_ENUM__ORDER_TYPE_SELL;
     }
   void ~OrderEnum() {};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class TrendEnum
  {
public:
   ENUM__TRENDING    BULL;
   ENUM__TRENDING    BEAR;
   ENUM__TRENDING    NONE;

   void TrendEnum()
     {
      BULL = _ENUM__TRENDING_BULL;
      BEAR = _ENUM__TRENDING_BEAR;
      NONE = _ENUM__TRENDING_NONE;
     }
   void ~TrendEnum() {};
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CustomEnum
  {
public:
   TrendEnum         TREND;
   OrderEnum         ORDER;
   void CustomEnum()
     {
     };
   void ~CustomEnum()
     {
     };
  };

CustomEnum ENUM();
//+------------------------------------------------------------------+
