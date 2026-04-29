package com.module.house.vipHouse
{
   import com.core.info.LocalUserInfo;
   import com.logic.switchMapLogic.switchMapLogic;
   import flash.events.MouseEvent;
   
   public class NpcHouseIconView extends VipHouseIconView
   {
      
      public function NpcHouseIconView(icon_str:String = "")
      {
         super(icon_str);
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         if(id == LocalUserInfo.getMapID())
         {
            return;
         }
         GV.MyInfo_PrevMap = GV.MapInfo_mapID;
         LocalUserInfo.setMapID(0);
         GV.Room_DefaultRoomID = 0;
         switchMapLogic.switchMapLogicHandler(id);
      }
   }
}

