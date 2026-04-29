package com.logic.socket.moleshow
{
   import com.common.msgHead.MsgHead;
   import com.event.EventTaomee;
   
   public class MoleShow
   {
      
      public function MoleShow()
      {
         super();
      }
      
      public static function getScore() : void
      {
         MsgHead.Command = 1932;
         GF.writeHead();
      }
      
      public static function res_getScore() : void
      {
         var obj:Object = new Object();
         obj.socre0 = GV.onlineSocket.readUnsignedInt();
         obj.socre1 = GV.onlineSocket.readUnsignedInt();
         obj.socre2 = GV.onlineSocket.readUnsignedInt();
         obj.itemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1932,obj));
      }
      
      public static function getOnTime() : void
      {
         MsgHead.Command = 1936;
         GF.writeHead();
      }
      
      public static function res_getOnTime() : void
      {
         var obj:Object = new Object();
         obj.onTime = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1936,obj));
      }
      
      public static function res_OnTime() : void
      {
         var obj:Object = new Object();
         obj.onTime = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1935,obj));
      }
      
      public static function res_Over() : void
      {
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1949));
      }
      
      public static function getExp() : void
      {
         MsgHead.Command = 1950;
         GF.writeHead();
      }
      
      public static function res_getExp() : void
      {
         var obj:Object = new Object();
         obj.lvl = GV.onlineSocket.readUnsignedInt();
         obj.restExp = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1950,obj));
      }
      
      public static function res_lvlup() : void
      {
         var obj:Object = new Object();
         obj.lvl = GV.onlineSocket.readUnsignedInt();
         obj.itemID = GV.onlineSocket.readUnsignedInt();
         GV.onlineSocket.dispatchEvent(new EventTaomee("read_" + 1951,obj));
      }
   }
}

