//+------------------------------------------------------------------+
//|                                          RiskManagerClass.mqh |
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

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM__RISK_BASED
  {
   _RISK_BASED_BALANCE,
   _RISK_BASED_EQUITY
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM__RISK_MODE
  {
   _RISK_MODE_FIXED,
   _RISK_MODE_DYNAMIC
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class RiskManagerClass
  {
protected:

   int               previousTicket;

   string            symbol;

   double            fixedVolume;
   double            fixedTpPips;
   double            fixedSlPips;

   double            GetTickValue();
   double            GetBaseAmount();
public:
                     RiskManagerClass(string _symbol,double _fixedVolume,double _fixedSlPips,double _fixedTpPips);
                     RiskManagerClass(string _symbol,double _riskPercentage,ENUM__RISK_BASED _riskBased);

   double            GetPips(double volume);
   double            GetVolume(double pips);

   double            GetFixedVolume();
   double            GetFixedSl();
   double            GetFixedTp();

   ENUM__RISK_BASED  riskBased;
   ENUM__RISK_MODE   riskMode;
   double            riskPercentage;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagerClass::RiskManagerClass(string _symbol,double _fixedVolume,double _fixedSlPips,double _fixedTpPips=EMPTY_VALUE)
  {
   symbol=_symbol;
   riskMode=_RISK_MODE_FIXED;
   fixedSlPips = _fixedSlPips;
   fixedVolume = _fixedVolume;
   fixedTpPips = _fixedTpPips == EMPTY_VALUE ? _fixedSlPips : _fixedTpPips;

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagerClass::RiskManagerClass(string _symbol,
                                        double _riskPercentage,
                                        ENUM__RISK_BASED _riskBased=_RISK_BASED_EQUITY)
  {
   symbol=_symbol;
   riskBased=_riskBased;
   riskPercentage=_riskPercentage;
   riskMode=_RISK_MODE_DYNAMIC;
  }
//+------------------------------------------------------------------+

double RiskManagerClass::GetFixedSl(void)
  {
   return fixedSlPips;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagerClass::GetFixedTp(void)
  {
   return fixedTpPips;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagerClass::GetFixedVolume(void)
  {
   return fixedVolume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagerClass::GetPips(double volume=1)
  {
   return riskMode==_RISK_MODE_FIXED ? GetFixedSl() : GetBaseAmount()*riskPercentage/GetTickValue()/volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagerClass::GetVolume(double pips=1)
  {
   double value=riskMode==_RISK_MODE_FIXED ? GetFixedVolume() : GetBaseAmount()*riskPercentage/GetTickValue()/pips;

   return NormalizeDouble(value, 2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagerClass::GetTickValue(void)
  {
   return MarketInfo(symbol,MODE_TICKVALUE);
  }
//+------------------------------------------------------------------+

double RiskManagerClass::GetBaseAmount()
  {
   switch(riskBased)
     {
      case _RISK_BASED_BALANCE:
        {
         return AccountBalance();
         break;
        }
      case _RISK_BASED_EQUITY:
        {
         return AccountEquity();
         break;
        }
      default:
        {
         return AccountEquity();
         break;
        }
     }
  }
//+------------------------------------------------------------------+
