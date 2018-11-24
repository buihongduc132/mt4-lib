//+------------------------------------------------------------------+
//|                                           _CommonObjectClass.mqh |
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

class CommonObjectClass
  {

protected:
   string            ModuleName;
   long              chartId;
   bool              isIndividual;

   string GenerateName(datetime time1,double price1,datetime time2,double price2,string type="NONE")
     {
      return GenerateName(time1*time2,price1*price2,type);
     }

   string GenerateName(datetime time,double price,string type="NONE")
     {
      string name=StringSubstr(StringFormat("%s%s (X%s)(Y%.3f) %d%d%d",ModuleName,type,TimeToStr(time),price,rand(),rand(),rand()),0,63);

      return name;
     }
                     CommonObjectClass(string parentName,long _chartId,bool _isIndividual=false)
     {
      ModuleName=parentName;
      chartId=_chartId;
      initProperties();
      isIndividual=_isIndividual;
     }

   void initProperties()
     {
      objectId=EMPTY_VALUE;
      objectName=NULL;
     }

public:
   int               objectId;
   string            objectName;

                    ~CommonObjectClass()
     {
      Delete();
     };

   static bool Delete(CommonObjectClass *that)
     {
      if(CheckPointer(that))
        {
         return that.Delete();
        }
      return false;
     }

   virtual CommonObjectClass    *Create()
     {
      return GetPointer(this);
     }

   bool Delete()
     {
      bool isDeleted=ObjectDelete(chartId,objectName);
      if(isDeleted)
        {
         initProperties();
        }

      return isDeleted;
     }

   void NewObject()
     {
      isIndividual=true;
     }

   void RemoveOldObject()
     {
      if(isIndividual)
        {
         Delete();
        }
     }
  };
//+------------------------------------------------------------------+
