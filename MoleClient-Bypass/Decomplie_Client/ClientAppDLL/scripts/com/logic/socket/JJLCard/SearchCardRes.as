package com.logic.socket.JJLCard
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class SearchCardRes extends Sprite
   {
      
      public static var BACK_JJL_GET:String = "search_jjl_users";
      
      public function SearchCardRes()
      {
         super();
      }
      
      public function backFun() : void
      {
         var i:uint = 0;
         var objs:Object = null;
         var Info_arr:Array = [];
         var count:uint = GV.onlineSocket.readUnsignedInt();
         if(count > 0)
         {
            for(i = 0; i < count; i++)
            {
               objs = new Object();
               objs.ID = GV.onlineSocket.readUnsignedInt();
               objs.Uid_nick = GV.onlineSocket.readUTFBytes(16);
               objs.Color = GV.onlineSocket.readUnsignedInt();
               objs.Is_vip = GV.onlineSocket.readByte();
               if(objs.Is_vip == 0)
               {
                  objs.Is_vip = false;
               }
               else
               {
                  objs.Is_vip = true;
               }
               objs.Time = GV.onlineSocket.readUnsignedInt();
               Info_arr.push(objs);
            }
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(BACK_JJL_GET,{"arr":Info_arr}));
      }
   }
}

