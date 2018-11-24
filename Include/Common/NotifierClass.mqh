//+------------------------------------------------------------------+
//|                                                     Notifier.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Notifier

  {
protected:
   string            moduleName;
   string            moduleFriendlyName;
   string            _symbol;
   string            _timeframe;

   string            GetMessage(string inputs);
public:
   void              Notifier(string parentModuleName,string symbol,string timeframe);
   void              Notifier(string parentModuleName,string symbol,string timeframe,datetime lastAlertTime);
   void             ~Notifier() {};
   void              _Print(string inputs);
   void              _Alert(string inputs);
   datetime          _AlertPerTime(string inputs,datetime time);

   datetime          lastAlertTime;
  };
//+------------------------------------------------------------------+

void Notifier::Notifier(string parentModuleName,string symbol,string timeframe)
  {
   _symbol=symbol;
   _timeframe= timeframe;
   moduleName="Notifier"+parentModuleName+symbol+timeframe;
   moduleFriendlyName=StringFormat("%s-%s-%s",parentModuleName,symbol,timeframe);
  }
//+------------------------------------------------------------------+

void Notifier::Notifier(string parentModuleName,string symbol,string timeframe,datetime _lastAlertTime)
  {
   _symbol=symbol;
   _timeframe= timeframe;
   moduleName="Notifier"+parentModuleName+symbol+timeframe;
   moduleFriendlyName=StringFormat("%s-%s-%s",parentModuleName,symbol,timeframe);
   this.lastAlertTime=_lastAlertTime;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void Notifier::_Alert(string inputs)
  {
   string data=GetMessage(inputs);
   Alert(data);
  }
//+------------------------------------------------------------------+

void Notifier::_Print(string inputs)
  {
   string data=GetMessage(inputs);
   Print(data);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string Notifier::GetMessage(string inputs)
  {
   return StringFormat("%s: %s",moduleFriendlyName,inputs);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
datetime Notifier::_AlertPerTime(string inputs,datetime time)
  {
   if(time!=lastAlertTime)
     {
      string data=GetMessage(inputs);
      Alert(data);
      lastAlertTime=time;
      return lastAlertTime;
     }

   return EMPTY_VALUE;
  }
//+------------------------------------------------------------------+
