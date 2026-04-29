package com.logic.socket.qqb
{
   import com.event.EventTaomee;
   
   public class QQBResult
   {
      
      public static const QQB_STATUS:String = "qqbStatus";
      
      public static const SOME_ONE_JOIN:String = "someOneJoin";
      
      public static const SOME_ONE_MOVE:String = "someOneMove";
      
      public function QQBResult()
      {
         super();
      }
      
      public static function qqbStatus() : void
      {
         var obj:Object = null;
         var cnt:int = GV.onlineSocket.readByte();
         var array:Array = [];
         for(var i:int = 0; i < cnt; i++)
         {
            obj = [];
            obj.userID = GV.onlineSocket.readInt();
            obj.posX = GV.onlineSocket.readShort();
            obj.posY = GV.onlineSocket.readShort();
            obj.dir = GV.onlineSocket.readByte();
            array.push(obj);
         }
         GV.onlineSocket.dispatchEvent(new EventTaomee(QQB_STATUS,array));
      }
      
      public static function someOneJoin() : void
      {
         var obj:Object = {};
         obj.userID = GV.onlineSocket.readInt();
         obj.PosX = GV.onlineSocket.readShort();
         GV.onlineSocket.dispatchEvent(new EventTaomee(SOME_ONE_JOIN,obj));
      }
      
      public static function someOneMove() : void
      {
         var obj:Object = {};
         obj.userID = GV.onlineSocket.readInt();
         obj.PosX = GV.onlineSocket.readShort();
         obj.PosY = GV.onlineSocket.readShort();
         obj.DIR = GV.onlineSocket.readByte();
         GV.onlineSocket.dispatchEvent(new EventTaomee(SOME_ONE_MOVE,obj));
      }
   }
}

