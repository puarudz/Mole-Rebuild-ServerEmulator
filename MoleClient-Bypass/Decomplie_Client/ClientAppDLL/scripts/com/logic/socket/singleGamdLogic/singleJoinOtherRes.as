package com.logic.socket.singleGamdLogic
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class singleJoinOtherRes extends EventDispatcher
   {
      
      public static var SINGLEOTHER_INFO:String = "singleOther_info";
      
      public function singleJoinOtherRes()
      {
         super();
      }
      
      public function doAction() : void
      {
         var gameObj:Object = null;
         var infoArray:Array = new Array();
         var gameCount:int = int(GV.onlineSocket.readUnsignedShort());
         for(var i:int = 0; i < gameCount; i++)
         {
            gameObj = new Object();
            gameObj.Userid = GV.onlineSocket.readUnsignedInt();
            gameObj.Itemid = GV.onlineSocket.readByte();
            gameObj.Status = new ByteArray();
            GV.onlineSocket.readBytes(gameObj.Status,0,16);
            infoArray.push(gameObj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(SINGLEOTHER_INFO,{"arr":infoArray}));
      }
   }
}

