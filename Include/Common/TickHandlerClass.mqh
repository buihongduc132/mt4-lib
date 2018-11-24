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

class TickHandle
  {
protected:
   datetime          previousCheckTime;
public:
   void              TickHandle();
   bool              IsNewBar();
   bool              IsNewBar(datetime time);
   bool              IsGap(int index);
   bool              IsNSecondsPass(uint seconds,datetime time);
  };
//+------------------------------------------------------------------+

bool TickHandle::IsNSecondsPass(uint seconds,datetime time=EMPTY_VALUE)
  {
   if(time==EMPTY_VALUE)
      time=TimeCurrent();
   uint secondsPassed=(uint)(time-previousCheckTime-1);
//Print(secondsPassed, " seconds passed");
   if(secondsPassed>seconds)
     {
      previousCheckTime=time;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void TickHandle::TickHandle(void)
  {
   previousCheckTime=0;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TickHandle::IsNewBar()
  {
   return this.IsNewBar(Time[0]);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TickHandle::IsNewBar(datetime time)
  {
   if(time!=previousCheckTime)
     {
      previousCheckTime=time;
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
bool TickHandle::IsGap(int i)
  {
//Print(i);
   if(i>=Bars-1)
     {
      return false;
     }
   if((High[i]>High[i+1] && Low[i]>High[i+1]) || (High[i]<Low[i+1] && Low[i]<Low[i+1]))
     {
      return true;
     }
   return false;
  }
//+------------------------------------------------------------------+
