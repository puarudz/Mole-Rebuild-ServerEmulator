package com.logic.socket.JJLCard
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class GetJJLCardRes extends Sprite
   {
      
      public static var BACK_JJL_GET:String = "getjjl_back";
      
      public function GetJJLCardRes()
      {
         super();
      }
      
      public function backFun() : void
      {
         var i:uint = 0;
         var obj:Object = null;
         var Info_arr:Array = [];
         var count:uint = GV.onlineSocket.readUnsignedInt();
         if(count > 0)
         {
            for(i = 0; i < count; i++)
            {
               obj = new Object();
               obj.ID = GV.onlineSocket.readUnsignedInt();
               obj.Num = GV.onlineSocket.readUnsignedInt();
               obj.Flag = GV.onlineSocket.readUnsignedInt();
               obj.WantID = GV.onlineSocket.readUnsignedInt();
               Info_arr.push(obj);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_JJL_GET,{"arr":Info_arr}));
      }
   }
}

