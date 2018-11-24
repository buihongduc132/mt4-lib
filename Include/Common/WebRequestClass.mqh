//+------------------------------------------------------------------+
//|                                              WebRequestClass.mqh |
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
class WebRequestClass
  {
protected:
   string            url;
   string            cookie;
   string            latestDataString;
   int               timeout;

   string            _latestResultHeaders;
   string            _latestResultString;

   char              latestResult[];
   char              latestData[];
public:
                     WebRequestClass(string _url);
   bool              CheckServer();
   bool              CheckApi();
   int               Send(string method,string api,string data,string headers="");
   void              SetFixedData(string data);

   string            GetResponseBody() { return _latestResultString; };
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void WebRequestClass::WebRequestClass(string _url)
  {
   cookie=NULL;
   url=_url;
   timeout=5000;
  }
//+------------------------------------------------------------------+

int WebRequestClass::Send(string method,string api,string data="",string headers="")
  {
   _latestResultHeaders= NULL;
   _latestResultString = NULL;
   _latestResultHeaders=NULL;

   latestDataString=data;
   ArrayResize(latestData,StringToCharArray(data,latestData,0,WHOLE_ARRAY,CP_UTF8) -1);
   int result=-1;

   string destination=url+api;

   if(cookie==NULL)
      result=WebRequest(method,destination,headers,timeout,latestData,latestResult,_latestResultHeaders);

   if(result!=200)
     {
      Print("Server Error: ",GetLastError(),". Server URL: ",destination);
     }

   _latestResultString=CharArrayToString(latestResult,0,WHOLE_ARRAY,CP_UTF8);

   return result;
  }
//+------------------------------------------------------------------+
