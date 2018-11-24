//+------------------------------------------------------------------+
//|                                                    MenuClass.mqh |
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

#include "_GUILib.mqh";
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Menu
  {

protected:
   int               hwnd;
   int               menuHandle;
   int               parentId;
   int               flags;
   string            menuName;
public:
                     Menu(string _menuName,int _hwnd,string _label,int _parentId,int _isCheckbox);
   int               SetText(string NewLabel) { return guiSetMenuText(hwnd,menuHandle,NewLabel); };
   int               SetTextColor(int Color) { return guiSetMenuTextColor(hwnd,menuHandle,Color); };
   int               SetBgColor(int Color) { return guiSetMenuBgColor(hwnd,menuHandle,Color); };
   bool              IsClicked() { return guiIsMenuClicked(hwnd,menuHandle); };
   bool              IsChecked() { return guiIsMenuChecked(hwnd,menuHandle); };
   int               Check(int Status) { return guiCheckMenu(hwnd,menuHandle,Status); };
   int               Enable(int Status) { return guiEnableMenu(hwnd,menuHandle,Status); };
   int               CreateChild(string _menuName,string _label,int _isCheckbox);

   int               GetMenuHandle() { return menuHandle; };
   string               GetMenuName() { return menuName; };

   Menu             *childMenu[];
   Menu             *GetMenu(string name);

   void             ~Menu();
  };
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Menu *Menu::GetMenu(string _menuName)
  {
   for(int i=0; i<ArraySize(childMenu); i++)
     {
      if(childMenu[i].GetMenuName()==_menuName)
        {
         return childMenu[i];
        }
     }

   return NULL;
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

void Menu::Menu(string _menuName,int _hwnd,string _label,int _parentId=0,int _isCheckbox=0)
  {
   hwnd=_hwnd;
   parentId=_parentId;
   menuName=_menuName;
   menuHandle=guiAddMenu(_hwnd,_label,_parentId,_isCheckbox); // Flags=1 -> Checkbox // Done
   guiSetName(_hwnd,menuHandle,"MENU"+_menuName);
  }
//+------------------------------------------------------------------+

int Menu::CreateChild(string _menuName,string _label="",int _isCheckbox=0)
  {
   if(_label=="")
      _label=_menuName;

   int size=ArraySize(childMenu);

   ArrayResize(childMenu,size+1);

   childMenu[size]=new Menu(_menuName,hwnd,_label,menuHandle,_isCheckbox);

   return childMenu[size].GetMenuHandle();
  }
//+------------------------------------------------------------------+

void Menu::~Menu()
  {
     {
      for(int i=0; i<ArraySize(childMenu); i++)
        {
         delete childMenu[i];
        }
     };
  }
//+------------------------------------------------------------------+
