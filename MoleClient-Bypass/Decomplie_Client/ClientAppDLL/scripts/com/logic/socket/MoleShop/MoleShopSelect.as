package com.logic.socket.MoleShop
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   
   public class MoleShopSelect
   {
      
      public function MoleShopSelect()
      {
         super();
      }
      
      public static function selectDou() : void
      {
         MsgHead.Command = 2032;
         GF.writeHead();
      }
      
      public static function res_selectDou() : void
      {
         var obj:Object = new Object();
         obj.count = GV.onlineSocket.readUnsignedInt() / 100;
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2032,obj));
      }
      
      public static function addScore() : void
      {
         MsgHead.Command = 2040;
         GF.writeHead();
      }
      
      public static function res_addScore() : void
      {
         var obj:Object = new Object();
         obj.loginCount = GV.onlineSocket.readUnsignedInt();
         obj.score = GV.onlineSocket.readUnsignedInt();
         obj.nextScore = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 2040,obj));
      }
   }
}

