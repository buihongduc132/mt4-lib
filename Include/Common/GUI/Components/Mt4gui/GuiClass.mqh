//+------------------------------------------------------------------+
//|                                                     GuiClass.mqh |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link "https://www.mql5.com"
#property strict

#include "_GUILib.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GUI_OBJECT_TYPE
  {
public:
   static const string BUTTON;
   static const string CHECKBOX;
   static const string LIST;
   static const string LABEL;
   static const string TEXT;
   static const string LINK;
   static const string RADIO;
   static const string IMAGE;

   void GUI_OBJECT_TYPE(){};
   void ~GUI_OBJECT_TYPE(){};
  };
//+------------------------------------------------------------------+

string const GUI_OBJECT_TYPE::BUTTON="button";
string const GUI_OBJECT_TYPE::CHECKBOX="checkbox";
string const GUI_OBJECT_TYPE::LIST="list";
string const GUI_OBJECT_TYPE::LABEL= "label";
string const GUI_OBJECT_TYPE::TEXT = "text";
string const GUI_OBJECT_TYPE::LINK = "link";
string const GUI_OBJECT_TYPE::RADIO = "radio";
string const GUI_OBJECT_TYPE::IMAGE = "image";
//int guiAdd(int hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label); // Done

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GuiObjectAttribute
  {
protected:
   int               hwnd;
   int               objectHandle;
   string            objectName;
   string            type;

public:
                     GuiObjectAttribute(int _hwnd,int _ObjectHandle,string _objectName,string _type)
     {

      hwnd=_hwnd;
      objectHandle=_ObjectHandle;
      objectName=_objectName;
      type=_type;
     }
                    ~GuiObjectAttribute(){};

   int               guiAppendTextPart(int hwnd,int ObjectHandle,string Text,int FontSize,string FontName,int Position);
   // Getter
   string Name() { return objectName; };
   string GetName() { return guiGetName(hwnd,objectHandle); };
   int GetWidth() { return guiGetWidth(hwnd,objectHandle); };
   int GetHeight() { return guiGetHeight(hwnd,objectHandle); };
   bool IsEnabled() { return guiIsEnabled(hwnd,objectHandle); };
   int GetType() { return guiGetType(hwnd,objectHandle); };
   string GetText() { return guiGetText(hwnd,objectHandle); };
   // events
   // END Getter

   // Setter
   int SetText(string NewText,int FontSize=14,string Fontname="Arial") { return guiSetText(hwnd,objectHandle,NewText,FontSize,Fontname); };
   int SetName(string NameOfObject)
     {
      objectName=NameOfObject;
      return guiSetName(hwnd, objectHandle, NameOfObject);
     };
   int SetChecked(int State) { return guiSetChecked(hwnd,objectHandle,State); };
   int SetPos(int X,int Y) { return guiSetPos(hwnd,objectHandle,X,Y); };
   int SetSize(int Width,int Height) { return guiSetSize(hwnd,objectHandle,Width,Height); };
   int AppendText(string Text,int FontSize=14,string FontName="Arial",int Position=1) { return guiAppendTextPart(hwnd,objectHandle,Text,FontSize,FontName,Position); };
   int SetShortcut(string Shortcut) { return guiSetShortcut(hwnd,objectHandle,Shortcut); };
   // END Setter
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GuiObjectStyle
  {
protected:
   int               hwnd;
   int               objectHandle;
   string            objectName;
   string            type;

public:
                     GuiObjectStyle(int _hwnd,int _ObjectHandle,string _objectName,string _type)
     {
      hwnd=_hwnd;
      objectHandle=_ObjectHandle;
      objectName=_objectName;
      type=_type;
     }
                    ~GuiObjectStyle(){};
   //~~~~~~~ colors for Objects
   int SetBgColor(int Color) { return guiSetBgColor(hwnd,objectHandle,Color); };
   int SetTextColor(int Color) { return guiSetTextColor(hwnd,objectHandle,Color); };

   // New functions for buttons only
   int SetBorderRadius(int Radius) { return guiSetBorderRadius(hwnd,objectHandle,Radius); };
   int SetBorderColor(int BorderColor) { return guiSetBorderColor(hwnd,objectHandle,BorderColor); };
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class GuiObject
  {
protected:
   int               hwnd;
   int               objectHandle;
   string            objectType;
   string            objectName;
   int               x;
   int               y;
   int               width;
   int               height;
   int               hideOffset;
   int               panelId;

   void              __Init__(string _objectName,int hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label,int _panelId);
public:
   void Remove()
     {
      guiRemove(hwnd,objectHandle);
     }
   void Hide()
     {
      attr.SetPos(x*hideOffset,y*hideOffset);
     }
   int PanelId() { return panelId; };
   void Show()
     {
      attr.SetPos(x,y);
     }
   GuiObjectAttribute *attr;
   GuiObjectStyle   *style;
                     GuiObject(string _objectName,int hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label,int _panelId);
                     GuiObject(string _objectName,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label,int _panelId,string symbol,int timeframe);
                    ~GuiObject()
     {
      delete attr;
      delete style;
     };

   bool IsClicked() { return guiIsClicked(hwnd, objectHandle); };
   bool IsChecked() { return guiIsChecked(hwnd, objectHandle); };
   int Enable() { return guiEnable(hwnd,objectHandle,1); };
   int Disable() { return guiEnable(hwnd,objectHandle,0); };

   int HandlerId() { return objectHandle; };
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiObject::__Init__(string _objectName,int _hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label,int _panelId)
  {
   hideOffset=9999;

   panelId=_panelId;

   objectName = _objectName;
   objectType = Type;
   if(Label== "")
      Label= _objectName;

   x = X;
   y = Y;
   width=WIDTH;
   height=HEIGHT;

   hwnd=_hwnd;

   objectHandle=guiAdd(_hwnd,Type,X,Y,WIDTH,HEIGHT,Label);
   attr=new GuiObjectAttribute(hwnd,objectHandle,objectName,Type);
   style=new GuiObjectStyle(hwnd,objectHandle,objectName,Type);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiObject::GuiObject(string _objectName,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label="",int _panelId=0,string _symbol=EMPTY,int _timeframe=EMPTY)
  {
   if(_timeframe== EMPTY)
      _timeframe=Period();
   if(_symbol== EMPTY)
      _symbol=Symbol();

   int _hwnd=WindowHandle(_symbol,_timeframe);

   __Init__(_objectName,_hwnd,Type,X,Y,WIDTH,HEIGHT,Label,_panelId);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiObject::GuiObject(string _objectName,int _hwnd,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label="",int _panelId=0)
  {
   __Init__(_objectName,_hwnd,Type,X,Y,WIDTH,HEIGHT,Label,_panelId);
  }
//+------------------------------------------------------------------+
