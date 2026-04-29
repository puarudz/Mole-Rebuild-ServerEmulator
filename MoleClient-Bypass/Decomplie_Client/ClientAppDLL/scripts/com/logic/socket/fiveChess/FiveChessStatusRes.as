package com.logic.socket.fiveChess
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class FiveChessStatusRes extends EventDispatcher
   {
      
      public static var SEACE_STATUS:String = "seace_status";
      
      public function FiveChessStatusRes()
      {
         super();
      }
      
      public function fiveChessStatus() : void
      {
         var fiveObj:Object = null;
         var fiveChessStatusObj:Object = new Object();
         var fiveChessArr:Array = new Array();
         fiveChessStatusObj.Count = GV.onlineSocket.readUnsignedByte();
         for(var i:int = 0; i < fiveChessStatusObj.Count; i++)
         {
            fiveObj = new Object();
            fiveObj.Itemid = GV.onlineSocket.readUnsignedByte();
            fiveObj.started = GV.onlineSocket.readUnsignedByte();
            fiveChessArr.push(fiveObj);
         }
         fiveChessStatusObj.senceArr = fiveChessArr;
         GV.onlineSocket.dispatchEvent(new EventTaomee(SEACE_STATUS,fiveChessStatusObj));
      }
   }
}

