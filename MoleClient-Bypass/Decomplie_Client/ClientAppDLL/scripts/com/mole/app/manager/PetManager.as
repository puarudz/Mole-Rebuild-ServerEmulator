package com.mole.app.manager
{
   import com.common.Alert.Alert;
   import com.common.Alert.type.AlertType;
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.petSocket.adoptPet.petNumReq;
   import com.logic.socket.petSocket.adoptPet.petNumRes;
   import com.mole.app.map.MapManager;
   import com.view.PeopleView.PeopleManageView;
   import flash.events.Event;
   
   public class PetManager
   {
      
      public function PetManager()
      {
         super();
      }
      
      public static function checkCarryPet(tipStr:String, autoGuide:Boolean = true) : Boolean
      {
         var getPetCountBack:Function = null;
         if(!PeopleManageView(GV.MAN_PEOPLE).Petlevel)
         {
            if(autoGuide)
            {
               getPetCountBack = function(evt:EventTaomee):void
               {
                  var lamuCount:uint;
                  GV.onlineSocket.removeEventListener(petNumRes.GET_PETNUM_SUCC,getPetCountBack);
                  lamuCount = uint(evt.EventObj.Count);
                  if(lamuCount > 0)
                  {
                     Alert.angryAlart(tipStr + "是否現在去小屋中攜帶拉姆？",function(e:Event):void
                     {
                        MapManager.enterMap(LocalUserInfo.getUserID(),2);
                     },AlertType.SURE + "," + AlertType.CANCEL);
                  }
                  else
                  {
                     Alert.angryAlart(tipStr + "是否現在去寵物店購買屬於自己的拉姆？",function(e:Event):void
                     {
                        MapManager.enterMap(21);
                     },AlertType.SURE + "," + AlertType.CANCEL);
                  }
               };
               GV.onlineSocket.addEventListener(petNumRes.GET_PETNUM_SUCC,getPetCountBack);
               petNumReq.sendNumReq(LocalUserInfo.getUserID());
            }
            return false;
         }
         return true;
      }
   }
}

