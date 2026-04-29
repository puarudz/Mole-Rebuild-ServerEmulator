package com.mole.app.task.specific
{
   public class Task541 extends TaskSpecific
   {
      
      private static var _inst:Task541;
      
      public function Task541()
      {
         super(541);
      }
      
      public static function get inst() : Task541
      {
         if(_inst == null)
         {
            _inst = new Task541();
         }
         return _inst;
      }
   }
}

