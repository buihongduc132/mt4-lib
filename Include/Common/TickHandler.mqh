//+------------------------------------------------------------------+
//|                                                         aaaa.mq4 |
//|                        Copyright 2012, MetaQuotes Software Corp. |
//|                                        https://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link "https://www.metaquotes.net"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TickHandler_IsNewBar(datetime &newBarTime)
  {
   if(Time[0]!=newBarTime)
     {
      newBarTime=Time[0];
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
