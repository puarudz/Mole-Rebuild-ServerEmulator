package com.module.lamu
{
   import com.core.info.LocalUserInfo;
   import com.event.EventTaomee;
   import com.logic.socket.ephemeral.ephemeralDataSocket;
   import com.logic.socket.petSocket.adoptPet.petInfoReq;
   import com.logic.socket.petSocket.adoptPet.petInfoRes;
   import flash.events.Event;
   
   public class lamuGameDate
   {
      
      private static var owner:lamuGameDate;
      
      private var lamuObj:Object = new Object();
      
      private var lamuStatus:uint = 0;
      
      private var petInfoObj:Object;
      
      public function lamuGameDate()
      {
         super();
         owner = this;
         BC.addEvent(this,GV.onlineSocket,"removeMapEvent",this.removeEventHandler);
      }
      
      public static function getInstance() : lamuGameDate
      {
         return Boolean(owner) ? owner : new lamuGameDate();
      }
      
      private function removeEventHandler(evt:*) : void
      {
         BC.removeEvent(this);
      }
      
      public function lamuInfoEvent() : void
      {
         BC.addEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         BC.addEvent(this,GV.onlineSocket,"read_" + 1098,this.data1098Fun);
         ephemeralDataSocket.getObjData(1);
      }
      
      private function data1098Fun(evt:EventTaomee) : void
      {
         var petInfo:petInfoReq = null;
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1098,this.data1098Fun);
         if(evt.EventObj.type == 1)
         {
            if(Boolean(evt.EventObj.data))
            {
               this.lamuObj = evt.EventObj.data;
            }
            else
            {
               BC.addEvent(this,GV.onlineSocket,petInfoRes.GET_PETINFO_SUCC,this.getPetInfo);
               petInfo = new petInfoReq();
               petInfo.sendInfoReq(LocalUserInfo.getUserID(),0,1);
               petInfo = null;
            }
         }
         else
         {
            BC.addEvent(this,GV.onlineSocket,petInfoRes.GET_PETINFO_SUCC,this.getPetInfo);
            petInfo = new petInfoReq();
            petInfo.sendInfoReq(LocalUserInfo.getUserID(),0,1);
            petInfo = null;
         }
      }
      
      private function error_cmd0Fun(evt:Event) : void
      {
         BC.removeEvent(this,GV.onlineSocket,"ERROR_CMD_-12621",this.error_cmd0Fun);
         BC.removeEvent(this,GV.onlineSocket,"read_" + 1098,this.data1098Fun);
         BC.addEvent(this,GV.onlineSocket,petInfoRes.GET_PETINFO_SUCC,this.getPetInfo);
         var petInfo:petInfoReq = new petInfoReq();
         petInfo.sendInfoReq(LocalUserInfo.getUserID(),0,1);
         petInfo = null;
      }
      
      private function getPetInfo(evt:EventTaomee) : void
      {
         var obj:Object = null;
         BC.removeEvent(this,GV.onlineSocket,petInfoRes.GET_PETINFO_SUCC,this.getPetInfo);
         this.petInfoObj = evt.EventObj;
         var lamuArray:Array = this.petInfoObj.arr;
         lamuArray = lamuArray.sortOn("SpriteID",16);
         for(var i:uint = 0; i < lamuArray.length; i++)
         {
            obj = new Object();
            this.lamuObj[lamuArray[i].SpriteID] = [obj.flag1,obj.flag2,obj.flag3];
         }
         ephemeralDataSocket.setObjData(1,this.lamuObj);
      }
      
      public function set lamuInfo(b:Object) : void
      {
         this.lamuObj = b;
      }
      
      public function get lamuInfo() : Object
      {
         return this.lamuObj;
      }
   }
}

