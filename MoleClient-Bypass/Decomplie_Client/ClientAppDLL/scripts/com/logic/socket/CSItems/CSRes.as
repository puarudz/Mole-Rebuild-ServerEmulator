package com.logic.socket.CSItems
{
   import com.event.EventTaomee;
   import flash.display.Sprite;
   
   public class CSRes extends Sprite
   {
      
      public static var GETITEM_OK:String = "get_item_ok";
      
      public function CSRes()
      {
         super();
      }
      
      public function getBackFun() : void
      {
         var i:uint = 0;
         var objb:Object = null;
         var obj:Object = new Object();
         obj.Cnt = GV.onlineSocket.readUnsignedInt();
         var Arr:Array = [];
         if(obj.Cnt != 0)
         {
            for(i = 0; i < obj.Cnt; i++)
            {
               objb = new Object();
               objb.ItemID = GV.onlineSocket.readUnsignedInt();
               objb.Cnt = GV.onlineSocket.readUnsignedInt();
               Arr.push(objb);
            }
            obj.Arr = Arr;
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(GETITEM_OK,obj));
      }
   }
}

