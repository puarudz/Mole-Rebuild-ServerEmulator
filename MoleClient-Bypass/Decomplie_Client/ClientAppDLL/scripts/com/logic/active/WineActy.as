package com.logic.active
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.mapEvent.MapEvent;
   import com.logic.socket.GetItemCount.GetItemCountReq;
   import com.logic.socket.GetItemCount.GetItemCountRes;
   import com.mole.app.event.SystemEvent;
   import com.mole.app.manager.ModuleManager;
   import com.mole.app.manager.SystemEventManager;
   
   public class WineActy
   {
      
      private static var _inst:WineActy;
      
      public function WineActy()
      {
         super();
      }
      
      public static function get inst() : WineActy
      {
         if(_inst == null)
         {
            _inst = new WineActy();
         }
         return _inst;
      }
      
      public function init() : void
      {
         SystemEventManager.addEventListener("produceWine",this.produceWine);
         BC.addEvent(this,GV.onlineSocket,MapEvent.READY_CHANGE_MAP,this.onLeaveMap);
      }
      
      private function onLeaveMap(e:EventTaomee) : void
      {
         BC.removeEvent(this);
         SystemEventManager.removeEventListener("produceWine",this.produceWine);
      }
      
      private function produceWine(e:SystemEvent) : void
      {
         BC.addEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkOver);
         GetItemCountReq.getItemCount(LocalUserInfo.getUserID(),190379,2);
      }
      
      private function checkOver(e:EventTaomee) : void
      {
         BC.removeEvent(this,GV.onlineSocket,GetItemCountRes.GET_ITEMCOUNT,this.checkOver);
         var arr:Array = e.EventObj.obj.arr;
         var len:int = int(arr.length);
         if(len != 0 && arr[0].Count > 0)
         {
            ModuleManager.openPanel("WinePanel");
         }
         else
         {
            ModuleManager.openPanel("WineIntroPanel");
         }
      }
   }
}

