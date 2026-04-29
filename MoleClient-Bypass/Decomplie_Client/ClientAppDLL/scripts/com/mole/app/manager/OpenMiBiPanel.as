package com.mole.app.manager
{
   import com.mole.app.type.ModuleType;
   
   public class OpenMiBiPanel
   {
      
      public function OpenMiBiPanel()
      {
         super();
      }
      
      public static function setUp() : void
      {
         ModuleManager.openPanel(ModuleType.Win_Million_MiBi_Panel);
      }
   }
}

