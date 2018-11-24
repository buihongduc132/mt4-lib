//+------------------------------------------------------------------+
//|                                              FileHelperClass.mqh |
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

string __fileLineSeparator="~";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
enum ENUM__FILE_WRITE_MODE
  {
   _FILE_WRITE_MODE_BEGIN,
   _FILE_WRITE_MODE_CURRENT,
   _FILE_WRITE_MODE_APPEND,
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class FileHelperClass
  {
public:
   string            _filename;
   string            _path;
   int               _mode;
   int               _fileHandler;
   string            _delimiter;
   uint              _codepage;

   string _GetFullName() { return _path+"\\"+_filename; };
   void              _AssignConfigAfterOpen(int mode,int delimiter,uint codepage);

   void              _InitInfo(string filename,string path);
   void _ResetSeekPointer() { FileSeek(_fileHandler,0,SEEK_SET); };
                    ~FileHelperClass() { _Close(); };
                     FileHelperClass(string filename=NULL,int mode=FILE_READ,string path=NULL,int delimiter=-1,uint codepage=CP_ACP,bool openNow=false)
     {
      _InitInfo(filename,path);
      if(openNow)
         _Open(mode,delimiter,codepage);
      else
        {
         _AssignConfigAfterOpen(mode,delimiter,codepage);
        }
     }

   void              _Seek(long offset,ENUM_FILE_POSITION origin) { FileSeek(_fileHandler,offset,origin); };
   void              _Open() { _Open(_mode,_delimiter,_codepage); };
   void              _Open(int mode,int delimiter=-1,uint codepage=CP_ACP);
   void              _Close() { FileClose(_fileHandler); };

   bool              IsValid() { return _fileHandler==INVALID_HANDLE; };
   void              Write(string data,ENUM__FILE_WRITE_MODE mode);
   string            ReadAllText(bool isSeparateLine);
   int               ReadTextByLine(string &result[]);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FileHelperClass::_Open(int mode,int delimiter=-1,uint codepage=0)
  {
   _fileHandler=FileOpen(_GetFullName(),mode,delimiter,codepage);
   _AssignConfigAfterOpen(mode,delimiter,codepage);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FileHelperClass::_AssignConfigAfterOpen(int mode,int delimiter,uint codepage)
  {
   _mode=mode;
   _delimiter= delimiter;
   _codepage = codepage;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int FileHelperClass::ReadTextByLine(string &result[])
  {
   _ResetSeekPointer();

   int size=0;
   string data="";

   while(!FileIsEnding(_fileHandler))
     {
      data+=FileReadString(_fileHandler);;

      if(FileIsLineEnding(_fileHandler))
        {
         size++;
         if(size>ArraySize(result))
           {
            ArrayResize(result,size,100);
           }
         result[size-1]=data;
         data="";
        }
     }
   return size;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
string FileHelperClass::ReadAllText(bool isSeparateLine=false)
  {
   _ResetSeekPointer();

   string data="";
   while(!FileIsEnding(_fileHandler))
     {
      data+=FileReadString(_fileHandler,0);
      if(isSeparateLine)
        {
         data+=__fileLineSeparator;
        }
     }
   return data;
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void FileHelperClass::_InitInfo(string filename=NULL,string path=NULL)
  {
   _filename=filename==NULL ? MathRand()+TimeCurrent() : filename;
   _path=path==NULL ? "custom files" : path;
  }
//+------------------------------------------------------------------+

void              FileHelperClass::Write(string data,ENUM__FILE_WRITE_MODE mode=_FILE_WRITE_MODE_APPEND)
  {
   if(mode==_FILE_WRITE_MODE_BEGIN)
      _Seek(0,SEEK_SET);
   if(mode==_FILE_WRITE_MODE_APPEND)
     {
      _Close();
      _Open(FILE_READ|FILE_WRITE,_delimiter,_codepage);
      _Seek(0,SEEK_END);
     }
   FileWrite(_fileHandler,data);
  }
//+------------------------------------------------------------------+
