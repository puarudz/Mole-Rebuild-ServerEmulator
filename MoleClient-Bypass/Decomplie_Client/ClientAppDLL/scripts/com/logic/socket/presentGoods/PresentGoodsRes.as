package com.logic.socket.presentGoods
{
   import com.event.EventTaomee;
   import flash.events.EventDispatcher;
   
   public class PresentGoodsRes extends EventDispatcher
   {
      
      public static var PRESENT_GOODS_SUCC:String = "PRESENT_GOODS_SUCC";
      
      public static var PRESENT_FRIEND_GOODS_SUCC:String = "PRESENT_FRIEND_GOODS_SUCC";
      
      public static var TWELVE_HAT_SUCC:String = "TWELVE_HAT_SUCC";
      
      public function PresentGoodsRes()
      {
         super();
      }
      
      public static function GetInfo() : void
      {
         var obj:Object = new Object();
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         obj.Flag = GV.onlineSocket.readUnsignedInt();
         obj.count = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(PRESENT_GOODS_SUCC,obj));
      }
      
      public static function Gethat() : void
      {
         var obj:Object = new Object();
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(TWELVE_HAT_SUCC,obj));
      }
      
      public static function PresentSucc() : void
      {
         var obj:Object = new Object();
         obj.ItemID = GV.onlineSocket.readUnsignedInt();
         obj.FriendID = GV.onlineSocket.readUnsignedInt();
         obj.getItemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee(PRESENT_FRIEND_GOODS_SUCC,obj));
      }
   }
}

