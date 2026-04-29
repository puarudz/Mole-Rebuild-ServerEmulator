package com.logic.socket.getMapheat
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class getMapheatRes extends EventDispatcher
   {
      
      public static var GETMAP_HEAT:String = "getmap_heat";
      
      public function getMapheatRes()
      {
         super();
      }
      
      public function doAction() : void
      {
         var mapObj:Object = null;
         var mapCount:uint = GV.onlineSocket.readUnsignedInt();
         var mapArray:Array = new Array();
         for(var i:int = 0; i < mapCount; i++)
         {
            mapObj = new Object();
            mapObj.mapID = GV.onlineSocket.readUnsignedInt();
            mapObj.mapUser = GV.onlineSocket.readUnsignedInt();
            mapArray.push(mapObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETMAP_HEAT,mapArray));
      }
   }
}

