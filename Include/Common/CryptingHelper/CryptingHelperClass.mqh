//+------------------------------------------------------------------+
//|                                          CryptingHelperClass.mqh |
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

static char __hex[]=
  {
   '0','1','2','3','4','5','6','7',
   '8','9','A','B','C','D','E','F'
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class CryptingHelper
  {
   uchar             _src[],_dst[],_key[];
   string            _keyString;
   ENUM_CRYPT_METHOD _cryptingMode;

   string IntegerToHexString(uint num)
     {
      int len=0,k=0;
      char buff[64];
      do
        {
         uint n=num&0xF;
         buff[len]=__hex[n];
         len++;
         num>>=4;
        }
      while(num!=0);

      for(;k<len/2;k++)
        {
         buff[k]^=buff[len-k-1];
         buff[len-k-1]^=buff[k];
         buff[k]^=buff[len-k-1];
        }
      return CharArrayToString(buff,0,len);
     }

   string ArrayToHex(uchar &arr[],int count=-1)
     {
      string res="";
      //--- check
      if(count<0 || count>ArraySize(arr))
         count=ArraySize(arr);
      //--- transform to HEX string
      for(int i=0; i<count; i++)
         res+=StringFormat("%.2X",arr[i]);
      //---
      return(res);
     }
   void _InitDefaultData(ENUM_CRYPT_METHOD mode,string keyString)
     {
      _keyString=keyString;
      _cryptingMode=mode;
      StringToCharArray(_keyString,_key);
     }
public:
                     CryptingHelper(ENUM_CRYPT_METHOD mode=CRYPT_HASH_MD5,string keyString="Default Key String")
     {
      _InitDefaultData(mode,keyString);
     };

                     CryptingHelper(string encryptedData,ENUM_CRYPT_METHOD mode=CRYPT_HASH_MD5,string keyString="Default Key String")
     {
      _InitDefaultData(mode,keyString);
      //TODO: NOT YET IMPLEMENTED
     };

   string Encrypt(string data)
     {
      StringToCharArray(data,_src);
      CryptEncode(_cryptingMode,_src,_key,_dst);
      return GetEncryptedData();
     }

   string Decrypt()
     {
      CryptDecode(_cryptingMode,_dst,_key,_src);
      return GetDecryptedData();
     }

   static CryptingHelper *Decrypt(string encryptedData,ENUM_CRYPT_METHOD mode=CRYPT_HASH_MD5,string keyString="Default Key String")
     {
      CryptingHelper *crypting=new CryptingHelper(encryptedData,mode,keyString);
      return GetPointer(crypting);
     }

   string GetEncryptedData() { return ArrayToHex(_dst); };
   string GetDecryptedData() { return CharArrayToString(_src); };
   //+------------------------------------------------------------------+
  };
//+------------------------------------------------------------------+
