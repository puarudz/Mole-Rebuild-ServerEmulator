package com.logic.socket.petSocket.keepPet
{
   import com.event.EventTaomee;
   
   public class petBackKeepRes
   {
      
      public static var PET_BACK_SUCC:String = "PET_BACK_SUCC";
      
      public function petBackKeepRes()
      {
         super();
      }
      
      public function parseBA() : void
      {
         var obj:Object = null;
         var Info:Object = new Object();
         Info.arr = new Array();
         Info.count = GV.onlineSocket.readUnsignedInt();
         for(var i:uint = 0; i < Info.count; i++)
         {
            obj = new Object();
            obj.kind = GV.onlineSocket.readUnsignedInt();
            obj.num = GV.onlineSocket.readUnsignedInt();
            Info.arr.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(PET_BACK_SUCC,Info));
      }
   }
}

