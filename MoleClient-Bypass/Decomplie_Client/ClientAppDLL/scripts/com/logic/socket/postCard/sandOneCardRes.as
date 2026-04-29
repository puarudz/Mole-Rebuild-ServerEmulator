package com.logic.socket.postCard
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class sandOneCardRes extends EventDispatcher
   {
      
      public static var SANDONECARD_INFO:String = "sand_onecard";
      
      public function sandOneCardRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var ID:uint = 0;
         var i:uint = 0;
         var failID:uint = 0;
         var target_obj:Object = new Object();
         target_obj.FailCnt = GV.onlineSocket.readUnsignedByte();
         target_obj.Arr = new Array();
         if(target_obj.FailCnt == 0)
         {
            ID = 0;
            target_obj.Arr.push(ID);
         }
         else
         {
            for(i = 0; i < target_obj.FailCnt; i++)
            {
               failID = uint(GV.onlineSocket.readUnsignedInt());
               target_obj.Arr.push(failID);
            }
         }
         var obj:Object = {"info":target_obj};
         GV.onlineSocket.dispatchEvent(new EventTaomee(SANDONECARD_INFO,obj));
      }
   }
}

