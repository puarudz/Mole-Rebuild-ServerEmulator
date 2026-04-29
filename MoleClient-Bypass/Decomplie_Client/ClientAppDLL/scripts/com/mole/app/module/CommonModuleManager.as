package com.mole.app.module
{
   import com.mole.app.manager.ModuleManager;
   
   public class CommonModuleManager
   {
      
      public function CommonModuleManager()
      {
         super();
      }
      
      public static function openSelectCount(itemID:uint, max:uint, tip:String = "") : AppModuleControl
      {
         return ModuleManager.openPanel("SelectCountPanel",{
            "itemID":itemID,
            "max":max,
            "tip":tip
         });
      }
   }
}

