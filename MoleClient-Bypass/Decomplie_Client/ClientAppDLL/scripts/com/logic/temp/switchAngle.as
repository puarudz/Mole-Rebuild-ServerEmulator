package com.logic.temp
{
   import com.core.MainManager;
   import com.module.farm.IAnimal;
   import com.module.lamuPkSys.LamuPkMainControler;
   import com.module.loadExtentPanel.LoadGame;
   
   public class switchAngle
   {
      
      private static var _instance:switchAngle;
      
      private static var _animal:IAnimal;
      
      public function switchAngle()
      {
         super();
      }
      
      public static function get instance() : switchAngle
      {
         if(!_instance)
         {
            _instance = new switchAngle();
         }
         return _instance;
      }
      
      public function init() : void
      {
         var msg:String = new String();
         _animal = LamuPkMainControler._animalSkillControler.animal;
         if(!_animal)
         {
            this.begainAllSwitch();
            return;
         }
         if(_animal.Level > 3)
         {
            this.begainSwitch();
            return;
         }
         msg = "    只有成年的聖光獸，才有可能蛻變為天使哦。";
      }
      
      private function begainAllSwitch() : void
      {
         new LoadGame("module/external/angelPark/AllAnimalSwitchAngleMain.swf","正在打開......",MainManager.getAppLevel());
      }
      
      private function begainSwitch() : void
      {
         new LoadGame("module/external/AnimalSwitchAngle.swf","正在打開......",MainManager.getAppLevel());
      }
   }
}

