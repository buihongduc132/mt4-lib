//+------------------------------------------------------------------+
//|                                           SambleGUIDashboard.mq4 |
//|                        Copyright 2018, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property indicator_chart_window


#include "Components\Mt4Gui\MenuClass.mqh";
#include "Components\Mt4Gui\GuiClass.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

class GuiDashboardClass
  {
protected:
   int               hwnd;
   void              RemoveAll() { guiRemoveAll(hwnd); };
   void              CleanUp() { guiCleanup(hwnd); };
   int               hideOffset;
   GuiObject        *objects[];
   Menu             *menu[];
public:
                     GuiDashboardClass(string symbol,int timeframe);
                    ~GuiDashboardClass();
   int               AddMenu(string _menuName,string label,int flag);
   int               GuiAdd(string Type,int X,int Y,int WIDTH,int HEIGHT,string Label);

   GuiObject        *NewObject(string _objectName,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label,int _panelId);

   Menu             *GetMenu(string menuName);

   void              Hide(int panelId);
   void              Show(int panelId);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiDashboardClass::Show(int panelId=EMPTY_VALUE)
  {
   for(int i=0; i<ArraySize(objects); i++)
     {
      if(objects[i].PanelId()==panelId || panelId==EMPTY_VALUE)
         objects[i].Show();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiDashboardClass::Hide(int panelId=EMPTY_VALUE)
  {
   for(int i=0; i<ArraySize(objects); i++)
     {
      if(CheckPointer(objects[i]))
         if(objects[i].PanelId()==panelId || panelId==EMPTY_VALUE)
            objects[i].Hide();
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Menu *GuiDashboardClass::GetMenu(string menuName)
  {
   for(int i=0; i<ArraySize(menu); i++)
     {
      if(menu[i].GetMenuName()==menuName)
        {
         return menu[i];
        }
     }

   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int GuiDashboardClass::AddMenu(string _menuName,string label="",int flag=0)
  {
   if(label=="")
      label=_menuName;
   int size=ArraySize(menu);

   ArrayResize(menu,size+1);
   menu[size]=new Menu(_menuName,hwnd,label,0,flag);

   return menu[size].GetMenuHandle();
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiDashboardClass::GuiDashboardClass(string symbol,int timeframe)
  {
   hwnd=WindowHandle(symbol,timeframe);
   hideOffset=999999;
   ArrayResize(menu,0);
   ArrayResize(objects,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GuiDashboardClass::~GuiDashboardClass()
  {
   RemoveAll();
   CleanUp();

   for(int i=0; i<ArraySize(menu); i++)
     {
      delete menu[i];
     }
   for(int i=0; i<ArraySize(objects); i++)
     {
      objects[i].Remove();
      delete objects[i];
     }

   ArrayResize(objects,0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
GuiObject *GuiDashboardClass::NewObject(string _objectName,string Type,int X,int Y,int WIDTH,int HEIGHT,string Label=NULL,int _panelId=0)
  {

   int size=ArraySize(objects);
   ArrayResize(objects,size+1);

   if(Label==NULL)
      Label=_objectName;

   objects[size]=new GuiObject(_objectName,hwnd,Type,X,Y,WIDTH,HEIGHT,Label,_panelId);

   return objects[size];
  }
//+------------------------------------------------------------------+
