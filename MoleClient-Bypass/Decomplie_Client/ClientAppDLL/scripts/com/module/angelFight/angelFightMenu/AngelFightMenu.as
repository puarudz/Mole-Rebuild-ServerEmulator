package com.module.angelFight.angelFightMenu
{
   import com.common.popUpMenu.PopUpMenu;
   import com.module.angelFight.AngelFightMain;
   
   public class AngelFightMenu
   {
      
      public function AngelFightMenu()
      {
         super();
      }
      
      public static function ClearClickMenu(mc:*) : void
      {
         PopUpMenu.ClearClickMenu(mc);
      }
      
      public static function SetClickMenu(mc:*, items:Array) : void
      {
         AngelFightMain.instance.GetClass("menu_mc");
         PopUpMenu.SetClickMenu(mc,items,null);
      }
   }
}

