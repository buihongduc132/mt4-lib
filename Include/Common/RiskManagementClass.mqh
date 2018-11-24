//+------------------------------------------------------------------+
//|                                          RiskManagementClass.mqh |
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

input string __riskManagementConfig="--- Risk management Configuration ---"; // Risk management Configuration
input double            winInWinStreak=4;
input double            lossInWinStreak = 1;
input double            winInLossStreak = 2;
input double            lossInLossStreak= 3;
input double inputConsecutiveAdjustment;
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
class RiskManagementClass
  {
protected:
   ENUM__RISK_BASED  riskBased;
   ENUM__RISK_MODE   riskMode;

   int               previousTicket;

   int               magicNumber;
   string            symbol;
   double            lastResult;

   //double            consecutiveResultMoney;

   datetime          lastTradeOpen;
   datetime          lastTradeClosed;

   double            riskPercentage;

   double            consecutiveTowardScore;
   double            consecutiveAgainstScore;
   double            consecutiveAdjustment;

   double            currentConsecutiveScore;

   double            fixedVolume;
   double            fixedTpPips;
   double            fixedSlPips;

   double            GetTickValue();
   double            GetBaseAmount();

   int               GetLatestOrderTicket();

   void              AdjustConsecutiveSteps();
   void              InitDefaultParams();
public:
                     RiskManagementClass(string _symbol,int _magicNumber,double _fixedVolume,double _fixedSlPips,double _fixedTpPips);
                     RiskManagementClass(string _symbol,int _magicNumber,double _riskPercentage,ENUM__RISK_BASED _riskBased);

   double            GetPips(double volume);
   double            GetVolume(double pips);

   double            GetFixedVolume();
   double            GetFixedSl();
   double            GetFixedTp();
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagementClass::AdjustConsecutiveSteps()
  {

   double profit=0.0;
   int ticket=EMPTY_VALUE;

   for(int i=OrdersHistoryTotal()-1;i>=0 && profit==0.0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_HISTORY))
        {
         profit=OrderProfit();
         ticket= OrderTicket();
        }
     }

   if(ticket!=previousTicket)
     {
      if(currentConsecutiveScore>=0)
        {
         if(profit>0)
           {
            currentConsecutiveScore+=winInWinStreak;
           }
         else if(profit<0)
           {
            currentConsecutiveScore-=lossInWinStreak;
           }
        }
      else
        {
         if(profit>0)
           {
            currentConsecutiveScore+=winInLossStreak;
           }
         else if(profit<0)
           {
            currentConsecutiveScore-=lossInLossStreak;
           }
        }
      Print("Curren Score",currentConsecutiveScore,"--Profit",OrderProfit(),"--Totals:",OrdersHistoryTotal());
      previousTicket=ticket;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagementClass::InitDefaultParams()
  {
   currentConsecutiveScore=0;
   lastResult=EMPTY_VALUE;

   consecutiveTowardScore=1;
   consecutiveAgainstScore=3;
   consecutiveAdjustment=1.01;

  }
//+------------------------------------------------------------------+
int RiskManagementClass::GetLatestOrderTicket()
  {
   if(!OrderSelect(OrdersHistoryTotal() -1,SELECT_BY_POS,MODE_HISTORY))
     {
      return -GetLastError();
     }
   return OrderTicket();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagementClass::RiskManagementClass(string _symbol,int _magicNumber,double _fixedVolume,double _fixedSlPips,double _fixedTpPips=EMPTY_VALUE)
  {
   symbol=_symbol;
   magicNumber=_magicNumber;
   riskMode=_RISK_MODE_FIXED;
   fixedSlPips = _fixedSlPips;
   fixedVolume = _fixedVolume;
   fixedTpPips = _fixedTpPips == EMPTY_VALUE ? _fixedSlPips : _fixedTpPips;

   InitDefaultParams();

  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void RiskManagementClass::RiskManagementClass(string _symbol,int _magicNumber,
                                              double _riskPercentage,
                                              ENUM__RISK_BASED _riskBased=_RISK_BASED_EQUITY)
  {
   symbol=_symbol;
   magicNumber=_magicNumber;
   riskBased=_riskBased;
   riskPercentage=_riskPercentage;
   riskMode=_RISK_MODE_DYNAMIC;

   InitDefaultParams();
  }
//+------------------------------------------------------------------+

double RiskManagementClass::GetFixedSl(void)
  {
   return fixedSlPips;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagementClass::GetFixedTp(void)
  {
   return fixedTpPips;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagementClass::GetFixedVolume(void)
  {
   return fixedVolume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagementClass::GetPips(double volume=1)
  {
   return riskMode==_RISK_MODE_FIXED ? GetFixedSl() : GetBaseAmount()*riskPercentage/GetTickValue()/volume;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagementClass::GetVolume(double pips=1)
  {
   AdjustConsecutiveSteps();
   double value=riskMode==_RISK_MODE_FIXED ? GetFixedVolume() : GetBaseAmount()*riskPercentage/GetTickValue()/pips*MathPow(inputConsecutiveAdjustment,currentConsecutiveScore);

   return NormalizeDouble(value, 2);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double RiskManagementClass::GetTickValue(void)
  {
   return MarketInfo(symbol,MODE_TICKVALUE);
  }
//+------------------------------------------------------------------+

double RiskManagementClass::GetBaseAmount()
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
