//+------------------------------------------------------------------+
//|                                           MessageHelperClass.mqh |
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

class MessageHelper
  {
public:
   static void AddVar(string &target,string key,string varName)
     {
      target+=StringFormat("%s:{{%s}}|",key,varName);
     }
     
   static void AddValue(string &target,string key,string value)
     {
      target+=StringFormat("%s:%s|",key,value);
     }

   static void Decode(string &target,string key,string value)
     {
      StringReplace(target,"{{"+key+"}}",value);
     }

   static string Get(string message,string key)
     {
      string datas[];
      int length=StringSplit(message,'|',datas);

      for(int i=0; i<length; i++)
        {
         string keyValuePair[];
         int pairCheck=StringSplit(datas[i],':',keyValuePair);
         if(pairCheck==2)
           {
            if(keyValuePair[0]==key)
               return keyValuePair[1];
           }
        }

      return NULL;
     }

   static string Set(string message,string key,string value)
     {
      return NULL;
     }

   static string Remove(string message,string key)
     {
      return NULL;
     }
  };
//+------------------------------------------------------------------+
