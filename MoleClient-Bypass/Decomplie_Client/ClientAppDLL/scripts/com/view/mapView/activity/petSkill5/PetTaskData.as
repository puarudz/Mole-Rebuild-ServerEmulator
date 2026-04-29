package com.view.mapView.activity.petSkill5
{
   public class PetTaskData
   {
      
      public static var HIGHFLAG:Number = -2;
      
      public function PetTaskData()
      {
         super();
         GV.onlineSocket.addEventListener("contact_close",this.high_game_closeEvent);
      }
      
      private function high_game_closeEvent(evt:*) : void
      {
         GV.onlineSocket.removeEventListener("contact_close",this.high_game_closeEvent);
         HIGHFLAG = evt.EventObj.bln;
         try
         {
            GV.map_ManagerChange.refreshMap();
         }
         catch(E:*)
         {
         }
      }
   }
}

