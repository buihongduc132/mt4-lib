//+------------------------------------------------------------------+
//|                                          PointerManagerClass.mqh |
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

class PointerManagerClass
  {
private:
   PointerManagerClass *pointers[];
public:
   PointerManagerClass *AddObject(PointerManagerClass *object)
     {
      int size=ArraySize(pointers);
      ArrayResize(pointers,size+1);

      pointers[size]=object;

      return pointers[size];
     }
   void RemoveAll()
     {

      for(int i=0; i<ArraySize(pointers); i++)
        {
         delete pointers[i];
        }
     }
  };
//+------------------------------------------------------------------+

class TestClass : public PointerManagerClass
  {
public:
                     TestClass() {};

  };
//+------------------------------------------------------------------+
