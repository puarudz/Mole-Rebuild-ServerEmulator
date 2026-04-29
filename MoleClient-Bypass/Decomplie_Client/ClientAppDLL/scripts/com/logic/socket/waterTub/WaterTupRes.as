package com.logic.socket.waterTub
{
   import com.event.EventTaomee;
   
   public class WaterTupRes
   {
      
      public static const WATERTUB:String = "watertub";
      
      public function WaterTupRes()
      {
         super();
      }
      
      public static function waterTub() : void
      {
         var itemObj:Object = new Object();
         itemObj.OtherID = GV.onlineSocket.readUnsignedInt();
         itemObj.ItemID = GV.onlineSocket.readUnsignedInt();
         itemObj.UserID = 0;
         itemObj.FlashTag = 0;
         itemObj.ChangeID = 0;
         GV.onlineSocket.dispatchEvent(new EventTaomee(WATERTUB,itemObj));
      }
      
      public static function res_canglePumpkins() : void
      {
         var itemObj:Object = new Object();
         itemObj.Count = GV.onlineSocket.readUnsignedInt();
         itemObj.ItemID = 10002;
         itemObj.UserID = 0;
         itemObj.FlashTag = 0;
         itemObj.ChangeID = 0;
         for(var i:int = 0; i < itemObj.Count; i++)
         {
            itemObj.OtherID = GV.onlineSocket.readUnsignedInt();
            GV.onlineSocket.dispatchEvent(new EventTaomee(WATERTUB,itemObj));
         }
      }
      
      public static function res_canglePumpkin() : void
      {
         var itemObj:Object = new Object();
         itemObj.Count = GV.onlineSocket.readUnsignedInt();
         itemObj.ItemID = 19001;
         itemObj.UserID = 0;
         itemObj.FlashTag = 0;
         itemObj.ChangeID = 0;
         for(var i:int = 0; i < itemObj.Count; i++)
         {
            itemObj.OtherID = GV.onlineSocket.readUnsignedInt();
            GV.onlineSocket.dispatchEvent(new EventTaomee(WATERTUB,itemObj));
         }
      }
   }
}

